Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1CYX5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:57:14 -0400
Received: from kroah.org ([198.145.64.141]:41968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593Ab1CYXxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:44 2011
Message-Id: <20110325234844.258247976@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [50/55] perf: Fix tear-down of inherited group events
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 38b435b16c36b0d863efcf3f07b34a6fac9873fd upstream.

When destroying inherited events, we need to destroy groups too,
otherwise the event iteration in perf_event_exit_task_context() will
miss group siblings and we leak events with all the consequences.

Reported-and-tested-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1300196470.2203.61.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5863,17 +5863,20 @@ __perf_event_exit_task(struct perf_event
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	struct perf_event *parent_event;
+	if (child_event->parent) {
+		raw_spin_lock_irq(&child_ctx->lock);
+		perf_group_detach(child_event);
+		raw_spin_unlock_irq(&child_ctx->lock);
+	}
 
 	perf_event_remove_from_context(child_event);
 
-	parent_event = child_event->parent;
 	/*
-	 * It can happen that parent exits first, and has events
+	 * It can happen that the parent exits first, and has events
 	 * that are still around due to the child reference. These
-	 * events need to be zapped - but otherwise linger.
+	 * events need to be zapped.
 	 */
-	if (parent_event) {
+	if (child_event->parent) {
 		sync_child_event(child_event, child);
 		free_event(child_event);
 	}


