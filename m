Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1EJGpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:45:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43189 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1EJGpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:45:22 -0400
Date: Tue, 10 May 2011 08:45:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110510064504.GC29089@pengutronix.de>
References: <1302097097.22904.41.camel@rex>
 <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110509150254.e7da059f.akpm@linux-foundation.org>
 <20110509221719.GE16919@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110509221719.GE16919@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:17:19PM +0100, Russell King - ARM Linux wrote:
> On Mon, May 09, 2011 at 03:02:54PM -0700, Andrew Morton wrote:
> > On Mon, 11 Apr 2011 22:35:57 +0200
> > Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> > > +#if defined(CONFIG_LED_REGISTER_GPIO)
> > > +struct platform_device *__init gpio_led_register_device(
> > > +		int id, const struct gpio_led_platform_data *pdata)
> > > +{
> > > +	struct platform_device *ret;
> > > +	struct gpio_led_platform_data _pdata = *pdata;
> > > +
> > > +	_pdata.leds = kmemdup(pdata->leds,
> > > +			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
> > > +	if (!_pdata.leds)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	ret = platform_device_register_resndata(NULL, "leds-gpio", id,
> > > +			NULL, 0, &_pdata, sizeof(_pdata));
> > > +	if (IS_ERR(ret))
> > > +		kfree(_pdata.leds);
> > > +
> > > +	return ret;
> > > +}
> > > +#endif
> ...
> > The comment doesn't document return values.
> 
> Two further comments.
> 
> 1. Why is this .c file always built, but _all_ the containing code is
> wrapped up in an ifdef?  It seems a waste of resources to compile a .c
> file with all code #ifdef'd out.
This was done because I thought that the .c file could contain other
registration routines later. Richard requested to use

	obj-$(CONFIG_LED_REGISTER_GPIO) += ...

then the #ifdef can go away, too. (@Andrew: Richard's ack was only for a
patch that used that. You took the patch anyhow and added his ack.)

> 2. What is the point of returning the platform device structure?  You've
> already registered it, so you must _not_ modify any data in that structure
> which may be used by the driver.  The only thing which you can safely do
> with it is unregister it.
pdev->device can be used as parent for another device. (OK, probably not
an led device. The origin of this function is the imx device
registration stuff, and all these functions return a platform device).
The other case where I needed to have the device created was to fill a
struct regulator_consumer_supply, but nowadays this is done using just
the name.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
