Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2DEQZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:25:10 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:3142 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247Ab2DEQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:25:07 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3416lzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LLK-01-4HZ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf, x86: Fix cmpxchg() usage in amd_put_event_constraints()
Date: Thu, 5 Apr 2012 18:24:42 +0200
Message-ID: <1333643084-26776-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the return value of cmpxchg() is used to match an event. The
change removes the duplicate event comparison and traverses the list
until an event was removed. This also fixes the following warning:

 arch/x86/kernel/cpu/perf_event_amd.c:170: warning: value computed is not used

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4be3463..6565226 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -210,10 +210,8 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	 * when we come here
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (nb->owners[i] == event) {
-			cmpxchg(nb->owners+i, event, NULL);
+		if (cmpxchg(nb->owners + i, event, NULL) == event)
 			break;
-		}
 	}
 }
 
-- 
1.7.8.4


