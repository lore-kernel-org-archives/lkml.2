Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1KKNCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:02:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55773 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab1KKNCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:02:52 -0500
MIME-Version: 1.0
In-Reply-To: <1321006467-15824-1-git-send-email-peiyong.feng.kernel@gmail.com>
References: <1321006467-15824-1-git-send-email-peiyong.feng.kernel@gmail.com>
Date: Fri, 11 Nov 2011 18:32:51 +0530
Message-ID: <CAJuYYwRueftNrWofo744vWXPa+vkgv3r4CyOr_Q_GNrcfct4YA@mail.gmail.com>
Subject: Re: [PATCH] Add dm9000 network support for OK6410 board.
From: Thomas Abraham <thomas.abraham@linaro.org>
To: peiyong feng <peiyong.feng.kernel@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2011 15:44, peiyong feng <peiyong.feng.kernel@gmail.com> wrote:
> Signed-off-by: peiyong feng <peiyong.feng.kernel@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/mach-smdk6410.c |    1 +
>  arch/arm/plat-samsung/devs.c          |   40 +++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 0 deletions(-)

If the change is intended for OK6410 board, any reason for modifying
mach-smdk6410.c board file?

>
> diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c b/arch/arm/mach-s3c64xx/mach-smdk6410.c
> index 8bc8edd..71e817a 100644
> --- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
> +++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
> @@ -276,6 +276,7 @@ static struct platform_device *smdk6410_devices[] __initdata = {
>        &s3c_device_fb,
>        &s3c_device_ohci,
>        &s3c_device_usb_hsotg,
> +       &s3c_device_dm9000,
>        &samsung_asoc_dma,
>        &s3c64xx_device_iisv4,
>        &samsung_device_keypad,
> diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
> index 4ca8b57..38edc1a 100644
> --- a/arch/arm/plat-samsung/devs.c
> +++ b/arch/arm/plat-samsung/devs.c
> @@ -29,6 +29,7 @@
>  #include <linux/mtd/partitions.h>
>  #include <linux/mmc/host.h>
>  #include <linux/ioport.h>
> +#include <linux/dm9000.h>
>
>  #include <asm/irq.h>
>  #include <asm/pmu.h>
> @@ -1401,6 +1402,45 @@ void __init s5p_ehci_set_platdata(struct s5p_ehci_platdata *pd)
>  }
>  #endif /* CONFIG_S5P_DEV_USB_EHCI */
>
> +/* Ethernet */
> +#ifdef CONFIG_DM9000
> +#define S3C64XX_PA_DM9000      (0x18000000)
> +#define S3C64XX_SZ_DM9000      SZ_1M
> +#define S3C64XX_VA_DM9000      S3C_ADDR(0x03b00300)

There could be other boards based on other samsung soc's which would
be using dm9000. So arch/arm/plat-samsung/devs.c might not be correct
place for these additions. And, there is S3C64XX_PA_XM0CSN0 in
mach-s3c64xx/include/mach/map.h which should be reused instead of
these new macros.

Please refer to other board files in arch/arm/mach-s3c64xx for
reference on adding dm9000 support for OK6410 board.

Regards,
Thomas.

> +
> +static struct resource dm9000_resources[] = {
> +       [0] = {
> +               .start          = S3C64XX_PA_DM9000,
> +               .end            = S3C64XX_PA_DM9000 + 3,
> +               .flags          = IORESOURCE_MEM,
> +       },
> +       [1] = {
> +               .start          = S3C64XX_PA_DM9000 + 4,
> +               .end            = S3C64XX_PA_DM9000 + S3C64XX_SZ_DM9000 - 1,
> +               .flags          = IORESOURCE_MEM,
> +       },
> +       [2] = {
> +               .start          = IRQ_EINT(7),
> +               .end            = IRQ_EINT(7),
> +               .flags          = IORESOURCE_IRQ | IRQF_TRIGGER_HIGH,
> +       },
> +};
> +
> +static struct dm9000_plat_data dm9000_setup = {
> +       .flags                  = DM9000_PLATF_16BITONLY,
> +       .dev_addr               = { 0x08, 0x90, 0x00, 0xa0, 0x90, 0x90 },
> +};
> +
> +static struct platform_device s3c_device_dm9000 = {
> +       .name                   = "dm9000",
> +       .id                             = 0,
> +       .num_resources  = ARRAY_SIZE(dm9000_resources),
> +       .resource               = dm9000_resources,
> +       .dev                    = {
> +               .platform_data = &dm9000_setup,
> +       }
> +};
> +#endif /*#ifdef CONFIG_DM9000*/
>  /* USB HSOTG */
>
>  #ifdef CONFIG_S3C_DEV_USB_HSOTG
> --
> 1.7.7.rc0.235.g8d714
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
