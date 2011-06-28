Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1F1Ctz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:49:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1F1CsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:48:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Lj/JRjyWV1gEh8JKHZEa2Xl8fAHtuBMz5LKwn6wkp7fXqgsybPJWyzYxrVl3j0vzK
	iNPAZ0NRXSDBAZyzWkxAg==
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 3/3] ARM: Move leds idle start/stop calls to idle notifiers
Date: Mon, 27 Jun 2011 19:46:30 -0700
Message-Id: <1309229190-25006-4-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I5d8e4e85b17bbab7992ecb477f0bdb5e4138b166
Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 arch/arm/kernel/leds.c    |   27 ++++++++++++++++++++++++++-
 arch/arm/kernel/process.c |    3 ---
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/leds.c b/arch/arm/kernel/leds.c
index 0f107dc..136e837 100644
--- a/arch/arm/kernel/leds.c
+++ b/arch/arm/kernel/leds.c
@@ -9,6 +9,8 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
 #include <linux/sysdev.h>
 #include <linux/syscore_ops.h>
 
@@ -101,6 +103,25 @@ static struct syscore_ops leds_syscore_ops = {
 	.resume		= leds_resume,
 };
 
+static int leds_idle_notifier(struct notifier_block *nb, unsigned long val,
+                                void *data)
+{
+	switch (val) {
+	case IDLE_START:
+		leds_event(led_idle_start);
+		break;
+	case IDLE_END:
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
@@ -109,8 +130,12 @@ static int __init leds_init(void)
 		ret = sysdev_register(&leds_device);
 	if (ret == 0)
 		ret = sysdev_create_file(&leds_device, &attr_event);
-	if (ret == 0)
+
+	if (ret == 0) {
 		register_syscore_ops(&leds_syscore_ops);
+		idle_notifier_register(&leds_idle_nb);
+	}
+
 	return ret;
 }
 
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 1b9101e..6adf53f 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -32,7 +32,6 @@
 #include <linux/hw_breakpoint.h>
 
 #include <asm/cacheflush.h>
-#include <asm/leds.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/thread_notify.h>
@@ -183,7 +182,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
-		leds_event(led_idle_start);
 		idle_notifier_call_chain(IDLE_START);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -208,7 +206,6 @@ void cpu_idle(void)
 				local_irq_enable();
 			}
 		}
-		leds_event(led_idle_end);
 		idle_notifier_call_chain(IDLE_END);
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
-- 
1.7.3.1

