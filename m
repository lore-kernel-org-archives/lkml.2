Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2BHBo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:44:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63034 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2BHBoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:44:55 -0500
Date: Wed, 8 Feb 2012 05:44:52 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Jones <davej@redhat.com>, Russell King <linux@arm.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: Move leds idle start/stop calls to sched idle
 notifiers
Message-ID: <20120208014452.GD459@panacea>
References: <20120208013959.GA24535@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208013959.GA24535@panacea>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/leds.c    |   25 ++++++++++++++++++++++++-
 arch/arm/kernel/process.c |    3 ---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/leds.c b/arch/arm/kernel/leds.c
index 1911dae..fbc30d4 100644
--- a/arch/arm/kernel/leds.c
+++ b/arch/arm/kernel/leds.c
@@ -9,6 +9,8 @@
  */
 #include <linux/export.h>
 #include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/syscore_ops.h>
 #include <linux/string.h>
@@ -103,6 +105,25 @@ static struct syscore_ops leds_syscore_ops = {
 	.resume		= leds_resume,
 };
 
+static int leds_idle_notifier(struct notifier_block *nb, unsigned long val,
+			      void *data)
+{
+	switch (val) {
+	case SCHED_IDLE_START:
+		leds_event(led_idle_start);
+		break;
+	case SCHED_IDLE_END:
+		leds_event(led_idle_end);
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block leds_idle_nb = {
+	.notifier_call = leds_idle_notifier,
+};
+
 static int __init leds_init(void)
 {
 	int ret;
@@ -111,8 +132,10 @@ static int __init leds_init(void)
 		ret = device_register(&leds_device);
 	if (ret == 0)
 		ret = device_create_file(&leds_device, &dev_attr_event);
-	if (ret == 0)
+	if (ret == 0) {
 		register_syscore_ops(&leds_syscore_ops);
+		sched_idle_notifier_register(&leds_idle_nb);
+	}
 	return ret;
 }
 
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index f2bac2d..f4b53aa 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -33,7 +33,6 @@
 #include <linux/cpuidle.h>
 
 #include <asm/cacheflush.h>
-#include <asm/leds.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/thread_notify.h>
@@ -207,7 +206,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		sched_idle_enter();
-		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
 			if (cpu_is_offline(smp_processor_id()))
@@ -235,7 +233,6 @@ void cpu_idle(void)
 				local_irq_enable();
 			}
 		}
-		leds_event(led_idle_end);
 		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
-- 
1.7.7.6
