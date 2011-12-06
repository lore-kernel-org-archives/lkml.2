Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab1LFJrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:47:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:47:47 -0500
Date: Tue, 6 Dec 2011 01:47:20 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-b79387ef185af2323594920923cecba5753c3817@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        dczhu@mips.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dczhu@mips.com,
        mingo@elte.hu
In-Reply-To: <1322048382.14799.41.camel@twins>
References: <1322048382.14799.41.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix enable_on_exec for sibling events
Git-Commit-ID: b79387ef185af2323594920923cecba5753c3817
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:47:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b79387ef185af2323594920923cecba5753c3817
Gitweb:     http://git.kernel.org/tip/b79387ef185af2323594920923cecba5753c3817
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 22 Nov 2011 11:25:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:34:01 +0100

perf: Fix enable_on_exec for sibling events

Deng-Cheng Zhu reported that sibling events that were created disabled
with enable_on_exec would never get enabled. Iterate all events
instead of the group lists.

Reported-by: Deng-Cheng Zhu <dczhu@mips.com>
Tested-by: Deng-Cheng Zhu <dczhu@mips.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322048382.14799.41.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index eeda540..3c1541d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2497,13 +2497,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	raw_spin_lock(&ctx->lock);
 	task_ctx_sched_out(ctx);
 
-	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
-		ret = event_enable_on_exec(event, ctx);
-		if (ret)
-			enabled = 1;
-	}
-
-	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
+	list_for_each_entry(event, &ctx->event_list, event_entry) {
 		ret = event_enable_on_exec(event, ctx);
 		if (ret)
 			enabled = 1;
