Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0EPJVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 05:21:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:49633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0EPJVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 05:21:50 -0400
Date: Sun, 16 May 2010 09:20:53 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <20100514151121.GR15159@redhat.com>
References: <20100514151121.GR15159@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] lockup_detector: Cross arch compile fixes
Message-ID: <tip-cafcd80d216bc2136b8edbb794327e495792c666@git.kernel.org>
Git-Commit-ID: cafcd80d216bc2136b8edbb794327e495792c666
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 16 May 2010 09:20:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cafcd80d216bc2136b8edbb794327e495792c666
Gitweb:     http://git.kernel.org/tip/cafcd80d216bc2136b8edbb794327e495792c666
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 14 May 2010 11:11:21 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 16 May 2010 04:25:14 +0200

lockup_detector: Cross arch compile fixes

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
