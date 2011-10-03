Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1JCNuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab1JCNuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:40 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 2/9] perf, amd: Use GO/HO bits in perf-ctr
Date: Mon,  3 Oct 2011 15:49:48 +0200
Message-Id: <1317649795-18259-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-1-git-send-email-gleb@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The AMD perf-counters support counting in guest or host-mode
only. Make use of that feature when user-space specified
guest/host-mode only counting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/perf_event.h    |    3 +++
 arch/x86/kernel/cpu/perf_event_amd.c |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 094fb30..ce2bfb3 100644
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
index 941caa2..5c01a73 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,6 +132,19 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (event->attr.exclude_host && event->attr.exclude_guest)
+		/*
+		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
+		 * and will count in both modes. We don't want to count in that
+		 * case so we emulate no-counting by setting US = OS = 0.
+		 */
+		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
+				      ARCH_PERFMON_EVENTSEL_OS);
+	else if (event->attr.exclude_host)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
+	else if (event->attr.exclude_guest)
+		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
-- 
1.7.5.3

