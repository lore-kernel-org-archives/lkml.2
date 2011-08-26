Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HZJFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:05:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1HZJE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:04:57 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] led-triggers: create a trigger for CPU activity
Date: Fri, 26 Aug 2011 17:03:19 +0800
Message-Id: <1314349415-889-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to consolidate the ARM LED code, this removes the
custom RealView LED trigger code to turn LEDs on and off in
response to CPU activity and replace it with a standard trigger.

(bryan.wu@canonical.com:
It moves arch/arm/kernel/leds.c syscore stubs into this trigger.
It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
Although it was inspired by ARM work, it can be used in other arch.)

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
Tested-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/leds/Kconfig       |   10 ++++
 drivers/leds/Makefile      |    1 +
 drivers/leds/ledtrig-cpu.c |  120 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds.h       |   15 ++++++
 4 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-cpu.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b591e72..b444cc3 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -430,6 +430,16 @@ config LEDS_TRIGGER_BACKLIGHT
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_CPU
+	tristate "LED CPU Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by active CPUs. This shows
+	  the active CPUs across an array of LEDs so you can see what
+	  CPUs are active on the system at any given moment.
+
+	  If unsure, say N.
+
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index bbfd2e3..5e70d2e 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -53,4 +53,5 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
+obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
new file mode 100644
index 0000000..d00ca77
--- /dev/null
+++ b/drivers/leds/ledtrig-cpu.c
@@ -0,0 +1,120 @@
+/*
+ * ledtrig-cpu.c - LED trigger based on CPU activity
+ *
+ * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
+ * Copyright 2011 Bryan Wu <bryan.wu@canonical.com>
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
+#include "leds.h"
+
+static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
+static DEFINE_PER_CPU(char [8], trig_name);
+
+void ledtrig_cpu(enum cpu_led_event ledevt)
+{
+	struct led_trigger *trig = __get_cpu_var(cpu_trig);
+
+	if (!trig)
+		return;
+
+	/* Locate the correct CPU LED */
+
+	switch (ledevt) {
+	case CPU_LED_IDLE_END:
+	case CPU_LED_START:
+		/* Will turn the LED on, max brightness */
+		led_trigger_event(trig, LED_FULL);
+		break;
+
+	case CPU_LED_IDLE_START:
+	case CPU_LED_STOP:
+	case CPU_LED_HALTED:
+		/* Will turn the LED off */
+		led_trigger_event(trig, LED_OFF);
+		break;
+
+	default:
+		/* Will leave the LED as it is */
+		break;
+	}
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
+static void __init ledtrig_cpu_register(void *info)
+{
+	int cpuid = smp_processor_id();
+	struct led_trigger *trig;
+	char *name = __get_cpu_var(trig_name);
+
+	snprintf(name, 8, "cpu%d", cpuid);
+	led_trigger_register_simple(name, &trig);
+
+	pr_info("LED trigger %s indicate activity on CPU %d\n",
+		trig->name, cpuid);
+
+	__get_cpu_var(cpu_trig) = trig;
+}
+
+static void __exit ledtrig_cpu_unregister(void *info)
+{
+	struct led_trigger *trig = __get_cpu_var(cpu_trig);
+	char *name = __get_cpu_var(trig_name);
+
+	led_trigger_unregister_simple(trig);
+	__get_cpu_var(cpu_trig) = NULL;
+	memset(name, 0, 8);
+}
+
+static int __init ledtrig_cpu_init(void)
+{
+	on_each_cpu(ledtrig_cpu_register, NULL, 1);
+	register_syscore_ops(&ledtrig_cpu_syscore_ops);
+
+	return 0;
+}
+module_init(ledtrig_cpu_init);
+
+static void __exit ledtrig_cpu_exit(void)
+{
+	on_each_cpu(ledtrig_cpu_unregister, NULL, 1);
+	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
+}
+module_exit(ledtrig_cpu_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
+MODULE_DESCRIPTION("CPU LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..b782abd 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -210,4 +210,19 @@ struct gpio_led_platform_data {
 struct platform_device *gpio_led_register_device(
 		int id, const struct gpio_led_platform_data *pdata);
 
+#ifdef CONFIG_LEDS_TRIGGER_CPU
+enum cpu_led_event {
+	CPU_LED_IDLE_START,	/* CPU enters idle */
+	CPU_LED_IDLE_END,	/* CPU idle ends */
+	CPU_LED_START,		/* Machine starts, especially resume */
+	CPU_LED_STOP,		/* Machine stops, especially suspend */
+	CPU_LED_HALTED,		/* Machine shutdown */
+};
+
+/* Use this routine to handle LEDs */
+extern void ledtrig_cpu(enum cpu_led_event evt);
+#else
+#define ledtrig_cpu(evt) do {} while (0)
+#endif
+
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.5

