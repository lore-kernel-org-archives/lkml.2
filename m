Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2EaLkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:40:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55409 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2EaLkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <1338393307-20470-1-git-send-email-sjhill@mips.com>
References: <1338393307-20470-1-git-send-email-sjhill@mips.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 31 May 2012 19:39:52 +0800
X-Google-Sender-Auth: VgY97vQZ_p0EVpfjNuAbi6btFhw
Message-ID: <CAK5ve-LKOQGrRKh_WmPNJp7G1hiywd4uixSAWTcVVOd1ZH0zGg@mail.gmail.com>
Subject: Re: [PATCH] leds: Support for MIPS SEAD-3 controlled LEDs
To: "Steven J. Hill" <sjhill@mips.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>, Chris Dearman <chris@mips.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:55 PM, Steven J. Hill <sjhill@mips.com> wrote:
> From: "Steven J. Hill" <sjhill@mips.com>
>
> Add driver for the two LED banks on the MIPS SEAD-3 platform.
>

Overall this LED driver looks very specific to MIPS board SEAD-3 and
the code is not going to share with other platform. How about just
adding this driver in your MIPS machine code, like I did in ARM LED
consolidation work here:

http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=commitdiff;h=a1bebaca84560c691b7ca6c86df541f36ff87432

> Signed-off-by: Chris Dearman <chris@mips.com>
> Signed-off-by: Steven J. Hill <sjhill@mips.com>
> ---
>  drivers/leds/Kconfig      |   13 +++++
>  drivers/leds/Makefile     |    1 +
>  drivers/leds/leds-sead3.c |  125 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 139 insertions(+)
>  create mode 100644 drivers/leds/leds-sead3.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ff4b8cf..3407020 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -401,6 +401,19 @@ config LEDS_OT200
>          This option enables support for the LEDs on the Bachmann OT200.
>          Say Y to enable LEDs on the Bachmann OT200.
>
> +config LEDS_SEAD3
> +       tristate "LED support for MIPS SEAD-3"
> +       depends on LEDS_CLASS && MIPS_SEAD3
> +       help
> +         This option enables support for the two LED banks on the MIPS
> +         SEAD-3 platform. They are accessible via the sysfs interface:
> +
> +            /sys/class/leds/sead3::pled/brightness
> +            /sys/class/leds/sead3::fled/brightness
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called leds-sead3.
> +
>  config LEDS_TRIGGERS
>        bool "LED Trigger support"
>        depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 890481c..2003fee 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_LEDS_NETXBIG)            += leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)               += leds-asic3.o
>  obj-$(CONFIG_LEDS_RENESAS_TPU)         += leds-renesas-tpu.o
>  obj-$(CONFIG_LEDS_MAX8997)             += leds-max8997.o
> +obj-$(CONFIG_LEDS_SEAD3)               += leds-sead3.o
>
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> diff --git a/drivers/leds/leds-sead3.c b/drivers/leds/leds-sead3.c
> new file mode 100644
> index 0000000..9d3d437
> --- /dev/null
> +++ b/drivers/leds/leds-sead3.c
> @@ -0,0 +1,125 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2010-2012  MIPS Technologies, Inc.
> + *
> + * Based on leds-wrap.c
> + * Copyright (C) 2006 Kristian Kielhofner <kris@krisk.org>
> + */
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/leds.h>
> +#include <linux/platform_device.h>
> +
> +#define DRVNAME        "sead3-led"
> +
> +static struct platform_device *pdev;
> +
> +static void sead3_pled_set(struct led_classdev *led_cdev,
> +               enum led_brightness value)
> +{
> +       writel(value, (void __iomem *)0xbf000210);

No idea for this address, is that a register for brightness? It's
better to give a meaningful name.
> +}
> +
> +static void sead3_fled_set(struct led_classdev *led_cdev,
> +               enum led_brightness value)
> +{
> +       writel(value, (void __iomem *)0xbf000218);
> +}
> +
> +static struct led_classdev sead3_pled = {
> +       .name           = "sead3::pled",
> +       .brightness_set = sead3_pled_set,

If you need to support suspend/resume, just add this
.flags = LED_CORE_SUSPENDRESUME
And don't need following PM functions.
> +};
> +
> +static struct led_classdev sead3_fled = {
> +       .name           = "sead3::fled",
> +       .brightness_set = sead3_fled_set,
> +};
> +
> +#ifdef CONFIG_PM
> +static int sead3_led_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +       led_classdev_suspend(&sead3_pled);
> +       led_classdev_suspend(&sead3_fled);
> +       return 0;
> +}
> +
> +static int sead3_led_resume(struct platform_device *dev)
> +{
> +       led_classdev_resume(&sead3_pled);
> +       led_classdev_resume(&sead3_fled);
> +       return 0;
> +}
> +#else
> +#define sead3_led_suspend      NULL
> +#define sead3_led_resume       NULL
> +#endif
> +
> +static int sead3_led_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +
> +       ret = led_classdev_register(&pdev->dev, &sead3_pled);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = led_classdev_register(&pdev->dev, &sead3_fled);
> +       if (ret < 0)
> +               led_classdev_unregister(&sead3_pled);
> +
> +       return ret;
> +}
> +
> +static int sead3_led_remove(struct platform_device *pdev)
> +{
> +       led_classdev_unregister(&sead3_pled);
> +       led_classdev_unregister(&sead3_fled);
> +       return 0;
> +}
> +
> +static struct platform_driver sead3_led_driver = {
> +       .driver         = {
> +               .name           = DRVNAME,
> +               .owner          = THIS_MODULE,
> +       },
> +       .probe          = sead3_led_probe,
> +       .remove         = sead3_led_remove,
> +       .suspend        = sead3_led_suspend,
> +       .resume         = sead3_led_resume,
> +};
> +
> +static int __init sead3_led_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&sead3_led_driver);
> +       if (ret < 0)
> +               return ret;
> +
> +       pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
> +       if (IS_ERR(pdev)) {
> +               ret = PTR_ERR(pdev);
> +               platform_driver_unregister(&sead3_led_driver);
> +       }
> +
> +       return ret;
> +}
> +module_init(sead3_led_init);
> +
> +static void __exit sead3_led_exit(void)
> +{
> +       platform_device_unregister(pdev);
> +       platform_driver_unregister(&sead3_led_driver);
> +
> +       sead3_pled_set(NULL, 0);
> +       sead3_fled_set(NULL, 0);
> +}
> +module_exit(sead3_led_exit);
> +
> +MODULE_AUTHOR("Chris Dearman <chris@mips.com");
> +MODULE_DESCRIPTION("SEAD-3 LED driver");
> +MODULE_LICENSE("GPL");
> --
> 1.7.10
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
