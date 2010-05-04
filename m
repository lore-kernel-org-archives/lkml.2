Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab0EDMlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:41:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:51779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600Ab0EDMjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/12] perf: add perf_event_task_migrate()
Date: Tue,  4 May 2010 14:38:35 +0200
Message-Id: <1272976724-14312-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling perf_sw_event() directly from set_task_cpu(),
implement perf_event_task_migrate() which takes the same arguments as
trace_sched_migrate_task() and invokes perf_sw_event() is the task is
really migrating (cur_cpu != new_cpu).  This will help unifying
notifiers in sched.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    3 +++
 kernel/perf_event.c        |   11 +++++++++++
 kernel/sched.c             |    5 ++---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8e3754..a5eec48 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -754,6 +754,7 @@ extern int perf_max_events;
 
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
+extern void perf_event_task_migrate(struct task_struct *task, int new_cpu);
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
 extern void perf_event_task_tick(struct task_struct *task);
@@ -949,6 +950,8 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 #else
 static inline void
+perf_event_task_migrate(struct task_struct *task, int new_cpu)		{ }
+static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3d1552d..a01ba31 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1148,6 +1148,17 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 }
 
 /*
+ * Called from scheduler set_task_cpu() to notify migration events.
+ * If the task is moving to a different cpu, generate a migration sw
+ * event.
+ */
+void perf_event_task_migrate(struct task_struct *task, int new_cpu)
+{
+	if (task_cpu(task) != new_cpu)
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+}
+
+/*
  * Called from scheduler to remove the events of the current task,
  * with interrupts disabled.
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index c20fd31..2568911 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2084,11 +2084,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);
+	perf_event_task_migrate(p, new_cpu);
 
-	if (task_cpu(p) != new_cpu) {
+	if (task_cpu(p) != new_cpu)
 		p->se.nr_migrations++;
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
-	}
 
 	__set_task_cpu(p, new_cpu);
 }
-- 
1.6.4.2

