Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0D0HEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:04:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:45132 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0D0HEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:04:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,278,1270450800"; 
   d="scan'208";a="270455965"
Subject: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, masbock@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 15:04:20 +0800
Message-ID: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In common cases, guest SRAO MCE will cause corresponding poisoned page
be un-mapped and SIGBUS be sent to QEMU-KVM, then QEMU-KVM will relay
the MCE to guest OS.

But it is reported that if the poisoned page is accessed in guest
after un-mapped and before MCE is relayed to guest OS, QEMU-KVM will
be killed.

The reason is as follow. Because poisoned page has been un-mapped,
guest access will cause guest exit and kvm_mmu_page_fault will be
called. kvm_mmu_page_fault can not get the poisoned page for fault
address, so kernel and user space MMIO processing is tried in turn. In
user MMIO processing, poisoned page is accessed again, then QEMU-KVM
is killed by force_sig_info.

To fix the bug, kvm_mmu_page_fault send HWPOISON signal to QEMU-KVM
and do not try kernel and user space MMIO processing for poisoned
page.

Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kvm/mmu.c         |   24 ++++++++++++++++++++++--
 arch/x86/kvm/paging_tmpl.h |   10 ++++++++--
 include/linux/kvm_host.h   |    1 +
 virt/kvm/kvm_main.c        |   30 ++++++++++++++++++++++++++++--
 4 files changed, 59 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -32,6 +32,7 @@
 #include <linux/compiler.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -1972,6 +1973,17 @@ static int __direct_map(struct kvm_vcpu
 	return pt_write;
 }
 
+static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
+{
+	char buf[1];
+	void __user *hva;
+	int r;
+
+	/* Touch the page, so send SIGBUS */
+	hva = (void __user *)gfn_to_hva(kvm, gfn);
+	r = copy_from_user(buf, hva, 1);
+}
+
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
@@ -1997,7 +2009,11 @@ static int nonpaging_map(struct kvm_vcpu
 	/* mmio */
 	if (is_error_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
-		return 1;
+		if (is_hwpoison_pfn(pfn)) {
+			kvm_send_hwpoison_signal(vcpu->kvm, gfn);
+			return 0;
+		} else
+			return 1;
 	}
 
 	spin_lock(&vcpu->kvm->mmu_lock);
@@ -2203,7 +2219,11 @@ static int tdp_page_fault(struct kvm_vcp
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	if (is_error_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
-		return 1;
+		if (is_hwpoison_pfn(pfn)) {
+			kvm_send_hwpoison_signal(vcpu->kvm, gfn);
+			return 0;
+		} else
+			return 1;
 	}
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -425,9 +425,15 @@ static int FNAME(page_fault)(struct kvm_
 
 	/* mmio */
 	if (is_error_pfn(pfn)) {
-		pgprintk("gfn %lx is mmio\n", walker.gfn);
 		kvm_release_pfn_clean(pfn);
-		return 1;
+		if (is_hwpoison_pfn(pfn)) {
+			pgprintk("gfn %lx is hwpoisoned\n", walker.gfn);
+			kvm_send_hwpoison_signal(vcpu->kvm, walker.gfn);
+			return 0;
+		} else {
+			pgprintk("gfn %lx is mmio\n", walker.gfn);
+			return 1;
+		}
 	}
 
 	spin_lock(&vcpu->kvm->mmu_lock);
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -249,6 +249,7 @@ extern pfn_t bad_pfn;
 
 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
+int is_hwpoison_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -92,6 +92,9 @@ static bool kvm_rebooting;
 
 static bool largepages_enabled = true;
 
+struct page *hwpoison_page;
+pfn_t hwpoison_pfn;
+
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
@@ -805,16 +808,22 @@ EXPORT_SYMBOL_GPL(kvm_disable_largepages
 
 int is_error_page(struct page *page)
 {
-	return page == bad_page;
+	return page == bad_page || page == hwpoison_page;
 }
 EXPORT_SYMBOL_GPL(is_error_page);
 
 int is_error_pfn(pfn_t pfn)
 {
-	return pfn == bad_pfn;
+	return pfn == bad_pfn || pfn == hwpoison_pfn;
 }
 EXPORT_SYMBOL_GPL(is_error_pfn);
 
+int is_hwpoison_pfn(pfn_t pfn)
+{
+	return pfn == hwpoison_pfn;
+}
+EXPORT_SYMBOL_GPL(is_hwpoison_pfn);
+
 static inline unsigned long bad_hva(void)
 {
 	return PAGE_OFFSET;
@@ -935,6 +944,11 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
+		if (npages == -EHWPOISON) {
+			get_page(hwpoison_page);
+			return page_to_pfn(hwpoison_page);
+		}
+
 		down_read(&current->mm->mmap_sem);
 		vma = find_vma(current->mm, addr);
 
@@ -2191,6 +2205,15 @@ int kvm_init(void *opaque, unsigned int
 
 	bad_pfn = page_to_pfn(bad_page);
 
+	hwpoison_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (hwpoison_page == NULL) {
+		r = -ENOMEM;
+		goto out_free_0;
+	}
+
+	hwpoison_pfn = page_to_pfn(hwpoison_page);
+
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto out_free_0;
@@ -2262,6 +2285,8 @@ out_free_1:
 out_free_0a:
 	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
+	if (hwpoison_page)
+		__free_page(hwpoison_page);
 	__free_page(bad_page);
 out:
 	kvm_arch_exit();
@@ -2284,6 +2309,7 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	free_cpumask_var(cpus_hardware_enabled);
+	__free_page(hwpoison_page);
 	__free_page(bad_page);
 }
 EXPORT_SYMBOL_GPL(kvm_exit);


