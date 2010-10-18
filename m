Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0JRTnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:43:37 -0400
Received: from 189-30-137-112.ctame700.dsl.brasiltelecom.net.br ([189.30.137.112]:38143
	"EHLO ana.ghostprotocols.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757594Ab0JRTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:43:36 -0400
X-Greylist: delayed 3837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 15:43:34 EDT
Date: Mon, 18 Oct 2010 16:38:43 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Subject: [PATCH tip/rt/head] perf: Mark software events as irqsafe
Message-ID: <20101018183843.GA22254@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Noticed while using 'perf top' on a machine without a supported PMU on
2.6.33.7-rt29, when top falls back to using the "cpu-clock" software
event.

Reproduced on other machines where the problem was masked due to the
existence and use of hardware events, by explicitely asking for a
software event using:

perf top -e cpu-clock

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@infradead.org>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6dfaf5b..b9fbc17 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4238,6 +4238,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.irqsafe = 1;
 	hwc->hrtimer.function = perf_swevent_hrtimer;
 	if (hwc->sample_period) {
 		u64 period;
