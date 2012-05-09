Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab2EIOcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:32:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab2EIOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:32:39 -0400
Date: Wed, 9 May 2012 07:32:24 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-6accb9cf76080422d400a641d9068b6b2a2c216f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-5-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs: Fix frequency profiling
Git-Commit-ID: 6accb9cf76080422d400a641d9068b6b2a2c216f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:32:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6accb9cf76080422d400a641d9068b6b2a2c216f
Gitweb:     http://git.kernel.org/tip/6accb9cf76080422d400a641d9068b6b2a2c216f
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:13 +0200

perf/x86-ibs: Fix frequency profiling

Fixing profiling at a fixed frequency, in this case the freq value and
sample period was setup incorrectly. Since sampling periods are
adjusted we also allow periods that have lower 4 bits set.

Another fix is the setup of the hw counter: If we modify
hwc->sample_period, we also need to update hwc->last_period and
hwc->period_left.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-5-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index ebf169f..bc401bd 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -162,9 +162,16 @@ static int perf_ibs_init(struct perf_event *event)
 		if (config & perf_ibs->cnt_mask)
 			/* raw max_cnt may not be set */
 			return -EINVAL;
-		if (hwc->sample_period & 0x0f)
-			/* lower 4 bits can not be set in ibs max cnt */
+		if (!event->attr.sample_freq && hwc->sample_period & 0x0f)
+			/*
+			 * lower 4 bits can not be set in ibs max cnt,
+			 * but allowing it in case we adjust the
+			 * sample period to set a frequency.
+			 */
 			return -EINVAL;
+		hwc->sample_period &= ~0x0FULL;
+		if (!hwc->sample_period)
+			hwc->sample_period = 0x10;
 	} else {
 		max_cnt = config & perf_ibs->cnt_mask;
 		config &= ~perf_ibs->cnt_mask;
@@ -175,6 +182,13 @@ static int perf_ibs_init(struct perf_event *event)
 	if (!hwc->sample_period)
 		return -EINVAL;
 
+	/*
+	 * If we modify hwc->sample_period, we also need to update
+	 * hwc->last_period and hwc->period_left.
+	 */
+	hwc->last_period = hwc->sample_period;
+	local64_set(&hwc->period_left, hwc->sample_period);
+
 	hwc->config_base = perf_ibs->msr;
 	hwc->config = config;
 
