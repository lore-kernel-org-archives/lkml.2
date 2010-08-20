Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0HTIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0HTIJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:23 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 33/35] Indicate reliable TSC in kvmclock
Date: Thu, 19 Aug 2010 22:07:47 -1000
Message-Id: <1282291669-25709-34-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When no platform bugs have been detected, no TSC warps have been
detected, and the hardware guarantees to us TSC does not change
rate or stop with P-state or C-state changes, we can consider it reliable.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86f182a..a7fa24e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -55,6 +55,7 @@
 #include <asm/mce.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
+#include <asm/pvclock-abi.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -900,6 +901,13 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 unsigned long max_tsc_khz;
 
+static inline int kvm_tsc_reliable(void)
+{
+	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+		!check_tsc_unstable());
+}
+
 static inline u64 nsec_to_cycles(struct kvm *kvm, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, kvm->arch.virtual_tsc_mult,
@@ -1151,7 +1159,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_kernel_ns = kernel_ns;
-	vcpu->hv_clock.flags = 0;
+	vcpu->hv_clock.flags = kvm_tsc_reliable() ? PVCLOCK_TSC_STABLE_BIT : 0;
 
 	/*
 	 * The interface expects us to write an even number signaling that the
-- 
1.7.1

