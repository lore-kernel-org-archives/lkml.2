Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2DYIXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab2DYIXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:23:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] ftrace: No return value for ftrace_process_locs
Date: Wed, 25 Apr 2012 10:23:38 +0200
Message-Id: <1335342219-2782-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of ftrace_process_locs is never checked. The function
tries to update as many calls as possible and in case of error there's
either warning output or ftrace_bug call.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b3ceecd..e67f5b3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1930,7 +1930,7 @@ static int ops_traces_mod(struct ftrace_ops *ops)
 	return ftrace_hash_empty(hash);
 }
 
-static int ftrace_update_code(struct module *mod)
+static void ftrace_update_code(struct module *mod)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *p;
@@ -1959,7 +1959,7 @@ static int ftrace_update_code(struct module *mod)
 		for (i = 0; i < pg->index; i++) {
 			/* If something went wrong, bail without enabling anything */
 			if (unlikely(ftrace_disabled))
-				return -1;
+				return;
 
 			p = &pg->records[i];
 			p->flags = ref;
@@ -1968,8 +1968,8 @@ static int ftrace_update_code(struct module *mod)
 			 * Do the initial record conversion from mcount jump
 			 * to the NOP instructions.
 			 */
-			if (!ftrace_code_disable(mod, p))
-				break;
+			if (WARN_ON_ONCE(!ftrace_code_disable(mod, p)))
+				return;
 
 			cnt++;
 
@@ -1992,7 +1992,6 @@ static int ftrace_update_code(struct module *mod)
 
 	ftrace_new_pgs = NULL;
 	ftrace_update_tot_cnt += cnt;
-	return 0;
 }
 
 static int ftrace_allocate_records(struct ftrace_page *pg, int count)
@@ -2041,11 +2040,11 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	int cnt;
 
 	if (!num_to_init)
-		return 0;
+		return NULL;
 
 	start_pg = pg = kzalloc(sizeof(*pg), GFP_KERNEL);
 	if (!pg)
-		return NULL;
+		goto out;
 
 	/*
 	 * Try to allocate as much as possible in one continues
@@ -2078,6 +2077,7 @@ ftrace_allocate_pages(unsigned long num_to_init)
 		kfree(pg);
 		pg = start_pg;
 	}
+ out:
 	pr_info("ftrace: FAILED to allocate memory for functions\n");
 	return NULL;
 }
@@ -3589,25 +3589,23 @@ static void ftrace_swap_recs(void *a, void *b, int size)
 	*recb = t;
 }
 
-static int ftrace_process_locs(struct module *mod,
-			       unsigned long *start,
-			       unsigned long *end)
+static void ftrace_process_locs(struct module *mod,
+				unsigned long *start,
+				unsigned long *end)
 {
 	struct ftrace_page *pg;
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
 	unsigned long flags = 0; /* Shut up gcc */
-	int ret = -ENOMEM;
 
 	count = end - start;
-
 	if (!count)
-		return 0;
+		return;
 
 	pg = ftrace_allocate_pages(count);
 	if (!pg)
-		return -ENOMEM;
+		return;
 
 	mutex_lock(&ftrace_lock);
 
@@ -3621,7 +3619,7 @@ static int ftrace_process_locs(struct module *mod,
 		/* First initialization */
 		ftrace_pages = ftrace_pages_start = pg;
 	} else {
-		if (!ftrace_pages)
+		if (!WARN_ON_ONCE(ftrace_pages))
 			goto out;
 
 		if (WARN_ON(ftrace_pages->next)) {
@@ -3670,11 +3668,8 @@ static int ftrace_process_locs(struct module *mod,
 	ftrace_update_code(mod);
 	if (!mod)
 		local_irq_restore(flags);
-	ret = 0;
  out:
 	mutex_unlock(&ftrace_lock);
-
-	return ret;
 }
 
 #ifdef CONFIG_MODULES
@@ -3789,9 +3784,9 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_process_locs(NULL,
-				  __start_mcount_loc,
-				  __stop_mcount_loc);
+	ftrace_process_locs(NULL,
+			    __start_mcount_loc,
+			    __stop_mcount_loc);
 
 	ret = register_module_notifier(&ftrace_module_nb);
 	if (ret)
-- 
1.7.1

