Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0FJDuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:50:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32830 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab0FJDt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=tEHsWaHxn+OQW3WYPD6EAJHWMqxNcHXs1GM7bvYsUl1wLS9cI1iVudRgXhLqOzL8aP
         EXxSVJpIcbRVIaSinITQbVaRSxEOXyLkNYh+PecePpUpc0ikF18m6oa+jwkjkbH/n6hc
         oEqys3w6qfhdth+Cl3Sou68fVYWsceyWVWGqA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/5] perf: New PERF_EVENT_STATE_PAUSED event state
Date: Thu, 10 Jun 2010 05:49:18 +0200
Message-Id: <1276141760-11590-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a new PERF_EVENT_STATE_PAUSED state. It means the events
is enabled but we don't want it to run, it must be in the same state
than after a pmu->stop() call. So the event has been reserved and
allocated and it is ready to start after a pmu->start() call.

It is deemed for hardware events when we want them to be reserved on
the cpu and ready to be started anytime. This is going to be useful
for the new context exclusion that will follow.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ++++--
 include/linux/perf_event.h       |    3 ++-
 kernel/perf_event.c              |    7 ++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..9b0e52f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -839,7 +839,8 @@ void hw_perf_enable(void)
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			x86_pmu_stop(event);
+			if (event->state != PERF_EVENT_STATE_PAUSED)
+				x86_pmu_stop(event);
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
@@ -851,7 +852,8 @@ void hw_perf_enable(void)
 			else if (i < n_running)
 				continue;
 
-			x86_pmu_start(event);
+			if (event->state != PERF_EVENT_STATE_PAUSED)
+				x86_pmu_start(event);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63b5aa5..48b3157 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -598,7 +598,8 @@ enum perf_event_active_state {
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
-	PERF_EVENT_STATE_ACTIVE		=  1,
+	PERF_EVENT_STATE_PAUSED		=  1,
+	PERF_EVENT_STATE_ACTIVE		=  2,
 };
 
 struct file;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2d818bc..7c6502a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1541,20 +1541,21 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		bool software_event = is_software_event(event);
+		bool reprogram = !is_software_event(event) &&
+				 event->state != PERF_EVENT_STATE_PAUSED;
 
 		/*
 		 * Only hardware events need their irq period to be
 		 * reprogrammed
 		 */
-		if (!software_event) {
+		if (reprogram) {
 			perf_disable();
 			perf_event_stop(event);
 		}
 
 		local64_set(&hwc->period_left, 0);
 
-		if (!software_event) {
+		if (reprogram) {
 			perf_event_start(event);
 			perf_enable();
 		}
-- 
1.6.2.3

