Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0CQLw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:52:56 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43105 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0CQLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:52:53 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h6bh87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZFCZU-01-60W-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/4] perf/core, x86: reduce number of CONFIG_X86_LOCAL_APIC macros
Date: Wed, 17 Mar 2010 12:49:10 +0100
Message-ID: <1268826553-19518-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 17 Mar 2010 11:52:37.0747 (UTC) FILETIME=[5703AC30:01CAC5C8]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function reserve_pmc_hardware() and release_pmc_hardware() were
hard to read. This patch improves readablity of the code by removing
most of the CONFIG_X86_LOCAL_APIC macros.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5dacf63..793e63f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -313,9 +313,10 @@ again:
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static bool reserve_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -330,11 +331,9 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
-#endif
 
 	return true;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -349,12 +348,10 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
-#endif
 }
 
 static void release_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_events; i++) {
@@ -364,9 +361,15 @@ static void release_pmc_hardware(void)
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
-#endif
 }
 
+#else
+
+static bool reserve_pmc_hardware(void) { return true; }
+static void release_pmc_hardware(void) {}
+
+#endif
+
 static int reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
-- 
1.7.0


