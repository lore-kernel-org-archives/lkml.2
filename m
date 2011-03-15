Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab1CONld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:41:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab1CONlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:41:31 -0400
Subject: [PATCH] perf: Fix tear-down of inherited group events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <alpine.DEB.2.00.1103142224150.20209@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
	 <20110314223224.GD9388@ghostprotocols.net>
	 <alpine.DEB.2.00.1103142026350.16076@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1103142224150.20209@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 14:41:10 +0100
Message-ID: <1300196470.2203.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf: Fix tear-down of inherited group events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Mar 15 14:37:10 CET 2011

When destroying inherited events, we need to destroy groups too,
otherwise the event iteration in perf_event_exit_task_context() will
miss group siblings and we leak events with all the consequences.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org # .35+
---
 kernel/perf_event.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -6722,17 +6722,20 @@ __perf_event_exit_task(struct perf_event
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	struct perf_event *parent_event;
+	if (child_event->parent) {
+		raw_spin_lock_irq(&child_ctx->lock);
+		perf_group_detach(child_event);
+		raw_spin_unlock_irq(&child_ctx->lock);
+	}
 
 	perf_remove_from_context(child_event);
 
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

