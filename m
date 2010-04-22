Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0DVTaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:30:12 -0400
Received: from kroah.org ([198.145.64.141]:41607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0DVTaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:30:00 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:24 2010
Message-Id: <20100422190924.251074663@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [188/197] KVM: Dont spam kernel log when injecting exceptions due to bad cr writes
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

(Cherry-picked from commit d6a23895aa82353788a1cc5a1d9a1c963465463e)

These are guest-triggerable.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -297,21 +297,16 @@ out:
 void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (cr0 & CR0_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
-		       cr0, vcpu->arch.cr0);
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
 
 	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD)) {
-		printk(KERN_DEBUG "set_cr0: #GP, CD == 0 && NW == 1\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
 
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE)) {
-		printk(KERN_DEBUG "set_cr0: #GP, set PG flag "
-		       "and a clear PE flag\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -322,15 +317,11 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu,
 			int cs_db, cs_l;
 
 			if (!is_pae(vcpu)) {
-				printk(KERN_DEBUG "set_cr0: #GP, start paging "
-				       "in long mode while PAE is disabled\n");
 				kvm_inject_gp(vcpu, 0);
 				return;
 			}
 			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 			if (cs_l) {
-				printk(KERN_DEBUG "set_cr0: #GP, start paging "
-				       "in long mode while CS.L == 1\n");
 				kvm_inject_gp(vcpu, 0);
 				return;
 
@@ -338,8 +329,6 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu,
 		} else
 #endif
 		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
-			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
-			       "reserved bits\n");
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
@@ -366,28 +355,23 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu,
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
 
 	if (cr4 & CR4_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
 
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE)) {
-			printk(KERN_DEBUG "set_cr4: #GP, clearing PAE while "
-			       "in long mode\n");
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & pdptr_bits)
 		   && !load_pdptrs(vcpu, vcpu->arch.cr3)) {
-		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
 
 	if (cr4 & X86_CR4_VMXE) {
-		printk(KERN_DEBUG "set_cr4: #GP, setting VMXE\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -408,21 +392,16 @@ void kvm_set_cr3(struct kvm_vcpu *vcpu,
 
 	if (is_long_mode(vcpu)) {
 		if (cr3 & CR3_L_MODE_RESERVED_BITS) {
-			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
 	} else {
 		if (is_pae(vcpu)) {
 			if (cr3 & CR3_PAE_RESERVED_BITS) {
-				printk(KERN_DEBUG
-				       "set_cr3: #GP, reserved bits\n");
 				kvm_inject_gp(vcpu, 0);
 				return;
 			}
 			if (is_paging(vcpu) && !load_pdptrs(vcpu, cr3)) {
-				printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
-				       "reserved bits\n");
 				kvm_inject_gp(vcpu, 0);
 				return;
 			}
@@ -454,7 +433,6 @@ EXPORT_SYMBOL_GPL(kvm_set_cr3);
 void kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
 	if (cr8 & CR8_RESERVED_BITS) {
-		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -508,15 +486,12 @@ static u32 emulated_msrs[] = {
 static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	if (efer & efer_reserved_bits) {
-		printk(KERN_DEBUG "set_efer: 0x%llx #GP, reserved bits\n",
-		       efer);
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
 
 	if (is_paging(vcpu)
 	    && (vcpu->arch.shadow_efer & EFER_LME) != (efer & EFER_LME)) {
-		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -526,7 +501,6 @@ static void set_efer(struct kvm_vcpu *vc
 
 		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
 		if (!feat || !(feat->edx & bit(X86_FEATURE_FXSR_OPT))) {
-			printk(KERN_DEBUG "set_efer: #GP, enable FFXSR w/o CPUID capability\n");
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}
@@ -537,7 +511,6 @@ static void set_efer(struct kvm_vcpu *vc
 
 		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
 		if (!feat || !(feat->ecx & bit(X86_FEATURE_SVM))) {
-			printk(KERN_DEBUG "set_efer: #GP, enable SVM w/o SVM\n");
 			kvm_inject_gp(vcpu, 0);
 			return;
 		}


