Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2GRKb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:31:27 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59933 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2GRKbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:31:24 -0400
Subject: [PATCH v2 RESEND] Hardware breakpoints: Invoke
 __perf_event_disable() if interrupts are already disabled
To: fweisbec@gmail.com, paulus@samba.org, a.p.zijlstra@chello.nl
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        emachado@linux.vnet.ibm.com, acme@ghostprotocols.net,
        prasad.krishnan@gmail.com
Date: Wed, 18 Jul 2012 16:00:46 +0530
Message-ID: <20120718103046.7512.8326.stgit@localhost.localdomain>
In-Reply-To: <20120706101653.7515.23309.stgit@localhost.localdomain>
References: <20120706101653.7515.23309.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12071810-5816-0000-0000-000003A2F61B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find v2 of the patch from Prasad, based on Peter Zijlstra's
feedback. This applies on top of v3.5-rc7. This has been tested and
found to work fine by Edjunior.

Regards,
Naveen
______

From: K.Prasad <Prasad.Krishnan@gmail.com>

While debugging a warning message on PowerPC while using hardware
breakpoints, it was discovered that when perf_event_disable is invoked
through hw_breakpoint_handler function with interrupts disabled, a
subsequent IPI in the code path would trigger a WARN_ON_ONCE message in
smp_call_function_single function.

This patch calls __perf_event_disable() when interrupts are already
disabled, instead of perf_event_disable().

Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: K.Prasad <Prasad.Krishnan@gmail.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 include/linux/perf_event.h    |    2 ++
 kernel/events/core.c          |    2 +-
 kernel/events/hw_breakpoint.c |   10 +++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45db49f..c289ba0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1292,6 +1292,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
 #else
 static inline void
@@ -1330,6 +1331,7 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+static inline int __perf_event_disable(void *info)			{ }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7d71d6..0ad0fc9 100644
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
index bb38c4d..483f14a 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -453,7 +453,15 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
 	int old_type = bp->attr.bp_type;
 	int err = 0;
 
-	perf_event_disable(bp);
+	/*
+	 * modify_user_hw_breakpoint can be invoked with IRQs disabled and hence it
+	 * will not be possible to raise IPIs that invoke __perf_event_disable.
+	 * So call the function directly.
+	 */
+	if (irqs_disabled())
+		__perf_event_disable(bp);
+	else
+		perf_event_disable(bp);
 
 	bp->attr.bp_addr = attr->bp_addr;
 	bp->attr.bp_type = attr->bp_type;

