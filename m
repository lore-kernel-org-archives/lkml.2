Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1ESCbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:31:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51545 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1ESCbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:31:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD480DD.2040307@jp.fujitsu.com>
Date: Thu, 19 May 2011 11:30:53 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        riel@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH v2 1/3] vmscan,memcg: memcg aware swap token
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memcg reclaim can disable swap token even if the swap token
mm doesn't belong in its memory cgroup. It's slightly risky. If an
admin creates very small mem-cgroup and silly guy runs contentious heavy
memory pressure workload, every tasks are going to lose swap token and
then system may become unresponsive. That's bad.

This patch adds 'memcg' parameter into disable_swap_token(). and if
the parameter doesn't match swap token, VM doesn't disable it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
---
 include/linux/memcontrol.h |    6 +++
 include/linux/swap.h       |    8 +---
 mm/memcontrol.c            |   16 ++++-----
 mm/thrash.c                |   73 ++++++++++++++++++++++++++++++++-----------
 mm/vmscan.c                |    4 +-
 5 files changed, 71 insertions(+), 36 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a0cffd..df572af 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -84,6 +84,7 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);

 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);

 static inline
 int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
@@ -244,6 +245,11 @@ static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 	return NULL;
 }

+static inline struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+{
+	return NULL;
+}
+
 static inline int mm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
 	return 1;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 384eb5f..e705646 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -358,6 +358,7 @@ struct backing_dev_info;
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
+extern void disable_swap_token(struct mem_cgroup *memcg);

 static inline int has_swap_token(struct mm_struct *mm)
 {
@@ -370,11 +371,6 @@ static inline void put_swap_token(struct mm_struct *mm)
 		__put_swap_token(mm);
 }

-static inline void disable_swap_token(void)
-{
-	put_swap_token(swap_token_mm);
-}
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
@@ -500,7 +496,7 @@ static inline int has_swap_token(struct mm_struct *mm)
 	return 0;
 }

-static inline void disable_swap_token(void)
+static inline void disable_swap_token(struct mem_cgroup *memcg)
 {
 }

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c2776f1..1a78b3e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -735,7 +735,7 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 				struct mem_cgroup, css);
 }

-static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *mem = NULL;

@@ -5194,18 +5194,16 @@ static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
-	struct mm_struct *mm;
+	struct mm_struct *mm = get_task_mm(p);

-	if (!mc.to)
-		/* no need to move charge */
-		return;
-
-	mm = get_task_mm(p);
 	if (mm) {
-		mem_cgroup_move_charge(mm);
+		if (mc.to)
+			mem_cgroup_move_charge(mm);
+		put_swap_token(mm);
 		mmput(mm);
 	}
-	mem_cgroup_clear_mc();
+	if (mc.to)
+		mem_cgroup_clear_mc();
 }
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
diff --git a/mm/thrash.c b/mm/thrash.c
index 2372d4e..32c07fd 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -21,14 +21,17 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/swap.h>
+#include <linux/memcontrol.h>

 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
+struct mem_cgroup *swap_token_memcg;
 static unsigned int global_faults;

 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
+	struct mem_cgroup *memcg;

 	global_faults++;

@@ -38,40 +41,72 @@ void grab_swap_token(struct mm_struct *mm)
 		return;

 	/* First come first served */
-	if (swap_token_mm == NULL) {
-		mm->token_priority = mm->token_priority + 2;
-		swap_token_mm = mm;
+	if (!swap_token_mm)
+		goto replace_token;
+
+	if (mm == swap_token_mm) {
+		mm->token_priority += 2;
 		goto out;
 	}

-	if (mm != swap_token_mm) {
-		if (current_interval < mm->last_interval)
-			mm->token_priority++;
-		else {
-			if (likely(mm->token_priority > 0))
-				mm->token_priority--;
-		}
-		/* Check if we deserve the token */
-		if (mm->token_priority > swap_token_mm->token_priority) {
-			mm->token_priority += 2;
-			swap_token_mm = mm;
-		}
-	} else {
-		/* Token holder came in again! */
-		mm->token_priority += 2;
+	if (current_interval < mm->last_interval)
+		mm->token_priority++;
+	else {
+		if (likely(mm->token_priority > 0))
+			mm->token_priority--;
 	}

+	/* Check if we deserve the token */
+	if (mm->token_priority > swap_token_mm->token_priority)
+		goto replace_token;
+
 out:
 	mm->faultstamp = global_faults;
 	mm->last_interval = current_interval;
 	spin_unlock(&swap_token_lock);
+	return;
+
+replace_token:
+	mm->token_priority += 2;
+	memcg = try_get_mem_cgroup_from_mm(mm);
+	if (memcg)
+		css_put(mem_cgroup_css(memcg));
+	swap_token_mm = mm;
+	swap_token_memcg = memcg;
+	goto out;
 }

 /* Called on process exit. */
 void __put_swap_token(struct mm_struct *mm)
 {
 	spin_lock(&swap_token_lock);
-	if (likely(mm == swap_token_mm))
+	if (likely(mm == swap_token_mm)) {
 		swap_token_mm = NULL;
+		swap_token_memcg = NULL;
+	}
 	spin_unlock(&swap_token_lock);
 }
+
+static bool match_memcg(struct mem_cgroup *a, struct mem_cgroup *b)
+{
+	if (!a)
+		return true;
+	if (!b)
+		return true;
+	if (a == b)
+		return true;
+	return false;
+}
+
+void disable_swap_token(struct mem_cgroup *memcg)
+{
+	/* memcg reclaim don't disable unrelated mm token. */
+	if (match_memcg(memcg, swap_token_memcg)) {
+		spin_lock(&swap_token_lock);
+		if (match_memcg(memcg, swap_token_memcg)) {
+			swap_token_mm = NULL;
+			swap_token_memcg = NULL;
+		}
+		spin_unlock(&swap_token_lock);
+	}
+}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3a569f..19e179b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2044,7 +2044,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(sc->mem_cgroup);
 		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2353,7 +2353,7 @@ loop_again:

 		/* The swap token gets in the way of swapout... */
 		if (!priority)
-			disable_swap_token();
+			disable_swap_token(NULL);

 		all_zones_ok = 1;
 		balanced = 0;
-- 
1.7.3.1


