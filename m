Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2KGXX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:23:58 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54796 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2KGXX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:23:57 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] cpuidle: add Calxeda SOC idle support
Date: Wed,  7 Nov 2012 17:23:42 -0600
Message-Id: <1352330622-13616-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add support for core powergating on Calxeda platforms. Initially, this
supports ECX-1000 (highbank), but support will be added for ECX-2000
later.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---

It's not really clear where we want ARM cpuidle drivers. We're moving
everything else out of arch/arm, and my understanding is Len doesn't want
them in drivers/idle. It seems kind of silly to me to have the framework
and drivers in 2 places. I've put this in drivers/cpuidle, but it doesn't
make any difference to me.

Rob

 drivers/cpuidle/Kconfig           |   10 +++
 drivers/cpuidle/Makefile          |    2 +
 drivers/cpuidle/cpuidle-calxeda.c |  161 +++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 drivers/cpuidle/cpuidle-calxeda.c

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index a76b689..d2d007b 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -21,3 +21,13 @@ config CPU_IDLE_GOV_MENU
 
 config ARCH_NEEDS_CPU_IDLE_COUPLED
 	def_bool n
+
+if CPU_IDLE
+
+config CPU_IDLE_CALXEDA
+	bool "CPU Idle Driver for Calxeda processors"
+	depends on ARCH_HIGHBANK
+	help
+	  Select this to enable cpuidle on Calxeda processors.
+
+endif
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index 38c8f69..03ee874 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -4,3 +4,5 @@
 
 obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
+
+obj-$(CONFIG_CPU_IDLE_CALXEDA) += cpuidle-calxeda.o
diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
new file mode 100644
index 0000000..e1aab38
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-calxeda.c
@@ -0,0 +1,161 @@
+/*
+ * Copyright 2012 Calxeda, Inc.
+ *
+ * Based on arch/arm/plat-mxc/cpuidle.c:
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/cpuidle.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/suspend.h>
+#include <asm/cpuidle.h>
+#include <asm/proc-fns.h>
+#include <asm/smp_scu.h>
+#include <asm/suspend.h>
+#include <asm/cacheflush.h>
+#include <asm/cp15.h>
+
+extern void highbank_set_cpu_jump(int cpu, void *jump_addr);
+extern void *scu_base_addr;
+
+static struct cpuidle_device __percpu *calxeda_idle_cpuidle_devices;
+
+static inline unsigned int get_auxcr(void)
+{
+	unsigned int val;
+	asm("mrc p15, 0, %0, c1, c0, 1	@ get AUXCR" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_auxcr(unsigned int val)
+{
+	asm volatile("mcr p15, 0, %0, c1, c0, 1	@ set AUXCR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+static noinline void calxeda_idle_restore(void)
+{
+	set_cr(get_cr() | CR_C);
+	set_auxcr(get_auxcr() | 0x40);
+	scu_power_mode(scu_base_addr, SCU_PM_NORMAL);
+}
+
+static int calxeda_idle_finish(unsigned long val)
+{
+	/* Already flushed cache, but do it again as the outer cache functions
+	 * dirty the cache with spinlocks */
+	flush_cache_all();
+
+	set_auxcr(get_auxcr() & ~0x40);
+	set_cr(get_cr() & ~CR_C);
+
+	scu_power_mode(scu_base_addr, SCU_PM_DORMANT);
+
+	cpu_do_idle();
+
+	/* Restore things if we didn't enter power-gating */
+	calxeda_idle_restore();
+	return 1;
+}
+
+static int calxeda_pwrdown_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	highbank_set_cpu_jump(smp_processor_id(), cpu_resume);
+	cpu_suspend(0, calxeda_idle_finish);
+	return index;
+}
+
+static void calxeda_idle_cpuidle_devices_uninit(void)
+{
+	int i;
+	struct cpuidle_device *dev;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(calxeda_idle_cpuidle_devices, i);
+		cpuidle_unregister_device(dev);
+	}
+
+	free_percpu(calxeda_idle_cpuidle_devices);
+}
+
+static struct cpuidle_driver calxeda_idle_driver = {
+	.name = "calxeda_idle",
+	.en_core_tk_irqen = 1,
+	.states = {
+		ARM_CPUIDLE_WFI_STATE,
+		{
+			.name = "PG",
+			.desc = "Power Gate",
+			.flags = CPUIDLE_FLAG_TIME_VALID,
+			.exit_latency = 30,
+			.power_usage = 50,
+			.target_residency = 200,
+			.enter = calxeda_pwrdown_idle,
+		},
+	},
+	.state_count = 2,
+};
+
+static int __init calxeda_cpuidle_init(void)
+{
+	int cpu_id;
+	int ret;
+	struct cpuidle_device *dev;
+	struct cpuidle_driver *drv = &calxeda_idle_driver;
+
+	if (!of_machine_is_compatible("calxeda,highbank"))
+		return -ENODEV;
+
+	ret = cpuidle_register_driver(drv);
+	if (ret)
+		return ret;
+
+	calxeda_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (calxeda_idle_cpuidle_devices == NULL) {
+		ret = -ENOMEM;
+		goto unregister_drv;
+	}
+
+	/* initialize state data for each cpuidle_device */
+	for_each_possible_cpu(cpu_id) {
+		dev = per_cpu_ptr(calxeda_idle_cpuidle_devices, cpu_id);
+		dev->cpu = cpu_id;
+		dev->state_count = drv->state_count;
+
+		ret = cpuidle_register_device(dev);
+		if (ret) {
+			pr_err("Failed to register cpu %u, error: %d\n",
+			       cpu_id, ret);
+			goto uninit;
+		}
+	}
+
+	return 0;
+
+uninit:
+	calxeda_idle_cpuidle_devices_uninit();
+unregister_drv:
+	cpuidle_unregister_driver(drv);
+	return ret;
+}
+module_init(calxeda_cpuidle_init);
-- 
1.7.10.4

