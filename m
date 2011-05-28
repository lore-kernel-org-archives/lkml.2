Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1E1QmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:42:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1E1QmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:42:05 -0400
Date: Sat, 28 May 2011 16:41:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-e03a9a55b4e45377af9ca3d464135f9ea280b8f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
In-Reply-To: <20110409192142.038377551@chello.nl>
References: <20110409192142.038377551@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Change close() semantics for group events
Git-Commit-ID: e03a9a55b4e45377af9ca3d464135f9ea280b8f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:41:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e03a9a55b4e45377af9ca3d464135f9ea280b8f8
Gitweb:     http://git.kernel.org/tip/e03a9a55b4e45377af9ca3d464135f9ea280b8f8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:21 +0200

perf: Change close() semantics for group events

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
Cc: Vince Weaver <vweaver1@eecs.utk.edu>
Link: http://lkml.kernel.org/r/20110409192142.038377551@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 802f3b2..c378062 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2920,12 +2920,6 @@ int perf_event_release_kernel(struct perf_event *event)
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
@@ -2942,8 +2936,8 @@ int perf_event_release_kernel(struct perf_event *event)
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
-	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);
