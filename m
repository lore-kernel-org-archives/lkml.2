Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2IYTIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:08:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48980 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2IYTIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:08:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6846"; a="238721060"
Message-ID: <5062013F.8050507@codeaurora.org>
Date: Tue, 25 Sep 2012 12:08:47 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/2] ARM: local timers: add timer support using
 IO mapped register
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org> <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments ?

Marc, would it be possible for you to pull this into your timers-next tree ?

-Rohit

On 9/15/2012 12:41 AM, Rohit Vaswani wrote:
> The current arch_timer only support accessing through CP15 interface.
> Add support for ARM processors that only support IO mapped register
> interface. The memory mapped timer interface works with SPI
> interrupts instead of PPI.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>   .../devicetree/bindings/arm/arch_timer.txt         |    9 +-
>   arch/arm/kernel/arch_timer.c                       |  299 +++++++++++++++++++-
>   2 files changed, 297 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 52478c8..8e01328 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -7,10 +7,13 @@ The timer is attached to a GIC to deliver its per-processor interrupts.
>   
>   ** Timer node properties:
>   
> -- compatible : Should at least contain "arm,armv7-timer".
> +- compatible : Should at least contain "arm,armv7-timer" or
> +  "arm,armv7-timer-mem" if using the memory mapped arch timer interface.
>   
> -- interrupts : Interrupt list for secure, non-secure, virtual and
> -  hypervisor timers, in that order.
> +- interrupts : If using the cp15 interface, the interrupt list for secure,
> +  non-secure, virtual and hypervisor timers, in that order.
> +  If using the memory mapped interface, list the interrupts for each core,
> +  starting with core 0.
>   
>   - clock-frequency : The frequency of the main counter, in Hz. Optional.
>   
> diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
> index 8672a75..f79092d 100644
> --- a/arch/arm/kernel/arch_timer.c
> +++ b/arch/arm/kernel/arch_timer.c
> @@ -17,7 +17,9 @@
>   #include <linux/jiffies.h>
>   #include <linux/clockchips.h>
>   #include <linux/interrupt.h>
> +#include <linux/irq.h>
>   #include <linux/of_irq.h>
> +#include <linux/of_address.h>
>   #include <linux/io.h>
>   
>   #include <asm/cputype.h>
> @@ -44,6 +46,11 @@ extern void init_current_timer_delay(unsigned long freq);
>   
>   static bool arch_timer_use_virtual = true;
>   
> +static bool arch_timer_irq_percpu = true;
> +static void __iomem *timer_base;
> +static unsigned arch_timer_mem_irqs[NR_CPUS];
> +static unsigned arch_timer_num_irqs;
> +
>   /*
>    * Architected system timer support.
>    */
> @@ -56,8 +63,17 @@ static bool arch_timer_use_virtual = true;
>   #define ARCH_TIMER_REG_FREQ		1
>   #define ARCH_TIMER_REG_TVAL		2
>   
> +/* Iomapped Register Offsets */
> +static unsigned arch_timer_mem_offset[] = {0x2C, 0x10, 0x28};
> +#define ARCH_TIMER_CNTP_LOW_REG		0x0
> +#define ARCH_TIMER_CNTP_HIGH_REG	0x4
> +#define ARCH_TIMER_CNTV_LOW_REG		0x8
> +#define ARCH_TIMER_CNTV_HIGH_REG	0xC
> +
>   #define ARCH_TIMER_PHYS_ACCESS		0
>   #define ARCH_TIMER_VIRT_ACCESS		1
> +#define ARCH_TIMER_MEM_PHYS_ACCESS	2
> +#define ARCH_TIMER_MEM_VIRT_ACCESS	3
>   
>   /*
>    * These register accessors are marked inline so the compiler can
> @@ -88,6 +104,9 @@ static inline void arch_timer_reg_write(const int access, const int reg, u32 val
>   		}
>   	}
>   
> +	if (access == ARCH_TIMER_MEM_PHYS_ACCESS)
> +		__raw_writel(val, timer_base + arch_timer_mem_offset[reg]);
> +
>   	isb();
>   }
>   
> @@ -120,12 +139,16 @@ static inline u32 arch_timer_reg_read(const int access, const int reg)
>   		}
>   	}
>   
> +	if (access == ARCH_TIMER_MEM_PHYS_ACCESS)
> +		val = __raw_readl(timer_base + arch_timer_mem_offset[reg]);
> +
>   	return val;
>   }
>   
>   static inline cycle_t arch_timer_counter_read(const int access)
>   {
>   	cycle_t cval = 0;
> +	u32 cvall, cvalh, thigh;
>   
>   	if (access == ARCH_TIMER_PHYS_ACCESS)
>   		asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
> @@ -133,17 +156,49 @@ static inline cycle_t arch_timer_counter_read(const int access)
>   	if (access == ARCH_TIMER_VIRT_ACCESS)
>   		asm volatile("mrrc p15, 1, %Q0, %R0, c14" : "=r" (cval));
>   
> +	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
> +		do {
> +			cvalh = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTP_HIGH_REG);
> +			cvall = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTP_LOW_REG);
> +			thigh = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTP_HIGH_REG);
> +		} while (cvalh != thigh);
> +
> +		cval = ((cycle_t) cvalh << 32) | cvall;
> +	}
> +
> +	if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
> +		do {
> +			cvalh = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTV_HIGH_REG);
> +			cvall = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTV_LOW_REG);
> +			thigh = __raw_readl(timer_base +
> +						ARCH_TIMER_CNTV_HIGH_REG);
> +		} while (cvalh != thigh);
> +
> +		cval = ((cycle_t) cvalh << 32) | cvall;
> +	}
> +
>   	return cval;
>   }
>   
>   static inline cycle_t arch_counter_get_cntpct(void)
>   {
> -	return arch_timer_counter_read(ARCH_TIMER_PHYS_ACCESS);
> +	if (timer_base)
> +		return arch_timer_counter_read(ARCH_TIMER_MEM_PHYS_ACCESS);
> +	else
> +		return arch_timer_counter_read(ARCH_TIMER_PHYS_ACCESS);
>   }
>   
>   static inline cycle_t arch_counter_get_cntvct(void)
>   {
> -	return arch_timer_counter_read(ARCH_TIMER_VIRT_ACCESS);
> +	if (timer_base)
> +		return arch_timer_counter_read(ARCH_TIMER_MEM_VIRT_ACCESS);
> +	else
> +		return arch_timer_counter_read(ARCH_TIMER_VIRT_ACCESS);
>   }
>   
>   static irqreturn_t inline timer_handler(const int access,
> @@ -175,6 +230,13 @@ static irqreturn_t arch_timer_handler_phys(int irq, void *dev_id)
>   	return timer_handler(ARCH_TIMER_PHYS_ACCESS, evt);
>   }
>   
> +static irqreturn_t arch_timer_handler_mem(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
> +
> +	return timer_handler(ARCH_TIMER_MEM_PHYS_ACCESS, evt);
> +}
> +
>   static inline void timer_set_mode(const int access, int mode)
>   {
>   	unsigned long ctrl;
> @@ -202,6 +264,12 @@ static void arch_timer_set_mode_phys(enum clock_event_mode mode,
>   	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode);
>   }
>   
> +static void arch_timer_set_mode_mem(enum clock_event_mode mode,
> +				     struct clock_event_device *clk)
> +{
> +	timer_set_mode(ARCH_TIMER_MEM_PHYS_ACCESS, mode);
> +}
> +
>   static inline void set_next_event(const int access, unsigned long evt)
>   {
>   	unsigned long ctrl;
> @@ -227,8 +295,41 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
>   	return 0;
>   }
>   
> +static int arch_timer_set_next_event_mem(unsigned long evt,
> +					  struct clock_event_device *unused)
> +{
> +	set_next_event(ARCH_TIMER_MEM_PHYS_ACCESS, evt);
> +	return 0;
> +}
> +
> +static int __cpuinit arch_timer_mem_setup(struct clock_event_device *clk)
> +{
> +	unsigned cpu = smp_processor_id();
> +
> +	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
> +	clk->name = "arch_sys_timer";
> +	clk->rating = 450;
> +	clk->irq = arch_timer_mem_irqs[cpu];
> +	clk->set_mode = arch_timer_set_mode_mem;
> +	clk->set_next_event = arch_timer_set_next_event_mem;
> +
> +	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, NULL);
> +
> +	clockevents_config_and_register(clk, arch_timer_rate,
> +					0xf, 0x7fffffff);
> +
> +	*__this_cpu_ptr(arch_timer_evt) = clk;
> +	if (arch_timer_irq_percpu)
> +		enable_percpu_irq(arch_timer_mem_irqs[cpu], 0);
> +	else
> +		enable_irq(arch_timer_mem_irqs[cpu]);
> +
> +	return 0;
> +}
> +
>   static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
>   {
> +
>   	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
>   	clk->name = "arch_sys_timer";
>   	clk->rating = 450;
> @@ -271,11 +372,15 @@ static int arch_timer_available(void)
>   {
>   	unsigned long freq;
>   
> -	if (!local_timer_is_architected())
> +	if (!timer_base && !local_timer_is_architected())
>   		return -ENXIO;
>   
>   	if (arch_timer_rate == 0) {
> -		freq = arch_timer_reg_read(ARCH_TIMER_PHYS_ACCESS,
> +		if (timer_base)
> +			freq = arch_timer_reg_read(ARCH_TIMER_MEM_PHYS_ACCESS,
> +					   ARCH_TIMER_REG_FREQ);
> +		else
> +			freq = arch_timer_reg_read(ARCH_TIMER_PHYS_ACCESS,
>   					   ARCH_TIMER_REG_FREQ);
>   
>   		/* Check the timer frequency. */
> @@ -363,6 +468,19 @@ struct timecounter *arch_timer_get_timecounter(void)
>   	return &timecounter;
>   }
>   
> +static void __cpuinit arch_timer_mem_stop(struct clock_event_device *clk)
> +{
> +	pr_debug("%s disable IRQ%d cpu #%d\n", __func__, clk->irq,
> +						smp_processor_id());
> +
> +	if (arch_timer_irq_percpu)
> +		disable_percpu_irq(clk->irq);
> +	else
> +		disable_irq(clk->irq);
> +
> +	clk->set_mode(CLOCK_EVT_MODE_UNUSED, clk);
> +}
> +
>   static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
>   {
>   	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
> @@ -384,6 +502,11 @@ static struct local_timer_ops arch_timer_ops __cpuinitdata = {
>   	.stop	= arch_timer_stop,
>   };
>   
> +static struct local_timer_ops arch_timer_mem_ops __cpuinitdata = {
> +	.setup	= arch_timer_mem_setup,
> +	.stop	= arch_timer_mem_stop,
> +};
> +
>   static struct clock_event_device arch_timer_global_evt;
>   
>   static int __init arch_timer_register(void)
> @@ -466,11 +589,166 @@ out:
>   	return err;
>   }
>   
> +static int __init arch_timer_mem_register(void)
> +{
> +	int err, irq, i;
> +
> +	err = arch_timer_available();
> +	if (err)
> +		goto out;
> +
> +	arch_timer_evt = alloc_percpu(struct clock_event_device *);
> +	if (!arch_timer_evt) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
> +
> +	if (arch_timer_irq_percpu) {
> +		for (i = 0; i < arch_timer_num_irqs; i++) {
> +			irq = arch_timer_mem_irqs[i];
> +			err = request_percpu_irq(irq, arch_timer_handler_mem,
> +						"arch_timer", arch_timer_evt);
> +		}
> +	} else {
> +		for (i = 0; i < arch_timer_num_irqs; i++) {
> +			irq = arch_timer_mem_irqs[i];
> +			err = request_irq(irq, arch_timer_handler_mem, 0,
> +						"arch_timer",
> +						per_cpu_ptr(arch_timer_evt, i));
> +			/* Disable irq now and it will be enabled later
> +			 * in arch_timer_mem_setup which is called from
> +			 * smp code. If we don't disable it here, then we
> +			 * face unbalanced irq problem in arch_timer_mem_setup.
> +			 * Percpu irqs don't have irq depth management,
> +			 * hence they dont face this problem.
> +			 */
> +			disable_irq(irq);
> +		}
> +	}
> +
> +	if (err) {
> +		pr_err("arch_timer_mem: can't register interrupt %d (%d)\n",
> +		       irq, err);
> +		goto out_free;
> +	}
> +
> +	err = local_timer_register(&arch_timer_mem_ops);
> +	if (err) {
> +		/*
> +		 * We couldn't register as a local timer (could be
> +		 * because we're on a UP platform, or because some
> +		 * other local timer is already present...). Try as a
> +		 * global timer instead.
> +		 */
> +		arch_timer_global_evt.cpumask = cpumask_of(0);
> +		err = arch_timer_setup(&arch_timer_global_evt);
> +	}
> +
> +	percpu_timer_setup();
> +
> +	if (err)
> +		goto out_free_irq;
> +
> +	return 0;
> +
> +out_free_irq:
> +	if (arch_timer_irq_percpu)
> +		for (i = 0; i < arch_timer_num_irqs; i++)
> +			free_percpu_irq(arch_timer_mem_irqs[i], arch_timer_evt);
> +	else
> +		for (i = 0; i < arch_timer_num_irqs; i++)
> +			free_irq(arch_timer_mem_irqs[i],
> +					per_cpu(arch_timer_evt, i));
> +
> +out_free:
> +	free_percpu(arch_timer_evt);
> +out:
> +	return err;
> +}
> +
>   static const struct of_device_id arch_timer_of_match[] __initconst = {
>   	{ .compatible	= "arm,armv7-timer",	},
>   	{},
>   };
>   
> +static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
> +	{ .compatible	= "arm,armv7-timer-mem",},
> +	{},
> +};
> +
> +static inline int __init arch_timer_base_init(void)
> +{
> +	struct device_node *np;
> +
> +	if (!timer_base) {
> +		if (!of_find_matching_node(NULL, arch_timer_of_match)) {
> +			np = of_find_matching_node(NULL,
> +						arch_timer_mem_of_match);
> +			if (!np) {
> +				pr_err("arch_timer: can't find armv7-timer-mem DT node\n");
> +				return -ENODEV;
> +			}
> +
> +			if (of_get_address(np, 0, NULL, NULL)) {
> +				timer_base = of_iomap(np, 0);
> +				if (!timer_base) {
> +					pr_err("arch_timer: cant map timer base\n");
> +					return	-ENOMEM;
> +				}
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
> +static int __init arch_timer_mem_of_register(void)
> +{
> +	struct device_node *np;
> +	u32 freq;
> +	int i, ret, irq;
> +	arch_timer_num_irqs = num_possible_cpus();
> +
> +	np = of_find_matching_node(NULL, arch_timer_mem_of_match);
> +	if (!np) {
> +		pr_err("arch_timer: can't find armv7-timer-mem DT node\n");
> +		return -ENODEV;
> +	}
> +
> +	arch_timer_use_virtual = false;
> +
> +	/* Try to determine the frequency from the device tree or CNTFRQ */
> +	if (!of_property_read_u32(np, "clock-frequency", &freq))
> +		arch_timer_rate = freq;
> +
> +	for (i = 0; i < arch_timer_num_irqs; i++) {
> +		arch_timer_mem_irqs[i] = irq = irq_of_parse_and_map(np, i);
> +		if (!irq)
> +			break;
> +	}
> +
> +	if (!irq_is_per_cpu(arch_timer_ppi[0]))
> +		arch_timer_irq_percpu = false;
> +
> +	ret = arch_timer_base_init();
> +	if (ret)
> +		return ret;
> +
> +	ret =  arch_timer_mem_register();
> +	if (ret)
> +		arch_timer_base_free();
> +
> +	return ret;
> +}
> +
>   int __init arch_timer_of_register(void)
>   {
>   	struct device_node *np;
> @@ -479,8 +757,8 @@ int __init arch_timer_of_register(void)
>   
>   	np = of_find_matching_node(NULL, arch_timer_of_match);
>   	if (!np) {
> -		pr_err("arch_timer: can't find DT node\n");
> -		return -ENODEV;
> +		pr_debug("arch_timer: can't find DT node for armv7-timer, falling back to memory mapped arch timer\n");
> +		return arch_timer_mem_of_register();
>   	}
>   
>   	/* Try to determine the frequency from the device tree or CNTFRQ */
> @@ -496,7 +774,6 @@ int __init arch_timer_of_register(void)
>   	 */
>   	if (!arch_timer_ppi[VIRT_PPI]) {
>   		arch_timer_use_virtual = false;
> -
>   		if (!arch_timer_ppi[PHYS_SECURE_PPI] ||
>   		    !arch_timer_ppi[PHYS_NONSECURE_PPI]) {
>   			pr_warn("arch_timer: No interrupt available, giving up\n");
> @@ -512,10 +789,16 @@ int __init arch_timer_sched_clock_init(void)
>   	u32 (*cnt32)(void);
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
>   	if (arch_timer_use_virtual)
>   		cnt32 = arch_counter_get_cntvct32;
>   	else


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

