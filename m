Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2EIOaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:30:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581Ab2EIOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:30:10 -0400
Date: Wed, 9 May 2012 07:29:54 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-c75841a398d667d9968245b9519d93cedbfb4780@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-2-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs: Fix update of period
Git-Commit-ID: c75841a398d667d9968245b9519d93cedbfb4780
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:30:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c75841a398d667d9968245b9519d93cedbfb4780
Gitweb:     http://git.kernel.org/tip/c75841a398d667d9968245b9519d93cedbfb4780
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:11 +0200

perf/x86-ibs: Fix update of period

The last sw period was not correctly updated on overflow and thus led
to wrong distribution of events. We always need to properly initialize
data.period in struct perf_sample_data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-2-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 8ff74d4..c8f69be 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -386,7 +386,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (!(*buf++ & perf_ibs->valid_mask))
 		return 0;
 
+	/*
+	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
+	 * supported in all cpus. As this triggered an interrupt, we
+	 * set the current count to the max count.
+	 */
+	config = ibs_data.regs[0];
+	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
+		config &= ~IBS_OP_CUR_CNT;
+		config |= (config & IBS_OP_MAX_CNT) << 36;
+	}
+
+	perf_ibs_event_update(perf_ibs, event, config);
 	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		ibs_data.caps = ibs_caps;
 		size = 1;
@@ -405,19 +419,6 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	regs = *iregs; /* XXX: update ip from ibs sample */
 
-	/*
-	 * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
-	 * supported in all cpus. As this triggered an interrupt, we
-	 * set the current count to the max count.
-	 */
-	config = ibs_data.regs[0];
-	if (perf_ibs == &perf_ibs_op && !(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-		config &= ~IBS_OP_CUR_CNT;
-		config |= (config & IBS_OP_MAX_CNT) << 36;
-	}
-
-	perf_ibs_event_update(perf_ibs, event, config);
-
 	overflow = perf_ibs_set_period(perf_ibs, hwc, &config);
 	reenable = !(overflow && perf_event_overflow(event, &data, &regs));
 	config = (config >> 4) | (reenable ? perf_ibs->enable_mask : 0);
