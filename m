Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2IBOpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:45:41 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65031 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab2IBOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:45:36 -0400
Message-ID: <50437117.8000700@metafoo.de>
Date: Sun, 02 Sep 2012 16:45:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 2/3] MIPS: JZ4740: Export timer API
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de> <1346579550-5990-3-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346579550-5990-3-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 11:52 AM, Thierry Reding wrote:
> This is a prerequisite for allowing the PWM driver to be converted to
> the PWM framework.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

I'd prefer to keep the timer functions inline, some of them are called quite
often in the system clock code.

> ---
>  arch/mips/include/asm/mach-jz4740/timer.h |  35 ++++++++
>  arch/mips/jz4740/time.c                   |   2 +-
>  arch/mips/jz4740/timer.c                  | 128 +++++++++++++++++++++++++---
>  arch/mips/jz4740/timer.h                  | 136 ------------------------------
>  4 files changed, 153 insertions(+), 148 deletions(-)
>  delete mode 100644 arch/mips/jz4740/timer.h
> 
> diff --git a/arch/mips/include/asm/mach-jz4740/timer.h b/arch/mips/include/asm/mach-jz4740/timer.h
> index 9baa03c..9e41d0e 100644
> --- a/arch/mips/include/asm/mach-jz4740/timer.h
> +++ b/arch/mips/include/asm/mach-jz4740/timer.h
> @@ -16,6 +16,41 @@
>  #ifndef __ASM_MACH_JZ4740_TIMER
>  #define __ASM_MACH_JZ4740_TIMER
>  
> +#define JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN	BIT(9)
> +#define JZ_TIMER_CTRL_PWM_ACTIVE_LOW		BIT(8)
> +#define JZ_TIMER_CTRL_PWM_ENABLE		BIT(7)
> +#define JZ_TIMER_CTRL_PRESCALE_MASK		0x1c
> +#define JZ_TIMER_CTRL_PRESCALE_OFFSET		0x3
> +#define JZ_TIMER_CTRL_PRESCALE_1		(0 << 3)
> +#define JZ_TIMER_CTRL_PRESCALE_4		(1 << 3)
> +#define JZ_TIMER_CTRL_PRESCALE_16		(2 << 3)
> +#define JZ_TIMER_CTRL_PRESCALE_64		(3 << 3)
> +#define JZ_TIMER_CTRL_PRESCALE_256		(4 << 3)
> +#define JZ_TIMER_CTRL_PRESCALE_1024		(5 << 3)
> +
> +#define JZ_TIMER_CTRL_PRESCALER(x) ((x) << JZ_TIMER_CTRL_PRESCALE_OFFSET)
> +
> +#define JZ_TIMER_CTRL_SRC_EXT		BIT(2)
> +#define JZ_TIMER_CTRL_SRC_RTC		BIT(1)
> +#define JZ_TIMER_CTRL_SRC_PCLK		BIT(0)
> +
> +void __init jz4740_timer_init(void);
> +
> +void jz4740_timer_stop(unsigned int timer);
> +void jz4740_timer_start(unsigned int timer);
> +bool jz4740_timer_is_enabled(unsigned int timer);
> +void jz4740_timer_enable(unsigned int timer);
> +void jz4740_timer_disable(unsigned int timer);
> +void jz4740_timer_set_period(unsigned int timer, uint16_t period);
> +void jz4740_timer_set_duty(unsigned int timer, uint16_t duty);
> +void jz4740_timer_set_count(unsigned int timer, uint16_t count);
> +uint16_t jz4740_timer_get_count(unsigned int timer);
> +void jz4740_timer_ack_full(unsigned int timer);
> +void jz4740_timer_irq_full_enable(unsigned int timer);
> +void jz4740_timer_irq_full_disable(unsigned int timer);
> +uint16_t jz4740_timer_get_ctrl(unsigned int timer);
> +void jz4740_timer_set_ctrl(unsigned int timer, uint16_t ctrl);
> +
>  void jz4740_timer_enable_watchdog(void);
>  void jz4740_timer_disable_watchdog(void);
>  
> diff --git a/arch/mips/jz4740/time.c b/arch/mips/jz4740/time.c
> index f83c2dd..39bb4bb 100644
> --- a/arch/mips/jz4740/time.c
> +++ b/arch/mips/jz4740/time.c
> @@ -20,10 +20,10 @@
>  #include <linux/clockchips.h>
>  
>  #include <asm/mach-jz4740/irq.h>
> +#include <asm/mach-jz4740/timer.h>
>  #include <asm/time.h>
>  
>  #include "clock.h"
> -#include "timer.h"
>  
>  #define TIMER_CLOCKEVENT 0
>  #define TIMER_CLOCKSOURCE 1
> diff --git a/arch/mips/jz4740/timer.c b/arch/mips/jz4740/timer.c
> index 654d5c3..79c4354 100644
> --- a/arch/mips/jz4740/timer.c
> +++ b/arch/mips/jz4740/timer.c
> @@ -21,19 +21,28 @@
>  
>  #include <asm/mach-jz4740/base.h>
>  
> -void __iomem *jz4740_timer_base;
> +#define JZ_REG_TIMER_STOP		0x0C
> +#define JZ_REG_TIMER_STOP_SET		0x1C
> +#define JZ_REG_TIMER_STOP_CLEAR		0x2C
> +#define JZ_REG_TIMER_ENABLE		0x00
> +#define JZ_REG_TIMER_ENABLE_SET		0x04
> +#define JZ_REG_TIMER_ENABLE_CLEAR	0x08
> +#define JZ_REG_TIMER_FLAG		0x10
> +#define JZ_REG_TIMER_FLAG_SET		0x14
> +#define JZ_REG_TIMER_FLAG_CLEAR		0x18
> +#define JZ_REG_TIMER_MASK		0x20
> +#define JZ_REG_TIMER_MASK_SET		0x24
> +#define JZ_REG_TIMER_MASK_CLEAR		0x28
>  
> -void jz4740_timer_enable_watchdog(void)
> -{
> -	writel(BIT(16), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
> -}
> -EXPORT_SYMBOL_GPL(jz4740_timer_enable_watchdog);
> +#define JZ_REG_TIMER_DFR(x) (((x) * 0x10) + 0x30)
> +#define JZ_REG_TIMER_DHR(x) (((x) * 0x10) + 0x34)
> +#define JZ_REG_TIMER_CNT(x) (((x) * 0x10) + 0x38)
> +#define JZ_REG_TIMER_CTRL(x) (((x) * 0x10) + 0x3C)
>  
> -void jz4740_timer_disable_watchdog(void)
> -{
> -	writel(BIT(16), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
> -}
> -EXPORT_SYMBOL_GPL(jz4740_timer_disable_watchdog);
> +#define JZ_TIMER_IRQ_HALF(x) BIT((x) + 0x10)
> +#define JZ_TIMER_IRQ_FULL(x) BIT(x)
> +
> +void __iomem *jz4740_timer_base;
>  
>  void __init jz4740_timer_init(void)
>  {
> @@ -48,3 +57,100 @@ void __init jz4740_timer_init(void)
>  	/* Timer irqs are unmasked by default, mask them */
>  	writel(0x00ff00ff, jz4740_timer_base + JZ_REG_TIMER_MASK_SET);
>  }
> +
> +void jz4740_timer_stop(unsigned int timer)
> +{
> +	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_stop);
> +
> +void jz4740_timer_start(unsigned int timer)
> +{
> +	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_start);
> +
> +bool jz4740_timer_is_enabled(unsigned int timer)
> +{
> +	return readb(jz4740_timer_base + JZ_REG_TIMER_ENABLE) & BIT(timer);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_is_enabled);
> +
> +void jz4740_timer_enable(unsigned int timer)
> +{
> +	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_SET);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_enable);
> +
> +void jz4740_timer_disable(unsigned int timer)
> +{
> +	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_CLEAR);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_disable);
> +
> +void jz4740_timer_set_period(unsigned int timer, uint16_t period)
> +{
> +	writew(period, jz4740_timer_base + JZ_REG_TIMER_DFR(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_set_period);
> +
> +void jz4740_timer_set_duty(unsigned int timer, uint16_t duty)
> +{
> +	writew(duty, jz4740_timer_base + JZ_REG_TIMER_DHR(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_set_duty);
> +
> +void jz4740_timer_set_count(unsigned int timer, uint16_t count)
> +{
> +	writew(count, jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_set_count);
> +
> +uint16_t jz4740_timer_get_count(unsigned int timer)
> +{
> +	return readw(jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_get_count);
> +
> +void jz4740_timer_ack_full(unsigned int timer)
> +{
> +	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_ack_full);
> +
> +void jz4740_timer_irq_full_enable(unsigned int timer)
> +{
> +	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
> +	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_CLEAR);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_irq_full_enable);
> +
> +void jz4740_timer_irq_full_disable(unsigned int timer)
> +{
> +	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_SET);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_irq_full_disable);
> +
> +void jz4740_timer_set_ctrl(unsigned int timer, uint16_t ctrl)
> +{
> +	writew(ctrl, jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_set_ctrl);
> +
> +uint16_t jz4740_timer_get_ctrl(unsigned int timer)
> +{
> +	return readw(jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_get_ctrl);
> +
> +void jz4740_timer_enable_watchdog(void)
> +{
> +	writel(BIT(16), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_enable_watchdog);
> +
> +void jz4740_timer_disable_watchdog(void)
> +{
> +	writel(BIT(16), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
> +}
> +EXPORT_SYMBOL_GPL(jz4740_timer_disable_watchdog);
> diff --git a/arch/mips/jz4740/timer.h b/arch/mips/jz4740/timer.h
> deleted file mode 100644
> index fca3994..0000000
> --- a/arch/mips/jz4740/timer.h
> +++ /dev/null
> @@ -1,136 +0,0 @@
> -/*
> - *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
> - *  JZ4740 platform timer support
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under  the terms of the GNU General  Public License as published by the
> - *  Free Software Foundation;  either version 2 of the License, or (at your
> - *  option) any later version.
> - *
> - *  You should have received a copy of the GNU General Public License along
> - *  with this program; if not, write to the Free Software Foundation, Inc.,
> - *  675 Mass Ave, Cambridge, MA 02139, USA.
> - *
> - */
> -
> -#ifndef __MIPS_JZ4740_TIMER_H__
> -#define __MIPS_JZ4740_TIMER_H__
> -
> -#include <linux/module.h>
> -#include <linux/io.h>
> -
> -#define JZ_REG_TIMER_STOP		0x0C
> -#define JZ_REG_TIMER_STOP_SET		0x1C
> -#define JZ_REG_TIMER_STOP_CLEAR		0x2C
> -#define JZ_REG_TIMER_ENABLE		0x00
> -#define JZ_REG_TIMER_ENABLE_SET		0x04
> -#define JZ_REG_TIMER_ENABLE_CLEAR	0x08
> -#define JZ_REG_TIMER_FLAG		0x10
> -#define JZ_REG_TIMER_FLAG_SET		0x14
> -#define JZ_REG_TIMER_FLAG_CLEAR		0x18
> -#define JZ_REG_TIMER_MASK		0x20
> -#define JZ_REG_TIMER_MASK_SET		0x24
> -#define JZ_REG_TIMER_MASK_CLEAR		0x28
> -
> -#define JZ_REG_TIMER_DFR(x) (((x) * 0x10) + 0x30)
> -#define JZ_REG_TIMER_DHR(x) (((x) * 0x10) + 0x34)
> -#define JZ_REG_TIMER_CNT(x) (((x) * 0x10) + 0x38)
> -#define JZ_REG_TIMER_CTRL(x) (((x) * 0x10) + 0x3C)
> -
> -#define JZ_TIMER_IRQ_HALF(x) BIT((x) + 0x10)
> -#define JZ_TIMER_IRQ_FULL(x) BIT(x)
> -
> -#define JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN	BIT(9)
> -#define JZ_TIMER_CTRL_PWM_ACTIVE_LOW		BIT(8)
> -#define JZ_TIMER_CTRL_PWM_ENABLE		BIT(7)
> -#define JZ_TIMER_CTRL_PRESCALE_MASK		0x1c
> -#define JZ_TIMER_CTRL_PRESCALE_OFFSET		0x3
> -#define JZ_TIMER_CTRL_PRESCALE_1		(0 << 3)
> -#define JZ_TIMER_CTRL_PRESCALE_4		(1 << 3)
> -#define JZ_TIMER_CTRL_PRESCALE_16		(2 << 3)
> -#define JZ_TIMER_CTRL_PRESCALE_64		(3 << 3)
> -#define JZ_TIMER_CTRL_PRESCALE_256		(4 << 3)
> -#define JZ_TIMER_CTRL_PRESCALE_1024		(5 << 3)
> -
> -#define JZ_TIMER_CTRL_PRESCALER(x) ((x) << JZ_TIMER_CTRL_PRESCALE_OFFSET)
> -
> -#define JZ_TIMER_CTRL_SRC_EXT		BIT(2)
> -#define JZ_TIMER_CTRL_SRC_RTC		BIT(1)
> -#define JZ_TIMER_CTRL_SRC_PCLK		BIT(0)
> -
> -extern void __iomem *jz4740_timer_base;
> -void __init jz4740_timer_init(void);
> -
> -static inline void jz4740_timer_stop(unsigned int timer)
> -{
> -	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
> -}
> -
> -static inline void jz4740_timer_start(unsigned int timer)
> -{
> -	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
> -}
> -
> -static inline bool jz4740_timer_is_enabled(unsigned int timer)
> -{
> -	return readb(jz4740_timer_base + JZ_REG_TIMER_ENABLE) & BIT(timer);
> -}
> -
> -static inline void jz4740_timer_enable(unsigned int timer)
> -{
> -	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_SET);
> -}
> -
> -static inline void jz4740_timer_disable(unsigned int timer)
> -{
> -	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_CLEAR);
> -}
> -
> -
> -static inline void jz4740_timer_set_period(unsigned int timer, uint16_t period)
> -{
> -	writew(period, jz4740_timer_base + JZ_REG_TIMER_DFR(timer));
> -}
> -
> -static inline void jz4740_timer_set_duty(unsigned int timer, uint16_t duty)
> -{
> -	writew(duty, jz4740_timer_base + JZ_REG_TIMER_DHR(timer));
> -}
> -
> -static inline void jz4740_timer_set_count(unsigned int timer, uint16_t count)
> -{
> -	writew(count, jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
> -}
> -
> -static inline uint16_t jz4740_timer_get_count(unsigned int timer)
> -{
> -	return readw(jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
> -}
> -
> -static inline void jz4740_timer_ack_full(unsigned int timer)
> -{
> -	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
> -}
> -
> -static inline void jz4740_timer_irq_full_enable(unsigned int timer)
> -{
> -	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
> -	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_CLEAR);
> -}
> -
> -static inline void jz4740_timer_irq_full_disable(unsigned int timer)
> -{
> -	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_SET);
> -}
> -
> -static inline void jz4740_timer_set_ctrl(unsigned int timer, uint16_t ctrl)
> -{
> -	writew(ctrl, jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
> -}
> -
> -static inline uint16_t jz4740_timer_get_ctrl(unsigned int timer)
> -{
> -	return readw(jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
> -}
> -
> -#endif

