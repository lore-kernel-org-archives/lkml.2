Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1AGPer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:34:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:40741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1AGPeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:34:46 -0500
Date: Fri, 7 Jan 2011 15:34:22 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1294348732-15030-4-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Add priorities to handlers
Message-ID: <tip-166d751479c6d4e5b17dfc1f204a9c4397c9b3f1@git.kernel.org>
Git-Commit-ID: 166d751479c6d4e5b17dfc1f204a9c4397c9b3f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:34:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  166d751479c6d4e5b17dfc1f204a9c4397c9b3f1
Gitweb:     http://git.kernel.org/tip/166d751479c6d4e5b17dfc1f204a9c4397c9b3f1
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 6 Jan 2011 16:18:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:52 +0100

x86, NMI: Add priorities to handlers

In order to consolidate the NMI die_chain events, we need to setup the priorities
for the die notifiers.

I started by defining a bunch of common priorities that can be used by the
notifier blocks.  Then I modified the notifier blocks to use the newly created
priorities.

Now that the priorities are straightened out, it should be easier to remove the
event DIE_NMI_IPI.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294348732-15030-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/nmi.h              |   20 ++++++++++++++++++++
 arch/x86/kernel/apic/hw_nmi.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
 arch/x86/kernel/cpu/perf_event.c        |    2 +-
 arch/x86/kernel/kgdb.c                  |    3 ++-
 arch/x86/kernel/reboot.c                |    2 ++
 arch/x86/oprofile/nmi_int.c             |    2 +-
 arch/x86/oprofile/nmi_timer_int.c       |    2 +-
 8 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c4021b9..c76f5b9 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -23,6 +23,26 @@ void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
+/*
+ * Define some priorities for the nmi notifier call chain.
+ *
+ * Create a local nmi bit that has a higher priority than
+ * external nmis, because the local ones are more frequent.
+ *
+ * Also setup some default high/normal/low settings for
+ * subsystems to registers with.  Using 4 bits to seperate
+ * the priorities.  This can go alot higher if needed be.
+ */
+
+#define NMI_LOCAL_SHIFT		16	/* randomly picked */
+#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
+#define NMI_HIGH_PRIOR		(1ULL << 8)
+#define NMI_NORMAL_PRIOR	(1ULL << 4)
+#define NMI_LOW_PRIOR		(1ULL << 0)
+#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
+#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
+#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
+
 void stop_nmi(void);
 void restart_nmi(void);
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 72ec29e..8bc49f1 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -96,7 +96,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block backtrace_notifier = {
 	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
 	.next                   = NULL,
-	.priority               = 1
+	.priority               = NMI_LOCAL_LOW_PRIOR,
 };
 
 static int __init register_trigger_all_cpu_backtrace(void)
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e7dbde7..59546c1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -95,7 +95,7 @@ static int mce_raise_notify(struct notifier_block *self,
 
 static struct notifier_block mce_raise_nb = {
 	.notifier_call = mce_raise_notify,
-	.priority = 1000,
+	.priority = NMI_LOCAL_NORMAL_PRIOR,
 };
 
 /* Inject mce on current CPU */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a360d1..5e14b5e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1318,7 +1318,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
-	.priority		= 1
+	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
 static struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index cd21b65..d43c841 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -48,6 +48,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
@@ -606,7 +607,7 @@ static struct notifier_block kgdb_notifier = {
 	/*
 	 * Lowest-prio notifier priority, we want to be notified last:
 	 */
-	.priority	= -INT_MAX,
+	.priority	= NMI_LOCAL_LOW_PRIOR,
 };
 
 /**
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c495aa8..9c1c83e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -778,6 +778,8 @@ static void smp_send_nmi_allbutself(void)
 
 static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
+	/* we want to be the first one called */
+	.priority = NMI_LOCAL_HIGH_PRIOR+1,
 };
 
 /* Halt all other CPUs, calling the specified function on each of them
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 358c8b9..6e84ea4 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -361,7 +361,7 @@ static void nmi_cpu_setup(void *dummy)
 static struct notifier_block profile_exceptions_nb = {
 	.notifier_call = profile_exceptions_notify,
 	.next = NULL,
-	.priority = 2
+	.priority = NMI_LOCAL_LOW_PRIOR,
 };
 
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index 0636dd9..720bf5a 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -38,7 +38,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 static struct notifier_block profile_timer_exceptions_nb = {
 	.notifier_call = profile_timer_exceptions_notify,
 	.next = NULL,
-	.priority = 0
+	.priority = NMI_LOW_PRIOR,
 };
 
 static int timer_start(void)
