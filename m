Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0EGSmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:42:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0EGSmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:42:40 -0400
Date: Fri, 7 May 2010 18:42:10 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271190201-25705-2-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Move perfctr init code to x86_setup_perfctr()
Message-ID: <tip-4261e0e0efd9e04b6c69e0773c3cf4d6f337c416@git.kernel.org>
Git-Commit-ID: 4261e0e0efd9e04b6c69e0773c3cf4d6f337c416
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:42:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4261e0e0efd9e04b6c69e0773c3cf4d6f337c416
Gitweb:     http://git.kernel.org/tip/4261e0e0efd9e04b6c69e0773c3cf4d6f337c416
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 13 Apr 2010 22:23:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:30:59 +0200

perf, x86: Move perfctr init code to x86_setup_perfctr()

Split __hw_perf_event_init() to configure pmu events other than
perfctrs. Perfctr code is moved to a separate function
x86_setup_perfctr(). This and the following patches refactor the code.

Split in multiple patches for better review.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271190201-25705-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7de7061..801441a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -426,6 +426,8 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	return 0;
 }
 
+static int x86_setup_perfctr(struct perf_event *event);
+
 static int x86_pmu_hw_config(struct perf_event *event)
 {
 	/*
@@ -453,9 +455,6 @@ static int x86_pmu_hw_config(struct perf_event *event)
  */
 static int __hw_perf_event_init(struct perf_event *event)
 {
-	struct perf_event_attr *attr = &event->attr;
-	struct hw_perf_event *hwc = &event->hw;
-	u64 config;
 	int err;
 
 	if (!x86_pmu_initialized())
@@ -482,15 +481,24 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 	event->destroy = hw_perf_event_destroy;
 
-	hwc->idx = -1;
-	hwc->last_cpu = -1;
-	hwc->last_tag = ~0ULL;
+	event->hw.idx = -1;
+	event->hw.last_cpu = -1;
+	event->hw.last_tag = ~0ULL;
 
 	/* Processor specifics */
 	err = x86_pmu.hw_config(event);
 	if (err)
 		return err;
 
+	return x86_setup_perfctr(event);
+}
+
+static int x86_setup_perfctr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 config;
+
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
