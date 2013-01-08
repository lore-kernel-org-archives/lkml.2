Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3AHXoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:44:46 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53759 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab3AHXjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:39:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 67/77] perf_events: Fix races in group composition
Date: Tue, 8 Jan 2013 18:35:46 -0500
Message-ID: <1357688156-25387-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8a49542c0554af7d0073aac0ee73ee65b807ef34 upstream.

Group siblings don't pin each-other or the parent, so when we destroy
events we must make sure to clean up all cross referencing pointers.

In particular, for destruction of a group leader we must be able to
find all its siblings and remove their reference to it.

This means that detaching an event from its context must not detach it
from the group, otherwise we can end up failing to clear all pointers.

Solve this by clearly separating the attachment to a context and
attachment to a group, and keep the group composed until we destroy
the events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/perf_event.h |  4 ++
 kernel/perf_event.c        | 91 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index eea9188..c6e1432 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -571,6 +571,9 @@ enum perf_group_flag {
 	PERF_GROUP_SOFTWARE = 0x1,
 };
 
+#define PERF_ATTACH_CONTEXT	0x01
+#define PERF_ATTACH_GROUP	0x02
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -585,6 +588,7 @@ struct perf_event {
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
+	unsigned int			attach_state;
 	atomic64_t			count;
 
 	/*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 540c26b..0e4499e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -291,14 +291,15 @@ ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
 static void
 list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	struct perf_event *group_leader = event->group_leader;
+	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_CONTEXT);
+	event->attach_state |= PERF_ATTACH_CONTEXT;
 
 	/*
-	 * Depending on whether it is a standalone or sibling event,
-	 * add it straight to the context's event list, or to the group
-	 * leader's sibling list:
+	 * If we're a stand alone event or group leader, we go to the context
+	 * list, group events are kept attached to the group so that
+	 * perf_group_detach can, at all times, locate all siblings.
 	 */
-	if (group_leader == event) {
+	if (event->group_leader == event) {
 		struct list_head *list;
 
 		if (is_software_event(event))
@@ -306,13 +307,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 
 		list = ctx_group_list(event, ctx);
 		list_add_tail(&event->group_entry, list);
-	} else {
-		if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
-		    !is_software_event(event))
-			group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
-
-		list_add_tail(&event->group_entry, &group_leader->sibling_list);
-		group_leader->nr_siblings++;
 	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
@@ -321,6 +315,24 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_stat++;
 }
 
+static void perf_group_attach(struct perf_event *event)
+{
+	struct perf_event *group_leader = event->group_leader;
+
+	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_GROUP);
+	event->attach_state |= PERF_ATTACH_GROUP;
+
+	if (group_leader == event)
+		return;
+
+	if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
+			!is_software_event(event))
+		group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
+
+	list_add_tail(&event->group_entry, &group_leader->sibling_list);
+	group_leader->nr_siblings++;
+}
+
 /*
  * Remove a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
@@ -328,17 +340,22 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	if (list_empty(&event->group_entry))
+	/*
+	 * We can have double detach due to exit/hot-unplug + close.
+	 */
+	if (!(event->attach_state & PERF_ATTACH_CONTEXT))
 		return;
+
+	event->attach_state &= ~PERF_ATTACH_CONTEXT;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
 
-	list_del_init(&event->group_entry);
 	list_del_rcu(&event->event_entry);
 
-	if (event->group_leader != event)
-		event->group_leader->nr_siblings--;
+	if (event->group_leader == event)
+		list_del_init(&event->group_entry);
 
 	update_group_times(event);
 
@@ -353,21 +370,39 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		event->state = PERF_EVENT_STATE_OFF;
 }
 
-static void
-perf_destroy_group(struct perf_event *event, struct perf_event_context *ctx)
+static void perf_group_detach(struct perf_event *event)
 {
 	struct perf_event *sibling, *tmp;
+	struct list_head *list = NULL;
+
+	/*
+	 * We can have double detach due to exit/hot-unplug + close.
+	 */
+	if (!(event->attach_state & PERF_ATTACH_GROUP))
+		return;
+
+	event->attach_state &= ~PERF_ATTACH_GROUP;
+
+	/*
+	 * If this is a sibling, remove it from its group.
+	 */
+	if (event->group_leader != event) {
+		list_del_init(&event->group_entry);
+		event->group_leader->nr_siblings--;
+		return;
+	}
+
+	if (!list_empty(&event->group_entry))
+		list = &event->group_entry;
 
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
-	 * to the context list directly:
+	 * to whatever list we are on.
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, group_entry) {
-		struct list_head *list;
-
-		list = ctx_group_list(event, ctx);
-		list_move_tail(&sibling->group_entry, list);
+		if (list)
+			list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
 
 		/* Inherit group flags from the previous leader */
@@ -720,6 +755,7 @@ static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
 	list_add_event(event, ctx);
+	perf_group_attach(event);
 	event->tstamp_enabled = ctx->time;
 	event->tstamp_running = ctx->time;
 	event->tstamp_stopped = ctx->time;
@@ -1874,8 +1910,8 @@ int perf_event_release_kernel(struct perf_event *event)
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	raw_spin_lock_irq(&ctx->lock);
+	perf_group_detach(event);
 	list_del_event(event, ctx);
-	perf_destroy_group(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
@@ -4946,6 +4982,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
 
+	/*
+	 * Drop the reference on the group_event after placing the
+	 * new event on the sibling_list. This ensures destruction
+	 * of the group leader will find the pointer to itself in
+	 * perf_group_detach().
+	 */
 	fput_light(group_file, fput_needed);
 	fd_install(event_fd, event_file);
 	return event_fd;
@@ -5267,6 +5309,7 @@ static void perf_free_event(struct perf_event *event,
 
 	fput(parent->filp);
 
+	perf_group_detach(event);
 	list_del_event(event, ctx);
 	free_event(event);
 }
-- 
1.7.12.1

