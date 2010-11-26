Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0KZPCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:02:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:40190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0KZPCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:02:16 -0500
Date: Fri, 26 Nov 2010 15:01:44 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix the software context switch counter
Message-ID: <tip-ee6dcfa40a50fe12a3ae0fb4d2653c66c3ed6556@git.kernel.org>
Git-Commit-ID: ee6dcfa40a50fe12a3ae0fb4d2653c66c3ed6556
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:01:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee6dcfa40a50fe12a3ae0fb4d2653c66c3ed6556
Gitweb:     http://git.kernel.org/tip/ee6dcfa40a50fe12a3ae0fb4d2653c66c3ed6556
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 26 Nov 2010 13:49:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:00:59 +0100

perf: Fix the software context switch counter

Stephane noticed that because the perf_sw_event() call is inside the
perf_event_task_sched_out() call it won't get called unless we
have a per-task counter.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   29 +++++++++++++++--------------
 kernel/perf_event.c        |    2 --
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 142e3d6..de2c417 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -909,20 +909,6 @@ extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
 extern void __perf_event_task_sched_in(struct task_struct *task);
 extern void __perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
-
-extern atomic_t perf_task_events;
-
-static inline void perf_event_task_sched_in(struct task_struct *task)
-{
-	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
-}
-
-static inline
-void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
-{
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
-}
-
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1031,6 +1017,21 @@ have_event:
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
+extern atomic_t perf_task_events;
+
+static inline void perf_event_task_sched_in(struct task_struct *task)
+{
+	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
+}
+
+static inline
+void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+{
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+
+	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+}
+
 extern void perf_event_mmap(struct vm_area_struct *vma);
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f365dd8..eac7e33 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1287,8 +1287,6 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
-
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 }
