Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1KMAvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:51:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1KMAvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAFPAmTTTvLMrSjfVkP+C7grkBY6cpB9kxTUWN2mJe-bTQX17OA@mail.gmail.com>
References: <1321139283-2955-1-git-send-email-consul.kautuk@gmail.com>
	<20111112232039.GD27746@n2100.arm.linux.org.uk>
	<CAFPAmTTTvLMrSjfVkP+C7grkBY6cpB9kxTUWN2mJe-bTQX17OA@mail.gmail.com>
Date: Sat, 12 Nov 2011 19:51:03 -0500
Message-ID: <CAFPAmTRDm_B8jgiVxZcHr-e+ZcL4n=oO+FB5H+=n4sbXuOSjFg@mail.gmail.com>
Subject: Re: [PATCH 1/1] arch/arm/mm/fault.c: Porting OOM changes into __do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyways, I have created a version 2 of this patch with all the locking
kept inside do_page_fault
itself. I will send it right after I send this email.

I would appreciate it if you could review that.

On Sat, Nov 12, 2011 at 6:56 PM, kautuk.c @samsung.com
<consul.kautuk@gmail.com> wrote:
> On Sat, Nov 12, 2011 at 6:20 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sat, Nov 12, 2011 at 06:08:03PM -0500, Kautuk Consul wrote:
>>> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
>>> index aa33949..2f89dba 100644
>>> --- a/arch/arm/mm/fault.c
>>> +++ b/arch/arm/mm/fault.c
>>> @@ -231,11 +231,15 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
>>>
>>>  static int __kprobes
>>>  __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
>>> -             struct task_struct *tsk)
>>> +             struct pt_regs *regs, struct task_struct *tsk)
>>>  {
>>>       struct vm_area_struct *vma;
>>>       int fault;
>>> +     int write = fsr & FSR_WRITE;
>>> +     unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
>>> +                                     (write ? FAULT_FLAG_WRITE : 0);
>>>
>>> +retry:
>>>       vma = find_vma(mm, addr);
>>>       fault = VM_FAULT_BADMAP;
>>>       if (unlikely(!vma))
>>> @@ -257,13 +261,44 @@ good_area:
>>>        * If for any reason at all we couldn't handle the fault, make
>>>        * sure we exit gracefully rather than endlessly redo the fault.
>>>        */
>>> -     fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, (fsr & FSR_WRITE) ? FAULT_FLAG_WRITE : 0);
>>> -     if (unlikely(fault & VM_FAULT_ERROR))
>>> +     fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
>>> +
>>> +     if (unlikely((fault & VM_FAULT_ERROR)))
>>>               return fault;
>>> -     if (fault & VM_FAULT_MAJOR)
>>> -             tsk->maj_flt++;
>>> -     else
>>> -             tsk->min_flt++;
>>> +
>>> +     if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
>>> +             return fault;
>>> +
>>> +     /*
>>> +      * Major/minor page fault accounting is only done on the
>>> +      * initial attempt. If we go through a retry, it is extremely
>>> +      * likely that the page will be found in page cache at that point.
>>> +      */
>>> +     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
>>> +     if (flags & FAULT_FLAG_ALLOW_RETRY) {
>>> +             if (fault & VM_FAULT_MAJOR) {
>>> +                     tsk->maj_flt++;
>>> +                     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
>>> +                                   regs, addr);
>>> +             } else {
>>> +                     tsk->min_flt++;
>>> +                     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
>>> +                                   regs, addr);
>>> +             }
>>> +             if (fault & VM_FAULT_RETRY) {
>>> +                     /* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
>>> +                      * of starvation. */
>>> +                     flags &= ~FAULT_FLAG_ALLOW_RETRY;
>>> +
>>> +                     /* Acquire the mmap_sem again before retrying this
>>> +                      * pagefault. This would have been released by
>>> +                      * __lock_page_or_retry() in mm/filemap.c. */
>>> +                     down_read(&mm->mmap_sem);
>>> +
>>> +                     goto retry;
>>> +             }
>>> +     }
>>> +
>>>       return fault;
>>>
>>>  check_stack:
>>> @@ -320,14 +355,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>>>  #endif
>>>       }
>>>
>>> -     fault = __do_page_fault(mm, addr, fsr, tsk);
>>> -     up_read(&mm->mmap_sem);
>>> -
>>> -     perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
>>> -     if (fault & VM_FAULT_MAJOR)
>>> -             perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, addr);
>>> -     else if (fault & VM_FAULT_MINOR)
>>> -             perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, addr);
>>> +     fault = __do_page_fault(mm, addr, fsr, regs, tsk);
>>> +     if (likely(!(fault & VM_FAULT_RETRY)))
>>> +             up_read(&mm->mmap_sem);
>>
>> I really don't like this.  I crafted this handling in such a way that
>> the locking was plainly obvious - with all locking handled in
>> do_page_fault and not inside __do_page_fault.  That's how I want things
>> to stay, so please rework this patch to maintain that.
>
>
> I understand your concern.
>
> However, the entire concept of retryable and killable page fault
> handlers kind of messes with the
> locking that was there earlier.
> ( Please look at the commits I have mentioned in the patch. )
>
> There will anyways have to be a check somewhere in the pagefault
> handler code to check if
> VM_FAULT_RETRY was returned and only do an up_read when there wasn't.
> The reason for this is that the mmap_sem is released in
> __lock_page_or_retry() in filemap.c.
>
> Can you shed some more light on what you would find more acceptable in
> the locking mechanism ?
>
>>
>
