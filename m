Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2BBVys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:54:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45686 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2BBVyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:54:47 -0500
Date: Thu, 2 Feb 2012 13:54:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [patch] android, lowmemorykiller: convert to use oom_score_adj
Message-ID: <alpine.DEB.2.00.1202021353420.13316@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/pid/oom_adj is deprecated and will be removed in August 2012
according to Documentation/feature-removal-schedule.txt.  Convert its
usage in the lowmemorykiller to use the new interface, oom_score_adj,
instead.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/staging/android/lowmemorykiller.c |   43 +++++++++++++++--------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -1,16 +1,17 @@
 /* drivers/misc/lowmemorykiller.c
  *
  * The lowmemorykiller driver lets user-space specify a set of memory thresholds
- * where processes with a range of oom_adj values will get killed. Specify the
- * minimum oom_adj values in /sys/module/lowmemorykiller/parameters/adj and the
- * number of free pages in /sys/module/lowmemorykiller/parameters/minfree. Both
- * files take a comma separated list of numbers in ascending order.
+ * where processes with a range of oom_score_adj values will get killed. Specify
+ * the minimum oom_score_adj values in
+ * /sys/module/lowmemorykiller/parameters/adj and the number of free pages in
+ * /sys/module/lowmemorykiller/parameters/minfree. Both files take a comma
+ * separated list of numbers in ascending order.
  *
  * For example, write "0,8" to /sys/module/lowmemorykiller/parameters/adj and
  * "1024,4096" to /sys/module/lowmemorykiller/parameters/minfree to kill
- * processes with a oom_adj value of 8 or higher when the free memory drops
- * below 4096 pages and kill processes with a oom_adj value of 0 or higher
- * when the free memory drops below 1024 pages.
+ * processes with a oom_score_adj value of 8 or higher when the free memory
+ * drops below 4096 pages and kill processes with a oom_score_adj value of 0 or
+ * higher when the free memory drops below 1024 pages.
  *
  * The driver considers memory used for caches to be free, but if a large
  * percentage of the cached memory is locked this can be very inaccurate
@@ -86,9 +87,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	int rem = 0;
 	int tasksize;
 	int i;
-	int min_adj = OOM_ADJUST_MAX + 1;
+	int min_score_adj = OOM_SCORE_ADJ_MAX + 1;
 	int selected_tasksize = 0;
-	int selected_oom_adj;
+	int selected_oom_score_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES);
 	int other_file = global_page_state(NR_FILE_PAGES) -
@@ -113,30 +114,30 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	for (i = 0; i < array_size; i++) {
 		if (other_free < lowmem_minfree[i] &&
 		    other_file < lowmem_minfree[i]) {
-			min_adj = lowmem_adj[i];
+			min_score_adj = lowmem_adj[i];
 			break;
 		}
 	}
 	if (sc->nr_to_scan > 0)
 		lowmem_print(3, "lowmem_shrink %lu, %x, ofree %d %d, ma %d\n",
 				sc->nr_to_scan, sc->gfp_mask, other_free,
-				other_file, min_adj);
+				other_file, min_score_adj);
 	rem = global_page_state(NR_ACTIVE_ANON) +
 		global_page_state(NR_ACTIVE_FILE) +
 		global_page_state(NR_INACTIVE_ANON) +
 		global_page_state(NR_INACTIVE_FILE);
-	if (sc->nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
+	if (sc->nr_to_scan <= 0 || min_score_adj == OOM_SCORE_ADJ_MAX + 1) {
 		lowmem_print(5, "lowmem_shrink %lu, %x, return %d\n",
 			     sc->nr_to_scan, sc->gfp_mask, rem);
 		return rem;
 	}
-	selected_oom_adj = min_adj;
+	selected_oom_score_adj = min_score_adj;
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		struct mm_struct *mm;
 		struct signal_struct *sig;
-		int oom_adj;
+		int oom_score_adj;
 
 		task_lock(p);
 		mm = p->mm;
@@ -145,8 +146,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = sig->oom_adj;
-		if (oom_adj < min_adj) {
+		oom_score_adj = sig->oom_score_adj;
+		if (oom_score_adj < min_score_adj) {
 			task_unlock(p);
 			continue;
 		}
@@ -155,22 +156,22 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		if (tasksize <= 0)
 			continue;
 		if (selected) {
-			if (oom_adj < selected_oom_adj)
+			if (oom_score_adj < selected_oom_score_adj)
 				continue;
-			if (oom_adj == selected_oom_adj &&
+			if (oom_score_adj == selected_oom_score_adj &&
 			    tasksize <= selected_tasksize)
 				continue;
 		}
 		selected = p;
 		selected_tasksize = tasksize;
-		selected_oom_adj = oom_adj;
+		selected_oom_score_adj = oom_score_adj;
 		lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
-			     p->pid, p->comm, oom_adj, tasksize);
+			     p->pid, p->comm, oom_score_adj, tasksize);
 	}
 	if (selected) {
 		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
 			     selected->pid, selected->comm,
-			     selected_oom_adj, selected_tasksize);
+			     selected_oom_score_adj, selected_tasksize);
 		/*
 		 * If CONFIG_PROFILING is off, then task_handoff_register()
 		 * is a nop. In that case we don't want to stall the killer
