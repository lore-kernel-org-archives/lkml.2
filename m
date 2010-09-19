Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0ISAiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab0ISAiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:38:22 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping fixes 2/4] Make math work for other scales
Date: Sat, 18 Sep 2010 14:38:13 -1000
Message-Id: <1284856695-19438-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
References: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The math in kvm_get_time_scale relies on the fact that
NSEC_PER_SEC < 2^32.  To use the same function to compute
arbitrary time scales, we must extend the first reduction
step to shrink the base rate to a 32-bit value, and
possibly reduce the scaled rate into a 32-bit as well.

Note we must take care to avoid an arithmetic overflow
when scaling up the tps32 value (this could not happen
with the fixed scaled value of NSEC_PER_SEC, but can
happen with scaled rates above 2^31.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b021e1..f92401f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -920,31 +920,35 @@ static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
 	return quotient;
 }
 
-static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *hv_clock)
+static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
+			       s8 *pshift, u32 *pmultiplier)
 {
-	uint64_t nsecs = 1000000000LL;
+	uint64_t scaled64;
 	int32_t  shift = 0;
 	uint64_t tps64;
 	uint32_t tps32;
 
-	tps64 = tsc_khz * 1000LL;
-	while (tps64 > nsecs*2) {
+	tps64 = base_khz * 1000LL;
+	scaled64 = scaled_khz * 1000LL;
+	while (tps64 > scaled64*2 || tps64 & 0xffffffff00000000UL) {
 		tps64 >>= 1;
 		shift--;
 	}
 
 	tps32 = (uint32_t)tps64;
-	while (tps32 <= (uint32_t)nsecs) {
-		tps32 <<= 1;
+	while (tps32 <= scaled64 || scaled64 & 0xffffffff00000000UL) {
+		if (scaled64 & 0xffffffff00000000UL || tps32 & 0x80000000)
+			scaled64 >>= 1;
+		else
+			tps32 <<= 1;
 		shift++;
 	}
 
-	hv_clock->tsc_shift = shift;
-	hv_clock->tsc_to_system_mul = div_frac(nsecs, tps32);
+	*pshift = shift;
+	*pmultiplier = div_frac(scaled64, tps32);
 
-	pr_debug("%s: tsc_khz %u, tsc_shift %d, tsc_mul %u\n",
-		 __func__, tsc_khz, hv_clock->tsc_shift,
-		 hv_clock->tsc_to_system_mul);
+	pr_debug("%s: base_khz %u => %u, shift %d, mul %u\n",
+		 __func__, base_khz, scaled_khz, shift, *pmultiplier);
 }
 
 static inline u64 get_kernel_ns(void)
@@ -1084,7 +1088,9 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	}
 
 	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
-		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
+		kvm_get_time_scale(NSEC_PER_SEC / 1000, this_tsc_khz,
+				   &vcpu->hv_clock.tsc_shift,
+				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz = this_tsc_khz;
 	}
 
-- 
1.6.6.1

