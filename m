Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2IGQbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:31:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34777 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2IGQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:28:00 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 28/31] arm64: Generic timers support
Date: Fri,  7 Sep 2012 17:27:03 +0100
Message-Id: <1347035226-18649-29-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:58.0269 (UTC) FILETIME=[BDDB06D0:01CD8D15]
X-MC-Unique: 112090717275809301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GVFhY008387

From: Marc Zyngier <marc.zyngier@arm.com>

This patch adds support for the ARM generic timers with A64 instructions
for accessing the timer registers. It uses the physical counter as the
clock source and the virtual counter as sched_clock.

The timer frequency can be specified via DT or read from the CNTFRQ_EL0
register. The physical counter is also accessible from user space
allowing fast gettimeofday() implementation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/arm_generic.h |  100 +++++++++++++++
 arch/arm64/include/asm/timex.h       |   29 +++++
 arch/arm64/kernel/time.c             |   65 ++++++++++
 drivers/clocksource/Kconfig          |    5 +
 drivers/clocksource/Makefile         |    1 +
 drivers/clocksource/arm_generic.c    |  232 ++++++++++++++++++++++++++++++++++
 include/clocksource/arm_generic.h    |   21 +++
 7 files changed, 453 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/arm_generic.h
 create mode 100644 arch/arm64/include/asm/timex.h
 create mode 100644 arch/arm64/kernel/time.c
 create mode 100644 drivers/clocksource/arm_generic.c
 create mode 100644 include/clocksource/arm_generic.h

diff --git a/arch/arm64/include/asm/arm_generic.h b/arch/arm64/include/asm/arm_generic.h
new file mode 100644
index 0000000..e4cec9d
--- /dev/null
+++ b/arch/arm64/include/asm/arm_generic.h
@@ -0,0 +1,100 @@
+/*
+ * arch/arm64/include/asm/arm_generic.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_ARM_GENERIC_H
+#define __ASM_ARM_GENERIC_H
+
+#include <linux/clocksource.h>
+
+#define ARCH_TIMER_CTRL_ENABLE		(1 << 0)
+#define ARCH_TIMER_CTRL_IMASK		(1 << 1)
+#define ARCH_TIMER_CTRL_ISTATUS		(1 << 2)
+
+#define ARCH_TIMER_REG_CTRL		0
+#define ARCH_TIMER_REG_FREQ		1
+#define ARCH_TIMER_REG_TVAL		2
+
+static inline void arch_timer_reg_write(int reg, u32 val)
+{
+	switch (reg) {
+	case ARCH_TIMER_REG_CTRL:
+		asm volatile("msr cntp_ctl_el0,  %0" : : "r" (val));
+		break;
+	case ARCH_TIMER_REG_TVAL:
+		asm volatile("msr cntp_tval_el0, %0" : : "r" (val));
+		break;
+	default:
+		BUILD_BUG();
+	}
+
+	isb();
+}
+
+static inline u32 arch_timer_reg_read(int reg)
+{
+	u32 val;
+
+	switch (reg) {
+	case ARCH_TIMER_REG_CTRL:
+		asm volatile("mrs %0,  cntp_ctl_el0" : "=r" (val));
+		break;
+	case ARCH_TIMER_REG_FREQ:
+		asm volatile("mrs %0,   cntfrq_el0" : "=r" (val));
+		break;
+	case ARCH_TIMER_REG_TVAL:
+		asm volatile("mrs %0, cntp_tval_el0" : "=r" (val));
+		break;
+	default:
+		BUILD_BUG();
+	}
+
+	return val;
+}
+
+static inline void __cpuinit arch_counter_enable_user_access(void)
+{
+	u32 cntkctl;
+
+	/* Disable user access to the timers and the virtual counter. */
+	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
+	cntkctl &= ~((3 << 8) | (1 << 1));
+
+	/* Enable user access to the physical counter and frequency. */
+	cntkctl |= 1;
+	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
+}
+
+static inline cycle_t arch_counter_get_cntpct(void)
+{
+	cycle_t cval;
+
+	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
+
+	return cval;
+}
+
+static inline cycle_t arch_counter_get_cntvct(void)
+{
+	cycle_t cval;
+
+	asm volatile("mrs %0, cntvct_el0" : "=r" (cval));
+
+	return cval;
+}
+
+#endif
diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
new file mode 100644
index 0000000..b24a31a
--- /dev/null
+++ b/arch/arm64/include/asm/timex.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_TIMEX_H
+#define __ASM_TIMEX_H
+
+/*
+ * Use the current timer as a cycle counter since this is what we use for
+ * the delay loop.
+ */
+#define get_cycles()	({ cycles_t c; read_current_timer(&c); c; })
+
+#include <asm-generic/timex.h>
+
+#define ARCH_HAS_READ_CURRENT_TIMER
+
+#endif
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
new file mode 100644
index 0000000..3b4b725
--- /dev/null
+++ b/arch/arm64/kernel/time.c
@@ -0,0 +1,65 @@
+/*
+ * Based on arch/arm/kernel/time.c
+ *
+ * Copyright (C) 1991, 1992, 1995  Linus Torvalds
+ * Modifications for ARM (C) 1994-2001 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/timex.h>
+#include <linux/errno.h>
+#include <linux/profile.h>
+#include <linux/syscore_ops.h>
+#include <linux/timer.h>
+#include <linux/irq.h>
+
+#include <clocksource/arm_generic.h>
+
+#include <asm/thread_info.h>
+#include <asm/stacktrace.h>
+
+#ifdef CONFIG_SMP
+unsigned long profile_pc(struct pt_regs *regs)
+{
+	struct stackframe frame;
+
+	if (!in_lock_functions(regs->pc))
+		return regs->pc;
+
+	frame.fp = regs->regs[29];
+	frame.sp = regs->sp;
+	frame.pc = regs->pc;
+	do {
+		int ret = unwind_frame(&frame);
+		if (ret < 0)
+			return 0;
+	} while (in_lock_functions(frame.pc));
+
+	return frame.pc;
+}
+EXPORT_SYMBOL(profile_pc);
+#endif
+
+void __init time_init(void)
+{
+	arm_generic_timer_init();
+}
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index d53cd0a..6a78073 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -35,3 +35,8 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 	default y
 	help
 	  Use the always on PRCMU Timer as sched_clock
+
+config CLKSRC_ARM_GENERIC
+	def_bool y if ARM64
+	help
+	  This option enables support for the ARM generic timer.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index b65d0c5..6591990 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
 obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
+obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/drivers/clocksource/arm_generic.c b/drivers/clocksource/arm_generic.c
new file mode 100644
index 0000000..c4d9f95
--- /dev/null
+++ b/drivers/clocksource/arm_generic.c
@@ -0,0 +1,232 @@
+/*
+ * Generic timers support
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/smp.h>
+#include <linux/cpu.h>
+#include <linux/jiffies.h>
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+
+#include <clocksource/arm_generic.h>
+
+#include <asm/arm_generic.h>
+
+static u32 arch_timer_rate;
+static u64 sched_clock_mult __read_mostly;
+static DEFINE_PER_CPU(struct clock_event_device, arch_timer_evt);
+static int arch_timer_ppi;
+
+static irqreturn_t arch_timer_handle_irq(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	unsigned long ctrl;
+
+	ctrl = arch_timer_reg_read(ARCH_TIMER_REG_CTRL);
+	if (ctrl & ARCH_TIMER_CTRL_ISTATUS) {
+		ctrl |= ARCH_TIMER_CTRL_IMASK;
+		arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);
+		evt->event_handler(evt);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void arch_timer_stop(void)
+{
+	unsigned long ctrl;
+
+	ctrl = arch_timer_reg_read(ARCH_TIMER_REG_CTRL);
+	ctrl &= ~ARCH_TIMER_CTRL_ENABLE;
+	arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);
+}
+
+static void arch_timer_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		arch_timer_stop();
+		break;
+	default:
+		break;
+	}
+}
+
+static int arch_timer_set_next_event(unsigned long evt,
+				     struct clock_event_device *unused)
+{
+	unsigned long ctrl;
+
+	ctrl = arch_timer_reg_read(ARCH_TIMER_REG_CTRL);
+	ctrl |= ARCH_TIMER_CTRL_ENABLE;
+	ctrl &= ~ARCH_TIMER_CTRL_IMASK;
+
+	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);
+	arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);
+
+	return 0;
+}
+
+static void __cpuinit arch_timer_setup(struct clock_event_device *clk)
+{
+	/* Let's make sure the timer is off before doing anything else */
+	arch_timer_stop();
+
+	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
+	clk->name = "arch_sys_timer";
+	clk->rating = 400;
+	clk->set_mode = arch_timer_set_mode;
+	clk->set_next_event = arch_timer_set_next_event;
+	clk->irq = arch_timer_ppi;
+	clk->cpumask = cpumask_of(smp_processor_id());
+
+	clockevents_config_and_register(clk, arch_timer_rate,
+					0xf, 0x7fffffff);
+
+	enable_percpu_irq(clk->irq, 0);
+
+	/* Ensure the physical counter is visible to userspace for the vDSO. */
+	arch_counter_enable_user_access();
+}
+
+static void __init arch_timer_calibrate(void)
+{
+	if (arch_timer_rate == 0) {
+		arch_timer_reg_write(ARCH_TIMER_REG_CTRL, 0);
+		arch_timer_rate = arch_timer_reg_read(ARCH_TIMER_REG_FREQ);
+
+		/* Check the timer frequency. */
+		if (arch_timer_rate == 0)
+			panic("Architected timer frequency is set to zero.\n"
+			      "You must set this in your .dts file\n");
+	}
+
+	/* Cache the sched_clock multiplier to save a divide in the hot path. */
+
+	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
+
+	pr_info("Architected local timer running at %u.%02uMHz.\n",
+		 arch_timer_rate / 1000000, (arch_timer_rate / 10000) % 100);
+}
+
+static cycle_t arch_counter_read(struct clocksource *cs)
+{
+	return arch_counter_get_cntpct();
+}
+
+static struct clocksource clocksource_counter = {
+	.name	= "arch_sys_counter",
+	.rating	= 400,
+	.read	= arch_counter_read,
+	.mask	= CLOCKSOURCE_MASK(56),
+	.flags	= (CLOCK_SOURCE_IS_CONTINUOUS | CLOCK_SOURCE_VALID_FOR_HRES),
+};
+
+int read_current_timer(unsigned long *timer_value)
+{
+	*timer_value = arch_counter_get_cntpct();
+	return 0;
+}
+
+unsigned long long notrace sched_clock(void)
+{
+	return arch_counter_get_cntvct() * sched_clock_mult;
+}
+
+static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	struct clock_event_device *clk = per_cpu_ptr(&arch_timer_evt, cpu);
+
+	switch(action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		arch_timer_setup(clk);
+		break;
+
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
+			 clk->irq, cpu);
+		disable_percpu_irq(clk->irq);
+		arch_timer_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata arch_timer_cpu_nb = {
+	.notifier_call = arch_timer_cpu_notify,
+};
+
+static const struct of_device_id arch_timer_of_match[] __initconst = {
+	{ .compatible = "arm,armv8-timer" },
+	{},
+};
+
+int __init arm_generic_timer_init(void)
+{
+	struct device_node *np;
+	int err;
+	u32 freq;
+
+	np = of_find_matching_node(NULL, arch_timer_of_match);
+	if (!np) {
+		pr_err("arch_timer: can't find DT node\n");
+		return -ENODEV;
+	}
+
+	/* Try to determine the frequency from the device tree or CNTFRQ */
+	if (!of_property_read_u32(np, "clock-frequency", &freq))
+		arch_timer_rate = freq;
+	arch_timer_calibrate();
+
+	arch_timer_ppi = irq_of_parse_and_map(np, 0);
+	pr_info("arch_timer: found %s irq %d\n", np->name, arch_timer_ppi);
+
+	err = request_percpu_irq(arch_timer_ppi, arch_timer_handle_irq,
+				 np->name, &arch_timer_evt);
+	if (err) {
+		pr_err("arch_timer: can't register interrupt %d (%d)\n",
+		       arch_timer_ppi, err);
+		return err;
+	}
+
+	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
+
+	/* Calibrate the delay loop directly */
+	lpj_fine = arch_timer_rate / HZ;
+
+	/* Immediately configure the timer on the boot CPU */
+	arch_timer_setup(per_cpu_ptr(&arch_timer_evt, smp_processor_id()));
+
+	register_cpu_notifier(&arch_timer_cpu_nb);
+
+	return 0;
+}
diff --git a/include/clocksource/arm_generic.h b/include/clocksource/arm_generic.h
new file mode 100644
index 0000000..5b41b0d
--- /dev/null
+++ b/include/clocksource/arm_generic.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __CLKSOURCE_ARM_GENERIC_H
+#define __CLKSOURCE_ARM_GENERIC_H
+
+extern int arm_generic_timer_init(void);
+
+#endif

