Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0FIKPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:15:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:41388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0FIKPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:15:36 -0400
Date: Wed, 9 Jun 2010 10:14:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Inline perf_swevent_put_recursion_context()
Message-ID: <tip-ecc55f84b2e9741f29daa787ded93986df6cbe17@git.kernel.org>
Git-Commit-ID: ecc55f84b2e9741f29daa787ded93986df6cbe17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:14:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ecc55f84b2e9741f29daa787ded93986df6cbe17
Gitweb:     http://git.kernel.org/tip/ecc55f84b2e9741f29daa787ded93986df6cbe17
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 15:11:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:33 +0200

perf, trace: Inline perf_swevent_put_recursion_context()

Inline perf_swevent_put_recursion_context into perf_tp_event(), this
shrinks the per trace template code footprint and saves a function
call.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h |    3 +--
 include/linux/perf_event.h   |    2 +-
 kernel/perf_event.c          |    8 ++++----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3167f2d..0af31cd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -257,8 +257,7 @@ static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
 		       u64 count, struct pt_regs *regs, void *head)
 {
-	perf_tp_event(addr, count, raw_data, size, regs, head);
-	perf_swevent_put_recursion_context(rctx);
+	perf_tp_event(addr, count, raw_data, size, regs, head, rctx);
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5d0266d..c691a0b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1001,7 +1001,7 @@ static inline bool perf_paranoid_kernel(void)
 extern void perf_event_init(void);
 extern void perf_tp_event(u64 addr, u64 count, void *record,
 			  int entry_size, struct pt_regs *regs,
-			  struct hlist_head *head);
+			  struct hlist_head *head, int rctx);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ff86c55..4bd3b59 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4213,14 +4213,12 @@ int perf_swevent_get_recursion_context(void)
 }
 EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
-void perf_swevent_put_recursion_context(int rctx)
+void inline perf_swevent_put_recursion_context(int rctx)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	barrier();
 	cpuctx->recursion[rctx]--;
 }
-EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
-
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
@@ -4601,7 +4599,7 @@ static int perf_tp_event_match(struct perf_event *event,
 }
 
 void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
-		   struct pt_regs *regs, struct hlist_head *head)
+		   struct pt_regs *regs, struct hlist_head *head, int rctx)
 {
 	struct perf_sample_data data;
 	struct perf_event *event;
@@ -4621,6 +4619,8 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 			perf_swevent_add(event, count, 1, &data, regs);
 	}
 	rcu_read_unlock();
+
+	perf_swevent_put_recursion_context(rctx);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
