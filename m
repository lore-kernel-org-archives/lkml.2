Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab0GAU6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:58:34 -0400
Received: from kroah.org ([198.145.64.141]:47987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab0GAUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:36 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:40 2010
Message-Id: <20100701173439.958836610@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 156/164] KVM: PPC: Add missing vcpu_load()/vcpu_put() in vcpu ioctls
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 98001d8d017cea1ee0f9f35c6227bbd63ef5005b)
---
 arch/powerpc/kvm/book3s.c |   10 ++++++++++
 arch/powerpc/kvm/booke.c  |   15 ++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -766,6 +766,8 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	int i;
 
+	vcpu_load(vcpu);
+
 	sregs->pvr = vcpu->arch.pvr;
 
 	sregs->u.s.sdr1 = to_book3s(vcpu)->sdr1;
@@ -784,6 +786,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct
 			sregs->u.s.ppc32.dbat[i] = vcpu3s->dbat[i].raw;
 		}
 	}
+
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -793,6 +798,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	int i;
 
+	vcpu_load(vcpu);
+
 	kvmppc_set_pvr(vcpu, sregs->pvr);
 
 	vcpu3s->sdr1 = sregs->u.s.sdr1;
@@ -819,6 +826,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 
 	/* Flush the MMU after messing with the segments */
 	kvmppc_mmu_pte_flush(vcpu, 0, 0);
+
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -443,6 +443,8 @@ int kvm_arch_vcpu_ioctl_get_regs(struct
 {
 	int i;
 
+	vcpu_load(vcpu);
+
 	regs->pc = vcpu->arch.pc;
 	regs->cr = vcpu->arch.cr;
 	regs->ctr = vcpu->arch.ctr;
@@ -463,6 +465,8 @@ int kvm_arch_vcpu_ioctl_get_regs(struct
 	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
 		regs->gpr[i] = vcpu->arch.gpr[i];
 
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -470,6 +474,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct
 {
 	int i;
 
+	vcpu_load(vcpu);
+
 	vcpu->arch.pc = regs->pc;
 	vcpu->arch.cr = regs->cr;
 	vcpu->arch.ctr = regs->ctr;
@@ -489,6 +495,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct
 	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
 		vcpu->arch.gpr[i] = regs->gpr[i];
 
+	vcpu_put(vcpu);
+
 	return 0;
 }
 
@@ -517,7 +525,12 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
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


