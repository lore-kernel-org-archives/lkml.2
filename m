Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1EJOf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:35:57 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:44676
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255Ab1EJOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:35:54 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZHV9-02-2Y6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] perf, x86: Use GO/HO bits in perf-ctr
Date: Tue, 10 May 2011 16:35:31 +0200
Message-ID: <1305038132-5080-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD perf-counters support counting in guest or host-mode
only. Make use of that feature when user-space specified
guest/host-mode only counting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    3 +++
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index d9d4dae..34047c2 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
+#define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
+
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
 #define INTEL_ARCH_EVENT_MASK	\
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index cf4e369..afc21f3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -116,6 +116,12 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (event->attr.exclude_host)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
+
+	if (event->attr.exclude_guest)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
-- 
1.7.4.1


