Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2APQcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:32:02 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54651 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2APQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:32:00 -0500
Date: Mon, 16 Jan 2012 09:31:54 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Dong Aisheng-B29396 <B29396@freescale.com>
Subject: Re: [PATCH RESEND] gpio: add flags to export GPIOs when requesting
Message-ID: <20120116163154.GF4223@ponder.secretlab.ca>
References: <1323797641-7277-1-git-send-email-w.sang@pengutronix.de>
 <20120106152741.GE2610@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106152741.GE2610@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 04:27:41PM +0100, Wolfram Sang wrote:
> On Tue, Dec 13, 2011 at 06:34:01PM +0100, Wolfram Sang wrote:
> > Introduce new flags to automatically export GPIOs when using the convenience
> > functions gpio_request_one() or gpio_request_array(). This eases support for
> > custom boards where lots of GPIOs need to be exported for customer
> > applications.
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > ---
> > 
> > Based on 3.2-rc5. Previous discussion (with kind of acks) can be found here
> > 
> > http://lkml.org/lkml/2011/11/15/378
> 
> Ping. I am using this patch with v3.2 right now and it is really useful
> (and no build failure this time (I owe you a drink for my last patch!))

Applied, thanks.

g.

> 
> > 
> >  Documentation/gpio.txt |    3 +++
> >  drivers/gpio/gpiolib.c |   12 +++++++++++-
> >  include/linux/gpio.h   |    5 +++++
> >  3 files changed, 19 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> > index 792faa3..9e28c05 100644
> > --- a/Documentation/gpio.txt
> > +++ b/Documentation/gpio.txt
> > @@ -303,6 +303,9 @@ where 'flags' is currently defined to specify the following properties:
> >  	* GPIOF_INIT_LOW	- as output, set initial level to LOW
> >  	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
> >  
> > +	* GPIOF_EXPORT_DIR_FIXED	- export gpio to sysfs, keep direction
> > +	* GPIOF_EXPORT_DIR_CHANGEABLE	- also export, allow changing direction
> > +
> >  since GPIOF_INIT_* are only valid when configured as output, so group valid
> >  combinations as:
> >  
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index a971e3d..65ba047 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1285,8 +1285,18 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
> >  				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
> >  
> >  	if (err)
> > -		gpio_free(gpio);
> > +		goto free_gpio;
> > +
> > +	if (flags & GPIOF_EXPORT) {
> > +		err = gpio_export(gpio, flags & GPIOF_EXPORT_CHANGEABLE);
> > +		if (err)
> > +			goto free_gpio;
> > +	}
> > +
> > +	return 0;
> >  
> > + free_gpio:
> > +	gpio_free(gpio);
> >  	return err;
> >  }
> >  EXPORT_SYMBOL_GPL(gpio_request_one);
> > diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> > index 38ac48b..38afe24 100644
> > --- a/include/linux/gpio.h
> > +++ b/include/linux/gpio.h
> > @@ -14,6 +14,11 @@
> >  #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> >  #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> >  
> > +#define GPIOF_EXPORT		(1 << 2)
> > +#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
> > +#define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
> > +#define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
> > +
> >  /**
> >   * struct gpio - a structure describing a GPIO with configuration
> >   * @gpio:	the GPIO number
> > -- 
> > 1.7.2.5
> > 
> 
> -- 
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |


