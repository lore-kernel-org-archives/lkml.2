Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab1JZN05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:26:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab1JZN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:26:54 -0400
Date: Wed, 26 Oct 2011 15:25:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.2
Message-ID: <20111026132500.GA23461@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

These changes of annotating certain low level (mostly hw related) 
locks as raw do not impact lockdep coverage, the before/after vmlinux 
size with PROVE_LOCKING=y on x86 defconfig is:

    text	   data	    bss	     dec	    hex	filename
10762222	1058192	9605120	21425534	146ed7e	vmlinux.orig
10762222	1058192	9605120	21425534	146ed7e	vmlinux.new

Note, you will get a conflict in kernel/posix-cpu-timers.c, which i 
resolved in -tip the following way:

	raw_spin_lock_irqsave(&cputimer->lock, flags);
	if (!cputimer->running) {
		cputimer->running = 1;
		/*
		 * The POSIX timer interface allows for absolute time expiry
		 * values through the TIMER_ABSTIME flag, therefore we have
		 * to synchronize the timer to the clock every time we start
		 * it.
		 */
		thread_group_cputime(tsk, &sum);
		update_gt_cputime(&cputimer->cputime, &sum);
	}
	*times = cputimer->cputime;
	raw_spin_unlock_irqrestore(&cputimer->lock, flags);

Thanks,

	Ingo

------------------>
Mike Galbraith (1):
      locking, drivers/dca: Annotate dca_lock as raw

Peter Zijlstra (1):
      lockdep: Comment all warnings

Shan Hai (1):
      locking, lib/atomic64: Annotate atomic64_lock::lock as raw

Thomas Gleixner (22):
      rtmutex: Cleanup the debug code
      locking, kprobes: Annotate the hash locks and kretprobe.lock as raw
      locking, percpu_counter: Annotate ::lock as raw
      locking, sched, cgroups: Annotate release_list_lock as raw
      locking, lib/proportions: Annotate prop_local_percpu::lock as raw
      locking, tracing: Annotate tracing locks as raw
      locking, printk: Annotate logbuf_lock as raw
      locking, sched: Annotate thread_group_cputimer as raw
      locking, semaphores: Annotate inner lock as raw
      locking, rwsem: Annotate inner lock as raw
      locking, timer_stats: Annotate table_lock as raw
      locking, latencytop: Annotate latency_lock as raw
      locking, video: Annotate vga console lock as raw
      locking, oprofile: Annotate oprofilefs lock as raw
      locking, ACPI: Annotate c3_lock as raw
      locking, x86: mce: Annotate cmci_discover_lock as raw
      locking, powerpc: Annotate uic->lock as raw
      locking, ARM: Annotate low level hw locks as raw
      locking, x86, iommu: Annotate iommu->register_lock as raw
      locking, x86, iommu: Annotate irq_2_ir_lock as raw
      locking, x86, iommu: Annotate qi->q_lock as raw
      rtmutex: Add missing rcu_read_unlock() in debug_rt_mutex_print_deadlock()

Uwe Kleine-König (1):
      locking, dma, ipu: Annotate bank_lock as raw

Yong Zhang (1):
      lib: atomic64: Change the type of local lock to raw_spinlock_t


 arch/arm/common/gic.c                            |   26 ++--
 arch/arm/include/asm/dma.h                       |    6 +-
 arch/arm/include/asm/mmu.h                       |    4 +-
 arch/arm/kernel/dma.c                            |    2 +-
 arch/arm/kernel/smp.c                            |    6 +-
 arch/arm/kernel/traps.c                          |   20 ++--
 arch/arm/mach-footbridge/include/mach/hardware.h |    2 +-
 arch/arm/mach-footbridge/netwinder-hw.c          |   14 +-
 arch/arm/mach-footbridge/netwinder-leds.c        |   10 +-
 arch/arm/mach-integrator/core.c                  |    6 +-
 arch/arm/mach-integrator/pci_v3.c                |   14 +-
 arch/arm/mach-ixp4xx/common-pci.c                |   22 ++--
 arch/arm/mach-shark/leds.c                       |    6 +-
 arch/arm/mm/cache-l2x0.c                         |   46 +++---
 arch/arm/mm/context.c                            |   14 +-
 arch/arm/mm/copypage-v4mc.c                      |    6 +-
 arch/arm/mm/copypage-v6.c                        |   10 +-
 arch/arm/mm/copypage-xscale.c                    |    6 +-
 arch/powerpc/sysdev/uic.c                        |   24 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c           |   10 +-
 arch/x86/oprofile/nmi_int.c                      |    4 +-
 drivers/acpi/processor_idle.c                    |   10 +-
 drivers/dca/dca-core.c                           |   78 ++++++-----
 drivers/dma/ipu/ipu_irq.c                        |   48 ++++----
 drivers/iommu/dmar.c                             |   48 ++++----
 drivers/iommu/intel-iommu.c                      |   36 +++---
 drivers/iommu/intr_remapping.c                   |   40 +++---
 drivers/oprofile/event_buffer.c                  |    4 +-
 drivers/oprofile/oprofile_perf.c                 |    4 +-
 drivers/oprofile/oprofilefs.c                    |    6 +-
 drivers/video/console/vgacon.c                   |   42 +++---
 include/linux/init_task.h                        |    2 +-
 include/linux/intel-iommu.h                      |    4 +-
 include/linux/kprobes.h                          |    2 +-
 include/linux/oprofile.h                         |    2 +-
 include/linux/percpu_counter.h                   |    2 +-
 include/linux/proportions.h                      |    6 +-
 include/linux/ratelimit.h                        |    6 +-
 include/linux/rwsem-spinlock.h                   |    2 +-
 include/linux/rwsem.h                            |   10 +-
 include/linux/sched.h                            |    4 +-
 include/linux/semaphore.h                        |    4 +-
 kernel/cgroup.c                                  |   18 ++--
 kernel/kprobes.c                                 |   34 +++---
 kernel/latencytop.c                              |   14 +-
 kernel/lockdep.c                                 |  156 ++++++++++++++++++++--
 kernel/posix-cpu-timers.c                        |   12 +-
 kernel/printk.c                                  |   46 +++---
 kernel/rtmutex-debug.c                           |   77 ++---------
 kernel/sched_stats.h                             |   12 +-
 kernel/semaphore.c                               |   28 ++--
 kernel/time/timer_stats.c                        |    6 +-
 kernel/trace/ring_buffer.c                       |   52 ++++----
 kernel/trace/trace.c                             |   10 +-
 kernel/trace/trace_irqsoff.c                     |    6 +-
 lib/atomic64.c                                   |   66 +++++-----
 lib/percpu_counter.c                             |   18 ++--
 lib/proportions.c                                |   12 +-
 lib/ratelimit.c                                  |    4 +-
 lib/rwsem-spinlock.c                             |   38 +++---
 lib/rwsem.c                                      |   14 +-
 61 files changed, 669 insertions(+), 572 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 3227ca9..6fba8bd 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -33,7 +33,7 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
 
-static DEFINE_SPINLOCK(irq_controller_lock);
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /* Address of GIC 0 CPU interface */
 void __iomem *gic_cpu_base_addr __read_mostly;
@@ -82,30 +82,30 @@ static void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_CLEAR + (gic_irq(d) / 32) * 4);
 	if (gic_arch_extn.irq_mask)
 		gic_arch_extn.irq_mask(d);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	if (gic_arch_extn.irq_unmask)
 		gic_arch_extn.irq_unmask(d);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_SET + (gic_irq(d) / 32) * 4);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_eoi_irq(struct irq_data *d)
 {
 	if (gic_arch_extn.irq_eoi) {
-		spin_lock(&irq_controller_lock);
+		raw_spin_lock(&irq_controller_lock);
 		gic_arch_extn.irq_eoi(d);
-		spin_unlock(&irq_controller_lock);
+		raw_spin_unlock(&irq_controller_lock);
 	}
 
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
@@ -129,7 +129,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 
 	if (gic_arch_extn.irq_set_type)
 		gic_arch_extn.irq_set_type(d, type);
@@ -154,7 +154,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (enabled)
 		writel_relaxed(enablemask, base + GIC_DIST_ENABLE_SET + enableoff);
 
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
 }
@@ -182,10 +182,10 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	mask = 0xff << shift;
 	bit = 1 << (cpu + shift);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	val = readl_relaxed(reg) & ~mask;
 	writel_relaxed(val | bit, reg);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return IRQ_SET_MASK_OK;
 }
@@ -215,9 +215,9 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 
 	chained_irq_enter(chip, desc);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	status = readl_relaxed(chip_data->cpu_base + GIC_CPU_INTACK);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	gic_irq = (status & 0x3ff);
 	if (gic_irq == 1023)
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 628670e..69a5b0b 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -34,18 +34,18 @@
 #define DMA_MODE_CASCADE 0xc0
 #define DMA_AUTOINIT	 0x10
 
-extern spinlock_t  dma_spin_lock;
+extern raw_spinlock_t  dma_spin_lock;
 
 static inline unsigned long claim_dma_lock(void)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&dma_spin_lock, flags);
+	raw_spin_lock_irqsave(&dma_spin_lock, flags);
 	return flags;
 }
 
 static inline void release_dma_lock(unsigned long flags)
 {
-	spin_unlock_irqrestore(&dma_spin_lock, flags);
+	raw_spin_unlock_irqrestore(&dma_spin_lock, flags);
 }
 
 /* Clear the 'DMA Pointer Flip Flop'.
diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index b4ffe9d..1496565 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -6,7 +6,7 @@
 typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	unsigned int id;
-	spinlock_t id_lock;
+	raw_spinlock_t id_lock;
 #endif
 	unsigned int kvm_seq;
 } mm_context_t;
@@ -16,7 +16,7 @@ typedef struct {
 
 /* init_mm.context.id_lock should be initialized. */
 #define INIT_MM_CONTEXT(name)                                                 \
-	.context.id_lock    = __SPIN_LOCK_UNLOCKED(name.context.id_lock),
+	.context.id_lock    = __RAW_SPIN_LOCK_UNLOCKED(name.context.id_lock),
 #else
 #define ASID(mm)	(0)
 #endif
diff --git a/arch/arm/kernel/dma.c b/arch/arm/kernel/dma.c
index 2c4a185..7b829d9 100644
--- a/arch/arm/kernel/dma.c
+++ b/arch/arm/kernel/dma.c
@@ -23,7 +23,7 @@
 
 #include <asm/mach/dma.h>
 
-DEFINE_SPINLOCK(dma_spin_lock);
+DEFINE_RAW_SPINLOCK(dma_spin_lock);
 EXPORT_SYMBOL(dma_spin_lock);
 
 static dma_t *dma_chan[MAX_DMA_CHANNELS];
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index d88ff02..4e76e0c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -538,7 +538,7 @@ static void percpu_timer_stop(void)
 }
 #endif
 
-static DEFINE_SPINLOCK(stop_lock);
+static DEFINE_RAW_SPINLOCK(stop_lock);
 
 /*
  * ipi_cpu_stop - handle IPI from smp_send_stop()
@@ -547,10 +547,10 @@ static void ipi_cpu_stop(unsigned int cpu)
 {
 	if (system_state == SYSTEM_BOOTING ||
 	    system_state == SYSTEM_RUNNING) {
-		spin_lock(&stop_lock);
+		raw_spin_lock(&stop_lock);
 		printk(KERN_CRIT "CPU%u: stopping\n", cpu);
 		dump_stack();
-		spin_unlock(&stop_lock);
+		raw_spin_unlock(&stop_lock);
 	}
 
 	set_cpu_online(cpu, false);
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index bc9f9da..81cc05a 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -255,7 +255,7 @@ static int __die(const char *str, int err, struct thread_info *thread, struct pt
 	return ret;
 }
 
-static DEFINE_SPINLOCK(die_lock);
+static DEFINE_RAW_SPINLOCK(die_lock);
 
 /*
  * This function is protected against re-entrancy.
@@ -267,7 +267,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	raw_spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
 	ret = __die(str, err, thread, regs);
@@ -277,7 +277,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
-	spin_unlock_irq(&die_lock);
+	raw_spin_unlock_irq(&die_lock);
 	oops_exit();
 
 	if (in_interrupt())
@@ -302,24 +302,24 @@ void arm_notify_die(const char *str, struct pt_regs *regs,
 }
 
 static LIST_HEAD(undef_hook);
-static DEFINE_SPINLOCK(undef_lock);
+static DEFINE_RAW_SPINLOCK(undef_lock);
 
 void register_undef_hook(struct undef_hook *hook)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&undef_lock, flags);
+	raw_spin_lock_irqsave(&undef_lock, flags);
 	list_add(&hook->node, &undef_hook);
-	spin_unlock_irqrestore(&undef_lock, flags);
+	raw_spin_unlock_irqrestore(&undef_lock, flags);
 }
 
 void unregister_undef_hook(struct undef_hook *hook)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&undef_lock, flags);
+	raw_spin_lock_irqsave(&undef_lock, flags);
 	list_del(&hook->node);
-	spin_unlock_irqrestore(&undef_lock, flags);
+	raw_spin_unlock_irqrestore(&undef_lock, flags);
 }
 
 static int call_undef_hook(struct pt_regs *regs, unsigned int instr)
@@ -328,12 +328,12 @@ static int call_undef_hook(struct pt_regs *regs, unsigned int instr)
 	unsigned long flags;
 	int (*fn)(struct pt_regs *regs, unsigned int instr) = NULL;
 
-	spin_lock_irqsave(&undef_lock, flags);
+	raw_spin_lock_irqsave(&undef_lock, flags);
 	list_for_each_entry(hook, &undef_hook, node)
 		if ((instr & hook->instr_mask) == hook->instr_val &&
 		    (regs->ARM_cpsr & hook->cpsr_mask) == hook->cpsr_val)
 			fn = hook->fn;
-	spin_unlock_irqrestore(&undef_lock, flags);
+	raw_spin_unlock_irqrestore(&undef_lock, flags);
 
 	return fn ? fn(regs, instr) : 1;
 }
diff --git a/arch/arm/mach-footbridge/include/mach/hardware.h b/arch/arm/mach-footbridge/include/mach/hardware.h
index 15d5498..e3d6cca 100644
--- a/arch/arm/mach-footbridge/include/mach/hardware.h
+++ b/arch/arm/mach-footbridge/include/mach/hardware.h
@@ -93,7 +93,7 @@
 #define CPLD_FLASH_WR_ENABLE	1
 
 #ifndef __ASSEMBLY__
-extern spinlock_t nw_gpio_lock;
+extern raw_spinlock_t nw_gpio_lock;
 extern void nw_gpio_modify_op(unsigned int mask, unsigned int set);
 extern void nw_gpio_modify_io(unsigned int mask, unsigned int in);
 extern unsigned int nw_gpio_read(void);
diff --git a/arch/arm/mach-footbridge/netwinder-hw.c b/arch/arm/mach-footbridge/netwinder-hw.c
index 06e514f..5b73190 100644
--- a/arch/arm/mach-footbridge/netwinder-hw.c
+++ b/arch/arm/mach-footbridge/netwinder-hw.c
@@ -68,7 +68,7 @@ static inline void wb977_ww(int reg, int val)
 /*
  * This is a lock for accessing ports GP1_IO_BASE and GP2_IO_BASE
  */
-DEFINE_SPINLOCK(nw_gpio_lock);
+DEFINE_RAW_SPINLOCK(nw_gpio_lock);
 EXPORT_SYMBOL(nw_gpio_lock);
 
 static unsigned int current_gpio_op;
@@ -327,9 +327,9 @@ static inline void wb977_init_gpio(void)
 	/*
 	 * Set Group1/Group2 outputs
 	 */
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_gpio_modify_op(-1, GPIO_RED_LED | GPIO_FAN);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 }
 
 /*
@@ -390,9 +390,9 @@ static void __init cpld_init(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_cpld_modify(-1, CPLD_UNMUTE | CPLD_7111_DISABLE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 }
 
 static unsigned char rwa_unlock[] __initdata =
@@ -616,9 +616,9 @@ static int __init nw_hw_init(void)
 		cpld_init();
 		rwa010_init();
 
-		spin_lock_irqsave(&nw_gpio_lock, flags);
+		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 		nw_gpio_modify_op(GPIO_RED_LED|GPIO_GREEN_LED, DEFAULT_LEDS);
-		spin_unlock_irqrestore(&nw_gpio_lock, flags);
+		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 	}
 	return 0;
 }
diff --git a/arch/arm/mach-footbridge/netwinder-leds.c b/arch/arm/mach-footbridge/netwinder-leds.c
index 00269fe..e57102e 100644
--- a/arch/arm/mach-footbridge/netwinder-leds.c
+++ b/arch/arm/mach-footbridge/netwinder-leds.c
@@ -31,13 +31,13 @@
 static char led_state;
 static char hw_led_state;
 
-static DEFINE_SPINLOCK(leds_lock);
+static DEFINE_RAW_SPINLOCK(leds_lock);
 
 static void netwinder_leds_event(led_event_t evt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&leds_lock, flags);
+	raw_spin_lock_irqsave(&leds_lock, flags);
 
 	switch (evt) {
 	case led_start:
@@ -117,12 +117,12 @@ static void netwinder_leds_event(led_event_t evt)
 		break;
 	}
 
-	spin_unlock_irqrestore(&leds_lock, flags);
+	raw_spin_unlock_irqrestore(&leds_lock, flags);
 
 	if  (led_state & LED_STATE_ENABLED) {
-		spin_lock_irqsave(&nw_gpio_lock, flags);
+		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 		nw_gpio_modify_op(GPIO_RED_LED | GPIO_GREEN_LED, hw_led_state);
-		spin_unlock_irqrestore(&nw_gpio_lock, flags);
+		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 	}
 }
 
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 77315b9..0c20cf6 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -205,7 +205,7 @@ static struct amba_pl010_data integrator_uart_data = {
 
 #define CM_CTRL	IO_ADDRESS(INTEGRATOR_HDR_CTRL)
 
-static DEFINE_SPINLOCK(cm_lock);
+static DEFINE_RAW_SPINLOCK(cm_lock);
 
 /**
  * cm_control - update the CM_CTRL register.
@@ -217,10 +217,10 @@ void cm_control(u32 mask, u32 set)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&cm_lock, flags);
+	raw_spin_lock_irqsave(&cm_lock, flags);
 	val = readl(CM_CTRL) & ~mask;
 	writel(val | set, CM_CTRL);
-	spin_unlock_irqrestore(&cm_lock, flags);
+	raw_spin_unlock_irqrestore(&cm_lock, flags);
 }
 
 EXPORT_SYMBOL(cm_control);
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index dd56bfb..56c3062 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -164,7 +164,7 @@
  *	 7:2	register number
  *  
  */
-static DEFINE_SPINLOCK(v3_lock);
+static DEFINE_RAW_SPINLOCK(v3_lock);
 
 #define PCI_BUS_NONMEM_START	0x00000000
 #define PCI_BUS_NONMEM_SIZE	SZ_256M
@@ -285,7 +285,7 @@ static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 	unsigned long flags;
 	u32 v;
 
-	spin_lock_irqsave(&v3_lock, flags);
+	raw_spin_lock_irqsave(&v3_lock, flags);
 	addr = v3_open_config_window(bus, devfn, where);
 
 	switch (size) {
@@ -303,7 +303,7 @@ static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 	}
 
 	v3_close_config_window();
-	spin_unlock_irqrestore(&v3_lock, flags);
+	raw_spin_unlock_irqrestore(&v3_lock, flags);
 
 	*val = v;
 	return PCIBIOS_SUCCESSFUL;
@@ -315,7 +315,7 @@ static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 	unsigned long addr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&v3_lock, flags);
+	raw_spin_lock_irqsave(&v3_lock, flags);
 	addr = v3_open_config_window(bus, devfn, where);
 
 	switch (size) {
@@ -336,7 +336,7 @@ static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 	}
 
 	v3_close_config_window();
-	spin_unlock_irqrestore(&v3_lock, flags);
+	raw_spin_unlock_irqrestore(&v3_lock, flags);
 
 	return PCIBIOS_SUCCESSFUL;
 }
@@ -515,7 +515,7 @@ void __init pci_v3_preinit(void)
 	hook_fault_code(8, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 	hook_fault_code(10, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 
-	spin_lock_irqsave(&v3_lock, flags);
+	raw_spin_lock_irqsave(&v3_lock, flags);
 
 	/*
 	 * Unlock V3 registers, but only if they were previously locked.
@@ -588,7 +588,7 @@ void __init pci_v3_preinit(void)
 		printk(KERN_ERR "PCI: unable to grab PCI error "
 		       "interrupt: %d\n", ret);
 
-	spin_unlock_irqrestore(&v3_lock, flags);
+	raw_spin_unlock_irqrestore(&v3_lock, flags);
 }
 
 void __init pci_v3_postinit(void)
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 2131832..1b5fe87 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -54,7 +54,7 @@ unsigned long ixp4xx_pci_reg_base = 0;
  * these transactions are atomic or we will end up
  * with corrupt data on the bus or in a driver.
  */
-static DEFINE_SPINLOCK(ixp4xx_pci_lock);
+static DEFINE_RAW_SPINLOCK(ixp4xx_pci_lock);
 
 /*
  * Read from PCI config space
@@ -62,10 +62,10 @@ static DEFINE_SPINLOCK(ixp4xx_pci_lock);
 static void crp_read(u32 ad_cbe, u32 *data)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ixp4xx_pci_lock, flags);
+	raw_spin_lock_irqsave(&ixp4xx_pci_lock, flags);
 	*PCI_CRP_AD_CBE = ad_cbe;
 	*data = *PCI_CRP_RDATA;
-	spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
+	raw_spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
 }
 
 /*
@@ -74,10 +74,10 @@ static void crp_read(u32 ad_cbe, u32 *data)
 static void crp_write(u32 ad_cbe, u32 data)
 { 
 	unsigned long flags;
-	spin_lock_irqsave(&ixp4xx_pci_lock, flags);
+	raw_spin_lock_irqsave(&ixp4xx_pci_lock, flags);
 	*PCI_CRP_AD_CBE = CRP_AD_CBE_WRITE | ad_cbe;
 	*PCI_CRP_WDATA = data;
-	spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
+	raw_spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
 }
 
 static inline int check_master_abort(void)
@@ -101,7 +101,7 @@ int ixp4xx_pci_read_errata(u32 addr, u32 cmd, u32* data)
 	int retval = 0;
 	int i;
 
-	spin_lock_irqsave(&ixp4xx_pci_lock, flags);
+	raw_spin_lock_irqsave(&ixp4xx_pci_lock, flags);
 
 	*PCI_NP_AD = addr;
 
@@ -118,7 +118,7 @@ int ixp4xx_pci_read_errata(u32 addr, u32 cmd, u32* data)
 	if(check_master_abort())
 		retval = 1;
 
-	spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
+	raw_spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
 	return retval;
 }
 
@@ -127,7 +127,7 @@ int ixp4xx_pci_read_no_errata(u32 addr, u32 cmd, u32* data)
 	unsigned long flags;
 	int retval = 0;
 
-	spin_lock_irqsave(&ixp4xx_pci_lock, flags);
+	raw_spin_lock_irqsave(&ixp4xx_pci_lock, flags);
 
 	*PCI_NP_AD = addr;
 
@@ -140,7 +140,7 @@ int ixp4xx_pci_read_no_errata(u32 addr, u32 cmd, u32* data)
 	if(check_master_abort())
 		retval = 1;
 
-	spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
+	raw_spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
 	return retval;
 }
 
@@ -149,7 +149,7 @@ int ixp4xx_pci_write(u32 addr, u32 cmd, u32 data)
 	unsigned long flags;
 	int retval = 0;
 
-	spin_lock_irqsave(&ixp4xx_pci_lock, flags);
+	raw_spin_lock_irqsave(&ixp4xx_pci_lock, flags);
 
 	*PCI_NP_AD = addr;
 
@@ -162,7 +162,7 @@ int ixp4xx_pci_write(u32 addr, u32 cmd, u32 data)
 	if(check_master_abort())
 		retval = 1;
 
-	spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
+	raw_spin_unlock_irqrestore(&ixp4xx_pci_lock, flags);
 	return retval;
 }
 
diff --git a/arch/arm/mach-shark/leds.c b/arch/arm/mach-shark/leds.c
index c9e32de..ccd4918 100644
--- a/arch/arm/mach-shark/leds.c
+++ b/arch/arm/mach-shark/leds.c
@@ -36,7 +36,7 @@ static char led_state;
 static short hw_led_state;
 static short saved_state;
 
-static DEFINE_SPINLOCK(leds_lock);
+static DEFINE_RAW_SPINLOCK(leds_lock);
 
 short sequoia_read(int addr) {
   outw(addr,0x24);
@@ -52,7 +52,7 @@ static void sequoia_leds_event(led_event_t evt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&leds_lock, flags);
+	raw_spin_lock_irqsave(&leds_lock, flags);
 
 	hw_led_state = sequoia_read(0x09);
 
@@ -144,7 +144,7 @@ static void sequoia_leds_event(led_event_t evt)
 	if  (led_state & LED_STATE_ENABLED)
 		sequoia_write(hw_led_state,0x09);
 
-	spin_unlock_irqrestore(&leds_lock, flags);
+	raw_spin_unlock_irqrestore(&leds_lock, flags);
 }
 
 static int __init leds_init(void)
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 9ecfdb5..3255c51 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -26,7 +26,7 @@
 #define CACHE_LINE_SIZE		32
 
 static void __iomem *l2x0_base;
-static DEFINE_SPINLOCK(l2x0_lock);
+static DEFINE_RAW_SPINLOCK(l2x0_lock);
 static uint32_t l2x0_way_mask;	/* Bitmask of active ways */
 static uint32_t l2x0_size;
 
@@ -115,9 +115,9 @@ static void l2x0_cache_sync(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void __l2x0_flush_all(void)
@@ -134,9 +134,9 @@ static void l2x0_flush_all(void)
 	unsigned long flags;
 
 	/* clean all ways */
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	__l2x0_flush_all();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_clean_all(void)
@@ -144,11 +144,11 @@ static void l2x0_clean_all(void)
 	unsigned long flags;
 
 	/* clean all ways */
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	writel_relaxed(l2x0_way_mask, l2x0_base + L2X0_CLEAN_WAY);
 	cache_wait_way(l2x0_base + L2X0_CLEAN_WAY, l2x0_way_mask);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_inv_all(void)
@@ -156,13 +156,13 @@ static void l2x0_inv_all(void)
 	unsigned long flags;
 
 	/* invalidate all ways */
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	/* Invalidating when L2 is enabled is a nono */
 	BUG_ON(readl(l2x0_base + L2X0_CTRL) & 1);
 	writel_relaxed(l2x0_way_mask, l2x0_base + L2X0_INV_WAY);
 	cache_wait_way(l2x0_base + L2X0_INV_WAY, l2x0_way_mask);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_inv_range(unsigned long start, unsigned long end)
@@ -170,7 +170,7 @@ static void l2x0_inv_range(unsigned long start, unsigned long end)
 	void __iomem *base = l2x0_base;
 	unsigned long flags;
 
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	if (start & (CACHE_LINE_SIZE - 1)) {
 		start &= ~(CACHE_LINE_SIZE - 1);
 		debug_writel(0x03);
@@ -195,13 +195,13 @@ static void l2x0_inv_range(unsigned long start, unsigned long end)
 		}
 
 		if (blk_end < end) {
-			spin_unlock_irqrestore(&l2x0_lock, flags);
-			spin_lock_irqsave(&l2x0_lock, flags);
+			raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+			raw_spin_lock_irqsave(&l2x0_lock, flags);
 		}
 	}
 	cache_wait(base + L2X0_INV_LINE_PA, 1);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_clean_range(unsigned long start, unsigned long end)
@@ -214,7 +214,7 @@ static void l2x0_clean_range(unsigned long start, unsigned long end)
 		return;
 	}
 
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	start &= ~(CACHE_LINE_SIZE - 1);
 	while (start < end) {
 		unsigned long blk_end = start + min(end - start, 4096UL);
@@ -225,13 +225,13 @@ static void l2x0_clean_range(unsigned long start, unsigned long end)
 		}
 
 		if (blk_end < end) {
-			spin_unlock_irqrestore(&l2x0_lock, flags);
-			spin_lock_irqsave(&l2x0_lock, flags);
+			raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+			raw_spin_lock_irqsave(&l2x0_lock, flags);
 		}
 	}
 	cache_wait(base + L2X0_CLEAN_LINE_PA, 1);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_flush_range(unsigned long start, unsigned long end)
@@ -244,7 +244,7 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
 		return;
 	}
 
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	start &= ~(CACHE_LINE_SIZE - 1);
 	while (start < end) {
 		unsigned long blk_end = start + min(end - start, 4096UL);
@@ -257,24 +257,24 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
 		debug_writel(0x00);
 
 		if (blk_end < end) {
-			spin_unlock_irqrestore(&l2x0_lock, flags);
-			spin_lock_irqsave(&l2x0_lock, flags);
+			raw_spin_unlock_irqrestore(&l2x0_lock, flags);
+			raw_spin_lock_irqsave(&l2x0_lock, flags);
 		}
 	}
 	cache_wait(base + L2X0_CLEAN_INV_LINE_PA, 1);
 	cache_sync();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void l2x0_disable(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&l2x0_lock, flags);
+	raw_spin_lock_irqsave(&l2x0_lock, flags);
 	__l2x0_flush_all();
 	writel_relaxed(0, l2x0_base + L2X0_CTRL);
 	dsb();
-	spin_unlock_irqrestore(&l2x0_lock, flags);
+	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
 static void __init l2x0_unlock(__u32 cache_id)
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index b0ee9ba..93aac068 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -16,7 +16,7 @@
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
-static DEFINE_SPINLOCK(cpu_asid_lock);
+static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 #ifdef CONFIG_SMP
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct mm_struct *, current_mm);
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	mm->context.id = 0;
-	spin_lock_init(&mm->context.id_lock);
+	raw_spin_lock_init(&mm->context.id_lock);
 }
 
 static void flush_context(void)
@@ -58,7 +58,7 @@ static void set_mm_context(struct mm_struct *mm, unsigned int asid)
 	 * the broadcast. This function is also called via IPI so the
 	 * mm->context.id_lock has to be IRQ-safe.
 	 */
-	spin_lock_irqsave(&mm->context.id_lock, flags);
+	raw_spin_lock_irqsave(&mm->context.id_lock, flags);
 	if (likely((mm->context.id ^ cpu_last_asid) >> ASID_BITS)) {
 		/*
 		 * Old version of ASID found. Set the new one and
@@ -67,7 +67,7 @@ static void set_mm_context(struct mm_struct *mm, unsigned int asid)
 		mm->context.id = asid;
 		cpumask_clear(mm_cpumask(mm));
 	}
-	spin_unlock_irqrestore(&mm->context.id_lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.id_lock, flags);
 
 	/*
 	 * Set the mm_cpumask(mm) bit for the current CPU.
@@ -117,7 +117,7 @@ void __new_context(struct mm_struct *mm)
 {
 	unsigned int asid;
 
-	spin_lock(&cpu_asid_lock);
+	raw_spin_lock(&cpu_asid_lock);
 #ifdef CONFIG_SMP
 	/*
 	 * Check the ASID again, in case the change was broadcast from
@@ -125,7 +125,7 @@ void __new_context(struct mm_struct *mm)
 	 */
 	if (unlikely(((mm->context.id ^ cpu_last_asid) >> ASID_BITS) == 0)) {
 		cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
-		spin_unlock(&cpu_asid_lock);
+		raw_spin_unlock(&cpu_asid_lock);
 		return;
 	}
 #endif
@@ -153,5 +153,5 @@ void __new_context(struct mm_struct *mm)
 	}
 
 	set_mm_context(mm, asid);
-	spin_unlock(&cpu_asid_lock);
+	raw_spin_unlock(&cpu_asid_lock);
 }
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index b806151..7d0a8c2 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -30,7 +30,7 @@
 #define minicache_pgprot __pgprot(L_PTE_PRESENT | L_PTE_YOUNG | \
 				  L_PTE_MT_MINICACHE)
 
-static DEFINE_SPINLOCK(minicache_lock);
+static DEFINE_RAW_SPINLOCK(minicache_lock);
 
 /*
  * ARMv4 mini-dcache optimised copy_user_highpage
@@ -76,14 +76,14 @@ void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
 
-	spin_lock(&minicache_lock);
+	raw_spin_lock(&minicache_lock);
 
 	set_pte_ext(TOP_PTE(0xffff8000), pfn_pte(page_to_pfn(from), minicache_pgprot), 0);
 	flush_tlb_kernel_page(0xffff8000);
 
 	mc_copy_user_page((void *)0xffff8000, kto);
 
-	spin_unlock(&minicache_lock);
+	raw_spin_unlock(&minicache_lock);
 
 	kunmap_atomic(kto, KM_USER1);
 }
diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index 63cca00..3d9a155 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -27,7 +27,7 @@
 #define from_address	(0xffff8000)
 #define to_address	(0xffffc000)
 
-static DEFINE_SPINLOCK(v6_lock);
+static DEFINE_RAW_SPINLOCK(v6_lock);
 
 /*
  * Copy the user page.  No aliasing to deal with so we can just
@@ -88,7 +88,7 @@ static void v6_copy_user_highpage_aliasing(struct page *to,
 	 * Now copy the page using the same cache colour as the
 	 * pages ultimate destination.
 	 */
-	spin_lock(&v6_lock);
+	raw_spin_lock(&v6_lock);
 
 	set_pte_ext(TOP_PTE(from_address) + offset, pfn_pte(page_to_pfn(from), PAGE_KERNEL), 0);
 	set_pte_ext(TOP_PTE(to_address) + offset, pfn_pte(page_to_pfn(to), PAGE_KERNEL), 0);
@@ -101,7 +101,7 @@ static void v6_copy_user_highpage_aliasing(struct page *to,
 
 	copy_page((void *)kto, (void *)kfrom);
 
-	spin_unlock(&v6_lock);
+	raw_spin_unlock(&v6_lock);
 }
 
 /*
@@ -121,13 +121,13 @@ static void v6_clear_user_highpage_aliasing(struct page *page, unsigned long vad
 	 * Now clear the page using the same cache colour as
 	 * the pages ultimate destination.
 	 */
-	spin_lock(&v6_lock);
+	raw_spin_lock(&v6_lock);
 
 	set_pte_ext(TOP_PTE(to_address) + offset, pfn_pte(page_to_pfn(page), PAGE_KERNEL), 0);
 	flush_tlb_kernel_page(to);
 	clear_page((void *)to);
 
-	spin_unlock(&v6_lock);
+	raw_spin_unlock(&v6_lock);
 }
 
 struct cpu_user_fns v6_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index 649bbcd..610c24c 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -32,7 +32,7 @@
 #define minicache_pgprot __pgprot(L_PTE_PRESENT | L_PTE_YOUNG | \
 				  L_PTE_MT_MINICACHE)
 
-static DEFINE_SPINLOCK(minicache_lock);
+static DEFINE_RAW_SPINLOCK(minicache_lock);
 
 /*
  * XScale mini-dcache optimised copy_user_highpage
@@ -98,14 +98,14 @@ void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
 
-	spin_lock(&minicache_lock);
+	raw_spin_lock(&minicache_lock);
 
 	set_pte_ext(TOP_PTE(COPYPAGE_MINICACHE), pfn_pte(page_to_pfn(from), minicache_pgprot), 0);
 	flush_tlb_kernel_page(COPYPAGE_MINICACHE);
 
 	mc_copy_user_page((void *)COPYPAGE_MINICACHE, kto);
 
-	spin_unlock(&minicache_lock);
+	raw_spin_unlock(&minicache_lock);
 
 	kunmap_atomic(kto, KM_USER1);
 }
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 984cd20..3330fec 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -47,7 +47,7 @@ struct uic {
 	int index;
 	int dcrbase;
 
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	/* The remapper for this UIC */
 	struct irq_host	*irqhost;
@@ -61,14 +61,14 @@ static void uic_unmask_irq(struct irq_data *d)
 	u32 er, sr;
 
 	sr = 1 << (31-src);
-	spin_lock_irqsave(&uic->lock, flags);
+	raw_spin_lock_irqsave(&uic->lock, flags);
 	/* ack level-triggered interrupts here */
 	if (irqd_is_level_type(d))
 		mtdcr(uic->dcrbase + UIC_SR, sr);
 	er = mfdcr(uic->dcrbase + UIC_ER);
 	er |= sr;
 	mtdcr(uic->dcrbase + UIC_ER, er);
-	spin_unlock_irqrestore(&uic->lock, flags);
+	raw_spin_unlock_irqrestore(&uic->lock, flags);
 }
 
 static void uic_mask_irq(struct irq_data *d)
@@ -78,11 +78,11 @@ static void uic_mask_irq(struct irq_data *d)
 	unsigned long flags;
 	u32 er;
 
-	spin_lock_irqsave(&uic->lock, flags);
+	raw_spin_lock_irqsave(&uic->lock, flags);
 	er = mfdcr(uic->dcrbase + UIC_ER);
 	er &= ~(1 << (31 - src));
 	mtdcr(uic->dcrbase + UIC_ER, er);
-	spin_unlock_irqrestore(&uic->lock, flags);
+	raw_spin_unlock_irqrestore(&uic->lock, flags);
 }
 
 static void uic_ack_irq(struct irq_data *d)
@@ -91,9 +91,9 @@ static void uic_ack_irq(struct irq_data *d)
 	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 
-	spin_lock_irqsave(&uic->lock, flags);
+	raw_spin_lock_irqsave(&uic->lock, flags);
 	mtdcr(uic->dcrbase + UIC_SR, 1 << (31-src));
-	spin_unlock_irqrestore(&uic->lock, flags);
+	raw_spin_unlock_irqrestore(&uic->lock, flags);
 }
 
 static void uic_mask_ack_irq(struct irq_data *d)
@@ -104,7 +104,7 @@ static void uic_mask_ack_irq(struct irq_data *d)
 	u32 er, sr;
 
 	sr = 1 << (31-src);
-	spin_lock_irqsave(&uic->lock, flags);
+	raw_spin_lock_irqsave(&uic->lock, flags);
 	er = mfdcr(uic->dcrbase + UIC_ER);
 	er &= ~sr;
 	mtdcr(uic->dcrbase + UIC_ER, er);
@@ -118,7 +118,7 @@ static void uic_mask_ack_irq(struct irq_data *d)
 	 */
 	if (!irqd_is_level_type(d))
 		mtdcr(uic->dcrbase + UIC_SR, sr);
-	spin_unlock_irqrestore(&uic->lock, flags);
+	raw_spin_unlock_irqrestore(&uic->lock, flags);
 }
 
 static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
@@ -152,7 +152,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	mask = ~(1 << (31 - src));
 
-	spin_lock_irqsave(&uic->lock, flags);
+	raw_spin_lock_irqsave(&uic->lock, flags);
 	tr = mfdcr(uic->dcrbase + UIC_TR);
 	pr = mfdcr(uic->dcrbase + UIC_PR);
 	tr = (tr & mask) | (trigger << (31-src));
@@ -161,7 +161,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 	mtdcr(uic->dcrbase + UIC_PR, pr);
 	mtdcr(uic->dcrbase + UIC_TR, tr);
 
-	spin_unlock_irqrestore(&uic->lock, flags);
+	raw_spin_unlock_irqrestore(&uic->lock, flags);
 
 	return 0;
 }
@@ -254,7 +254,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 	if (! uic)
 		return NULL; /* FIXME: panic? */
 
-	spin_lock_init(&uic->lock);
+	raw_spin_lock_init(&uic->lock);
 	indexp = of_get_property(node, "cell-index", &len);
 	if (!indexp || (len != sizeof(u32))) {
 		printk(KERN_ERR "uic: Device node %s has missing or invalid "
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 8694ef56..38e49bc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
  * cmci_discover_lock protects against parallel discovery attempts
  * which could race against each other.
  */
-static DEFINE_SPINLOCK(cmci_discover_lock);
+static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 
 #define CMCI_THRESHOLD 1
 
@@ -85,7 +85,7 @@ static void cmci_discover(int banks, int boot)
 	int hdr = 0;
 	int i;
 
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -116,7 +116,7 @@ static void cmci_discover(int banks, int boot)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
 }
@@ -150,7 +150,7 @@ void cmci_clear(void)
 
 	if (!cmci_supported(&banks))
 		return;
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
 			continue;
@@ -160,7 +160,7 @@ void cmci_clear(void)
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 68894fd..96646b3 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -355,10 +355,10 @@ static void nmi_cpu_setup(void *dummy)
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 	nmi_cpu_save_registers(msrs);
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
 	nmi_cpu_setup_mux(cpu, msrs);
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 431ab11..3e05314 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -852,7 +852,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 }
 
 static int c3_cpu_count;
-static DEFINE_SPINLOCK(c3_lock);
+static DEFINE_RAW_SPINLOCK(c3_lock);
 
 /**
  * acpi_idle_enter_bm - enters C3 with proper BM handling
@@ -930,12 +930,12 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 * without doing anything.
 	 */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
-		spin_lock(&c3_lock);
+		raw_spin_lock(&c3_lock);
 		c3_cpu_count++;
 		/* Disable bus master arbitration when all CPUs are in C3 */
 		if (c3_cpu_count == num_online_cpus())
 			acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 1);
-		spin_unlock(&c3_lock);
+		raw_spin_unlock(&c3_lock);
 	} else if (!pr->flags.bm_check) {
 		ACPI_FLUSH_CPU_CACHE();
 	}
@@ -944,10 +944,10 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	/* Re-enable bus master arbitration */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
-		spin_lock(&c3_lock);
+		raw_spin_lock(&c3_lock);
 		acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 0);
 		c3_cpu_count--;
-		spin_unlock(&c3_lock);
+		raw_spin_unlock(&c3_lock);
 	}
 	kt2 = ktime_get_real();
 	idle_time_ns = ktime_to_ns(ktime_sub(kt2, kt1));
diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index 4abd089..25ec0bb 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -35,7 +35,7 @@ MODULE_VERSION(DCA_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 
-static DEFINE_SPINLOCK(dca_lock);
+static DEFINE_RAW_SPINLOCK(dca_lock);
 
 static LIST_HEAD(dca_domains);
 
@@ -101,10 +101,10 @@ static void unregister_dca_providers(void)
 
 	INIT_LIST_HEAD(&unregistered_providers);
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	if (list_empty(&dca_domains)) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return;
 	}
 
@@ -116,7 +116,7 @@ static void unregister_dca_providers(void)
 
 	dca_free_domain(domain);
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	list_for_each_entry_safe(dca, _dca, &unregistered_providers, node) {
 		dca_sysfs_remove_provider(dca);
@@ -144,13 +144,8 @@ static struct dca_domain *dca_get_domain(struct device *dev)
 	domain = dca_find_domain(rc);
 
 	if (!domain) {
-		if (dca_provider_ioat_ver_3_0(dev) && !list_empty(&dca_domains)) {
+		if (dca_provider_ioat_ver_3_0(dev) && !list_empty(&dca_domains))
 			dca_providers_blocked = 1;
-		} else {
-			domain = dca_allocate_domain(rc);
-			if (domain)
-				list_add(&domain->node, &dca_domains);
-		}
 	}
 
 	return domain;
@@ -198,19 +193,19 @@ int dca_add_requester(struct device *dev)
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	/* check if the requester has not been added already */
 	dca = dca_find_provider_by_dev(dev);
 	if (dca) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return -EEXIST;
 	}
 
 	pci_rc = dca_pci_rc_from_dev(dev);
 	domain = dca_find_domain(pci_rc);
 	if (!domain) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 
@@ -220,17 +215,17 @@ int dca_add_requester(struct device *dev)
 			break;
 	}
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	if (slot < 0)
 		return slot;
 
 	err = dca_sysfs_add_req(dca, dev, slot);
 	if (err) {
-		spin_lock_irqsave(&dca_lock, flags);
+		raw_spin_lock_irqsave(&dca_lock, flags);
 		if (dca == dca_find_provider_by_dev(dev))
 			dca->ops->remove_requester(dca, dev);
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return err;
 	}
 
@@ -251,14 +246,14 @@ int dca_remove_requester(struct device *dev)
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	slot = dca->ops->remove_requester(dca, dev);
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	if (slot < 0)
 		return slot;
@@ -280,16 +275,16 @@ u8 dca_common_get_tag(struct device *dev, int cpu)
 	u8 tag;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	tag = dca->ops->get_tag(dca, dev, cpu);
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 	return tag;
 }
 
@@ -360,36 +355,51 @@ int register_dca_provider(struct dca_provider *dca, struct device *dev)
 {
 	int err;
 	unsigned long flags;
-	struct dca_domain *domain;
+	struct dca_domain *domain, *newdomain = NULL;
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 	if (dca_providers_blocked) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	err = dca_sysfs_add_provider(dca, dev);
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 	domain = dca_get_domain(dev);
 	if (!domain) {
+		struct pci_bus *rc;
+
 		if (dca_providers_blocked) {
-			spin_unlock_irqrestore(&dca_lock, flags);
+			raw_spin_unlock_irqrestore(&dca_lock, flags);
 			dca_sysfs_remove_provider(dca);
 			unregister_dca_providers();
-		} else {
-			spin_unlock_irqrestore(&dca_lock, flags);
+			return -ENODEV;
+		}
+
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		rc = dca_pci_rc_from_dev(dev);
+		newdomain = dca_allocate_domain(rc);
+		if (!newdomain)
+			return -ENODEV;
+		raw_spin_lock_irqsave(&dca_lock, flags);
+		/* Recheck, we might have raced after dropping the lock */
+		domain = dca_get_domain(dev);
+		if (!domain) {
+			domain = newdomain;
+			newdomain = NULL;
+			list_add(&domain->node, &dca_domains);
 		}
-		return -ENODEV;
 	}
 	list_add(&dca->node, &domain->dca_providers);
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_ADD, NULL);
+	kfree(newdomain);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(register_dca_provider);
@@ -407,7 +417,7 @@ void unregister_dca_provider(struct dca_provider *dca, struct device *dev)
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_REMOVE, NULL);
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	list_del(&dca->node);
 
@@ -416,7 +426,7 @@ void unregister_dca_provider(struct dca_provider *dca, struct device *dev)
 	if (list_empty(&domain->dca_providers))
 		dca_free_domain(domain);
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	dca_sysfs_remove_provider(dca);
 }
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index ab8a4ef..a71f55e 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -81,7 +81,7 @@ static struct ipu_irq_map irq_map[CONFIG_MX3_IPU_IRQS];
 /* Protects allocations from the above array of maps */
 static DEFINE_MUTEX(map_lock);
 /* Protects register accesses and individual mappings */
-static DEFINE_SPINLOCK(bank_lock);
+static DEFINE_RAW_SPINLOCK(bank_lock);
 
 static struct ipu_irq_map *src2map(unsigned int src)
 {
@@ -101,11 +101,11 @@ static void ipu_irq_unmask(struct irq_data *d)
 	uint32_t reg;
 	unsigned long lock_flags;
 
-	spin_lock_irqsave(&bank_lock, lock_flags);
+	raw_spin_lock_irqsave(&bank_lock, lock_flags);
 
 	bank = map->bank;
 	if (!bank) {
-		spin_unlock_irqrestore(&bank_lock, lock_flags);
+		raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
@@ -114,7 +114,7 @@ static void ipu_irq_unmask(struct irq_data *d)
 	reg |= (1UL << (map->source & 31));
 	ipu_write_reg(bank->ipu, reg, bank->control);
 
-	spin_unlock_irqrestore(&bank_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
 static void ipu_irq_mask(struct irq_data *d)
@@ -124,11 +124,11 @@ static void ipu_irq_mask(struct irq_data *d)
 	uint32_t reg;
 	unsigned long lock_flags;
 
-	spin_lock_irqsave(&bank_lock, lock_flags);
+	raw_spin_lock_irqsave(&bank_lock, lock_flags);
 
 	bank = map->bank;
 	if (!bank) {
-		spin_unlock_irqrestore(&bank_lock, lock_flags);
+		raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
@@ -137,7 +137,7 @@ static void ipu_irq_mask(struct irq_data *d)
 	reg &= ~(1UL << (map->source & 31));
 	ipu_write_reg(bank->ipu, reg, bank->control);
 
-	spin_unlock_irqrestore(&bank_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
 static void ipu_irq_ack(struct irq_data *d)
@@ -146,17 +146,17 @@ static void ipu_irq_ack(struct irq_data *d)
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
-	spin_lock_irqsave(&bank_lock, lock_flags);
+	raw_spin_lock_irqsave(&bank_lock, lock_flags);
 
 	bank = map->bank;
 	if (!bank) {
-		spin_unlock_irqrestore(&bank_lock, lock_flags);
+		raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
 	ipu_write_reg(bank->ipu, 1UL << (map->source & 31), bank->status);
-	spin_unlock_irqrestore(&bank_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
 /**
@@ -172,11 +172,11 @@ bool ipu_irq_status(unsigned int irq)
 	unsigned long lock_flags;
 	bool ret;
 
-	spin_lock_irqsave(&bank_lock, lock_flags);
+	raw_spin_lock_irqsave(&bank_lock, lock_flags);
 	bank = map->bank;
 	ret = bank && ipu_read_reg(bank->ipu, bank->status) &
 		(1UL << (map->source & 31));
-	spin_unlock_irqrestore(&bank_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 
 	return ret;
 }
@@ -213,10 +213,10 @@ int ipu_irq_map(unsigned int source)
 		if (irq_map[i].source < 0) {
 			unsigned long lock_flags;
 
-			spin_lock_irqsave(&bank_lock, lock_flags);
+			raw_spin_lock_irqsave(&bank_lock, lock_flags);
 			irq_map[i].source = source;
 			irq_map[i].bank = irq_bank + source / 32;
-			spin_unlock_irqrestore(&bank_lock, lock_flags);
+			raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 
 			ret = irq_map[i].irq;
 			pr_debug("IPU: mapped source %u to IRQ %u\n",
@@ -252,10 +252,10 @@ int ipu_irq_unmap(unsigned int source)
 			pr_debug("IPU: unmapped source %u from IRQ %u\n",
 				 source, irq_map[i].irq);
 
-			spin_lock_irqsave(&bank_lock, lock_flags);
+			raw_spin_lock_irqsave(&bank_lock, lock_flags);
 			irq_map[i].source = -EINVAL;
 			irq_map[i].bank = NULL;
-			spin_unlock_irqrestore(&bank_lock, lock_flags);
+			raw_spin_unlock_irqrestore(&bank_lock, lock_flags);
 
 			ret = 0;
 			break;
@@ -276,7 +276,7 @@ static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
 	for (i = IPU_IRQ_NR_FN_BANKS; i < IPU_IRQ_NR_BANKS; i++) {
 		struct ipu_irq_bank *bank = irq_bank + i;
 
-		spin_lock(&bank_lock);
+		raw_spin_lock(&bank_lock);
 		status = ipu_read_reg(ipu, bank->status);
 		/*
 		 * Don't think we have to clear all interrupts here, they will
@@ -284,18 +284,18 @@ static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
 		 * might want to clear unhandled interrupts after the loop...
 		 */
 		status &= ipu_read_reg(ipu, bank->control);
-		spin_unlock(&bank_lock);
+		raw_spin_unlock(&bank_lock);
 		while ((line = ffs(status))) {
 			struct ipu_irq_map *map;
 
 			line--;
 			status &= ~(1UL << line);
 
-			spin_lock(&bank_lock);
+			raw_spin_lock(&bank_lock);
 			map = src2map(32 * i + line);
 			if (map)
 				irq = map->irq;
-			spin_unlock(&bank_lock);
+			raw_spin_unlock(&bank_lock);
 
 			if (!map) {
 				pr_err("IPU: Interrupt on unmapped source %u bank %d\n",
@@ -317,22 +317,22 @@ static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
 	for (i = 0; i < IPU_IRQ_NR_FN_BANKS; i++) {
 		struct ipu_irq_bank *bank = irq_bank + i;
 
-		spin_lock(&bank_lock);
+		raw_spin_lock(&bank_lock);
 		status = ipu_read_reg(ipu, bank->status);
 		/* Not clearing all interrupts, see above */
 		status &= ipu_read_reg(ipu, bank->control);
-		spin_unlock(&bank_lock);
+		raw_spin_unlock(&bank_lock);
 		while ((line = ffs(status))) {
 			struct ipu_irq_map *map;
 
 			line--;
 			status &= ~(1UL << line);
 
-			spin_lock(&bank_lock);
+			raw_spin_lock(&bank_lock);
 			map = src2map(32 * i + line);
 			if (map)
 				irq = map->irq;
-			spin_unlock(&bank_lock);
+			raw_spin_unlock(&bank_lock);
 
 			if (!map) {
 				pr_err("IPU: Interrupt on unmapped source %u bank %d\n",
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 3dc9bef..388a118 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -800,7 +800,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		(unsigned long long)iommu->cap,
 		(unsigned long long)iommu->ecap);
 
-	spin_lock_init(&iommu->register_lock);
+	raw_spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
 	return 0;
@@ -921,11 +921,11 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
 restart:
 	rc = 0;
 
-	spin_lock_irqsave(&qi->q_lock, flags);
+	raw_spin_lock_irqsave(&qi->q_lock, flags);
 	while (qi->free_cnt < 3) {
-		spin_unlock_irqrestore(&qi->q_lock, flags);
+		raw_spin_unlock_irqrestore(&qi->q_lock, flags);
 		cpu_relax();
-		spin_lock_irqsave(&qi->q_lock, flags);
+		raw_spin_lock_irqsave(&qi->q_lock, flags);
 	}
 
 	index = qi->free_head;
@@ -965,15 +965,15 @@ restart:
 		if (rc)
 			break;
 
-		spin_unlock(&qi->q_lock);
+		raw_spin_unlock(&qi->q_lock);
 		cpu_relax();
-		spin_lock(&qi->q_lock);
+		raw_spin_lock(&qi->q_lock);
 	}
 
 	qi->desc_status[index] = QI_DONE;
 
 	reclaim_free_desc(qi);
-	spin_unlock_irqrestore(&qi->q_lock, flags);
+	raw_spin_unlock_irqrestore(&qi->q_lock, flags);
 
 	if (rc == -EAGAIN)
 		goto restart;
@@ -1062,7 +1062,7 @@ void dmar_disable_qi(struct intel_iommu *iommu)
 	if (!ecap_qis(iommu->ecap))
 		return;
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 
 	sts =  dmar_readq(iommu->reg + DMAR_GSTS_REG);
 	if (!(sts & DMA_GSTS_QIES))
@@ -1082,7 +1082,7 @@ void dmar_disable_qi(struct intel_iommu *iommu)
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl,
 		      !(sts & DMA_GSTS_QIES), sts);
 end:
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
 /*
@@ -1097,7 +1097,7 @@ static void __dmar_enable_qi(struct intel_iommu *iommu)
 	qi->free_head = qi->free_tail = 0;
 	qi->free_cnt = QI_LENGTH;
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 
 	/* write zero to the tail reg */
 	writel(0, iommu->reg + DMAR_IQT_REG);
@@ -1110,7 +1110,7 @@ static void __dmar_enable_qi(struct intel_iommu *iommu)
 	/* Make sure hardware complete it */
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
 /*
@@ -1159,7 +1159,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	qi->free_head = qi->free_tail = 0;
 	qi->free_cnt = QI_LENGTH;
 
-	spin_lock_init(&qi->q_lock);
+	raw_spin_lock_init(&qi->q_lock);
 
 	__dmar_enable_qi(iommu);
 
@@ -1225,11 +1225,11 @@ void dmar_msi_unmask(struct irq_data *data)
 	unsigned long flag;
 
 	/* unmask it */
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	writel(0, iommu->reg + DMAR_FECTL_REG);
 	/* Read a reg to force flush the post write */
 	readl(iommu->reg + DMAR_FECTL_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 void dmar_msi_mask(struct irq_data *data)
@@ -1238,11 +1238,11 @@ void dmar_msi_mask(struct irq_data *data)
 	struct intel_iommu *iommu = irq_data_get_irq_handler_data(data);
 
 	/* mask it */
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	writel(DMA_FECTL_IM, iommu->reg + DMAR_FECTL_REG);
 	/* Read a reg to force flush the post write */
 	readl(iommu->reg + DMAR_FECTL_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 void dmar_msi_write(int irq, struct msi_msg *msg)
@@ -1250,11 +1250,11 @@ void dmar_msi_write(int irq, struct msi_msg *msg)
 	struct intel_iommu *iommu = irq_get_handler_data(irq);
 	unsigned long flag;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	writel(msg->data, iommu->reg + DMAR_FEDATA_REG);
 	writel(msg->address_lo, iommu->reg + DMAR_FEADDR_REG);
 	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 void dmar_msi_read(int irq, struct msi_msg *msg)
@@ -1262,11 +1262,11 @@ void dmar_msi_read(int irq, struct msi_msg *msg)
 	struct intel_iommu *iommu = irq_get_handler_data(irq);
 	unsigned long flag;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	msg->data = readl(iommu->reg + DMAR_FEDATA_REG);
 	msg->address_lo = readl(iommu->reg + DMAR_FEADDR_REG);
 	msg->address_hi = readl(iommu->reg + DMAR_FEUADDR_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
@@ -1303,7 +1303,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 	u32 fault_status;
 	unsigned long flag;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
 	if (fault_status)
 		printk(KERN_ERR "DRHD: handling fault status reg %x\n",
@@ -1342,7 +1342,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 		writel(DMA_FRCD_F, iommu->reg + reg +
 			fault_index * PRIMARY_FAULT_REG_LEN + 12);
 
-		spin_unlock_irqrestore(&iommu->register_lock, flag);
+		raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 
 		dmar_fault_do_one(iommu, type, fault_reason,
 				source_id, guest_addr);
@@ -1350,14 +1350,14 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 		fault_index++;
 		if (fault_index >= cap_num_fault_regs(iommu->cap))
 			fault_index = 0;
-		spin_lock_irqsave(&iommu->register_lock, flag);
+		raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	}
 clear_rest:
 	/* clear all the other faults */
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
 	writel(fault_status, iommu->reg + DMAR_FSTS_REG);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..bf4a63c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -932,7 +932,7 @@ static void iommu_set_root_entry(struct intel_iommu *iommu)
 
 	addr = iommu->root_entry;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	dmar_writeq(iommu->reg + DMAR_RTADDR_REG, virt_to_phys(addr));
 
 	writel(iommu->gcmd | DMA_GCMD_SRTP, iommu->reg + DMAR_GCMD_REG);
@@ -941,7 +941,7 @@ static void iommu_set_root_entry(struct intel_iommu *iommu)
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_RTPS), sts);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 static void iommu_flush_write_buffer(struct intel_iommu *iommu)
@@ -952,14 +952,14 @@ static void iommu_flush_write_buffer(struct intel_iommu *iommu)
 	if (!rwbf_quirk && !cap_rwbf(iommu->cap))
 		return;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	writel(iommu->gcmd | DMA_GCMD_WBF, iommu->reg + DMAR_GCMD_REG);
 
 	/* Make sure hardware complete it */
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (!(val & DMA_GSTS_WBFS)), val);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 /* return value determine if we need a write buffer flush */
@@ -986,14 +986,14 @@ static void __iommu_flush_context(struct intel_iommu *iommu,
 	}
 	val |= DMA_CCMD_ICC;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	dmar_writeq(iommu->reg + DMAR_CCMD_REG, val);
 
 	/* Make sure hardware complete it */
 	IOMMU_WAIT_OP(iommu, DMAR_CCMD_REG,
 		dmar_readq, (!(val & DMA_CCMD_ICC)), val);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
 /* return value determine if we need a write buffer flush */
@@ -1032,7 +1032,7 @@ static void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
 	if (cap_write_drain(iommu->cap))
 		val |= DMA_TLB_WRITE_DRAIN;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	/* Note: Only uses first TLB reg currently */
 	if (val_iva)
 		dmar_writeq(iommu->reg + tlb_offset, val_iva);
@@ -1042,7 +1042,7 @@ static void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
 	IOMMU_WAIT_OP(iommu, tlb_offset + 8,
 		dmar_readq, (!(val & DMA_TLB_IVT)), val);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 
 	/* check IOTLB invalidation granularity */
 	if (DMA_TLB_IAIG(val) == 0)
@@ -1158,7 +1158,7 @@ static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
 	u32 pmen;
 	unsigned long flags;
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 	pmen = readl(iommu->reg + DMAR_PMEN_REG);
 	pmen &= ~DMA_PMEN_EPM;
 	writel(pmen, iommu->reg + DMAR_PMEN_REG);
@@ -1167,7 +1167,7 @@ static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
 	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
 		readl, !(pmen & DMA_PMEN_PRS), pmen);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
 static int iommu_enable_translation(struct intel_iommu *iommu)
@@ -1175,7 +1175,7 @@ static int iommu_enable_translation(struct intel_iommu *iommu)
 	u32 sts;
 	unsigned long flags;
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 	iommu->gcmd |= DMA_GCMD_TE;
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
 
@@ -1183,7 +1183,7 @@ static int iommu_enable_translation(struct intel_iommu *iommu)
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_TES), sts);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 	return 0;
 }
 
@@ -1192,7 +1192,7 @@ static int iommu_disable_translation(struct intel_iommu *iommu)
 	u32 sts;
 	unsigned long flag;
 
-	spin_lock_irqsave(&iommu->register_lock, flag);
+	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	iommu->gcmd &= ~DMA_GCMD_TE;
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
 
@@ -1200,7 +1200,7 @@ static int iommu_disable_translation(struct intel_iommu *iommu)
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (!(sts & DMA_GSTS_TES)), sts);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 	return 0;
 }
 
@@ -3320,7 +3320,7 @@ static int iommu_suspend(void)
 	for_each_active_iommu(iommu, drhd) {
 		iommu_disable_translation(iommu);
 
-		spin_lock_irqsave(&iommu->register_lock, flag);
+		raw_spin_lock_irqsave(&iommu->register_lock, flag);
 
 		iommu->iommu_state[SR_DMAR_FECTL_REG] =
 			readl(iommu->reg + DMAR_FECTL_REG);
@@ -3331,7 +3331,7 @@ static int iommu_suspend(void)
 		iommu->iommu_state[SR_DMAR_FEUADDR_REG] =
 			readl(iommu->reg + DMAR_FEUADDR_REG);
 
-		spin_unlock_irqrestore(&iommu->register_lock, flag);
+		raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 	}
 	return 0;
 
@@ -3358,7 +3358,7 @@ static void iommu_resume(void)
 
 	for_each_active_iommu(iommu, drhd) {
 
-		spin_lock_irqsave(&iommu->register_lock, flag);
+		raw_spin_lock_irqsave(&iommu->register_lock, flag);
 
 		writel(iommu->iommu_state[SR_DMAR_FECTL_REG],
 			iommu->reg + DMAR_FECTL_REG);
@@ -3369,7 +3369,7 @@ static void iommu_resume(void)
 		writel(iommu->iommu_state[SR_DMAR_FEUADDR_REG],
 			iommu->reg + DMAR_FEUADDR_REG);
 
-		spin_unlock_irqrestore(&iommu->register_lock, flag);
+		raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
 	}
 
 	for_each_active_iommu(iommu, drhd)
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 1a89d4a..73a9034 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -45,7 +45,7 @@ static __init int setup_intremap(char *str)
 }
 early_param("intremap", setup_intremap);
 
-static DEFINE_SPINLOCK(irq_2_ir_lock);
+static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
@@ -62,12 +62,12 @@ int get_irte(int irq, struct irte *entry)
 	if (!entry || !irq_iommu)
 		return -1;
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 	return 0;
 }
 
@@ -101,7 +101,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 		return -1;
 	}
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 	do {
 		for (i = index; i < index + count; i++)
 			if  (table->base[i].present)
@@ -113,7 +113,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 		index = (index + count) % INTR_REMAP_TABLE_ENTRIES;
 
 		if (index == start_index) {
-			spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+			raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 			printk(KERN_ERR "can't allocate an IRTE\n");
 			return -1;
 		}
@@ -127,7 +127,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	irq_iommu->sub_handle = 0;
 	irq_iommu->irte_mask = mask;
 
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return index;
 }
@@ -152,10 +152,10 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	if (!irq_iommu)
 		return -1;
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 	*sub_handle = irq_iommu->sub_handle;
 	index = irq_iommu->irte_index;
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 	return index;
 }
 
@@ -167,14 +167,14 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 	if (!irq_iommu)
 		return -1;
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
 	irq_iommu->sub_handle = subhandle;
 	irq_iommu->irte_mask = 0;
 
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return 0;
 }
@@ -190,7 +190,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	if (!irq_iommu)
 		return -1;
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
 	iommu = irq_iommu->iommu;
 
@@ -202,7 +202,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
 }
@@ -270,7 +270,7 @@ int free_irte(int irq)
 	if (!irq_iommu)
 		return -1;
 
-	spin_lock_irqsave(&irq_2_ir_lock, flags);
+	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
 	rc = clear_entries(irq_iommu);
 
@@ -279,7 +279,7 @@ int free_irte(int irq)
 	irq_iommu->sub_handle = 0;
 	irq_iommu->irte_mask = 0;
 
-	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
+	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
 }
@@ -409,7 +409,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 
 	addr = virt_to_phys((void *)iommu->ir_table->base);
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 
 	dmar_writeq(iommu->reg + DMAR_IRTA_REG,
 		    (addr) | IR_X2APIC_MODE(mode) | INTR_REMAP_TABLE_REG_SIZE);
@@ -420,7 +420,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRTPS), sts);
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 
 	/*
 	 * global invalidation of interrupt entry cache before enabling
@@ -428,7 +428,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 	 */
 	qi_global_iec(iommu);
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 
 	/* Enable interrupt-remapping */
 	iommu->gcmd |= DMA_GCMD_IRE;
@@ -437,7 +437,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRES), sts);
 
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
 
@@ -485,7 +485,7 @@ static void iommu_disable_intr_remapping(struct intel_iommu *iommu)
 	 */
 	qi_global_iec(iommu);
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	raw_spin_lock_irqsave(&iommu->register_lock, flags);
 
 	sts = dmar_readq(iommu->reg + DMAR_GSTS_REG);
 	if (!(sts & DMA_GSTS_IRES))
@@ -498,7 +498,7 @@ static void iommu_disable_intr_remapping(struct intel_iommu *iommu)
 		      readl, !(sts & DMA_GSTS_IRES), sts);
 
 end:
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
 int __init intr_remapping_supported(void)
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index dd87e86..c0cc4e7 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -82,10 +82,10 @@ int alloc_event_buffer(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	buffer_size = oprofile_buffer_size;
 	buffer_watershed = oprofile_buffer_watershed;
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 94796f3..da14432 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -160,9 +160,9 @@ static int oprofile_perf_create_files(struct super_block *sb, struct dentry *roo
 
 static int oprofile_perf_setup(void)
 {
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	op_perf_setup();
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	return 0;
 }
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index e9ff6f7..d0de6cc 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -21,7 +21,7 @@
 
 #define OPROFILEFS_MAGIC 0x6f70726f
 
-DEFINE_SPINLOCK(oprofilefs_lock);
+DEFINE_RAW_SPINLOCK(oprofilefs_lock);
 
 static struct inode *oprofilefs_get_inode(struct super_block *sb, int mode)
 {
@@ -76,9 +76,9 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
 	if (copy_from_user(tmpbuf, buf, count))
 		return -EFAULT;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 	return 0;
 }
 
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 915fd74..d449a74 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -50,7 +50,7 @@
 #include <video/vga.h>
 #include <asm/io.h>
 
-static DEFINE_SPINLOCK(vga_lock);
+static DEFINE_RAW_SPINLOCK(vga_lock);
 static int cursor_size_lastfrom;
 static int cursor_size_lastto;
 static u32 vgacon_xres;
@@ -157,7 +157,7 @@ static inline void write_vga(unsigned char reg, unsigned int val)
 	 * ddprintk might set the console position from interrupt
 	 * handlers, thus the write has to be IRQ-atomic.
 	 */
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 
 #ifndef SLOW_VGA
 	v1 = reg + (val & 0xff00);
@@ -170,7 +170,7 @@ static inline void write_vga(unsigned char reg, unsigned int val)
 	outb_p(reg + 1, vga_video_port_reg);
 	outb_p(val & 0xff, vga_video_port_val);
 #endif
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 }
 
 static inline void vga_set_mem_top(struct vc_data *c)
@@ -664,7 +664,7 @@ static void vgacon_set_cursor_size(int xpos, int from, int to)
 	cursor_size_lastfrom = from;
 	cursor_size_lastto = to;
 
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 	if (vga_video_type >= VIDEO_TYPE_VGAC) {
 		outb_p(VGA_CRTC_CURSOR_START, vga_video_port_reg);
 		curs = inb_p(vga_video_port_val);
@@ -682,7 +682,7 @@ static void vgacon_set_cursor_size(int xpos, int from, int to)
 	outb_p(curs, vga_video_port_val);
 	outb_p(VGA_CRTC_CURSOR_END, vga_video_port_reg);
 	outb_p(cure, vga_video_port_val);
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 }
 
 static void vgacon_cursor(struct vc_data *c, int mode)
@@ -757,7 +757,7 @@ static int vgacon_doresize(struct vc_data *c,
 	unsigned int scanlines = height * c->vc_font.height;
 	u8 scanlines_lo = 0, r7 = 0, vsync_end = 0, mode, max_scan;
 
-	spin_lock_irqsave(&vga_lock, flags);
+	raw_spin_lock_irqsave(&vga_lock, flags);
 
 	vgacon_xres = width * VGA_FONTWIDTH;
 	vgacon_yres = height * c->vc_font.height;
@@ -808,7 +808,7 @@ static int vgacon_doresize(struct vc_data *c,
 		outb_p(vsync_end, vga_video_port_val);
 	}
 
-	spin_unlock_irqrestore(&vga_lock, flags);
+	raw_spin_unlock_irqrestore(&vga_lock, flags);
 	return 0;
 }
 
@@ -891,11 +891,11 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 {
 	/* save original values of VGA controller registers */
 	if (!vga_vesa_blanked) {
-		spin_lock_irq(&vga_lock);
+		raw_spin_lock_irq(&vga_lock);
 		vga_state.SeqCtrlIndex = vga_r(state->vgabase, VGA_SEQ_I);
 		vga_state.CrtCtrlIndex = inb_p(vga_video_port_reg);
 		vga_state.CrtMiscIO = vga_r(state->vgabase, VGA_MIS_R);
-		spin_unlock_irq(&vga_lock);
+		raw_spin_unlock_irq(&vga_lock);
 
 		outb_p(0x00, vga_video_port_reg);	/* HorizontalTotal */
 		vga_state.HorizontalTotal = inb_p(vga_video_port_val);
@@ -918,7 +918,7 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 
 	/* assure that video is enabled */
 	/* "0x20" is VIDEO_ENABLE_bit in register 01 of sequencer */
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE, vga_state.ClockingMode | 0x20);
 
 	/* test for vertical retrace in process.... */
@@ -954,13 +954,13 @@ static void vga_vesa_blank(struct vgastate *state, int mode)
 	/* restore both index registers */
 	vga_w(state->vgabase, VGA_SEQ_I, vga_state.SeqCtrlIndex);
 	outb_p(vga_state.CrtCtrlIndex, vga_video_port_reg);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 }
 
 static void vga_vesa_unblank(struct vgastate *state)
 {
 	/* restore original values of VGA controller registers */
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	vga_w(state->vgabase, VGA_MIS_W, vga_state.CrtMiscIO);
 
 	outb_p(0x00, vga_video_port_reg);	/* HorizontalTotal */
@@ -985,7 +985,7 @@ static void vga_vesa_unblank(struct vgastate *state)
 	/* restore index/control registers */
 	vga_w(state->vgabase, VGA_SEQ_I, vga_state.SeqCtrlIndex);
 	outb_p(vga_state.CrtCtrlIndex, vga_video_port_reg);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 }
 
 static void vga_pal_blank(struct vgastate *state)
@@ -1104,7 +1104,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		charmap += 4 * cmapsz;
 #endif
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	/* First, the Sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
 	/* CPU writes only to map 2 */
@@ -1120,7 +1120,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 	vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x00);
 	/* map start at A000:0000 */
 	vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x00);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 
 	if (arg) {
 		if (set)
@@ -1147,7 +1147,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		}
 	}
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	/* First, the sequencer, Synchronous reset */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x01);	
 	/* CPU writes to maps 0 and 1 */
@@ -1186,7 +1186,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		inb_p(video_port_status);
 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
 	}
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 	return 0;
 }
 
@@ -1211,26 +1211,26 @@ static int vgacon_adjust_height(struct vc_data *vc, unsigned fontheight)
 	   registers; they are write-only on EGA, but it appears that they
 	   are all don't care bits on EGA, so I guess it doesn't matter. */
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	outb_p(0x07, vga_video_port_reg);	/* CRTC overflow register */
 	ovr = inb_p(vga_video_port_val);
 	outb_p(0x09, vga_video_port_reg);	/* Font size register */
 	fsr = inb_p(vga_video_port_val);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 
 	vde = maxscan & 0xff;	/* Vertical display end reg */
 	ovr = (ovr & 0xbd) +	/* Overflow register */
 	    ((maxscan & 0x100) >> 7) + ((maxscan & 0x200) >> 3);
 	fsr = (fsr & 0xe0) + (fontheight - 1);	/*  Font size register */
 
-	spin_lock_irq(&vga_lock);
+	raw_spin_lock_irq(&vga_lock);
 	outb_p(0x07, vga_video_port_reg);	/* CRTC overflow register */
 	outb_p(ovr, vga_video_port_val);
 	outb_p(0x09, vga_video_port_reg);	/* Font size */
 	outb_p(fsr, vga_video_port_val);
 	outb_p(0x12, vga_video_port_reg);	/* Vertical display limit */
 	outb_p(vde, vga_video_port_val);
-	spin_unlock_irq(&vga_lock);
+	raw_spin_unlock_irq(&vga_lock);
 	vga_video_font_height = fontheight;
 
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..08ffab0 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -42,7 +42,7 @@ extern struct fs_struct init_fs;
 	.cputimer	= { 						\
 		.cputime = INIT_CPUTIME,				\
 		.running = 0,						\
-		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
+		.lock = __RAW_SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 9310c69..8b9b5d3 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -271,7 +271,7 @@ struct qi_desc {
 };
 
 struct q_inval {
-	spinlock_t      q_lock;
+	raw_spinlock_t  q_lock;
 	struct qi_desc  *desc;          /* invalidation queue */
 	int             *desc_status;   /* desc status */
 	int             free_head;      /* first free entry */
@@ -311,7 +311,7 @@ struct intel_iommu {
 	u64		cap;
 	u64		ecap;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
-	spinlock_t	register_lock; /* protect register handling */
+	raw_spinlock_t	register_lock; /* protect register handling */
 	int		seq_id;	/* sequence id of the iommu */
 	int		agaw; /* agaw of this iommu */
 	int		msagaw; /* max sagaw of this iommu */
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index dd7c12e..dce6e4d 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -181,7 +181,7 @@ struct kretprobe {
 	int nmissed;
 	size_t data_size;
 	struct hlist_head free_instances;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 struct kretprobe_instance {
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 49c8727..a4c5624 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -166,7 +166,7 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user * buf, size_t co
 int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count);
 
 /** lock for read/write safety */
-extern spinlock_t oprofilefs_lock;
+extern raw_spinlock_t oprofilefs_lock;
 
 /**
  * Add the contents of a circular buffer to the event buffer.
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 5edc901..b9df9ed 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -16,7 +16,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..ef35bb7 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -58,7 +58,7 @@ struct prop_local_percpu {
 	 */
 	int shift;
 	unsigned long period;
-	spinlock_t lock;		/* protect the snapshot state */
+	raw_spinlock_t lock;		/* protect the snapshot state */
 };
 
 int prop_local_init_percpu(struct prop_local_percpu *pl);
@@ -106,11 +106,11 @@ struct prop_local_single {
 	 */
 	unsigned long period;
 	int shift;
-	spinlock_t lock;		/* protect the snapshot state */
+	raw_spinlock_t lock;		/* protect the snapshot state */
 };
 
 #define INIT_PROP_LOCAL_SINGLE(name)			\
-{	.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
+{	.lock = __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 
 int prop_local_init_single(struct prop_local_single *pl);
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 2f00715..e11ccb4 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -8,7 +8,7 @@
 #define DEFAULT_RATELIMIT_BURST		10
 
 struct ratelimit_state {
-	spinlock_t	lock;		/* protect the state */
+	raw_spinlock_t	lock;		/* protect the state */
 
 	int		interval;
 	int		burst;
@@ -20,7 +20,7 @@ struct ratelimit_state {
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
 									\
 	struct ratelimit_state name = {					\
-		.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
@@ -28,7 +28,7 @@ struct ratelimit_state {
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
-	spin_lock_init(&rs->lock);
+	raw_spin_lock_init(&rs->lock);
 	rs->interval = interval;
 	rs->burst = burst;
 	rs->printed = 0;
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 3470124..d5b13bc 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -22,7 +22,7 @@
  */
 struct rw_semaphore {
 	__s32			activity;
-	spinlock_t		wait_lock;
+	raw_spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 6a67414..63d4065 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -25,7 +25,7 @@ struct rw_semaphore;
 /* All arch specific implementations share the same struct */
 struct rw_semaphore {
 	long			count;
-	spinlock_t		wait_lock;
+	raw_spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -56,9 +56,11 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-	  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_INITIALIZER(name)			\
+	{ RWSEM_UNLOCKED_VALUE,				\
+	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  LIST_HEAD_INIT((name).wait_list)		\
+	  __RWSEM_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..e672236 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -510,7 +510,7 @@ struct task_cputime {
 struct thread_group_cputimer {
 	struct task_cputime cputime;
 	int running;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 #include <linux/rwsem.h>
@@ -2566,7 +2566,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	spin_lock_init(&sig->cputimer.lock);
+	raw_spin_lock_init(&sig->cputimer.lock);
 }
 
 /*
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 39fa049..dc368b8 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -14,14 +14,14 @@
 
 /* Please don't access any members of this structure directly */
 struct semaphore {
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 	unsigned int		count;
 	struct list_head	wait_list;
 };
 
 #define __SEMAPHORE_INITIALIZER(name, n)				\
 {									\
-	.lock		= __SPIN_LOCK_UNLOCKED((name).lock),		\
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED((name).lock),	\
 	.count		= n,						\
 	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
 }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d2b6ce..453100a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -265,7 +265,7 @@ list_for_each_entry(_root, &roots, root_list)
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
-static DEFINE_SPINLOCK(release_list_lock);
+static DEFINE_RAW_SPINLOCK(release_list_lock);
 static void cgroup_release_agent(struct work_struct *work);
 static DECLARE_WORK(release_agent_work, cgroup_release_agent);
 static void check_for_release(struct cgroup *cgrp);
@@ -4014,11 +4014,11 @@ again:
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	spin_lock(&release_list_lock);
+	raw_spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
 		list_del_init(&cgrp->release_list);
-	spin_unlock(&release_list_lock);
+	raw_spin_unlock(&release_list_lock);
 
 	cgroup_lock_hierarchy(cgrp->root);
 	/* delete this cgroup from parent->children */
@@ -4671,13 +4671,13 @@ static void check_for_release(struct cgroup *cgrp)
 		 * already queued for a userspace notification, queue
 		 * it now */
 		int need_schedule_work = 0;
-		spin_lock(&release_list_lock);
+		raw_spin_lock(&release_list_lock);
 		if (!cgroup_is_removed(cgrp) &&
 		    list_empty(&cgrp->release_list)) {
 			list_add(&cgrp->release_list, &release_list);
 			need_schedule_work = 1;
 		}
-		spin_unlock(&release_list_lock);
+		raw_spin_unlock(&release_list_lock);
 		if (need_schedule_work)
 			schedule_work(&release_agent_work);
 	}
@@ -4729,7 +4729,7 @@ static void cgroup_release_agent(struct work_struct *work)
 {
 	BUG_ON(work != &release_agent_work);
 	mutex_lock(&cgroup_mutex);
-	spin_lock(&release_list_lock);
+	raw_spin_lock(&release_list_lock);
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
 		int i;
@@ -4738,7 +4738,7 @@ static void cgroup_release_agent(struct work_struct *work)
 						    struct cgroup,
 						    release_list);
 		list_del_init(&cgrp->release_list);
-		spin_unlock(&release_list_lock);
+		raw_spin_unlock(&release_list_lock);
 		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!pathbuf)
 			goto continue_free;
@@ -4768,9 +4768,9 @@ static void cgroup_release_agent(struct work_struct *work)
  continue_free:
 		kfree(pathbuf);
 		kfree(agentbuf);
-		spin_lock(&release_list_lock);
+		raw_spin_lock(&release_list_lock);
 	}
-	spin_unlock(&release_list_lock);
+	raw_spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b30fd54..2f193d0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -78,10 +78,10 @@ static bool kprobes_all_disarmed;
 static DEFINE_MUTEX(kprobe_mutex);
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
-	spinlock_t lock ____cacheline_aligned_in_smp;
+	raw_spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
 
-static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
+static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 {
 	return &(kretprobe_table_locks[hash].lock);
 }
@@ -1013,9 +1013,9 @@ void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 	hlist_del(&ri->hlist);
 	INIT_HLIST_NODE(&ri->hlist);
 	if (likely(rp)) {
-		spin_lock(&rp->lock);
+		raw_spin_lock(&rp->lock);
 		hlist_add_head(&ri->hlist, &rp->free_instances);
-		spin_unlock(&rp->lock);
+		raw_spin_unlock(&rp->lock);
 	} else
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
@@ -1026,19 +1026,19 @@ void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 __acquires(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	spinlock_t *hlist_lock;
+	raw_spinlock_t *hlist_lock;
 
 	*head = &kretprobe_inst_table[hash];
 	hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_lock_irqsave(hlist_lock, *flags);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
 
 static void __kprobes kretprobe_table_lock(unsigned long hash,
 	unsigned long *flags)
 __acquires(hlist_lock)
 {
-	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_lock_irqsave(hlist_lock, *flags);
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
 
 void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
@@ -1046,18 +1046,18 @@ void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
 __releases(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	spinlock_t *hlist_lock;
+	raw_spinlock_t *hlist_lock;
 
 	hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_unlock_irqrestore(hlist_lock, *flags);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 static void __kprobes kretprobe_table_unlock(unsigned long hash,
        unsigned long *flags)
 __releases(hlist_lock)
 {
-	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_unlock_irqrestore(hlist_lock, *flags);
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 /*
@@ -1663,12 +1663,12 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
-	spin_lock_irqsave(&rp->lock, flags);
+	raw_spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
 		ri = hlist_entry(rp->free_instances.first,
 				struct kretprobe_instance, hlist);
 		hlist_del(&ri->hlist);
-		spin_unlock_irqrestore(&rp->lock, flags);
+		raw_spin_unlock_irqrestore(&rp->lock, flags);
 
 		ri->rp = rp;
 		ri->task = current;
@@ -1685,7 +1685,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 		kretprobe_table_unlock(hash, &flags);
 	} else {
 		rp->nmissed++;
-		spin_unlock_irqrestore(&rp->lock, flags);
+		raw_spin_unlock_irqrestore(&rp->lock, flags);
 	}
 	return 0;
 }
@@ -1721,7 +1721,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 		rp->maxactive = num_possible_cpus();
 #endif
 	}
-	spin_lock_init(&rp->lock);
+	raw_spin_lock_init(&rp->lock);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kmalloc(sizeof(struct kretprobe_instance) +
@@ -1959,7 +1959,7 @@ static int __init init_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
-		spin_lock_init(&(kretprobe_table_locks[i].lock));
+		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
 	/*
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 376066e..4ac8ebf 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -58,7 +58,7 @@
 #include <linux/list.h>
 #include <linux/stacktrace.h>
 
-static DEFINE_SPINLOCK(latency_lock);
+static DEFINE_RAW_SPINLOCK(latency_lock);
 
 #define MAXLR 128
 static struct latency_record latency_record[MAXLR];
@@ -72,19 +72,19 @@ void clear_all_latency_tracing(struct task_struct *p)
 	if (!latencytop_enabled)
 		return;
 
-	spin_lock_irqsave(&latency_lock, flags);
+	raw_spin_lock_irqsave(&latency_lock, flags);
 	memset(&p->latency_record, 0, sizeof(p->latency_record));
 	p->latency_record_count = 0;
-	spin_unlock_irqrestore(&latency_lock, flags);
+	raw_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static void clear_global_latency_tracing(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&latency_lock, flags);
+	raw_spin_lock_irqsave(&latency_lock, flags);
 	memset(&latency_record, 0, sizeof(latency_record));
-	spin_unlock_irqrestore(&latency_lock, flags);
+	raw_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static void __sched
@@ -190,7 +190,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	lat.max = usecs;
 	store_stacktrace(tsk, &lat);
 
-	spin_lock_irqsave(&latency_lock, flags);
+	raw_spin_lock_irqsave(&latency_lock, flags);
 
 	account_global_scheduler_latency(tsk, &lat);
 
@@ -231,7 +231,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));
 
 out_unlock:
-	spin_unlock_irqrestore(&latency_lock, flags);
+	raw_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static int lstats_show(struct seq_file *m, void *v)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..c081fa9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -96,8 +96,13 @@ static int graph_lock(void)
 
 static inline int graph_unlock(void)
 {
-	if (debug_locks && !arch_spin_is_locked(&lockdep_lock))
+	if (debug_locks && !arch_spin_is_locked(&lockdep_lock)) {
+		/*
+		 * The lockdep graph lock isn't locked while we expect it to
+		 * be, we're confused now, bye!
+		 */
 		return DEBUG_LOCKS_WARN_ON(1);
+	}
 
 	current->lockdep_recursion--;
 	arch_spin_unlock(&lockdep_lock);
@@ -134,6 +139,9 @@ static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 static inline struct lock_class *hlock_class(struct held_lock *hlock)
 {
 	if (!hlock->class_idx) {
+		/*
+		 * Someone passed in garbage, we give up.
+		 */
 		DEBUG_LOCKS_WARN_ON(1);
 		return NULL;
 	}
@@ -687,6 +695,10 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	 */
 	list_for_each_entry(class, hash_head, hash_entry) {
 		if (class->key == key) {
+			/*
+			 * Huh! same key, different name? Did someone trample
+			 * on some memory? We're most confused.
+			 */
 			WARN_ON_ONCE(class->name != lock->name);
 			return class;
 		}
@@ -800,6 +812,10 @@ out_unlock_set:
 	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
 		lock->class_cache[subclass] = class;
 
+	/*
+	 * Hash collision, did we smoke some? We found a class with a matching
+	 * hash but the subclass -- which is hashed in -- didn't match.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
 		return NULL;
 
@@ -926,7 +942,7 @@ static inline void mark_lock_accessed(struct lock_list *lock,
 	unsigned long nr;
 
 	nr = lock - list_entries;
-	WARN_ON(nr >= nr_list_entries);
+	WARN_ON(nr >= nr_list_entries); /* Out-of-bounds, input fail */
 	lock->parent = parent;
 	lock->class->dep_gen_id = lockdep_dependency_gen_id;
 }
@@ -936,7 +952,7 @@ static inline unsigned long lock_accessed(struct lock_list *lock)
 	unsigned long nr;
 
 	nr = lock - list_entries;
-	WARN_ON(nr >= nr_list_entries);
+	WARN_ON(nr >= nr_list_entries); /* Out-of-bounds, input fail */
 	return lock->class->dep_gen_id == lockdep_dependency_gen_id;
 }
 
@@ -1196,6 +1212,9 @@ static noinline int print_bfs_bug(int ret)
 	if (!debug_locks_off_graph_unlock())
 		return 0;
 
+	/*
+	 * Breadth-first-search failed, graph got corrupted?
+	 */
 	WARN(1, "lockdep bfs error:%d\n", ret);
 
 	return 0;
@@ -1944,6 +1963,11 @@ out_bug:
 	if (!debug_locks_off_graph_unlock())
 		return 0;
 
+	/*
+	 * Clearly we all shouldn't be here, but since we made it we
+	 * can reliable say we messed up our state. See the above two
+	 * gotos for reasons why we could possibly end up here.
+	 */
 	WARN_ON(1);
 
 	return 0;
@@ -1975,6 +1999,11 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct held_lock *hlock_curr, *hlock_next;
 	int i, j;
 
+	/*
+	 * We might need to take the graph lock, ensure we've got IRQs
+	 * disabled to make this an IRQ-safe lock.. for recursion reasons
+	 * lockdep won't complain about its own locking errors.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 	/*
@@ -2126,6 +2155,10 @@ static void check_chain_key(struct task_struct *curr)
 		hlock = curr->held_locks + i;
 		if (chain_key != hlock->prev_chain_key) {
 			debug_locks_off();
+			/*
+			 * We got mighty confused, our chain keys don't match
+			 * with what we expect, someone trample on our task state?
+			 */
 			WARN(1, "hm#1, depth: %u [%u], %016Lx != %016Lx\n",
 				curr->lockdep_depth, i,
 				(unsigned long long)chain_key,
@@ -2133,6 +2166,9 @@ static void check_chain_key(struct task_struct *curr)
 			return;
 		}
 		id = hlock->class_idx - 1;
+		/*
+		 * Whoops ran out of static storage again?
+		 */
 		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 			return;
 
@@ -2144,6 +2180,10 @@ static void check_chain_key(struct task_struct *curr)
 	}
 	if (chain_key != curr->curr_chain_key) {
 		debug_locks_off();
+		/*
+		 * More smoking hash instead of calculating it, damn see these
+		 * numbers float.. I bet that a pink elephant stepped on my memory.
+		 */
 		WARN(1, "hm#2, depth: %u [%u], %016Lx != %016Lx\n",
 			curr->lockdep_depth, i,
 			(unsigned long long)chain_key,
@@ -2525,12 +2565,24 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 	}
 
+	/*
+	 * We're enabling irqs and according to our state above irqs weren't
+	 * already enabled, yet we find the hardware thinks they are in fact
+	 * enabled.. someone messed up their IRQ state tracing.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
+	/*
+	 * See the fine text that goes along with this variable definition.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
+	/*
+	 * Can't allow enabling interrupts while in an interrupt handler,
+	 * that's general bad form and such. Recursion, limited stack etc..
+	 */
 	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
 		return;
 
@@ -2558,6 +2610,10 @@ void trace_hardirqs_off_caller(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	/*
+	 * So we're supposed to get called after you mask local IRQs, but for
+	 * some reason the hardware doesn't quite think you did a proper job.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
@@ -2590,6 +2646,10 @@ void trace_softirqs_on(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	/*
+	 * We fancy IRQs being disabled here, see softirq.c, avoids
+	 * funny state and nesting things.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
@@ -2626,6 +2686,9 @@ void trace_softirqs_off(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	/*
+	 * We fancy IRQs being disabled here, see softirq.c
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
@@ -2637,6 +2700,9 @@ void trace_softirqs_off(unsigned long ip)
 		curr->softirq_disable_ip = ip;
 		curr->softirq_disable_event = ++curr->irq_events;
 		debug_atomic_inc(softirqs_off_events);
+		/*
+		 * Whoops, we wanted softirqs off, so why aren't they?
+		 */
 		DEBUG_LOCKS_WARN_ON(!softirq_count());
 	} else
 		debug_atomic_inc(redundant_softirqs_off);
@@ -2661,6 +2727,9 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 	if (!(gfp_mask & __GFP_FS))
 		return;
 
+	/*
+	 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
 		return;
 
@@ -2773,13 +2842,13 @@ static int separate_irq_context(struct task_struct *curr,
 	return 0;
 }
 
-#else
+#else /* defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING) */
 
 static inline
 int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit new_bit)
 {
-	WARN_ON(1);
+	WARN_ON(1); /* Impossible innit? when we don't have TRACE_IRQFLAG */
 	return 1;
 }
 
@@ -2799,7 +2868,7 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 {
 }
 
-#endif
+#endif /* defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING) */
 
 /*
  * Mark a lock with a usage bit, and validate the state transition:
@@ -2880,6 +2949,9 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	lock->cpu = raw_smp_processor_id();
 #endif
 
+	/*
+	 * Can't be having no nameless bastards around this place!
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!name)) {
 		lock->name = "NULL";
 		return;
@@ -2887,6 +2959,9 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 
 	lock->name = name;
 
+	/*
+	 * No key, no joy, we need to hash something.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!key))
 		return;
 	/*
@@ -2894,6 +2969,9 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	 */
 	if (!static_obj(key)) {
 		printk("BUG: key %p not in .data!\n", key);
+		/*
+		 * What it says above ^^^^^, I suggest you read it.
+		 */
 		DEBUG_LOCKS_WARN_ON(1);
 		return;
 	}
@@ -2932,6 +3010,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (unlikely(!debug_locks))
 		return 0;
 
+	/*
+	 * Lockdep should run with IRQs disabled, otherwise we could
+	 * get an interrupt which would want to take locks, which would
+	 * end up in lockdep and have you got a head-ache already?
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
@@ -2963,6 +3046,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	 * dependency checks are done)
 	 */
 	depth = curr->lockdep_depth;
+	/*
+	 * Ran out of static storage for our per-task lock stack again have we?
+	 */
 	if (DEBUG_LOCKS_WARN_ON(depth >= MAX_LOCK_DEPTH))
 		return 0;
 
@@ -2981,6 +3067,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	}
 
 	hlock = curr->held_locks + depth;
+	/*
+	 * Plain impossible, we just registered it and checked it weren't no
+	 * NULL like.. I bet this mushroom I ate was good!
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!class))
 		return 0;
 	hlock->class_idx = class_idx;
@@ -3015,11 +3105,17 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	 * the hash, not class->key.
 	 */
 	id = class - lock_classes;
+	/*
+	 * Whoops, we did it again.. ran straight out of our static allocation.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 		return 0;
 
 	chain_key = curr->curr_chain_key;
 	if (!depth) {
+		/*
+		 * How can we have a chain hash when we ain't got no keys?!
+		 */
 		if (DEBUG_LOCKS_WARN_ON(chain_key != 0))
 			return 0;
 		chain_head = 1;
@@ -3091,6 +3187,9 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
 {
 	if (unlikely(!debug_locks))
 		return 0;
+	/*
+	 * Lockdep should run with IRQs disabled, recursion, head-ache, etc..
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
@@ -3120,6 +3219,11 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		if (!class)
 			return 0;
 
+		/*
+		 * References, but not a lock we're actually ref-counting?
+		 * State got messed up, follow the sites that change ->references
+		 * and try to make sense of it.
+		 */
 		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
 			return 0;
 
@@ -3142,6 +3246,10 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 	int i;
 
 	depth = curr->lockdep_depth;
+	/*
+	 * This function is about (re)setting the class of a held lock,
+	 * yet we're not actually holding any locks. Naughty user!
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!depth))
 		return 0;
 
@@ -3177,6 +3285,10 @@ found_it:
 			return 0;
 	}
 
+	/*
+	 * I took it apart and put it back together again, except now I have
+	 * these 'spare' parts.. where shall I put them.
+	 */
 	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
 		return 0;
 	return 1;
@@ -3201,6 +3313,10 @@ lock_release_non_nested(struct task_struct *curr,
 	 * of held locks:
 	 */
 	depth = curr->lockdep_depth;
+	/*
+	 * So we're all set to release this lock.. wait what lock? We don't
+	 * own any locks, you've been drinking again?
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!depth))
 		return 0;
 
@@ -3253,6 +3369,10 @@ found_it:
 			return 0;
 	}
 
+	/*
+	 * We had N bottles of beer on the wall, we drank one, but now
+	 * there's not N-1 bottles of beer left on the wall...
+	 */
 	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth - 1))
 		return 0;
 	return 1;
@@ -3283,6 +3403,9 @@ static int lock_release_nested(struct task_struct *curr,
 		return lock_release_non_nested(curr, lock, ip);
 	curr->lockdep_depth--;
 
+	/*
+	 * No more locks, but somehow we've got hash left over, who left it?
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!depth && (hlock->prev_chain_key != 0)))
 		return 0;
 
@@ -3365,10 +3488,13 @@ static void check_flags(unsigned long flags)
 	 * check if not in hardirq contexts:
 	 */
 	if (!hardirq_count()) {
-		if (softirq_count())
+		if (softirq_count()) {
+			/* like the above, but with softirqs */
 			DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
-		else
+		} else {
+			/* lick the above, does it taste good? */
 			DEBUG_LOCKS_WARN_ON(!current->softirqs_enabled);
+		}
 	}
 
 	if (!debug_locks)
@@ -3506,6 +3632,10 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 	int i, contention_point, contending_point;
 
 	depth = curr->lockdep_depth;
+	/*
+	 * Whee, we contended on this lock, except it seems we're not
+	 * actually trying to acquire anything much at all..
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!depth))
 		return;
 
@@ -3555,6 +3685,10 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	int i, cpu;
 
 	depth = curr->lockdep_depth;
+	/*
+	 * Yay, we acquired ownership of this lock we didn't try to
+	 * acquire, how the heck did that happen?
+	 */
 	if (DEBUG_LOCKS_WARN_ON(!depth))
 		return;
 
@@ -3759,8 +3893,12 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 				match |= class == lock->class_cache[j];
 
 			if (unlikely(match)) {
-				if (debug_locks_off_graph_unlock())
+				if (debug_locks_off_graph_unlock()) {
+					/*
+					 * We all just reset everything, how did it match?
+					 */
 					WARN_ON(1);
+				}
 				goto out_restore;
 			}
 		}
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..41440cc 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -274,7 +274,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct task_cputime sum;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
+	raw_spin_lock_irqsave(&cputimer->lock, flags);
 	if (!cputimer->running) {
 		cputimer->running = 1;
 		/*
@@ -287,7 +287,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		update_gt_cputime(&cputimer->cputime, &sum);
 	}
 	*times = cputimer->cputime;
-	spin_unlock_irqrestore(&cputimer->lock, flags);
+	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
 /*
@@ -997,9 +997,9 @@ static void stop_process_timers(struct signal_struct *sig)
 	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
+	raw_spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
-	spin_unlock_irqrestore(&cputimer->lock, flags);
+	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
 static u32 onecputick;
@@ -1289,9 +1289,9 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
-		spin_lock(&sig->cputimer.lock);
+		raw_spin_lock(&sig->cputimer.lock);
 		group_sample = sig->cputimer.cputime;
-		spin_unlock(&sig->cputimer.lock);
+		raw_spin_unlock(&sig->cputimer.lock);
 
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
diff --git a/kernel/printk.c b/kernel/printk.c
index 28a40d8..b7da183 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -100,7 +100,7 @@ static int console_locked, console_suspended;
  * It is also used in interesting ways to provide interlocking in
  * console_unlock();.
  */
-static DEFINE_SPINLOCK(logbuf_lock);
+static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #define LOG_BUF_MASK (log_buf_len-1)
 #define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
@@ -212,7 +212,7 @@ void __init setup_log_buf(int early)
 		return;
 	}
 
-	spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
 	log_buf_len = new_log_buf_len;
 	log_buf = new_log_buf;
 	new_log_buf_len = 0;
@@ -230,7 +230,7 @@ void __init setup_log_buf(int early)
 	log_start -= offset;
 	con_start -= offset;
 	log_end -= offset;
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	pr_info("log_buf_len: %d\n", log_buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
@@ -365,18 +365,18 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		if (error)
 			goto out;
 		i = 0;
-		spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&logbuf_lock);
 		while (!error && (log_start != log_end) && i < len) {
 			c = LOG_BUF(log_start);
 			log_start++;
-			spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,buf);
 			buf++;
 			i++;
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&logbuf_lock);
 		if (!error)
 			error = i;
 		break;
@@ -399,7 +399,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		count = len;
 		if (count > log_buf_len)
 			count = log_buf_len;
-		spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&logbuf_lock);
 		if (count > logged_chars)
 			count = logged_chars;
 		if (do_clear)
@@ -416,12 +416,12 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			if (j + log_buf_len < log_end)
 				break;
 			c = LOG_BUF(j);
-			spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&logbuf_lock);
 			error = __put_user(c,&buf[count-1-i]);
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&logbuf_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&logbuf_lock);
 		if (error)
 			break;
 		error = i;
@@ -689,7 +689,7 @@ static void zap_locks(void)
 	oops_timestamp = jiffies;
 
 	/* If a crash is occurring, make sure we can't deadlock */
-	spin_lock_init(&logbuf_lock);
+	raw_spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
 	sema_init(&console_sem, 1);
 }
@@ -802,9 +802,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
+	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 static const char recursion_bug_msg [] =
@@ -864,7 +864,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 
 	lockdep_off();
-	spin_lock(&logbuf_lock);
+	raw_spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
 	if (recursion_bug) {
@@ -1257,14 +1257,14 @@ void console_unlock(void)
 
 again:
 	for ( ; ; ) {
-		spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
 		if (con_start == log_end)
 			break;			/* Nothing to print */
 		_con_start = con_start;
 		_log_end = log_end;
 		con_start = log_end;		/* Flush */
-		spin_unlock(&logbuf_lock);
+		raw_spin_unlock(&logbuf_lock);
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(_con_start, _log_end);
 		start_critical_timings();
@@ -1276,7 +1276,7 @@ again:
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&logbuf_lock);
 
 	up(&console_sem);
 
@@ -1286,13 +1286,13 @@ again:
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	spin_lock(&logbuf_lock);
+	raw_spin_lock(&logbuf_lock);
 	if (con_start != log_end)
 		retry = 1;
-	spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (retry && console_trylock())
 		goto again;
 
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }
@@ -1522,9 +1522,9 @@ void register_console(struct console *newcon)
 		 * console_unlock(); will print out the buffered messages
 		 * for us.
 		 */
-		spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -1731,10 +1731,10 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-	spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
 	end = log_end & LOG_BUF_MASK;
 	chars = logged_chars;
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (chars > end) {
 		s1 = log_buf + log_buf_len - chars + end;
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index 3c7cbc2..a2e7e72 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -29,61 +29,6 @@
 
 #include "rtmutex_common.h"
 
-# define TRACE_WARN_ON(x)			WARN_ON(x)
-# define TRACE_BUG_ON(x)			BUG_ON(x)
-
-# define TRACE_OFF()						\
-do {								\
-	if (rt_trace_on) {					\
-		rt_trace_on = 0;				\
-		console_verbose();				\
-		if (raw_spin_is_locked(&current->pi_lock))	\
-			raw_spin_unlock(&current->pi_lock);	\
-	}							\
-} while (0)
-
-# define TRACE_OFF_NOLOCK()					\
-do {								\
-	if (rt_trace_on) {					\
-		rt_trace_on = 0;				\
-		console_verbose();				\
-	}							\
-} while (0)
-
-# define TRACE_BUG_LOCKED()			\
-do {						\
-	TRACE_OFF();				\
-	BUG();					\
-} while (0)
-
-# define TRACE_WARN_ON_LOCKED(c)		\
-do {						\
-	if (unlikely(c)) {			\
-		TRACE_OFF();			\
-		WARN_ON(1);			\
-	}					\
-} while (0)
-
-# define TRACE_BUG_ON_LOCKED(c)			\
-do {						\
-	if (unlikely(c))			\
-		TRACE_BUG_LOCKED();		\
-} while (0)
-
-#ifdef CONFIG_SMP
-# define SMP_TRACE_BUG_ON_LOCKED(c)	TRACE_BUG_ON_LOCKED(c)
-#else
-# define SMP_TRACE_BUG_ON_LOCKED(c)	do { } while (0)
-#endif
-
-/*
- * deadlock detection flag. We turn it off when we detect
- * the first problem because we dont want to recurse back
- * into the tracing code when doing error printk or
- * executing a BUG():
- */
-static int rt_trace_on = 1;
-
 static void printk_task(struct task_struct *p)
 {
 	if (p)
@@ -111,8 +56,8 @@ static void printk_lock(struct rt_mutex *lock, int print_owner)
 
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	WARN_ON(!plist_head_empty(&task->pi_waiters));
-	WARN_ON(task->pi_blocked_on);
+	DEBUG_LOCKS_WARN_ON(!plist_head_empty(&task->pi_waiters));
+	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
 }
 
 /*
@@ -125,7 +70,7 @@ void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
 {
 	struct task_struct *task;
 
-	if (!rt_trace_on || detect || !act_waiter)
+	if (!debug_locks || detect || !act_waiter)
 		return;
 
 	task = rt_mutex_owner(act_waiter->lock);
@@ -139,7 +84,7 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
 {
 	struct task_struct *task;
 
-	if (!waiter->deadlock_lock || !rt_trace_on)
+	if (!waiter->deadlock_lock || !debug_locks)
 		return;
 
 	rcu_read_lock();
@@ -149,7 +94,10 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
 		return;
 	}
 
-	TRACE_OFF_NOLOCK();
+	if (!debug_locks_off()) {
+		rcu_read_unlock();
+		return;
+	}
 
 	printk("\n============================================\n");
 	printk(  "[ BUG: circular locking deadlock detected! ]\n");
@@ -180,7 +128,6 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
 
 	printk("[ turning off deadlock detection."
 	       "Please report this trace. ]\n\n");
-	local_irq_disable();
 }
 
 void debug_rt_mutex_lock(struct rt_mutex *lock)
@@ -189,7 +136,7 @@ void debug_rt_mutex_lock(struct rt_mutex *lock)
 
 void debug_rt_mutex_unlock(struct rt_mutex *lock)
 {
-	TRACE_WARN_ON_LOCKED(rt_mutex_owner(lock) != current);
+	DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current);
 }
 
 void
@@ -199,7 +146,7 @@ debug_rt_mutex_proxy_lock(struct rt_mutex *lock, struct task_struct *powner)
 
 void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock)
 {
-	TRACE_WARN_ON_LOCKED(!rt_mutex_owner(lock));
+	DEBUG_LOCKS_WARN_ON(!rt_mutex_owner(lock));
 }
 
 void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
@@ -213,8 +160,8 @@ void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
 	put_pid(waiter->deadlock_task_pid);
-	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
+	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
+	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	memset(waiter, 0x22, sizeof(*waiter));
 }
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 331e01b..87f9e36 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -282,10 +282,10 @@ static inline void account_group_user_time(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.utime =
 		cputime_add(cputimer->cputime.utime, cputime);
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -306,10 +306,10 @@ static inline void account_group_system_time(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.stime =
 		cputime_add(cputimer->cputime.stime, cputime);
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -330,7 +330,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.sum_exec_runtime += ns;
-	spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->lock);
 }
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 94a62c0..d831841 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -54,12 +54,12 @@ void down(struct semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
 		__down(sem);
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 }
 EXPORT_SYMBOL(down);
 
@@ -77,12 +77,12 @@ int down_interruptible(struct semaphore *sem)
 	unsigned long flags;
 	int result = 0;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
 		result = __down_interruptible(sem);
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
 }
@@ -103,12 +103,12 @@ int down_killable(struct semaphore *sem)
 	unsigned long flags;
 	int result = 0;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
 		result = __down_killable(sem);
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
 }
@@ -132,11 +132,11 @@ int down_trylock(struct semaphore *sem)
 	unsigned long flags;
 	int count;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	count = sem->count - 1;
 	if (likely(count >= 0))
 		sem->count = count;
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return (count < 0);
 }
@@ -157,12 +157,12 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	unsigned long flags;
 	int result = 0;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
 		result = __down_timeout(sem, jiffies);
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
 }
@@ -179,12 +179,12 @@ void up(struct semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->lock, flags);
+	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(list_empty(&sem->wait_list)))
 		sem->count++;
 	else
 		__up(sem);
-	spin_unlock_irqrestore(&sem->lock, flags);
+	raw_spin_unlock_irqrestore(&sem->lock, flags);
 }
 EXPORT_SYMBOL(up);
 
@@ -217,9 +217,9 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 		if (timeout <= 0)
 			goto timed_out;
 		__set_task_state(task, state);
-		spin_unlock_irq(&sem->lock);
+		raw_spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
-		spin_lock_irq(&sem->lock);
+		raw_spin_lock_irq(&sem->lock);
 		if (waiter.up)
 			return 0;
 	}
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index a5d0a3a..0b537f2 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -81,7 +81,7 @@ struct entry {
 /*
  * Spinlock protecting the tables - not taken during lookup:
  */
-static DEFINE_SPINLOCK(table_lock);
+static DEFINE_RAW_SPINLOCK(table_lock);
 
 /*
  * Per-CPU lookup locks for fast hash lookup:
@@ -188,7 +188,7 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 	prev = NULL;
 	curr = *head;
 
-	spin_lock(&table_lock);
+	raw_spin_lock(&table_lock);
 	/*
 	 * Make sure we have not raced with another CPU:
 	 */
@@ -215,7 +215,7 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 			*head = curr;
 	}
  out_unlock:
-	spin_unlock(&table_lock);
+	raw_spin_unlock(&table_lock);
 
 	return curr;
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 731201b..f2f821a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -478,7 +478,7 @@ struct ring_buffer_per_cpu {
 	int				cpu;
 	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
-	spinlock_t			reader_lock;	/* serialize readers */
+	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -1062,7 +1062,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	spin_lock_init(&cpu_buffer->reader_lock);
+	raw_spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
@@ -1259,7 +1259,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1277,7 +1277,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	rb_check_pages(cpu_buffer);
 
 out:
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 static void
@@ -1288,7 +1288,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1303,7 +1303,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_check_pages(cpu_buffer);
 
 out:
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 /**
@@ -2804,9 +2804,9 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 
 	cpu_buffer = iter->cpu_buffer;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_iter_reset(iter);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
@@ -3265,12 +3265,12 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
  again:
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
@@ -3295,9 +3295,9 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	unsigned long flags;
 
  again:
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3337,7 +3337,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
 	cpu_buffer = buffer->buffers[cpu];
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event) {
@@ -3346,7 +3346,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
 	}
 
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
  out:
@@ -3438,11 +3438,11 @@ ring_buffer_read_start(struct ring_buffer_iter *iter)
 
 	cpu_buffer = iter->cpu_buffer;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
@@ -3477,7 +3477,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
  again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -3488,7 +3488,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
 	rb_advance_iter(iter);
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
 }
@@ -3557,7 +3557,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	atomic_inc(&cpu_buffer->record_disabled);
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
@@ -3569,7 +3569,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 }
@@ -3607,10 +3607,10 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 		cpu_buffer = buffer->buffers[cpu];
 		local_irq_save(flags);
 		if (dolock)
-			spin_lock(&cpu_buffer->reader_lock);
+			raw_spin_lock(&cpu_buffer->reader_lock);
 		ret = rb_per_cpu_empty(cpu_buffer);
 		if (dolock)
-			spin_unlock(&cpu_buffer->reader_lock);
+			raw_spin_unlock(&cpu_buffer->reader_lock);
 		local_irq_restore(flags);
 
 		if (!ret)
@@ -3641,10 +3641,10 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 	ret = rb_per_cpu_empty(cpu_buffer);
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
 	return ret;
@@ -3841,7 +3841,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	if (!bpage)
 		goto out;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -3964,7 +3964,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
  out:
 	return ret;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..0c8bdee 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -341,7 +341,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
 
 static int trace_stop_count;
-static DEFINE_SPINLOCK(tracing_start_lock);
+static DEFINE_RAW_SPINLOCK(tracing_start_lock);
 
 static void wakeup_work_handler(struct work_struct *work)
 {
@@ -960,7 +960,7 @@ void tracing_start(void)
 	if (tracing_disabled)
 		return;
 
-	spin_lock_irqsave(&tracing_start_lock, flags);
+	raw_spin_lock_irqsave(&tracing_start_lock, flags);
 	if (--trace_stop_count) {
 		if (trace_stop_count < 0) {
 			/* Someone screwed up their debugging */
@@ -985,7 +985,7 @@ void tracing_start(void)
 
 	ftrace_start();
  out:
-	spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
 
 /**
@@ -1000,7 +1000,7 @@ void tracing_stop(void)
 	unsigned long flags;
 
 	ftrace_stop();
-	spin_lock_irqsave(&tracing_start_lock, flags);
+	raw_spin_lock_irqsave(&tracing_start_lock, flags);
 	if (trace_stop_count++)
 		goto out;
 
@@ -1018,7 +1018,7 @@ void tracing_stop(void)
 	arch_spin_unlock(&ftrace_max_lock);
 
  out:
-	spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
 
 void trace_stop_cmdline_recording(void);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..1118621 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -23,7 +23,7 @@ static int				tracer_enabled __read_mostly;
 
 static DEFINE_PER_CPU(int, tracing_cpu);
 
-static DEFINE_SPINLOCK(max_trace_lock);
+static DEFINE_RAW_SPINLOCK(max_trace_lock);
 
 enum {
 	TRACER_IRQS_OFF		= (1 << 1),
@@ -321,7 +321,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out;
 
-	spin_lock_irqsave(&max_trace_lock, flags);
+	raw_spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
 	if (!report_latency(delta))
@@ -344,7 +344,7 @@ check_critical_timing(struct trace_array *tr,
 	max_sequence++;
 
 out_unlock:
-	spin_unlock_irqrestore(&max_trace_lock, flags);
+	raw_spin_unlock_irqrestore(&max_trace_lock, flags);
 
 out:
 	data->critical_sequence = max_sequence;
diff --git a/lib/atomic64.c b/lib/atomic64.c
index e12ae0d..3975470 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -29,11 +29,11 @@
  * Ensure each lock is in a separate cacheline.
  */
 static union {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	char pad[L1_CACHE_BYTES];
 } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
 
-static inline spinlock_t *lock_addr(const atomic64_t *v)
+static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 {
 	unsigned long addr = (unsigned long) v;
 
@@ -45,12 +45,12 @@ static inline spinlock_t *lock_addr(const atomic64_t *v)
 long long atomic64_read(const atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_read);
@@ -58,34 +58,34 @@ EXPORT_SYMBOL(atomic64_read);
 void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter = i;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_set);
 
 void atomic64_add(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_add);
 
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_add_return);
@@ -93,23 +93,23 @@ EXPORT_SYMBOL(atomic64_add_return);
 void atomic64_sub(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(atomic64_sub);
 
 long long atomic64_sub_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_sub_return);
@@ -117,14 +117,14 @@ EXPORT_SYMBOL(atomic64_sub_return);
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter - 1;
 	if (val >= 0)
 		v->counter = val;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_dec_if_positive);
@@ -132,14 +132,14 @@ EXPORT_SYMBOL(atomic64_dec_if_positive);
 long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
 	if (val == o)
 		v->counter = n;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_cmpxchg);
@@ -147,13 +147,13 @@ EXPORT_SYMBOL(atomic64_cmpxchg);
 long long atomic64_xchg(atomic64_t *v, long long new)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
 	v->counter = new;
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return val;
 }
 EXPORT_SYMBOL(atomic64_xchg);
@@ -161,15 +161,15 @@ EXPORT_SYMBOL(atomic64_xchg);
 int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	int ret = 0;
 
-	spin_lock_irqsave(lock, flags);
+	raw_spin_lock_irqsave(lock, flags);
 	if (v->counter != u) {
 		v->counter += a;
 		ret = 1;
 	}
-	spin_unlock_irqrestore(lock, flags);
+	raw_spin_unlock_irqrestore(lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(atomic64_add_unless);
@@ -179,7 +179,7 @@ static int init_atomic64_lock(void)
 	int i;
 
 	for (i = 0; i < NR_LOCKS; ++i)
-		spin_lock_init(&atomic64_lock[i].lock);
+		raw_spin_lock_init(&atomic64_lock[i].lock);
 	return 0;
 }
 
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..f087105 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -59,13 +59,13 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	raw_spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	raw_spin_unlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -76,10 +76,10 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
+		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
+		raw_spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -96,13 +96,13 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	raw_spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	spin_unlock(&fbc->lock);
+	raw_spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -110,7 +110,7 @@ EXPORT_SYMBOL(__percpu_counter_sum);
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 			  struct lock_class_key *key)
 {
-	spin_lock_init(&fbc->lock);
+	raw_spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
@@ -173,11 +173,11 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 		s32 *pcount;
 		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
+		raw_spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
+		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif
diff --git a/lib/proportions.c b/lib/proportions.c
index d50746a..05df848 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -190,7 +190,7 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
 
 int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
-	spin_lock_init(&pl->lock);
+	raw_spin_lock_init(&pl->lock);
 	pl->shift = 0;
 	pl->period = 0;
 	return percpu_counter_init(&pl->events, 0);
@@ -226,7 +226,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 	if (pl->period == global_period)
 		return;
 
-	spin_lock_irqsave(&pl->lock, flags);
+	raw_spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
 
 	/*
@@ -247,7 +247,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 		percpu_counter_set(&pl->events, 0);
 
 	pl->period = global_period;
-	spin_unlock_irqrestore(&pl->lock, flags);
+	raw_spin_unlock_irqrestore(&pl->lock, flags);
 }
 
 /*
@@ -324,7 +324,7 @@ void prop_fraction_percpu(struct prop_descriptor *pd,
 
 int prop_local_init_single(struct prop_local_single *pl)
 {
-	spin_lock_init(&pl->lock);
+	raw_spin_lock_init(&pl->lock);
 	pl->shift = 0;
 	pl->period = 0;
 	pl->events = 0;
@@ -356,7 +356,7 @@ void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl)
 	if (pl->period == global_period)
 		return;
 
-	spin_lock_irqsave(&pl->lock, flags);
+	raw_spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
 	/*
 	 * For each missed period, we half the local counter.
@@ -367,7 +367,7 @@ void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl)
 	else
 		pl->events = 0;
 	pl->period = global_period;
-	spin_unlock_irqrestore(&pl->lock, flags);
+	raw_spin_unlock_irqrestore(&pl->lock, flags);
 }
 
 /*
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 027a03f..c96d500 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -39,7 +39,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	 * in addition to the one that will be printed by
 	 * the entity that is holding the lock already:
 	 */
-	if (!spin_trylock_irqsave(&rs->lock, flags))
+	if (!raw_spin_trylock_irqsave(&rs->lock, flags))
 		return 0;
 
 	if (!rs->begin)
@@ -60,7 +60,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->missed++;
 		ret = 0;
 	}
-	spin_unlock_irqrestore(&rs->lock, flags);
+	raw_spin_unlock_irqrestore(&rs->lock, flags);
 
 	return ret;
 }
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ffc9fc7..f2393c2 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -22,9 +22,9 @@ int rwsem_is_locked(struct rw_semaphore *sem)
 	int ret = 1;
 	unsigned long flags;
 
-	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
+	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
 		ret = (sem->activity != 0);
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 	}
 	return ret;
 }
@@ -44,7 +44,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	lockdep_init_map(&sem->dep_map, name, key, 0);
 #endif
 	sem->activity = 0;
-	spin_lock_init(&sem->wait_lock);
+	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
 EXPORT_SYMBOL(__init_rwsem);
@@ -145,12 +145,12 @@ void __sched __down_read(struct rw_semaphore *sem)
 	struct task_struct *tsk;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity++;
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -165,7 +165,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -189,7 +189,7 @@ int __down_read_trylock(struct rw_semaphore *sem)
 	int ret = 0;
 
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
@@ -197,7 +197,7 @@ int __down_read_trylock(struct rw_semaphore *sem)
 		ret = 1;
 	}
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	return ret;
 }
@@ -212,12 +212,12 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	struct task_struct *tsk;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity = -1;
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -232,7 +232,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -260,7 +260,7 @@ int __down_write_trylock(struct rw_semaphore *sem)
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
 		/* granted */
@@ -268,7 +268,7 @@ int __down_write_trylock(struct rw_semaphore *sem)
 		ret = 1;
 	}
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	return ret;
 }
@@ -280,12 +280,12 @@ void __up_read(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (--sem->activity == 0 && !list_empty(&sem->wait_list))
 		sem = __rwsem_wake_one_writer(sem);
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
 /*
@@ -295,13 +295,13 @@ void __up_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	sem->activity = 0;
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, 1);
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
 /*
@@ -312,12 +312,12 @@ void __downgrade_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	sem->activity = 1;
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, 0);
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
diff --git a/lib/rwsem.c b/lib/rwsem.c
index aa7c305..410aa11 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -22,7 +22,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	lockdep_init_map(&sem->dep_map, name, key, 0);
 #endif
 	sem->count = RWSEM_UNLOCKED_VALUE;
-	spin_lock_init(&sem->wait_lock);
+	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
 
@@ -180,7 +180,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
 	/* set up my own style of waitqueue */
-	spin_lock_irq(&sem->wait_lock);
+	raw_spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
 	waiter.flags = flags;
 	get_task_struct(tsk);
@@ -204,7 +204,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
-	spin_unlock_irq(&sem->wait_lock);
+	raw_spin_unlock_irq(&sem->wait_lock);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -245,13 +245,13 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	return sem;
 }
@@ -265,13 +265,13 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sem->wait_lock, flags);
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	return sem;
 }
