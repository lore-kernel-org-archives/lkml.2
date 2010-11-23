Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0KWPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:21:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0KWPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fP88pNWmFkmkizsF5sDVbtQk7fdfA1RUNJFXORwuEVAWVxGe/cAsz3KvefuTNpKKos
         9FW5r8UzTYdr9kUUlmMk05/dgbaDL4lbHWAV611Af0BVkwsjkPsxeJ4JPg3kCqqZwfkG
         6AnIyv1OIEhrXXVF2Zfkxv3CEE9Mak3KVskMQ=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf: introduce is_sampling_event()
Date: Tue, 23 Nov 2010 16:21:43 +0100
Message-Id: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

and use it when appropriate.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 include/linux/perf_event.h       |    5 +++++
 kernel/perf_event.c              |   10 +++++-----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..89aa0f8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -437,7 +437,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	u64 config;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40150f3..bb1884c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -982,6 +982,11 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
 				 struct perf_sample_data *data,
 				 struct pt_regs *regs);
 
+static inline bool is_sampling_event(struct perf_event *event)
+{
+	return event->attr.sample_period != 0;
+}
+
 /*
  * Return 1 for a software event, 0 for a hardware event
  */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index cb6c0d2..df7869f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2482,7 +2482,7 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 	int ret = 0;
 	u64 value;
 
-	if (!event->attr.sample_period)
+	if (!is_sampling_event(event))
 		return -EINVAL;
 
 	if (copy_from_user(&value, arg, sizeof(value)))
@@ -4353,7 +4353,7 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 	if (!regs)
 		return;
 
-	if (!hwc->sample_period)
+	if (!is_sampling_event(event))
 		return;
 
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
@@ -4516,7 +4516,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		hwc->last_period = hwc->sample_period;
 		perf_swevent_set_period(event);
 	}
@@ -4897,7 +4897,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		s64 period = local64_read(&hwc->period_left);
 
 		if (period) {
@@ -4918,7 +4918,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
 		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
-- 
1.7.3.2

