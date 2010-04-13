Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0DMU1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:50 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:12693 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0DMU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:55 -0400
X-SpamScore: 9
X-BigFish: VPS9(zba6l37d4lzab9bhzz1202hzzz32i6bh2a8h87h467h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SH-01-CB3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/12] perf, x86: call x86_setup_perfctr() from .hw_config()
Date: Tue, 13 Apr 2010 22:23:12 +0200
Message-ID: <1271190201-25705-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0449 (UTC) FILETIME=[9CDED290:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perfctr setup calls are in the corresponding .hw_config()
functions now. This makes it possible to introduce config functions
for other pmu events that are not perfctr specific.

Also, all of a sudden the code looks much nicer.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c    |    9 ++-------
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 84b6107..5945128 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -505,7 +505,7 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-	return 0;
+	return x86_setup_perfctr(event);
 }
 
 /*
@@ -543,12 +543,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
-	/* Processor specifics */
-	err = x86_pmu.hw_config(event);
-	if (err)
-		return err;
-
-	return x86_setup_perfctr(event);
+	return x86_pmu.hw_config(event);
 }
 
 static void x86_pmu_disable_all(void)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 15367cc..9e00205 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -455,7 +455,7 @@ static int p4_hw_config(struct perf_event *event)
 		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 
-	return 0;
+	return x86_setup_perfctr(event);
 }
 
 static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
-- 
1.7.0.3


