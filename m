Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0EUOFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:05:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48158 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0EUOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=eHNZXyPUGlViRy/Fr2bllnV6uHcLZJ9M7WUt3k7/s3kHDimPMZDq/8JPDiU51PaOdZ
         HGwEA21o0xsyWeh3c02jQCYs+rDIsE5TrkWDyM6Vz/gwssAzwzM4hxi6ng6A5+sDpWTF
         zXmmMnhbXd/aP0zEtiNx0MDbHfu1AcwjkKnpQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf: Support for irq exclusion
Date: Fri, 21 May 2010 16:05:14 +0200
Message-Id: <1274450715-23955-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide exclude_softirq and exclude_hardirq support in perf
event attributes. This brings the final pieces to subscribe
to any desired context granularity of profiling or tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_event.h |    8 +++++---
 kernel/perf_event.c        |   42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d939fc7..ca55ec5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -213,10 +213,12 @@ struct perf_event_attr {
 				 *
 				 *  See also PERF_RECORD_MISC_EXACT_IP
 				 */
-				precise_ip     :  2, /* skid constraint       */
-				exclude_task   :  1, /* don't count task context */
+				precise_ip	:  2, /* skid constraint */
+				exclude_task	:  1, /* don't count task context */
+				exclude_softirq	:  1, /* don't count softirq */
+				exclude_hardirq	:  1, /* don't count hardirq */
 
-				__reserved_1   : 46;
+				__reserved_1	: 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ab96411..03c17b2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3837,16 +3837,9 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	perf_output_end(&handle);
 }
 
-/*
- * Generic event overflow handling, sampling.
- */
-
-static int __perf_event_overflow(struct perf_event *event, int nmi,
-				   int throttle, struct perf_sample_data *data,
-				   struct pt_regs *regs)
+static int perf_event_unthrottle(struct perf_event *event,
+				 struct hw_perf_event *hwc, int throttle)
 {
-	int events = atomic_read(&event->event_limit);
-	struct hw_perf_event *hwc = &event->hw;
 	int ret = 0;
 
 	throttle = (throttle && event->pmu->unthrottle != NULL);
@@ -3872,6 +3865,23 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 		}
 	}
 
+	return ret;
+}
+
+/*
+ * Generic event overflow handling, sampling.
+ */
+
+static int __perf_event_overflow(struct perf_event *event, int nmi,
+				   int throttle, struct perf_sample_data *data,
+				   struct pt_regs *regs)
+{
+	int events = atomic_read(&event->event_limit);
+	struct hw_perf_event *hwc = &event->hw;
+	int ret;
+
+	ret = perf_event_unthrottle(event, &event->hw, throttle);
+
 	if (event->attr.freq) {
 		u64 now = perf_clock();
 		s64 delta = now - hwc->freq_time_stamp;
@@ -3910,9 +3920,19 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 static bool
 perf_exclude_event(struct perf_event *event, int offset)
 {
-	if (!in_interrupt_offset(preempt_count() - offset)) {
+	int preempt_offset = preempt_count() - offset;
+
+	if (!in_interrupt_offset(preempt_offset)) {
 		if (event->attr.exclude_task)
 			return true;
+	} else {
+		if (in_irq_offset(preempt_offset)) {
+			if (event->attr.exclude_hardirq)
+				return true;
+		} else if (in_softirq_offset(preempt_offset)) {
+			if (event->attr.exclude_softirq)
+				return true;
+		}
 	}
 
 	return false;
@@ -3932,7 +3952,7 @@ int perf_event_overflow(struct perf_event *event, int nmi,
 	 * context.
 	 */
 	if (perf_exclude_event(event, offset))
-		return 0;
+		return perf_event_unthrottle(event, &event->hw, 1);
 
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
-- 
1.6.2.3

