Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0GMC02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0GMC0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:26:21 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 17/18] Indicate reliable TSC in kvmclock
Date: Mon, 12 Jul 2010 16:25:37 -1000
Message-Id: <1278987938-23873-18-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
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
index e73ddf6..b3cc186 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -55,6 +55,7 @@
 #include <asm/mce.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
+#include <asm/pvclock-abi.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -902,6 +903,13 @@ static inline int kvm_tsc_changes_freq(void)
 	return ret;
 }
 
+static inline int kvm_tsc_reliable(void)
+{
+	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+		!check_tsc_unstable());
+}
+
 static inline u64 nsec_to_cycles(u64 nsec)
 {
 	WARN_ON(preemptible());
@@ -1025,7 +1033,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_kernel_ns = kernel_ns;
-	vcpu->hv_clock.flags = 0;
+	vcpu->hv_clock.flags = kvm_tsc_reliable() ? PVCLOCK_TSC_STABLE_BIT : 0;
 
 	/*
 	 * The interface expects us to write an even number signaling that the
-- 
1.7.1

