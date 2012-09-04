Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2IDSxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:53:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2IDSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:53:28 -0400
Date: Tue, 4 Sep 2012 11:53:11 -0700
From: "tip-bot for K.Prasad" <Prasad.Krishnan@gmail.com>
Message-ID: <tip-500ad2d8b01390c98bc6dce068bccfa9534b8212@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, Prasad.Krishnan@gmail.com,
        emachado@linux.vnet.ibm.com, fweisbec@gmail.com,
        naveen.n.rao@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, Prasad.Krishnan@gmail.com,
        emachado@linux.vnet.ibm.com, fweisbec@gmail.com,
        naveen.n.rao@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120802081635.5811.17737.stgit@localhost.localdomain>
References: <20120802081635.5811.17737.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/hwpb: Invoke __perf_event_disable()
  if interrupts are already disabled
Git-Commit-ID: 500ad2d8b01390c98bc6dce068bccfa9534b8212
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:53:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  500ad2d8b01390c98bc6dce068bccfa9534b8212
Gitweb:     http://git.kernel.org/tip/500ad2d8b01390c98bc6dce068bccfa9534b8212
Author:     K.Prasad <Prasad.Krishnan@gmail.com>
AuthorDate: Thu, 2 Aug 2012 13:46:35 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 17:29:53 +0200

perf/hwpb: Invoke __perf_event_disable() if interrupts are already disabled

While debugging a warning message on PowerPC while using hardware
breakpoints, it was discovered that when perf_event_disable is invoked
through hw_breakpoint_handler function with interrupts disabled, a
subsequent IPI in the code path would trigger a WARN_ON_ONCE message in
smp_call_function_single function.

This patch calls __perf_event_disable() when interrupts are already
disabled, instead of perf_event_disable().

Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: K.Prasad <Prasad.Krishnan@gmail.com>
[naveen.n.rao@linux.vnet.ibm.com: v3: Check to make sure we target current task]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120802081635.5811.17737.stgit@localhost.localdomain
[ Fixed build error on MIPS. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h    |    2 ++
 kernel/events/core.c          |    2 +-
 kernel/events/hw_breakpoint.c |   11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ad04dfc..33ed9d6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1296,6 +1296,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
 #else
 static inline void
@@ -1334,6 +1335,7 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index efef428..7fee567 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1253,7 +1253,7 @@ retry:
 /*
  * Cross CPU call to disable a performance event
  */
-static int __perf_event_disable(void *info)
+int __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index bb38c4d..9a7b487 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -453,7 +453,16 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
 	int old_type = bp->attr.bp_type;
 	int err = 0;
 
-	perf_event_disable(bp);
+	/*
+	 * modify_user_hw_breakpoint can be invoked with IRQs disabled and hence it
+	 * will not be possible to raise IPIs that invoke __perf_event_disable.
+	 * So call the function directly after making sure we are targeting the
+	 * current task.
+	 */
+	if (irqs_disabled() && bp->ctx && bp->ctx->task == current)
+		__perf_event_disable(bp);
+	else
+		perf_event_disable(bp);
 
 	bp->attr.bp_addr = attr->bp_addr;
 	bp->attr.bp_type = attr->bp_type;
