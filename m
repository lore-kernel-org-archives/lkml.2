Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0EPCe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:34:27 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41529 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0EPCeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=i56s1k9EcfenrHc8ETCk3DvF3oN9F0Mpb50/DEpkRIhL1s9vPKUPu7a3Su9zv5OWNJ
         CUnme/kYPzaWaPtBwJvyZI+49khM0ERakdgPXOsezdjv8+JDqYk5JwF+9b/ZNrFNC6Ro
         +LTDw8Hd2Oz7VV6xQfi27QvS0XvIXV6zOVvKw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] lockup_detector: Cross arch compile fixes
Date: Sun, 16 May 2010 04:34:00 +0200
Message-Id: <1273977240-30800-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <20100515073732.GA17120@elte.hu>
References: <20100515073732.GA17120@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

Combining the softlockup and hardlockup code causes watchdog.c
to build even without the hardlockup detection support.

So if an arch, that has the previous and the new nmi watchdog
implementations cohabiting, wants to know if the generic one
is in use, CONFIG_LOCKUP_DETECTOR is not a reliable check.
We need to use CONFIG_HARDLOCKUP_DETECTOR instead.

Fixes:
	kernel/built-in.o: In function `touch_nmi_watchdog':
	(.text+0x449bc): multiple definition of `touch_nmi_watchdog'
	arch/sparc/kernel/built-in.o:(.text+0x11b28): first defined here

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <20100514151121.GR15159@redhat.com>
[ use CONFIG_HARDLOCKUP_DETECTOR instead of CONFIG_PERF_EVENTS_NMI]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/apic/Makefile |    4 ++--
 include/linux/nmi.h           |    2 +-
 kernel/watchdog.c             |    7 +++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 52f32e0..910f20b 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -3,10 +3,10 @@
 #
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
-ifneq ($(CONFIG_LOCKUP_DETECTOR),y)
+ifneq ($(CONFIG_HARDLOCKUP_DETECTOR),y)
 obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
 endif
-obj-$(CONFIG_LOCKUP_DETECTOR)	+= hw_nmi.o
+obj-$(CONFIG_HARDLOCKUP_DETECTOR)	+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index abd48aa..06aab5e 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,7 +20,7 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
-#ifndef CONFIG_LOCKUP_DETECTOR
+#ifndef CONFIG_HARDLOCKUP_DETECTOR
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 83fb631..e53622c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,13 +31,13 @@ int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
-static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+static DEFINE_PER_CPU(bool, hard_watchdog_warn);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
@@ -139,6 +139,7 @@ void touch_all_softlockup_watchdogs(void)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
 
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
 	__get_cpu_var(watchdog_nmi_touch) = true;
@@ -146,6 +147,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
+#endif
+
 void touch_softlockup_watchdog_sync(void)
 {
 	__raw_get_cpu_var(softlockup_touch_sync) = true;
-- 
1.6.2.3

