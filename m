Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab0GAV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:27:18 -0400
Received: from kroah.org ([198.145.64.141]:33279 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0GAVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:03 2010
Message-Id: <20100701174302.978073077@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [195/200] KVM: PPC: Add missing vcpu_load()/vcpu_put() in vcpu ioctls
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 98001d8d017cea1ee0f9f35c6227bbd63ef5005b)
---
 arch/powerpc/kvm/book3s.c |   10 ++++++++++
 arch/powerpc/kvm/booke.c  |   15 ++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -922,6 +922,8 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	int i;
 
+	vcpu_load(vcpu);
+
 	sregs->pvr = vcpu->arch.pvr;
 
 	sregs->u.s.sdr1 = to_book3s(vcpu)->sdr1;
@@ -940,6 +942,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct
 			sregs->u.s.ppc32.dbat[i] = vcpu3s->dbat[i].raw;
 		}
 	}
+
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -949,6 +954,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	int i;
 
+	vcpu_load(vcpu);
+
 	kvmppc_set_pvr(vcpu, sregs->pvr);
 
 	vcpu3s->sdr1 = sregs->u.s.sdr1;
@@ -975,6 +982,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 
 	/* Flush the MMU after messing with the segments */
 	kvmppc_mmu_pte_flush(vcpu, 0, 0);
+
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -479,6 +479,8 @@ int kvm_arch_vcpu_ioctl_get_regs(struct
 {
 	int i;
 
+	vcpu_load(vcpu);
+
 	regs->pc = vcpu->arch.pc;
 	regs->cr = kvmppc_get_cr(vcpu);
 	regs->ctr = vcpu->arch.ctr;
@@ -499,6 +501,8 @@ int kvm_arch_vcpu_ioctl_get_regs(struct
 	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
 		regs->gpr[i] = kvmppc_get_gpr(vcpu, i);
 
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -506,6 +510,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct
 {
 	int i;
 
+	vcpu_load(vcpu);
+
 	vcpu->arch.pc = regs->pc;
 	kvmppc_set_cr(vcpu, regs->cr);
 	vcpu->arch.ctr = regs->ctr;
@@ -525,6 +531,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct
 	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
 		kvmppc_set_gpr(vcpu, i, regs->gpr[i]);
 
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -553,7 +561,12 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
                                   struct kvm_translation *tr)
 {
-	return kvmppc_core_vcpu_translate(vcpu, tr);
+	int r;
+
+	vcpu_load(vcpu);
+	r = kvmppc_core_vcpu_translate(vcpu, tr);
+	vcpu_put(vcpu);
+	return r;
 }
 
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)


