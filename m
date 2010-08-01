Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0HALHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 07:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0HALHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 07:07:41 -0400
Message-ID: <4C55556C.6050206@kernel.org>
Date: Sun, 01 Aug 2010 13:07:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] workqueue: mark init_workqueues() as early_initcall()
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 Aug 2010 11:07:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6ee0578b4daaea01c96b172c6aacca43fd9807a6 Mon Sep 17 00:00:00 2001
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 30 Jul 2010 14:57:37 -0700

Mark init_workqueues() as early_initcall() and thus it will be initialized
before smp bringup. init_workqueues() registers for the hotcpu notifier
and thus it should cope with the processors that are brought online after
the workqueues are initialized.

x86 smp bringup code uses workqueues and uses a workaround for the
cold boot process (as the workqueues are initialized post smp_init()).
Marking init_workqueues() as early_initcall() will pave the way for
cleaning up this code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Audited and tested.  It should be fine.  Patch applied and pushed out
to linux-next.  How shall we route the second patch?

Thanks.

 include/linux/workqueue.h |    1 -
 init/main.c               |    2 --
 kernel/workqueue.c        |    4 +++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5f76001..51dc9a7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -327,7 +327,6 @@ extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 extern int schedule_on_each_cpu(work_func_t func);
 extern int keventd_up(void);

-extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);

 extern int flush_work(struct work_struct *work);
diff --git a/init/main.c b/init/main.c
index 3bdb152..5f2ec2c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -32,7 +32,6 @@
 #include <linux/start_kernel.h>
 #include <linux/security.h>
 #include <linux/smp.h>
-#include <linux/workqueue.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
@@ -786,7 +785,6 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
-	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
 	init_tmpfs();
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1105c47..e2eb351 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3507,7 +3507,7 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */

-void __init init_workqueues(void)
+static int __init init_workqueues(void)
 {
 	unsigned int cpu;
 	int i;
@@ -3559,4 +3559,6 @@ void __init init_workqueues(void)
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+	return 0;
 }
+early_initcall(init_workqueues);
-- 
1.7.1

