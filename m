Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2DBSUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:12 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:10136
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab2DBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:04 -0400
X-SpamScore: 12
X-BigFish: VPS12(z3edbo63cmzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6XA-01-AHM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/12] perf/x86-ibs: Trigger overflow if remaining period is too small
Date: Mon, 2 Apr 2012 20:19:14 +0200
Message-ID: <1333390758-10893-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where the remaining period is smaller than the minimal
possible value. In this case the counter is restarted with the minimal
period. This is of no use as the interrupt handler will trigger
immediately again and most likely hits itself. This biases the
results.

So, if the remaining period is within the min range, we better do not
restart the counter and instead trigger the overflow.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 6591b77..1f53f16 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -78,16 +78,13 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_perio
 		overflow = 1;
 	}
 
-	if (unlikely(left <= 0)) {
+	if (unlikely(left < (s64)min)) {
 		left += period;
 		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		overflow = 1;
 	}
 
-	if (unlikely(left < min))
-		left = min;
-
 	if (left > max)
 		left = max;
 
-- 
1.7.8.4


