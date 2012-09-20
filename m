Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2ITK1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:27:40 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47760 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2ITK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:27:37 -0400
Date: Thu, 20 Sep 2012 12:27:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.6-rc7
Message-ID: <20120920122729.3e19f731@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12092010-4966-0000-0000-0000038D4375
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive bug fixes for 3.6-rc7, including some important patches for
large page related memory management issues.

Gerald Schaefer (3):
      s390/mm: fix deadlock in unmap_hugepage_range()
      s390/hugetlb: use direct TLB flushing for hugetlbfs pages
      s390/mm: fix user access page-table walk code

Martin Schwidefsky (1):
      s390/hwcaps: do not report high gprs for 31 bit kernel

Sebastian Ott (3):
      s390/dasd: move wake_up call
      s390/cio: fix IO subchannel event race
      s390/cio: invalidate cdev pointer before deregistration

Stefan Haberland (2):
      s390/dasd: fix pathgroup race
      s390/dasd: fix read unit address configuration loop

 arch/s390/include/asm/hugetlb.h  |   24 +++----
 arch/s390/include/asm/tlbflush.h |    2 -
 arch/s390/kernel/setup.c         |    2 +
 arch/s390/lib/uaccess_pt.c       |  142 +++++++++++++++++---------------------
 drivers/s390/block/dasd.c        |   17 ++++-
 drivers/s390/block/dasd_alias.c  |   27 +++++++-
 drivers/s390/block/dasd_eckd.c   |   32 +++++++--
 drivers/s390/cio/device.c        |    7 +-
 8 files changed, 146 insertions(+), 107 deletions(-)

diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 799ed0f..2d6e6e3 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -66,16 +66,6 @@ static inline pte_t huge_ptep_get(pte_t *ptep)
 	return pte;
 }
 
-static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
-					    unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = huge_ptep_get(ptep);
-
-	mm->context.flush_mm = 1;
-	pmd_clear((pmd_t *) ptep);
-	return pte;
-}
-
 static inline void __pmd_csp(pmd_t *pmdp)
 {
 	register unsigned long reg2 asm("2") = pmd_val(*pmdp);
@@ -117,6 +107,15 @@ static inline void huge_ptep_invalidate(struct mm_struct *mm,
 		__pmd_csp(pmdp);
 }
 
+static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = huge_ptep_get(ptep);
+
+	huge_ptep_invalidate(mm, addr, ptep);
+	return pte;
+}
+
 #define huge_ptep_set_access_flags(__vma, __addr, __ptep, __entry, __dirty) \
 ({									    \
 	int __changed = !pte_same(huge_ptep_get(__ptep), __entry);	    \
@@ -131,10 +130,7 @@ static inline void huge_ptep_invalidate(struct mm_struct *mm,
 ({									\
 	pte_t __pte = huge_ptep_get(__ptep);				\
 	if (pte_write(__pte)) {						\
-		(__mm)->context.flush_mm = 1;				\
-		if (atomic_read(&(__mm)->context.attach_count) > 1 ||	\
-		    (__mm) != current->active_mm)			\
-			huge_ptep_invalidate(__mm, __addr, __ptep);	\
+		huge_ptep_invalidate(__mm, __addr, __ptep);		\
 		set_huge_pte_at(__mm, __addr, __ptep,			\
 				huge_pte_wrprotect(__pte));		\
 	}								\
diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index 9fde315..1d8fe2b 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -90,12 +90,10 @@ static inline void __tlb_flush_mm(struct mm_struct * mm)
 
 static inline void __tlb_flush_mm_cond(struct mm_struct * mm)
 {
-	spin_lock(&mm->page_table_lock);
 	if (mm->context.flush_mm) {
 		__tlb_flush_mm(mm);
 		mm->context.flush_mm = 0;
 	}
-	spin_unlock(&mm->page_table_lock);
 }
 
 /*
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f86c81e..40b5769 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -974,11 +974,13 @@ static void __init setup_hwcaps(void)
 	if (MACHINE_HAS_HPAGE)
 		elf_hwcap |= HWCAP_S390_HPAGE;
 
+#if defined(CONFIG_64BIT)
 	/*
 	 * 64-bit register support for 31-bit processes
 	 * HWCAP_S390_HIGH_GPRS is bit 9.
 	 */
 	elf_hwcap |= HWCAP_S390_HIGH_GPRS;
+#endif
 
 	get_cpu_id(&cpu_id);
 	switch (cpu_id.machine) {
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 60ee2b8..2d37bb8 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -2,69 +2,82 @@
  *  User access functions based on page table walks for enhanced
  *  system layout without hardware support.
  *
- *    Copyright IBM Corp. 2006
+ *    Copyright IBM Corp. 2006, 2012
  *    Author(s): Gerald Schaefer (gerald.schaefer@de.ibm.com)
  */
 
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <asm/uaccess.h>
 #include <asm/futex.h>
 #include "uaccess.h"
 
-static inline pte_t *follow_table(struct mm_struct *mm, unsigned long addr)
+
+/*
+ * Returns kernel address for user virtual address. If the returned address is
+ * >= -4095 (IS_ERR_VALUE(x) returns true), a fault has occured and the address
+ * contains the (negative) exception code.
+ */
+static __always_inline unsigned long follow_table(struct mm_struct *mm,
+						  unsigned long addr, int write)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
+	pte_t *ptep;
 
 	pgd = pgd_offset(mm, addr);
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		return (pte_t *) 0x3a;
+		return -0x3aUL;
 
 	pud = pud_offset(pgd, addr);
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		return (pte_t *) 0x3b;
+		return -0x3bUL;
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		return (pte_t *) 0x10;
+	if (pmd_none(*pmd))
+		return -0x10UL;
+	if (pmd_huge(*pmd)) {
+		if (write && (pmd_val(*pmd) & _SEGMENT_ENTRY_RO))
+			return -0x04UL;
+		return (pmd_val(*pmd) & HPAGE_MASK) + (addr & ~HPAGE_MASK);
+	}
+	if (unlikely(pmd_bad(*pmd)))
+		return -0x10UL;
+
+	ptep = pte_offset_map(pmd, addr);
+	if (!pte_present(*ptep))
+		return -0x11UL;
+	if (write && !pte_write(*ptep))
+		return -0x04UL;
 
-	return pte_offset_map(pmd, addr);
+	return (pte_val(*ptep) & PAGE_MASK) + (addr & ~PAGE_MASK);
 }
 
 static __always_inline size_t __user_copy_pt(unsigned long uaddr, void *kptr,
 					     size_t n, int write_user)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long offset, pfn, done, size;
-	pte_t *pte;
+	unsigned long offset, done, size, kaddr;
 	void *from, *to;
 
 	done = 0;
 retry:
 	spin_lock(&mm->page_table_lock);
 	do {
-		pte = follow_table(mm, uaddr);
-		if ((unsigned long) pte < 0x1000)
+		kaddr = follow_table(mm, uaddr, write_user);
+		if (IS_ERR_VALUE(kaddr))
 			goto fault;
-		if (!pte_present(*pte)) {
-			pte = (pte_t *) 0x11;
-			goto fault;
-		} else if (write_user && !pte_write(*pte)) {
-			pte = (pte_t *) 0x04;
-			goto fault;
-		}
 
-		pfn = pte_pfn(*pte);
-		offset = uaddr & (PAGE_SIZE - 1);
+		offset = uaddr & ~PAGE_MASK;
 		size = min(n - done, PAGE_SIZE - offset);
 		if (write_user) {
-			to = (void *)((pfn << PAGE_SHIFT) + offset);
+			to = (void *) kaddr;
 			from = kptr + done;
 		} else {
-			from = (void *)((pfn << PAGE_SHIFT) + offset);
+			from = (void *) kaddr;
 			to = kptr + done;
 		}
 		memcpy(to, from, size);
@@ -75,7 +88,7 @@ retry:
 	return n - done;
 fault:
 	spin_unlock(&mm->page_table_lock);
-	if (__handle_fault(uaddr, (unsigned long) pte, write_user))
+	if (__handle_fault(uaddr, -kaddr, write_user))
 		return n - done;
 	goto retry;
 }
@@ -84,27 +97,22 @@ fault:
  * Do DAT for user address by page table walk, return kernel address.
  * This function needs to be called with current->mm->page_table_lock held.
  */
-static __always_inline unsigned long __dat_user_addr(unsigned long uaddr)
+static __always_inline unsigned long __dat_user_addr(unsigned long uaddr,
+						     int write)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long pfn;
-	pte_t *pte;
+	unsigned long kaddr;
 	int rc;
 
 retry:
-	pte = follow_table(mm, uaddr);
-	if ((unsigned long) pte < 0x1000)
-		goto fault;
-	if (!pte_present(*pte)) {
-		pte = (pte_t *) 0x11;
+	kaddr = follow_table(mm, uaddr, write);
+	if (IS_ERR_VALUE(kaddr))
 		goto fault;
-	}
 
-	pfn = pte_pfn(*pte);
-	return (pfn << PAGE_SHIFT) + (uaddr & (PAGE_SIZE - 1));
+	return kaddr;
 fault:
 	spin_unlock(&mm->page_table_lock);
-	rc = __handle_fault(uaddr, (unsigned long) pte, 0);
+	rc = __handle_fault(uaddr, -kaddr, write);
 	spin_lock(&mm->page_table_lock);
 	if (!rc)
 		goto retry;
@@ -159,11 +167,9 @@ static size_t clear_user_pt(size_t n, void __user *to)
 
 static size_t strnlen_user_pt(size_t count, const char __user *src)
 {
-	char *addr;
 	unsigned long uaddr = (unsigned long) src;
 	struct mm_struct *mm = current->mm;
-	unsigned long offset, pfn, done, len;
-	pte_t *pte;
+	unsigned long offset, done, len, kaddr;
 	size_t len_str;
 
 	if (segment_eq(get_fs(), KERNEL_DS))
@@ -172,19 +178,13 @@ static size_t strnlen_user_pt(size_t count, const char __user *src)
 retry:
 	spin_lock(&mm->page_table_lock);
 	do {
-		pte = follow_table(mm, uaddr);
-		if ((unsigned long) pte < 0x1000)
-			goto fault;
-		if (!pte_present(*pte)) {
-			pte = (pte_t *) 0x11;
+		kaddr = follow_table(mm, uaddr, 0);
+		if (IS_ERR_VALUE(kaddr))
 			goto fault;
-		}
 
-		pfn = pte_pfn(*pte);
-		offset = uaddr & (PAGE_SIZE-1);
-		addr = (char *)(pfn << PAGE_SHIFT) + offset;
+		offset = uaddr & ~PAGE_MASK;
 		len = min(count - done, PAGE_SIZE - offset);
-		len_str = strnlen(addr, len);
+		len_str = strnlen((char *) kaddr, len);
 		done += len_str;
 		uaddr += len_str;
 	} while ((len_str == len) && (done < count));
@@ -192,7 +192,7 @@ retry:
 	return done + 1;
 fault:
 	spin_unlock(&mm->page_table_lock);
-	if (__handle_fault(uaddr, (unsigned long) pte, 0))
+	if (__handle_fault(uaddr, -kaddr, 0))
 		return 0;
 	goto retry;
 }
@@ -225,11 +225,10 @@ static size_t copy_in_user_pt(size_t n, void __user *to,
 			      const void __user *from)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long offset_from, offset_to, offset_max, pfn_from, pfn_to,
-		      uaddr, done, size, error_code;
+	unsigned long offset_max, uaddr, done, size, error_code;
 	unsigned long uaddr_from = (unsigned long) from;
 	unsigned long uaddr_to = (unsigned long) to;
-	pte_t *pte_from, *pte_to;
+	unsigned long kaddr_to, kaddr_from;
 	int write_user;
 
 	if (segment_eq(get_fs(), KERNEL_DS)) {
@@ -242,38 +241,23 @@ retry:
 	do {
 		write_user = 0;
 		uaddr = uaddr_from;
-		pte_from = follow_table(mm, uaddr_from);
-		error_code = (unsigned long) pte_from;
-		if (error_code < 0x1000)
-			goto fault;
-		if (!pte_present(*pte_from)) {
-			error_code = 0x11;
+		kaddr_from = follow_table(mm, uaddr_from, 0);
+		error_code = kaddr_from;
+		if (IS_ERR_VALUE(error_code))
 			goto fault;
-		}
 
 		write_user = 1;
 		uaddr = uaddr_to;
-		pte_to = follow_table(mm, uaddr_to);
-		error_code = (unsigned long) pte_to;
-		if (error_code < 0x1000)
-			goto fault;
-		if (!pte_present(*pte_to)) {
-			error_code = 0x11;
+		kaddr_to = follow_table(mm, uaddr_to, 1);
+		error_code = (unsigned long) kaddr_to;
+		if (IS_ERR_VALUE(error_code))
 			goto fault;
-		} else if (!pte_write(*pte_to)) {
-			error_code = 0x04;
-			goto fault;
-		}
 
-		pfn_from = pte_pfn(*pte_from);
-		pfn_to = pte_pfn(*pte_to);
-		offset_from = uaddr_from & (PAGE_SIZE-1);
-		offset_to = uaddr_from & (PAGE_SIZE-1);
-		offset_max = max(offset_from, offset_to);
+		offset_max = max(uaddr_from & ~PAGE_MASK,
+				 uaddr_to & ~PAGE_MASK);
 		size = min(n - done, PAGE_SIZE - offset_max);
 
-		memcpy((void *)(pfn_to << PAGE_SHIFT) + offset_to,
-		       (void *)(pfn_from << PAGE_SHIFT) + offset_from, size);
+		memcpy((void *) kaddr_to, (void *) kaddr_from, size);
 		done += size;
 		uaddr_from += size;
 		uaddr_to += size;
@@ -282,7 +266,7 @@ retry:
 	return n - done;
 fault:
 	spin_unlock(&mm->page_table_lock);
-	if (__handle_fault(uaddr, error_code, write_user))
+	if (__handle_fault(uaddr, -error_code, write_user))
 		return n - done;
 	goto retry;
 }
@@ -341,7 +325,7 @@ int futex_atomic_op_pt(int op, u32 __user *uaddr, int oparg, int *old)
 		return __futex_atomic_op_pt(op, uaddr, oparg, old);
 	spin_lock(&current->mm->page_table_lock);
 	uaddr = (u32 __force __user *)
-		__dat_user_addr((__force unsigned long) uaddr);
+		__dat_user_addr((__force unsigned long) uaddr, 1);
 	if (!uaddr) {
 		spin_unlock(&current->mm->page_table_lock);
 		return -EFAULT;
@@ -378,7 +362,7 @@ int futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
 		return __futex_atomic_cmpxchg_pt(uval, uaddr, oldval, newval);
 	spin_lock(&current->mm->page_table_lock);
 	uaddr = (u32 __force __user *)
-		__dat_user_addr((__force unsigned long) uaddr);
+		__dat_user_addr((__force unsigned long) uaddr, 1);
 	if (!uaddr) {
 		spin_unlock(&current->mm->page_table_lock);
 		return -EFAULT;
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 15370a2..0595c76 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -534,11 +534,11 @@ static void dasd_change_state(struct dasd_device *device)
 	if (rc)
 		device->target = device->state;
 
-	if (device->state == device->target)
-		wake_up(&dasd_init_waitq);
-
 	/* let user-space know that the device status changed */
 	kobject_uevent(&device->cdev->dev.kobj, KOBJ_CHANGE);
+
+	if (device->state == device->target)
+		wake_up(&dasd_init_waitq);
 }
 
 /*
@@ -2157,6 +2157,7 @@ static int _dasd_sleep_on(struct dasd_ccw_req *maincqr, int interruptible)
 		    test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
 		    (!dasd_eer_enabled(device))) {
 			cqr->status = DASD_CQR_FAILED;
+			cqr->intrc = -EAGAIN;
 			continue;
 		}
 		/* Don't try to start requests if device is stopped */
@@ -3270,6 +3271,16 @@ void dasd_generic_path_event(struct ccw_device *cdev, int *path_event)
 			dasd_schedule_device_bh(device);
 		}
 		if (path_event[chp] & PE_PATHGROUP_ESTABLISHED) {
+			if (!(device->path_data.opm & eventlpm) &&
+			    !(device->path_data.tbvpm & eventlpm)) {
+				/*
+				 * we can not establish a pathgroup on an
+				 * unavailable path, so trigger a path
+				 * verification first
+				 */
+				device->path_data.tbvpm |= eventlpm;
+				dasd_schedule_device_bh(device);
+			}
 			DBF_DEV_EVENT(DBF_WARNING, device, "%s",
 				      "Pathgroup re-established\n");
 			if (device->discipline->kick_validate)
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 157defe..6b55699 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -384,6 +384,29 @@ static void _remove_device_from_lcu(struct alias_lcu *lcu,
 		group->next = NULL;
 };
 
+static int
+suborder_not_supported(struct dasd_ccw_req *cqr)
+{
+	char *sense;
+	char reason;
+	char msg_format;
+	char msg_no;
+
+	sense = dasd_get_sense(&cqr->irb);
+	if (!sense)
+		return 0;
+
+	reason = sense[0];
+	msg_format = (sense[7] & 0xF0);
+	msg_no = (sense[7] & 0x0F);
+
+	/* command reject, Format 0 MSG 4 - invalid parameter */
+	if ((reason == 0x80) && (msg_format == 0x00) && (msg_no == 0x04))
+		return 1;
+
+	return 0;
+}
+
 static int read_unit_address_configuration(struct dasd_device *device,
 					   struct alias_lcu *lcu)
 {
@@ -435,6 +458,8 @@ static int read_unit_address_configuration(struct dasd_device *device,
 
 	do {
 		rc = dasd_sleep_on(cqr);
+		if (rc && suborder_not_supported(cqr))
+			return -EOPNOTSUPP;
 	} while (rc && (cqr->retries > 0));
 	if (rc) {
 		spin_lock_irqsave(&lcu->lock, flags);
@@ -521,7 +546,7 @@ static void lcu_update_work(struct work_struct *work)
 	 * processing the data
 	 */
 	spin_lock_irqsave(&lcu->lock, flags);
-	if (rc || (lcu->flags & NEED_UAC_UPDATE)) {
+	if ((rc && (rc != -EOPNOTSUPP)) || (lcu->flags & NEED_UAC_UPDATE)) {
 		DBF_DEV_EVENT(DBF_WARNING, device, "could not update"
 			    " alias data in lcu (rc = %d), retry later", rc);
 		schedule_delayed_work(&lcu->ruac_data.dwork, 30*HZ);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 2fb2b9e..c48c72a 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1507,7 +1507,8 @@ static struct dasd_ccw_req *dasd_eckd_build_psf_ssc(struct dasd_device *device,
  * call might change behaviour of DASD devices.
  */
 static int
-dasd_eckd_psf_ssc(struct dasd_device *device, int enable_pav)
+dasd_eckd_psf_ssc(struct dasd_device *device, int enable_pav,
+		  unsigned long flags)
 {
 	struct dasd_ccw_req *cqr;
 	int rc;
@@ -1516,10 +1517,19 @@ dasd_eckd_psf_ssc(struct dasd_device *device, int enable_pav)
 	if (IS_ERR(cqr))
 		return PTR_ERR(cqr);
 
+	/*
+	 * set flags e.g. turn on failfast, to prevent blocking
+	 * the calling function should handle failed requests
+	 */
+	cqr->flags |= flags;
+
 	rc = dasd_sleep_on(cqr);
 	if (!rc)
 		/* trigger CIO to reprobe devices */
 		css_schedule_reprobe();
+	else if (cqr->intrc == -EAGAIN)
+		rc = -EAGAIN;
+
 	dasd_sfree_request(cqr, cqr->memdev);
 	return rc;
 }
@@ -1527,7 +1537,8 @@ dasd_eckd_psf_ssc(struct dasd_device *device, int enable_pav)
 /*
  * Valide storage server of current device.
  */
-static void dasd_eckd_validate_server(struct dasd_device *device)
+static int dasd_eckd_validate_server(struct dasd_device *device,
+				     unsigned long flags)
 {
 	int rc;
 	struct dasd_eckd_private *private;
@@ -1536,17 +1547,18 @@ static void dasd_eckd_validate_server(struct dasd_device *device)
 	private = (struct dasd_eckd_private *) device->private;
 	if (private->uid.type == UA_BASE_PAV_ALIAS ||
 	    private->uid.type == UA_HYPER_PAV_ALIAS)
-		return;
+		return 0;
 	if (dasd_nopav || MACHINE_IS_VM)
 		enable_pav = 0;
 	else
 		enable_pav = 1;
-	rc = dasd_eckd_psf_ssc(device, enable_pav);
+	rc = dasd_eckd_psf_ssc(device, enable_pav, flags);
 
 	/* may be requested feature is not available on server,
 	 * therefore just report error and go ahead */
 	DBF_EVENT_DEVID(DBF_WARNING, device->cdev, "PSF-SSC for SSID %04x "
 			"returned rc=%d", private->uid.ssid, rc);
+	return rc;
 }
 
 /*
@@ -1556,7 +1568,13 @@ static void dasd_eckd_do_validate_server(struct work_struct *work)
 {
 	struct dasd_device *device = container_of(work, struct dasd_device,
 						  kick_validate);
-	dasd_eckd_validate_server(device);
+	if (dasd_eckd_validate_server(device, DASD_CQR_FLAGS_FAILFAST)
+	    == -EAGAIN) {
+		/* schedule worker again if failed */
+		schedule_work(&device->kick_validate);
+		return;
+	}
+
 	dasd_put_device(device);
 }
 
@@ -1685,7 +1703,7 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 	if (rc)
 		goto out_err2;
 
-	dasd_eckd_validate_server(device);
+	dasd_eckd_validate_server(device, 0);
 
 	/* device may report different configuration data after LCU setup */
 	rc = dasd_eckd_read_conf(device);
@@ -4153,7 +4171,7 @@ static int dasd_eckd_restore_device(struct dasd_device *device)
 	rc = dasd_alias_make_device_known_to_lcu(device);
 	if (rc)
 		return rc;
-	dasd_eckd_validate_server(device);
+	dasd_eckd_validate_server(device, DASD_CQR_FLAGS_FAILFAST);
 
 	/* RE-Read Configuration Data */
 	rc = dasd_eckd_read_conf(device);
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index ed25c87..fc916f5 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1426,6 +1426,8 @@ static enum io_sch_action sch_get_action(struct subchannel *sch)
 		return IO_SCH_REPROBE;
 	if (cdev->online)
 		return IO_SCH_VERIFY;
+	if (cdev->private->state == DEV_STATE_NOT_OPER)
+		return IO_SCH_UNREG_ATTACH;
 	return IO_SCH_NOP;
 }
 
@@ -1519,11 +1521,14 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 			goto out;
 		break;
 	case IO_SCH_UNREG_ATTACH:
+		spin_lock_irqsave(sch->lock, flags);
 		if (cdev->private->flags.resuming) {
 			/* Device will be handled later. */
 			rc = 0;
-			goto out;
+			goto out_unlock;
 		}
+		sch_set_cdev(sch, NULL);
+		spin_unlock_irqrestore(sch->lock, flags);
 		/* Unregister ccw device. */
 		ccw_device_unregister(cdev);
 		break;

