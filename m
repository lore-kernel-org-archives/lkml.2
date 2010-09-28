Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0I1Ozt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:55:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34673 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0I1Ozs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nIVxvWYayeSlwDyRlfjZ+sCM4zNntsY0lCyR1hMHHzLPQkObaHFXCYbOn+QbUkYxxO
         CQatS5bKS0Ubrh9rU/b+pMWa/089HFNbONjJAohyfVOZ5vxOA9KnDRxEejPXYbGPdY26
         Ga6jx1IyAEgrE01YXSz29NIaMnMS045NP6zSk=
MIME-Version: 1.0
In-Reply-To: <4CA1B775.9020809@dsn.okisemi.com>
References: <4CA1B775.9020809@dsn.okisemi.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 28 Sep 2010 10:55:26 -0400
X-Google-Sender-Auth: 4TYTVbUOQ8EFxXWQ4r_qR5j2DmM
Message-ID: <AANLkTikVtxYiSyqn-DbNsjukf+am9N2xU+xzWLFFhC0Y@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_GPIO driver to 2.6.35
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        =?UTF-8?Q?Richard_R=C3=B6jfors?= <richard.rojfors@mocean-labs.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, margie.foster@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 05:37, Masayuki Ohtak wrote:
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
>
>  comment "I2C GPIO expanders:"
>
> +config PCH_GPIO
> +       tristate "PCH GPIO"
> +       depends on PCI

this is connected to a PCI bus, not I2C, so it shouldnt be under the
I2C comment.  move it to a diff place in the file.

> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_GPIO_WM8994)     += wm8994-gpio.o
>  obj-$(CONFIG_GPIO_SCH)         += sch_gpio.o
>  obj-$(CONFIG_GPIO_RDC321X)     += rdc321x-gpio.o
>  obj-$(CONFIG_GPIO_JANZ_TTL)    += janz-ttl.o
> +obj-$(CONFIG_PCH_GPIO) += pch_gpio.o

there is a clear standard of naming things CONFIG_GPIO_XXX, so i'd
change your CONFIG_PCH_GPIO to CONFIG_GPIO_PCH

> +#include <linux/cdev.h>

you dont actually use cdev anywhere.  punt the header.

> +#define MODULE_NAME "pch_gpio"

KBUILD_MODNAME already exists

> +#define PCI_DEVICE_ID_PCH_GPIO 0x8803

considering you use this define in one place, i dont see why you need
a define at all.  just put the id in the one structure.

> +#ifdef CONFIG_PM
> +static s32 pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
> +static s32 pch_gpio_resume(struct pci_dev *pdev)

suspend/resume funcs return "int", not "s32"

> +static struct pci_device_id pch_gpio_pcidev_id[] = {

should be const

> +static s32 __devinit pch_gpio_probe(struct pci_dev *pdev,
> +                                   const struct pci_device_id *id)

return value is "int", not "s32"

> +       chip = kzalloc(sizeof(struct pch_gpio_chip), GFP_KERNEL);

sizeof(*chip)


> +               printk(KERN_ERR "PCH gpio: Failed to register GPIO\n");

use dev_err()

> +static s32 __init pch_gpio_pci_init(void)
> +{
> +       return pci_register_driver(&pch_gpio_driver);
> +}
> +module_init(pch_gpio_pci_init);

module_init funcs return "int", not "s32"
-mike
