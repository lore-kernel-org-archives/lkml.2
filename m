Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0ERL1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:27:35 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:51050 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756616Ab0ERL1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:27:30 -0400
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] mc13783: add LED support
Date: Tue, 18 May 2010 13:27:29 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.13-desktop-1mnb; KDE/4.3.5; x86_64; ; )
Cc: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
       "maramaopercheseimorto@gmail.com" <maramaopercheseimorto@gmail.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       Longchamp Valentin <valentin.longchamp@epfl.ch>,
       "rpurdie@linux.intel.com" <rpurdie@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch> <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch> <20100517190242.GA17604@pengutronix.de>
In-Reply-To: <20100517190242.GA17604@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005181327.29529.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi, 17 mai 2010 21.02:42, Uwe Kleine-König a écrit :
> Hi Philippe,
> 
> On Mon, May 17, 2010 at 06:40:22PM +0200, Philippe Rétornaz wrote:
> > This adds basic led support for Freescale MC13783 PMIC.
> >
> > Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
> > ---
> >  drivers/leds/Kconfig        |    7 +
> >  drivers/leds/Makefile       |    1 +
> >  drivers/leds/leds-mc13783.c |  375
> > +++++++++++++++++++++++++++++++++++++++++++ drivers/mfd/mc13783-core.c  |
> >    4 +
> >  include/linux/mfd/mc13783.h |   68 ++++++++
> >  5 files changed, 455 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/leds/leds-mc13783.c
> >
> > +++ b/drivers/leds/leds-mc13783.c
> > @@ -0,0 +1,375 @@
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/leds.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/mfd/mc13783.h>
> > +#include <linux/mfd/mc13783-private.h>
> 
> please don't use mc13783-private.h.

I use some register macro defined in mc13783-private.h
Do you perfer I redefine them inside leds-mc13783.c ? 


> > +static void mc13783_led_set(struct led_classdev *led_cdev,
> > +                        enum led_brightness value)
> > +{
> > +     struct mc13783_led *led;
> > +
> > +     led = container_of(led_cdev, struct mc13783_led, cdev);
> > +     led->new_brightness = value;
> > +     schedule_work(&led->work);
> > +}
> 
> I wonder why you don't set the registers directly here, but use a work
> struct instead.

As Marc explained, it can be called from interrupt context.

> > +#define BL_C_MASK 0x7
> > +#define MD_C_SHIFT 0
> > +#define AD_C_SHIFT 3
> > +#define KP_C_SHIFT 6
> > +#define TC_C_MASK 0x3
[...]
> > +#define TC1HALF_BIT 18
> > +#define SLEWLIM_BIT 23
> > +#define TRIODE_TC_BIT 23
> > +#define TRIODE_MD_BIT 7
> > +#define TRIODE_AD_BIT 8
> > +#define TRIODE_KP_BIT 9
> > +#define BOOST_BIT 10
> > +#define PERIOD_MASK 0x3
> > +#define PERIOD_SHIFT 21
> > +#define ABMODE_MASK 0x7
> > +#define ABMODE_SHIFT 11
> > +#define ABREF_MASK 0x3
> > +#define ABREF_SHIFT 14
> 
> Why not group the defines at the beginning of the file and properly
> namespace them?

Ok, I will define it with the register definition I must add to remove mc13783-
private.h inclusion.

[...]
> > +     ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
> > +     if (ret)
> > +             goto out;
> > +
> > +
> 
> only one empty line please.

Ok.

[...]
> > +err_register:
> > +     if (i > 0) {
> > +             for (i = i - 1; i >= 0; i--) {
> > +                     led_classdev_unregister(&led[i].cdev);
> > +                     cancel_work_sync(&led[i].work);
> > +             }
> > +     }
> 
> the if isn't necessary, just doing for(...) is enough.

You're right i is signed. I will remove it.

> > +MODULE_DESCRIPTION("LEDs driver for Freescale MC13783 PMIC");
> > +MODULE_AUTHOR("Philipe Rétornaz <philippe.retorna@epfl.ch>");
> 
> Philippe with two p?  I'm not sure if non-ASCII chars are allowed here.

What a shame, I'm not able to write my own name ! 

Thank you for the review, I will post a v2 patch with the appropriates fixes 
soon.

BTW, should I split this patch in 2 ? One for the mfd device, and one which 
adds the led driver ? 
Who will merge this ?

Regards,

Philippe
