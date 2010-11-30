Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0K3Qya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:54:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49891 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0K3QyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:54:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: [PATCH] Unicore architecture patch review, part 2
Date: Tue, 30 Nov 2010 17:54:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011301754.17829.arnd@arndb.de>
X-Provags-ID: V02:K0:ozuJsi9gj7s/PziG9z6w1Jrt9xGOt1ylF6yAZs+3rjx
 WCo/JS/f61t9CZuBwie3PsEZ0K2hshsxvB5Hkxb+PzLnxOWx0J
 9qH/IBgNsAAhES4Acfm53hMUCENGFK7Q3Y72uCmOhGxgdaSZxy
 pnK/zoHK0edscbuSpeZDkXGJ4e4rMJZC3wEtrIj0Tmwmf95VVZ
 2XVR+XSiKuTHnu9OHmkxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second part of my review of the architecture, based on the
revised patch at
http://mprc.pku.edu.cn/~guanxuetao/linux/2.6.37/patch-2.6.37-rc2-uc32-gxt2-arch.bz2

I'm skipping the parts that I commented in the first review, but will
look at them again once we have resolved the points raised in this review
and Guan Xuetao posts the series to the mailing list.

The recurring theme with the unicore code is that it uses unnecessary
abstractions because it copies code from other architectures, mainly
the ARM tree, but does not actually require the complexity of the
original code. All the code that is required does seem to be there
and looks quite good for the most part, but there are substantial
parts that should just not be included.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/bios32.c linux-2.6.37.y/arch/unicore32/kernel/bios32.c
> --- linux-2.6.37-rc2/arch/unicore32/kernel/bios32.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/bios32.c	2010-11-19 14:39:26.102176502 +0800
> @@ -0,0 +1,505 @@
> +/*
> + * linux/arch/unicore32/kernel/bios32.c
> + *

The name of this file is somewhat misleading, it seems to refer to the
way that x86 originally did this using BIOS calls, which is not the case
on unicore. I would just name it pci.c.

> +void pcibios_report_status(u_int status_mask, int warn)
> +{
> +	struct list_head *l;
> +
> +	list_for_each(l, &pci_root_buses) {
> +		struct pci_bus *bus = pci_bus_b(l);
> +
> +		pcibios_bus_report_status(bus, status_mask, warn);
> +	}
> +}

Does not seem to be used anywhere, just remove this and
pcibios_bus_report_status.

> +/*
> + * PCI IDE controllers use non-standard I/O port decoding, respect it.
> + */
> +static void __devinit pci_fixup_ide_bases(struct pci_dev *dev)
> +{
> +	struct resource *r;
> +	int i;
> +
> +	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
> +		return;
> +
> +	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +		r = dev->resource + i;
> +		if ((r->start & ~0x80) == 0x374) {
> +			r->start |= 2;
> +			r->end = r->start;
> +		}
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_ide_bases);

This seems to be specific to some ARM IDE controller, I don't think
you need it here.

> +/*
> + * Swizzle the device pin each time we cross a bridge.
> + * This might update pin and returns the slot number.
> + */
> +static u8 __devinit pcibios_swizzle(struct pci_dev *dev, u8 *pin)
> +{
> +	struct pci_sys_data *sys = dev->sysdata;
> +	int slot = 0, oldpin = *pin;
> +
> +	if (sys->swizzle)
> +		slot = sys->swizzle(dev, pin);
> +
> +	if (debug_pci)
> +		printk(KERN_DEFAULT "PCI: %s swizzling pin %d => pin %d slot %d\n",
> +			pci_name(dev), oldpin, *pin, slot);
> +
> +	return slot;
> +}

As I mentioned when discussing the header files, the pci_sys_data
abstraction is not useful on unicore, since you only have one
PCI controller.

> +
> +static void __init pcibios_init_hw(struct hw_pci *hw)
> +{
> +	struct pci_sys_data *sys = NULL;
> +	int ret;
> +	int nr, busnr;
> +
> +	for (nr = busnr = 0; nr < hw->nr_controllers; nr++) {
> +		sys = kzalloc(sizeof(struct pci_sys_data), GFP_KERNEL);
> +		if (!sys)
> +			panic("PCI: unable to allocate sys data!");
> +
> +#ifdef CONFIG_PCI_DOMAINS
> +		sys->domain  = hw->domain;
> +#endif
> +		sys->hw      = hw;
> +		sys->busnr   = busnr;
> +		sys->swizzle = hw->swizzle;
> +		sys->map_irq = hw->map_irq;
> +		sys->resource[0] = &ioport_resource;
> +		sys->resource[1] = &iomem_resource;

Also all the hw_pci abstraction, which adds another indirection here.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/calls.S linux-2.6.37.y/arch/unicore32/kernel/calls.S
> --- linux-2.6.37-rc2/arch/unicore32/kernel/calls.S	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/calls.S	2010-11-19 14:33:16.973569009 +0800
> @@ -0,0 +1,390 @@
> +/* 0 */		CALL(sys_restart_syscall)
> +		CALL(sys_exit)
> +		CALL(sys_fork_wrapper)
> +		CALL(sys_read)
> +		CALL(sys_write)
> +/* 5 */		CALL(sys_open)
> +		CALL(sys_close)

When you start using the generic unistd.h file, you can also replace
this table with something like arch/tile/kernel/sys.c.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/elf.c linux-2.6.37.y/arch/unicore32/kernel/elf.c
> --- linux-2.6.37-rc2/arch/unicore32/kernel/elf.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/elf.c	2010-11-19 14:32:14.295934503 +0800
> +void elf_set_personality(const struct elf32_hdr *x)
> +{
> +	unsigned int personality = PER_LINUX_32BIT;
> +
> +	set_personality(personality);
> +}
> +EXPORT_SYMBOL(elf_set_personality);

This should set PER_LINUX for the native personality, not
PER_LINUX_32BIT.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/irq.c linux-2.6.37.y/arch/unicore32/kernel/irq.c
> --- linux-2.6.37-rc2/arch/unicore32/kernel/irq.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/irq.c	2010-11-19 14:32:27.927456589 +0800
> +
> +/*
> + * No architecture-specific irq_finish function defined in unicore/arch/irqs.h.
> + */
> +#ifndef irq_finish
> +#define irq_finish(irq) do { } while (0)
> +#endif

Then just remove irq_finish.

> +void __init init_IRQ(void)
> +{
> +	puv3_init_irq();
> +}

This also looks unnecessary, just rename puv3_init_irq to init_IRQ.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/process.c linux-2.6.37.y/arch/unicore32/kernel/process.c
> --- linux-2.6.37-rc2/arch/unicore32/kernel/process.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/process.c	2010-11-19 14:32:38.032011777 +0800
> +
> +extern void setup_mm_for_reboot(char mode);

Please move all extern declarations to header files.

> +static volatile int hlt_counter;
> +
> +void disable_hlt(void)
> +{
> +	hlt_counter++;
> +}
> +EXPORT_SYMBOL(disable_hlt);
> +
> +void enable_hlt(void)
> +{
> +	hlt_counter--;
> +}
> +EXPORT_SYMBOL(enable_hlt);
> +
> +static int __init nohlt_setup(char *__unused)
> +{
> +	hlt_counter = 1;
> +	return 1;
> +}
> +
> +static int __init hlt_setup(char *__unused)
> +{
> +	hlt_counter = 0;
> +	return 1;
> +}
> +
> +__setup("nohlt", nohlt_setup);
> +__setup("hlt", hlt_setup);

I don't think disable_hlt is used anywhere, it's rather x86 specific,
so I'd just drop it.

> +/*
> + * Function pointers to optional machine specific functions
> + */
> +void (*pm_power_off)(void);
> +EXPORT_SYMBOL(pm_power_off);
> +
> +void (*uc32_pm_restart)(char str, const char *cmd) = uc32_machine_restart;
> +EXPORT_SYMBOL_GPL(uc32_pm_restart);
> +
> +static void do_nothing(void *unused)
> +{
> +}
> +
> +/*
> + * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
> + * pm_idle and update to new pm_idle value. Required while changing pm_idle
> + * handler on SMP systems.
> + *
> + * Caller must have changed pm_idle to the new value before the call. Old
> + * pm_idle value will not be used by any CPU after the return of this function.
> + */
> +void cpu_idle_wait(void)
> +{
> +	smp_mb();
> +	/* kick all the CPUs so that they exit out of pm_idle */
> +	smp_call_function(do_nothing, NULL, 1);
> +}
> +EXPORT_SYMBOL_GPL(cpu_idle_wait);
> +
> +/*
> + * This is our default idle handler.  We need to disable
> + * interrupts here to ensure we don't miss a wakeup call.
> + */
> +static void default_idle(void)
> +{
> +	if (!need_resched())
> +		cpu_do_idle();
> +	local_irq_enable();
> +}
> +
> +void (*pm_idle)(void) = default_idle;
> +EXPORT_SYMBOL(pm_idle);

All of these can probably go away, since the code is not dynamic on
unicore.

> +extern void kernel_thread_helper(void);

Another extern that should be in a header.

> +unsigned int processor_id;
> +EXPORT_SYMBOL(processor_id);
> +
> +unsigned int system_rev;
> +EXPORT_SYMBOL(system_rev);
> +
> +unsigned int system_serial_low;
> +EXPORT_SYMBOL(system_serial_low);
> +
> +unsigned int system_serial_high;
> +EXPORT_SYMBOL(system_serial_high);
> +
> +unsigned int elf_hwcap;
> +EXPORT_SYMBOL(elf_hwcap);

Do you need to export these symbols? AFAICT they are only
used in nonmodular code.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/kernel/time.c linux-2.6.37.y/arch/unicore32/kernel/time.c
> --- linux-2.6.37-rc2/arch/unicore32/kernel/time.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/kernel/time.c	2010-11-19 14:32:59.439093890 +0800
> +/*
> + * Our system timer.
> + */
> +struct sys_timer *system_timer;
> +
> +#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
> +/* this needs a better home */
> +DEFINE_SPINLOCK(rtc_lock);
> +
> +#ifdef CONFIG_RTC_DRV_CMOS_MODULE
> +EXPORT_SYMBOL(rtc_lock);
> +#endif
> +#endif	/* pc-style 'CMOS' RTC support */

Do you have a PC-stype CMOS RTC or is this just copied from ARM?
The symbol is disabled in defconfig, so I expect you don't need this.

> +#ifndef CONFIG_GENERIC_CLOCKEVENTS
> +/*
> + * Kernel system timer support.
> + */
> +void timer_tick(void)
> +{
> +	profile_tick(CPU_PROFILING);
> +	write_seqlock(&xtime_lock);
> +	do_timer(1);
> +	write_sequnlock(&xtime_lock);
> +	update_process_times(user_mode(get_irq_regs()));
> +}
> +#endif
> +
> +#if defined(CONFIG_PM) && !defined(CONFIG_GENERIC_CLOCKEVENTS)
> +static int timer_suspend(struct sys_device *dev, pm_message_t state)
> +{
> +	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
> +
> +	if (timer->suspend != NULL)
> +		timer->suspend();
> +
> +	return 0;
> +}
> +
> +static int timer_resume(struct sys_device *dev)
> +{
> +	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
> +
> +	if (timer->resume != NULL)
> +		timer->resume();
> +
> +	return 0;
> +}
> +#else
> +#define timer_suspend NULL
> +#define timer_resume NULL
> +#endif
> +
> +static struct sysdev_class timer_sysclass = {
> +	.name		= "timer",
> +	.suspend	= timer_suspend,
> +	.resume		= timer_resume,
> +};
> +
> +static int __init timer_init_sysfs(void)
> +{
> +	int ret = sysdev_class_register(&timer_sysclass);
> +	if (ret == 0) {
> +		system_timer->dev.cls = &timer_sysclass;
> +		ret = sysdev_register(&system_timer->dev);
> +	}
> +
> +	return ret;
> +}
> +
> +device_initcall(timer_init_sysfs);
> +
> +void __init time_init(void)
> +{
> +	system_timer->init();
> +}

AFAICT, you can remove all this if you just use GENERIC_CLOCKEVENT
unconditionally.

> + * Handle all unrecognised system calls.
> + *  0x9f0000 - 0x9fffff are some more esoteric system calls
> + */
> +#define NR(x) ((__UNICORE_NR_##x) - __UNICORE_NR_BASE)
> +asmlinkage int uc32_syscall(int no, struct pt_regs *regs)

This function looks very obscure and it seems to deal with
legacy ARM issues that were copied here.

Better make the unicore specific interfaces regular syscalls
(sys_breakpoint, sys_cacheflush, sys_cmpxchg, ...).

> +	info.si_signo = SIGILL;
> +	info.si_errno = 0;
> +	info.si_code  = ILL_ILLTRP;
> +	info.si_addr  = (void __user *)instruction_pointer(regs) - 4;
> +
> +	uc32_notify_die("Oops - bad syscall(2)", regs, &info, no, 0);
> +	return 0;
> +}

This is unusual. If a syscall is not implemented, just return -ENOSYS,
rather than sending a signal.

> +void __bad_xchg(volatile void *ptr, int size)
> +{
> +	printk(KERN_DEFAULT "xchg: bad data size: pc 0x%p, ptr 0x%p, size %d\n",
> +		__builtin_return_address(0), ptr, size);
> +	BUG();
> +}
> +EXPORT_SYMBOL(__bad_xchg);

The idea of this function is to cause a link error if it ever
gets called, so you must have no definition in the code!

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/lib/copy_template.S linux-2.6.37.y/arch/unicore32/lib/copy_template.S
> --- linux-2.6.37-rc2/arch/unicore32/lib/copy_template.S	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/lib/copy_template.S	2010-11-16 18:30:56.013566876 +0800
> @@ -0,0 +1,214 @@
> +/*
> + * linux/arch/unicore32/lib/copy_template.S

This is a copy of the ARM-optimized memcpy code. Is it really better
than the libgcc version on unicore?

A similar question can be asked for much of the assembly code in
arch/unicore/lib. The code is rather old and compilers have gotten
a lot better in the meantime, so I could imagine that you'd be
better off just using the C versions.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/lib/delay.S linux-2.6.37.y/arch/unicore32/lib/delay.S
> --- linux-2.6.37-rc2/arch/unicore32/lib/delay.S	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/lib/delay.S	2010-11-16 18:30:56.015567130 +0800
> +
> +/*
> + * loops = r0 * HZ * loops_per_jiffy / 1000000
> + *
> + * Oh, if only we had a cycle counter...
> + */
> +
> +@ Delay routine
> +ENTRY(__delay)
> +		sub.a	r0, r0, #2
> +		bua	__delay
> +		mov	pc, lr
> +ENDPROC(__udelay)

Hmm, when the architecture was being defined, why didn't you ask
for a cycle counter? It really improves the delay code a lot.

If you have a good time base by now, you should use it. Is the
OST_OSCR something you could use here?

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mach-puv3/clock.c linux-2.6.37.y/arch/unicore32/mach-puv3/clock.c
> --- linux-2.6.37-rc2/arch/unicore32/mach-puv3/clock.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mach-puv3/clock.c	2010-11-16 18:30:56.020566930 +0800
> @@ -0,0 +1,389 @@
> +/*
> + * linux/arch/unicore32/mach-puv3/clock.c

I would not plan to have multiple mach- directories if you only need one
today. It makes sense on ARM, which has dozens of different machines,
but in your case, I would hope that you control it well enough to
keep machines mostly compatible with each other.

If you start seeing incompatible SoCs in the future, the chances are
quite high that the level of abstraction does not match the differences
between them well. In particular, we are currently trying very hard
to get ARM into a state where you can build one kernel that uses
multiple machine directories together. If you do this right from
the start, it will be much easier.

> +/*
> + * Very simple clock implementation
> + */
> +struct clk {
> +	struct list_head	node;
> +	unsigned long		rate;
> +	const char		*name;
> +};

There are currently patches under discussion for the ARM architecture
that unify the various struct clk definitions. It probably makes
sense for you to use the same definition.

> +		switch (rate) {
> +		case  25175000: pll_vgacfg = 0x00002001; pll_vgadiv = 0x9; break; /* 640x480@60  250M/10 */
> +		case  31500000: pll_vgacfg = 0x00002001; pll_vgadiv = 0x7; break; /* 640x480@75  250M/ 8 */
> +		case  40000000: pll_vgacfg = 0x00003801; pll_vgadiv = 0x9; break; /* 800x600@60  400M/10 */
> +		case  49500000: pll_vgacfg = 0x00003801; pll_vgadiv = 0x7; break; /* 800x600@75  400M/ 8 */
> +		case  65000000: pll_vgacfg = 0x00002c01; pll_vgadiv = 0x4; break; /* 1024x768@60 325M/ 5 */
> +		case  78750000: pll_vgacfg = 0x00002400; pll_vgadiv = 0x7; break; /* 1024x768@75 550M/ 8 */
> +		case 108000000: pll_vgacfg = 0x00002c01; pll_vgadiv = 0x2; break; /* 1280x960@60 325M/ 3 */
> +		case 106500000: pll_vgacfg = 0x00003c01; pll_vgadiv = 0x3; break; /* 1440x900@60 425M/ 4 */
> +		case  50650000: pll_vgacfg = 0x00106400; pll_vgadiv = 0x9; break; /* 1024x600@60 400M/10 */
> +		case  61500000: pll_vgacfg = 0x00106400; pll_vgadiv = 0xa; break; /* 1024x600@75 675M/11 */
> +		case  85500000: pll_vgacfg = 0x00002800; pll_vgadiv = 0x6; break; /* 1366x768@60 600M/ 7 */
> +		default: return -EINVAL;
> +		}

It's usually more efficient to turn code like this into table lookups,
like

struct {
	unsigned int rate;
	unsigned int cfg;
	unsigned int div;
} vga_clk_table = {
	{ .rate = 25175000, .cfg = 0x00002001, .div = 0x9 }, /*	640x480@60  250M/10 */
	...
};

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mach-puv3/core.c linux-2.6.37.y/arch/unicore32/mach-puv3/core.c
> --- linux-2.6.37-rc2/arch/unicore32/mach-puv3/core.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mach-puv3/core.c	2010-11-19 17:55:34.949943687 +0800
> +static struct resource puv3_usb_resources[] = {
> +	/* order is significant! */
> +	{
> +		.start		= PKUNITY_USB_BASE,
> +		.end		= PKUNITY_USB_BASE + 0x3ff,
> +		.flags		= IORESOURCE_MEM,
> +	}, {
> +		.start		= IRQ_USB,
> +		.flags		= IORESOURCE_IRQ,
> +	}, {
> +		.start		= IRQ_USB,
> +		.flags		= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct musb_hdrc_config	puv3_usb_config[] = {
> +	{
> +		.num_eps = 16,
> +		.multipoint = 1,
> +#ifdef CONFIG_USB_INVENTRA_DMA
> +		.dma = 1,
> +		.dma_channels = 8,
> +#endif
> +	},
> +};
> +
> +static struct musb_hdrc_platform_data puv3_usb_plat = {
> +	.mode		= MUSB_HOST,
> +	.min_power 	= 100,
> +	.clock		= 0,
> +	.config		= puv3_usb_config,
> +};

Please have a look at the flattened device tree format as
a way to define the SoC components. Defining all the platform
data statically is generally not a scalable way to support
multiple SOCs in the long run, or even multiple boards
based on the same SOC in different configurations.

> +static u64 puv3_usb_dmamask = 0xffffffffUL;
> +
> +static struct platform_device puv3_device_usb = {
> +	.name		= "musb_hdrc",
> +	.id		= -1,
> +	.dev = {
> +		.platform_data          = &puv3_usb_plat,
> +		.dma_mask               = &puv3_usb_dmamask,
> +		.coherent_dma_mask      = 0xffffffff,
> +	},
> +	.num_resources	= ARRAY_SIZE(puv3_usb_resources),
> +	.resource	= puv3_usb_resources,
> +};

Statically defining platform devices is deprecated. Please use
platform_device_register_resndata or platform_device_register_simple
to create the platform_device for you.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/abort-ucv2.S linux-2.6.37.y/arch/unicore32/mm/abort-ucv2.S
> --- linux-2.6.37-rc2/arch/unicore32/mm/abort-ucv2.S	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/abort-ucv2.S	2010-11-16 18:30:56.023566683 +0800

I would not bother splitting the assembly code into so many CPU and
function specific files (abort, cache, ...) if all you have is a
single CPU type.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/alignment.c linux-2.6.37.y/arch/unicore32/mm/alignment.c
> --- linux-2.6.37-rc2/arch/unicore32/mm/alignment.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/alignment.c	2010-11-19 14:34:21.565047398 +0800
> +static int alignment_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "User:\t\t%lu\n", ai_user);
> +	seq_printf(m, "System:\t\t%lu\n", ai_sys);
> +	seq_printf(m, "Skipped:\t%lu\n", ai_skipped);
> +	seq_printf(m, "Half:\t\t%lu\n", ai_half);
> +	seq_printf(m, "Word:\t\t%lu\n", ai_word);
> +	seq_printf(m, "Multi:\t\t%lu\n", ai_multi);
> +	seq_printf(m, "User faults:\t%i (%s)\n", ai_usermode,
> +			usermode_action[ai_usermode]);
> +
> +	return 0;
> +}
> +
> +static int alignment_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, alignment_proc_show, NULL);
> +}

Please don't introduce new architectures specific procfs files.
If you need to track alignment exceptions, you could make that
a perf event.

Why do you even need to fix up alignment exceptions, can't you
just always send SIGBUS in this case?

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/copypage-ucv2.c linux-2.6.37.y/arch/unicore32/mm/copypage-ucv2.c
> --- linux-2.6.37-rc2/arch/unicore32/mm/copypage-ucv2.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/copypage-ucv2.c	2010-11-19 14:34:25.600566295 +0800
> +/*
> + * Copy the user page.  No aliasing to deal with so we can just
> + * attack the kernel's existing mapping of these pages.
> + */
> +void ucv2_copy_user_highpage(struct page *to,
> +	struct page *from, unsigned long vaddr, struct vm_area_struct *vma)
> +{
> +	void *kto, *kfrom;
> +
> +	kfrom = kmap_atomic(from, KM_USER0);
> +	kto = kmap_atomic(to, KM_USER1);
> +	copy_page(kto, kfrom);
> +	__cpuc_flush_dcache_area(kto, PAGE_SIZE);
> +	kunmap_atomic(kto, KM_USER1);
> +	kunmap_atomic(kfrom, KM_USER0);
> +}

This won't be needed once you get rid of highmem.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/dma-mapping.c linux-2.6.37.y/arch/unicore32/mm/dma-mapping.c
> --- linux-2.6.37-rc2/arch/unicore32/mm/dma-mapping.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/dma-mapping.c	2010-11-16 18:30:56.024566880 +0800

This file will look very different when you use swiotlb. Given
the restrictions on your PCI bus, I don't think your current
version even works in general for PCI devices.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/iomap.c linux-2.6.37.y/arch/unicore32/mm/iomap.c
> --- linux-2.6.37-rc2/arch/unicore32/mm/iomap.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/iomap.c	2010-11-16 18:30:56.026566925 +0800
> +#ifdef __io
> +void __iomem *ioport_map(unsigned long port, unsigned int nr)
> +{
> +	/* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
> +	if (port < 0x10000)
> +		return (void __iomem *) (unsigned long)
> +			io_p2v(port + PKUNITY_PCILIO_BASE);
> +

This is a very complex definition for something very simple ;-)

#define IO_PORT_BASE (void __iomem *)0x80030000
	return IO_PORT_BASE + (port & 0xffff);


> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/mm/vmregion.c linux-2.6.37.y/arch/unicore32/mm/vmregion.c
> --- linux-2.6.37-rc2/arch/unicore32/mm/vmregion.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/mm/vmregion.c	2010-11-19 14:36:00.632986551 +0800
> @@ -0,0 +1,145 @@
> +/*
> + * linux/arch/unicore32/mm/vmregion.c
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + * Copyright (C) 2001-2008 GUAN Xue-tao
> + *
> + * Based on: arch/arm/mm/vmregion.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +
> +#include "vmregion.h"
> +
> +/*
> + * VM region handling support.
> + *
> + * This should become something generic, handling VM region allocations for
> + * vmalloc and similar (ioremap, module space, etc).
> + *
> + * I envisage vmalloc()'s supporting vm_struct becoming:

This apparently never happened. The only place where vmregion is
actually use is managing coherent DMA ranges. Do you actually need
to do this? I don't see any architecture besides ARM using something
like this, and they have all sorts of complex problems including
noncoherent DMA devices and VIPT caches with aliasing problems.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/ramfs/inittab linux-2.6.37.y/arch/unicore32/ramfs/inittab
> --- linux-2.6.37-rc2/arch/unicore32/ramfs/inittab	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/ramfs/inittab	2010-11-16 18:30:56.030566667 +0800
> @@ -0,0 +1,24 @@
> +#
> +# inittab       This file describes how the INIT process should set up
> +#               the system in a certain run-level.

Hmm, we don't have any precedent for putting ramfs contents into
the architecture tree. It's not necessarily a bad idea, but please
split this out into a separate patch so we can discuss this
independent of the architecture contents.

If people agree that this is a good thing to have in the kernel
sources, it should probably go into an architecture independent
place.

> diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-rc2/arch/unicore32/uc-f64/entry.S linux-2.6.37.y/arch/unicore32/uc-f64/entry.S
> --- linux-2.6.37-rc2/arch/unicore32/uc-f64/entry.S	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6.37.y/arch/unicore32/uc-f64/entry.S	2010-11-16 18:30:56.031566724 +0800

Please also split out the f64 code into a separate patch.
The code looks ok to me, but I have no clue what it actually
needs to do, but there is a large amount of code in it that
otherwise clutters up the review process.

When you have addressed the review comments you got up to
now, it would be good to start posting the code as separate
patches by email to the linux-kernel and linux-arch mailing
lists as described in the Documentation/SubmittingPatches
file. I recommend posting at most 10-20 patches at a time,
and if you have patches to include/asm-generic or other
common kernel code, please make them self-contained with
a proper changelog so we can apply them independent of the
architecture tree.

	Arnd
