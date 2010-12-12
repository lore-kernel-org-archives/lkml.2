Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0LLXyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:54:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab0LLXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:23 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tglx@linutronix.de, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [193/223] perf: Fix inherit vs. context rotation bug
Message-Id: <20101212234819.4664BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e upstream.

It was found that sometimes children of tasks with inherited events had
one extra event. Eventually it turned out to be due to the list rotation
no being exclusive with the list iteration in the inheritance code.

Cure this by temporarily disabling the rotation while we inherit the events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

Index: linux/include/linux/perf_event.h
===================================================================
--- linux.orig/include/linux/perf_event.h
+++ linux/include/linux/perf_event.h
@@ -764,6 +764,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
Index: linux/kernel/perf_event.c
===================================================================
--- linux.orig/kernel/perf_event.c
+++ linux/kernel/perf_event.c
@@ -1609,8 +1609,12 @@ static void rotate_ctx(struct perf_event
 {
 	raw_spin_lock(&ctx->lock);
 
-	/* Rotate the first entry last of non-pinned groups */
-	list_rotate_left(&ctx->flexible_groups);
+	/*
+	 * Rotate the first entry last of non-pinned groups. Rotation might be
+	 * disabled by the inheritance code.
+	 */
+	if (!ctx->rotate_disable)
+		list_rotate_left(&ctx->flexible_groups);
 
 	raw_spin_unlock(&ctx->lock);
 }
@@ -5596,6 +5600,7 @@ int perf_event_init_task(struct task_str
 	struct perf_event *event;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	unsigned long flags;
 	int ret = 0;
 
 	child->perf_event_ctxp = NULL;
@@ -5636,6 +5641,15 @@ int perf_event_init_task(struct task_str
 			break;
 	}
 
+	/*
+	 * We can't hold ctx->lock when iterating the ->flexible_group list due
+	 * to allocations, but we need to prevent rotation because
+	 * rotate_ctx() will change the list from interrupt context.
+	 */
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 1;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
 		ret = inherit_task_group(event, parent, parent_ctx, child,
 					 &inherited_all);
@@ -5643,6 +5657,10 @@ int perf_event_init_task(struct task_str
 			break;
 	}
 
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 0;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	child_ctx = child->perf_event_ctxp;
 
 	if (child_ctx && inherited_all) {
