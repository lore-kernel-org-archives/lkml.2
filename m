Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2BTA1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:27:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2BTA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:27:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.221.9 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F41935B.3010304@gmail.com>
Date: Mon, 20 Feb 2012 11:27:07 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] ARM: at91/PMC: make register base soc independent
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <0a6b12715f8e339eb42f4dc73921a8402af969bf.1329500622.git.nicolas.ferre@atmel.com>
In-Reply-To: <0a6b12715f8e339eb42f4dc73921a8402af969bf.1329500622.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/12 04:50, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


Looks good,

Reviewed-by: Ryan Mallon <rmallon@gmail.com>

> ---
>  arch/arm/mach-at91/at91rm9200.c               |    2 +-
>  arch/arm/mach-at91/clock.c                    |   75 +++++++++++++------------
>  arch/arm/mach-at91/include/mach/at91_pmc.h    |   56 +++++++++++-------
>  arch/arm/mach-at91/include/mach/at91rm9200.h  |    4 +-
>  arch/arm/mach-at91/include/mach/at91sam9260.h |    1 -
>  arch/arm/mach-at91/include/mach/at91sam9261.h |    1 -
>  arch/arm/mach-at91/include/mach/at91sam9263.h |    1 -
>  arch/arm/mach-at91/include/mach/at91sam9g45.h |    1 -
>  arch/arm/mach-at91/include/mach/at91sam9rl.h  |    1 -
>  arch/arm/mach-at91/include/mach/at91sam9x5.h  |    3 +-
>  arch/arm/mach-at91/include/mach/hardware.h    |    3 +-
>  arch/arm/mach-at91/pm.c                       |    9 +--
>  arch/arm/mach-at91/pm_slowclock.S             |   38 ++++++------
>  drivers/usb/gadget/atmel_usba_udc.c           |    6 +-
>  14 files changed, 105 insertions(+), 96 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> index 94141b2..c7efa17 100644
> --- a/arch/arm/mach-at91/at91rm9200.c
> +++ b/arch/arm/mach-at91/at91rm9200.c
> @@ -295,7 +295,7 @@ static void at91rm9200_idle(void)
>  	 * Disable the processor clock.  The processor will be automatically
>  	 * re-enabled by an interrupt or by a reset.
>  	 */
> -	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> +	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
>  }
>  
>  static void at91rm9200_restart(char mode, const char *cmd)
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index d1b4e07..57b15a9 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -33,6 +33,7 @@
>  #include "clock.h"
>  #include "generic.h"
>  
> +void __iomem *at91_pmc_base;
>  
>  /*
>   * There's a lot more which can be done with clocks, including cpufreq
> @@ -125,11 +126,11 @@ static void pllb_mode(struct clk *clk, int is_on)
>  		value = 0;
>  
>  	// REVISIT: Add work-around for AT91RM9200 Errata #26 ?
> -	at91_sys_write(AT91_CKGR_PLLBR, value);
> +	at91_pmc_write(AT91_CKGR_PLLBR, value);
>  
>  	do {
>  		cpu_relax();
> -	} while ((at91_sys_read(AT91_PMC_SR) & AT91_PMC_LOCKB) != is_on);
> +	} while ((at91_pmc_read(AT91_PMC_SR) & AT91_PMC_LOCKB) != is_on);
>  }
>  
>  static struct clk pllb = {
> @@ -144,24 +145,24 @@ static struct clk pllb = {
>  static void pmc_sys_mode(struct clk *clk, int is_on)
>  {
>  	if (is_on)
> -		at91_sys_write(AT91_PMC_SCER, clk->pmc_mask);
> +		at91_pmc_write(AT91_PMC_SCER, clk->pmc_mask);
>  	else
> -		at91_sys_write(AT91_PMC_SCDR, clk->pmc_mask);
> +		at91_pmc_write(AT91_PMC_SCDR, clk->pmc_mask);
>  }
>  
>  static void pmc_uckr_mode(struct clk *clk, int is_on)
>  {
> -	unsigned int uckr = at91_sys_read(AT91_CKGR_UCKR);
> +	unsigned int uckr = at91_pmc_read(AT91_CKGR_UCKR);
>  
>  	if (is_on) {
>  		is_on = AT91_PMC_LOCKU;
> -		at91_sys_write(AT91_CKGR_UCKR, uckr | clk->pmc_mask);
> +		at91_pmc_write(AT91_CKGR_UCKR, uckr | clk->pmc_mask);
>  	} else
> -		at91_sys_write(AT91_CKGR_UCKR, uckr & ~(clk->pmc_mask));
> +		at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(clk->pmc_mask));
>  
>  	do {
>  		cpu_relax();
> -	} while ((at91_sys_read(AT91_PMC_SR) & AT91_PMC_LOCKU) != is_on);
> +	} while ((at91_pmc_read(AT91_PMC_SR) & AT91_PMC_LOCKU) != is_on);
>  }
>  
>  /* USB function clocks (PLLB must be 48 MHz) */
> @@ -197,9 +198,9 @@ struct clk mck = {
>  static void pmc_periph_mode(struct clk *clk, int is_on)
>  {
>  	if (is_on)
> -		at91_sys_write(AT91_PMC_PCER, clk->pmc_mask);
> +		at91_pmc_write(AT91_PMC_PCER, clk->pmc_mask);
>  	else
> -		at91_sys_write(AT91_PMC_PCDR, clk->pmc_mask);
> +		at91_pmc_write(AT91_PMC_PCDR, clk->pmc_mask);
>  }
>  
>  static struct clk __init *at91_css_to_clk(unsigned long css)
> @@ -359,10 +360,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  		if (actual && actual <= rate) {
>  			u32	pckr;
>  
> -			pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
> +			pckr = at91_pmc_read(AT91_PMC_PCKR(clk->id));
>  			pckr &= css_mask;	/* keep clock selection */
>  			pckr |= prescale << prescale_offset;
> -			at91_sys_write(AT91_PMC_PCKR(clk->id), pckr);
> +			at91_pmc_write(AT91_PMC_PCKR(clk->id), pckr);
>  			clk->rate_hz = actual;
>  			break;
>  		}
> @@ -396,7 +397,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>  
>  	clk->rate_hz = parent->rate_hz;
>  	clk->parent = parent;
> -	at91_sys_write(AT91_PMC_PCKR(clk->id), parent->id);
> +	at91_pmc_write(AT91_PMC_PCKR(clk->id), parent->id);
>  
>  	spin_unlock_irqrestore(&clk_lock, flags);
>  	return 0;
> @@ -415,7 +416,7 @@ static void __init init_programmable_clock(struct clk *clk)
>  	else
>  		css_mask = AT91_PMC_CSS;
>  
> -	pckr = at91_sys_read(AT91_PMC_PCKR(clk->id));
> +	pckr = at91_pmc_read(AT91_PMC_PCKR(clk->id));
>  	parent = at91_css_to_clk(pckr & css_mask);
>  	clk->parent = parent;
>  	clk->rate_hz = parent->rate_hz / pmc_prescaler_divider(pckr);
> @@ -432,19 +433,19 @@ static int at91_clk_show(struct seq_file *s, void *unused)
>  	u32		scsr, pcsr, uckr = 0, sr;
>  	struct clk	*clk;
>  
> -	seq_printf(s, "SCSR = %8x\n", scsr = at91_sys_read(AT91_PMC_SCSR));
> -	seq_printf(s, "PCSR = %8x\n", pcsr = at91_sys_read(AT91_PMC_PCSR));
> -	seq_printf(s, "MOR  = %8x\n", at91_sys_read(AT91_CKGR_MOR));
> -	seq_printf(s, "MCFR = %8x\n", at91_sys_read(AT91_CKGR_MCFR));
> -	seq_printf(s, "PLLA = %8x\n", at91_sys_read(AT91_CKGR_PLLAR));
> +	seq_printf(s, "SCSR = %8x\n", scsr = at91_pmc_read(AT91_PMC_SCSR));
> +	seq_printf(s, "PCSR = %8x\n", pcsr = at91_pmc_read(AT91_PMC_PCSR));
> +	seq_printf(s, "MOR  = %8x\n", at91_pmc_read(AT91_CKGR_MOR));
> +	seq_printf(s, "MCFR = %8x\n", at91_pmc_read(AT91_CKGR_MCFR));
> +	seq_printf(s, "PLLA = %8x\n", at91_pmc_read(AT91_CKGR_PLLAR));
>  	if (cpu_has_pllb())
> -		seq_printf(s, "PLLB = %8x\n", at91_sys_read(AT91_CKGR_PLLBR));
> +		seq_printf(s, "PLLB = %8x\n", at91_pmc_read(AT91_CKGR_PLLBR));
>  	if (cpu_has_utmi())
> -		seq_printf(s, "UCKR = %8x\n", uckr = at91_sys_read(AT91_CKGR_UCKR));
> -	seq_printf(s, "MCKR = %8x\n", at91_sys_read(AT91_PMC_MCKR));
> +		seq_printf(s, "UCKR = %8x\n", uckr = at91_pmc_read(AT91_CKGR_UCKR));
> +	seq_printf(s, "MCKR = %8x\n", at91_pmc_read(AT91_PMC_MCKR));
>  	if (cpu_has_upll())
> -		seq_printf(s, "USB  = %8x\n", at91_sys_read(AT91_PMC_USB));
> -	seq_printf(s, "SR   = %8x\n", sr = at91_sys_read(AT91_PMC_SR));
> +		seq_printf(s, "USB  = %8x\n", at91_pmc_read(AT91_PMC_USB));
> +	seq_printf(s, "SR   = %8x\n", sr = at91_pmc_read(AT91_PMC_SR));
>  
>  	seq_printf(s, "\n");
>  
> @@ -632,14 +633,14 @@ static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
>  	if (cpu_is_at91rm9200()) {
>  		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
>  		udpck.pmc_mask = AT91RM9200_PMC_UDP;
> -		at91_sys_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
> +		at91_pmc_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
>  	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() ||
>  		   cpu_is_at91sam9263() || cpu_is_at91sam9g20() ||
>  		   cpu_is_at91sam9g10()) {
>  		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
>  		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
>  	}
> -	at91_sys_write(AT91_CKGR_PLLBR, 0);
> +	at91_pmc_write(AT91_CKGR_PLLBR, 0);
>  
>  	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
>  	uhpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
> @@ -656,13 +657,13 @@ static void __init at91_upll_usbfs_clock_init(unsigned long main_clock)
>  	/* Setup divider by 10 to reach 48 MHz */
>  	usbr |= ((10 - 1) << 8) & AT91_PMC_OHCIUSBDIV;
>  
> -	at91_sys_write(AT91_PMC_USB, usbr);
> +	at91_pmc_write(AT91_PMC_USB, usbr);
>  
>  	/* Now set uhpck values */
>  	uhpck.parent = &utmi_clk;
>  	uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
>  	uhpck.rate_hz = utmi_clk.rate_hz;
> -	uhpck.rate_hz /= 1 + ((at91_sys_read(AT91_PMC_USB) & AT91_PMC_OHCIUSBDIV) >> 8);
> +	uhpck.rate_hz /= 1 + ((at91_pmc_read(AT91_PMC_USB) & AT91_PMC_OHCIUSBDIV) >> 8);
>  }
>  
>  int __init at91_clock_init(unsigned long main_clock)
> @@ -671,6 +672,10 @@ int __init at91_clock_init(unsigned long main_clock)
>  	int i;
>  	int pll_overclock = false;
>  
> +	at91_pmc_base = ioremap(AT91_PMC, 256);
> +	if (!at91_pmc_base)
> +		panic("Impossible to ioremap AT91_PMC 0x%x\n", AT91_PMC);
> +
>  	/*
>  	 * When the bootloader initialized the main oscillator correctly,
>  	 * there's no problem using the cycle counter.  But if it didn't,
> @@ -679,14 +684,14 @@ int __init at91_clock_init(unsigned long main_clock)
>  	 */
>  	if (!main_clock) {
>  		do {
> -			tmp = at91_sys_read(AT91_CKGR_MCFR);
> +			tmp = at91_pmc_read(AT91_CKGR_MCFR);
>  		} while (!(tmp & AT91_PMC_MAINRDY));
>  		main_clock = (tmp & AT91_PMC_MAINF) * (AT91_SLOW_CLOCK / 16);
>  	}
>  	main_clk.rate_hz = main_clock;
>  
>  	/* report if PLLA is more than mildly overclocked */
> -	plla.rate_hz = at91_pll_rate(&plla, main_clock, at91_sys_read(AT91_CKGR_PLLAR));
> +	plla.rate_hz = at91_pll_rate(&plla, main_clock, at91_pmc_read(AT91_CKGR_PLLAR));
>  	if (cpu_has_300M_plla()) {
>  		if (plla.rate_hz > 300000000)
>  			pll_overclock = true;
> @@ -701,7 +706,7 @@ int __init at91_clock_init(unsigned long main_clock)
>  		pr_info("Clocks: PLLA overclocked, %ld MHz\n", plla.rate_hz / 1000000);
>  
>  	if (cpu_has_plladiv2()) {
> -		mckr = at91_sys_read(AT91_PMC_MCKR);
> +		mckr = at91_pmc_read(AT91_PMC_MCKR);
>  		plla.rate_hz /= (1 << ((mckr & AT91_PMC_PLLADIV2) >> 12));	/* plla divisor by 2 */
>  	}
>  
> @@ -741,7 +746,7 @@ int __init at91_clock_init(unsigned long main_clock)
>  	 * MCK and CPU derive from one of those primary clocks.
>  	 * For now, assume this parentage won't change.
>  	 */
> -	mckr = at91_sys_read(AT91_PMC_MCKR);
> +	mckr = at91_pmc_read(AT91_PMC_MCKR);
>  	mck.parent = at91_css_to_clk(mckr & AT91_PMC_CSS);
>  	freq = mck.parent->rate_hz;
>  	freq /= pmc_prescaler_divider(mckr);					/* prescale */
> @@ -814,8 +819,8 @@ static int __init at91_clock_reset(void)
>  		pr_debug("Clocks: disable unused %s\n", clk->name);
>  	}
>  
> -	at91_sys_write(AT91_PMC_PCDR, pcdr);
> -	at91_sys_write(AT91_PMC_SCDR, scdr);
> +	at91_pmc_write(AT91_PMC_PCDR, pcdr);
> +	at91_pmc_write(AT91_PMC_SCDR, scdr);
>  
>  	return 0;
>  }
> @@ -823,6 +828,6 @@ late_initcall(at91_clock_reset);
>  
>  void at91sam9_idle(void)
>  {
> -	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> +	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
>  	cpu_do_idle();
>  }
> diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/arch/arm/mach-at91/include/mach/at91_pmc.h
> index f9fdbbe..3660478 100644
> --- a/arch/arm/mach-at91/include/mach/at91_pmc.h
> +++ b/arch/arm/mach-at91/include/mach/at91_pmc.h
> @@ -16,10 +16,22 @@
>  #ifndef AT91_PMC_H
>  #define AT91_PMC_H
>  
> -#define	AT91_PMC_SCER		(AT91_PMC + 0x00)	/* System Clock Enable Register */
> -#define	AT91_PMC_SCDR		(AT91_PMC + 0x04)	/* System Clock Disable Register */
> +#ifndef __ASSEMBLY__
> +extern void __iomem *at91_pmc_base;
>  
> -#define	AT91_PMC_SCSR		(AT91_PMC + 0x08)	/* System Clock Status Register */
> +#define at91_pmc_read(field) \
> +	__raw_readl(at91_pmc_base + field)
> +
> +#define at91_pmc_write(field, value) \
> +	__raw_writel(value, at91_pmc_base + field)
> +#else
> +.extern at91_aic_base
> +#endif
> +
> +#define	AT91_PMC_SCER		0x00			/* System Clock Enable Register */
> +#define	AT91_PMC_SCDR		0x04			/* System Clock Disable Register */
> +
> +#define	AT91_PMC_SCSR		0x08			/* System Clock Status Register */
>  #define		AT91_PMC_PCK		(1 <<  0)		/* Processor Clock */
>  #define		AT91RM9200_PMC_UDP	(1 <<  1)		/* USB Devcice Port Clock [AT91RM9200 only] */
>  #define		AT91RM9200_PMC_MCKUDP	(1 <<  2)		/* USB Device Port Master Clock Automatic Disable on Suspend [AT91RM9200 only] */
> @@ -34,17 +46,17 @@
>  #define		AT91_PMC_HCK0		(1 << 16)		/* AHB Clock (USB host) [AT91SAM9261 only] */
>  #define		AT91_PMC_HCK1		(1 << 17)		/* AHB Clock (LCD) [AT91SAM9261 only] */
>  
> -#define	AT91_PMC_PCER		(AT91_PMC + 0x10)	/* Peripheral Clock Enable Register */
> -#define	AT91_PMC_PCDR		(AT91_PMC + 0x14)	/* Peripheral Clock Disable Register */
> -#define	AT91_PMC_PCSR		(AT91_PMC + 0x18)	/* Peripheral Clock Status Register */
> +#define	AT91_PMC_PCER		0x10			/* Peripheral Clock Enable Register */
> +#define	AT91_PMC_PCDR		0x14			/* Peripheral Clock Disable Register */
> +#define	AT91_PMC_PCSR		0x18			/* Peripheral Clock Status Register */
>  
> -#define	AT91_CKGR_UCKR		(AT91_PMC + 0x1C)	/* UTMI Clock Register [some SAM9] */
> +#define	AT91_CKGR_UCKR		0x1C			/* UTMI Clock Register [some SAM9] */
>  #define		AT91_PMC_UPLLEN		(1   << 16)		/* UTMI PLL Enable */
>  #define		AT91_PMC_UPLLCOUNT	(0xf << 20)		/* UTMI PLL Start-up Time */
>  #define		AT91_PMC_BIASEN		(1   << 24)		/* UTMI BIAS Enable */
>  #define		AT91_PMC_BIASCOUNT	(0xf << 28)		/* UTMI BIAS Start-up Time */
>  
> -#define	AT91_CKGR_MOR		(AT91_PMC + 0x20)	/* Main Oscillator Register [not on SAM9RL] */
> +#define	AT91_CKGR_MOR		0x20			/* Main Oscillator Register [not on SAM9RL] */
>  #define		AT91_PMC_MOSCEN		(1    <<  0)		/* Main Oscillator Enable */
>  #define		AT91_PMC_OSCBYPASS	(1    <<  1)		/* Oscillator Bypass */
>  #define		AT91_PMC_MOSCRCEN	(1    <<  3)		/* Main On-Chip RC Oscillator Enable [some SAM9] */
> @@ -53,12 +65,12 @@
>  #define		AT91_PMC_MOSCSEL	(1    << 24)		/* Main Oscillator Selection [some SAM9] */
>  #define		AT91_PMC_CFDEN		(1    << 25)		/* Clock Failure Detector Enable [some SAM9] */
>  
> -#define	AT91_CKGR_MCFR		(AT91_PMC + 0x24)	/* Main Clock Frequency Register */
> +#define	AT91_CKGR_MCFR		0x24			/* Main Clock Frequency Register */
>  #define		AT91_PMC_MAINF		(0xffff <<  0)		/* Main Clock Frequency */
>  #define		AT91_PMC_MAINRDY	(1	<< 16)		/* Main Clock Ready */
>  
> -#define	AT91_CKGR_PLLAR		(AT91_PMC + 0x28)	/* PLL A Register */
> -#define	AT91_CKGR_PLLBR		(AT91_PMC + 0x2c)	/* PLL B Register */
> +#define	AT91_CKGR_PLLAR		0x28			/* PLL A Register */
> +#define	AT91_CKGR_PLLBR		0x2c			/* PLL B Register */
>  #define		AT91_PMC_DIV		(0xff  <<  0)		/* Divider */
>  #define		AT91_PMC_PLLCOUNT	(0x3f  <<  8)		/* PLL Counter */
>  #define		AT91_PMC_OUT		(3     << 14)		/* PLL Clock Frequency Range */
> @@ -69,7 +81,7 @@
>  #define			AT91_PMC_USBDIV_4		(2 << 28)
>  #define		AT91_PMC_USB96M		(1     << 28)		/* Divider by 2 Enable (PLLB only) */
>  
> -#define	AT91_PMC_MCKR		(AT91_PMC + 0x30)	/* Master Clock Register */
> +#define	AT91_PMC_MCKR		0x30			/* Master Clock Register */
>  #define		AT91_PMC_CSS		(3 <<  0)		/* Master Clock Selection */
>  #define			AT91_PMC_CSS_SLOW		(0 << 0)
>  #define			AT91_PMC_CSS_MAIN		(1 << 0)
> @@ -111,27 +123,27 @@
>  #define			AT91_PMC_PLLADIV2_OFF		(0 << 12)
>  #define			AT91_PMC_PLLADIV2_ON		(1 << 12)
>  
> -#define	AT91_PMC_USB		(AT91_PMC + 0x38)	/* USB Clock Register [some SAM9 only] */
> +#define	AT91_PMC_USB		0x38			/* USB Clock Register [some SAM9 only] */
>  #define		AT91_PMC_USBS		(0x1 <<  0)		/* USB OHCI Input clock selection */
>  #define			AT91_PMC_USBS_PLLA		(0 << 0)
>  #define			AT91_PMC_USBS_UPLL		(1 << 0)
>  #define		AT91_PMC_OHCIUSBDIV	(0xF <<  8)		/* Divider for USB OHCI Clock */
>  
> -#define	AT91_PMC_SMD		(AT91_PMC + 0x3c)	/* Soft Modem Clock Register [some SAM9 only] */
> +#define	AT91_PMC_SMD		0x3c			/* Soft Modem Clock Register [some SAM9 only] */
>  #define		AT91_PMC_SMDS		(0x1  <<  0)		/* SMD input clock selection */
>  #define		AT91_PMC_SMD_DIV	(0x1f <<  8)		/* SMD input clock divider */
>  #define		AT91_PMC_SMDDIV(n)	(((n) <<  8) & AT91_PMC_SMD_DIV)
>  
> -#define	AT91_PMC_PCKR(n)	(AT91_PMC + 0x40 + ((n) * 4))	/* Programmable Clock 0-N Registers */
> +#define	AT91_PMC_PCKR(n)	(0x40 + ((n) * 4))	/* Programmable Clock 0-N Registers */
>  #define		AT91_PMC_ALT_PCKR_CSS	(0x7 <<  0)		/* Programmable Clock Source Selection [alternate length] */
>  #define			AT91_PMC_CSS_MASTER		(4 << 0)	/* [some SAM9 only] */
>  #define		AT91_PMC_CSSMCK		(0x1 <<  8)		/* CSS or Master Clock Selection */
>  #define			AT91_PMC_CSSMCK_CSS		(0 << 8)
>  #define			AT91_PMC_CSSMCK_MCK		(1 << 8)
>  
> -#define	AT91_PMC_IER		(AT91_PMC + 0x60)	/* Interrupt Enable Register */
> -#define	AT91_PMC_IDR		(AT91_PMC + 0x64)	/* Interrupt Disable Register */
> -#define	AT91_PMC_SR		(AT91_PMC + 0x68)	/* Status Register */
> +#define	AT91_PMC_IER		0x60			/* Interrupt Enable Register */
> +#define	AT91_PMC_IDR		0x64			/* Interrupt Disable Register */
> +#define	AT91_PMC_SR		0x68			/* Status Register */
>  #define		AT91_PMC_MOSCS		(1 <<  0)		/* MOSCS Flag */
>  #define		AT91_PMC_LOCKA		(1 <<  1)		/* PLLA Lock */
>  #define		AT91_PMC_LOCKB		(1 <<  2)		/* PLLB Lock */
> @@ -144,18 +156,18 @@
>  #define		AT91_PMC_MOSCSELS	(1 << 16)		/* Main Oscillator Selection [some SAM9] */
>  #define		AT91_PMC_MOSCRCS	(1 << 17)		/* Main On-Chip RC [some SAM9] */
>  #define		AT91_PMC_CFDEV		(1 << 18)		/* Clock Failure Detector Event [some SAM9] */
> -#define	AT91_PMC_IMR		(AT91_PMC + 0x6c)	/* Interrupt Mask Register */
> +#define	AT91_PMC_IMR		0x6c			/* Interrupt Mask Register */
>  
> -#define AT91_PMC_PROT		(AT91_PMC + 0xe4)	/* Write Protect Mode Register [some SAM9] */
> +#define AT91_PMC_PROT		0xe4			/* Write Protect Mode Register [some SAM9] */
>  #define		AT91_PMC_WPEN		(0x1  <<  0)		/* Write Protect Enable */
>  #define		AT91_PMC_WPKEY		(0xffffff << 8)		/* Write Protect Key */
>  #define		AT91_PMC_PROTKEY	(0x504d43 << 8)		/* Activation Code */
>  
> -#define AT91_PMC_WPSR		(AT91_PMC + 0xe8)	/* Write Protect Status Register [some SAM9] */
> +#define AT91_PMC_WPSR		0xe8			/* Write Protect Status Register [some SAM9] */
>  #define		AT91_PMC_WPVS		(0x1  <<  0)		/* Write Protect Violation Status */
>  #define		AT91_PMC_WPVSRC		(0xffff  <<  8)		/* Write Protect Violation Source */
>  
> -#define AT91_PMC_PCR		(AT91_PMC + 0x10c)	/* Peripheral Control Register [some SAM9] */
> +#define AT91_PMC_PCR		0x10c			/* Peripheral Control Register [some SAM9] */
>  #define		AT91_PMC_PCR_PID	(0x3f  <<  0)		/* Peripheral ID */
>  #define		AT91_PMC_PCR_CMD	(0x1  <<  12)		/* Command */
>  #define		AT91_PMC_PCR_DIV	(0x3  <<  16)		/* Divisor Value */
> diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
> index 32d57be..603e6aa 100644
> --- a/arch/arm/mach-at91/include/mach/at91rm9200.h
> +++ b/arch/arm/mach-at91/include/mach/at91rm9200.h
> @@ -77,10 +77,8 @@
>  
>  
>  /*
> - * System Peripherals (offset from AT91_BASE_SYS)
> + * System Peripherals
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)	/* Power Management Controller */
> -
>  #define AT91RM9200_BASE_DBGU	AT91_BASE_DBGU0	/* Debug Unit */
>  #define AT91RM9200_BASE_PIOA	0xfffff400	/* PIO Controller A */
>  #define AT91RM9200_BASE_PIOB	0xfffff600	/* PIO Controller B */
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
> index c5b6b3b..1524e87 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9260.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
> @@ -80,7 +80,6 @@
>  /*
>   * System Peripherals (offset from AT91_BASE_SYS)
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
>  
>  #define AT91SAM9260_BASE_ECC	0xffffe800
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
> index a269cef..a6a3c1d 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9261.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
> @@ -65,7 +65,6 @@
>  /*
>   * System Peripherals (offset from AT91_BASE_SYS)
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
>  
>  #define AT91SAM9261_BASE_SMC	0xffffec00
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
> index bccba0b..dda083d 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9263.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9263.h
> @@ -74,7 +74,6 @@
>  /*
>   * System Peripherals (offset from AT91_BASE_SYS)
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
>  
>  #define AT91SAM9263_BASE_ECC0	0xffffe000
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
> index dfc4570..a824e15 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
> @@ -86,7 +86,6 @@
>  /*
>   * System Peripherals (offset from AT91_BASE_SYS)
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
>  
>  #define AT91SAM9G45_BASE_ECC	0xffffe200
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
> index de960dc..2d7176a 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
> @@ -69,7 +69,6 @@
>  /*
>   * System Peripherals (offset from AT91_BASE_SYS)
>   */
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  #define AT91_SCKCR	(0xfffffd50 - AT91_BASE_SYS)
>  #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
>  
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5.h b/arch/arm/mach-at91/include/mach/at91sam9x5.h
> index 96f25f5..a297a77 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9x5.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9x5.h
> @@ -55,10 +55,9 @@
>  #define AT91SAM9X5_BASE_USART2	0xf8024000
>  
>  /*
> - * System Peripherals (offset from AT91_BASE_SYS)
> + * System Peripherals
>   */
>  #define AT91SAM9X5_BASE_DDRSDRC0	0xffffe800
> -#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
>  
>  /*
>   * Base addresses for early serial code (uncompress.h)
> diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
> index fd7dce4..e9e29a6 100644
> --- a/arch/arm/mach-at91/include/mach/hardware.h
> +++ b/arch/arm/mach-at91/include/mach/hardware.h
> @@ -59,9 +59,10 @@
>  
>  /*
>   * On all at91 have the Advanced Interrupt Controller starts at address
> - * 0xfffff000
> + * 0xfffff000 and the Power Management Controller starts at 0xfffffc00
>   */
>  #define AT91_AIC	0xfffff000
> +#define AT91_PMC	0xfffffc00
>  
>  /*
>   * Peripheral identifiers/interrupts.
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 83a0051..44f4b08 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -136,7 +136,7 @@ static int at91_pm_verify_clocks(void)
>  	unsigned long scsr;
>  	int i;
>  
> -	scsr = at91_sys_read(AT91_PMC_SCSR);
> +	scsr = at91_pmc_read(AT91_PMC_SCSR);
>  
>  	/* USB must not be using PLLB */
>  	if (cpu_is_at91rm9200()) {
> @@ -160,7 +160,7 @@ static int at91_pm_verify_clocks(void)
>  		if ((scsr & (AT91_PMC_PCK0 << i)) == 0)
>  			continue;
>  
> -		css = at91_sys_read(AT91_PMC_PCKR(i)) & AT91_PMC_CSS;
> +		css = at91_pmc_read(AT91_PMC_PCKR(i)) & AT91_PMC_CSS;
>  		if (css != AT91_PMC_CSS_SLOW) {
>  			pr_err("AT91: PM - Suspend-to-RAM with PCK%d src %d\n", i, css);
>  			return 0;
> @@ -197,7 +197,6 @@ extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
>  extern u32 at91_slow_clock_sz;
>  #endif
>  
> -static void __iomem *at91_pmc_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_PMC);
>  void __iomem *at91_ramc_base[2];
>  
>  void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
> @@ -208,7 +207,7 @@ void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
>  	}
>  	at91_ramc_base[id] = ioremap(addr, size);
>  	if (!at91_ramc_base[id])
> -		pr_warn("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
> +		panic("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
>  }
>  
>  static int at91_pm_enter(suspend_state_t state)
> @@ -218,7 +217,7 @@ static int at91_pm_enter(suspend_state_t state)
>  
>  	pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
>  			/* remember all the always-wake irqs */
> -			(at91_sys_read(AT91_PMC_PCSR)
> +			(at91_pmc_read(AT91_PMC_PCSR)
>  					| (1 << AT91_ID_FIQ)
>  					| (1 << AT91_ID_SYS)
>  					| (at91_extern_irq))
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index 17f4d72..abb9214 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -54,7 +54,7 @@
>  1:	sub	tmp2, tmp2, #1
>  	cmp	tmp2, #0
>  	beq	2f
> -	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_PMC_SR]
>  	tst	tmp1, #AT91_PMC_MCKRDY
>  	beq	1b
>  2:
> @@ -68,7 +68,7 @@
>  1:	sub	tmp2, tmp2, #1
>  	cmp	tmp2, #0
>  	beq	2f
> -	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_PMC_SR]
>  	tst	tmp1, #AT91_PMC_MOSCS
>  	beq	1b
>  2:
> @@ -82,7 +82,7 @@
>  1:	sub	tmp2, tmp2, #1
>  	cmp	tmp2, #0
>  	beq	2f
> -	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_PMC_SR]
>  	tst	tmp1, #AT91_PMC_LOCKA
>  	beq	1b
>  2:
> @@ -96,7 +96,7 @@
>  1:	sub	tmp2, tmp2, #1
>  	cmp	tmp2, #0
>  	beq	2f
> -	ldr	tmp1, [pmc, #(AT91_PMC_SR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_PMC_SR]
>  	tst	tmp1, #AT91_PMC_LOCKB
>  	beq	1b
>  2:
> @@ -176,14 +176,14 @@ sdr_sr_enable:
>  
>  sdr_sr_done:
>  	/* Save Master clock setting */
> -	ldr	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_PMC_MCKR]
>  	str	tmp1, .saved_mckr
>  
>  	/*
>  	 * Set the Master clock source to slow clock
>  	 */
>  	bic	tmp1, tmp1, #AT91_PMC_CSS
> -	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_PMC_MCKR]
>  
>  	wait_mckrdy
>  
> @@ -194,44 +194,44 @@ sdr_sr_done:
>  	 * See AT91RM9200 errata #27 and #28 for details.
>  	 */
>  	mov	tmp1, #0
> -	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_PMC_MCKR]
>  
>  	wait_mckrdy
>  #endif
>  
>  	/* Save PLLA setting and disable it */
> -	ldr	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_CKGR_PLLAR]
>  	str	tmp1, .saved_pllar
>  
>  	mov	tmp1, #AT91_PMC_PLLCOUNT
>  	orr	tmp1, tmp1, #(1 << 29)		/* bit 29 always set */
> -	str	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
>  
>  	/* Save PLLB setting and disable it */
> -	ldr	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_CKGR_PLLBR]
>  	str	tmp1, .saved_pllbr
>  
>  	mov	tmp1, #AT91_PMC_PLLCOUNT
> -	str	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_PLLBR]
>  
>  	/* Turn off the main oscillator */
> -	ldr	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
>  	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
> -	str	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_MOR]
>  
>  	/* Wait for interrupt */
>  	mcr	p15, 0, tmp1, c7, c0, 4
>  
>  	/* Turn on the main oscillator */
> -	ldr	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
> +	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
>  	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
> -	str	tmp1, [pmc, #(AT91_CKGR_MOR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_MOR]
>  
>  	wait_moscrdy
>  
>  	/* Restore PLLB setting */
>  	ldr	tmp1, .saved_pllbr
> -	str	tmp1, [pmc, #(AT91_CKGR_PLLBR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_PLLBR]
>  
>  	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
>  	bne	1f
> @@ -243,7 +243,7 @@ sdr_sr_done:
>  
>  	/* Restore PLLA setting */
>  	ldr	tmp1, .saved_pllar
> -	str	tmp1, [pmc, #(AT91_CKGR_PLLAR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
>  
>  	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
>  	bne	3f
> @@ -264,7 +264,7 @@ sdr_sr_done:
>  	tst	tmp1, #AT91_PMC_PRES
>  	beq	2f
>  	and	tmp1, tmp1, #AT91_PMC_PRES
> -	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_PMC_MCKR]
>  
>  	wait_mckrdy
>  #endif
> @@ -273,7 +273,7 @@ sdr_sr_done:
>  	 * Restore master clock setting
>  	 */
>  2:	ldr	tmp1, .saved_mckr
> -	str	tmp1, [pmc, #(AT91_PMC_MCKR - AT91_PMC)]
> +	str	tmp1, [pmc, #AT91_PMC_MCKR]
>  
>  	wait_mckrdy
>  
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index e2fb6d5..ce9dffb 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -332,12 +332,12 @@ static int vbus_is_present(struct usba_udc *udc)
>  
>  static void toggle_bias(int is_on)
>  {
> -	unsigned int uckr = at91_sys_read(AT91_CKGR_UCKR);
> +	unsigned int uckr = at91_pmc_read(AT91_CKGR_UCKR);
>  
>  	if (is_on)
> -		at91_sys_write(AT91_CKGR_UCKR, uckr | AT91_PMC_BIASEN);
> +		at91_pmc_write(AT91_CKGR_UCKR, uckr | AT91_PMC_BIASEN);
>  	else
> -		at91_sys_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
> +		at91_pmc_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
>  }
>  
>  #else


