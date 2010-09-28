Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab0I1Gfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:35:48 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:46349 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176Ab0I1Gfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:35:46 -0400
Message-ID: <001201cb5ed7$6117cb40$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Mike Frysinger" <vapier@gentoo.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Alek Du" <alek.du@intel.com>, <richard.rojfors@mocean-labs.com>,
        <meego-dev@meego.com>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        "Qi" <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <gregkh@suse.de>, "Yong Y" <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <margie.foster@intel.com>,
        <kok.howg.ewe@intel.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org> <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com> <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com> <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com> <20100928052950.GB5878@sirena.org.uk>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Date: Tue, 28 Sep 2010 15:35:39 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> Your mail client has for some reason chosen to uuencode the attachment
> so it's going to be difficult for most people to read it.

Sorry, I copied to mail body.

static void pch_gpio_setup(struct pch_gpio_chip *chip)
{
    struct gpio_chip *gpio = &chip->gpio;

    gpio->label = dev_name(chip->dev);
    gpio->owner = THIS_MODULE;
    gpio->direction_input = pch_gpio_direction_input;
    gpio->get = pch_gpio_get;
    gpio->direction_output = pch_gpio_direction_output;
    gpio->set = pch_gpio_set;
    gpio->dbg_show = NULL;
    gpio->base = (u32)chip->pch_gpio_base_address;
    gpio->ngpio = 12;
    gpio->can_sleep = 0;
}


static s32 __devinit pch_gpio_probe(struct pci_dev *pdev,
        const struct pci_device_id *id)
{
    s32 ret;
    struct pch_gpio_chip *chip;

    chip = kzalloc(sizeof(struct pch_gpio_chip), GFP_KERNEL);
    if (chip == NULL)
         return -ENOMEM;

    chip->dev = &pdev->dev;

    ret = pci_enable_device(pdev);
    if (ret) {
        dev_err(&pdev->dev, "%s : pci_enable_device FAILED", __func__);
        goto err_pci_enable;
    }

    ret = pci_request_regions(pdev, MODULE_NAME);
    if (ret) {
        dev_err(&pdev->dev, "%s : pci_request_regions FAILED",
            __func__);
        goto err_request_regions;
    }

    chip->pch_gpio_base_address = pci_iomap(pdev, 1, 0);

    if (chip->pch_gpio_base_address == 0) {
        dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
        ret = -ENOMEM;
        goto err_iomap;
    }
    chip->reg = chip->pch_gpio_base_address;

    pci_set_drvdata(pdev, chip);
    pch_gpio_cb_register(pch_gpio_cb, chip);
    chip->pch_gpio_irq = pdev->irq;
    device_set_wakeup_enable(&pdev->dev, 1);

    pch_gpio_setup(chip);
    ret = gpiochip_add(&chip->gpio);
    if (ret) {
        printk(KERN_ERR "PCH gpio: Failed to register GPIO\n");
        goto err_gpiochip_add;
    }

    return 0;

err_gpiochip_add:
    pci_iounmap(pdev, chip->pch_gpio_base_address);

err_iomap:
    pci_release_regions(pdev);

err_request_regions:
    pci_disable_device(pdev);

err_pci_enable:
    kfree(chip);

    return ret;
}

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Mike Frysinger" <vapier@gentoo.org>; "Andrew Morton" <akpm@linux-foundation.org>; "Samuel Ortiz"
<sameo@linux.intel.com>; "Randy Dunlap" <randy.dunlap@oracle.com>; "Alek Du" <alek.du@intel.com>;
<richard.rojfors@mocean-labs.com>; <meego-dev@meego.com>; "ML linux-kernel" <linux-kernel@vger.kernel.org>; "Qi"
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <gregkh@suse.de>; "Yong Y" <yong.y.wang@intel.com>; "Tomoya
MORINAGA" <morinaga526@dsn.okisemi.com>; <joel.clark@intel.com>; <margie.foster@intel.com>; <kok.howg.ewe@intel.com>
Sent: Tuesday, September 28, 2010 2:29 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35


> On Tue, Sep 28, 2010 at 02:25:36PM +0900, Masayuki Ohtake wrote:
>
> > > find out what range of GPIO numbers your driver is using and use those
> > > instead of "1"
> > I have attached a part of our source file.
>
> > Since I set "ngpio=12",
> > I guess 0-11 can be used, thus, "echo 1 > export" should be success too.
> > Is this true ?
>
> > begin 666 pch_gpio.c
> > M<W1A=&EC('9O:60@<&-H7V=P:6]?<V5T=7 H<W1R=6-T('!C:%]G<&EO7V-H
> > M:7 @*F-H:7 I#0I[#0H)<W1R=6-T(&=P:6]?8VAI<" J9W!I;R ]("9C:&EP
>
> Your mail client has for some reason chosen to uuencode the attachment
> so it's going to be difficult for most people to read it.  If you have
> debugfs enabled and mounted you can see the current GPIO banks in the
> file 'gpio' under debugfs.
>


