Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1D2Onm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab1D2On0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:43:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 3/3] tracing: set_ftrace_filter support
Date: Fri, 29 Apr 2011 16:43:14 +0200
Message-Id: <1304088194-6214-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding support to use set_ftrace_filter for multiple tracers

---
 arch/x86/kernel/ftrace.c |   24 +++--
 include/linux/ftrace.h   |    3 +
 kernel/trace/ftrace.c    |  269 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 219 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5a8e679..5fdb40e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -76,18 +76,20 @@ static int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr, int old)
 {
-	static union ftrace_code_union calc;
+	static union ftrace_code_union calc_new;
+	static union ftrace_code_union calc_old;
+	union ftrace_code_union *calc = old ? &calc_old : &calc_new;
 
-	calc.e8		= 0xe8;
-	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
+	calc->e8	= 0xe8;
+	calc->offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
 
 	/*
 	 * No locking needed, this must be called via kstop_machine
 	 * which in essence is like running on a uniprocessor machine.
 	 */
-	return calc.code;
+	return calc->code;
 }
 
 /*
@@ -304,9 +306,10 @@ int ftrace_make_nop(struct module *mod,
 	unsigned char *new, *old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_call_replace(ip, addr);
+	old = ftrace_call_replace(ip, addr, 1);
 	new = ftrace_nop_replace();
 
+	rec->addr = 0L;
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
@@ -315,9 +318,14 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned char *new, *old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_nop_replace();
-	new = ftrace_call_replace(ip, addr);
+	if (rec->addr)
+		old = ftrace_call_replace(ip, rec->addr, 1);
+	else
+		old = ftrace_nop_replace();
 
+	new = ftrace_call_replace(ip, addr, 0);
+
+	rec->addr = addr;
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b12f5df..9ce3484 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -164,6 +164,9 @@ struct dyn_ftrace {
 		unsigned long		flags;
 		struct dyn_ftrace	*newlist;
 	};
+	unsigned long			filter;
+	unsigned long			no_trace;
+	unsigned long			addr;
 	struct dyn_arch_ftrace		arch;
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b39dd52..bbffb05 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -80,6 +80,8 @@ static struct ftrace_ops *ftrace_tracers[FTRACE_TRACERS_MAX];
 static DECLARE_BITMAP(ftrace_tracers_bm, FTRACE_TRACERS_MAX);
 static int ftrace_tracers_cur = -1;
 
+static void __ftrace_tracer_clear(int id, int type);
+
 #define for_each_tracer(id, bm) \
 	for_each_set_bit(id, bm, FTRACE_TRACERS_MAX)
 
@@ -141,6 +143,8 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	BUG_ON(ops != ftrace_tracers[id]);
 	rcu_assign_pointer(ftrace_tracers[id], NULL);
 
+	__ftrace_tracer_clear(id, FTRACE_FL_FILTER|FTRACE_FL_NOTRACE);
+
 	if (ftrace_tracers_cur != id)
 		return 0;
 
@@ -175,6 +179,11 @@ static int ftrace_tracer_default(char *name)
 	return ret;
 }
 
+static int __ftrace_get_next_tracer(int idx)
+{
+	return find_next_bit(ftrace_tracers_bm, FTRACE_TRACERS_MAX, idx);
+}
+
 #ifdef CONFIG_FUNCTION_PROFILER
 struct ftrace_profile {
 	struct hlist_node		node;
@@ -808,7 +817,7 @@ enum {
 	FTRACE_STOP_FUNC_RET		= (1 << 4),
 };
 
-static int ftrace_filtered;
+static unsigned long ftrace_tracer_filtered;
 
 static struct dyn_ftrace *ftrace_new_addrs;
 
@@ -845,6 +854,20 @@ static struct dyn_ftrace *ftrace_free_records;
 		}				\
 	}
 
+static void __ftrace_tracer_clear(int id, int type)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	unsigned long mask = ~(1 << id);
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (type & FTRACE_FL_FILTER)
+			rec->filter  &= mask;
+		if (type & FTRACE_FL_NOTRACE)
+			rec->no_trace &= mask;
+	} while_for_each_ftrace_rec();
+}
+
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->freelist = ftrace_free_records;
@@ -956,31 +979,52 @@ int ftrace_text_reserved(void *start, void *end)
 	return 0;
 }
 
+unsigned long ftrace_tracer_flag_addr(struct dyn_ftrace *rec,
+				      unsigned long *ftrace_addr, int enable)
+{
+	unsigned long flag = 0L;
+	int id, mask = 0;
+
+	for_each_tracer(id, ftrace_tracers_bm) {
+#define SET(var) (var & (1 << id))
+		int ftrace_filtered = SET(ftrace_tracer_filtered);
+
+		/*
+		 * If this record is not to be traced or we want to disable it,
+		 * then disable it.
+		 *
+		 * If we want to enable it and filtering is off, then enable
+		 * it.
+		 *
+		 * If we want to enable it and filtering is on, enable it
+		 * only if it's filtered
+		 */
+		if (enable && !(SET(rec->no_trace)))
+			if (!ftrace_filtered || (SET(rec->filter)))
+				mask |= (1 << id);
+#undef SET
+	}
+
+	if (mask)
+		flag = FTRACE_FL_ENABLED;
+
+	*ftrace_addr = ftrace_arch_tracer_addr(mask);
+	return flag;
+}
 
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
+	unsigned long flag;
 	unsigned long ftrace_addr;
-	unsigned long flag = 0UL;
 
-	ftrace_addr = ftrace_arch_tracer_addr(FTRACE_CALLERS_MAX);
+	flag = ftrace_tracer_flag_addr(rec, &ftrace_addr, enable);
 
-	/*
-	 * If this record is not to be traced or we want to disable it,
-	 * then disable it.
-	 *
-	 * If we want to enable it and filtering is off, then enable it.
-	 *
-	 * If we want to enable it and filtering is on, enable it only if
-	 * it's filtered
-	 */
-	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
-		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
-			flag = FTRACE_FL_ENABLED;
-	}
+	BUG_ON(flag && !ftrace_addr);
 
 	/* If the state of this record hasn't changed, then do nothing */
-	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
+	if (((rec->flags & FTRACE_FL_ENABLED) == flag) &&
+	    (rec->addr == ftrace_addr))
 		return 0;
 
 	if (flag) {
@@ -989,7 +1033,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	}
 
 	rec->flags &= ~FTRACE_FL_ENABLED;
-	return ftrace_make_nop(NULL, rec, ftrace_addr);
+	return ftrace_make_nop(NULL, rec, rec->addr);
 }
 
 static void ftrace_replace_code(int enable)
@@ -1273,6 +1317,7 @@ struct ftrace_iterator {
 	struct trace_parser		parser;
 	int				hidx;
 	int				idx;
+	int				tracer;
 	unsigned			flags;
 };
 
@@ -1363,6 +1408,76 @@ t_hash_show(struct seq_file *m, struct ftrace_iterator *iter)
 	return 0;
 }
 
+static void reset_iter_read(struct ftrace_iterator *iter)
+{
+	iter->pos = 0;
+	iter->func_pos = 0;
+	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos);
+
+#define TRACER_ISSET(var) (var & (1 << iter->tracer))
+
+static struct dyn_ftrace*
+t_next_entry(struct ftrace_iterator *iter)
+{
+	struct dyn_ftrace *rec = NULL;
+
+	while(!rec) {
+		if (iter->idx >= iter->pg->index) {
+			if (!iter->pg->next)
+				break;
+
+			iter->pg = iter->pg->next;
+			iter->idx = 0;
+
+		} else {
+			rec = &iter->pg->records[iter->idx++];
+
+			if ((rec->flags & FTRACE_FL_FREE) ||
+
+			    (!(iter->flags & FTRACE_ITER_FAILURES) &&
+			     (rec->flags & FTRACE_FL_FAILED)) ||
+
+			    ((iter->flags & FTRACE_ITER_FAILURES) &&
+			     !(rec->flags & FTRACE_FL_FAILED)) ||
+
+			    ((iter->flags & FTRACE_ITER_FILTER) &&
+			     !(TRACER_ISSET(rec->filter))) ||
+
+			    ((iter->flags & FTRACE_ITER_NOTRACE) &&
+			     !(TRACER_ISSET(rec->no_trace)))) {
+				rec = NULL;
+			}
+		}
+	}
+
+	return rec;
+}
+
+static int t_next_new_tracer(struct ftrace_iterator *iter)
+{
+	int id = __ftrace_get_next_tracer(++iter->tracer);
+	if (id >= FTRACE_TRACERS_MAX)
+		return -1;
+
+	iter->tracer = id;
+	iter->pg = ftrace_pages_start;
+	iter->idx = 0;
+
+	if (iter->flags & FTRACE_ITER_FILTER) {
+		if (!TRACER_ISSET(ftrace_tracer_filtered))
+			iter->flags |= FTRACE_ITER_PRINTALL;
+		else
+			iter->flags &= ~FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
+	}
+
+	return id;
+}
+
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
@@ -1375,32 +1490,21 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	(*pos)++;
 	iter->pos = iter->func_pos = *pos;
 
+	if (iter->flags & FTRACE_ITER_PRINTALL) {
+		if (t_next_new_tracer(iter) > 0)
+			if (iter->flags & FTRACE_ITER_PRINTALL)
+				return iter;
+	}
+
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return t_hash_start(m, pos);
 
- retry:
-	if (iter->idx >= iter->pg->index) {
-		if (iter->pg->next) {
-			iter->pg = iter->pg->next;
-			iter->idx = 0;
-			goto retry;
-		}
-	} else {
-		rec = &iter->pg->records[iter->idx++];
-		if ((rec->flags & FTRACE_FL_FREE) ||
-
-		    (!(iter->flags & FTRACE_ITER_FAILURES) &&
-		     (rec->flags & FTRACE_FL_FAILED)) ||
-
-		    ((iter->flags & FTRACE_ITER_FAILURES) &&
-		     !(rec->flags & FTRACE_FL_FAILED)) ||
-
-		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER)) ||
-
-		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !(rec->flags & FTRACE_FL_NOTRACE))) {
-			rec = NULL;
+retry:
+	rec = t_next_entry(iter);
+	if (!rec) {
+		if (t_next_new_tracer(iter) > 0) {
+			if (iter->flags & FTRACE_ITER_PRINTALL)
+				return iter;
 			goto retry;
 		}
 	}
@@ -1409,17 +1513,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		return t_hash_start(m, pos);
 
 	iter->func = rec;
-
 	return iter;
 }
 
-static void reset_iter_read(struct ftrace_iterator *iter)
-{
-	iter->pos = 0;
-	iter->func_pos = 0;
-	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
-}
-
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
@@ -1430,15 +1526,17 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	/*
 	 * If an lseek was done, then reset and start from beginning.
 	 */
-	if (*pos < iter->pos)
+	if (*pos < iter->pos) {
 		reset_iter_read(iter);
+		iter->tracer = 0;
+	}
 
 	/*
 	 * For set_ftrace_filter reading, if we have the filter
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !ftrace_filtered) {
+	if (iter->flags & FTRACE_ITER_FILTER && !TRACER_ISSET(ftrace_tracer_filtered)) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -1472,6 +1570,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 
 	return iter;
 }
+#undef TRACER_ISSET
 
 static void t_stop(struct seq_file *m, void *p)
 {
@@ -1482,12 +1581,14 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec;
+	char *tracer = iter->tracer < FTRACE_TRACERS_MAX ?
+		       ftrace_tracers[iter->tracer]->name : NULL;
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_show(m, iter);
 
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
-		seq_printf(m, "#### all functions enabled ####\n");
+		seq_printf(m, "[%20s] #### all functions enabled ####\n", tracer);
 		return 0;
 	}
 
@@ -1496,7 +1597,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%ps\n", (void *)rec->ip);
+	seq_printf(m, "[%20s] %ps\n", tracer, (void *)rec->ip);
 
 	return 0;
 }
@@ -1552,21 +1653,15 @@ ftrace_failures_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-
 static void ftrace_filter_reset(int enable)
 {
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	mutex_lock(&ftrace_lock);
 	if (enable)
-		ftrace_filtered = 0;
-	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
-		rec->flags &= ~type;
-	} while_for_each_ftrace_rec();
+		ftrace_tracer_filtered &= ~(1 << ftrace_tracers_cur);
+
+	__ftrace_tracer_clear(ftrace_tracers_cur, type);
 	mutex_unlock(&ftrace_lock);
 }
 
@@ -1722,6 +1817,22 @@ ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 	return ftrace_match(str, regex, len, type);
 }
 
+#define TRACER_SET(enable) \
+do { \
+	if (enable) \
+		rec->filter   |= (1 << ftrace_tracers_cur); \
+	else \
+		rec->no_trace |= (1 << ftrace_tracers_cur); \
+} while (0)
+
+#define TRACER_UNSET(enable) \
+do { \
+	if (enable) \
+		rec->filter   &= ~(1 << ftrace_tracers_cur); \
+	else \
+		rec->no_trace &= ~(1 << ftrace_tracers_cur); \
+} while (0)
+
 static int ftrace_match_records(char *buff, int len, int enable)
 {
 	unsigned int search_len;
@@ -1739,16 +1850,23 @@ static int ftrace_match_records(char *buff, int len, int enable)
 	search_len = strlen(search);
 
 	mutex_lock(&ftrace_lock);
+
+	if (ftrace_tracers_cur < 0)
+		goto out_unlock;
+
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
 			continue;
 
 		if (ftrace_match_record(rec, search, search_len, type)) {
-			if (not)
+			if (not) {
 				rec->flags &= ~flag;
-			else
+				TRACER_UNSET(enable);
+			} else {
 				rec->flags |= flag;
+				TRACER_SET(enable);
+			}
 			found = 1;
 		}
 		/*
@@ -1756,10 +1874,12 @@ static int ftrace_match_records(char *buff, int len, int enable)
 		 * is filtered on.
 		 */
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
+			ftrace_tracer_filtered |= (1 << ftrace_tracers_cur);
+
 	} while_for_each_ftrace_rec();
-	mutex_unlock(&ftrace_lock);
 
+ out_unlock:
+	mutex_unlock(&ftrace_lock);
 	return found;
 }
 
@@ -1811,6 +1931,10 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 	}
 
 	mutex_lock(&ftrace_lock);
+
+	if (ftrace_tracers_cur < 0)
+		goto out_unlock;
+
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
@@ -1818,20 +1942,27 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 
 		if (ftrace_match_module_record(rec, mod,
 					       search, search_len, type)) {
-			if (not)
+			if (not) {
 				rec->flags &= ~flag;
-			else
+				TRACER_UNSET(enable);
+			} else {
 				rec->flags |= flag;
+				TRACER_SET(enable);
+			}
 			found = 1;
 		}
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
+			ftrace_tracer_filtered |= (1 << ftrace_tracers_cur);
 
 	} while_for_each_ftrace_rec();
+
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 
 	return found;
 }
+#undef TRACER_SET
+#undef TRACER_UNSET
 
 /*
  * We register the module command as a template to show others how
-- 
1.7.1

