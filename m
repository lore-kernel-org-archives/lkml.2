Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0JRTSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:18:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:59360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470Ab0JRTSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:18:23 -0400
Date: Mon, 18 Oct 2010 19:17:58 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
References: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix bogus context time tracking
Message-ID: <tip-c530ccd9a1864a44a7ff35826681229ce9f2357a@git.kernel.org>
Git-Commit-ID: c530ccd9a1864a44a7ff35826681229ce9f2357a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:17:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c530ccd9a1864a44a7ff35826681229ce9f2357a
Gitweb:     http://git.kernel.org/tip/c530ccd9a1864a44a7ff35826681229ce9f2357a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 15 Oct 2010 15:26:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:46 +0200

perf_events: Fix bogus context time tracking

You can only call update_context_time() when the context
is active, i.e., the thread it is attached to is still running.

However, perf_event_read() can be called even when the context
is inactive, e.g., user read() the counters. The call to
update_context_time() must be conditioned on the status of
the context, otherwise, bogus time_enabled, time_running may
be returned. Here is an example on AMD64. The task program
is an example from libpfm4. The -p prints deltas every 1s.

$ task -p -e cpu_clk_unhalted sleep 5
    2,266,610 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
5,242,358,071 cpu_clk_unhalted (99.95% scaling, ena=5,000,359,984, run=2,319,270)

Whereas if you don't read deltas, e.g., no call to perf_event_read() until
the process terminates:

$ task -e cpu_clk_unhalted sleep 5
    2,497,783 cpu_clk_unhalted (0.00% scaling, ena=2,376,899, run=2,376,899)

Notice that time_enable, time_running are bogus in the first example
causing bogus scaling.

This patch fixes the problem, by conditionally calling update_context_time()
in perf_event_read().

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org
LKML-Reference: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1ec3916..e7eeba1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1780,7 +1780,13 @@ static u64 perf_event_read(struct perf_event *event)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&ctx->lock, flags);
-		update_context_time(ctx);
+		/*
+		 * may read while context is not active
+		 * (e.g., thread is blocked), in that case
+		 * we cannot update context time
+		 */
+		if (ctx->is_active)
+			update_context_time(ctx);
 		update_event_times(event);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
