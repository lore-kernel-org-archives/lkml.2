Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2EIOjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:39:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2EIOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:39:15 -0400
Date: Wed, 9 May 2012 07:39:02 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-8b1e13638d465863572c8207a5cfceeef0cf0441@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-13-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-13-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs: Fix usage of IBS op current count
Git-Commit-ID: 8b1e13638d465863572c8207a5cfceeef0cf0441
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:39:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b1e13638d465863572c8207a5cfceeef0cf0441
Gitweb:     http://git.kernel.org/tip/8b1e13638d465863572c8207a5cfceeef0cf0441
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:17 +0200

perf/x86-ibs: Fix usage of IBS op current count

The value of IbsOpCurCnt rolls over when it reaches IbsOpMaxCnt. Thus,
it is reset to zero by hardware. To get the correct count we need to
add the max count to it in case we received an ibs sample (valid bit
set).

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-13-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   33 +++++++++++++++++++----------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 5a9f95b..da9bcdc 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -286,7 +286,15 @@ static u64 get_ibs_fetch_count(u64 config)
 
 static u64 get_ibs_op_count(u64 config)
 {
-	return (config & IBS_OP_CUR_CNT) >> 32;
+	u64 count = 0;
+
+	if (config & IBS_OP_VAL)
+		count += (config & IBS_OP_MAX_CNT) << 4; /* cnt rolled over */
+
+	if (ibs_caps & IBS_CAPS_RDWROPCNT)
+		count += (config & IBS_OP_CUR_CNT) >> 32;
+
+	return count;
 }
 
 static void
@@ -295,7 +303,12 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 {
 	u64 count = perf_ibs->get_count(*config);
 
-	while (!perf_event_try_update(event, count, 20)) {
+	/*
+	 * Set width to 64 since we do not overflow on max width but
+	 * instead on max count. In perf_ibs_set_period() we clear
+	 * prev count manually on overflow.
+	 */
+	while (!perf_event_try_update(event, count, 64)) {
 		rdmsrl(event->hw.config_base, *config);
 		count = perf_ibs->get_count(*config);
 	}
@@ -374,6 +387,12 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (hwc->state & PERF_HES_UPTODATE)
 		return;
 
+	/*
+	 * Clear valid bit to not count rollovers on update, rollovers
+	 * are only updated in the irq handler.
+	 */
+	config &= ~perf_ibs->valid_mask;
+
 	perf_ibs_event_update(perf_ibs, event, &config);
 	hwc->state |= PERF_HES_UPTODATE;
 }
@@ -488,17 +507,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (!(*buf++ & perf_ibs->valid_mask))
 		return 0;
 
-	/*
-	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
-	 * supported in all cpus. As this triggered an interrupt, we
-	 * set the current count to the max count.
-	 */
 	config = &ibs_data.regs[0];
-	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		*config &= ~IBS_OP_CUR_CNT;
-		*config |= (*config & IBS_OP_MAX_CNT) << 36;
-	}
-
 	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0, hwc->last_period);
 	if (!perf_ibs_set_period(perf_ibs, hwc, &period))
