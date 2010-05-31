Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0EaHUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:20:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab0EaHT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:19:56 -0400
Date: Mon, 31 May 2010 07:19:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix races in group composition
Message-ID: <tip-8a49542c0554af7d0073aac0ee73ee65b807ef34@git.kernel.org>
Git-Commit-ID: 8a49542c0554af7d0073aac0ee73ee65b807ef34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:19:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a49542c0554af7d0073aac0ee73ee65b807ef34
Gitweb:     http://git.kernel.org/tip/8a49542c0554af7d0073aac0ee73ee65b807ef34
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 27 May 2010 15:47:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:09 +0200

perf_events: Fix races in group composition

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
---
 include/linux/perf_event.h |    4 ++
 kernel/perf_event.c        |   91 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4906985..5d0266d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -631,6 +631,9 @@ struct swevent_hlist {
 	struct rcu_head		rcu_head;
 };
 
+#define PERF_ATTACH_CONTEXT	0x01
+#define PERF_ATTACH_GROUP	0x02
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -646,6 +649,7 @@ struct perf_event {
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
+	unsigned int			attach_state;
 	atomic64_t			count;
 
 	/*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 848d49a..10a1aee 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -283,14 +283,15 @@ ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -298,13 +299,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 
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
@@ -313,6 +307,24 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -320,17 +332,22 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
 
@@ -345,21 +362,39 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -727,6 +762,7 @@ static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
 	list_add_event(event, ctx);
+	perf_group_attach(event);
 	event->tstamp_enabled = ctx->time;
 	event->tstamp_running = ctx->time;
 	event->tstamp_stopped = ctx->time;
@@ -1894,8 +1930,8 @@ int perf_event_release_kernel(struct perf_event *event)
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
+	perf_group_detach(event);
 	list_del_event(event, ctx);
-	perf_destroy_group(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
@@ -5127,6 +5163,12 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5448,6 +5490,7 @@ static void perf_free_event(struct perf_event *event,
 
 	fput(parent->filp);
 
+	perf_group_detach(event);
 	list_del_event(event, ctx);
 	free_event(event);
 }
