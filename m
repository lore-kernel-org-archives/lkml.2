Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0EQHBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:01:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:40137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0EQHBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:01:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,245,1272870000"; 
   d="scan'208";a="518479462"
Subject: [PATCH -v3] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, masbock@linux.vnet.ibm.com,
       Wu@vger.kernel.org, Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 15:01:15 +0800
Message-ID: <1274079675.3564.573.camel@yhuang-dev.sh.intel.com>
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


Changelog:

v3:

- Make is_hwpoison_address workable for pud_large or pmd_large address.

v2:

- Use page table walker to determine whether the virtual address is
  poisoned to avoid change user space interface (via changing
  get_user_pages).

- Wrap bad page processing into kvm_handle_bad_page to avoid code
  duplicating.

Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kvm/mmu.c         |   34 ++++++++++++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h |    7 ++-----
 include/linux/kvm_host.h   |    1 +
 include/linux/mm.h         |    8 ++++++++
 mm/memory-failure.c        |   30 ++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |   30 ++++++++++++++++++++++++++++--
 6 files changed, 95 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -32,6 +32,7 @@
 #include <linux/compiler.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -1975,6 +1976,27 @@ static int __direct_map(struct kvm_vcpu
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
+static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
+{
+	kvm_release_pfn_clean(pfn);
+	if (is_hwpoison_pfn(pfn)) {
+		kvm_send_hwpoison_signal(kvm, gfn);
+		return 0;
+	}
+	return 1;
+}
+
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
@@ -1998,10 +2020,8 @@ static int nonpaging_map(struct kvm_vcpu
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 
 	/* mmio */
-	if (is_error_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
-		return 1;
-	}
+	if (is_error_pfn(pfn))
+		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
@@ -2204,10 +2224,8 @@ static int tdp_page_fault(struct kvm_vcp
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-	if (is_error_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
-		return 1;
-	}
+	if (is_error_pfn(pfn))
+		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -424,11 +424,8 @@ static int FNAME(page_fault)(struct kvm_
 	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
 
 	/* mmio */
-	if (is_error_pfn(pfn)) {
-		pgprintk("gfn %lx is mmio\n", walker.gfn);
-		kvm_release_pfn_clean(pfn);
-		return 1;
-	}
+	if (is_error_pfn(pfn))
+		return kvm_handle_bad_page(vcpu->kvm, walker.gfn, pfn);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -254,6 +254,7 @@ extern pfn_t bad_pfn;
 
 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
+int is_hwpoison_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1464,6 +1464,14 @@ extern int sysctl_memory_failure_recover
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
+#ifdef CONFIG_MEMORY_FAILURE
+int is_hwpoison_address(unsigned long addr);
+#else
+static inline int is_hwpoison_address(unsigned long addr)
+{
+	return 0;
+}
+#endif
 
 extern void dump_page(struct page *page);
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -45,6 +45,7 @@
 #include <linux/page-isolation.h>
 #include <linux/suspend.h>
 #include <linux/slab.h>
+#include <linux/swapops.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1296,3 +1297,32 @@ done:
 	/* keep elevated page count for bad page */
 	return ret;
 }
+
+int is_hwpoison_address(unsigned long addr)
+{
+	pgd_t *pgdp;
+	pud_t pud, *pudp;
+	pmd_t pmd, *pmdp;
+	pte_t pte, *ptep;
+	swp_entry_t entry;
+
+	pgdp = pgd_offset(current->mm, addr);
+	if (!pgd_present(*pgdp))
+		return 0;
+	pudp = pud_offset(pgdp, addr);
+	pud = *pudp;
+	if (!pud_present(pud) || pud_large(pud))
+		return 0;
+	pmdp = pmd_offset(pudp, addr);
+	pmd = *pmdp;
+	if (!pmd_present(pmd) || pmd_large(pmd))
+		return 0;
+	ptep = pte_offset_map(pmdp, addr);
+	pte = *ptep;
+	pte_unmap(ptep);
+	if (!is_swap_pte(pte))
+		return 0;
+	entry = pte_to_swp_entry(pte);
+	return is_hwpoison_entry(entry);
+}
+EXPORT_SYMBOL_GPL(is_hwpoison_address);
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
@@ -809,16 +812,22 @@ EXPORT_SYMBOL_GPL(kvm_disable_largepages
 
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
@@ -939,6 +948,11 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
+		if (is_hwpoison_address(addr)) {
+			get_page(hwpoison_page);
+			return page_to_pfn(hwpoison_page);
+		}
+
 		down_read(&current->mm->mmap_sem);
 		vma = find_vma(current->mm, addr);
 
@@ -2198,6 +2212,15 @@ int kvm_init(void *opaque, unsigned int
 
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
@@ -2269,6 +2292,8 @@ out_free_1:
 out_free_0a:
 	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
+	if (hwpoison_page)
+		__free_page(hwpoison_page);
 	__free_page(bad_page);
 out:
 	kvm_arch_exit();
@@ -2291,6 +2316,7 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	free_cpumask_var(cpus_hardware_enabled);
+	__free_page(hwpoison_page);
 	__free_page(bad_page);
 }
 EXPORT_SYMBOL_GPL(kvm_exit);


