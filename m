Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2HKClB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 22:41:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34070 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab2HKCk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 22:40:59 -0400
Message-ID: <5025C62B.10407@ti.com>
Date: Fri, 10 Aug 2012 22:40:43 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: <marc.zyngier@arm.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <linux-arm-msm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: local timers: add timer support using IO mapped
 register
References: <1344635921-5147-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1344635921-5147-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2012 5:58 PM, Rohit Vaswani wrote:
> The current arch_timer only support accessing through CP15 interface.
> Add support for ARM processors that only support IO mapped register
> interface
>

It looks like this patch attempts to address both (a) non-percpu arch 
timers, and (b) memory mapped arch timers in one go.  These should 
probably be broken out into two distinct logical changes.

More below...

> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>   .../devicetree/bindings/arm/arch_timer.txt         |    7 +
>   arch/arm/kernel/arch_timer.c                       |  259 ++++++++++++++++----
>   2 files changed, 223 insertions(+), 43 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 52478c8..1c71799 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -14,6 +14,13 @@ The timer is attached to a GIC to deliver its per-processor interrupts.
>
>   - clock-frequency : The frequency of the main counter, in Hz. Optional.
>
> +- irq-is-not-percpu: Specify is the timer irq is *NOT* a percpu (PPI) interrupt
> +  In the default case i.e without this property, the timer irq is treated as a
> +  PPI interrupt. Optional.
> +

The handling of non-percpu IRQs looks broken.  The code does 
(enable/disable)_percpu_irq() on IRQs that may no longer be percpu.

> +- If the node address and reg is specified, the arch_timer will try to use the memory
> +  mapped timer. Optional.
> +
>   Example:
>
>   	timer {
> diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
> index 1d0d9df..09604b7 100644
> --- a/arch/arm/kernel/arch_timer.c
> +++ b/arch/arm/kernel/arch_timer.c
> @@ -18,6 +18,7 @@
>   #include <linux/clockchips.h>
>   #include <linux/interrupt.h>
>   #include <linux/of_irq.h>
> +#include <linux/of_address.h>
>   #include <linux/io.h>
>
>   #include <asm/cputype.h>
> @@ -29,8 +30,17 @@
>   static unsigned long arch_timer_rate;
>   static int arch_timer_ppi;
>   static int arch_timer_ppi2;
> +static int is_irq_percpu;
>
>   static struct clock_event_device __percpu **arch_timer_evt;
> +static void __iomem *timer_base;
> +

Are percpu memory mapped arch timers an impossibility?

> +struct arch_timer_operations {
> +	void (*reg_write)(int, u32);
> +	u32 (*reg_read)(int);
> +	cycle_t (*get_cntpct)(void);
> +	cycle_t (*get_cntvct)(void);
> +};
>
>   /*
>    * Architected system timer support.
> @@ -44,7 +54,29 @@ static struct clock_event_device __percpu **arch_timer_evt;
>   #define ARCH_TIMER_REG_FREQ		1
>   #define ARCH_TIMER_REG_TVAL		2
>
> -static void arch_timer_reg_write(int reg, u32 val)
> +/* Iomapped Register Offsets */
> +#define ARCH_TIMER_CNTP_LOW_REG		0x000
> +#define ARCH_TIMER_CNTP_HIGH_REG	0x004
> +#define ARCH_TIMER_CNTV_LOW_REG		0x008
> +#define ARCH_TIMER_CNTV_HIGH_REG	0x00C
> +#define ARCH_TIMER_CTRL_REG		0x02C
> +#define ARCH_TIMER_FREQ_REG		0x010
> +#define ARCH_TIMER_CNTP_TVAL_REG	0x028
> +#define ARCH_TIMER_CNTV_TVAL_REG	0x038
> +

ARCH_TIMER_CNTV_TVAL_REG appears to be unused here.

> +static void timer_reg_write_mem(int reg, u32 val)
> +{
> +	switch (reg) {
> +	case ARCH_TIMER_REG_CTRL:
> +		__raw_writel(val, timer_base + ARCH_TIMER_CTRL_REG);
> +		break;
> +	case ARCH_TIMER_REG_TVAL:
> +		__raw_writel(val, timer_base + ARCH_TIMER_CNTP_TVAL_REG);
> +		break;
> +	}
> +}
> +

Wouldn't an array of offsets to map from ARCH_TIMER_REG_* to these 
memory mapped registers eliminate the need to switch-case your way 
through each register?

> +static void timer_reg_write_cp15(int reg, u32 val)
>   {
>   	switch (reg) {
>   	case ARCH_TIMER_REG_CTRL:
> @@ -58,7 +90,28 @@ static void arch_timer_reg_write(int reg, u32 val)
>   	isb();
>   }
>
> -static u32 arch_timer_reg_read(int reg)
> +static u32 timer_reg_read_mem(int reg)
> +{
> +	u32 val;
> +
> +	switch (reg) {
> +	case ARCH_TIMER_REG_CTRL:
> +		val = __raw_readl(timer_base + ARCH_TIMER_CTRL_REG);
> +		break;
> +	case ARCH_TIMER_REG_FREQ:
> +		val = __raw_readl(timer_base + ARCH_TIMER_FREQ_REG);
> +		break;
> +	case ARCH_TIMER_REG_TVAL:
> +		val = __raw_readl(timer_base + ARCH_TIMER_CNTP_TVAL_REG);
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	return val;
> +}
> +

Same as above.

> +static u32 timer_reg_read_cp15(int reg)
>   {
>   	u32 val;
>
> @@ -79,6 +132,103 @@ static u32 arch_timer_reg_read(int reg)
>   	return val;
>   }
>
> +static cycle_t arch_counter_get_cntpct_mem(void)
> +{
> +	u32 cvall, cvalh, thigh;
> +
> +	do {
> +		cvalh = __raw_readl(timer_base + ARCH_TIMER_CNTP_HIGH_REG);
> +		cvall = __raw_readl(timer_base + ARCH_TIMER_CNTP_LOW_REG);
> +		thigh = __raw_readl(timer_base + ARCH_TIMER_CNTP_HIGH_REG);
> +	} while (cvalh != thigh);
> +
> +	return ((cycle_t) cvalh << 32) | cvall;
> +}
> +
> +static cycle_t arch_counter_get_cntpct_cp15(void)
> +{
> +	u32 cvall, cvalh;
> +
> +	asm volatile("mrrc p15, 0, %0, %1, c14" : "=r" (cvall), "=r" (cvalh));
> +
> +	return ((cycle_t) cvalh << 32) | cvall;
> +}
> +
> +static cycle_t arch_counter_get_cntvct_mem(void)
> +{
> +	u32 cvall, cvalh, thigh;
> +
> +	do {
> +		cvalh = __raw_readl(timer_base + ARCH_TIMER_CNTV_HIGH_REG);
> +		cvall = __raw_readl(timer_base + ARCH_TIMER_CNTV_LOW_REG);
> +		thigh = __raw_readl(timer_base + ARCH_TIMER_CNTV_HIGH_REG);
> +	} while (cvalh != thigh);
> +
> +	return ((cycle_t) cvalh << 32) | cvall;
> +}
> +

Repetitive - the logic is identical to arch_counter_get_cntpct_mem() above.

> +static cycle_t arch_counter_get_cntvct_cp15(void)
> +{
> +	u32 cvall, cvalh;
> +
> +	asm volatile("mrrc p15, 1, %0, %1, c14" : "=r" (cvall), "=r" (cvalh));
> +
> +	return ((cycle_t) cvalh << 32) | cvall;
> +}
> +
> +static struct arch_timer_operations arch_timer_ops_cp15 = {
> +	.reg_read = &timer_reg_read_cp15,
> +	.reg_write = &timer_reg_write_cp15,
> +	.get_cntpct = &arch_counter_get_cntpct_cp15,
> +	.get_cntvct = &arch_counter_get_cntvct_cp15,
> +};
> +
> +static struct arch_timer_operations arch_timer_ops_mem = {
> +	.reg_read = &timer_reg_read_mem,
> +	.reg_write = &timer_reg_write_mem,
> +	.get_cntpct = &arch_counter_get_cntpct_mem,
> +	.get_cntvct = &arch_counter_get_cntvct_mem,
> +};
> +
> +static struct arch_timer_operations *arch_specific_timer = &arch_timer_ops_cp15;
> +
> +static inline void arch_timer_reg_write(int reg, u32 val)
> +{
> +	arch_specific_timer->reg_write(reg, val);
> +}
> +
> +static inline u32 arch_timer_reg_read(int reg)
> +{
> +	return arch_specific_timer->reg_read(reg);
> +}
> +
> +static inline cycle_t arch_counter_get_cntpct(void)
> +{
> +	return arch_specific_timer->get_cntpct();
> +}
> +
> +static inline cycle_t arch_counter_get_cntvct(void)
> +{
> +	return arch_specific_timer->get_cntvct();
> +}
> +

The 4 pointer chasers above could lose some verbosity by being #defines.

> +static u32 notrace arch_counter_get_cntvct32(void)
> +{
> +	cycle_t cntvct = arch_counter_get_cntpct();

Shouldn't that be arch_counter_get_cntvct() instead?

> +
> +	/*
> +	 * The sched_clock infrastructure only knows about counters
> +	 * with at most 32bits. Forget about the upper 24 bits for the
> +	 * time being...
> +	 */
> +	return (u32)(cntvct & (u32)~0);
> +}
> +
> +static cycle_t arch_counter_read(struct clocksource *cs)
> +{
> +	return arch_counter_get_cntpct();
> +}
> +

Did the code really need to be moved around?  Some of the functions in 
this file appear to be entirely unchanged, but show up as both added and 
removed lines.

>   static irqreturn_t arch_timer_handler(int irq, void *dev_id)
>   {
>   	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
> @@ -167,7 +317,9 @@ static int arch_timer_available(void)
>   {
>   	unsigned long freq;
>
> -	if (!local_timer_is_architected())
> +	if (timer_base)
> +		arch_specific_timer = &arch_timer_ops_mem;
> +	else if (!local_timer_is_architected())
>   		return -ENXIO;
>
>   	if (arch_timer_rate == 0) {
> @@ -188,41 +340,6 @@ static int arch_timer_available(void)
>   	return 0;
>   }
>
> -static inline cycle_t arch_counter_get_cntpct(void)
> -{
> -	u32 cvall, cvalh;
> -
> -	asm volatile("mrrc p15, 0, %0, %1, c14" : "=r" (cvall), "=r" (cvalh));
> -
> -	return ((cycle_t) cvalh << 32) | cvall;
> -}
> -
> -static inline cycle_t arch_counter_get_cntvct(void)
> -{
> -	u32 cvall, cvalh;
> -
> -	asm volatile("mrrc p15, 1, %0, %1, c14" : "=r" (cvall), "=r" (cvalh));
> -
> -	return ((cycle_t) cvalh << 32) | cvall;
> -}
> -
> -static u32 notrace arch_counter_get_cntvct32(void)
> -{
> -	cycle_t cntvct = arch_counter_get_cntvct();
> -
> -	/*
> -	 * The sched_clock infrastructure only knows about counters
> -	 * with at most 32bits. Forget about the upper 24 bits for the
> -	 * time being...
> -	 */
> -	return (u32)(cntvct & (u32)~0);
> -}
> -
> -static cycle_t arch_counter_read(struct clocksource *cs)
> -{
> -	return arch_counter_get_cntpct();
> -}
> -
>   static struct clocksource clocksource_counter = {
>   	.name	= "arch_sys_counter",
>   	.rating	= 400,
> @@ -262,8 +379,12 @@ static int __init arch_timer_register(void)
>
>   	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
>
> -	err = request_percpu_irq(arch_timer_ppi, arch_timer_handler,
> +	if (is_irq_percpu)
> +		err = request_percpu_irq(arch_timer_ppi, arch_timer_handler,
>   				 "arch_timer", arch_timer_evt);
> +	else
> +		err = request_irq(arch_timer_ppi, arch_timer_handler, 0,
> +			"arch_timer", arch_timer_evt);
>   	if (err) {
>   		pr_err("arch_timer: can't register interrupt %d (%d)\n",
>   		       arch_timer_ppi, err);
> @@ -271,8 +392,13 @@ static int __init arch_timer_register(void)
>   	}
>
>   	if (arch_timer_ppi2) {
> -		err = request_percpu_irq(arch_timer_ppi2, arch_timer_handler,
> -					 "arch_timer", arch_timer_evt);
> +		if (is_irq_percpu)
> +			err = request_percpu_irq(arch_timer_ppi2,
> +					arch_timer_handler, "arch_timer",
> +					arch_timer_evt);
> +		else
> +			err = request_irq(arch_timer_ppi2, arch_timer_handler,
> +					0, "arch_timer", arch_timer_evt);
>   		if (err) {
>   			pr_err("arch_timer: can't register interrupt %d (%d)\n",
>   			       arch_timer_ppi2, err);
> @@ -314,10 +440,40 @@ static const struct of_device_id arch_timer_of_match[] __initconst = {
>   	{},
>   };
>
> +static int __init arch_timer_base_init(void)
> +{
> +	struct device_node *np;
> +
> +	if (!timer_base) {
> +		np = of_find_matching_node(NULL, arch_timer_of_match);
> +		if (!np) {
> +			pr_err("arch_timer: can't find DT node\n");
> +			return -ENODEV;
> +		}
> +
> +		if (of_get_address(np, 0, NULL, NULL)) {
> +			timer_base = of_iomap(np, 0);
> +			if (!timer_base) {
> +				pr_err("arch_timer: cant map timer base\n");
> +				return -ENOMEM;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void __init arch_timer_base_free(void)
> +{
> +	if (timer_base)
> +		iounmap(timer_base);
> +}
> +
>   int __init arch_timer_of_register(void)
>   {
>   	struct device_node *np;
>   	u32 freq;
> +	int ret;
>
>   	np = of_find_matching_node(NULL, arch_timer_of_match);
>   	if (!np) {
> @@ -331,20 +487,37 @@ int __init arch_timer_of_register(void)
>
>   	arch_timer_ppi = irq_of_parse_and_map(np, 0);
>   	arch_timer_ppi2 = irq_of_parse_and_map(np, 1);
> +
> +	ret = arch_timer_base_init();
> +	if (ret)
> +		return ret;
> +
> +	is_irq_percpu = !(of_property_read_bool(np, "irq-is-not-percpu"));
> +
>   	pr_info("arch_timer: found %s irqs %d %d\n",
>   		np->name, arch_timer_ppi, arch_timer_ppi2);
>
> -	return arch_timer_register();
> +	ret = arch_timer_register();
> +	if (ret)
> +		arch_timer_base_free();
> +
> +	return ret;
>   }
>
>   int __init arch_timer_sched_clock_init(void)
>   {
>   	int err;
>
> -	err = arch_timer_available();
> +	err = arch_timer_base_init();
>   	if (err)
>   		return err;
>
> +	err = arch_timer_available();
> +	if (err) {
> +		arch_timer_base_free();
> +		return err;
> +	}
> +
>   	setup_sched_clock(arch_counter_get_cntvct32, 32, arch_timer_rate);
>   	return 0;
>   }
>

-- 
Cheers
- Cyril
