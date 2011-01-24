Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1AXSKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:10:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1AXSIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:04 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 09/16] KVM-HV: Implement kvmclock systemtime over KVM - KVM Virtual Memory
Date: Mon, 24 Jan 2011 13:06:30 -0500
Message-Id: <1295892397-11354-10-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a proof of concept to KVM - Kernel Virtual Memory, this patch
implements kvmclock per-vcpu systime grabbing on top of it. At first, it
may seem as a waste of work to just redo it, since it is working well. But over
the time, other MSRs were added - think ASYNC_PF - and more will probably come.
After this patch, we won't need to ever add another virtual MSR to KVM.

If the hypervisor fails to register the memory area, we switch back to legacy
behavior on things that were already present - like kvm clock.

This patch contains the hypervisor part for it. I am keeping it separate from
the headers to facilitate backports to people who wants to backport the kernel part
but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   55 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a232a36..81b2f34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1453,6 +1453,33 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
+static void kvmclock_register_page(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (vcpu->arch.time_page) {
+		kvm_release_page_dirty(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+
+	vcpu->arch.time = data;
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+
+	/* we verify if the enable bit is set... */
+	if (!(data & 1))
+		return;
+
+	/* ...but clean it before doing the actual write */
+	vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+
+	vcpu->arch.time_page =
+			gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
+
+	if (is_error_page(vcpu->arch.time_page)) {
+		kvm_release_page_clean(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+}
+
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
@@ -1510,28 +1537,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
-		if (vcpu->arch.time_page) {
-			kvm_release_page_dirty(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
-
-		vcpu->arch.time = data;
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-		/* we verify if the enable bit is set... */
-		if (!(data & 1))
-			break;
-
-		/* ...but clean it before doing the actual write */
-		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
-
-		vcpu->arch.time_page =
-				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
-
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
+		kvmclock_register_page(vcpu, data);
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
@@ -1553,6 +1559,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			goto rma_out;
 		}
 
+		if (area_desc.type == KVM_AREA_SYSTIME) {
+			kvmclock_register_page(vcpu, area_desc.base | 1);
+			goto rma_out;
+		}
+
 		if (vcpu->kvm->register_mem_area_uspace) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_MSR_OP;
 			vcpu->run->msr.msr_data = data;
-- 
1.7.2.3

