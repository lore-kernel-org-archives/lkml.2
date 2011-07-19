Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1GSEVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:21:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:36278 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1GSEVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:21:20 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@kernel.crashing.org>
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
Date: Tue, 19 Jul 2011 14:20:28 +1000
Message-ID: <1311049228.25044.383.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 11:30 +0800, Shan Hai wrote:
> On 07/18/2011 03:36 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2011-07-18 at 15:26 +0800, Shan Hai wrote:
> >> I am sorry I hadn't tried your newer patch, I tried it but it still
> >> could not work in my test environment, I will dig into and tell you
> >> why that failed later.
> > Ok, please let me know what you find !
> >
> 
> Have not been finding out the reason why failed,
> I tried the following based on your code,

Ok, looks like we'll need to dig more, though the original findings
still stand, which means we might be chasing two different bugs :-)

I haven't had time to try to reproduce today and may not this week,
so I'll have to let you toy around with it until I get a chance to
try to track it down myself unless somebody else gets into it... Kumar ?
Anybody on FSL side feels like having a look ?
 
> How about the following one?
> the write permission fixup behaviour is triggered explicitly by
> the trouble making parts like futex as you suggested.
> 
> In this way, the follow_page() mimics exactly how the MMU
> faults on atomic access to the user pages, and we could handle
> the fault by already existing handle_mm_fault which also do
> the dirty/young tracking properly.

So you say this still doesn't fix your problem right ?

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9670f71..8a76694 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1546,6 +1546,7 @@ struct page *follow_page(struct vm_area_struct *, 
> unsigned long address,
>   #define FOLL_MLOCK    0x40    /* mark page as mlocked */
>   #define FOLL_SPLIT    0x80    /* don't return transhuge pages, split 
> them */
>   #define FOLL_HWPOISON    0x100    /* check page is hwpoisoned */
> +#define FOLL_FIXFAULT    0x200    /* fixup after a fault (PTE 
> dirty/young upd) */

Badly wrapped it seems :-) And totally whitespace damaged...

>   typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
>               void *data);
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..820556d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -353,10 +353,11 @@ static int fault_in_user_writeable(u32 __user *uaddr)
>   {
>       struct mm_struct *mm = current->mm;
>       int ret;
> +    int flags = FOLL_TOUCH | FOLL_GET | FOLL_WRITE | FOLL_FIXFAULT;

You don't want TOUCH -and- FIXFAULT do you ? Also you don't want GET
since you aren't passing a page array or vma array anyway.

>       down_read(&mm->mmap_sem);
> -    ret = get_user_pages(current, mm, (unsigned long)uaddr,
> -                 1, 1, 0, NULL, NULL);
> +    ret = __get_user_pages(current, mm, (unsigned long)uaddr, 1,
> +                   flags, NULL, NULL, NULL);
>       up_read(&mm->mmap_sem);
> 
>       return ret < 0 ? ret : 0;
> diff --git a/mm/memory.c b/mm/memory.c
> index 9b8a01d..5682501 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1442,6 +1442,7 @@ struct page *follow_page(struct vm_area_struct 
> *vma, unsigned long address,
>       spinlock_t *ptl;
>       struct page *page;
>       struct mm_struct *mm = vma->vm_mm;
> +    int fix_write_permission = 0;

Don't do that.

>       page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
>       if (!IS_ERR(page)) {
> @@ -1519,6 +1520,9 @@ split_fallthrough:
>           if ((flags & FOLL_WRITE) &&
>               !pte_dirty(pte) && !PageDirty(page))
>               set_page_dirty(page);
> +
> +        if ((flags & (FOLL_WRITE | FOLL_FIXFAULT)) && !pte_dirty(pte))
> +            fix_write_permission = 1;

No, you missed my point completely. If FOLL_FIXFAULT is set, you don't
even need to call follow_page() to begin with... you -always- want to
force a call to handle_mm_fault (and only one, no loop), regardless
of whether the PTE is dirty or not, since you need to also address
the lack of a young bit.

(That might explain why your patch doesn't work if your problem is
caused by a missing young bit).

What about the patch in my next email...

Ben.



