Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2LNRvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:51:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:14213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab2LNRvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:51:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,282,1355126400"; 
   d="scan'208";a="181002943"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "swetland@google.com" <swetland@google.com>
CC: "Zhang, Di" <di.zhang@intel.com>, "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Subject: [PATCH] [lmk]  improve ANR produce rate caused by high io
 wait on android,create a thread for lowmem killer instead of usingkswapd
Thread-Topic: Subject: [PATCH] [lmk]  improve ANR produce rate caused by
 high io wait on android,create a thread for lowmem killer instead of
 usingkswapd
Thread-Index: Ac3aGEdv/5133Wd5T0qGsUMTqzTW3AAC0IEQ
Date: Fri, 14 Dec 2012 17:51:47 +0000
Message-ID: <EE928378561BF1449699C96571234A740FF11D0A@SHSMSX102.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to fix the typo issue.


Subject: [PATCH] [lmk] create a thread for low mem killer instead of using kswapd

Currently low mem killer is registered as a shrinker and will be
invoked by kswapd. Since low mem killer and kswapd has different
criteria to invoke to work -- kswap wakes up when watermark of some
certain order in zone is low, and low mem killer should do its job
when free memory is below the min free threshold. In the case that
the kswapd isn't waked up and lmk is, the killed process selected
by lmk will release memory so that the kswapd doesn't need towork
any more.So it is not appropriate to mix them together. A 20 minutes
average vmstat shows that the iowait/page fault has huge improvement.
In this way, it can reduce the chance of ANR due to high iowait.

orignal:
flt    wa
62.70 2.00

with patch
flt    wa
2.32  0.01

Signed-off-by: Zhang Di <di.zhang@intel.com>
Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
---
 drivers/staging/android/lowmemorykiller.c |   87 +++++++++++++++++++++++++++--
 mm/page_alloc.c                           |    7 ++-
 mm/vmscan.c                               |    2 +
 3 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..3d87c6d 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -36,6 +36,8 @@
 #include <linux/sched.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
 
 static uint32_t lowmem_debug_level = 2;
 static int lowmem_adj[6] = {
@@ -52,7 +54,7 @@ static size_t lowmem_minfree[6] = {
 	16 * 1024,	/* 64MB */
 };
 static int lowmem_minfree_size = 4;
-
+static unsigned long lowmem_timeout;
 static struct task_struct *lowmem_deathpending;
 
 #define lowmem_print(level, x...)			\
@@ -68,17 +70,46 @@ static struct notifier_block task_nb = {
 	.notifier_call	= task_notify_func,
 };
 
+static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc);
+
+int lmk_involk()
+{
+	int other_free = global_page_state(NR_FREE_PAGES);
+	int other_file = global_page_state(NR_INACTIVE_FILE);
+	int array_max_idx = ARRAY_SIZE(lowmem_adj)-2;
+
+	if (lowmem_deathpending &&
+		time_before_eq(jiffies, lowmem_deathpending_timeout))
+		return 0;
+	if (time_before_eq(jiffies, lowmem_timeout))
+		return 0;
+
+	if (other_free + other_file > lowmem_minfree[array_max_idx])
+		return 0;
+
+	lowmem_timeout = jiffies + HZ/2;
+
+	return 1;
+}
+
+void wakeup_lmkd();
+
 static int
 task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct task_struct *task = data;
+	struct shrink_control sc = {NULL, 1};
 	if (task == lowmem_deathpending) {
 		lowmem_deathpending = NULL;
-		task_handoff_unregister(&task_nb);
+		if (lmk_involk()) {
+			wakeup_lmkd();
+		}
 	}
 	return NOTIFY_OK;
 }
 
+
+
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 {
 	struct task_struct *p;
@@ -93,6 +124,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	int other_free = global_page_state(NR_FREE_PAGES);
 	int other_file = global_page_state(NR_FILE_PAGES) -
 						global_page_state(NR_SHMEM);
+	int other_file_act = global_page_state(NR_ACTIVE_FILE);
+	int other_anon = global_page_state(NR_ANON_PAGES);
 
 	/*
 	 * If we already have a death outstanding, then
@@ -105,6 +138,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	 */
 	if (lowmem_deathpending)
 		return 0;
+	lowmem_deathpending = NULL;
 
 	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
@@ -146,7 +180,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			continue;
 		}
 		oom_adj = sig->oom_adj;
-		if (oom_adj < min_adj) {
+		if (oom_adj < selected_oom_adj) {
 			task_unlock(p);
 			continue;
 		}
@@ -155,8 +189,6 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		if (tasksize <= 0)
 			continue;
 		if (selected) {
-			if (oom_adj < selected_oom_adj)
-				continue;
 			if (oom_adj == selected_oom_adj &&
 			    tasksize <= selected_tasksize)
 				continue;
@@ -189,6 +221,51 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	return rem;
 }
 
+wait_queue_head_t lmkd_wait;
+
+static void lmkd_try_to_sleep()
+{
+	long remaining;
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&lmkd_wait, &wait, TASK_INTERRUPTIBLE);
+	schedule();
+	finish_wait(&lmkd_wait, &wait);
+}
+
+struct task_struct *lmkd_task;
+static int lmkd();
+int lmkd_run(int nid)
+{
+	int ret = 0;
+	if (lmkd_task)
+		return ret;
+	init_waitqueue_head(&lmkd_wait);
+	lowmem_timeout = jiffies;
+	lmkd_task = kthread_run(lmkd, NULL , "lmkd");
+	if (IS_ERR(lmkd_task)) {
+		printk("Failed to start lmkd\n");
+		ret = -1;
+	}
+	return ret;
+}
+
+static int lmkd()
+{
+	struct shrink_control sc = {NULL, 1};
+	while (1) {
+		lowmem_shrink(NULL, &sc);
+	}
+}
+
+void wakeup_lmkd()
+{
+	if (!waitqueue_active(&lmkd_wait))
+		return;
+	wake_up_interruptible(&lmkd_wait);
+}
+
 static struct shrinker lowmem_shrinker = {
 	.shrink = lowmem_shrink,
 	.seeks = DEFAULT_SEEKS * 16
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7990ca1..1bcb476 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2226,8 +2226,9 @@ got_pg:
 
 }
 
-/*
- * This is the 'heart' of the zoned buddy allocator.
+extern int lmk_involk();
+extern void wakeup_lmkd();
+/* This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
@@ -2264,6 +2265,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		put_mems_allowed();
 		return NULL;
 	}
+	if (lmk_involk())
+		wakeup_lmkd();
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 753a2dc..db33dba 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3106,6 +3106,7 @@ void kswapd_stop(int nid)
 		kthread_stop(kswapd);
 }
 
+extern int lmkd_run();
 static int __init kswapd_init(void)
 {
 	int nid;
@@ -3113,6 +3114,7 @@ static int __init kswapd_init(void)
 	swap_setup();
 	for_each_node_state(nid, N_HIGH_MEMORY)
  		kswapd_run(nid);
+	lmkd_run();
 	hotcpu_notifier(cpu_callback, 0);
 	return 0;
 }
-- 
1.7.6

