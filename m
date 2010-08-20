Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab0HTIIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0HTIIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:04 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 01/35] Drop vm_init_tsc
Date: Thu, 19 Aug 2010 22:07:15 -1000
Message-Id: <1282291669-25709-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used only by the VMX code, and is not done properly;
if the TSC is indeed backwards, it is out of sync, and will
need proper handling in the logic at each and every CPU change.
For now, drop this test during init as misguided.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/vmx.c              |   10 +++-------
 arch/x86/kvm/x86.c              |    2 --
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 502e53f..960f9c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -394,7 +394,6 @@ struct kvm_arch {
 	gpa_t ept_identity_map_addr;
 
 	unsigned long irq_sources_bitmap;
-	u64 vm_init_tsc;
 	s64 kvmclock_offset;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cf56462..a8753e1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2518,7 +2518,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
 	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
-	u64 host_pat, tsc_this, tsc_base;
+	u64 host_pat, tsc_this;
 	unsigned long a;
 	struct desc_ptr dt;
 	int i;
@@ -2659,12 +2659,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
-	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
-	rdtscll(tsc_this);
-	if (tsc_this < vmx->vcpu.kvm->arch.vm_init_tsc)
-		tsc_base = tsc_this;
-
-	guest_write_tsc(0, tsc_base);
+	tsc_this = native_read_tsc();
+	guest_write_tsc(0, tsc_this);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d5ac966..1bf9227 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5495,8 +5495,6 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	rdtscll(kvm->arch.vm_init_tsc);
-
 	return kvm;
 }
 
-- 
1.7.1

