Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0KWPWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:22:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0KWPV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jWl3srsh9M5CykHIVHg6jVRfXWWTKKwqW6QaYOwQ87SdAtm33jFO6wRfaC9yBZfbXm
         85z6kM89a8ieAoTMgrV6MZUHTnvHMCtDYLLDN6HLKDtMMA/f0yw+tJ01ud9vfxVVCDLx
         PiSQ/cal+RIx3461VLNgdk4o3e79/kz/0Z95Q=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf: don't bother to init the hrtimer for no SW sampling counters
Date: Tue, 23 Nov 2010 16:21:45 +0100
Message-Id: <1290525705-6265-3-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
References: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
 <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 kernel/perf_event.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 813b09e..31515200 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4894,24 +4894,26 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
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
-- 
1.7.3.2

