Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0LHBDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:50 -0500
Received: from kroah.org ([198.145.64.141]:33805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab0LHBDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:48 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.890252880@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [255/289] perf: Fix inherit vs. context rotation bug
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e upstream.

It was found that sometimes children of tasks with inherited events had
one extra event. Eventually it turned out to be due to the list rotation
no being exclusive with the list iteration in the inheritance code.

Cure this by temporarily disabling the rotation while we inherit the events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -788,6 +788,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1620,8 +1620,12 @@ static void rotate_ctx(struct perf_event
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
@@ -5622,6 +5626,7 @@ int perf_event_init_task(struct task_str
 	struct perf_event *event;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	unsigned long flags;
 	int ret = 0;
 
 	child->perf_event_ctxp = NULL;
@@ -5662,6 +5667,15 @@ int perf_event_init_task(struct task_str
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
@@ -5669,6 +5683,10 @@ int perf_event_init_task(struct task_str
 			break;
 	}
 
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 0;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	child_ctx = child->perf_event_ctxp;
 
 	if (child_ctx && inherited_all) {


