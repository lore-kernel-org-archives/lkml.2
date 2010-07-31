Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0GaApY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 20:45:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:3753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0GaApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 20:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,290,1278313200"; 
   d="scan'208";a="591511889"
Message-Id: <20100731004316.101616883@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jul 2010 17:41:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch v2 1/2] workqueue: mark init_workqueues() as early_initcall()
Content-Disposition: inline; filename=init_workqueues_before_smp_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark init_workqueues() as early_initcall() and thus it will be initialized
before smp bringup. init_workqueues() registers for the hotcpu notifier
and thus it should cope with the processors that are brought online after
the workqueues are initialized.

x86, ia64 smp bringup code uses workqueues and uses a workaround for the
cold boot process (as the workqueues are initialized post smp_init()).
Marking init_workqueues() as early_initcall() will pave the way for
cleaning up this code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/workqueue.h |    1 -
 init/main.c               |    2 --
 kernel/workqueue.c        |    5 ++++-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-next/init/main.c
===================================================================
--- linux-next.orig/init/main.c
+++ linux-next/init/main.c
@@ -32,7 +32,6 @@
 #include <linux/start_kernel.h>
 #include <linux/security.h>
 #include <linux/smp.h>
-#include <linux/workqueue.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
@@ -787,7 +786,6 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
-	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
 	init_tmpfs();
Index: linux-next/include/linux/workqueue.h
===================================================================
--- linux-next.orig/include/linux/workqueue.h
+++ linux-next/include/linux/workqueue.h
@@ -327,7 +327,6 @@ extern int schedule_delayed_work_on(int 
 extern int schedule_on_each_cpu(work_func_t func);
 extern int keventd_up(void);
 
-extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern int flush_work(struct work_struct *work);
Index: linux-next/kernel/workqueue.c
===================================================================
--- linux-next.orig/kernel/workqueue.c
+++ linux-next/kernel/workqueue.c
@@ -3509,7 +3509,7 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */
 
-void __init init_workqueues(void)
+static int __init init_workqueues(void)
 {
 	unsigned int cpu;
 	int i;
@@ -3561,4 +3561,7 @@ void __init init_workqueues(void)
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+
+	return 0;
 }
+early_initcall(init_workqueues);


