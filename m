Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1JKGPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:15:06 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:43409 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab1JKGPE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111011154304.f7fefc4f7f86b4b10348578c@canb.auug.org.au>
References: <20111011154304.f7fefc4f7f86b4b10348578c@canb.auug.org.au>
Date: Tue, 11 Oct 2011 09:15:02 +0300
Message-ID: <CAPo=G1yMZm-gcVsqL3V7o-y=+cFfeQxVup27_48wdtV0_LTnkQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the sound tree with the arm-soc tree
From: "Ujfalusi, Peter" <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Oct 11, 2011 at 7:43 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Takashi,
>
> Today's linux-next merge of the sound tree got a conflict in
> arch/arm/plat-omap/devices.c between commit 40246e0003f0 ("ARM: OMAP:
> mcbsp: Move out omap_mcbsp_register_board_cfg from plat-omap/devices")
> from the arm-soc tree and commit d231f5cbac9e ("OMAP: McPDM: Convert
> McPDM device to omap_device") from the sound tree.
>
> Just overlapping removals.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks, the McBSP change came via linux-omap while we had the McPDM
changes coming via sound tree.

>
> Mark, Liam:  That sound tree commit has a few Signed-off-by lines with no
> email addresses.

I can not track their new contact information. They used to work for TI, and I
have been advised to give them credit for their work on this area.
I could have added no longer valid email addresses...

-- 
Péter

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/plat-omap/devices.c
> index acd132c,40eca9b..0000000
> --- a/arch/arm/plat-omap/devices.c
> +++ b/arch/arm/plat-omap/devices.c
> @@@ -24,44 -24,56 +24,11 @@@
>  #include <plat/tc.h>
>  #include <plat/board.h>
>  #include <plat/mmc.h>
>  -#include <mach/gpio.h>
>  #include <plat/menelaus.h>
>  -#include <plat/mcbsp.h>
>  #include <plat/omap44xx.h>
>
> - #if defined(CONFIG_SND_OMAP_SOC_MCPDM) || \
> -               defined(CONFIG_SND_OMAP_SOC_MCPDM_MODULE)
> -
> - static struct resource mcpdm_resources[] = {
> -       {
> -               .name           = "mcpdm_mem",
> -               .start          = OMAP44XX_MCPDM_BASE,
> -               .end            = OMAP44XX_MCPDM_BASE + SZ_4K,
> -               .flags          = IORESOURCE_MEM,
> -       },
> -       {
> -               .name           = "mcpdm_irq",
> -               .start          = OMAP44XX_IRQ_MCPDM,
> -               .end            = OMAP44XX_IRQ_MCPDM,
> -               .flags          = IORESOURCE_IRQ,
> -       },
> - };
> -
> - static struct platform_device omap_mcpdm_device = {
> -       .name           = "omap-mcpdm",
> -       .id             = -1,
> -       .num_resources  = ARRAY_SIZE(mcpdm_resources),
> -       .resource       = mcpdm_resources,
> - };
> -
> - static void omap_init_mcpdm(void)
> - {
> -       (void) platform_device_register(&omap_mcpdm_device);
> - }
> - #else
> - static inline void omap_init_mcpdm(void) {}
> - #endif
> -
>  /*-------------------------------------------------------------------------*/
>
>  -#if defined(CONFIG_OMAP_MCBSP) || defined(CONFIG_OMAP_MCBSP_MODULE)
>  -
>  -static struct platform_device **omap_mcbsp_devices;
>  -
>  -void omap_mcbsp_register_board_cfg(struct resource *res, int res_count,
>  -                      struct omap_mcbsp_platform_data *config, int size)
>  -{
>  -      int i;
>  -
>  -      omap_mcbsp_devices = kzalloc(size * sizeof(struct platform_device *),
>  -                                   GFP_KERNEL);
>  -      if (!omap_mcbsp_devices) {
>  -              printk(KERN_ERR "Could not register McBSP devices\n");
>  -              return;
>  -      }
>  -
>  -      for (i = 0; i < size; i++) {
>  -              struct platform_device *new_mcbsp;
>  -              int ret;
>  -
>  -              new_mcbsp = platform_device_alloc("omap-mcbsp", i + 1);
>  -              if (!new_mcbsp)
>  -                      continue;
>  -              platform_device_add_resources(new_mcbsp, &res[i * res_count],
>  -                                      res_count);
>  -              new_mcbsp->dev.platform_data = &config[i];
>  -              ret = platform_device_add(new_mcbsp);
>  -              if (ret) {
>  -                      platform_device_put(new_mcbsp);
>  -                      continue;
>  -              }
>  -              omap_mcbsp_devices[i] = new_mcbsp;
>  -      }
>  -}
>  -
>  -#else
>  -void omap_mcbsp_register_board_cfg(struct resource *res, int res_count,
>  -                      struct omap_mcbsp_platform_data *config, int size)
>  -{  }
>  -#endif
>  -
>  -/*-------------------------------------------------------------------------*/
>  -
>  #if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
>        defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
>
>
