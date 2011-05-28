Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1E1Qip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:38:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:32944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1E1Qin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:38:43 -0400
Date: Sat, 28 May 2011 16:38:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-075e0b00857e166dcc3e39037a1fc5a90acac709@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110409192141.665385503@chello.nl>
References: <20110409192141.665385503@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize ctx_sched_out()
Git-Commit-ID: 075e0b00857e166dcc3e39037a1fc5a90acac709
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:38:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  075e0b00857e166dcc3e39037a1fc5a90acac709
Gitweb:     http://git.kernel.org/tip/075e0b00857e166dcc3e39037a1fc5a90acac709
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:09 +0200

perf: Optimize ctx_sched_out()

Oleg noted that ctx_sched_out() disables the PMU even though it might
not actually do something, avoid needless PMU-disabling.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.665385503@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d863b3c..4d9a1f01 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1760,7 +1760,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	struct perf_event *event;
 
 	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1770,6 +1769,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (!ctx->nr_active)
 		goto out;
 
+	perf_pmu_disable(ctx->pmu);
 	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
@@ -1779,8 +1779,8 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-out:
 	perf_pmu_enable(ctx->pmu);
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 
