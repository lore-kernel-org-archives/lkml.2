Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1AMMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:53:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1AMMxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:53:46 -0500
Date: Thu, 13 Jan 2011 14:53:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
Message-ID: <20110113125308.GJ14750@redhat.com>
References: <4D2ACFA7.6000502@redhat.com>
 <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
 <4D2C21FE.3000406@redhat.com>
 <4D2E1010.4080706@redhat.com>
 <AANLkTimLJnV9oJwnaN+jdvNus4cxuqvgUqHUwi7vpqBe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimLJnV9oJwnaN+jdvNus4cxuqvgUqHUwi7vpqBe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:53:14PM -0800, Linus Torvalds wrote:
> On Wed, Jan 12, 2011 at 12:33 PM, Rik van Riel <riel@redhat.com> wrote:
> >
> > Now that we have FAULT_FLAG_ALLOW_RETRY, the async
> > pagefault patches can be a little smaller.
> 
> I suspect you do still want a new page flag, to say that
> FAULT_FLAG_ALLOW_RETRY shouldn't actually wait for the page that it
> allows retry for.
> 
> But even then, that flag should not be named "MINOR", it should be
> about what the behaviour is actually all about ("NOWAIT_RETRY" or
> whatever - it presumably would also cause us to not drop the
> mmap_sem).
> 
> IOW, these days I suspect the patch _should_ look something like the attached.
> 
> Anyway, with this, you should be able to use
> 
>   FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT
> 
> to basically get a non-waiting page fault (and it will return the
> VM_FAULT_RETRY error code if it failed).
> 
I implemented get_user_pages_nowait() on top of your patch. In my testing
it works as expected when used inside KVM. Does this looks OK to you?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dc83565..d78e9e7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -859,6 +859,9 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			unsigned long start, int nr_pages, int write, int force,
 			struct page **pages, struct vm_area_struct **vmas);
+int get_user_pages_nowait(struct task_struct *tsk, struct mm_struct *mm,
+			unsigned long start, int nr_pages, int write, int force,
+			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
@@ -1416,6 +1419,8 @@ struct page *follow_page(struct vm_area_struct *, unsigned long address,
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_RETRY	0x20	/* if disk transfer is needed release mmap_sem and return error */
+#define FOLL_NOWAIT	0x40	/* if disk transfer is needed return error without releasing mmap_sem */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/mm/memory.c b/mm/memory.c
index 02e48aa..0a3d3b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1443,8 +1443,12 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				int ret;
 
 				ret = handle_mm_fault(mm, vma, start,
-					(foll_flags & FOLL_WRITE) ?
-					FAULT_FLAG_WRITE : 0);
+					((foll_flags & FOLL_WRITE) ?
+					FAULT_FLAG_WRITE : 0) |
+					((foll_flags & FOLL_RETRY) ?
+					FAULT_FLAG_ALLOW_RETRY : 0) |
+					((foll_flags & FOLL_NOWAIT) ?
+					FAULT_FLAG_RETRY_NOWAIT : 0));
 
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
@@ -1460,6 +1464,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				else
 					tsk->min_flt++;
 
+				if (ret & VM_FAULT_RETRY)
+					return i ? i : -EFAULT;
+
 				/*
 				 * The VM_FAULT_WRITE bit tells us that
 				 * do_wp_page has broken COW when necessary,
@@ -1563,6 +1570,23 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 }
 EXPORT_SYMBOL(get_user_pages);
 
+int get_user_pages_nowait(struct task_struct *tsk, struct mm_struct *mm,
+               unsigned long start, int nr_pages, int write, int force,
+               struct page **pages, struct vm_area_struct **vmas)
+{
+       int flags = FOLL_TOUCH | FOLL_RETRY | FOLL_NOWAIT;
+
+       if (pages)
+               flags |= FOLL_GET;
+       if (write)
+               flags |= FOLL_WRITE;
+       if (force)
+               flags |= FOLL_FORCE;
+
+       return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
+}
+EXPORT_SYMBOL(get_user_pages_nowait);
+
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
--
			Gleb.
