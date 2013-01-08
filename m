Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3AHXod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:44:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:64026 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab3AHXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:39:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 68/77] perf: Fix tear-down of inherited group events
Date: Tue, 8 Jan 2013 18:35:47 -0500
Message-ID: <1357688156-25387-69-git-send-email-paul.gortmaker@windriver.com>
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

commit 38b435b16c36b0d863efcf3f07b34a6fac9873fd upstream.

When destroying inherited events, we need to destroy groups too,
otherwise the event iteration in perf_event_exit_task_context() will
miss group siblings and we leak events with all the consequences.

Reported-and-tested-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1300196470.2203.61.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/perf_event.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0e4499e..30e164e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5196,17 +5196,20 @@ __perf_event_exit_task(struct perf_event *child_event,
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
-- 
1.7.12.1

