Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0KZDEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:04:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62286 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0KZDEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IPkDy+cKxkKZfcdbJs66tf6E7W/alEr9CIK1YMW9T3KAMqvs7iPmsxDc4k8y0Rj9CI
         A87o135b+QmZTZ8f4IobaOpCySDp0BW6YRaZoH/UinE7T4JaqktyTt2gWlfIFNDCp4uy
         1ixsSsxH3dO/6DIm5Kluz6A7zk74N9sTTm430=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH v2 3/5] MIPS/Perf-events: Fix event check in validate_event()
Date: Fri, 26 Nov 2010 11:05:05 +0800
Message-Id: <1290740707-32586-4-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore events that are in off/error state or belong to a different PMU.

This patch originates from the following commit for ARM by Will Deacon:

65b4711ff513767341aa1915c822de6ec0de65cb
	ARM: 6352/1: perf: fix event validation

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 1ee44a3..3d55761 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -486,8 +486,9 @@ static int validate_event(struct cpu_hw_events *cpuc,
 {
 	struct hw_perf_event fake_hwc = event->hw;
 
-	if (event->pmu && event->pmu != &pmu)
-		return 0;
+	/* Allow mixed event group. So return 1 to pass validation. */
+	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
+		return 1;
 
 	return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
 }
-- 
1.7.1

