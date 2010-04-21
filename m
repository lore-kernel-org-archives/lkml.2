Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0DUMYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:24:10 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60832 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0DUMYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:24:07 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] perf lock: Fix state machine to recognize lock sequence
Date: Wed, 21 Apr 2010 21:23:54 +0900
Message-Id: <1271852634-9351-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20100421012651.GC7120@nowhere>
References: <20100421012651.GC7120@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I'm sending this v2 patch.
It seems that your tree doesn't contain previous one.
So could you queue this new one?

I'm developing the model to recognize the correct sequence of lock events.
Previous state machine of perf lock was really broken.
This patch improves it a little.

This patch prepares the list of state machine represents lock sequence for each threads.
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
and ratio is like this (case of tracing whoami): bad:233, total:2279

version 2:
 * threads are now identified with tid, not pid
 * prepared SEQ_STATE_READ_ACQUIRED for read lock.
 * bunch of struct lock_seq_stat is now linked list
 * debug information enhanced (this have to be removed someday)
   e.g.
     | === output for debug===
     |
     | bad:233, total:2279
     | bad rate:0.000000
     | histogram of events caused bad sequence
     |     acquire: 165
     |    acquired: 0
     |   contended: 0
     |     release: 68

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 tools/perf/builtin-lock.c |  410 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 342 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6c38e4f..9475208 100644
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
+#define SEQ_STATE_READ_ACQUIRED	4
+#define SEQ_STATE_CONTENDED	5
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
+	struct list_head        list;
+	int			state;
+	u64			prev_event_time;
+	void                    *addr;
+
+	int                     read_count;
 };
 
+struct thread_stat {
+	struct rb_node		rb;
+
+	u32                     tid;
+	struct list_head        seq_list;
+};
+
+static struct rb_root		thread_stats;
+
+static struct thread_stat *thread_stat_find(u32 tid)
+{
+	struct rb_node *node;
+	struct thread_stat *st;
+
+	node = thread_stats.rb_node;
+	while (node) {
+		st = container_of(node, struct thread_stat, rb);
+		if (st->tid == tid)
+			return st;
+		else if (tid < st->tid)
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
+		if (new->tid < p->tid)
+			rb = &(*rb)->rb_left;
+		else if (new->tid > p->tid)
+			rb = &(*rb)->rb_right;
+		else
+			BUG_ON("inserting invalid thread_stat\n");
+	}
+
+	rb_link_node(&new->rb, parent, rb);
+	rb_insert_color(&new->rb, &thread_stats);
+}
+
+static struct thread_stat *thread_stat_findnew_after_first(u32 tid)
+{
+	struct thread_stat *st;
+
+	st = thread_stat_find(tid);
+	if (st)
+		return st;
+
+	st = zalloc(sizeof(struct thread_stat));
+	if (!st)
+		die("memory allocation failed\n");
+
+	st->tid = tid;
+	INIT_LIST_HEAD(&st->seq_list);
+
+	thread_stat_insert(st);
+
+	return st;
+}
+
+static struct thread_stat *thread_stat_findnew_first(u32 tid);
+static struct thread_stat *(*thread_stat_findnew)(u32 tid) =
+	thread_stat_findnew_first;
+
+static struct thread_stat *thread_stat_findnew_first(u32 tid)
+{
+	struct thread_stat *st;
+
+	st = zalloc(sizeof(struct thread_stat));
+	if (!st)
+		die("memory allocation failed\n");
+	st->tid = tid;
+	INIT_LIST_HEAD(&st->seq_list);
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
@@ -241,120 +370,246 @@ struct trace_lock_handler {
 			      struct thread *thread);
 };
 
+static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
+{
+	struct lock_seq_stat *seq;
+
+	list_for_each_entry(seq, &ts->seq_list, list) {
+		if (seq->addr == addr)
+			return seq;
+	}
+
+	seq = zalloc(sizeof(struct lock_seq_stat));
+	if (!seq)
+		die("Not enough memory\n");
+	seq->state = SEQ_STATE_UNINITED;
+	seq->addr = addr;
+
+	list_add(&seq->list, &ts->seq_list);
+	return seq;
+}
+
+static int bad_hist[4];
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
+
+	ls = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	if (ls->discard)
+		return;
 
-	st = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	ts = thread_stat_findnew(thread->pid);
+	seq = get_seq(ts, acquire_event->addr);
 
-	switch (st->state) {
-	case LOCK_STATE_UNLOCKED:
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
+			seq->state = SEQ_STATE_READ_ACQUIRED;
+			seq->read_count = 1;
+			ls->nr_acquired++;
+		}
+		break;
+	case SEQ_STATE_READ_ACQUIRED:
+		if (acquire_event->flag & 2) {
+			seq->read_count++;
+			ls->nr_acquired++;
+			goto end;
+		} else {
+			goto broken;
+		}
 		break;
-	case LOCK_STATE_LOCKED:
+	case SEQ_STATE_ACQUIRED:
+	case SEQ_STATE_ACQUIRING:
+	case SEQ_STATE_CONTENDED:
+broken:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		bad_hist[0]++;
+		list_del(&seq->list);
+		free(seq);
+		goto end;
 		break;
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
-	st->prev_event_time = timestamp;
+	ls->nr_acquire++;
+	seq->prev_event_time = timestamp;
+end:
+	return;
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
 
-	st = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	ls = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	if (ls->discard)
+		return;
+
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
 		break;
-	case LOCK_STATE_LOCKED:
+	case SEQ_STATE_CONTENDED:
+		contended_term = timestamp - seq->prev_event_time;
+		ls->wait_time_total += contended_term;
+
+		if (contended_term < ls->wait_time_min)
+			ls->wait_time_min = contended_term;
+		else if (ls->wait_time_max < contended_term)
+			ls->wait_time_max = contended_term;
 		break;
+	case SEQ_STATE_RELEASED:
+	case SEQ_STATE_ACQUIRED:
+	case SEQ_STATE_READ_ACQUIRED:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		bad_hist[1]++;
+		list_del(&seq->list);
+		free(seq);
+		goto end;
+		break;
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
+end:
+	return;
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
+	case SEQ_STATE_READ_ACQUIRED:
+	case SEQ_STATE_CONTENDED:
+		/* broken lock sequence, discard it */
+		ls->discard = 1;
+		bad_hist[2]++;
+		list_del(&seq->list);
+		free(seq);
+		goto end;
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
+end:
+	return;
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
+	switch (seq->state) {
+	case SEQ_STATE_UNINITED:
+		goto end;
+		break;
+	case SEQ_STATE_ACQUIRED:
+		break;
+	case SEQ_STATE_READ_ACQUIRED:
+		seq->read_count--;
+		BUG_ON(seq->read_count < 0);
+		if (!seq->read_count) {
+			ls->nr_release++;
 			goto end;
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
+		bad_hist[3]++;
+		goto free_seq;
 		break;
 	default:
-		BUG_ON(1);
+		BUG_ON("Unknown state of lock sequence found!\n");
 		break;
 	}
 
+	ls->nr_release++;
+free_seq:
+	list_del(&seq->list);
+	free(seq);
 end:
-	st->prev_event_time = timestamp;
+	return;
 }
 
 /* lock oriented handlers */
@@ -381,6 +636,7 @@ process_lock_acquire_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
 	acquire_event.name = (char *)raw_field_ptr(event, "name", data);
+	acquire_event.flag = (int)raw_field_value(event, "flag", data);
 
 	if (trace_handler->acquire_event)
 		trace_handler->acquire_event(&acquire_event, event, cpu, timestamp, thread);
@@ -441,8 +697,8 @@ process_lock_release_event(void *data,
 }
 
 static void
-process_raw_event(void *data, int cpu,
-		  u64 timestamp, struct thread *thread)
+process_raw_event(void *data, int cpu __used,
+		  u64 timestamp __used, struct thread *thread __used)
 {
 	struct event *event;
 	int type;
@@ -604,14 +860,15 @@ static void queue_raw_event(void *data, int raw_size, int cpu,
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
+	/* CAUTION: using tid as thread.pid */
+	thread = perf_session__findnew(s, data.tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -634,8 +891,8 @@ static void print_result(void)
 {
 	struct lock_stat *st;
 	char cut_name[20];
+	int bad, total;
 
-	printf("%18s ", "ID");
 	printf("%20s ", "Name");
 	printf("%10s ", "acquired");
 	printf("%10s ", "contended");
@@ -646,11 +903,15 @@ static void print_result(void)
 
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
@@ -673,6 +934,21 @@ static void print_result(void)
 		       0 : st->wait_time_min);
 		printf("\n");
 	}
+
+	{
+		/* Output for debug, this have to be removed */
+		int i;
+		const char *name[4] =
+			{ "acquire", "acquired", "contended", "release" };
+
+		printf("\n=== output for debug===\n\n");
+		printf("bad:%d, total:%d\n", bad, total);
+		printf("bad rate:%f\n", (double)(bad / total));
+
+		printf("histogram of events caused bad sequence\n");
+		for (i = 0; i < 4; i++)
+			printf(" %10s: %d\n", name[i], bad_hist[i]);
+	}
 }
 
 static void dump_map(void)
@@ -692,8 +968,6 @@ static struct perf_event_ops eops = {
 	.comm			= event__process_comm,
 };
 
-static struct perf_session *session;
-
 static int read_events(void)
 {
 	session = perf_session__new(input_name, O_RDONLY, 0);
-- 
1.6.5.2

