Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1DPAfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:35:44 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:12925
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab1DPAfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:35:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJPYZ9-01-0J1-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/4] perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE
Date: Sat, 16 Apr 2011 02:27:55 +0200
Message-ID: <1302913676-14352-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ALTERNATIVE() when checking for X86_FEATURE_PERFCTR_CORE avoids
an extra pointer chase and data cache hit.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..224a84f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/nmi.h>
 #include <asm/compat.h>
 #include <asm/smp.h>
+#include <asm/alternative.h>
 
 #if 0
 #undef wrmsrl
@@ -363,12 +364,18 @@ again:
 	return new_raw_count;
 }
 
-/* using X86_FEATURE_PERFCTR_CORE to later implement ALTERNATIVE() here */
 static inline int x86_pmu_addr_offset(int index)
 {
-	if (boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		return index << 1;
-	return index;
+	int offset;
+
+	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
+	alternative_io(ASM_NOP2,
+		       "shll $1, %%eax",
+		       X86_FEATURE_PERFCTR_CORE,
+		       "=a" (offset),
+		       "a"  (index));
+
+	return offset;
 }
 
 static inline unsigned int x86_pmu_config_addr(int index)
-- 
1.7.3.4


