Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab1C3VOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:14:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:20201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965214Ab1C3VKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448881"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: a.p.zijlstra@chello.nl, ak@linux.intel.com, stable@kernel.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [263/275] perf: Fix tear-down of inherited group events
Message-Id: <20110330210830.8924A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

[ upstream commit 38b435b16c36b0d863efcf3f07b34a6fac9873fd ]

When destroying inherited events, we need to destroy groups too,
otherwise the event iteration in perf_event_exit_task_context() will
miss group siblings and we leak events with all the consequences.

Reported-and-tested-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: <stable@kernel.org> # .35+
LKML-Reference: <1300196470.2203.61.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/perf_event.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/kernel/perf_event.c
===================================================================
--- linux-2.6.35.y.orig/kernel/perf_event.c	2011-03-29 23:03:03.000000000 -0700
+++ linux-2.6.35.y/kernel/perf_event.c	2011-03-29 23:27:02.487390526 -0700
@@ -5401,17 +5401,20 @@
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
