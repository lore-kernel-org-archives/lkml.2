Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1FYWK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:10:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65268 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1FYWKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Yhm/bKCJS7J4zgiiqkmC0MS2wBS+EZvndTaMmBzTgV2Mm/y+6m6QjE+aTZWqgoqQVy
         GVNx3XmDjLa5e331l5h4/J3AYlZOCnC9E4v1Hbn6mkPBNxQlMy24Z3goGHBZ07WJ78Yp
         6NXMur9kqk4671YCaLIKvmo3j0c8YQT79uQuk=
From: Bryan Wu <bryan.wu@canonical.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] leds: create a trigger for CPU activity
Date: Sun, 26 Jun 2011 06:10:01 +0800
Message-Id: <1309039804-659-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
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
---
 drivers/leds/Kconfig       |   10 +++
 drivers/leds/Makefile      |    1 +
 drivers/leds/ledtrig-cpu.c |  145 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds.h       |   15 +++++
 4 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-cpu.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 713d43b..186000a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -446,6 +446,16 @@ config LEDS_TRIGGER_BACKLIGHT
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_CPU
+	bool "LED CPU Trigger"
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
index 0000000..b0a89fd
--- /dev/null
+++ b/drivers/leds/ledtrig-cpu.c
@@ -0,0 +1,145 @@
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
+struct cpu_trig_data {
+	struct led_classdev *led;
+};
+
+static DEFINE_PER_CPU(struct cpu_trig_data *, cpu_triggers);
+
+void ledtrig_cpu(enum cpu_led_event ledevt)
+{
+	struct cpu_trig_data *trigdata = __get_cpu_var(cpu_triggers);
+
+	if (!trigdata)
+		return;
+
+	/* Locate the correct CPU LED */
+
+	switch (ledevt) {
+	case CPU_LED_START:
+	case CPU_LED_IDLE_START:
+		/* Will turn the LED on, max brightness */
+		if (trigdata->led)
+			led_set_brightness(trigdata->led,
+					   trigdata->led->max_brightness);
+		break;
+
+	case CPU_LED_STOP:
+	case CPU_LED_IDLE_END:
+	case CPU_LED_HALTED:
+		/* Will turn the LED off */
+		if (trigdata->led)
+			led_set_brightness(trigdata->led, LED_OFF);
+		break;
+
+	default:
+		/* Will leave the LED as it is */
+		break;
+	}
+}
+EXPORT_SYMBOL(ledtrig_cpu);
+
+static void cpu_trig_activate_cpu(void *data)
+{
+	struct cpu_trig_data *cpu_data;
+	struct led_classdev *led = data;
+	int my_cpu = smp_processor_id();
+	unsigned long target_cpu = (unsigned long) led->trigger_data;
+
+	if (target_cpu != my_cpu)
+		return;
+
+	cpu_data = kzalloc(sizeof(*cpu_data), GFP_KERNEL);
+	if (!cpu_data)
+		return;
+
+	dev_info(led->dev, "led %s indicate activity on CPU %d\n",
+		 led->name, my_cpu);
+
+	cpu_data->led = led;
+	__get_cpu_var(cpu_triggers) = cpu_data;
+}
+
+static void cpu_trig_activate(struct led_classdev *led)
+{
+	on_each_cpu(cpu_trig_activate_cpu, led, 1);
+}
+
+static void cpu_trig_deactivate(struct led_classdev *led)
+{
+	struct cpu_trig_data *cpu_data = led->trigger_data;
+
+	if (cpu_data)
+		kfree(cpu_data);
+}
+
+static struct led_trigger cpu_led_trigger = {
+	.name		= "cpu",
+	.activate	= cpu_trig_activate,
+	.deactivate	= cpu_trig_deactivate,
+};
+
+
+static int cpu_syscore_suspend(void)
+{
+	ledtrig_cpu(CPU_LED_STOP);
+	return 0;
+}
+
+static void cpu_syscore_resume(void)
+{
+	ledtrig_cpu(CPU_LED_START);
+}
+
+static void cpu_syscore_shutdown(void)
+{
+	ledtrig_cpu(CPU_LED_HALTED);
+}
+
+static struct syscore_ops cpu_syscore_ops = {
+	.shutdown	= cpu_syscore_shutdown,
+	.suspend	= cpu_syscore_suspend,
+	.resume		= cpu_syscore_resume,
+};
+
+static int __init cpu_trig_init(void)
+{
+	int ret;
+
+	ret = led_trigger_register(&cpu_led_trigger);
+	if (!ret)
+		register_syscore_ops(&cpu_syscore_ops);
+
+	return ret;
+}
+module_init(cpu_trig_init);
+
+static void __exit cpu_trig_exit(void)
+{
+	unregister_syscore_ops(&cpu_syscore_ops);
+	led_trigger_unregister(&cpu_led_trigger);
+}
+module_exit(cpu_trig_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
+MODULE_DESCRIPTION("CPU LED trigger");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..d9e0ebc 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -210,4 +210,19 @@ struct gpio_led_platform_data {
 struct platform_device *gpio_led_register_device(
 		int id, const struct gpio_led_platform_data *pdata);
 
+#ifdef CONFIG_LEDS_TRIGGER_CPU
+enum cpu_led_event {
+	CPU_LED_IDLE_START,
+	CPU_LED_IDLE_END,
+	CPU_LED_START,
+	CPU_LED_STOP,
+	CPU_LED_HALTED
+};
+
+/* Use this routine to handle LEDs */
+extern void ledtrig_cpu(enum cpu_led_event evt);
+#else
+#define ledtrig_cpu() do {} while(0)
+#endif
+
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.4.1

