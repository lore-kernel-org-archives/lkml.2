Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GSD1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:27:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46843 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1GSD1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:27:50 -0400
Message-ID: <4E24FA51.70602@gmail.com>
Date: Tue, 19 Jul 2011 11:30:25 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>	 <1310860194.25044.17.camel@pasglop>	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com> <1310974591.25044.298.camel@pasglop>
In-Reply-To: <1310974591.25044.298.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 03:36 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2011-07-18 at 15:26 +0800, Shan Hai wrote:
>> I am sorry I hadn't tried your newer patch, I tried it but it still
>> could not work in my test environment, I will dig into and tell you
>> why that failed later.
> Ok, please let me know what you find !
>

Have not been finding out the reason why failed,
I tried the following based on your code,
(1)
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..820556d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -353,10 +353,11 @@ static int fault_in_user_writeable(u32 __user *uaddr)
  {
         struct mm_struct *mm = current->mm;
         int ret;
+       int flags = FOLL_TOUCH | FOLL_GET | FOLL_WRITE | FOLL_FIXFAULT;

         down_read(&mm->mmap_sem);
-       ret = get_user_pages(current, mm, (unsigned long)uaddr,
-                            1, 1, 0, NULL, NULL);
+       ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
+                              flags, NULL, NULL, NULL);
         up_read(&mm->mmap_sem);

         return ret < 0 ? ret : 0;

(2)
diff --git a/mm/memory.c b/mm/memory.c
index 9b8a01d..f7ba26e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
...
+
+       if ((flags & (FOLL_WRITE | FOLL_FIXFAULT)) && !pte_dirty(pte))
+               handle_pte_sw_young_dirty(vma, address, ptep,
+                                          FAULT_FLAG_WRITE);
...

And everything lookes good, but still couldn't work, need more 
investigation.

>> Yep, I know holding lots of ifdef's everywhere is not so good,
>> but if we have some other way(I don't know how till now) to
>> figure out the arch has the need to fixup up the write permission
>> we could eradicate the ugly ifdef's here.
>>
>> I think the handle_mm_fault could do all dirty/young tracking,
>> because the purpose of making follow_page return NULL to
>> its caller is that want to the handle_mm_fault to be called
>> on write permission protection fault.
> I see your point. Rather than factoring the fixup code out, we could
> force gup to call handle_mm_fault()... that makes sense.
>
> However, I don't think we should special case archs. There's plenty of
> cases where we don't care about this fixup even on archs that do SW
> tracking of dirty and young. For example when gup is using for
> subsequent DMA.
>
> Only the (rare ?) cases where it's used as a mean to fixup a failing
> "atomic" user access are relevant.
>
> So I believe we should still pass an explicit flag to __get_user_pages()
> as I propose to activate that behaviour.
>

How about the following one?
the write permission fixup behaviour is triggered explicitly by
the trouble making parts like futex as you suggested.

In this way, the follow_page() mimics exactly how the MMU
faults on atomic access to the user pages, and we could handle
the fault by already existing handle_mm_fault which also do
the dirty/young tracking properly.


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..8a76694 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1546,6 +1546,7 @@ struct page *follow_page(struct vm_area_struct *, 
unsigned long address,
  #define FOLL_MLOCK    0x40    /* mark page as mlocked */
  #define FOLL_SPLIT    0x80    /* don't return transhuge pages, split 
them */
  #define FOLL_HWPOISON    0x100    /* check page is hwpoisoned */
+#define FOLL_FIXFAULT    0x200    /* fixup after a fault (PTE 
dirty/young upd) */

  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
              void *data);
diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..820556d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -353,10 +353,11 @@ static int fault_in_user_writeable(u32 __user *uaddr)
  {
      struct mm_struct *mm = current->mm;
      int ret;
+    int flags = FOLL_TOUCH | FOLL_GET | FOLL_WRITE | FOLL_FIXFAULT;

      down_read(&mm->mmap_sem);
-    ret = get_user_pages(current, mm, (unsigned long)uaddr,
-                 1, 1, 0, NULL, NULL);
+    ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
+                   flags, NULL, NULL, NULL);
      up_read(&mm->mmap_sem);

      return ret < 0 ? ret : 0;
diff --git a/mm/memory.c b/mm/memory.c
index 9b8a01d..5682501 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1442,6 +1442,7 @@ struct page *follow_page(struct vm_area_struct 
*vma, unsigned long address,
      spinlock_t *ptl;
      struct page *page;
      struct mm_struct *mm = vma->vm_mm;
+    int fix_write_permission = 0;

      page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
      if (!IS_ERR(page)) {
@@ -1519,6 +1520,9 @@ split_fallthrough:
          if ((flags & FOLL_WRITE) &&
              !pte_dirty(pte) && !PageDirty(page))
              set_page_dirty(page);
+
+        if ((flags & (FOLL_WRITE | FOLL_FIXFAULT)) && !pte_dirty(pte))
+            fix_write_permission = 1;
          /*
           * pte_mkyoung() would be more correct here, but atomic care
           * is needed to avoid losing the dirty bit: it is easier to use
@@ -1551,7 +1555,7 @@ split_fallthrough:
  unlock:
      pte_unmap_unlock(ptep, ptl);
  out:
-    return page;
+    return (fix_write_permission) ? NULL : page;

  bad_page:
      pte_unmap_unlock(ptep, ptl);

> At this point, since we have isolated the special case callers, I think
> we are pretty much in a situation where there's no point trying to
> optimize the x86 case more, it's a fairly slow path anyway, and so no
> ifdef should be needed (and x86 already #define out the TLB flush for
> spurious faults in handle_pte_fault today).
>
> We don't even need to change follow_page()... we just don't call it the
> first time around.
>
> I'll cook up another patch later but first we need to find out why the
> one you have doesn't work. There might be another problem lurking (or I
> just made a stupid mistake).
>
> BTW. Can you give me some details about how you reproduce the problem ?
> I should setup something on a booke machine here to verify things.
>
> Cheers,
> Ben.
>

