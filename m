Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2EXDE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:04:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55388 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2EXDE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:04:26 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-8a-4fbda5377e6b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: Make cycles:p working on SNB
Date: Thu, 24 May 2012 12:02:05 +0900
Message-Id: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel SDM (Vol.3B 18-55, Table 18-21) says the PEBS
is only work for INST_RETIRED.PREC_DIST (0x01C0) and it's
applied into intel_snb_pebs_event_constraints already.
Thus, current alt_config which has umake set to 0 cannot
work on SNBs and the output will look like below:

 namhyung@sejong:perf$ ./perf stat -e cycles:p noploop 1

 Performance counter stats for 'noploop 1':

   <not supported> cycles

       1.001116732 seconds time elapsed

After applying this patch, the event is counted properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546ec6aef..db8948171e22 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1329,6 +1329,12 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		 */
 		u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
 
+		/*
+		 * SNB introduced INST_RETIRED.PREC_DIST for this purpose.
+		 */
+		if (x86_pmu.pebs_constraints == intel_snb_pebs_event_constraints)
+			alt_config = X86_CONFIG(.event=0xc0, .umask=0x01,
+						.inv=1, .cmask=16);
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
-- 
1.7.10.1

