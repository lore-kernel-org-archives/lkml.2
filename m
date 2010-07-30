Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0G3WAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:00:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:60508 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0G3WAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,289,1278313200"; 
   d="scan'208";a="306487530"
Message-Id: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jul 2010 14:57:37 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/2] workqueue: mark init_workqueues() as early_initcall()
Content-Disposition: inline; filename=init_workqueues_before_smp_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark init_workqueues() as early_initcall() and thus it will be initialized
before smp bringup. init_workqueues() registers for the hotcpu notifier
and thus it should cope with the processors that are brought online after
the workqueues are initialized.

x86 smp bringup code uses workqueues and uses a workaround for the
cold boot process (as the workqueues are initialized post smp_init()).
Marking init_workqueues() as early_initcall() will pave the way for
cleaning up this code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/workqueue.h |    1 -
 init/main.c               |    2 --
 kernel/workqueue.c        |    4 +++-
 3 files changed, 3 insertions(+), 4 deletions(-)

Index: tip/init/main.c
===================================================================
--- tip.orig/init/main.c
+++ tip/init/main.c
@@ -32,7 +32,6 @@
 #include <linux/start_kernel.h>
 #include <linux/security.h>
 #include <linux/smp.h>
-#include <linux/workqueue.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
@@ -788,7 +787,6 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
-	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
 	init_tmpfs();
Index: tip/include/linux/workqueue.h
===================================================================
--- tip.orig/include/linux/workqueue.h
+++ tip/include/linux/workqueue.h
@@ -234,7 +234,6 @@ extern int schedule_on_each_cpu(work_fun
 extern int current_is_keventd(void);
 extern int keventd_up(void);
 
-extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern int flush_work(struct work_struct *work);
Index: tip/kernel/workqueue.c
===================================================================
--- tip.orig/kernel/workqueue.c
+++ tip/kernel/workqueue.c
@@ -1216,7 +1216,7 @@ long work_on_cpu(unsigned int cpu, long 
 EXPORT_SYMBOL_GPL(work_on_cpu);
 #endif /* CONFIG_SMP */
 
-void __init init_workqueues(void)
+static int __init init_workqueues(void)
 {
 	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
 
@@ -1226,4 +1226,6 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+	return 0;
 }
+early_initcall(init_workqueues);


