Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab0GAWFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:05:39 -0400
Received: from kroah.org ([198.145.64.141]:33673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725Ab0GAVMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:43 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:46 2010
Message-Id: <20100701174246.785204764@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [004/200] perf: Fix exit() vs PERF_FORMAT_GROUP
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 050735b08ca8a016bbace4445fa025b88fee770b upstream.

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
LKML-Reference: <1273571513.5605.3527.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -315,8 +315,6 @@ list_add_event(struct perf_event *event,
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	struct perf_event *sibling, *tmp;
-
 	if (list_empty(&event->group_entry))
 		return;
 	ctx->nr_events--;
@@ -340,6 +338,12 @@ list_del_event(struct perf_event *event,
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
@@ -1856,9 +1860,18 @@ int perf_event_release_kernel(struct per
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	/*
+	 * Remove from the PMU, can't get re-enabled since we got
+	 * here because the last ref went.
+	 */
+	perf_event_disable(event);
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
-	perf_event_remove_from_context(event);
+	raw_spin_lock_irq(&ctx->lock);
+	list_del_event(event, ctx);
+	perf_destroy_group(event, ctx);
+	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
 	mutex_lock(&event->owner->perf_event_mutex);


