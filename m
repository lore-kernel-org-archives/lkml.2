Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397Ab1CZCWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:22:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41756 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab1CZCWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:22:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6296"; a="82193235"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
Date: Fri, 25 Mar 2011 19:18:13 -0700
Message-Id: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm watchdog driver is present in kernel only. It does not use the
built-in Linux watchdog api. This is because the primary function of
our watchdog is detecting bus lockups and interrupts being turned off
for long periods of time. We wanted this functionality to be present
regardless of the userspace the kernel is running beneath. Userspace is
free to have its own watchdog implemented in software.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                       |    9 +
 arch/arm/mach-msm/Makefile                      |    1 +
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    3 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    3 +
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    1 +
 arch/arm/mach-msm/io.c                          |    4 +-
 arch/arm/mach-msm/msm_watchdog.c                |  317 +++++++++++++++++++++++
 arch/arm/mach-msm/scm.h                         |    3 +-
 9 files changed, 341 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-msm/msm_watchdog.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1516896..e30bab5 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -164,6 +164,15 @@ config IOMMU_PGTABLES_L2
 	def_bool y
 	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
 
+config MSM_WATCHDOG
+	bool "MSM Watchdog Support"
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	help
+	  This enables the watchdog as is present on 8x60. Currently we use
+	  core 0's watchdog, and reset the entire SoC if it times out. It does
+	  not run during the bootup process, so it will not catch any early
+	  lockups.
+
 config MSM_DEBUG_UART
 	int
 	default 1 if MSM_DEBUG_UART1
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 5ab09a1..8b3b7c2 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
 obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o
+obj-$(CONFIG_MSM_WATCHDOG) += msm_watchdog.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 4d84be1..dfcfc38 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -74,9 +74,8 @@
 #define MSM_GCC_PHYS	      0xC0182000
 #define MSM_GCC_SIZE	      SZ_4K
 
-#define MSM_TCSR_BASE	      IOMEM(0xE000A000)
-#define MSM_TCSR_PHYS	      0xAB600000
-#define MSM_TCSR_SIZE	      SZ_4K
+#define MSM7X30_TCSR_PHYS     0xAB600000
+#define MSM7X30_TCSR_SIZE     SZ_4K
 
 #define MSM_SHARED_RAM_BASE   IOMEM(0xE0100000)
 #define MSM_SHARED_RAM_PHYS   0x00100000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 3c9d960..22ebcb9 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -45,4 +45,7 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
+#define MSM8960_TCSR_PHYS	0x1A400000
+#define MSM8960_TCSR_SIZE	SZ_4K
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 3b19b8f..5a35bfe 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -62,4 +62,7 @@
 #define MSM8X60_TMR0_PHYS	0x02040000
 #define MSM8X60_TMR0_SIZE	SZ_4K
 
+#define MSM8X60_TCSR_PHYS	0x16B00000
+#define MSM8X60_TCSR_SIZE	SZ_4K
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c98c759..cdb9793 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -61,5 +61,6 @@
 #define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
+#define MSM_TCSR_BASE		IOMEM(0xF0202000)
 
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index cec6ed1..ad25d33 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -106,6 +106,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
+	MSM_CHIP_DEVICE(TCSR, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
 };
@@ -122,6 +123,7 @@ static struct map_desc msm8960_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8960),
 	MSM_CHIP_DEVICE(TMR, MSM8960),
 	MSM_CHIP_DEVICE(TMR0, MSM8960),
+	MSM_CHIP_DEVICE(TCSR, MSM8960),
 };
 
 void __init msm_map_msm8960_io(void)
@@ -144,7 +146,7 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(SAW),
 	MSM_DEVICE(GCC),
-	MSM_DEVICE(TCSR),
+	MSM_CHIP_DEVICE(TCSR, MSM7X30),
 #ifdef CONFIG_MSM_DEBUG_UART
 	MSM_DEVICE(DEBUG_UART),
 #endif
diff --git a/arch/arm/mach-msm/msm_watchdog.c b/arch/arm/mach-msm/msm_watchdog.c
new file mode 100644
index 0000000..9a144c9
--- /dev/null
+++ b/arch/arm/mach-msm/msm_watchdog.c
@@ -0,0 +1,317 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/pm.h>
+#include <linux/jiffies.h>
+#include <linux/suspend.h>
+#include <linux/interrupt.h>
+#include <mach/msm_iomap.h>
+#include "scm.h"
+
+#define TCSR_WDT_CFG 0x30
+
+#define WDT0_RST	(MSM_TMR0_BASE + 0x38)
+#define WDT0_EN		(MSM_TMR0_BASE + 0x40)
+#define WDT0_BARK_TIME	(MSM_TMR0_BASE + 0x4C)
+#define WDT0_BITE_TIME	(MSM_TMR0_BASE + 0x5C)
+
+/* Watchdog pet interval in ms */
+#define PET_DELAY 3000
+static unsigned long delay_time;
+static unsigned long long last_pet;
+
+/*
+ * On the kernel command line specify
+ * msm_watchdog.enable=1 to enable the watchdog
+ * By default watchdog is turned on
+ */
+static int enable = 1;
+module_param(enable, int, 0);
+
+/*
+ * If the watchdog is enabled at bootup (enable=1),
+ * the runtime_disable sysfs node at
+ * /sys/module/msm_watchdog/runtime_disable
+ * can be used to deactivate the watchdog.
+ * This is a one-time setting. The watchdog
+ * cannot be re-enabled once it is disabled.
+ */
+static int runtime_disable;
+static DEFINE_MUTEX(disable_lock);
+static int wdog_enable_set(const char *val, struct kernel_param *kp);
+module_param_call(runtime_disable, wdog_enable_set, param_get_int,
+			&runtime_disable, 0644);
+
+/*
+ * On the kernel command line specify msm_watchdog.appsbark=0 to handle
+ * watchdog barks on the secure side. By default barks are processed by Linux.
+ */
+static int appsbark = 1;
+module_param(appsbark, int, 0);
+
+/*
+ * Use /sys/module/msm_watchdog/parameters/print_all_stacks
+ * to control whether stacks of all running
+ * processes are printed when a wdog bark is received.
+ */
+static int print_all_stacks = 1;
+module_param(print_all_stacks, int,  S_IRUGO | S_IWUSR);
+
+static void pet_watchdog(struct work_struct *work);
+static DECLARE_DELAYED_WORK(dogwork_struct, pet_watchdog);
+
+static int msm_watchdog_suspend(void)
+{
+	writel(1, WDT0_RST);
+	writel(0, WDT0_EN);
+	return NOTIFY_DONE;
+}
+static int msm_watchdog_resume(void)
+{
+	writel(1, WDT0_EN);
+	writel(1, WDT0_RST);
+	return NOTIFY_DONE;
+}
+
+static int msm_watchdog_power_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	switch (event) {
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return msm_watchdog_resume();
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return msm_watchdog_suspend();
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static int panic_wdog_handler(struct notifier_block *this,
+			      unsigned long event, void *ptr)
+{
+	if (panic_timeout == 0) {
+		writel(0, WDT0_EN);
+		writel(0, MSM_TCSR_BASE + TCSR_WDT_CFG);
+	} else {
+		writel(32768 * (panic_timeout + 4), WDT0_BARK_TIME);
+		writel(32768 * (panic_timeout + 4), WDT0_BITE_TIME);
+		writel(1, WDT0_RST);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block panic_blk = {
+	.notifier_call	= panic_wdog_handler,
+};
+
+static struct notifier_block msm_watchdog_power_notifier = {
+	.notifier_call = msm_watchdog_power_event,
+};
+
+static int wdog_enable_set(const char *val, struct kernel_param *kp)
+{
+	int ret = 0;
+	int old_val = runtime_disable;
+
+	mutex_lock(&disable_lock);
+
+	if (!enable) {
+		printk(KERN_INFO "MSM Watchdog is not active.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = param_set_int(val, kp);
+
+	if (ret)
+		goto done;
+
+	switch (runtime_disable) {
+
+	case 1:
+		if (!old_val) {
+			writel(0, WDT0_EN);
+			unregister_pm_notifier(&msm_watchdog_power_notifier);
+
+			/* may be suspended after the first write above */
+			writel(0, WDT0_EN);
+			writel(0, MSM_TCSR_BASE + TCSR_WDT_CFG);
+			free_irq(WDT0_ACCSCSSNBARK_INT, 0);
+			enable = 0;
+			atomic_notifier_chain_unregister(&panic_notifier_list,
+			       &panic_blk);
+			cancel_delayed_work(&dogwork_struct);
+			printk(KERN_INFO "MSM Watchdog deactivated.\n");
+		}
+	break;
+
+	default:
+		runtime_disable = old_val;
+		ret = -EINVAL;
+	break;
+
+	}
+
+done:
+	mutex_unlock(&disable_lock);
+	return ret;
+}
+
+static void pet_watchdog(struct work_struct *work)
+{
+	writel(1, WDT0_RST);
+	last_pet = sched_clock();
+
+	if (enable)
+		schedule_delayed_work(&dogwork_struct, delay_time);
+}
+
+static void __exit exit_watchdog(void)
+{
+	if (enable) {
+		writel(0, WDT0_EN);
+		unregister_pm_notifier(&msm_watchdog_power_notifier);
+		writel(0, WDT0_EN); /* In case we got suspended mid-exit */
+		writel(0, MSM_TCSR_BASE + TCSR_WDT_CFG);
+		free_irq(WDT0_ACCSCSSNBARK_INT, 0);
+		enable = 0;
+	}
+	printk(KERN_INFO "MSM Watchdog Exit - Deactivated\n");
+}
+
+static irqreturn_t wdog_bark_handler(int irq, void *dev_id)
+{
+	unsigned long nanosec_rem;
+	unsigned long long t = sched_clock();
+	struct task_struct *tsk;
+
+	nanosec_rem = do_div(t, 1000000000);
+	printk(KERN_INFO "Watchdog bark! Now = %lu.%06lu\n", (unsigned long) t,
+		nanosec_rem / 1000);
+
+	nanosec_rem = do_div(last_pet, 1000000000);
+	printk(KERN_INFO "Watchdog last pet at %lu.%06lu\n", (unsigned long)
+		last_pet, nanosec_rem / 1000);
+
+	if (print_all_stacks) {
+
+		/* Suspend wdog until all stacks are printed */
+		msm_watchdog_suspend();
+
+		printk(KERN_INFO "Stack trace dump:\n");
+
+		for_each_process(tsk) {
+			printk(KERN_INFO "\nPID: %d, Name: %s\n",
+				tsk->pid, tsk->comm);
+			show_stack(tsk, NULL);
+		}
+
+		msm_watchdog_resume();
+	}
+
+	panic("Apps watchdog bark received!");
+	return IRQ_HANDLED;
+}
+
+#define SCM_SET_REGSAVE_CMD 0x2
+
+static int __init init_watchdog(void)
+{
+	int ret;
+	void *regsave;
+	struct {
+		unsigned addr;
+		int len;
+	} cmd_buf;
+
+	if (!enable) {
+		printk(KERN_INFO "MSM Watchdog Not Initialized\n");
+		return 0;
+	}
+
+	/* Must request irq before sending scm command */
+	ret = request_irq(WDT0_ACCSCSSNBARK_INT, wdog_bark_handler, 0,
+			  "apps_wdog_bark", NULL);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_MSM_SCM
+	if (!appsbark) {
+		regsave = (void *)__get_free_page(GFP_KERNEL);
+
+		if (regsave) {
+			cmd_buf.addr = __pa(regsave);
+			cmd_buf.len  = PAGE_SIZE;
+
+			ret = scm_call(SCM_SVC_UTIL, SCM_SET_REGSAVE_CMD,
+				       &cmd_buf, sizeof(cmd_buf), NULL, 0);
+			if (ret)
+				pr_err("Setting register save address failed.\n"
+				       "Registers won't be dumped on a dog "
+				       "bite\n");
+		} else
+			pr_err("Allocating register save space failed\n"
+			       "Registers won't be dumped on a dog bite\n");
+			/*
+			 * No need to bail if allocation fails. Simply don't
+			 * send the command, and the secure side will reset
+			 * without saving registers.
+			 */
+	}
+#endif
+	writel(1, MSM_TCSR_BASE + TCSR_WDT_CFG);
+	delay_time = msecs_to_jiffies(PET_DELAY);
+
+	/* 32768 ticks = 1 second */
+	writel(32768*8, WDT0_BARK_TIME);
+	writel(32768*10, WDT0_BITE_TIME);
+
+	ret = register_pm_notifier(&msm_watchdog_power_notifier);
+	if (ret) {
+		free_irq(WDT0_ACCSCSSNBARK_INT, NULL);
+		return ret;
+	}
+
+	INIT_DELAYED_WORK(&dogwork_struct, pet_watchdog);
+	schedule_delayed_work(&dogwork_struct, delay_time);
+
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &panic_blk);
+
+	writel(1, WDT0_EN);
+	writel(1, WDT0_RST);
+	last_pet = sched_clock();
+
+	printk(KERN_INFO "MSM Watchdog Initialized\n");
+
+	return 0;
+}
+
+late_initcall(init_watchdog);
+module_exit(exit_watchdog);
+MODULE_DESCRIPTION("MSM Watchdog Driver");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL v2");
diff --git a/arch/arm/mach-msm/scm.h b/arch/arm/mach-msm/scm.h
index 00b31ea..08d393e 100644
--- a/arch/arm/mach-msm/scm.h
+++ b/arch/arm/mach-msm/scm.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -14,6 +14,7 @@
 
 #define SCM_SVC_BOOT			0x1
 #define SCM_SVC_PIL			0x2
+#define SCM_SVC_UTIL			0x3
 
 extern int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		void *resp_buf, size_t resp_len);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

