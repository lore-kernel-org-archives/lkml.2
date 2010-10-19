Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab0JSNBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:01:05 -0400
Received: from www.tglx.de ([62.245.132.106]:60011 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab0JSNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:01:03 -0400
Date: Tue, 19 Oct 2010 15:00:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        mathieu.desnoyers@efficios.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <4CBD79CF.2060706@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com>  <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>  <20100908112529.GA25931@elte.hu>  <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of trace_softirq_raise() the softirq tracepoint got
even more convoluted. Why the tracepoints take two pointers to assign
an integer is beyond my comprehension.

But adding an extra case which treats the first pointer as an unsigned
long when the second pointer is NULL including the back and forth
type casting is just horrible.

Convert the softirq tracepoints to take a single unsigned int argument
for the softirq vector number and fix the call sites.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h  |    2 -
 include/trace/events/irq.h |   54 ++++++++++++++++-----------------------------
 kernel/softirq.c           |   14 ++++++-----
 3 files changed, 29 insertions(+), 41 deletions(-)

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
index 07b4f1b..c0a9ea5 100644
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
 				printk(KERN_ERR "huh, entered softirq %td %s %p"
 				       "with preempt_count %08x,"
-				       " exited with %08x?\n", h - softirq_vec,
-				       softirq_to_name[h - softirq_vec],
-				       h->action, prev_count, preempt_count());
+				       " exited with %08x?\n", vec_nr,
+				       softirq_to_name[vec_nr], h->action,
+				       prev_count, preempt_count());
 				preempt_count() = prev_count;
 			}
 
