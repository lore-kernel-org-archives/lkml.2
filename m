Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0HQX0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:26:01 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59280 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0HQXYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:24:15 -0400
Message-Id: <20100817232151.305981768@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        William Lee Irwin III <wli@holomorphy.com>
Subject: [RFC PATCH 05/20] Poll : add poll_wait_set_exclusive
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=poll-wait-exclusive.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executive summary:

poll_wait_set_exclusive : set poll wait queue to exclusive

Sets up a poll wait queue to use exclusive wakeups. This is useful to
wake up only one waiter at each wakeup. Used to work-around "thundering herd"
problem.

Detail:

* Problem description :

In the ring buffer poll() implementation, a typical multithreaded user-space
buffer reader polls all per-cpu buffer descriptors for data.  The number of
reader threads can be user-defined; the motivation for permitting this is that
there are typical workloads where a single CPU is producing most of the tracing
data and all other CPUs are idle, available to consume data. It therefore makes
sense not to tie those threads to specific buffers. However, when the number of
threads grows, we face a "thundering herd" problem where many threads can be
woken up and put back to sleep, leaving only a single thread doing useful work.

* Solution :

Introduce a poll_wait_set_exclusive() primitive to poll API, so the code which
implements the pollfd operation can specify that only a single waiter must be
woken up.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/select.c          |   41 ++++++++++++++++++++++++++++++++++++++---
 include/linux/poll.h |    2 ++
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux.trees.git/fs/select.c
===================================================================
--- linux.trees.git.orig/fs/select.c	2010-07-09 15:59:00.000000000 -0400
+++ linux.trees.git/fs/select.c	2010-07-09 16:03:24.000000000 -0400
@@ -112,6 +112,9 @@ struct poll_table_page {
  */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 		       poll_table *p);
+static void __pollwait_exclusive(struct file *filp,
+				 wait_queue_head_t *wait_address,
+				 poll_table *p);
 
 void poll_initwait(struct poll_wqueues *pwq)
 {
@@ -152,6 +155,20 @@ void poll_freewait(struct poll_wqueues *
 }
 EXPORT_SYMBOL(poll_freewait);
 
+/**
+ * poll_wait_set_exclusive - set poll wait queue to exclusive
+ *
+ * Sets up a poll wait queue to use exclusive wakeups. This is useful to
+ * wake up only one waiter at each wakeup. Used to work-around "thundering herd"
+ * problem.
+ */
+void poll_wait_set_exclusive(poll_table *p)
+{
+	if (p)
+		init_poll_funcptr(p, __pollwait_exclusive);
+}
+EXPORT_SYMBOL(poll_wait_set_exclusive);
+
 static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 {
 	struct poll_table_page *table = p->table;
@@ -213,8 +230,10 @@ static int pollwake(wait_queue_t *wait,
 }
 
 /* Add a new entry */
-static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+static void __pollwait_common(struct file *filp,
+			      wait_queue_head_t *wait_address,
+			      poll_table *p,
+			      int exclusive)
 {
 	struct poll_wqueues *pwq = container_of(p, struct poll_wqueues, pt);
 	struct poll_table_entry *entry = poll_get_entry(pwq);
@@ -226,7 +245,23 @@ static void __pollwait(struct file *filp
 	entry->key = p->key;
 	init_waitqueue_func_entry(&entry->wait, pollwake);
 	entry->wait.private = pwq;
-	add_wait_queue(wait_address, &entry->wait);
+	if (!exclusive)
+		add_wait_queue(wait_address, &entry->wait);
+	else
+		add_wait_queue_exclusive(wait_address, &entry->wait);
+}
+
+static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
+				poll_table *p)
+{
+	__pollwait_common(filp, wait_address, p, 0);
+}
+
+static void __pollwait_exclusive(struct file *filp,
+				 wait_queue_head_t *wait_address,
+				 poll_table *p)
+{
+	__pollwait_common(filp, wait_address, p, 1);
 }
 
 int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
Index: linux.trees.git/include/linux/poll.h
===================================================================
--- linux.trees.git.orig/include/linux/poll.h	2010-07-09 15:59:00.000000000 -0400
+++ linux.trees.git/include/linux/poll.h	2010-07-09 16:03:24.000000000 -0400
@@ -79,6 +79,8 @@ static inline int poll_schedule(struct p
 	return poll_schedule_timeout(pwq, state, NULL, 0);
 }
 
+extern void poll_wait_set_exclusive(poll_table *p);
+
 /*
  * Scaleable version of the fd_set.
  */

