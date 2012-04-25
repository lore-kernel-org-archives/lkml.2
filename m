Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2DYIZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab2DYIXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:23:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] ftrace: Remove unused code ftrace related code
Date: Wed, 25 Apr 2012 10:23:36 +0200
Message-Id: <1335342219-2782-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unused functions:
  ftrace_rec_iter_record
  ftrace_rec_iter_next
  ftrace_rec_iter_start
  ftrace_location

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h |    7 ---
 kernel/trace/ftrace.c  |  100 ------------------------------------------------
 2 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..49596e3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -280,16 +280,9 @@ enum {
 
 void arch_ftrace_update_code(int command);
 
-struct ftrace_rec_iter;
-
-struct ftrace_rec_iter *ftrace_rec_iter_start(void);
-struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter);
-struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter);
-
 int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
-int ftrace_location(unsigned long ip);
 
 extern ftrace_func_t ftrace_trace_function;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fa92f6..6e6c51a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1393,34 +1393,6 @@ static int ftrace_cmp_recs(const void *a, const void *b)
 	return 0;
 }
 
-/**
- * ftrace_location - return true if the ip giving is a traced location
- * @ip: the instruction pointer to check
- *
- * Returns 1 if @ip given is a pointer to a ftrace location.
- * That is, the instruction that is either a NOP or call to
- * the function tracer. It checks the ftrace internal tables to
- * determine if the address belongs or not.
- */
-int ftrace_location(unsigned long ip)
-{
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-	struct dyn_ftrace key;
-
-	key.ip = ip;
-
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		rec = bsearch(&key, pg->records, pg->index,
-			      sizeof(struct dyn_ftrace),
-			      ftrace_cmp_recs);
-		if (rec)
-			return 1;
-	}
-
-	return 0;
-}
-
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1717,78 +1689,6 @@ static void ftrace_replace_code(int update)
 	} while_for_each_ftrace_rec();
 }
 
-struct ftrace_rec_iter {
-	struct ftrace_page	*pg;
-	int			index;
-};
-
-/**
- * ftrace_rec_iter_start, start up iterating over traced functions
- *
- * Returns an iterator handle that is used to iterate over all
- * the records that represent address locations where functions
- * are traced.
- *
- * May return NULL if no records are available.
- */
-struct ftrace_rec_iter *ftrace_rec_iter_start(void)
-{
-	/*
-	 * We only use a single iterator.
-	 * Protected by the ftrace_lock mutex.
-	 */
-	static struct ftrace_rec_iter ftrace_rec_iter;
-	struct ftrace_rec_iter *iter = &ftrace_rec_iter;
-
-	iter->pg = ftrace_pages_start;
-	iter->index = 0;
-
-	/* Could have empty pages */
-	while (iter->pg && !iter->pg->index)
-		iter->pg = iter->pg->next;
-
-	if (!iter->pg)
-		return NULL;
-
-	return iter;
-}
-
-/**
- * ftrace_rec_iter_next, get the next record to process.
- * @iter: The handle to the iterator.
- *
- * Returns the next iterator after the given iterator @iter.
- */
-struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter)
-{
-	iter->index++;
-
-	if (iter->index >= iter->pg->index) {
-		iter->pg = iter->pg->next;
-		iter->index = 0;
-
-		/* Could have empty pages */
-		while (iter->pg && !iter->pg->index)
-			iter->pg = iter->pg->next;
-	}
-
-	if (!iter->pg)
-		return NULL;
-
-	return iter;
-}
-
-/**
- * ftrace_rec_iter_record, get the record at the iterator location
- * @iter: The current iterator location
- *
- * Returns the record that the current @iter is at.
- */
-struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter)
-{
-	return &iter->pg->records[iter->index];
-}
-
 static int
 ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 {
-- 
1.7.1

