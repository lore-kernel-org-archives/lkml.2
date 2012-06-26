Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2FZNRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:17:11 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:37641 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2FZNRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FD7B613.6060208@zankel.net>
References: <1333195501-5353-1-git-send-email-consul.kautuk@gmail.com>
	<CAFPAmTRR9N_EDVNa-9JyV70+b1xG4o7zB4dxcjN0EQ5ewp+t5g@mail.gmail.com>
	<4FD7B613.6060208@zankel.net>
Date: Tue, 26 Jun 2012 18:47:06 +0530
Message-ID: <CAFPAmTQn9=oBkLDZE1rUp0to5+vWwpoM8CoEa4Zz3Q2BQ8xQFg@mail.gmail.com>
Subject: Re: [PATCH 13/19 v2] xtensa/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Morton <akpm00@gmail.com>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Can you please accept this patch into linux-next ?

I have Chris Zankel's approval as below..

Thanks,
Kautuk.


On Wed, Jun 13, 2012 at 3:05 AM, Chris Zankel <chris@zankel.net> wrote:
> Hi Kautuk,
>
> Patch looks fine, so:
>
> Acked-by: Chris Zankel <chris@zankel.net>
>
> Thanks,
> -Chris
>
>
> On 6/12/12 8:54 AM, Kautuk Consul wrote:
>>
>> Hi,
>>
>> Could you please review this patch ?
>>
>> Many archs have accepted this patch, so I think maybe this is okay. :)
>>
>> Thanks,
>> Kautuk.
>>
>> On Sat, Mar 31, 2012 at 5:35 PM, Kautuk Consul<consul.kautuk@gmail.com>
>>  wrote:
>>>
>>> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
>>> (mm: retry page fault when blocking on disk transfer) and
>>> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
>>> (x86,mm: make pagefault killable)
>>>
>>> The above commits introduced changes into the x86 pagefault handler
>>> for making the page fault handler retryable as well as killable.
>>>
>>> These changes reduce the mmap_sem hold time, which is crucial
>>> during OOM killer invocation.
>>>
>>> Port these changes to xtensa.
>>>
>>> Signed-off-by: Kautuk Consul<consul.kautuk@gmail.com>
>>> ---
>>>  arch/xtensa/mm/fault.c |   29 ++++++++++++++++++++++++-----
>>>  1 files changed, 24 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
>>> index b17885a..5a74c53 100644
>>> --- a/arch/xtensa/mm/fault.c
>>> +++ b/arch/xtensa/mm/fault.c
>>> @@ -44,6 +44,7 @@ void do_page_fault(struct pt_regs *regs)
>>>
>>>        int is_write, is_exec;
>>>        int fault;
>>> +       unsigned int flags = FAULT_FLAG_ALLOW_RETRY |
>>> FAULT_FLAG_KILLABLE;
>>>
>>>        info.si_code = SEGV_MAPERR;
>>>
>>> @@ -71,6 +72,7 @@ void do_page_fault(struct pt_regs *regs)
>>>               address, exccause, regs->pc, is_write? "w":"", is_exec?
>>> "x":"");
>>>  #endif
>>>
>>> +retry:
>>>        down_read(&mm->mmap_sem);
>>>        vma = find_vma(mm, address);
>>>
>>> @@ -93,6 +95,7 @@ good_area:
>>>        if (is_write) {
>>>                if (!(vma->vm_flags&  VM_WRITE))
>>>
>>>                        goto bad_area;
>>> +               flags |= FAULT_FLAG_WRITE;
>>>        } else if (is_exec) {
>>>                if (!(vma->vm_flags&  VM_EXEC))
>>>
>>>                        goto bad_area;
>>> @@ -104,7 +107,11 @@ good_area:
>>>         * make sure we exit gracefully rather than endlessly redo
>>>         * the fault.
>>>         */
>>> -       fault = handle_mm_fault(mm, vma, address, is_write ?
>>> FAULT_FLAG_WRITE : 0);
>>> +       fault = handle_mm_fault(mm, vma, address, flags);
>>> +
>>> +       if ((fault&  VM_FAULT_RETRY)&&  fatal_signal_pending(current))
>>>
>>> +               return;
>>> +
>>>        if (unlikely(fault&  VM_FAULT_ERROR)) {
>>>                if (fault&  VM_FAULT_OOM)
>>>
>>>                        goto out_of_memory;
>>> @@ -112,10 +119,22 @@ good_area:
>>>                        goto do_sigbus;
>>>                BUG();
>>>        }
>>> -       if (fault&  VM_FAULT_MAJOR)
>>>
>>> -               current->maj_flt++;
>>> -       else
>>> -               current->min_flt++;
>>> +       if (flags&  FAULT_FLAG_ALLOW_RETRY) {
>>> +               if (fault&  VM_FAULT_MAJOR)
>>>
>>> +                       current->maj_flt++;
>>> +               else
>>> +                       current->min_flt++;
>>> +               if (fault&  VM_FAULT_RETRY) {
>>> +                       flags&= ~FAULT_FLAG_ALLOW_RETRY;
>>>
>>> +
>>> +                        /* No need to up_read(&mm->mmap_sem) as we would
>>> +                        * have already released it in
>>> __lock_page_or_retry
>>> +                        * in mm/filemap.c.
>>> +                        */
>>> +
>>> +                       goto retry;
>>> +               }
>>> +       }
>>>
>>>        up_read(&mm->mmap_sem);
>>>        return;
>>> --
>>> 1.7.5.4
>>>
>
