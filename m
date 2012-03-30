Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935933Ab2C3WCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:02:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935934Ab2C3VRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:06 -0400
Message-Id: <20120330194826.452834886@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [ 005/175] staging: android/lowmemorykiller: Dont unregister notifier from atomic context
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

commit 1eda5166c7640092f512138be6899d050c3d62ed upstream.

The lowmemorykiller registers an atomic notifier for notfication of when
the task is freed.  From this atomic notifier callback, it removes the
atomic notifier via task_free_unregister().  This is incorrect because
atomic_notifier_chain_unregister() calls syncronize_rcu(), which can
sleep, which shouldn't be done from an atomic notifier.

Fix this by registering the notifier during init, and only unregister it
if the lowmemorykiller is unloaded.

Rebased to -next by Paul E. McKenney.
Rebased to -next again by Anton Vorontsov.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Christian Bejram <christian.bejram@stericsson.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/lowmemorykiller.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -73,10 +73,10 @@ static int
 task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct task_struct *task = data;
-	if (task == lowmem_deathpending) {
+
+	if (task == lowmem_deathpending)
 		lowmem_deathpending = NULL;
-		task_handoff_unregister(&task_nb);
-	}
+
 	return NOTIFY_OK;
 }
 
@@ -174,14 +174,12 @@ static int lowmem_shrink(struct shrinker
 			     selected->pid, selected->comm,
 			     selected_oom_adj, selected_tasksize);
 		/*
-		 * If CONFIG_PROFILING is off, then task_handoff_register()
-		 * is a nop. In that case we don't want to stall the killer
-		 * by setting lowmem_deathpending.
+		 * If CONFIG_PROFILING is off, then we don't want to stall
+		 * the killer by setting lowmem_deathpending.
 		 */
 #ifdef CONFIG_PROFILING
 		lowmem_deathpending = selected;
 		lowmem_deathpending_timeout = jiffies + HZ;
-		task_handoff_register(&task_nb);
 #endif
 		force_sig(SIGKILL, selected);
 		rem -= selected_tasksize;
@@ -199,6 +197,7 @@ static struct shrinker lowmem_shrinker =
 
 static int __init lowmem_init(void)
 {
+	task_handoff_register(&task_nb);
 	register_shrinker(&lowmem_shrinker);
 	return 0;
 }
@@ -206,6 +205,7 @@ static int __init lowmem_init(void)
 static void __exit lowmem_exit(void)
 {
 	unregister_shrinker(&lowmem_shrinker);
+	task_handoff_unregister(&task_nb);
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);


