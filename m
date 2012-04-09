Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab2DIX4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:56:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2DIX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:56:21 -0400
Date: Mon, 9 Apr 2012 16:56:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Colin Cross <ccross@google.com>
Subject: [patch] android, lowmemorykiller: remove task handoff notifier
In-Reply-To: <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204091655470.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
 <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task handoff notifier leaks task_struct since it never gets freed
after the callback returns NOTIFY_OK, which means it is responsible for
doing so.

It turns out the lowmemorykiller actually doesn't need this notifier at
all.  It's used to prevent unnecessary killing by waiting for a thread to
exit as a result of lowmem_shrink(), however, it's possible to do this in
the same way the kernel oom killer works by setting TIF_MEMDIE and avoid
killing if we're still waiting for it to exit.

The kernel oom killer will already automatically set TIF_MEMDIE for
threads that are attempting to allocate memory that have a fatal signal.
The thread selected by lowmem_shrink() will have such a signal after the
lowmemorykiller sends it a SIGKILL, so this won't result in an
unnecessary use of memory reserves for the thread to exit.

This has the added benefit that we don't have to rely on CONFIG_PROFILING
to prevent needlessly killing tasks.

Reported-by: werner <w.landgraf@ru.ru>
Cc: stable@vger.kernel.org
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/staging/android/lowmemorykiller.c |   48 +++++------------------------
 1 file changed, 7 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -55,7 +55,6 @@ static int lowmem_minfree[6] = {
 };
 static int lowmem_minfree_size = 4;
 
-static struct task_struct *lowmem_deathpending;
 static unsigned long lowmem_deathpending_timeout;
 
 #define lowmem_print(level, x...)			\
@@ -64,24 +63,6 @@ static unsigned long lowmem_deathpending_timeout;
 			printk(x);			\
 	} while (0)
 
-static int
-task_notify_func(struct notifier_block *self, unsigned long val, void *data);
-
-static struct notifier_block task_nb = {
-	.notifier_call	= task_notify_func,
-};
-
-static int
-task_notify_func(struct notifier_block *self, unsigned long val, void *data)
-{
-	struct task_struct *task = data;
-
-	if (task == lowmem_deathpending)
-		lowmem_deathpending = NULL;
-
-	return NOTIFY_OK;
-}
-
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 {
 	struct task_struct *tsk;
@@ -97,19 +78,6 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	int other_file = global_page_state(NR_FILE_PAGES) -
 						global_page_state(NR_SHMEM);
 
-	/*
-	 * If we already have a death outstanding, then
-	 * bail out right away; indicating to vmscan
-	 * that we have nothing further to offer on
-	 * this pass.
-	 *
-	 * Note: Currently you need CONFIG_PROFILING
-	 * for this to work correctly.
-	 */
-	if (lowmem_deathpending &&
-	    time_before_eq(jiffies, lowmem_deathpending_timeout))
-		return 0;
-
 	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
 	if (lowmem_minfree_size < array_size)
@@ -148,6 +116,12 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		if (!p)
 			continue;
 
+		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
+		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
+			task_unlock(p);
+			rcu_read_unlock();
+			return 0;
+		}
 		oom_score_adj = p->signal->oom_score_adj;
 		if (oom_score_adj < min_score_adj) {
 			task_unlock(p);
@@ -174,15 +148,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
-		/*
-		 * If CONFIG_PROFILING is off, then we don't want to stall
-		 * the killer by setting lowmem_deathpending.
-		 */
-#ifdef CONFIG_PROFILING
-		lowmem_deathpending = selected;
 		lowmem_deathpending_timeout = jiffies + HZ;
-#endif
 		send_sig(SIGKILL, selected, 0);
+		set_tsk_thread_flag(selected, TIF_MEMDIE);
 		rem -= selected_tasksize;
 	}
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
@@ -198,7 +166,6 @@ static struct shrinker lowmem_shrinker = {
 
 static int __init lowmem_init(void)
 {
-	task_handoff_register(&task_nb);
 	register_shrinker(&lowmem_shrinker);
 	return 0;
 }
@@ -206,7 +173,6 @@ static int __init lowmem_init(void)
 static void __exit lowmem_exit(void)
 {
 	unregister_shrinker(&lowmem_shrinker);
-	task_handoff_unregister(&task_nb);
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
