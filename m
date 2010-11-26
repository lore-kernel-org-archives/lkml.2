Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0KZPEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:04:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:40390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0KZPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:04:16 -0500
Date: Fri, 26 Nov 2010 15:03:48 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
References: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Introduce is_sampling_event()
Message-ID: <tip-6c7e550f13f8ad82efb6a5653ae628c2543c1768@git.kernel.org>
Git-Commit-ID: 6c7e550f13f8ad82efb6a5653ae628c2543c1768
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:03:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c7e550f13f8ad82efb6a5653ae628c2543c1768
Gitweb:     http://git.kernel.org/tip/6c7e550f13f8ad82efb6a5653ae628c2543c1768
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Tue, 23 Nov 2010 16:21:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:54 +0100

perf: Introduce is_sampling_event()

and use it when appropriate.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290525705-6265-1-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 include/linux/perf_event.h       |    5 +++++
 kernel/perf_event.c              |   10 +++++-----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7c1a4c3..c01dfec 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -442,7 +442,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	u64 config;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index de2c417..cbf04cc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -969,6 +969,11 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
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
index 43f757c..8806984 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2514,7 +2514,7 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 	int ret = 0;
 	u64 value;
 
-	if (!event->attr.sample_period)
+	if (!is_sampling_event(event))
 		return -EINVAL;
 
 	if (copy_from_user(&value, arg, sizeof(value)))
@@ -4385,7 +4385,7 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 	if (!regs)
 		return;
 
-	if (!hwc->sample_period)
+	if (!is_sampling_event(event))
 		return;
 
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
@@ -4548,7 +4548,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		hwc->last_period = hwc->sample_period;
 		perf_swevent_set_period(event);
 	}
@@ -4920,7 +4920,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		s64 period = local64_read(&hwc->period_left);
 
 		if (period) {
@@ -4941,7 +4941,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (hwc->sample_period) {
+	if (is_sampling_event(event)) {
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
 		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
