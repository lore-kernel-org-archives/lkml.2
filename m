Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2HMMBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:01:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43387 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2HMMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:01:47 -0400
From: Heechul Yun <heechul@illinois.edu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Heechul Yun <heechul@illinois.edu>
Subject: [PATCH] powerpc: perf: Do not reset a counter value on stop/start
Date: Sun, 12 Aug 2012 11:50:21 -0500
Message-Id: <1344790221-2082-1-git-send-email-heechul@illinois.edu>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A performance counter of e500mc processor core generates an overflow
interrupt when the counter value reaches to 0x80000000. In order to
set up a sampling counter, the kernel sets the counter value to
0x80000000 - <samples> to cause an interrupt right after <samples>
are incremented.

In the current code, the problem arises when the kernel stops and
re-starts the sampling counter (fsl_emb_pmu_stop() and
fsl_emb_pmu_start() are called repsectively). When fsl_emb_pmu_stop()
is called, called when a user adjusts the sampling period, it currently
re-writes the counter value to zero, which breaks working of the
sampling counter. Similarily fsl_emb_pmu_start() re-write the counter
value.

This patch fixes the bug by not re-writing the counter unnecessarily.
Also, it sets the counter freeze bit in fsl_emb_pmu_stop(), so that
the counter does not increase until fsl_emb_pmu_start() is called
again.

Signed-off-by: Heechul Yun <heechul@illinois.edu>
---
 arch/powerpc/perf/core-fsl-emb.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/perf/core-fsl-emb.c b/arch/powerpc/perf/core-fsl-emb.c
index 106c533..4cd4f12 100644
--- a/arch/powerpc/perf/core-fsl-emb.c
+++ b/arch/powerpc/perf/core-fsl-emb.c
@@ -365,7 +365,6 @@ static void fsl_emb_pmu_del(struct perf_event *event, int flags)
 static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
 {
 	unsigned long flags;
-	s64 left;
 
 	if (event->hw.idx < 0 || !event->hw.sample_period)
 		return;
@@ -380,8 +379,9 @@ static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
 	perf_pmu_disable(event->pmu);
 
 	event->hw.state = 0;
-	left = local64_read(&event->hw.period_left);
-	write_pmc(event->hw.idx, left);
+
+	/* start the counter. */
+	write_pmlca(event->hw.idx, event->hw.config_base);
 
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
@@ -403,7 +403,9 @@ static void fsl_emb_pmu_stop(struct perf_event *event, int ef_flags)
 
 	fsl_emb_pmu_read(event);
 	event->hw.state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
-	write_pmc(event->hw.idx, 0);
+
+	/* freeze the counter. */
+	write_pmlca(event->hw.idx, event->hw.config_base | PMLCA_FC);
 
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
@@ -575,7 +577,6 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	int record = 0;
 
 	if (event->hw.state & PERF_HES_STOPPED) {
-		write_pmc(event->hw.idx, 0);
 		return;
 	}
 
-- 
1.7.1

