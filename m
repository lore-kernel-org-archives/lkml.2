Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2HMFwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:52:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2HMFv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:51:58 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, olof@lixom.net
Subject: [PATCH 01/18] led-triggers: create a trigger for CPU activity
Date: Mon, 13 Aug 2012 13:51:25 +0800
Message-Id: <1344837102-11850-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to consolidate the ARM LED code, this removes the
custom RealView LED trigger code to turn LEDs on and off in
response to CPU activity and replace it with a standard trigger.

(bryan.wu@canonical.com:
It introduces several syscore stubs into this trigger.
It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
Although it was inspired by ARM work, it can be used in other arch.)

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Reviewed-by: Jamie Iles <jamie@jamieiles.com>
Tested-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/leds/Kconfig       |  10 +++
 drivers/leds/Makefile      |   1 +
 drivers/leds/ledtrig-cpu.c | 163 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds.h       |  16 +++++
 4 files changed, 190 insertions(+)
 create mode 100644 drivers/leds/ledtrig-cpu.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 12b2b55..c96fd29 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -469,6 +469,16 @@ config LEDS_TRIGGER_BACKLIGHT
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_CPU
+	bool "LED CPU Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by active CPUs. This shows
+	  the active CPUs across an array of LEDs so you can see which
+	  CPUs are active on the system at any given moment.
+
+	  If unsure, say N.
+
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index f8958cd..fa0f536 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -57,5 +57,6 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
+obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
 obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
new file mode 100644
index 0000000..b312056
--- /dev/null
+++ b/drivers/leds/ledtrig-cpu.c
@@ -0,0 +1,163 @@
+/*
+ * ledtrig-cpu.c - LED trigger based on CPU activity
+ *
+ * This LED trigger will be registered for each possible CPU and named as
+ * cpu0, cpu1, cpu2, cpu3, etc.
+ *
+ * It can be bound to any LED just like other triggers using either a
+ * board file or via sysfs interface.
+ *
+ * An API named ledtrig_cpu is exported for any user, who want to add CPU
+ * activity indication in their code
+ *
+ * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
+ * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/syscore_ops.h>
+#include <linux/rwsem.h>
+#include "leds.h"
+
+#define MAX_NAME_LEN	8
+
+struct led_trigger_cpu {
+	char name[MAX_NAME_LEN];
+	struct led_trigger *_trig;
+	struct mutex lock;
+	int lock_is_inited;
+};
+
+static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
+
+/**
+ * ledtrig_cpu - emit a CPU event as a trigger
+ * @evt: CPU event to be emitted
+ *
+ * Emit a CPU event on a CPU core, which will trigger a
+ * binded LED to turn on or turn off.
+ */
+void ledtrig_cpu(enum cpu_led_event ledevt)
+{
+	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
+
+	/* mutex lock should be initialized before calling mutex_call() */
+	if (!trig->lock_is_inited)
+		return;
+
+	mutex_lock(&trig->lock);
+
+	/* Locate the correct CPU LED */
+	switch (ledevt) {
+	case CPU_LED_IDLE_END:
+	case CPU_LED_START:
+		/* Will turn the LED on, max brightness */
+		led_trigger_event(trig->_trig, LED_FULL);
+		break;
+
+	case CPU_LED_IDLE_START:
+	case CPU_LED_STOP:
+	case CPU_LED_HALTED:
+		/* Will turn the LED off */
+		led_trigger_event(trig->_trig, LED_OFF);
+		break;
+
+	default:
+		/* Will leave the LED as it is */
+		break;
+	}
+
+	mutex_unlock(&trig->lock);
+}
+EXPORT_SYMBOL(ledtrig_cpu);
+
+static int ledtrig_cpu_syscore_suspend(void)
+{
+	ledtrig_cpu(CPU_LED_STOP);
+	return 0;
+}
+
+static void ledtrig_cpu_syscore_resume(void)
+{
+	ledtrig_cpu(CPU_LED_START);
+}
+
+static void ledtrig_cpu_syscore_shutdown(void)
+{
+	ledtrig_cpu(CPU_LED_HALTED);
+}
+
+static struct syscore_ops ledtrig_cpu_syscore_ops = {
+	.shutdown	= ledtrig_cpu_syscore_shutdown,
+	.suspend	= ledtrig_cpu_syscore_suspend,
+	.resume		= ledtrig_cpu_syscore_resume,
+};
+
+static int __init ledtrig_cpu_init(void)
+{
+	int cpu;
+
+	/* Supports up to 9999 cpu cores */
+	BUILD_BUG_ON(CONFIG_NR_CPUS > 9999);
+
+	/*
+	 * Registering CPU led trigger for each CPU core here
+	 * ignores CPU hotplug, but after this CPU hotplug works
+	 * fine with this trigger.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
+
+		mutex_init(&trig->lock);
+
+		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
+
+		mutex_lock(&trig->lock);
+		led_trigger_register_simple(trig->name, &trig->_trig);
+		trig->lock_is_inited = 1;
+		mutex_unlock(&trig->lock);
+	}
+
+	register_syscore_ops(&ledtrig_cpu_syscore_ops);
+
+	pr_info("ledtrig-cpu: registered to indicate activity on CPUs\n");
+
+	return 0;
+}
+module_init(ledtrig_cpu_init);
+
+static void __exit ledtrig_cpu_exit(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
+
+		mutex_lock(&trig->lock);
+
+		led_trigger_unregister_simple(trig->_trig);
+		trig->_trig = NULL;
+		memset(trig->name, 0, MAX_NAME_LEN);
+		trig->lock_is_inited = 0;
+
+		mutex_unlock(&trig->lock);
+		mutex_destroy(&trig->lock);
+	}
+
+	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
+}
+module_exit(ledtrig_cpu_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
+MODULE_DESCRIPTION("CPU LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 39eee41..cd54558 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -212,4 +212,20 @@ struct gpio_led_platform_data {
 struct platform_device *gpio_led_register_device(
 		int id, const struct gpio_led_platform_data *pdata);
 
+enum cpu_led_event {
+	CPU_LED_IDLE_START,	/* CPU enters idle */
+	CPU_LED_IDLE_END,	/* CPU idle ends */
+	CPU_LED_START,		/* Machine starts, especially resume */
+	CPU_LED_STOP,		/* Machine stops, especially suspend */
+	CPU_LED_HALTED,		/* Machine shutdown */
+};
+#ifdef CONFIG_LEDS_TRIGGER_CPU
+extern void ledtrig_cpu(enum cpu_led_event evt);
+#else
+static inline void ledtrig_cpu(enum cpu_led_event evt)
+{
+	return;
+}
+#endif
+
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.11.4

