Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab1KCMdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247Ab1KCMcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:32:32 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCH 7/9] KVM: Expose the architectural performance monitoring CPUID leaf
Date: Thu,  3 Nov 2011 14:31:36 +0200
Message-Id: <1320323498-10233-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323498-10233-1-git-send-email-gleb@redhat.com>
References: <1320323498-10233-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Provide a CPUID leaf that describes the emulated PMU.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/x86.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ea4cb8..56153a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2543,6 +2543,28 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	case 9:
 		break;
+	case 0xa: { /* Architectural Performance Monitoring */
+		struct x86_pmu_capability cap;
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
+		entry->eax = min(cap.version, 2)
+			| (cap.num_counters_gp << 8)
+			| (cap.bit_width_gp << 16)
+			| (cap.events_mask_len << 24);
+		entry->ebx = cap.events_mask;
+		entry->ecx = 0;
+		entry->edx = cap.num_counters_fixed
+			| (cap.bit_width_fixed << 5);
+		break;
+	}
 	/* function 0xb has additional index. */
 	case 0xb: {
 		int i, level_type;
@@ -2637,7 +2659,6 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 3: /* Processor serial number */
 	case 5: /* MONITOR/MWAIT */
 	case 6: /* Thermal management */
-	case 0xA: /* Architectural Performance Monitoring */
 	case 0x80000007: /* Advanced power management */
 	case 0xC0000002:
 	case 0xC0000003:
-- 
1.7.5.3

