Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1BJCZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:25:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42824 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1BJCZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TLHMzeBeCveyGIMGs54FSF1VlcdN+MXxnuO097rdfBJas32NLkMtekHEWUNqpvp5Yd
         SeT0tgWUceI3wplR+klcW/Q9io+PpWjBL2MGFcfccC6ymT5DGM2xx4bZm39kmELsmSsw
         Njp3bNYHGwqXk6ujhDHLhcoaayN/EA5ot0d8M=
MIME-Version: 1.0
In-Reply-To: <46685.88.65.119.194.1297295587.squirrel@88.65.119.194>
References: <46685.88.65.119.194.1297295587.squirrel@88.65.119.194>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 10 Feb 2011 10:24:47 +0800
Message-ID: <AANLkTikHbJ+x0nEvdXQpzADwT3XfJNqR6O_WzaEtFWnh@mail.gmail.com>
Subject: Re: [PATCH]ARM: mmp: add Trizeps6 board support
To: yupeng.schneider@ipms.fraunhofer.de
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        inux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yupeng.schneider@googlemail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 7:53 AM, Yupeng Schneider
<yupeng.schneider@ipms.fraunhofer.de> wrote:
> Hi all,
>
> the following patch add the BSP for the Trizeps6 board with pxa168 Processor.
>
> Signed-off-by: Yupeng Schneider <yupeng.schneider@googlemail.com>

Hi Yupeng,

This is really a nice patch. I would be better if this can be separated into
some smaller patches further:

1. some of the MFP macros in trizeps6.h, they are generic and can be
placed into mfp-pxa168.h, or is there any reason that the macros in
mfp-pxa168.h do not work on your board?

2. individual patches for adding uart3, audio, and cpld

3. then the patch for the board

Sounds OK? Let me know your ideas.

Thanks
- eric

> ---
>  arch/arm/mach-mmp/Kconfig                      |   29 ++
>  arch/arm/mach-mmp/Makefile                     |    1 +
>  arch/arm/mach-mmp/include/mach/audio.h         |   29 ++
>  arch/arm/mach-mmp/include/mach/pxa168.h        |   21 +
>  arch/arm/mach-mmp/include/mach/regs-apmu.h     |    1 +
>  arch/arm/mach-mmp/include/mach/trizeps6.h      |  122 ++++++
>  arch/arm/mach-mmp/include/mach/trizeps6_cpld.h |   87 +++++
>  arch/arm/mach-mmp/pxa168.c                     |   10 +
>  arch/arm/mach-mmp/trizeps6.c                   |  469
> ++++++++++++++++++++++++
>  arch/arm/mach-mmp/trizeps6_cpld.c              |  145 ++++++++
>  10 files changed, 914 insertions(+), 0 deletions(-)
>  create mode 100755 arch/arm/mach-mmp/include/mach/audio.h
>  create mode 100755 arch/arm/mach-mmp/include/mach/trizeps6.h
>  create mode 100755 arch/arm/mach-mmp/include/mach/trizeps6_cpld.h create
> mode 100755 arch/arm/mach-mmp/trizeps6.c
>  create mode 100755 arch/arm/mach-mmp/trizeps6_cpld.c
>
> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig index
> 0711d3b..8c6be81 100644
> --- a/arch/arm/mach-mmp/Kconfig
> +++ b/arch/arm/mach-mmp/Kconfig
> @@ -64,6 +64,35 @@ config MACH_TETON_BGA
>          Say 'Y' here if you want to support the Marvell PXA168-based
>          Teton BGA Development Board.
>
> +comment "Third Party Dev Platforms (sorted by vendor name)"
> +
> +config MACH_TRIZEPS6
> +       bool "Keith und Koep Trizeps6 DIMM-Module"
> +       select TRIZEPS6_PCMCIA
> +       select CPU_PXA168
> +       help
> +         Say 'Y' here if you want to support TRIZEPS VI board Development Board.
> +
> +choice
> +       prompt "Select base board for Trizeps module"
> +       depends on MACH_TRIZEPS6
> +
> +config MACH_TRIZEPS6_CONXS
> +       bool "ConXS Eval Board"
> +
> +config MACH_TRIZEPS6_UCONXS
> +       bool "uConXS Eval Board"
> +
> +config MACH_TRIZEPS6_ANY
> +       bool "another Board"
> +
> +endchoice
> +
> +config TRIZEPS6_PCMCIA
> +       bool
> +       help
> +         Enable PCMCIA support for Trizeps modules
> +
>  endmenu
>
>  config CPU_PXA168
> diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile index
> 751cdbf..1b8744f 100644
> --- a/arch/arm/mach-mmp/Makefile
> +++ b/arch/arm/mach-mmp/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_MACH_TTC_DKB)    += ttc_dkb.o
>  obj-$(CONFIG_MACH_FLINT)       += flint.o
>  obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
>  obj-$(CONFIG_MACH_TETON_BGA)   += teton_bga.o
> +obj-$(CONFIG_MACH_TRIZEPS6)    += trizeps6.o trizeps6_cpld.o
> diff --git a/arch/arm/mach-mmp/include/mach/audio.h
> b/arch/arm/mach-mmp/include/mach/audio.h
> index 0000000..6ef474f
> --- /dev/null
> +++ b/arch/arm/mach-mmp/include/mach/audio.h
> @@ -0,0 +1,29 @@
> +#ifndef __ASM_ARCH_AUDIO_H__
> +#define __ASM_ARCH_AUDIO_H__
> +
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/ac97_codec.h>
> +
> +/*
> + * @reset_gpio: AC97 reset gpio (normally gpio113 or gpio95)
> + *              a -1 value means no gpio will be used for reset
> + * @codec_pdata: AC97 codec platform_data
> +
> + * reset_gpio should only be specified for pxa27x CPUs where a silicon +
> * bug prevents correct operation of the reset line. If not specified, + *
> the default behaviour on these CPUs is to consider gpio 113 as the + *
> AC97 reset line, which is the default on most boards.
> + */
> +struct pxa2xx_audio_ops_t {
> +       int (*startup)(struct snd_pcm_substream *, void *);
> +       void (*shutdown)(struct snd_pcm_substream *, void *);
> +       void (*suspend)(void *);
> +       void (*resume)(void *);
> +       void *priv;
> +       int reset_gpio;
> +       void *codec_pdata[AC97_BUS_MAX_DEVICES];
> +};
> +
> +
> +#endif
> diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h
> b/arch/arm/mach-mmp/include/mach/pxa168.h
> index 1801e42..c4a9977 100644
> --- a/arch/arm/mach-mmp/include/mach/pxa168.h
> +++ b/arch/arm/mach-mmp/include/mach/pxa168.h
> @@ -14,9 +14,12 @@ extern void pxa168_clear_keypad_wakeup(void);
>  #include <video/pxa168fb.h>
>  #include <plat/pxa27x_keypad.h>
>  #include <mach/cputype.h>
> +#include <linux/pxa168_eth.h>
> +#include <mach/audio.h>
>
>  extern struct pxa_device_desc pxa168_device_uart1;
>  extern struct pxa_device_desc pxa168_device_uart2;
> +extern struct pxa_device_desc pxa168_device_uart3;
>  extern struct pxa_device_desc pxa168_device_twsi0;
>  extern struct pxa_device_desc pxa168_device_twsi1;
>  extern struct pxa_device_desc pxa168_device_pwm1;
> @@ -31,6 +34,9 @@ extern struct pxa_device_desc pxa168_device_ssp5;
>  extern struct pxa_device_desc pxa168_device_nand;
>  extern struct pxa_device_desc pxa168_device_fb;
>  extern struct pxa_device_desc pxa168_device_keypad;
> +extern struct pxa_device_desc pxa168_device_mfu;
> +extern struct pxa_device_desc pxa168_device_ac97;
> +
>
>  static inline int pxa168_add_uart(int id)
>  {
> @@ -39,6 +45,7 @@ static inline int pxa168_add_uart(int id)
>        switch (id) {
>        case 1: d = &pxa168_device_uart1; break;
>        case 2: d = &pxa168_device_uart2; break;
> +       case 3: d = &pxa168_device_uart3; break;
>        }
>
>        if (d == NULL)
> @@ -117,4 +124,18 @@ static inline int pxa168_add_keypad(struct
> pxa27x_keypad_platform_data *data)
>        return pxa_register_device(&pxa168_device_keypad, data, sizeof(*data));
>  }
>
> +static inline int pxa168_add_mfu(struct pxa168_eth_platform_data *data) +{
> +#if defined(CONFIG_PXA168_ETH)
> +       return pxa_register_device(&pxa168_device_mfu, data, sizeof(*data)); +#else
> +       return 0;
> +#endif
> +}
> +
> +static inline int pxa168_add_ac97(struct pxa2xx_audio_ops_t *ops) +{
> +       return pxa_register_device(&pxa168_device_ac97, ops , sizeof(*ops)); +}
> +
>  #endif /* __ASM_MACH_PXA168_H */
> diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h
> b/arch/arm/mach-mmp/include/mach/regs-apmu.h
> index ac47023..68d39bc 100644
> --- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
> +++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
> @@ -27,6 +27,7 @@
>  #define APMU_DMA       APMU_REG(0x064)
>  #define APMU_GEU       APMU_REG(0x068)
>  #define APMU_BUS       APMU_REG(0x06c)
> +#define APMU_MFU       APMU_REG(0x0fc)
>
>  #define APMU_FNCLK_EN  (1 << 4)
>  #define APMU_AXICLK_EN (1 << 3)
> diff --git a/arch/arm/mach-mmp/include/mach/trizeps6.h
> b/arch/arm/mach-mmp/include/mach/trizeps6.h
> index 0000000..40b526a
> --- /dev/null
> +++ b/arch/arm/mach-mmp/include/mach/trizeps6.h
> @@ -0,0 +1,122 @@
> +/************************************************************************
> + * Include file for TRIZEPS6 SoM and ConXS eval-board
> + * Copyright (c) Yupeng Schneider
> + * 2010
> +
> ************************************************************************/ +
> +/*
> + * Includes/Defines
> + */
> +#ifndef _TRIPEPS6_H_
> +#define _TRIPEPS6_H_
> +
> +#define STUART_SODIMM  1
> +
> +/* UART */
> +#define GPIO104_UART1_DSR      MFP_CFG(GPIO104, AF2)
> +#define GPIO105_UART1_DCD      MFP_CFG(GPIO105, AF2)
> +#define GPIO107_UART2_TXD      MFP_CFG_DRV(GPIO126, AF2, FAST)
> +#define GPIO107_UART2_RXD      MFP_CFG_DRV(GPIO36, AF2, FAST)
> +#define GPIO109_UART2_CTS      MFP_CFG(GPIO123, AF2)
> +#define GPIO109_UART2_RTS      MFP_CFG(GPIO124, AF2)
> +#define GPIO30_UART3_TXD       MFP_CFG_DRV(GPIO30, AF2, FAST)
> +#define GPIO31_UART3_RXD       MFP_CFG_DRV(GPIO31, AF2, FAST)
> +#define GPIO32_UART3_CTS       MFP_CFG(GPIO32, AF2)
> +#define GPIO33_UART3_RTS       MFP_CFG(GPIO33, AF2)
> +
> +/* MMC2 */
> +#define        GPIO122_MMC2_DAT3       MFP_CFG_DRV(GPIO122, AF4, FAST)
> +#define        GPIO121_MMC2_DAT2       MFP_CFG_DRV(GPIO121, AF4, FAST)
> +#define        GPIO120_MMC2_DAT1       MFP_CFG_DRV(GPIO120, AF4, FAST)
> +#define        GPIO119_MMC2_DAT0       MFP_CFG_DRV(GPIO119, AF4, FAST)
> +#define        GPIO28_MMC2_CMD         MFP_CFG_DRV(GPIO28, AF6, FAST)
> +#define        GPIO29_MMC2_CLK         MFP_CFG_DRV(GPIO29, AF6, FAST)
> +#define GPIO53_MMC2_CD         MFP_CFG(GPIO53, AF0)
> +
> +/*MMC4*/
> +#define        GPIO78_MMC4_DAT3        MFP_CFG_DRV(GPIO78, AF5, FAST)
> +#define        GPIO79_MMC4_DAT2        MFP_CFG_DRV(GPIO79, AF5, FAST)
> +#define        GPIO80_MMC4_DAT1        MFP_CFG_DRV(GPIO80, AF5, FAST)
> +#define        GPIO81_MMC4_DAT0        MFP_CFG_DRV(GPIO81, AF5, FAST)
> +#define        GPIO82_MMC4_CMD         MFP_CFG_DRV(GPIO82, AF5, FAST)
> +#define        GPIO83_MMC4_CLK         MFP_CFG_DRV(GPIO83, AF5, FAST)
> +
> +/* I2C */
> +#define GPIO102_CI2C_SDA       MFP_CFG(GPIO102, AF1)
> +
> +/* MFU */
> +#define GPIO86_TX_CLK   MFP_CFG(GPIO86, AF5)
> +#define GPIO87_TX_EN    MFP_CFG(GPIO87, AF5)
> +#define GPIO88_TX_DQ3   MFP_CFG(GPIO88, AF5)
> +#define GPIO89_TX_DQ2   MFP_CFG(GPIO89, AF5)
> +#define GPIO90_TX_DQ1   MFP_CFG(GPIO90, AF5)
> +#define GPIO91_TX_DQ0   MFP_CFG(GPIO91, AF5)
> +#define GPIO92_MII_CRS   MFP_CFG(GPIO92, AF5)
> +#define GPIO93_MII_COL   MFP_CFG(GPIO93, AF5)
> +#define GPIO94_RX_CLK   MFP_CFG(GPIO94, AF5)
> +#define GPIO95_RX_ER   MFP_CFG(GPIO95, AF5)
> +#define GPIO96_RX_DQ3   MFP_CFG(GPIO96, AF5)
> +#define GPIO97_RX_DQ2   MFP_CFG(GPIO97, AF5)
> +#define GPIO98_RX_DQ1   MFP_CFG(GPIO98, AF5)
> +#define GPIO99_RX_DQ0   MFP_CFG(GPIO99, AF5)
> +#define GPIO100_MII_MDC   MFP_CFG(GPIO100, AF5)
> +#define GPIO101_MII_MDIO   MFP_CFG(GPIO101, AF5)
> +#define GPIO103_RX_DV   MFP_CFG(GPIO103, AF5)
> +
> +/* AC97 */
> +#define GPIO115_AC97_BITCLK    MFP_CFG(GPIO115, AF6)
> +#define GPIO114_AC97_SDATA_IN_0        MFP_CFG(GPIO114, AF6)
> +#define GPIO116_AC97_SDATA_IN_1        MFP_CFG(GPIO116, AF6)
> +#define GPIO117_AC97_SDATA_OUT MFP_CFG(GPIO117, AF6)
> +#define GPIO118_AC97_SYNC      MFP_CFG(GPIO118, AF6)
> +
> +
> +
> +#define TRIZEPS6_PHYS_BASE             0xd4000000
> +
> +
> +#define TRIZEPS6_PIC_PHYS      (0x88000000)    /* CS0-3 Logic chip on ConXS */
> +                               /* Logic on ConXS-board CSFR register*/
> +#define TRIZEPS6_CFSR_PHYS     (TRIZEPS6_PIC_PHYS)
> +                               /* Logic on ConXS-board BOCR register*/
> +#define TRIZEPS6_BOCR_PHYS     (TRIZEPS6_PIC_PHYS+0x00200000)
> +                               /* Logic on ConXS-board IRCR register*/
> +#define TRIZEPS6_IRCR_PHYS     (TRIZEPS6_PIC_PHYS+0x00300000)
> +                               /* Logic on ConXS-board UPSR register*/
> +#define TRIZEPS6_UPSR_PHYS     (TRIZEPS6_PIC_PHYS+0x00280000)
> +                               /* Logic on ConXS-board DICR register*/
> +#define TRIZEPS6_DICR_PHYS     (TRIZEPS6_PIC_PHYS+0x00380000)
> +
> +
> +#define TRIZEPS6_CPLD_PHYS  (0x8e000000) /* CPLD on Trizeps6 module */ +
> +#define TRIZEPS6_CPLD_CTRL_PHYS (TRIZEPS6_CPLD_PHYS)
> +#define TRIZEPS6_CPLD_FTUR_PHYS (TRIZEPS6_CPLD_PHYS+0x4)
> +#define TRIZEPS6_CPLD_HIBE_PHYS (TRIZEPS6_CPLD_PHYS+0x8)
> +#define TRIZEPS6_CPLD_PWM_PHYS (TRIZEPS6_CPLD_PHYS+0xc)
> +#define TRIZEPS6_CPLD_PLDR_PHYS (TRIZEPS6_CPLD_PHYS+0x10)
> +#define TRIZEPS6_CPLD_PSET_PHYS (TRIZEPS6_CPLD_PHYS+0x14)
> +#define TRIZEPS6_CPLD_TTLO_PHYS (TRIZEPS6_CPLD_PHYS+0x18)
> +
> +
> +/* MMC socket */
> +#define GPIO_MMC2_DET          53
> +#define TRIZEPS6_MMC2_IRQ      IRQ_GPIO(mfp_to_gpio(MFP_PIN_GPIO53))
> +#define GPIO_MMC4_DET          41
> +#define TRIZEPS6_MMC4_IRQ      IRQ_GPIO(mfp_to_gpio(MFP_PIN_GPIO41)
> +
> +/* Off-module PIC on ConXS board */
> +#define GPIO_PIC               51
> +#define TRIZEPS6_PIC_IRQ       IRQ_GPIO(mfp_to_gpio(MFP_PIN_GPIO51)
> +
> +/* PCMCIA socket Compact Flash */
> +#define GPIO_PCD               43              /* PCMCIA Card Detect */
> +#define TRIZEPS6_CD_IRQ                IRQ_GPIO(mfp_to_gpio(MFP_PIN_GPIO43)
> +#define GPIO_PRDY              113             /* READY / nINT */
> +#define TRIZEPS6_READY_NINT    IRQ_GPIO(mfp_to_gpio(MFP_PIN_GPIO113) +
> +#define trizeps6_GPIO_CODEC_IRQ                116
> +
> +extern void trizeps6_ac97_acreset(int i);
> +
> +#endif /* _TRIPEPS6_H_ */
> diff --git a/arch/arm/mach-mmp/include/mach/trizeps6_cpld.h
> b/arch/arm/mach-mmp/include/mach/trizeps6_cpld.h
> index 0000000..8538a6b
> --- /dev/null
> +++ b/arch/arm/mach-mmp/include/mach/trizeps6_cpld.h
> @@ -0,0 +1,87 @@
> +#ifndef _TRIPEPS6_CPLD_H_
> +#define _TRIPEPS6_CPLD_H_
> +
> +/* index of resource */
> +#define CTRL_S         0
> +#define CTRL_R         1
> +#define FTUR_S         2
> +#define FTUR_R         3
> +#define HIBE_S         4
> +#define HIBE_R         5
> +#define PWM            6
> +#define PLDR_S         7
> +#define PLDR_R         8
> +#define PSET_S         9
> +#define PSET_R         10
> +#define TTLO_S         11
> +#define TTLO_R         12
> +
> +#define CPLD_CTRL_S cpld.addr[CTRL_S].val
> +#define CPLD_CTRL_R cpld.addr[CTRL_R].val
> +#define CPLD_CONTROL_GR                        (1 << 0)
> +#define CPLD_CONTROL_CODEC             (1 << 2)
> +#define CPLD_CONTROL_ETHPHY            (1 << 3)
> +#define CPLD_CONTROL_RWL               (1 << 4)
> +#define CPLD_CONTROL_RBT               (1 << 5)
> +
> +#define CPLD_FTUR_S cpld.addr[FTUR_S].val
> +#define CPLD_FTUR_R cpld.addr[FTUR_R].val
> +#define CPLD_FEATURE_UART3_SODIMM      (1 << 0)
> +#define CPLD_FEATURE_UART3_BT          (1 << 1)
> +#define CPLD_FEATURE_CF_MODE           (1 << 2)
> +#define CPLD_FEATURE_TTLIO             (1 << 3)
> +#define CPLD_PWM_SODIMM_P69            (1 << 4)
> +#define CPLD_PWM_SODIMM_P77            (1 << 5)
> +#define CPLD_PWM_SODIMM_P106   (1 << 6)
> +#define CPLD_BT_PWM_SODIMM             (1 << 7)
> +
> +#define CPLD_HIBE_S cpld.addr[HIBE_S].val
> +#define CPLD_HIBE_R cpld.addr[HIBE_R].val
> +#define CPLD_HIBERNATE_MODE                            (1 << 0)
> +#define CPLD_HIBERNATE_WAKE_TOUCH              (1 << 1)
> +#define CPLD_HIBERNATE_WAKE_PMIC               (1 << 2)
> +#define CPLD_HIBERNATE_WAKE_IRQ_P43            (1 << 3)
> +
> +#define CPLD_PWM cpld.addr[PWM].val
> +
> +#define CPLD_PINLDR    cpld.addr[PINLDR].val
> +#define CPLD_PINLDR_P69                                        (1 << 0)
> +#define CPLD_PINLDR_P100_PSKTSEL               (1 << 1)
> +#define CPLD_PINLDR_P98_CFNREG                 (1 << 2)
> +#define CPLD_PINLDR_P104_CFNIOIS16             (1 << 3)
> +#define CPLD_PINLDR_P93_RDNWR                  (1 << 4)
> +#define CPLD_PINLDR_P104_IRQ_P43               (1 << 5)
> +
> +#define CPLD_PSET_S cpld.addr[PSET_S].val
> +#define CPLD_PSET_R cpld.addr[PSET_R].val
> +#define CPLD_PINSET_P69                                        (1 << 0)
> +#define CPLD_PINSET_P100_PSKTSEL               (1 << 1)
> +#define CPLD_PINSET_P98_CFNREG                 (1 << 2)
> +#define CPLD_PINSET_P104_CFNIOIS16             (1 << 3)
> +#define CPLD_PINSET_P93_RDnWR                  (1 << 4)
> +
> +#define CPLD_TTLO_S cpld.addr[TTLO_S].val
> +#define CPLD_TTLO_R cpld.addr[TTLO_R].val
> +#define CPLD_TTLIO_W_A8                        (1 << 0)
> +#define CPLD_TTLIO_W_A9                        (1 << 1)
> +#define CPLD_TTLIO_W_A10               (1 << 2)
> +#define CPLD_TTLIO_W_A11               (1 << 3)
> +#define CPLD_TTLIO_W_A12               (1 << 4)
> +#define CPLD_TTLIO_W_A13               (1 << 5)
> +#define CPLD_TTLIO_W_A14               (1 << 6)
> +#define CPLD_TTLIO_W_A15               (1 << 7)
> +#define CPLD_TTLIO_r_A0                        (1 << 0)
> +#define CPLD_TTLIO_r_A1                        (1 << 1)
> +#define CPLD_TTLIO_r_A2                        (1 << 2)
> +#define CPLD_TTLIO_r_A3                        (1 << 3)
> +#define CPLD_TTLIO_r_A4                        (1 << 4)
> +#define CPLD_TTLIO_r_A5                        (1 << 5)
> +#define CPLD_TTLIO_r_A6                        (1 << 6)
> +#define CPLD_TTLIO_r_A7                        (1 << 7)
> +
> +
> +
> +extern unsigned short trizeps6_cpld_readw(unsigned int reg);
> +extern inline void trizeps6_cpld_writew(unsigned int reg, unsigned short
> value);
> +
> +#endif /* _TRIPEPS6_CPLD_H_ */
> diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c index
> 72b4e76..9c2396e 100644
> --- a/arch/arm/mach-mmp/pxa168.c
> +++ b/arch/arm/mach-mmp/pxa168.c
> @@ -66,6 +66,7 @@ void __init pxa168_init_irq(void)
>  /* APB peripheral clocks */
>  static APBC_CLK(uart1, PXA168_UART1, 1, 14745600);
>  static APBC_CLK(uart2, PXA168_UART2, 1, 14745600);
> +static APBC_CLK(uart3, PXA168_UART3, 1, 14745600);
>  static APBC_CLK(twsi0, PXA168_TWSI0, 1, 33000000);
>  static APBC_CLK(twsi1, PXA168_TWSI1, 1, 33000000);
>  static APBC_CLK(pwm1, PXA168_PWM1, 1, 13000000);
> @@ -78,14 +79,18 @@ static APBC_CLK(ssp3, PXA168_SSP3, 4, 0);
>  static APBC_CLK(ssp4, PXA168_SSP4, 4, 0);
>  static APBC_CLK(ssp5, PXA168_SSP5, 4, 0);
>  static APBC_CLK(keypad, PXA168_KPC, 0, 32000);
> +static APBC_CLK(ac97, PXA168_AC97, 0, 24576000);
> +
>
>  static APMU_CLK(nand, NAND, 0x01db, 208000000);
>  static APMU_CLK(lcd, LCD, 0x7f, 312000000);
> +static APMU_CLK(mfu, MFU, 0x9, 0);
>
>  /* device and clock bindings */
>  static struct clk_lookup pxa168_clkregs[] = {
>        INIT_CLKREG(&clk_uart1, "pxa2xx-uart.0", NULL),
>        INIT_CLKREG(&clk_uart2, "pxa2xx-uart.1", NULL),
> +       INIT_CLKREG(&clk_uart3, "pxa2xx-uart.2", NULL),
>        INIT_CLKREG(&clk_twsi0, "pxa2xx-i2c.0", NULL),
>        INIT_CLKREG(&clk_twsi1, "pxa2xx-i2c.1", NULL),
>        INIT_CLKREG(&clk_pwm1, "pxa168-pwm.0", NULL),
> @@ -100,6 +105,8 @@ static struct clk_lookup pxa168_clkregs[] = {
>        INIT_CLKREG(&clk_nand, "pxa3xx-nand", NULL),
>        INIT_CLKREG(&clk_lcd, "pxa168-fb", NULL),
>        INIT_CLKREG(&clk_keypad, "pxa27x-keypad", NULL),
> +       INIT_CLKREG(&clk_mfu, "pxa168-eth", "MFUCLK"),
> +       INIT_CLKREG(&clk_ac97, "pxa2xx-ac97", "AC97CLK"),
>  };
>
>  static int __init pxa168_init(void)
> @@ -149,6 +156,7 @@ void pxa168_clear_keypad_wakeup(void)
>  /* on-chip devices */
>  PXA168_DEVICE(uart1, "pxa2xx-uart", 0, UART1, 0xd4017000, 0x30, 21, 22);
> PXA168_DEVICE(uart2, "pxa2xx-uart", 1, UART2, 0xd4018000, 0x30, 23, 24);
> +PXA168_DEVICE(uart3, "pxa2xx-uart", 2, UART3, 0xd4026000, 0x30, 23, 24);
>  PXA168_DEVICE(twsi0, "pxa2xx-i2c", 0, TWSI0, 0xd4011000, 0x28);
>  PXA168_DEVICE(twsi1, "pxa2xx-i2c", 1, TWSI1, 0xd4025000, 0x28);
>  PXA168_DEVICE(pwm1, "pxa168-pwm", 0, NONE, 0xd401a000, 0x10);
> @@ -163,3 +171,5 @@ PXA168_DEVICE(ssp4, "pxa168-ssp", 3, SSP4, 0xd4020000,
> 0x40, 58, 59);
>  PXA168_DEVICE(ssp5, "pxa168-ssp", 4, SSP5, 0xd4021000, 0x40, 60, 61);
> PXA168_DEVICE(fb, "pxa168-fb", -1, LCD, 0xd420b000, 0x1c8);
>  PXA168_DEVICE(keypad, "pxa27x-keypad", -1, KEYPAD, 0xd4012000, 0x4c);
> +PXA168_DEVICE(mfu, "pxa168-eth", -1, MFU, 0xc0800000, 0x0FFF);
> +PXA168_DEVICE(ac97, "pxa2xx-ac97", -1, AC97, 0xd402B000, 0x0fff); diff
> --git a/arch/arm/mach-mmp/trizeps6.c b/arch/arm/mach-mmp/trizeps6.c index
> 0000000..a935f14
> --- /dev/null
> +++ b/arch/arm/mach-mmp/trizeps6.c
> @@ -0,0 +1,469 @@
> +/*
> + *  linux/arch/arm/mach-mmp/trizeps6.c
> + *
> + *  Support for the Keith und Koep Trizeps6 Modul Platform
> + *  based on Marvell PXA168-CPU
> + *
> + *  Author:    Yupeng Schneider
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as + *
>  publishhed by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/delay.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/addr-map.h>
> +#include <mach/mfp-pxa168.h>
> +#include <mach/pxa168.h>
> +#include <mach/gpio.h>
> +#include <linux/pxa168_eth.h>
> +#include <mach/irqs.h>
> +#include <mach/trizeps6.h>
> +#include <mach/trizeps6_cpld.h>
> +#include "common.h"
> +#include <linux/mmc/sdhci.h>
> +#include <linux/ucb1400.h>
> +#include <mach/audio.h>
> +
> +
> +static unsigned long trizeps6_pin_config[] __initdata = {
> +       /* Data Flash Interface */
> +       GPIO0_DFI_D15,
> +       GPIO1_DFI_D14,
> +       GPIO2_DFI_D13,
> +       GPIO3_DFI_D12,
> +       GPIO4_DFI_D11,
> +       GPIO5_DFI_D10,
> +       GPIO6_DFI_D9,
> +       GPIO7_DFI_D8,
> +       GPIO8_DFI_D7,
> +       GPIO9_DFI_D6,
> +       GPIO10_DFI_D5,
> +       GPIO11_DFI_D4,
> +       GPIO12_DFI_D3,
> +       GPIO13_DFI_D2,
> +       GPIO14_DFI_D1,
> +       GPIO15_DFI_D0,
> +
> +       /* Static Memory Controller */
> +       GPIO18_SMC_nCS0,
> +       GPIO34_SMC_nCS1,
> +       GPIO23_SMC_nLUA,
> +       GPIO25_SMC_nLLA,
> +       GPIO28_SMC_RDY,
> +       GPIO29_SMC_SCLK,
> +       GPIO35_SMC_BE1,
> +       GPIO36_SMC_BE2,
> +
> +
> +       /* UART1 */
> +       GPIO107_UART1_RXD,
> +       GPIO108_UART1_TXD,
> +       GPIO107_UART1_RXD,
> +       GPIO108_UART1_TXD,
> +       GPIO109_UART1_RTS,
> +       GPIO110_UART1_CTS,
> +       GPIO111_UART1_RI,
> +       GPIO104_UART1_DSR,
> +       GPIO112_UART1_DTR,
> +       GPIO105_UART1_DCD,
> +
> +       /* UART2 */
> +       GPIO107_UART2_TXD,
> +       GPIO107_UART2_RXD,
> +       GPIO109_UART2_CTS,
> +       GPIO109_UART2_RTS,
> +
> +       /* UART3 */
> +       GPIO30_UART3_TXD,
> +       GPIO31_UART3_RXD,
> +       GPIO32_UART3_CTS,
> +       GPIO33_UART3_RTS,
> +
> +
> +       /* MFU */
> +       GPIO86_TX_CLK,
> +       GPIO87_TX_EN,
> +       GPIO88_TX_DQ3,
> +       GPIO89_TX_DQ2,
> +       GPIO90_TX_DQ1,
> +       GPIO91_TX_DQ0,
> +       GPIO92_MII_CRS,
> +       GPIO93_MII_COL,
> +       GPIO94_RX_CLK,
> +       GPIO95_RX_ER,
> +       GPIO96_RX_DQ3,
> +       GPIO97_RX_DQ2,
> +       GPIO98_RX_DQ1,
> +       GPIO99_RX_DQ0,
> +       GPIO100_MII_MDC,
> +       GPIO101_MII_MDIO,
> +       GPIO103_RX_DV,
> +
> +       /* USB OTG */
> +       GPIO85_GPIO,
> +       GPIO47_GPIO,
> +
> +       /* i2c bus */
> +       GPIO102_CI2C_SDA,
> +       GPIO106_CI2C_SCL,
> +
> +
> +       /* MMC2 */
> +       GPIO122_MMC2_DAT3 | MFP_PULL_HIGH,
> +       GPIO121_MMC2_DAT2 | MFP_PULL_HIGH,
> +       GPIO120_MMC2_DAT1 | MFP_PULL_HIGH,
> +       GPIO119_MMC2_DAT0 | MFP_PULL_HIGH,
> +       GPIO28_MMC2_CMD | MFP_PULL_HIGH,
> +       GPIO29_MMC2_CLK,
> +       GPIO53_MMC2_CD | MFP_PULL_LOW,                  /* TRIZEPS6_MMC2_IRQ */
> +
> +       /* MMC4 */
> +       GPIO78_MMC4_DAT3 | MFP_PULL_HIGH,
> +       GPIO79_MMC4_DAT2 | MFP_PULL_HIGH,
> +       GPIO80_MMC4_DAT1 | MFP_PULL_HIGH,
> +       GPIO81_MMC4_DAT0 | MFP_PULL_HIGH,
> +       GPIO82_MMC4_CMD | MFP_PULL_HIGH,
> +       GPIO83_MMC4_CLK,
> +
> +       /* LCD */
> +       GPIO56_LCD_FCLK_RD,
> +       GPIO57_LCD_LCLK_A0,
> +       GPIO58_LCD_PCLK_WR,
> +       GPIO59_LCD_DENA_BIAS,
> +       GPIO60_LCD_DD0,
> +       GPIO61_LCD_DD1,
> +       GPIO62_LCD_DD2,
> +       GPIO63_LCD_DD3,
> +       GPIO64_LCD_DD4,
> +       GPIO65_LCD_DD5,
> +       GPIO66_LCD_DD6,
> +       GPIO67_LCD_DD7,
> +       GPIO68_LCD_DD8,
> +       GPIO69_LCD_DD9,
> +       GPIO70_LCD_DD10,
> +       GPIO71_LCD_DD11,
> +       GPIO72_LCD_DD12,
> +       GPIO73_LCD_DD13,
> +       GPIO74_LCD_DD14,
> +       GPIO75_LCD_DD15,
> +
> +
> +       /* AC97 */
> +       GPIO115_AC97_BITCLK,
> +       GPIO114_AC97_SDATA_IN_0,
> +       GPIO117_AC97_SDATA_OUT,
> +       GPIO118_AC97_SYNC,
> +       GPIO116_GPIO,
> +
> +
> +       GPIO51_GPIO,                    /* TRIZEPS6_PIC_IRQ */
> +       GPIO27_GPIO,                    /* Ethernet IRQ */
> +};
> +
> +
> +
> +/****************************************************************************
> + * CPLD
> +
> ****************************************************************************/
> +
> +static struct resource tri6_cpld_resources[] = {
> +       [CTRL_S] = {
> +               .start  = TRIZEPS6_CPLD_CTRL_PHYS,
> +               .end    = TRIZEPS6_CPLD_CTRL_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [CTRL_R] = {
> +               .start  = TRIZEPS6_CPLD_CTRL_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_CTRL_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [FTUR_S] = {
> +               .start  = TRIZEPS6_CPLD_FTUR_PHYS,
> +               .end    = TRIZEPS6_CPLD_FTUR_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [FTUR_R] = {
> +               .start  = TRIZEPS6_CPLD_FTUR_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_FTUR_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [HIBE_S] = {
> +               .start  = TRIZEPS6_CPLD_HIBE_PHYS,
> +               .end    = TRIZEPS6_CPLD_HIBE_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [HIBE_R] = {
> +               .start  = TRIZEPS6_CPLD_HIBE_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_HIBE_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [PWM] = {
> +               .start  = TRIZEPS6_CPLD_PWM_PHYS,
> +               .end    = TRIZEPS6_CPLD_PWM_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [PLDR_S] = {
> +               .start  = TRIZEPS6_CPLD_PLDR_PHYS,
> +               .end    = TRIZEPS6_CPLD_PLDR_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [PLDR_R] = {
> +               .start  = TRIZEPS6_CPLD_PLDR_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_PLDR_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [PSET_S] = {
> +               .start  = TRIZEPS6_CPLD_PSET_PHYS,
> +               .end    = TRIZEPS6_CPLD_PSET_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [PSET_R] = {
> +               .start  = TRIZEPS6_CPLD_PSET_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_PSET_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [TTLO_S] = {
> +               .start  = TRIZEPS6_CPLD_TTLO_PHYS,
> +               .end    = TRIZEPS6_CPLD_TTLO_PHYS+1,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [TTLO_R] = {
> +               .start  = TRIZEPS6_CPLD_TTLO_PHYS+2,
> +               .end    = TRIZEPS6_CPLD_TTLO_PHYS+3,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +};
> +
> +static int tri6_cpld_platdata = 1;
> +
> +static struct platform_device cpld_device = {
> +       .name           = "trizeps6-cpld",
> +       .id             = -1,
> +       .num_resources  = ARRAY_SIZE(tri6_cpld_resources),
> +       .resource       = tri6_cpld_resources,
> +       .dev            = {
> +               .platform_data = &tri6_cpld_platdata,
> +       }
> +};
> +
> +
> +/******************************************************************************
> + * Audio and Touchscreen
> +
> ******************************************************************************/
> +
> +static struct ucb1400_pdata trizeps6_ucb1400_pdata = {
> +       .irq            =  gpio_to_irq(trizeps6_GPIO_CODEC_IRQ),
> +};
> +
> +static struct pxa2xx_audio_ops_t trizeps6_ac97_pdata = {
> +       .codec_pdata    = { &trizeps6_ucb1400_pdata, },
> +};
> +
> +static struct platform_device trizeps6_ucb1400_device = {
> +       .name           = "ucb1400_core",
> +       .id             = -1,
> +       .dev            = {
> +               .platform_data = &trizeps6_ucb1400_pdata,
> +       },
> +};
> +
> +static void __init trizeps6_ts_init(void)
> +{
> +       pxa168_add_ac97(&trizeps6_ac97_pdata);
> +       platform_device_register(&trizeps6_ucb1400_device);
> +}
> +
> +void trizeps6_ac97_acreset(int i)
> +{      unsigned short value;
> +
> +       if (i == 1) {
> +
> +               value = trizeps6_cpld_readw(CTRL_S);
> +               trizeps6_cpld_writew(CTRL_S, value | CPLD_CONTROL_CODEC);
> +       }
> +       if (!i) {
> +               value = trizeps6_cpld_readw(CTRL_R);
> +               trizeps6_cpld_writew(CTRL_R, value | CPLD_CONTROL_CODEC);
> +       }
> +}
> +
> +/******************************************************************************
> + * Ethernet
> +
> ******************************************************************************/
> +static int trizeps6_eth_init(void)
> +{
> +       unsigned short value;
> +
> +       value = trizeps6_cpld_readw(CTRL_R);
> +       trizeps6_cpld_writew(CTRL_R, value | CPLD_CONTROL_ETHPHY);
> +       return 0;
> +
> +}
> +
> +static struct pxa168_eth_platform_data trizeps6_eth_data = {
> +       .phy_addr       = 0x1f,
> +       .port_number = 0,
> +       .init           = trizeps6_eth_init,
> +};
> +
> +/******************************************************************************
> + * NAND
> +
> ******************************************************************************/
> +static struct pxa3xx_nand_timing stnand02gw3b2d_timing = {
> +       .tCH    = 10,
> +       .tCS    = 40,
> +       .tWH    = 20,
> +       .tWP    = 24,
> +       .tRH    = 20,
> +       .tRP    = 24,
> +       .tR         = 50000,
> +       .tWHR   = 120,
> +       .tAR    = 20,
> +
> +};
> +
> +static struct pxa3xx_nand_cmdset largepage_cmdset = {
> +       .read1          = 0x3000,
> +       .read2          = 0x0050,
> +       .program        = 0x1080,
> +       .read_status    = 0x0070,
> +       .read_id        = 0x0090,
> +       .erase          = 0xD060,
> +       .reset          = 0x00FF,
> +       .lock           = 0x002A,
> +       .unlock         = 0x2423,
> +       .lock_status    = 0x007A,
> +};
> +
> +static struct pxa3xx_nand_flash trizeps6_flashes[] = {
> +       {
> +               .timing = &stnand02gw3b2d_timing,
> +               .cmdset = &largepage_cmdset,
> +               .page_per_block = 64,
> +               .page_size      = 2048,
> +               .flash_width    = 8,
> +               .dfc_width      = 8,
> +               .num_blocks     = 2048,
> +               .chip_id        = 0xda20,
> +       },
> +};
> +
> +
> +static struct mtd_partition trizeps6_nand_partitions[] = {
> +       {
> +               .name           = "bootloader",
> +               .offset         = 0,
> +               .size           = SZ_16M,
> +               .mask_flags     = MTD_WRITEABLE,
> +       }, {
> +               .name           = "reserved",
> +               .offset         = MTDPART_OFS_APPEND,
> +               .size           = SZ_128K,
> +               .mask_flags     = MTD_WRITEABLE,
> +       }, {
> +               .name           = "kernel",
> +               .offset         = MTDPART_OFS_APPEND,
> +               .size           = (2*SZ_2M + SZ_1M),
> +               .mask_flags     = 0,
> +       }, {
> +               .name           = "filesystem",
> +               .offset         = MTDPART_OFS_APPEND,
> +               .size = (SZ_256M - 3*SZ_8M),
> +               .mask_flags     = 0,
> +       }
> +};
> +
> +static struct pxa3xx_nand_platform_data trizeps6_nand_info = {
> +       .enable_arbiter = 1,
> +       .parts          = trizeps6_nand_partitions,
> +       .nr_parts       = ARRAY_SIZE(trizeps6_nand_partitions),
> +       .flash      = trizeps6_flashes,
> +       .num_flash  = ARRAY_SIZE(trizeps6_flashes),
> +       .keep_config = 0
> +};
> +
> +
> +
> +static struct i2c_board_info trizeps6_i2c_devices[]  = {
> +       { I2C_BOARD_INFO("pcf8593", 0x51), },
> +};
> +
> +
> +/******************************************************************************
> + * LCD
> +
> ******************************************************************************/
> +static struct fb_videomode trizeps6_video_modes[] = {
> +       [0] = {
> +               .pixclock       = 39720,
> +               .refresh        = 60,
> +               .xres           = 640,
> +               .yres           = 480,
> +               .hsync_len      = 63,
> +               .left_margin    = 12,
> +               .right_margin   = 12,
> +               .vsync_len      = 4,
> +               .upper_margin   = 32,
> +               .lower_margin   = 10,
> +               .sync           = FB_SYNC_VERT_HIGH_ACT | FB_SYNC_HOR_HIGH_ACT,
> +       },
> +};
> +
> +static struct pxa168fb_mach_info trizeps6_lcd_info = {
> +       .id                     = "Base-trizeps6",
> +       .modes                  = trizeps6_video_modes,
> +       .num_modes              = ARRAY_SIZE(trizeps6_video_modes),
> +       .pix_fmt                = PIX_FMT_RGB565,
> +       .io_pin_allocation_mode = PIN_MODE_DUMB_16_GPIO,
> +       .dumb_mode              = DUMB_MODE_RGB565,
> +       .active                 = 1,
> +       .panel_rbswap           = 1,
> +       .invert_pixclock        = 0,
> +};
> +
> +
> +static struct platform_device *trizeps6_devices[] __initdata = {
> +       &cpld_device,
> +};
> +
> +static void __init trizeps6_init(void)
> +{
> +       mfp_config(ARRAY_AND_SIZE(trizeps6_pin_config));
> +
> +       pxa168_add_uart(1);
> +       pxa168_add_uart(2);
> +#ifdef STUART_SODIMM
> +       pxa168_add_uart(3);
> +#endif
> +       pxa168_add_nand(&trizeps6_nand_info);
> +       platform_add_devices(trizeps6_devices,
> +                                       ARRAY_SIZE(trizeps6_devices));
> +
> +       pxa168_add_fb(&trizeps6_lcd_info);
> +       pxa168_add_mfu(&trizeps6_eth_data);
> +       pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(trizeps6_i2c_devices));
> +       trizeps6_ts_init();
> +}
> +
> +static void __init trizeps6_map_io(void)
> +{
> +       mmp_map_io();
> +}
> +
> +MACHINE_START(TRIZEPS6, "PXA168-based Keith & Koep Trizeps VI Development
> Module")
> +       /* MAINTAINER("Yupeng Schneider" <yupeng.schneider@googlemail.com>) */
> +       .map_io         = trizeps6_map_io,
> +       .init_irq       = pxa168_init_irq,
> +       .timer          = &pxa168_timer,
> +       .init_machine   = trizeps6_init,
> +MACHINE_END
> +
> +
> diff --git a/arch/arm/mach-mmp/trizeps6_cpld.c
> b/arch/arm/mach-mmp/trizeps6_cpld.c
> index 0000000..2577b0f
> --- /dev/null
> +++ b/arch/arm/mach-mmp/trizeps6_cpld.c
> @@ -0,0 +1,145 @@
> +/*
> + *  linux/arch/arm/mach-mmp/trizeps6_cpld.c
> + *
> + *
> + *  Author:    Yupeng Schneider
> + *  Created:   27 10, 2010
> + *  Copyright: Yupeng Schneider
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as + *
>  published by the Free Software Foundation.*/
> +
> +#include <linux/kernel.h>
> +#include <linux/ioport.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +
> +#include <asm/io.h>
> +#include <asm/delay.h>
> +#include <mach/trizeps6.h>
> +#include <mach/trizeps6_cpld.h>
> +
> +struct cpld_info {
> +       struct region {
> +               struct resource *res;
> +               struct resource *req;
> +               void __iomem    *iom;
> +               unsigned short   val;
> +       } addr[7];
> +} cpld_info;
> +
> +static struct cpld_info cpld = { { { 0 } } };
> +
> +inline void trizeps6_cpld_writew(unsigned int reg, unsigned short value) +{
> +       if ((cpld.addr[reg].iom != NULL))
> +               writew(value, cpld.addr[reg].iom);
> +
> +}
> +
> +unsigned short trizeps6_cpld_readw(unsigned int reg)
> +{
> +       short value = 0;
> +       if (reg != HIBE_S || reg != HIBE_R || reg != PWM || reg != PSET_S || reg
> != PSET_R) {
> +
> +               if ((cpld.addr[reg].iom != NULL))
> +                       value = readw(cpld.addr[reg].iom);
> +       }
> +       return value;
> +}
> +EXPORT_SYMBOL(trizeps6_cpld_readw);
> +
> +static int trizeps6_cpld_probe(struct platform_device *pdev)
> +{
> +       int i;
> +
> +       CPLD_CTRL_R = CPLD_CONTROL_ETHPHY | CPLD_CONTROL_GR;
> +#ifdef STUART_SODIMM
> +       CPLD_FTUR_S = CPLD_FEATURE_UART3_SODIMM;
> +#endif
> +       for (i = CTRL_S; i <= TTLO_R; i++) {
> +               cpld.addr[i].res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +               if (cpld.addr[i].res == NULL) {
> +                       dev_err(&pdev->dev, "cannot get resource %d area\n", i);
> +                       return -EIO;
> +               }
> +               cpld.addr[i].req = request_mem_region(cpld.addr[i].res->start,
> +                                                       2, pdev->name);
> +               if (cpld.addr[i].req == NULL) {
> +                       dev_err(&pdev->dev, "cannot claim addr area %d\n", i);
> +                       return -EIO;
> +               }
> +               cpld.addr[i].iom = ioremap(cpld.addr[i].res->start, 2);
> +               if (cpld.addr[i].iom == NULL) {
> +                       dev_err(&pdev->dev, "cannot remap addr area %d\n", i);
> +                       return -EIO;
> +               }
> +               switch (i) {
> +               case CTRL_R:
> +                       trizeps6_cpld_writew(CTRL_R, CPLD_CTRL_R);
> +                       break;
> +               case FTUR_S:
> +                       trizeps6_cpld_writew(FTUR_S, CPLD_FTUR_S);
> +                       break;
> +               default:
> +                       ;
> +
> +               }
> +               dev_dbg(&pdev->dev, "mapped region  [%d] %08x -> %p\n", i,
> +                               (int)cpld.addr[i].req->start, cpld.addr[i].iom);
> +       }
> +
> +
> +       return 0;
> +}
> +
> +static int trizeps6_cpld_remove(struct platform_device *pdev)
> +{
> +       dev_dbg(&pdev->dev, "trizeps6_cpld_remove()\n");
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int trizeps6_cpld_suspend(struct platform_device *pdev,
> pm_message_t state)
> +{
> +       return 0;
> +}
> +
> +static int trizeps6_cpld_resume(struct platform_device *pdev)
> +{
> +       return 0;
> +}
> +#endif
> +
> +static struct platform_driver trizeps6_cpld_driver = {
> +       .probe          = trizeps6_cpld_probe,
> +       .remove         = trizeps6_cpld_remove,
> +#ifdef CONFIG_PM
> +       .suspend        = trizeps6_cpld_suspend,
> +       .resume         = trizeps6_cpld_resume,
> +#endif
> +       .driver         = {
> +               .name           = "trizeps6-cpld",
> +       },
> +};
> +
> +
> +static int __devinit trizeps6_cpld_init(void)
> +{
> +
> +       return platform_driver_register(&trizeps6_cpld_driver);
> +}
> +
> +static void trizeps6_cpld_exit(void)
> +{
> +       platform_driver_unregister(&trizeps6_cpld_driver);
> +}
> +
> +arch_initcall(trizeps6_cpld_init);
> +module_exit(trizeps6_cpld_exit);
> +
> +MODULE_AUTHOR("Yupeng Schneider <yupeng.schneider@googlemail.com>");
> +MODULE_DESCRIPTION("Trizeps VI CPLD");
> +MODULE_LICENSE("GPL");
> --
> 1.6.3.3
>
>
>
>
