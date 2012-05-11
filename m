Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946349Ab2EKWYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:24:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946204Ab2EKWYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:24:38 -0400
Date: Fri, 11 May 2012 15:24:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH v3] leds: add LM3533 LED driver
Message-Id: <20120511152436.5272ff1f.akpm@linux-foundation.org>
In-Reply-To: <20120511095411.GC29437@localhost>
References: <1336040799-18433-4-git-send-email-jhovold@gmail.com>
	<1336674425-24145-1-git-send-email-jhovold@gmail.com>
	<20120510114817.28b24168.akpm@linux-foundation.org>
	<20120511095411.GC29437@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 11:54:11 +0200
Johan Hovold <jhovold@gmail.com> wrote:

> On Thu, May 10, 2012 at 11:48:17AM -0700, Andrew Morton wrote:
> > On Thu, 10 May 2012 20:27:05 +0200
> > Johan Hovold <jhovold@gmail.com> wrote:
> > 
> > > Add sub-driver for the LEDs on National Semiconductor / TI LM3533
> > > lighting power chips.
> > > 
> > > The chip provides 256 brightness levels, hardware accelerated blinking
> > > as well as ambient-light-sensor and pwm input control.
> > > 
> > > ...
> > >
> > > +#define to_lm3533_led(_cdev) \
> > > +	container_of(_cdev, struct lm3533_led, cdev)
> > 
> > Minor thing: container_of() is not fully type-safe: it can be passed
> > the address of any struct which contains a field called cdev and will
> > return a struct lm3533_led* (or something like that - it has holes...).
> > 
> > A way to fix that is to wrap container_of() in a real C function, not a
> > macro:
> > 
> > static inline struct lm3533_led *to_lm3533_led(struct struct led_classdev *cdev)
> > {
> > 	return container_of(_cdev, struct lm3533_led, cdev);
> > }
> > 
> > This has been another episode in the ongoing series "macros are always
> > wrong" :)
> 
> Fair enough. :) Seems like the vast majority of drivers still use
> convenience macros such as the this one for this kind of use (where the
> functions are either passed the class device or it is retrieved through
> device driver data).
> 
> Do you want me to replace the other three instances of container_of
> convenience macros in the iio-subdriver and core (already added to the
> mfd tree) as well?

Well, it does result in better code.  How could I say no? ;)

> > > +static ssize_t store_als(struct device *dev,
> > > +					struct device_attribute *attr,
> > > +					const char *buf, size_t len)
> > > +{
> > > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > > +	struct lm3533_led *led = to_lm3533_led(led_cdev);
> > > +	u8 als;
> > > +	u8 reg;
> > > +	u8 mask;
> > > +	int ret;
> > > +
> > > +	if (kstrtou8(buf, 0, &als))
> > > +		return -EINVAL;
> > > +
> > > +	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
> > > +		return -EINVAL;
> > 
> > The `als != 0' test doesn't do anything, and looks odd.  Is there some
> > magical reason why als==0 would be illegal even if LM3533_ALS_LV_MIN
> > was negative?  If so, it should be documented.
> 
> The non-zero-test is not redundant as 0 is the only valid input outside
> of [LV_MIN,LV_MAX] (in fact, the only three valid values are 0,2 and 3).

ah, OK.  One day I'll get the hang of this C thingy.

> Would you prefer
> 
> 	if ((als < LM3533_ALS_LV_MIN && als != 0) || als > LM3533_ALS_LV_MAX)
> 		return -EINVAL;
> 
> or nested conditionals? Or should I simply add a comment?

A comment would be nice.  That 0 is also permitted is a surprise.
