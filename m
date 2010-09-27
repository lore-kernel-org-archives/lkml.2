Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0I0GUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:20:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40042 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab0I0GUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:20:07 -0400
Date: Mon, 27 Sep 2010 09:18:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20100927061840.GA22913@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1285529740-28232-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 02:35:40PM -0500, Grazvydas Ignotas wrote:
>TWL4030/TPS65950 is a multi-function device with integrated charger,
>which allows charging from AC or USB. This driver enables the
>charger and provides several monitoring functions.
>
>Tested on OMAP3 Pandora board.
>
>Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>---
>This is v3 of BCI charger driver I first sent nearly a year ago [1].
>I've updated it to use the new OTG notifiers for VBUS notifications,
>however it still is not able to determine charge current to use.
>For that reason there is now a temporary module param to enable USB
>charging, until I can figure out how to get that info from the gadget
>stack (hopefully Felipe can help me here).

You need to send USB_EVENT_ENUMERATED from usb_gadget_vbus_draw(), but
wait until the UDC class is finished, then we will have a common
location to do those stuff.

>Besides that it now uses threaded interrupts and makes use of charge
>state change interrupt to notify power supply core.
>
>For this driver to work, twl-core needs to be patched to register
>correct platform device, and twl4030-irq needs to set COR bit
>correctly (will send those patches to mfd).

>+static int __devinit twl4030_bci_probe(struct platform_device *pdev)
>+{
>+       struct twl4030_bci *bci;
>+       int ret;
>+       int reg;
>+
>+       bci = kzalloc(sizeof(*bci), GFP_KERNEL);
>+       if (bci == NULL)
>+               return -ENOMEM;
>+
>+       bci->dev = &pdev->dev;
>+       bci->irq_chg = platform_get_irq(pdev, 0);
>+       bci->irq_bci = platform_get_irq(pdev, 1);
>+
>+       ret = request_threaded_irq(bci->irq_chg, NULL,
>+                       twl4030_charger_interrupt, 0, pdev->name, bci);
>+       if (ret < 0) {
>+               dev_err(&pdev->dev, "could not request irq %d, status %d\n",
>+                       bci->irq_chg, ret);
>+               goto fail_chg_irq;
>+       }
>+
>+       ret = request_threaded_irq(bci->irq_bci, NULL,
>+               twl4030_bci_interrupt, 0, pdev->name, bci);
>+       if (ret < 0) {
>+               dev_err(&pdev->dev, "could not request irq %d, status %d\n",
>+                       bci->irq_bci, ret);
>+               goto fail_bci_irq;
>+       }

you should register the power_supply before enabling the IRQ lines,
otherwise you might call power_supply_changed() to a non-existent
power_supply.

>+       platform_set_drvdata(pdev, bci);
>+
>+       bci->ac.name = "twl4030_ac";
>+       bci->ac.type = POWER_SUPPLY_TYPE_MAINS;
>+       bci->ac.properties = twl4030_charger_props;
>+       bci->ac.num_properties = ARRAY_SIZE(twl4030_charger_props);
>+       bci->ac.get_property = twl4030_bci_get_property;
>+
>+       ret = power_supply_register(&pdev->dev, &bci->ac);
>+       if (ret) {
>+               dev_err(&pdev->dev, "failed to register ac: %d\n", ret);
>+               goto fail_register_ac;
>+       }
>+
>+       bci->usb.name = "twl4030_usb";
>+       bci->usb.type = POWER_SUPPLY_TYPE_USB;
>+       bci->usb.properties = twl4030_charger_props;
>+       bci->usb.num_properties = ARRAY_SIZE(twl4030_charger_props);
>+       bci->usb.get_property = twl4030_bci_get_property;
>+
>+       ret = power_supply_register(&pdev->dev, &bci->usb);
>+       if (ret) {
>+               dev_err(&pdev->dev, "failed to register usb: %d\n", ret);
>+               goto fail_register_usb;
>+       }
>+
>+#ifdef CONFIG_USB_OTG_UTILS
>+       bci->transceiver = otg_get_transceiver();
>+#endif

this driver should actually depend on that. It won't work without access
to the transceiver anyway. Or you add something like:

#ifdef CONFIG_USB_OTG_UTILS
extern struct otg_transceiver *otg_get_transceiver(void);
extern void otg_put_transceiver(struct otg_transceiver *);
#else
static inline struct otg_transceiver *otg_get_transceiver(void)
{ return NULL; }
static inline void otg_put_transceiver(struct otg_transceiver *x)
{ }
#endif

to the otg.h and avoid having to use that ifdef here and on any other
driver. (should be a separate patch though).

>+static struct platform_driver twl4030_bci_driver = {
>+       .probe          = twl4030_bci_probe,

drivers should not reference __init sections anymore. If you make this
statically linked to the kernel, you'll get section mismatches. It's
better to make probe __init remove it from here and call 
platform_driver_probe() from module_init();

>+       .remove         = __devexit_p(twl4030_bci_remove),
>+       .driver         = {
>+               .name   = "twl4030_bci",
>+               .owner  = THIS_MODULE,
>+       },
>+};

-- 
balbi
