Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1F2PnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab1F2PnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:43:05 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] perf: export perf_event_refresh() to modules
Date: Wed, 29 Jun 2011 18:42:37 +0300
Message-Id: <1309362157-6596-4-git-send-email-avi@redhat.com>
In-Reply-To: <1309362157-6596-1-git-send-email-avi@redhat.com>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM needs one-shot samples, since a PMC programmed to -X will fire after X
events and then again after 2^40 events (i.e. variable period).

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/perf_event.h |    5 +++++
 kernel/events/core.c       |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40264b5..91342ac 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -973,6 +973,7 @@ extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
+extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
@@ -1168,6 +1169,10 @@ static inline void perf_event_delayed_put(struct task_struct *task)	{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
+static inline int perf_event_refresh(struct perf_event *event, int refresh)
+{
+	return -EINVAL;
+}
 
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6dd4819..f69cc9f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1739,7 +1739,7 @@ out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
-static int perf_event_refresh(struct perf_event *event, int refresh)
+int perf_event_refresh(struct perf_event *event, int refresh)
 {
 	/*
 	 * not supported on inherited events
@@ -1752,6 +1752,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_event_refresh);
 
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
-- 
1.7.5.3

