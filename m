Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0EKPn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:43:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0EKPn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:43:26 -0400
Date: Tue, 11 May 2010 15:42:43 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1273571513.5605.3527.camel@twins>
References: <1273571513.5605.3527.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix exit() vs PERF_FORMAT_GROUP
Message-ID: <tip-050735b08ca8a016bbace4445fa025b88fee770b@git.kernel.org>
Git-Commit-ID: 050735b08ca8a016bbace4445fa025b88fee770b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 15:42:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  050735b08ca8a016bbace4445fa025b88fee770b
Gitweb:     http://git.kernel.org/tip/050735b08ca8a016bbace4445fa025b88fee770b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 11 May 2010 11:51:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 15:46:43 +0200

perf: Fix exit() vs PERF_FORMAT_GROUP

Both Stephane and Corey reported that PERF_FORMAT_GROUP didn't
work as expected if the task the counters were attached to quit
before the read() call.

The cause is that we unconditionally destroy the grouping when
we remove counters from their context. Fix this by splitting off
the group destroy from the list removal such that
perf_event_remove_from_context() does not do this and change
perf_event_release() to do so.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: <stable@kernel.org> # .34.x
LKML-Reference: <1273571513.5605.3527.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a904746..c97e825 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -308,8 +308,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	struct perf_event *sibling, *tmp;
-
 	if (list_empty(&event->group_entry))
 		return;
 	ctx->nr_events--;
@@ -333,6 +331,12 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 */
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
+}
+
+static void
+perf_destroy_group(struct perf_event *event, struct perf_event_context *ctx)
+{
+	struct perf_event *sibling, *tmp;
 
 	/*
 	 * If this was a group event with sibling events then
@@ -1868,6 +1872,12 @@ int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	/*
+	 * Remove from the PMU, can't get re-enabled since we got
+	 * here because the last ref went.
+	 */
+	perf_event_disable(event);
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -1882,7 +1892,10 @@ int perf_event_release_kernel(struct perf_event *event)
 	 *     to trigger the AB-BA case.
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	perf_event_remove_from_context(event);
+	raw_spin_lock_irq(&ctx->lock);
+	list_del_event(event, ctx);
+	perf_destroy_group(event, ctx);
+	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
 	mutex_lock(&event->owner->perf_event_mutex);
