Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab1AQFR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 00:17:58 -0500
Received: from ozlabs.org ([203.10.76.45]:57635 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab1AQFR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 00:17:57 -0500
Date: Mon, 17 Jan 2011 16:17:42 +1100
From: Anton Blanchard <anton@samba.org>
To: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: perf: Fix frequency calculation for overflowing
 counters
Message-ID: <20110117161742.5feb3761@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When profiling a benchmark that is almost 100% userspace, I noticed some
wildly inaccurate profiles that showed almost all time spent in the kernel.
Closer examination shows we were programming a tiny number of cycles into
the PMU after each overflow (about ~200 away from the next overflow). This
gets us stuck in a loop which we eventually break out of by throttling the
PMU (there are regular throttle/unthrottle events in the log).

It looks like we aren't setting event->hw.last_period to something same
and the frequency to period calculations in perf are going haywire. With
the following patch we find the correct period after a few interrupts and
stay there. I also see no more throttle events.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 5674807..ab6f6be 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1212,6 +1212,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			if (left <= 0)
 				left = period;
 			record = 1;
+			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
 			val = 0x80000000LL - left;
