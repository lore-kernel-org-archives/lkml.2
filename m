Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2ENK0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:26:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54218 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2ENK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:26:00 -0400
Date: Mon, 14 May 2012 12:25:57 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH v3] leds: add LM3533 LED driver
Message-ID: <20120514102556.GA15632@localhost>
References: <1336040799-18433-4-git-send-email-jhovold@gmail.com>
 <1336674425-24145-1-git-send-email-jhovold@gmail.com>
 <20120510114817.28b24168.akpm@linux-foundation.org>
 <20120511095411.GC29437@localhost>
 <20120511152436.5272ff1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511152436.5272ff1f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 03:24:36PM -0700, Andrew Morton wrote:
> On Fri, 11 May 2012 11:54:11 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> > On Thu, May 10, 2012 at 11:48:17AM -0700, Andrew Morton wrote:
> > > On Thu, 10 May 2012 20:27:05 +0200
> > > Johan Hovold <jhovold@gmail.com> wrote:
> > > 
> > > > Add sub-driver for the LEDs on National Semiconductor / TI LM3533
> > > > lighting power chips.
> > > > 
> > > > The chip provides 256 brightness levels, hardware accelerated blinking
> > > > as well as ambient-light-sensor and pwm input control.

[...]

> > > > +static ssize_t store_als(struct device *dev,
> > > > +					struct device_attribute *attr,
> > > > +					const char *buf, size_t len)
> > > > +{
> > > > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > > > +	struct lm3533_led *led = to_lm3533_led(led_cdev);
> > > > +	u8 als;
> > > > +	u8 reg;
> > > > +	u8 mask;
> > > > +	int ret;
> > > > +
> > > > +	if (kstrtou8(buf, 0, &als))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
> > > > +		return -EINVAL;
> > > 
> > > The `als != 0' test doesn't do anything, and looks odd.  Is there some
> > > magical reason why als==0 would be illegal even if LM3533_ALS_LV_MIN
> > > was negative?  If so, it should be documented.
> > 
> > The non-zero-test is not redundant as 0 is the only valid input outside
> > of [LV_MIN,LV_MAX] (in fact, the only three valid values are 0,2 and 3).
> 
> ah, OK.  One day I'll get the hang of this C thingy.
> 
> > Would you prefer
> > 
> > 	if ((als < LM3533_ALS_LV_MIN && als != 0) || als > LM3533_ALS_LV_MAX)
> > 		return -EINVAL;
> > 
> > or nested conditionals? Or should I simply add a comment?
> 
> A comment would be nice.  That 0 is also permitted is a surprise.

Actually, there is a comment already documenting the valid values and
it's placed above the show function immediately above the store one:

/*
 * ALS-control setting:
 *
 *   0 - ALS disabled
 *   2 - ALS-mapper 2
 *   3 - ALS-mapper 3
 */
static ssize_t show_als(struct device *dev,
...
static ssize_t store_als(struct device *dev,


Thanks,
Johan
