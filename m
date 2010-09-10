Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0IJOdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:33:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0IJOdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:33:10 -0400
Date: Fri, 10 Sep 2010 14:32:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Ensure we call add_event_to_ctx() with the right locks held
Message-ID: <tip-cee010ec5211b96f33c5c2208f5c14ebb04b634a@git.kernel.org>
Git-Commit-ID: cee010ec5211b96f33c5c2208f5c14ebb04b634a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 14:32:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cee010ec5211b96f33c5c2208f5c14ebb04b634a
Gitweb:     http://git.kernel.org/tip/cee010ec5211b96f33c5c2208f5c14ebb04b634a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 10 Sep 2010 12:51:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Sep 2010 16:24:33 +0200

perf: Ensure we call add_event_to_ctx() with the right locks held

Even though we call it from the inherit path, where the child is
not yet accessible, we need to hold ctx->lock, add_event_to_ctx()
assumes IRQs are disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index eaf1c5d..f395fb4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5913,6 +5913,7 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event_context *child_ctx)
 {
 	struct perf_event *child_event;
+	unsigned long flags;
 
 	/*
 	 * Instead of creating recursive hierarchies of events,
@@ -5957,7 +5958,9 @@ inherit_event(struct perf_event *parent_event,
 	/*
 	 * Link it up in the child's context:
 	 */
+	raw_spin_lock_irqsave(&child_ctx->lock, flags);
 	add_event_to_ctx(child_event, child_ctx);
+	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
 	 * Get a reference to the parent filp - we will fput it
