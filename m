Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab1GRECT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:02:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:55633 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1GRECS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:02:18 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310944453.25044.262.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 13:53:16 +1000
Message-ID: <1310961196.25044.266.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 09:14 +1000, Benjamin Herrenschmidt wrote:

> In fact, with such a flag, we could probably avoid the ifdef entirely, and
> always go toward the PTE fixup path when called in such a fixup case, my gut
> feeling is that this is going to be seldom enough not to hurt x86 measurably
> but we'll have to try it out.
> 
> That leads to that even less tested patch:

 And here's a version that builds (still not tested :-)

Shan, can you verify whether that fixes the problem for you ?

I also had a cursory glance at the ARM code and it seems to rely on the
same stuff as embedded powerpc does for dirty/young updates, so in
theory it should exhibit the same problem.

I suspect the scenario is rare enough in practice in embedded workloads
that nobody noticed until now.

Cheers,
Ben.

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 06c564e..e8ef0e6 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1296,7 +1296,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				DRV_NAME);
 	if (rc)
 		return rc;
-	iomap = pcim_iomap_table(pdev);
+	iomap = pcim_iomap_table~(pdev);
 
 	/* apply workaround for completion IRQ loss on PCI-X errata */
 	if (pi.flags & SIL24_FLAG_PCIX_IRQ_WOC) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..8a76694 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1546,6 +1546,7 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_FIXFAULT	0x200	/* fixup after a fault (PTE dirty/young upd) */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..02adff7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 	int ret;
 
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
+			       FOLL_WRITE | FOLL_FIXFAULT, NULL, NULL, NULL);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..94b1d3f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1419,6 +1419,29 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
+static void handle_pte_sw_young_dirty(struct vm_area_struct *vma,
+				      unsigned long address,
+				      pte_t *ptep, int write)
+{
+	pte_t entry = *ptep;
+
+	if (write)
+		pte_mkdirty(entry);
+	entry = pte_mkyoung(entry);
+	if (ptep_set_access_flags(vma, address, ptep, entry, write)) {
+		update_mmu_cache(vma, address, ptep);
+	} else {
+		/*
+		 * This is needed only for protection faults but the arch code
+		 * is not yet telling us if this is a protection fault or not.
+		 * This still avoids useless tlb flushes for .text page faults
+		 * with threads.
+		 */
+		if (write)
+			flush_tlb_fix_spurious_fault(vma, address);
+	}
+}
+
 /**
  * follow_page - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
@@ -1514,16 +1537,22 @@ split_fallthrough:
 
 	if (flags & FOLL_GET)
 		get_page(page);
-	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
-		/*
-		 * pte_mkyoung() would be more correct here, but atomic care
-		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * mark_page_accessed().
-		 */
-		mark_page_accessed(page);
+
+	if (!pte_young(pte) || ((flags & FOLL_WRITE) && !pte_dirty(pte))) {
+		if (flags & FOLL_FIXFAULT)
+			handle_pte_sw_young_dirty(vma, address, ptep,
+						  flags & FOLL_WRITE);
+		else if (flags & FOLL_TOUCH) {
+			if ((flags & FOLL_WRITE) &&
+			    !pte_dirty(pte) && !PageDirty(page))
+				set_page_dirty(page);
+			/*
+			 * pte_mkyoung() would be more correct here, but atomic care
+			 * is needed to avoid losing the dirty bit: it is easier to use
+			 * mark_page_accessed().
+			 */
+			mark_page_accessed(page);
+		}
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
@@ -3358,21 +3387,8 @@ int handle_pte_fault(struct mm_struct *mm,
 		if (!pte_write(entry))
 			return do_wp_page(mm, vma, address,
 					pte, pmd, ptl, entry);
-		entry = pte_mkdirty(entry);
-	}
-	entry = pte_mkyoung(entry);
-	if (ptep_set_access_flags(vma, address, pte, entry, flags & FAULT_FLAG_WRITE)) {
-		update_mmu_cache(vma, address, pte);
-	} else {
-		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
-		 */
-		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(vma, address);
 	}
+	handle_pte_sw_young_dirty(vma, address, pte, flags & FAULT_FLAG_WRITE);
 unlock:
 	pte_unmap_unlock(pte, ptl);
 	return 0;


