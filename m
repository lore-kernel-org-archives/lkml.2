Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2AEQPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:15:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41481 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757613Ab2AEQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:15:42 -0500
Date: Thu, 5 Jan 2012 16:15:18 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "hamo.by@gmail.com" <hamo.by@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] arm: Define cpu_logical_map when CONFIG_SMP is not
 set
Message-ID: <20120105161518.GA29124@mudshark.cambridge.arm.com>
References: <1325767486-6392-1-git-send-email-hamo.by@gmail.com>
 <20120105150140.GX11810@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105150140.GX11810@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:01:40PM +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 05, 2012 at 08:44:46PM +0800, hamo.by@gmail.com wrote:
> > From: Yang Bai <hamo.by@gmail.com>
> > 
> > If CONFIG_SMP is not set, define cpu_logical_map(cpu) as
> > (cpu), this fixes the problem described in this mail:
> > https://lkml.org/lkml/2012/1/2/142
> 
> This doesn't solve the reported problem.  asm/smp.h should not be included
> by any .c file, and won't be included by linux/smp.h if CONFIG_SMP is not
> set.

Exactly, which is why I think the proper solution to this is to move the
mapping stuff out of smp.{ch} altogether. I tried moving the mapping macro
into smp_plat.h and got something like below (compile-tested for vexpress
only).

Note that I didn't bother to return constant 0 when !CONFIG_SMP, since we
may want to do something more advanced with multi-cluster setups and the
kexec stuff mentioned in the previous thread.

What do you reckon? The only remaining bit to fix is patch 7167/1 in the
patch system, but that becomes much simpler with this change.

Will


diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 410a546..145b04a 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 
 #include <asm/irq.h>
+#include <asm/smp_plat.h>
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
 
@@ -271,11 +272,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	unsigned int gic_irqs = gic->gic_irqs;
 	struct irq_domain *domain = &gic->domain;
 	void __iomem *base = gic->dist_base;
-	u32 cpu = 0;
-
-#ifdef CONFIG_SMP
-	cpu = cpu_logical_map(smp_processor_id());
-#endif
+	u32 cpu = cpu_logical_map(smp_processor_id());
 
 	cpumask = 1 << cpu;
 	cpumask |= cpumask << 8;
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 1e5717a..ae29293 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -71,12 +71,6 @@ extern void platform_secondary_init(unsigned int cpu);
 extern void platform_smp_prepare_cpus(unsigned int);
 
 /*
- * Logical CPU mapping.
- */
-extern int __cpu_logical_map[NR_CPUS];
-#define cpu_logical_map(cpu)	__cpu_logical_map[cpu]
-
-/*
  * Initial data for bringing up a secondary CPU.
  */
 struct secondary_data {
diff --git a/arch/arm/include/asm/smp_plat.h b/arch/arm/include/asm/smp_plat.h
index f24c1b9..1aa4a5f 100644
--- a/arch/arm/include/asm/smp_plat.h
+++ b/arch/arm/include/asm/smp_plat.h
@@ -43,4 +43,10 @@ static inline int cache_ops_need_broadcast(void)
 }
 #endif
 
+/*
+ * Logical CPU mapping.
+ */
+extern int __cpu_logical_map[NR_CPUS];
+#define cpu_logical_map(cpu)	__cpu_logical_map[cpu]
+
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8fc2c8f..fc973b1 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -425,6 +425,20 @@ void cpu_init(void)
 	    : "r14");
 }
 
+int __cpu_logical_map[NR_CPUS];
+
+void __init smp_setup_processor_id(void)
+{
+	int i;
+	u32 cpu = is_smp() ? read_cpuid_mpidr() & 0xff : 0;
+
+	cpu_logical_map(0) = cpu;
+	for (i = 1; i < NR_CPUS; ++i)
+		cpu_logical_map(i) = i == cpu ? 0 : i;
+
+	printk(KERN_INFO "Booting Linux on physical CPU %d\n", cpu);
+}
+
 static void __init setup_processor(void)
 {
 	struct proc_info_list *list;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ef5640b..2fc5439 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -261,20 +261,6 @@ void __ref cpu_die(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-int __cpu_logical_map[NR_CPUS];
-
-void __init smp_setup_processor_id(void)
-{
-	int i;
-	u32 cpu = is_smp() ? read_cpuid_mpidr() & 0xff : 0;
-
-	cpu_logical_map(0) = cpu;
-	for (i = 1; i < NR_CPUS; ++i)
-		cpu_logical_map(i) = i == cpu ? 0 : i;
-
-	printk(KERN_INFO "Booting Linux on physical CPU %d\n", cpu);
-}
-
 /*
  * Called by both boot and secondaries to move global data into
  * per-processor storage.
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index da70e7e..dd1ad55 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 
 #include <mach/regs-pmu.h>
 
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 69ffb2f..dbfb0b1 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -23,6 +23,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/gic.h>
+#include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <asm/unified.h>
 
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 88660d5..10244b2 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -26,6 +26,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/unified.h>
+#include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/timer-sp.h>
@@ -73,9 +74,7 @@ static void __init highbank_map_io(void)
 
 void highbank_set_cpu_jump(int cpu, void *jump_addr)
 {
-#ifdef CONFIG_SMP
 	cpu = cpu_logical_map(cpu);
-#endif
 	writel(BSYM(virt_to_phys(jump_addr)), HB_JUMP_TABLE_VIRT(cpu));
 	__cpuc_flush_dcache_area(HB_JUMP_TABLE_VIRT(cpu), 16);
 	outer_clean_range(HB_JUMP_TABLE_PHYS(cpu),
diff --git a/arch/arm/mach-imx/src.c b/arch/arm/mach-imx/src.c
index a8e3368..b73b2fb 100644
--- a/arch/arm/mach-imx/src.c
+++ b/arch/arm/mach-imx/src.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/smp.h>
+#include <asm/smp_plat.h>
 #include <asm/unified.h>
 
 #define SRC_SCR				0x000
@@ -24,10 +25,6 @@
 
 static void __iomem *src_base;
 
-#ifndef CONFIG_SMP
-#define cpu_logical_map(cpu)		0
-#endif
-
 void imx_enable_cpu(int cpu, bool enable)
 {
 	u32 mask, val;
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index 41c252d..a446fc1 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -11,6 +11,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index fdec58a..12807e0 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/mach-types.h>
+#include <asm/smp_plat.h>
 
 #include <mach/msm_iomap.h>
 
diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
index ac1aed2..eb55f05 100644
--- a/arch/arm/mach-realview/hotplug.c
+++ b/arch/arm/mach-realview/hotplug.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mach-shmobile/smp-sh73a0.c b/arch/arm/mach-shmobile/smp-sh73a0.c
index be1ade7..0d159d6 100644
--- a/arch/arm/mach-shmobile/smp-sh73a0.c
+++ b/arch/arm/mach-shmobile/smp-sh73a0.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <mach/common.h>
+#include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <asm/smp_twd.h>
 #include <asm/hardware/gic.h>
diff --git a/arch/arm/mach-ux500/hotplug.c b/arch/arm/mach-ux500/hotplug.c
index 572015e..c76f0f4 100644
--- a/arch/arm/mach-ux500/hotplug.c
+++ b/arch/arm/mach-ux500/hotplug.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index a19e398..d2058ef 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -19,6 +19,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/gic.h>
+#include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <mach/hardware.h>
 #include <mach/setup.h>
diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index 813ee08..3034a4d 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 #include <asm/system.h>
 
 extern volatile int pen_release;
diff --git a/arch/arm/plat-versatile/platsmp.c b/arch/arm/plat-versatile/platsmp.c
index 92f18d3..49c7db4 100644
--- a/arch/arm/plat-versatile/platsmp.c
+++ b/arch/arm/plat-versatile/platsmp.c
@@ -16,6 +16,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
 #include <asm/hardware/gic.h>
 
 /*

