Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab1KJNAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:00:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649Ab1KJM6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:58:09 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv3 08/10] KVM: Expose the architectural performance monitoring CPUID leaf
Date: Thu, 10 Nov 2011 14:57:28 +0200
Message-Id: <1320929850-10480-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a CPUID leaf that describes the emulated PMU.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/x86.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b88426c..2c44b05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2544,6 +2544,35 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	case 9:
 		break;
+	case 0xa: { /* Architectural Performance Monitoring */
+		struct x86_pmu_capability cap;
+		union cpuid10_eax eax;
+		union cpuid10_edx edx;
+
+		perf_get_x86_pmu_capability(&cap);
+
+		/*
+		 * Only support guest architectural pmu on a host
+		 * with architectural pmu.
+		 */
+		if (!cap.version)
+			memset(&cap, 0, sizeof(cap));
+
+		eax.split.version_id = min(cap.version, 2);
+		eax.split.num_counters = cap.num_counters_gp;
+		eax.split.bit_width = cap.bit_width_gp;
+		eax.split.mask_length = cap.events_mask_len;
+
+		edx.split.num_counters_fixed = cap.num_counters_fixed;
+		edx.split.bit_width_fixed = cap.bit_width_fixed;
+		edx.split.reserved = 0;
+
+		entry->eax = eax.full;
+		entry->ebx = cap.events_mask;
+		entry->ecx = 0;
+		entry->edx = edx.full;
+		break;
+	}
 	/* function 0xb has additional index. */
 	case 0xb: {
 		int i, level_type;
@@ -2638,7 +2667,6 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 3: /* Processor serial number */
 	case 5: /* MONITOR/MWAIT */
 	case 6: /* Thermal management */
-	case 0xA: /* Architectural Performance Monitoring */
 	case 0x80000007: /* Advanced power management */
 	case 0xC0000002:
 	case 0xC0000003:
-- 
1.7.7.1

