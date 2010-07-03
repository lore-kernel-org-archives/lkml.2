Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0GCWCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:02:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0GCWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/8] init: remove the BKL from startup code
Date: Sun,  4 Jul 2010 00:02:26 +0200
Message-Id: <1278194552-24943-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VpI3ISWdudpAUNcKSimUvFuDH193lwpiIYlDrujNY7P
 s7zlp4TSkej4+NuvMO1LhdjLJGtxmGTyUI7VUHJHdu81KSfWsT
 tljMn3Fj2bt1DoRZfuIcs7SR6Asw/6XPpJrLUVQRkooJoWv4JY
 N1IFW8y/Q1uz5GvH6u4HAlRD1q9MSX7PPucrfOKabVm++ozOJZ
 4EFJsPLRthUKOjyZUpvnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have shown by code review that no driver takes
the BKL at init time any more, so whatever the
init code was locking against is no longer there
and it is now safe to remove the BKL there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Steven Rostedt <rostedt@goodmis>
---
 init/main.c          |    5 -----
 kernel/trace/trace.c |    8 --------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/init/main.c b/init/main.c
index a42fdf4..9b34c1b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -444,7 +444,6 @@ static noinline void __init_refok rest_init(void)
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
 	complete(&kthreadd_done);
-	unlock_kernel();
 
 	/*
 	 * The boot idle thread must execute schedule()
@@ -565,7 +564,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	lock_kernel();
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
@@ -829,7 +827,6 @@ static noinline int init_post(void)
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
 	free_initmem();
-	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
@@ -869,8 +866,6 @@ static int __init kernel_init(void * unused)
 	 * Wait until kthreadd is all set-up.
 	 */
 	wait_for_completion(&kthreadd_done);
-	lock_kernel();
-
 	/*
 	 * init can allocate pages on any node
 	 */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..8047ca5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -734,13 +734,6 @@ __acquires(kernel_lock)
 		return -1;
 	}
 
-	/*
-	 * When this gets called we hold the BKL which means that
-	 * preemption is disabled. Various trace selftests however
-	 * need to disable and enable preemption for successful tests.
-	 * So we drop the BKL here and grab it after the tests again.
-	 */
-	unlock_kernel();
 	mutex_lock(&trace_types_lock);
 
 	tracing_selftest_running = true;
@@ -822,7 +815,6 @@ __acquires(kernel_lock)
 #endif
 
  out_unlock:
-	lock_kernel();
 	return ret;
 }
 
-- 
1.7.1

