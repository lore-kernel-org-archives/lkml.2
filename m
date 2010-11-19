Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0KSWEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:14 -0500
Received: from kroah.org ([198.145.64.141]:52814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0KSWED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:03 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:22 2010
Message-Id: <20101119220122.605394981@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [05/66] perf_events: Fix bogus context time tracking
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephane Eranian <eranian@google.com>

commit c530ccd9a1864a44a7ff35826681229ce9f2357a upstream.

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
LKML-Reference: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1773,7 +1773,13 @@ static u64 perf_event_read(struct perf_e
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


