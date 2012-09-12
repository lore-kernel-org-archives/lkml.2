Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2ILJVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:21:38 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46552 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab2ILJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
References: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
Date: Wed, 12 Sep 2012 14:51:34 +0530
Message-ID: <CANrkHUYtxKEfL8QUA2e5vGJ-LSJLCNX+hmBm1hqFJ439asUefw@mail.gmail.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, svenkatr@ti.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, cjb@laptop.org, nsekhar@ti.com,
        sudhakar.raj@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 6:39 PM, Hebbar, Gururaja <gururaja.hebbar@ti.com> wrote:
> HSMMC IP on AM33xx need a special setting to handle High-speed cards.
> Other platforms like TI81xx, OMAP4 may need this as-well. This depends
> on the HSMMC IP timing closure done for the high speed cards.
>
> From AM335x TRM (SPRUH73F - 18.3.12 Output Signals Generation)
>
> The MMC/SD/SDIO output signals can be driven on either falling edge or
> rising edge depending on the SD_HCTL[2] HSPE bit. This feature allows
> to reach better timing performance, and thus to increase data transfer
> frequency.

Is this specific to some boards or all board with TI81xx ?
What is the side-effect if not done ?

>
> There are few pre-requisites for enabling the HSPE bit
> - Controller should support High-Speed-Enable Bit and
> - Controller should not be using DDR Mode and
> - Controller should advertise that it supports High Speed in
>   capabilities register and
> - MMC/SD clock coming out of controller > 25MHz
>
> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
> ---
> :100644 100644 be76a23... ed271fc... M  Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> :100644 100644 eb3e4d5... 00c658b... M  arch/arm/plat-omap/include/plat/mmc.h
> :100644 100644 c3e96a2... 0e14834... M  drivers/mmc/host/omap_hsmmc.c
>  .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |    1 +
>  arch/arm/plat-omap/include/plat/mmc.h              |    1 +
>  drivers/mmc/host/omap_hsmmc.c                      |   30 +++++++++++++++++++-
>  3 files changed, 31 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index be76a23..ed271fc 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -19,6 +19,7 @@ ti,dual-volt: boolean, supports dual voltage cards
>  "supply-name" examples are "vmmc", "vmmc_aux" etc
>  ti,non-removable: non-removable slot (like eMMC)
>  ti,needs-special-reset: Requires a special softreset sequence
> +ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
>
>  Example:
>         mmc1: mmc@0x4809c000 {
> diff --git a/arch/arm/plat-omap/include/plat/mmc.h b/arch/arm/plat-omap/include/plat/mmc.h
> index eb3e4d5..00c658b 100644
> --- a/arch/arm/plat-omap/include/plat/mmc.h
> +++ b/arch/arm/plat-omap/include/plat/mmc.h
> @@ -127,6 +127,7 @@ struct omap_mmc_platform_data {
>                 /* we can put the features above into this variable */
>  #define HSMMC_HAS_PBIAS                (1 << 0)
>  #define HSMMC_HAS_UPDATED_RESET        (1 << 1)
> +#define HSMMC_HAS_HSPE_SUPPORT (1 << 2)
>                 unsigned features;
>
>                 int switch_pin;                 /* gpio (card detect) */
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index c3e96a2..0e14834 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -63,6 +63,7 @@
>
>  #define VS18                   (1 << 26)
>  #define VS30                   (1 << 25)
> +#define HSS                    (1 << 21)
>  #define SDVS18                 (0x5 << 9)
>  #define SDVS30                 (0x6 << 9)
>  #define SDVS33                 (0x7 << 9)
> @@ -90,6 +91,7 @@
>  #define MSBS                   (1 << 5)
>  #define BCE                    (1 << 1)
>  #define FOUR_BIT               (1 << 1)
> +#define HSPE                   (1 << 2)
>  #define DDR                    (1 << 19)
>  #define DW8                    (1 << 5)
>  #define CC                     0x1
> @@ -490,6 +492,7 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>         struct mmc_ios *ios = &host->mmc->ios;
>         unsigned long regval;
>         unsigned long timeout;
> +       unsigned long clkdiv;
>
>         dev_vdbg(mmc_dev(host->mmc), "Set clock to %uHz\n", ios->clock);
>
> @@ -497,7 +500,8 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>
>         regval = OMAP_HSMMC_READ(host->base, SYSCTL);
>         regval = regval & ~(CLKD_MASK | DTO_MASK);
> -       regval = regval | (calc_divisor(host, ios) << 6) | (DTO << 16);
> +       clkdiv = calc_divisor(host, ios);
> +       regval = regval | (clkdiv << 6) | (DTO << 16);
>         OMAP_HSMMC_WRITE(host->base, SYSCTL, regval);
>         OMAP_HSMMC_WRITE(host->base, SYSCTL,
>                 OMAP_HSMMC_READ(host->base, SYSCTL) | ICE);
> @@ -508,6 +512,27 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>                 && time_before(jiffies, timeout))
>                 cpu_relax();
>
> +       /*
> +        * Enable High-Speed Support
> +        * Pre-Requisites
> +        *      - Controller should support High-Speed-Enable Bit
> +        *      - Controller should not be using DDR Mode
> +        *      - Controller should advertise that it supports High Speed
> +        *        in capabilities register
> +        *      - MMC/SD clock coming out of controller > 25MHz
> +        */
> +       if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
> +           (ios->timing != MMC_TIMING_UHS_DDR50) &&
> +           ((OMAP_HSMMC_READ(host->base, CAPA) & HSS) == HSS)) {
> +               regval = OMAP_HSMMC_READ(host->base, HCTL);
> +               if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)

I think clkdiv is not needed
clk_get_rate(host->fclk)/clkdiv is same as ios->clock

> +                       regval |= HSPE;
> +               else
> +                       regval &= ~HSPE;
> +
> +               OMAP_HSMMC_WRITE(host->base, HCTL, regval);
> +       }
> +
>         omap_hsmmc_start_clock(host);
>  }
>
> @@ -1701,6 +1726,9 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
>         if (of_find_property(np, "ti,needs-special-reset", NULL))
>                 pdata->slots[0].features |= HSMMC_HAS_UPDATED_RESET;
>
> +       if (of_find_property(np, "ti,needs-special-hs-handling", NULL))
> +               pdata->slots[0].features |= HSMMC_HAS_HSPE_SUPPORT;
> +
>         return pdata;
>  }
>  #else
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
