Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0FOHgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab0FOHer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:47 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 10/17] Make KVM clock computation work for other scales
Date: Mon, 14 Jun 2010 21:34:12 -1000
Message-Id: <1276587259-32319-11-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
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
 arch/x86/kvm/x86.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05c559d..52d7d34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -882,31 +882,35 @@ static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
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
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
-- 
1.7.1

