Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1GSEaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:30:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:33676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1GSEaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:30:11 -0400
Subject: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E24FA51.70602@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop>  <4E24FA51.70602@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 14:29:22 +1000
Message-ID: <1311049762.25044.392.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex code currently attempts to write to user memory within
a pagefault disabled section, and if that fails, tries to fix it
up using get_user_pages().

This doesn't work on archs where the dirty and young bits are
maintained by software, since they will gate access permission
in the TLB, and will not be updated by gup().

In addition, there's an expectation on some archs that a
spurious write fault triggers a local TLB flush, and that is
missing from the picture as well.

I decided that adding those "features" to gup() would be too much
for this already too complex function, and instead added a new
simpler fixup_user_fault() which is essentially a wrapper around
handle_mm_fault() which the futex code can call.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Shan, can you test this ? It might not fix the problem since I'm
starting to have the nasty feeling that you are hitting what is
somewhat a subtly different issue or my previous patch should
have worked (but then I might have done a stupid mistake as well)
but let us know anyway.

Cheers,
Ben.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..1036614 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -985,6 +985,8 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
+extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long address, unsigned int fault_flags);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..7a0a4ed 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 	int ret;
 
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
+			       FAULT_FLAG_WRITE);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..b967fb0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1815,7 +1815,64 @@ next_page:
 }
 EXPORT_SYMBOL(__get_user_pages);
 
-/**
+/*
+ * fixup_user_fault() - manually resolve a user page  fault
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @address:	user address
+ * @fault_flags:flags to pass down to handle_mm_fault()
+ *
+ * This is meant to be called in the specific scenario where for
+ * locking reasons we try to access user memory in atomic context
+ * (within a pagefault_disable() section), this returns -EFAULT,
+ * and we want to resolve the user fault before trying again.
+ *
+ * Typically this is meant to be used by the futex code.
+ *
+ * The main difference with get_user_pages() is that this function
+ * will unconditionally call handle_mm_fault() which will in turn
+ * perform all the necessary SW fixup of the dirty and young bits
+ * in the PTE, while handle_mm_fault() only guarantees to update
+ * these in the struct page.
+ *
+ * This is important for some architectures where those bits also
+ * gate the access permission to the page because their are
+ * maintained in software. On such architecture, gup() will not
+ * be enough to make a subsequent access succeed.
+ *
+ * This should be called with the mm_sem held for read.
+ */
+int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long address, unsigned int fault_flags)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	vma = find_extend_vma(mm, address);
+	if (!vma || address < vma->vm_start)
+		return -EFAULT;
+	
+	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	if (ret & VM_FAULT_ERROR) {
+		if (ret & VM_FAULT_OOM)
+			return -ENOMEM;
+		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+			return -EHWPOISON;
+		if (ret & VM_FAULT_SIGBUS)
+			return -EFAULT;
+		BUG();
+	}
+	if (tsk) {
+		if (ret & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+	}
+	return 0;
+}
+
+/*
  * get_user_pages() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.


