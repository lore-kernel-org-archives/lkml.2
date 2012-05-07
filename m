Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2EGCgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:36:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55907 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2EGCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:36:03 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-75-4fa73511c71c
Message-id: <4FA73510.7070705@samsung.com>
Date: Mon, 07 May 2012 11:36:00 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] tracing: Prevent wasting time evaluating parameters in
 trace_preempt_on/off
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes spending time for evaluating parameters in trace_preempt_on/off when
the tracer config is off.

The patch mainly inspired by Steven Rostedt, thanks Steven.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Minho Ban <mhban@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..bc7af66 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -485,8 +485,12 @@ static inline void __ftrace_enabled_restore(int enabled)
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
 #else
-  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
-  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
+/*
+ * Use defines instead of static inlines because some arches will make code out
+ * of the CALLER_ADDR, when we really want these to be a real nop.
+ */
+# define trace_preempt_on(a0, a1) do { } while (0)
+# define trace_preempt_off(a0, a1) do { } while (0)
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-- 
1.7.5.4

