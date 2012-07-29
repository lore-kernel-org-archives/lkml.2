Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2G2INJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:13:09 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38574 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2G2INF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:13:05 -0400
Message-ID: <5014F08A.7030408@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:12:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/9] KVM: define kvm_fault_pfn statically
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-5490-0000-0000-000001DDF4A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After that, the exported and un-inline function, get_fault_pfn,
can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |    2 +-
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/kvm_main.c      |   12 +++---------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a9a2052..19bac91 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2514,7 +2514,7 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,

 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
 	if (!slot)
-		return get_fault_pfn();
+		return kvm_fault_pfn;

 	hva = gfn_to_hva_memslot(slot, gfn);

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dbc65f9..7cd6871 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -48,6 +48,8 @@
 #define KVM_MAX_MMIO_FRAGMENTS \
 	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)

+#define kvm_fault_pfn	(-EFAULT)
+
 /*
  * vcpu->requests bit members
  */
@@ -444,7 +446,6 @@ void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
 void kvm_set_pfn_accessed(pfn_t pfn);
 void kvm_get_pfn(pfn_t pfn);
-pfn_t get_fault_pfn(void);

 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bcf973e..2117aa8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -948,12 +948,6 @@ static pfn_t get_bad_pfn(void)
 	return -ENOENT;
 }

-pfn_t get_fault_pfn(void)
-{
-	return -EFAULT;
-}
-EXPORT_SYMBOL_GPL(get_fault_pfn);
-
 static pfn_t get_hwpoison_pfn(void)
 {
 	return -EHWPOISON;
@@ -1124,7 +1118,7 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		struct vm_area_struct *vma;

 		if (atomic)
-			return get_fault_pfn();
+			return kvm_fault_pfn;

 		down_read(&current->mm->mmap_sem);
 		if (npages == -EHWPOISON ||
@@ -1136,7 +1130,7 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		vma = find_vma_intersection(current->mm, addr, addr+1);

 		if (vma == NULL)
-			pfn = get_fault_pfn();
+			pfn = kvm_fault_pfn;
 		else if ((vma->vm_flags & VM_PFNMAP)) {
 			pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) +
 				vma->vm_pgoff;
@@ -1144,7 +1138,7 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		} else {
 			if (async && (vma->vm_flags & VM_WRITE))
 				*async = true;
-			pfn = get_fault_pfn();
+			pfn = kvm_fault_pfn;
 		}
 		up_read(&current->mm->mmap_sem);
 	} else
-- 
1.7.7.6

