Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0IITuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:50:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:33083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0IITuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:50:09 -0400
Date: Thu, 9 Sep 2010 19:49:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Shrink hw_perf_event
Message-ID: <tip-fa407f35e0298d841e4088f95a7f9cf6e725c6d5@git.kernel.org>
Git-Commit-ID: fa407f35e0298d841e4088f95a7f9cf6e725c6d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:49:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa407f35e0298d841e4088f95a7f9cf6e725c6d5
Gitweb:     http://git.kernel.org/tip/fa407f35e0298d841e4088f95a7f9cf6e725c6d5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 24 Jun 2010 12:35:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:30 +0200

perf: Shrink hw_perf_event

Use hw_perf_event::period_left instead of hw_perf_event::remaining
and win back 8 bytes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 -
 kernel/perf_event.c        |   13 ++++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bf85733..8cafa15 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -529,7 +529,6 @@ struct hw_perf_event {
 			int		last_cpu;
 		};
 		struct { /* software */
-			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ef4ba3..1a6cdbf 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4800,14 +4800,13 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
 	if (hwc->sample_period) {
-		u64 period;
+		s64 period = local64_read(&hwc->period_left);
 
-		if (hwc->remaining) {
-			if (hwc->remaining < 0)
+		if (period) {
+			if (period < 0)
 				period = 10000;
-			else
-				period = hwc->remaining;
-			hwc->remaining = 0;
+
+			local64_set(&hwc->period_left, 0);
 		} else {
 			period = max_t(u64, 10000, hwc->sample_period);
 		}
@@ -4823,7 +4822,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 
 	if (hwc->sample_period) {
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
-		hwc->remaining = ktime_to_ns(remaining);
+		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
 		hrtimer_cancel(&hwc->hrtimer);
 	}
