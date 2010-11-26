Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0KZPE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:04:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:40434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab0KZPEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:04:55 -0500
Date: Fri, 26 Nov 2010 15:04:34 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290525705-6265-3-git-send-email-fbuihuu@gmail.com>
References: <1290525705-6265-3-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Don't bother to init the hrtimer for no SW sampling counters
Message-ID: <tip-5d508e820a23d9b6e8a149dfaa8ba5cbedf3d95c@git.kernel.org>
Git-Commit-ID: 5d508e820a23d9b6e8a149dfaa8ba5cbedf3d95c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:04:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d508e820a23d9b6e8a149dfaa8ba5cbedf3d95c
Gitweb:     http://git.kernel.org/tip/5d508e820a23d9b6e8a149dfaa8ba5cbedf3d95c
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Tue, 23 Nov 2010 16:21:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:55 +0100

perf: Don't bother to init the hrtimer for no SW sampling counters

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290525705-6265-3-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 027c4d3..98c5549 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4917,24 +4917,26 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 static void perf_swevent_start_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	s64 period;
+
+	if (!is_sampling_event(event))
+		return;
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (is_sampling_event(event)) {
-		s64 period = local64_read(&hwc->period_left);
 
-		if (period) {
-			if (period < 0)
-				period = 10000;
+	period = local64_read(&hwc->period_left);
+	if (period) {
+		if (period < 0)
+			period = 10000;
 
-			local64_set(&hwc->period_left, 0);
-		} else {
-			period = max_t(u64, 10000, hwc->sample_period);
-		}
-		__hrtimer_start_range_ns(&hwc->hrtimer,
+		local64_set(&hwc->period_left, 0);
+	} else {
+		period = max_t(u64, 10000, hwc->sample_period);
+	}
+	__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL_PINNED, 0);
-	}
 }
 
 static void perf_swevent_cancel_hrtimer(struct perf_event *event)
