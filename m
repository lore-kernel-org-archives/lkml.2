Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1CPOAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:00:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:50002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1CPOAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:00:02 -0400
Date: Wed, 16 Mar 2011 13:59:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
In-Reply-To: <1300196470.2203.61.camel@twins>
References: <1300196470.2203.61.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix tear-down of inherited group events
Message-ID: <tip-38b435b16c36b0d863efcf3f07b34a6fac9873fd@git.kernel.org>
Git-Commit-ID: 38b435b16c36b0d863efcf3f07b34a6fac9873fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:59:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38b435b16c36b0d863efcf3f07b34a6fac9873fd
Gitweb:     http://git.kernel.org/tip/38b435b16c36b0d863efcf3f07b34a6fac9873fd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Mar 2011 14:37:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:14 +0100

perf: Fix tear-down of inherited group events

When destroying inherited events, we need to destroy groups too,
otherwise the event iteration in perf_event_exit_task_context() will
miss group siblings and we leak events with all the consequences.

Reported-and-tested-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # .35+
LKML-Reference: <1300196470.2203.61.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 533f715..3472bb1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6722,17 +6722,20 @@ __perf_event_exit_task(struct perf_event *child_event,
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
