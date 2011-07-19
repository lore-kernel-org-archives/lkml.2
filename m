Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1GSFgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:36:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42831 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GSFgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:36:02 -0400
Message-ID: <4E25185F.1050605@gmail.com>
Date: Tue, 19 Jul 2011 13:38:39 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>	 <1310860194.25044.17.camel@pasglop>	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com>	 <1310974591.25044.298.camel@pasglop>  <4E24FA51.70602@gmail.com>	 <1311049762.25044.392.camel@pasglop>  <4E251365.9090004@gmail.com> <1311053063.25044.397.camel@pasglop>
In-Reply-To: <1311053063.25044.397.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 01:24 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2011-07-19 at 13:17 +0800, Shan Hai wrote:
>
>> The patch works, but I have certain confusions,
>> - Do we want to handle_mm_fault on each futex_lock_pi
>>       even though in most cases there is no write permission
>>       fixup's needed?
> Don't we only ever call this when futex_atomic_op_inuser() failed ?
> Which means a fixup -is- needed .... The fast path is still there.
>

What you said is another path, that is futex_wake_op(),
but what about futex_lock_pi in which my test case failed?
your patch will call handle_mm_fault on every futex contention
in the futex_lock_pi path.

futex_lock_pi()
     ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
         case -EFAULT:
                         goto uaddr_faulted;

     ...
uaddr_faulted:
     ret = fault_in_user_writeable(uaddr);


>> - How about let the archs do their own write permission
>>       fixup as what I did in my original
> Why ? This is generic and will fix all archs at once with generic code
> which is a significant improvement in my book and a lot more
> maintainable :-)
>

If the overhead in the futex_lock_pi  path is not considerable yes fix it up
generally is nice :-)

>>       "[PATCH 1/1] Fixup write permission of TLB on powerpc e500 core"?
>>       (I will fix the stupid errors in my original patch if the concept
>> is acceptable)
>>       in this way we could decrease the overhead of handle_mm_fault
>>       in the path which does not need write permission fixup.
> Which overhead ? gup does handle_mm_fault() as well if needed.

it does it *if needed*, and this requirement is rare in my opinion.


Thanks
Shan Hai

> What I do is I replace what is arguably an abuse of gup() in the case
> where a fixup -is- needed with a dedicated function designed to perform
> the said fixup ... and do it properly which gup() didn't :-)
>
> Cheers,
> Ben.
>
>> Thanks
>> Shan Hai
>>> Cheers,
>>> Ben.
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 9670f71..1036614 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -985,6 +985,8 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>>>    int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>>>    			struct page **pages);
>>>    struct page *get_dump_page(unsigned long addr);
>>> +extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
>>> +			    unsigned long address, unsigned int fault_flags);
>>>
>>>    extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
>>>    extern void do_invalidatepage(struct page *page, unsigned long offset);
>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>> index fe28dc2..7a0a4ed 100644
>>> --- a/kernel/futex.c
>>> +++ b/kernel/futex.c
>>> @@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
>>>    	int ret;
>>>
>>>    	down_read(&mm->mmap_sem);
>>> -	ret = get_user_pages(current, mm, (unsigned long)uaddr,
>>> -			     1, 1, 0, NULL, NULL);
>>> +	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
>>> +			       FAULT_FLAG_WRITE);
>>>    	up_read(&mm->mmap_sem);
>>>
>>>    	return ret<   0 ? ret : 0;
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 40b7531..b967fb0 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -1815,7 +1815,64 @@ next_page:
>>>    }
>>>    EXPORT_SYMBOL(__get_user_pages);
>>>
>>> -/**
>>> +/*
>>> + * fixup_user_fault() - manually resolve a user page  fault
>>> + * @tsk:	the task_struct to use for page fault accounting, or
>>> + *		NULL if faults are not to be recorded.
>>> + * @mm:		mm_struct of target mm
>>> + * @address:	user address
>>> + * @fault_flags:flags to pass down to handle_mm_fault()
>>> + *
>>> + * This is meant to be called in the specific scenario where for
>>> + * locking reasons we try to access user memory in atomic context
>>> + * (within a pagefault_disable() section), this returns -EFAULT,
>>> + * and we want to resolve the user fault before trying again.
>>> + *
>>> + * Typically this is meant to be used by the futex code.
>>> + *
>>> + * The main difference with get_user_pages() is that this function
>>> + * will unconditionally call handle_mm_fault() which will in turn
>>> + * perform all the necessary SW fixup of the dirty and young bits
>>> + * in the PTE, while handle_mm_fault() only guarantees to update
>>> + * these in the struct page.
>>> + *
>>> + * This is important for some architectures where those bits also
>>> + * gate the access permission to the page because their are
>>> + * maintained in software. On such architecture, gup() will not
>>> + * be enough to make a subsequent access succeed.
>>> + *
>>> + * This should be called with the mm_sem held for read.
>>> + */
>>> +int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
>>> +		     unsigned long address, unsigned int fault_flags)
>>> +{
>>> +	struct vm_area_struct *vma;
>>> +	int ret;
>>> +
>>> +	vma = find_extend_vma(mm, address);
>>> +	if (!vma || address<   vma->vm_start)
>>> +		return -EFAULT;
>>> +	
>>> +	ret = handle_mm_fault(mm, vma, address, fault_flags);
>>> +	if (ret&   VM_FAULT_ERROR) {
>>> +		if (ret&   VM_FAULT_OOM)
>>> +			return -ENOMEM;
>>> +		if (ret&   (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
>>> +			return -EHWPOISON;
>>> +		if (ret&   VM_FAULT_SIGBUS)
>>> +			return -EFAULT;
>>> +		BUG();
>>> +	}
>>> +	if (tsk) {
>>> +		if (ret&   VM_FAULT_MAJOR)
>>> +			tsk->maj_flt++;
>>> +		else
>>> +			tsk->min_flt++;
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>>     * get_user_pages() - pin user pages in memory
>>>     * @tsk:	the task_struct to use for page fault accounting, or
>>>     *		NULL if faults are not to be recorded.
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

