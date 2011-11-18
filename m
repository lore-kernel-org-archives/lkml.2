Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1KRXdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:33:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1KRXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:33:17 -0500
Date: Fri, 18 Nov 2011 15:32:58 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-1d5f003f5a964711853514b04ddc872eec0fdc7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111023171033.GI17571@redhat.com>
References: <20111023171033.GI17571@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Do not set task_ctx pointer in cpuctx if there are no events in the context
Git-Commit-ID: 1d5f003f5a964711853514b04ddc872eec0fdc7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:33:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d5f003f5a964711853514b04ddc872eec0fdc7b
Gitweb:     http://git.kernel.org/tip/1d5f003f5a964711853514b04ddc872eec0fdc7b
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Sun, 23 Oct 2011 19:10:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:01:21 +0100

perf: Do not set task_ctx pointer in cpuctx if there are no events in the context

Do not set task_ctx pointer during sched_in if there are no
events associated with the context.  Otherwise if during task
execution total number of events in the system will become zero
perf_event_context_sched_out() will not be called and cpuctx->task_ctx
will be left with a stale value.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111023171033.GI17571@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e8457d..b0c1186 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2173,7 +2173,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_event_sched_in(cpuctx, ctx, task);
 
-	cpuctx->task_ctx = ctx;
+	if (ctx->nr_events)
+		cpuctx->task_ctx = ctx;
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
