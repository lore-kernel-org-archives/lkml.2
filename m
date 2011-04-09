Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab1DITXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:45320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1DITWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:43 -0400
Message-Id: <20110409192142.038377551@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 8/9] perf: Change close() semantics for group events
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-remove-on-close.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to always call list_del_event() on the correct cpu if the
event is part of an active context and avoid having to do two IPIs,
change the close() semantics slightly.

The current perf_event_disable() call would disable a whole group if
the event that's being closed is the group leader, whereas the new
code keeps the group siblings enabled.

People should not rely on this behaviour and I don't think they do,
but in case we find they do, the fix is easy and we have to take the
double IPI cost.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2920,12 +2920,6 @@ int perf_event_release_kernel(struct per
 {
 	struct perf_event_context *ctx = event->ctx;
 
-	/*
-	 * Remove from the PMU, can't get re-enabled since we got
-	 * here because the last ref went.
-	 */
-	perf_event_disable(event);
-
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -2942,8 +2936,8 @@ int perf_event_release_kernel(struct per
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
-	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);


