Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0KZPBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:01:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0KZPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:01:19 -0500
Date: Fri, 26 Nov 2010 15:00:46 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix inherit vs. context rotation bug
Message-ID: <tip-dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e@git.kernel.org>
Git-Commit-ID: dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:00:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e
Gitweb:     http://git.kernel.org/tip/dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 24 Nov 2010 10:05:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:00:56 +0100

perf: Fix inherit vs. context rotation bug

It was found that sometimes children of tasks with inherited events had
one extra event. Eventually it turned out to be due to the list rotation
no being exclusive with the list iteration in the inheritance code.

Cure this by temporarily disabling the rotation while we inherit the events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40150f3..142e3d6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -850,6 +850,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 671f6c8..f365dd8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1622,8 +1622,12 @@ static void rotate_ctx(struct perf_event_context *ctx)
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
@@ -6162,6 +6166,7 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	struct perf_event *event;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	unsigned long flags;
 	int ret = 0;
 
 	child->perf_event_ctxp[ctxn] = NULL;
@@ -6202,6 +6207,15 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
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
 		ret = inherit_task_group(event, parent, parent_ctx,
 					 child, ctxn, &inherited_all);
@@ -6209,6 +6223,10 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 			break;
 	}
 
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 0;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	child_ctx = child->perf_event_ctxp[ctxn];
 
 	if (child_ctx && inherited_all) {
