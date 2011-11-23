Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1KWKYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:24:00 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42455 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1KWKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:23:59 -0500
Message-ID: <1322043831.1753.49.camel@x61.thuisdomein>
Subject: Re: [PATCH] powerpc/40x: Add APM8018X SOC support
From: Paul Bolle <pebolle@tiscali.nl>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: jwboyer@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 11:23:51 +0100
In-Reply-To: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
References: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanmay,

(Some minor Kconfig related comments follow.)

On Wed, 2011-11-23 at 15:14 +0530, Tanmay Inamdar wrote:
> The AppliedMicro APM8018X embedded processor targets embedded applications that
> require low power and a small footprint. It features a PowerPC 405 processor
> core built in a 65nm low-power CMOS process with a five-stage pipeline executing
> up to one instruction per cycle. The family has 128-kbytes of on-chip memory,
> a 128-bit local bus and on-chip DDR2 SDRAM controller with 16-bit interface.
>
>[...]
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  arch/powerpc/Kconfig                        |    6 +
>  arch/powerpc/boot/dcr.h                     |    6 +
>  arch/powerpc/boot/dts/klondike.dts          |  668 +++++++++++++
>  arch/powerpc/configs/40x/klondike_defconfig | 1353 +++++++++++++++++++++++++++
>  arch/powerpc/include/asm/dcr-regs.h         |   20 +
>  arch/powerpc/kernel/cputable.c              |   52 +
>  arch/powerpc/kernel/udbg_16550.c            |   22 +
>  arch/powerpc/platforms/40x/Kconfig          |   11 +
>  arch/powerpc/platforms/40x/ppc40x_simple.c  |    4 +-
>  9 files changed, 2141 insertions(+), 1 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/klondike.dts
>  create mode 100644 arch/powerpc/configs/40x/klondike_defconfig
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b177caa..3f2cc36 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -978,3 +978,9 @@ config PPC_LIB_RHEAP
>  	bool
>  
>  source "arch/powerpc/kvm/Kconfig"
> +
> +config UART_16550_WORD_ADDRESSABLE
> +	bool
> +	default n
> +	help
> +	   Enable this if your UART 16550 is word addressable.

This is only relevant for this SOC isn't it? If so, it might be better
to add it to arch/powerpc/platforms/40x/Kconfig.

The help line can be dropped (there's no prompt, so the help won't be
user visible).

Some people would suggest to use
	def_bool n

here. (I don't really care.)

> [...]

> diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
> index 6837f83..dd3bce9 100644
> --- a/arch/powerpc/kernel/udbg_16550.c
> +++ b/arch/powerpc/kernel/udbg_16550.c
> @@ -18,6 +18,19 @@ extern void real_writeb(u8 data, volatile u8 __iomem *addr);
>  extern u8 real_205_readb(volatile u8 __iomem  *addr);
>  extern void real_205_writeb(u8 data, volatile u8 __iomem *addr);
>  
> +#ifdef CONFIG_UART_16550_WORD_ADDRESSABLE
> +struct NS16550 {
> +	/* this struct must be packed */
> +	unsigned char rbr;  /* 0 */ u8 s0[3];
> +	unsigned char ier;  /* 1 */ u8 s1[3];
> +	unsigned char fcr;  /* 2 */ u8 s2[3];
> +	unsigned char lcr;  /* 3 */ u8 s3[3];
> +	unsigned char mcr;  /* 4 */ u8 s4[3];
> +	unsigned char lsr;  /* 5 */ u8 s5[3];
> +	unsigned char msr;  /* 6 */ u8 s6[3];
> +	unsigned char scr;  /* 7 */ u8 s7[3];
> +};
> +#else
>  struct NS16550 {
>  	/* this struct must be packed */
>  	unsigned char rbr;  /* 0 */
> @@ -29,6 +42,7 @@ struct NS16550 {
>  	unsigned char msr;  /* 6 */
>  	unsigned char scr;  /* 7 */
>  };
> +#endif /* CONFIG_UART_16550_WORD_ADDRESSABLE */
>  
>  #define thr rbr
>  #define iir fcr
> [...] 
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index 1530229..3d0d1d9 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -186,3 +186,14 @@ config IBM405_ERR51
>  #	bool
>  #	depends on !STB03xxx && PPC4xx_DMA
>  #	default y
> +#
> +
> +config APM8018X
> +	bool "APM8018X"
> +	depends on 40x
> +	default y

Why is this "default y"? All other "selectors" of PPC40x_SIMPLE default
to n.
 
> +	select PPC40x_SIMPLE

There was recently some powerpc related discussion on using "select" on
symbols that are themselves user selectable (see
https://lkml.org/lkml/2011/11/9/426 ). But other symbols already select
this symbol so this is not specific to this patch. 

> +	select UART_16550_WORD_ADDRESSABLE
> +	help
> +	  This option enables support for the AppliedMicro Klondike board.
> +

Since you're selecting it here it's good that you made
UART_16550_WORD_ADDRESSABLE hidden (as it has no prompt). But perhaps
you could even drop it and in the code just test for CONFIG_APM8018X. Or
are you expecting more users of UART_16550_WORD_ADDRESSABLE?

> [...]


Paul Bolle

