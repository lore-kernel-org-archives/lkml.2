Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab2CGNyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:54:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63753 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2CGNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:54:04 -0500
Date: Wed, 7 Mar 2012 17:54:00 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: john stultz <johnstul@us.ibm.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, San Mehat <san@google.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: android/lowmemorykiller: Don't unregister notifier
 from atomic context
Message-ID: <20120307135400.GA4354@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

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
---

This is respin of http://lkml.org/lkml/2012/1/3/265, which does not
apply cleanly nowadays.

 drivers/staging/android/lowmemorykiller.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index cf4c6f7..03d1de2 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -75,10 +75,10 @@ static int
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
 
@@ -175,14 +175,12 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
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
 		send_sig(SIGKILL, selected, 0);
 		rem -= selected_tasksize;
@@ -200,6 +198,7 @@ static struct shrinker lowmem_shrinker = {
 
 static int __init lowmem_init(void)
 {
+	task_handoff_register(&task_nb);
 	register_shrinker(&lowmem_shrinker);
 	return 0;
 }
@@ -207,6 +206,7 @@ static int __init lowmem_init(void)
 static void __exit lowmem_exit(void)
 {
 	unregister_shrinker(&lowmem_shrinker);
+	task_handoff_unregister(&task_nb);
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
-- 
1.7.7.6

