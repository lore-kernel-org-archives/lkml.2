Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0JRTXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:23:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808Ab0JRTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:23:04 -0400
Date: Mon, 18 Oct 2010 19:22:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: Add COND_STMT(), reducer wrappery
Message-ID: <tip-ebf31f502492527e2b6b5e5cf85a4ebc7fc8a52e@git.kernel.org>
Git-Commit-ID: ebf31f502492527e2b6b5e5cf85a4ebc7fc8a52e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:22:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebf31f502492527e2b6b5e5cf85a4ebc7fc8a52e
Gitweb:     http://git.kernel.org/tip/ebf31f502492527e2b6b5e5cf85a4ebc7fc8a52e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 17 Oct 2010 12:15:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:59:01 +0200

jump_label: Add COND_STMT(), reducer wrappery

The use of the JUMP_LABEL() construct ends up creating endless silly
wrappers, create a higher level construct to reduce this clutter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |   10 ++++++++++
 include/linux/perf_event.h |   12 ++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 81be496..b67cb18 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -61,4 +61,14 @@ static inline int jump_label_text_reserved(void *start, void *end)
 
 #endif
 
+#define COND_STMT(key, stmt)					\
+do {								\
+	__label__ jl_enabled;					\
+	JUMP_LABEL(key, jl_enabled);				\
+	if (0) {						\
+jl_enabled:							\
+		stmt;						\
+	}							\
+} while (0)
+
 #endif
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3b80cbf..057bf22 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -903,21 +903,13 @@ extern atomic_t perf_task_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	JUMP_LABEL(&perf_task_events, have_events);
-	return;
-
-have_events:
-	__perf_event_task_sched_in(task);
+	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
 }
 
 static inline
 void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
-	JUMP_LABEL(&perf_task_events, have_events);
-	return;
-
-have_events:
-	__perf_event_task_sched_out(task, next);
+	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
 }
 
 extern int perf_event_init_task(struct task_struct *child);
