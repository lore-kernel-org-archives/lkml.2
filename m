Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2DBSUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:07 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:59720
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab2DBSUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:05 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X7-02-33R-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/12] perf/x86-ibs: Extend hw period that triggers overflow
Date: Mon, 2 Apr 2012 20:19:15 +0200
Message-ID: <1333390758-10893-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the last hw period is too short we might hit the irq handler which
biases the results. Thus try to have a max last period that triggers
the sw overflow.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 1f53f16..f0271dd 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -85,8 +85,19 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_perio
 		overflow = 1;
 	}
 
-	if (left > max)
-		left = max;
+	/*
+	 * If the hw period that triggers the sw overflow is too short
+	 * we might hit the irq handler. This biases the results.
+	 * Thus we shorten the next-to-last period and set the last
+	 * period to the max period.
+	 */
+	if (left > max) {
+		left -= max;
+		if (left > max)
+			left = max;
+		else if (left < min)
+			left = min;
+	}
 
 	*hw_period = (u64)left;
 
-- 
1.7.8.4


