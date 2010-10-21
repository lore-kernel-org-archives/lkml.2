Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0JUOxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:53:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab0JUOxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:53:07 -0400
Date: Thu, 21 Oct 2010 14:52:45 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <tip-f4bc6bb2d562703eafc895c37e7be20906de139d@git.kernel.org>
Git-Commit-ID: f4bc6bb2d562703eafc895c37e7be20906de139d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Oct 2010 14:52:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4bc6bb2d562703eafc895c37e7be20906de139d
Gitweb:     http://git.kernel.org/tip/f4bc6bb2d562703eafc895c37e7be20906de139d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 19 Oct 2010 15:00:13 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 21 Oct 2010 16:50:29 +0200

tracing: Cleanup the convoluted softirq tracepoints

With the addition of trace_softirq_raise() the softirq tracepoint got
even more convoluted. Why the tracepoints take two pointers to assign
an integer is beyond my comprehension.

But adding an extra case which treats the first pointer as an unsigned
long when the second pointer is NULL including the back and forth
type casting is just horrible.

Convert the softirq tracepoints to take a single unsigned int argument
for the softirq vector number and fix the call sites.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: mathieu.desnoyers@efficios.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
 include/linux/interrupt.h  |    2 +-
 include/trace/events/irq.h |   54 ++++++++++++++++---------------------------
 kernel/softirq.c           |   16 +++++++-----
 3 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 531495d..0ac1949 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -410,7 +410,7 @@ extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
 static inline void __raise_softirq_irqoff(unsigned int nr)
 {
-	trace_softirq_raise((struct softirq_action *)(unsigned long)nr, NULL);
+	trace_softirq_raise(nr);
 	or_softirq_pending(1UL << nr);
 }
 
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 6fa7cba..1c09820 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -86,76 +86,62 @@ TRACE_EVENT(irq_handler_exit,
 
 DECLARE_EVENT_CLASS(softirq,
 
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_PROTO(unsigned int vec_nr),
 
-	TP_ARGS(h, vec),
+	TP_ARGS(vec_nr),
 
 	TP_STRUCT__entry(
-		__field(	int,	vec			)
+		__field(	unsigned int,	vec	)
 	),
 
 	TP_fast_assign(
-		if (vec)
-			__entry->vec = (int)(h - vec);
-		else
-			__entry->vec = (int)(long)h;
+		__entry->vec = vec_nr;
 	),
 
-	TP_printk("vec=%d [action=%s]", __entry->vec,
+	TP_printk("vec=%u [action=%s]", __entry->vec,
 		  show_softirq_name(__entry->vec))
 );
 
 /**
  * softirq_entry - called immediately before the softirq handler
- * @h: pointer to struct softirq_action
- * @vec: pointer to first struct softirq_action in softirq_vec array
+ * @vec_nr:  softirq vector number
  *
- * The @h parameter, contains a pointer to the struct softirq_action
- * which has a pointer to the action handler that is called. By subtracting
- * the @vec pointer from the @h pointer, we can determine the softirq
- * number. Also, when used in combination with the softirq_exit tracepoint
- * we can determine the softirq latency.
+ * When used in combination with the softirq_exit tracepoint
+ * we can determine the softirq handler runtine.
  */
 DEFINE_EVENT(softirq, softirq_entry,
 
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_PROTO(unsigned int vec_nr),
 
-	TP_ARGS(h, vec)
+	TP_ARGS(vec_nr)
 );
 
 /**
  * softirq_exit - called immediately after the softirq handler returns
- * @h: pointer to struct softirq_action
- * @vec: pointer to first struct softirq_action in softirq_vec array
+ * @vec_nr:  softirq vector number
  *
- * The @h parameter contains a pointer to the struct softirq_action
- * that has handled the softirq. By subtracting the @vec pointer from
- * the @h pointer, we can determine the softirq number. Also, when used in
- * combination with the softirq_entry tracepoint we can determine the softirq
- * latency.
+ * When used in combination with the softirq_entry tracepoint
+ * we can determine the softirq handler runtine.
  */
 DEFINE_EVENT(softirq, softirq_exit,
 
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_PROTO(unsigned int vec_nr),
 
-	TP_ARGS(h, vec)
+	TP_ARGS(vec_nr)
 );
 
 /**
  * softirq_raise - called immediately when a softirq is raised
- * @h: pointer to struct softirq_action
- * @vec: pointer to first struct softirq_action in softirq_vec array
+ * @vec_nr:  softirq vector number
  *
- * The @h parameter contains a pointer to the softirq vector number which is
- * raised. @vec is NULL and it means @h includes vector number not
- * softirq_action. When used in combination with the softirq_entry tracepoint
- * we can determine the softirq raise latency.
+ * When used in combination with the softirq_entry tracepoint
+ * we can determine the softirq raise to run latency.
  */
 DEFINE_EVENT(softirq, softirq_raise,
 
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_PROTO(unsigned int vec_nr),
 
-	TP_ARGS(h, vec)
+	TP_ARGS(vec_nr)
 );
 
 #endif /*  _TRACE_IRQ_H */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..b3cb1dc 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -212,18 +212,20 @@ restart:
 
 	do {
 		if (pending & 1) {
+			unsigned int vec_nr = h - softirq_vec;
 			int prev_count = preempt_count();
-			kstat_incr_softirqs_this_cpu(h - softirq_vec);
 
-			trace_softirq_entry(h, softirq_vec);
+			kstat_incr_softirqs_this_cpu(vec_nr);
+
+			trace_softirq_entry(vec_nr);
 			h->action(h);
-			trace_softirq_exit(h, softirq_vec);
+			trace_softirq_exit(vec_nr);
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %s %p"
+				printk(KERN_ERR "huh, entered softirq %u %s %p"
 				       "with preempt_count %08x,"
-				       " exited with %08x?\n", h - softirq_vec,
-				       softirq_to_name[h - softirq_vec],
-				       h->action, prev_count, preempt_count());
+				       " exited with %08x?\n", vec_nr,
+				       softirq_to_name[vec_nr], h->action,
+				       prev_count, preempt_count());
 				preempt_count() = prev_count;
 			}
 
