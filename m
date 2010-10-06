Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab0JFR4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:56:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37116 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753552Ab0JFR4k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:56:40 -0400
Date: Wed, 6 Oct 2010 13:56:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC PATCH] poll(): add poll_wait_set_exclusive()
Message-ID: <20101006175635.GA21652@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:49:09 up 13 days, 21:51,  6 users,  load average: 0.11, 0.13,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executive summary:

Addition of the new internal API:

poll_wait_set_exclusive() : set poll wait queue to exclusive

Sets up a poll wait queue to use exclusive wakeups. This is useful to
wake up only one waiter at each wakeup. Used to work-around "thundering herd"
problem.

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

To Andi's question:

> How does that work?

I let the ring buffer poll file operation calls a new:

poll_wait_set_exclusive(wait);

Which makes sure that when we have multiple threads waiting on the same file
descriptor (which represents a ring buffer), only one of the threads is woken
up.

> Wouldn't that break poll semantics?

The way I currently do it, yes, but we might be able to do better by tweaking
the poll wakeup chain.

Basically, what I need is that a poll wakeup triggers an exclusive synchronous
wakeup, and then re-checks the wakeup condition. AFAIU, the usual poll semantics
seems to be that all poll()/epoll() should be notified of state changes on all
examined file descriptors. But wether we should do the wakeup first, wait for
the woken up thread to run (possibly consume the data), and then only after that
check if we must continue going through the wakeup chain is left as a grey zone
(ref.  http://www.opengroup.org/onlinepubs/009695399/functions/poll.html).


> If not it sounds like a general improvement.
>
> I assume epoll already does it?

Nope, if I believe epoll(7):


"      Q2  Can two epoll instances wait for the same file descriptor?  If  so,
           are events reported to both epoll file descriptors?

       A2  Yes,  and  events would be reported to both.  However, careful pro‐


So for now, I still propose the less globally intrusive approach, with
poll_wait_set_exclusive(). Maybe if we figure out that changing the poll wakeup
chains behavior is appropriate, we can proceed differently.

This patch is based on top of:

  git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git
  branch: tip-pull-queue

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>
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

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
