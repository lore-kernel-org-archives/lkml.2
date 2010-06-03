Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab0FCANu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab0FCANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: [RFC 2/5] BKL: remove the BKL from kernel init code
Date: Thu,  3 Jun 2010 02:13:16 +0200
Message-Id: <1275523999-27462-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275523999-27462-1-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Ws/+Yw3sfSehxhyTDvQsVVZcovdUusYjDWpS
 QK7ypsm2MZaYBsJAlTS1LG3kRZy0Mu2BmeogutGa+PucP31pU2
 NA2T/ZbEWn9dXmAc1abKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have shown by code review that no driver takes
the BKL at init time any more, so whatever the
init code was locking against is no longer there
and it is now safe to remove the BKL there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 init/main.c          |    5 -----
 kernel/trace/trace.c |    8 --------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3bdb152..81821e1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -434,7 +434,6 @@ static noinline void __init_refok rest_init(void)
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
-	unlock_kernel();
 
 	/*
 	 * The boot idle thread must execute schedule()
@@ -555,7 +554,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	lock_kernel();
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
@@ -819,7 +817,6 @@ static noinline int init_post(void)
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
 	free_initmem();
-	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
@@ -855,8 +852,6 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
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
1.7.0.4

