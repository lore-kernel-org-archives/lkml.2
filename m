Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0LVCxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 21:53:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:52614 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0LVCws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 21:52:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,210,1291622400"; 
   d="scan'208";a="639093834"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, Dean Nelson <dnelson@redhat.com>
Subject: [RFC 3/3] KVM, HWPoison, unpoison address across rebooting
Date: Wed, 22 Dec 2010 10:51:57 +0800
Message-Id: <1292986317-2805-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
References: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In HWPoison processing code, not only the struct page corresponding
the error physical memory page is marked as HWPoison, but also the
virtual address in processes mapping the error physical memory page is
marked as HWPoison.  So that, the further accessing to the virtual
address will kill corresponding processes with SIGBUS.

If the error physical memory page is used by a KVM guest, the SIGBUS
will be sent to QEMU, and QEMU will simulate a MCE to report that
memory error to the guest OS.  If the guest OS can not recover from
the error (for example, the page is accessed by kernel code), guest OS
will reboot the system.  But because the underlying host virtual
address backing the guest physical memory is still poisoned, if the
guest system accesses the corresponding guest physical memory even
after rebooting, the SIGBUS will still be sent to QEMU and MCE will be
simulated.  That is, guest system can not recover via rebooting.

In fact, across rebooting, the contents of guest physical memory page
need not to be kept.  We can allocate a new host physical page to
back the corresponding guest physical address.

To do that, a mechanism in KVM to "unpoison" poisoned virtual address
by clearing the corresponding PTE is provided.  So that, when doing
rebooting, QEMU can unpoison the poisoned virtual address, and when
the unpoisoned memory page is accessed, a new physical memory may be
allocated if possible.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/kvm.h |    1 +
 include/linux/mm.h  |    8 ++++++++
 mm/memory-failure.c |   39 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c |   14 ++++++++++++++
 4 files changed, 62 insertions(+)

--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -676,6 +676,7 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
+#define KVM_UNPOISON_ADDRESS	  _IO(KVMIO,  0xa2)
 
 /*
  * ioctls for vcpu fds
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1512,6 +1512,14 @@ extern int sysctl_memory_failure_recover
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
+#ifdef CONFIG_MEMORY_FAILURE
+int unpoison_address(unsigned long addr);
+#else
+static inline int unpoison_address(unsigned long addr)
+{
+	return -EINVAL;
+}
+#endif
 
 extern void dump_page(struct page *page);
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1433,3 +1433,42 @@ done:
 	/* keep elevated page count for bad page */
 	return ret;
 }
+
+int unpoison_address(unsigned long addr)
+{
+	struct mm_struct *mm;
+	pgd_t *pgdp;
+	pud_t pud, *pudp;
+	pmd_t pmd, *pmdp;
+	pte_t pte, *ptep;
+	spinlock_t *ptl;
+	swp_entry_t entry;
+	int rc;
+
+	mm = current->mm;
+	pgdp = pgd_offset(mm, addr);
+	if (!pgd_present(*pgdp))
+		return -EINVAL;
+	pudp = pud_offset(pgdp, addr);
+	pud = *pudp;
+	if (!pud_present(pud) || pud_large(pud))
+		return -EINVAL;
+	pmdp = pmd_offset(pudp, addr);
+	pmd = *pmdp;
+	/* can not unpoison huge page yet */
+	if (!pmd_present(pmd) || pmd_large(pmd))
+		return -EINVAL;
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	pte = *ptep;
+	rc = -EINVAL;
+	if (!is_swap_pte(pte))
+		goto out;
+	entry = pte_to_swp_entry(pte);
+	if (!is_hwpoison_entry(entry))
+		goto out;
+	pte_clear(mm, addr, ptep);
+out:
+	pte_unmap_unlock(ptep, ptl);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(unpoison_address);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -774,6 +774,17 @@ int kvm_vm_ioctl_set_memory_region(struc
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
+static int kvm_unpoison_address(struct kvm *kvm, unsigned long address)
+{
+	int r;
+
+	down_read(&current->mm->mmap_sem);
+	r = unpoison_address(address);
+	up_read(&current->mm->mmap_sem);
+
+	return r;
+}
+
 int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
@@ -1728,6 +1739,9 @@ static long kvm_vm_ioctl(struct file *fi
 		mutex_unlock(&kvm->lock);
 		break;
 #endif
+	case KVM_UNPOISON_ADDRESS:
+		r = kvm_unpoison_address(kvm, arg);
+		break;
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 		if (r == -ENOTTY)
