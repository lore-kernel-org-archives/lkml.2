Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2DBSUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:03 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14841 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab2DBST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:19:59 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X2-02-33J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/12] perf/x86-ibs: Catch spurious interrupts after stopping ibs
Date: Mon, 2 Apr 2012 20:19:17 +0200
Message-ID: <1333390758-10893-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After disabling IBS there could be still incomming NMIs with samples
that even have the valid bit cleared. Mark all this NMIs as handled to
avoid spurious interrupt messages.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 35a35be..b44aa63 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -475,11 +475,13 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	u64 *buf, *config, period;
 
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
-		/* Catch spurious interrupts after stopping IBS: */
-		if (!test_and_clear_bit(IBS_STOPPING, pcpu->state))
-			return 0;
-		rdmsrl(perf_ibs->msr, *ibs_data.regs);
-		return (*ibs_data.regs & perf_ibs->valid_mask) ? 1 : 0;
+		/*
+		 * Catch spurious interrupts after stopping IBS: After
+		 * disabling IBS there could be still incomming NMIs
+		 * with samples that even have the valid bit cleared.
+		 * Mark all this NMIs as handled.
+		 */
+		return test_and_clear_bit(IBS_STOPPING, pcpu->state) ? 1 : 0;
 	}
 
 	msr = hwc->config_base;
-- 
1.7.8.4


