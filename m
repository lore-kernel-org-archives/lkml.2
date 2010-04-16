Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0DPIoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 04:44:21 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51657 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0DPIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 04:44:18 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf lock: Fix state machine to recognize lock sequence
Date: Fri, 16 Apr 2010 17:44:06 +0900
Message-Id: <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4BC09546.5050309@dcl.info.waseda.ac.jp>
References: <4BC09546.5050309@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'm developing the model to recognize the correct sequence of lock events.
Previous state machine of perf lock was really broken.
This patch improves it a little.

This patch prepares the array of state machine represents lock sequence for each threads.
These state machines represent one of these sequence:

      1) acquire -> acquired -> release
      2) acquire -> contended -> acquired -> release
      3) acquire (w/ try) -> release
      4) acquire (w/ read) -> release

The case of 4) is a little special.
Double acquire of read lock is allowed, so state machine of sequence
counts read lock number, and permit double acquire and release.

But, things are not so simple. Something of my model is still wrong.
I counted the number of lock instances with bad sequence,
and ratio is like this (case of tracing whoami): bad:122, total:1956

There is another new bad thing.
The size of array of state machine is equal to max depth lockdep defines.
If perf lock record tries to record lock events of the programs with lots of
system call like "perf bench sched messaging", the array will be exhausted :(

I believe my new model can recognize many case,
but some of locks is at beyond of my understanding...

I made too long silence, so I thought that this is time to dump my progress.
Could you make testing branch on your tip tree?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-lock.c |  399 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 330 insertions(+), 69 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6c38e4f..f277856 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -23,6 +23,8 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 
+static struct perf_session *session;
+
 /* based on kernel/lockdep.c */
 #define LOCKHASH_BITS		12
 #define LOCKHASH_SIZE		(1UL << LOCKHASH_BITS)
@@ -32,9 +34,6 @@ static struct list_head lockhash_table[LOCKHASH_SIZE];
 #define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
 #define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
 
-#define LOCK_STATE_UNLOCKED	0	       /* initial state */
-#define LOCK_STATE_LOCKED	1
-
 struct lock_stat {
 	struct list_head	hash_entry;
 	struct rb_node		rb;		/* used for sorting */
@@ -47,20 +46,151 @@ struct lock_stat {
 	void			*addr;		/* address of lockdep_map, used as ID */
 	char			*name;		/* for strcpy(), we cannot use const */
 
-	int			state;
-	u64			prev_event_time; /* timestamp of previous event */
-
-	unsigned int		nr_acquired;
 	unsigned int		nr_acquire;
+	unsigned int		nr_acquired;
 	unsigned int		nr_contended;
 	unsigned int		nr_release;
 
+	unsigned int		nr_readlock;
+	unsigned int		nr_trylock;
 	/* these times are in nano sec. */
 	u64			wait_time_total;
 	u64			wait_time_min;
 	u64			wait_time_max;
+
+	int			discard; /* flag of blacklist */
+};
+
+/*
+ * States of lock_seq_stat
+ *
+ * UNINITED is required for detecting first event of acquire.
+ * As the nature of lock events, there is no guarantee
+ * that the first event for the locks are acquire,
+ * it can be acquired, contended or release.
+ */
+#define SEQ_STATE_UNINITED      0	       /* initial state */
+#define SEQ_STATE_RELEASED	1
+#define SEQ_STATE_ACQUIRING	2
+#define SEQ_STATE_ACQUIRED	3
+#define SEQ_STATE_CONTENDED	4
+
+/*
+ * MAX_LOCK_DEPTH
+ * Imported from include/linux/sched.h.
+ * Should this be synchronized?
+ */
+#define MAX_LOCK_DEPTH 48
+
+/*
+ * struct lock_seq_stat:
+ * Place to put on state of one lock sequence
+ * 1) acquire -> acquired -> release
+ * 2) acquire -> contended -> acquired -> release
+ * 3) acquire (with read or try) -> release
+ * 4) Are there other patterns?
+ */
+struct lock_seq_stat {
+	int			state;
+	u64			prev_event_time;
+	void                    *addr_of_lock;
+
+	int                     read_count;
 };
 
+struct thread_stat {
+	struct rb_node		rb;
+
+	pid_t                   pid;
+	int                     seq_index_cache;
+	struct lock_seq_stat    seq_stack[MAX_LOCK_DEPTH];
+};
+
+static struct rb_root		thread_stats;
+
+static struct thread_stat *thread_stat_find(pid_t pid)
+{
+	struct rb_node *node;
+	struct thread_stat *st;
+
+	node = thread_stats.rb_node;
+	while (node) {
+		st = container_of(node, struct thread_stat, rb);
+		if (st->pid == pid)
+			return st;
+		else if (pid < st->pid)
+			node = node->rb_left;
+		else
+			node = node->rb_right;
+	}
+
+	return NULL;
+}
+
+static void thread_stat_insert(struct thread_stat *new)
+{
+	struct rb_node **rb = &thread_stats.rb_node;
+	struct rb_node *parent = NULL;
+	struct thread_stat *p;
+
+	while (*rb) {
+		p = container_of(*rb, struct thread_stat, rb);
+		parent = *rb;
+
+		if (new->pid < p->pid)
+			rb = &(*rb)->rb_left;
+		else if (new->pid > p->pid)
+			rb = &(*rb)->rb_right;
+		else
+			BUG_ON("inserting invalid thread_stat\n");
+	}
+
+	rb_link_node(&new->rb, parent, rb);
+	rb_insert_color(&new->rb, &thread_stats);
+}
+
+static struct thread_stat *thread_stat_findnew_after_first(pid_t pid)
+{
+	int i;
+	struct thread_stat *st;
+
+	st = thread_stat_find(pid);
+	if (st)
+		return st;
+
+	st = zalloc(sizeof(struct thread_stat));
+	if (!st)
+		die("memory allocation failed\n");
+
+	st->pid = pid;
+	for (i = 0; i < MAX_LOCK_DEPTH; i++)
+		st->seq_stack[i].state = SEQ_STATE_UNINITED;
+
+	thread_stat_insert(st);
+
+	return st;
+}
+
+static struct thread_stat *thread_stat_findnew_first(pid_t pid);
+static struct thread_stat *(*thread_stat_findnew)(pid_t pid) =
+	thread_stat_findnew_first;
+
+static struct thread_stat *thread_stat_findnew_first(pid_t pid)
+{
+	struct thread_stat *st;
+
+	st = zalloc(sizeof(struct thread_stat));
+	if (!st)
+		die("memory allocation failed\n");
+	st->pid = pid;
+
+	rb_link_node(&st->rb, NULL, &thread_stats.rb_node);
+	rb_insert_color(&st->rb, &thread_stats);
+
+	thread_stat_findnew = thread_stat_findnew_after_first;
+	return st;
+}
+
 /* build simple key function one is bigger than two */
 #define SINGLE_KEY(member)						\
 	static int lock_stat_key_ ## member(struct lock_stat *one,	\
@@ -175,8 +305,6 @@ static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
 		goto alloc_failed;
 	strcpy(new->name, name);
 
-	/* LOCK_STATE_UNLOCKED == 0 isn't guaranteed forever */
-	new->state = LOCK_STATE_UNLOCKED;
 	new->wait_time_min = ULLONG_MAX;
 
 	list_add(&new->hash_entry, entry);
@@ -198,6 +326,7 @@ struct raw_event_sample {
 struct trace_acquire_event {
 	void			*addr;
 	const char		*name;
+	int			flag;
 };
 
 struct trace_acquired_event {
@@ -241,120 +370,245 @@ struct trace_lock_handler {
 			      struct thread *thread);
 };
 
+static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
+{
+	int i, min_unused;
+	struct lock_seq_stat *seq;
+
+	seq = &ts->seq_stack[ts->seq_index_cache];
+
+	if (seq->addr_of_lock != addr) {
+		min_unused = -1;
+		for (i = 0; i < MAX_LOCK_DEPTH; i++) {
+			seq = &ts->seq_stack[i];
+			if (min_unused < 0 && !seq->addr_of_lock)
+				min_unused = i;
+			if (seq->addr_of_lock == addr) {
+				ts->seq_index_cache = i;
+				return seq;
+			}
+		}
+
+		if (min_unused == -1) {
+			for (i = 0; i < MAX_LOCK_DEPTH; i++) {
+				struct lock_stat *l;
+
+				l = lock_stat_findnew(
+					ts->seq_stack[i].addr_of_lock, NULL);
+				printf("%s:%p\n", l->name, l->addr);
+			}
+			BUG_ON("seq_stack overflowed, "
+			       "please expand MAX_LOCK_DEPTH\n");
+		}
+
+		seq = &ts->seq_stack[min_unused];
+		seq->addr_of_lock = addr;
+		ts->seq_index_cache = min_unused;
+	}
+
+	return seq;
+}
+
 static void
 report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			struct event *__event __used,
 			int cpu __used,
-			u64 timestamp,
+			u64 timestamp __used,
 			struct thread *thread __used)
 {
-	struct lock_stat *st;
+	struct lock_stat *ls;
+	struct thread_stat *ts;
+	struct lock_seq_stat *seq;
 
-	st = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	ls = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	if (ls->discard)
+		return;
 
-	switch (st->state) {
-	case LOCK_STATE_UNLOCKED:
+	ts = thread_stat_findnew(thread->pid);
+	seq = get_seq(ts, acquire_event->addr);
+
+	switch (seq->state) {
+	case SEQ_STATE_UNINITED:
+	case SEQ_STATE_RELEASED:
+		if (!acquire_event->flag) {
+			seq->state = SEQ_STATE_ACQUIRING;
+		} else {
+			if (acquire_event->flag & 1)
+				ls->nr_trylock++;
+			if (acquire_event->flag & 2)
+				ls->nr_readlock++;
+			seq->state = SEQ_STATE_ACQUIRED;
+		}
+		break;
+	case SEQ_STATE_ACQUIRED:
+		if (acquire_event->flag & 2)
+			seq->read_count++;
+		else
+			goto broken;
 		break;
-	case LOCK_STATE_LOCKED:
+	case SEQ_STATE_ACQUIRING:
+	case SEQ_STATE_CONTENDED:
+broken:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		seq->addr_of_lock = NULL;
+		seq->state = SEQ_STATE_UNINITED;
 		break;
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
-	st->prev_event_time = timestamp;
+	ls->nr_acquire++;
+	seq->prev_event_time = timestamp;
 }
 
 static void
 report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 			 struct event *__event __used,
 			 int cpu __used,
-			 u64 timestamp,
+			 u64 timestamp __used,
 			 struct thread *thread __used)
 {
-	struct lock_stat *st;
+	struct lock_stat *ls;
+	struct thread_stat *ts;
+	struct lock_seq_stat *seq;
+	u64 contended_term;
+
+	ls = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	if (ls->discard)
+		return;
 
-	st = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	ts = thread_stat_findnew(thread->pid);
+	seq = get_seq(ts, acquired_event->addr);
 
-	switch (st->state) {
-	case LOCK_STATE_UNLOCKED:
-		st->state = LOCK_STATE_LOCKED;
-		st->nr_acquired++;
+	switch (seq->state) {
+	case SEQ_STATE_UNINITED:
+		/* orphan event, do nothing */
+		return;
+	case SEQ_STATE_ACQUIRING:
+		break;
+	case SEQ_STATE_CONTENDED:
+		contended_term = timestamp - seq->prev_event_time;
+		ls->wait_time_total += contended_term;
+
+		if (contended_term < ls->wait_time_min)
+			ls->wait_time_min = contended_term;
+		else if (ls->wait_time_max < contended_term)
+			ls->wait_time_max = contended_term;
 		break;
-	case LOCK_STATE_LOCKED:
+	case SEQ_STATE_RELEASED:
+	case SEQ_STATE_ACQUIRED:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		seq->addr_of_lock = NULL;
+		seq->state = SEQ_STATE_UNINITED;
 		break;
+
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
-	st->prev_event_time = timestamp;
+	seq->state = SEQ_STATE_ACQUIRED;
+	ls->nr_acquired++;
+	seq->prev_event_time = timestamp;
 }
 
 static void
 report_lock_contended_event(struct trace_contended_event *contended_event,
 			  struct event *__event __used,
 			  int cpu __used,
-			  u64 timestamp,
+			  u64 timestamp __used,
 			  struct thread *thread __used)
 {
-	struct lock_stat *st;
+	struct lock_stat *ls;
+	struct thread_stat *ts;
+	struct lock_seq_stat *seq;
+
+	ls = lock_stat_findnew(contended_event->addr, contended_event->name);
+	if (ls->discard)
+		return;
 
-	st = lock_stat_findnew(contended_event->addr, contended_event->name);
+	ts = thread_stat_findnew(thread->pid);
+	seq = get_seq(ts, contended_event->addr);
 
-	switch (st->state) {
-	case LOCK_STATE_UNLOCKED:
+	switch (seq->state) {
+	case SEQ_STATE_UNINITED:
+		/* orphan event, do nothing */
+		return;
+	case SEQ_STATE_ACQUIRING:
 		break;
-	case LOCK_STATE_LOCKED:
-		st->nr_contended++;
+	case SEQ_STATE_RELEASED:
+	case SEQ_STATE_ACQUIRED:
+	case SEQ_STATE_CONTENDED:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		seq->addr_of_lock = NULL;
+		seq->state = SEQ_STATE_UNINITED;
 		break;
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
-	st->prev_event_time = timestamp;
+	seq->state = SEQ_STATE_CONTENDED;
+	ls->nr_contended++;
+	seq->prev_event_time = timestamp;
 }
 
 static void
 report_lock_release_event(struct trace_release_event *release_event,
 			struct event *__event __used,
 			int cpu __used,
-			u64 timestamp,
+			u64 timestamp __used,
 			struct thread *thread __used)
 {
-	struct lock_stat *st;
-	u64 hold_time;
+	struct lock_stat *ls;
+	struct thread_stat *ts;
+	struct lock_seq_stat *seq;
 
-	st = lock_stat_findnew(release_event->addr, release_event->name);
+	ls = lock_stat_findnew(release_event->addr, release_event->name);
+	if (ls->discard)
+		return;
 
-	switch (st->state) {
-	case LOCK_STATE_UNLOCKED:
-		break;
-	case LOCK_STATE_LOCKED:
-		st->state = LOCK_STATE_UNLOCKED;
-		hold_time = timestamp - st->prev_event_time;
+	ts = thread_stat_findnew(thread->pid);
+	seq = get_seq(ts, release_event->addr);
 
-		if (timestamp < st->prev_event_time) {
-			/* terribly, this can happen... */
-			goto end;
+	switch (seq->state) {
+	case SEQ_STATE_UNINITED:
+		goto end;
+		break;
+	case SEQ_STATE_ACQUIRED:
+		/*
+		 * FIXME: for this case, lock_release()
+		 * should have flag to represent read unlock
+		 */
+		if (seq->read_count > 0) {
+			if (--seq->read_count) {
+				ls->nr_release++;
+				return;
+			}
 		}
-
-		if (st->wait_time_min > hold_time)
-			st->wait_time_min = hold_time;
-		if (st->wait_time_max < hold_time)
-			st->wait_time_max = hold_time;
-		st->wait_time_total += hold_time;
-
-		st->nr_release++;
+		break;
+	case SEQ_STATE_ACQUIRING:
+	case SEQ_STATE_CONTENDED:
+	case SEQ_STATE_RELEASED:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		seq->addr_of_lock = NULL;
+		seq->state = SEQ_STATE_UNINITED;
 		break;
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
+	ls->nr_release++;
 end:
-	st->prev_event_time = timestamp;
+	seq->addr_of_lock = NULL;
+	seq->state = SEQ_STATE_UNINITED;
+	ts->seq_index_cache = 0;
 }
 
 /* lock oriented handlers */
@@ -381,6 +635,7 @@ process_lock_acquire_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
 	acquire_event.name = (char *)raw_field_ptr(event, "name", data);
+	acquire_event.flag = (int)raw_field_value(event, "flag", data);
 
 	if (trace_handler->acquire_event)
 		trace_handler->acquire_event(&acquire_event, event, cpu, timestamp, thread);
@@ -441,8 +696,8 @@ process_lock_release_event(void *data,
 }
 
 static void
-process_raw_event(void *data, int cpu,
-		  u64 timestamp, struct thread *thread)
+process_raw_event(void *data, int cpu __used,
+		  u64 timestamp __used, struct thread *thread __used)
 {
 	struct event *event;
 	int type;
@@ -604,14 +859,14 @@ static void queue_raw_event(void *data, int raw_size, int cpu,
 	}
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct perf_session *s)
 {
 	struct thread *thread;
 	struct sample_data data;
 
 	bzero(&data, sizeof(struct sample_data));
-	event__parse_sample(event, session->sample_type, &data);
-	thread = perf_session__findnew(session, data.pid);
+	event__parse_sample(event, s->sample_type, &data);
+	thread = perf_session__findnew(s, data.pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -634,8 +889,8 @@ static void print_result(void)
 {
 	struct lock_stat *st;
 	char cut_name[20];
+	int bad, total;
 
-	printf("%18s ", "ID");
 	printf("%20s ", "Name");
 	printf("%10s ", "acquired");
 	printf("%10s ", "contended");
@@ -646,11 +901,15 @@ static void print_result(void)
 
 	printf("\n\n");
 
+	bad = total = 0;
 	while ((st = pop_from_result())) {
+		total++;
+		if (st->discard) {
+			bad++;
+			continue;
+		}
 		bzero(cut_name, 20);
 
-		printf("%p ", st->addr);
-
 		if (strlen(st->name) < 16) {
 			/* output raw name */
 			printf("%20s ", st->name);
@@ -673,6 +932,10 @@ static void print_result(void)
 		       0 : st->wait_time_min);
 		printf("\n");
 	}
+
+	/* Output for debug */
+	printf("bad:%d, total:%d\n", bad, total);
+	printf("bad rate:%f\n", (double)(bad / total));
 }
 
 static void dump_map(void)
@@ -692,8 +955,6 @@ static struct perf_event_ops eops = {
 	.comm			= event__process_comm,
 };
 
-static struct perf_session *session;
-
 static int read_events(void)
 {
 	session = perf_session__new(input_name, O_RDONLY, 0);
-- 
1.6.5.2

