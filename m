Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0JONfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:35:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0JONfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=BosyPz8583mDi7bz9oTDBE7bIAGmK7MqSlr3e/6XChnAlKSNJIRC7ea51QUuJi934/
         1pGjanf+3zO88VJ2Qrew==
Message-ID: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 15 Oct 2010 15:26:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix bogus context time tracking
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b6fd9ec..4dae345 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1775,7 +1775,13 @@ static u64 perf_event_read(struct perf_event *event)
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
