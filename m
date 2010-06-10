Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0FJLLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880Ab0FJLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:56 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: avi@redhat.com, kvm@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [19/23] KVM: Fix unused but set warnings
Message-Id: <20100610111055.4FB51B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No real bugs in this one, the real bug I found is in a separate
patch.

Cc: avi@redhat.com
Cc: kvm@vger.kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/paging_tmpl.h |    1 +
 arch/x86/kvm/vmx.c         |    3 +--
 virt/kvm/assigned-dev.c    |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/kvm/paging_tmpl.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kvm/paging_tmpl.h
+++ linux-2.6.35-rc2-gcc/arch/x86/kvm/paging_tmpl.h
@@ -442,6 +442,7 @@ static int FNAME(page_fault)(struct kvm_
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn);
+	(void)sptep;
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
 
Index: linux-2.6.35-rc2-gcc/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kvm/vmx.c
+++ linux-2.6.35-rc2-gcc/arch/x86/kvm/vmx.c
@@ -1624,10 +1624,9 @@ static void enter_pmode(struct kvm_vcpu
 static gva_t rmode_tss_base(struct kvm *kvm)
 {
 	if (!kvm->arch.tss_addr) {
-		struct kvm_memslots *slots;
 		gfn_t base_gfn;
 
-		slots = kvm_memslots(kvm);
+		kvm_memslots(kvm);
 		base_gfn = kvm->memslots->memslots[0].base_gfn +
 				 kvm->memslots->memslots[0].npages - 3;
 		return base_gfn << PAGE_SHIFT;
Index: linux-2.6.35-rc2-gcc/virt/kvm/assigned-dev.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/virt/kvm/assigned-dev.c
+++ linux-2.6.35-rc2-gcc/virt/kvm/assigned-dev.c
@@ -58,12 +58,10 @@ static int find_index_from_host_irq(stru
 static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev;
-	struct kvm *kvm;
 	int i;
 
 	assigned_dev = container_of(work, struct kvm_assigned_dev_kernel,
 				    interrupt_work);
-	kvm = assigned_dev->kvm;
 
 	spin_lock_irq(&assigned_dev->assigned_dev_lock);
 	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
