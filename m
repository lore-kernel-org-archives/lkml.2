Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DXMgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:36:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53552 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2DXMgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:36:38 -0400
X-AuditID: cbfee61a-b7b8eae00000534b-9a-4f969e54e970
Message-id: <4F969E53.9080307@samsung.com>
Date: Tue, 24 Apr 2012 21:36:35 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
in argument. This seems not fair for those who expect to do nothing but increase
or decrease count.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Minho Ban <mhban@samsung.com>
---
 include/linux/ftrace.h |    3 ---
 kernel/sched/core.c    |    5 ++++-
 kernel/softirq.c       |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..7cd11fe 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -484,9 +484,6 @@ static inline void __ftrace_enabled_restore(int enabled)
 #ifdef CONFIG_PREEMPT_TRACER
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
-#else
-  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
-  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..efdd5a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3068,8 +3068,10 @@ void __kprobes add_preempt_count(int val)
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
+#ifdef CONFIG_PREEMPT_TRACER
 	if (preempt_count() == val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+#endif
 }
 EXPORT_SYMBOL(add_preempt_count);
 
@@ -3088,9 +3090,10 @@ void __kprobes sub_preempt_count(int val)
 			!(preempt_count() & PREEMPT_MASK)))
 		return;
 #endif
-
+#ifdef CONFIG_PREEMPT_TRACER
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+#endif
 	preempt_count() -= val;
 }
 EXPORT_SYMBOL(sub_preempt_count);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 671f959..e7c8336 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -112,9 +112,10 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 	if (softirq_count() == cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
-
+#ifdef CONFIG_PREEMPT_TRACER
 	if (preempt_count() == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+#endif
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
 static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
-- 
1.7.5.4

