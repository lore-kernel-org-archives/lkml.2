Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1FUABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab1FUAAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:06 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 5/9] Add last_host_tsc tracking back to KVM
Date: Mon, 20 Jun 2011 16:59:33 -0700
Message-Id: <1308614377-18627-6-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable last_host_tsc was removed from upstream code.  I am adding
it back for two reasons.  First, it is unnecessary to use guest TSC
computation to conclude information about the host TSC.  The guest may
set the TSC backwards (this case handled by the previous patch), but
the computation of guest TSC (and fetching an MSR) is significanlty more
work and complexity than simply reading the hardware counter.  In addition,
we don't actually need the guest TSC for any part of the computation,
by always recomputing the offset, we can eliminate the need to deal with
the current offset and any scaling factors that may apply.

The second reason is that later on, we are going to be using the host
TSC value to restore TSC offsets after a host S4 suspend, so we need to
be reading the host values, not the guest values here.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 865f051..3b9fdb5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -393,6 +393,7 @@ struct kvm_vcpu_arch {
 	u64 last_kernel_ns;
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
+	u64 last_host_tsc;
 	bool tsc_catchup;
 	bool tsc_always_catchup;
 	s8 virtual_tsc_shift;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bd2ca3..8fe988a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2154,11 +2154,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
 		/* Make sure TSC doesn't go backwards */
-		s64 tsc_delta;
-		u64 tsc;
-
-		kvm_get_msr(vcpu, MSR_IA32_TSC, &tsc);
-		tsc_delta = tsc - vcpu->arch.last_guest_tsc;
+		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
+				native_read_tsc() - vcpu->arch.last_host_tsc;
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 		if (check_tsc_unstable()) {
@@ -2178,7 +2175,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
-	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+	vcpu->arch.last_host_tsc = native_read_tsc();
 }
 
 static int is_efer_nx(void)
-- 
1.7.1

