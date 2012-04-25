Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab2DYFde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:33:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63891 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2DYFdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:33:33 -0400
X-AuditID: cbfee61a-b7b8eae00000534b-93-4f978caccf6a
Message-id: <4F978CAC.6060408@samsung.com>
Date: Wed, 25 Apr 2012 14:33:32 +0900
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

Signed-off-by: Minho Ban <mhban@samsung.com>
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

