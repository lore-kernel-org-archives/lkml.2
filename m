Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0EKJwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:52:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:39697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab0EKJwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:52:20 -0400
Subject: [PATCH] perf: Fix exit() vs PERF_FORMAT_GROUP -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Corey J Ashford <cjashfor@us.ibm.com>,
       stephane eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 11:51:53 +0200
Message-ID: <1273571513.5605.3527.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Stephane and Corey reported that PERF_FORMAT_GROUP didn't work
as expected if the task the counters were attached to quit before
the read() call.
    
The cause is that we unconditionally destroy the grouping when we
remove counters from their context. Fix this by splitting off the group
destroy from the list removal such that perf_event_remove_from_context()
does not do this and change perf_event_release() to do so.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

