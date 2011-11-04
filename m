Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1KDClH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:41:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47566 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab1KDClG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAGW+__+=q6W92+0HZWeQsqKt+wiBu7sPU8jTOxbaR_JEfqo6Qw@mail.gmail.com>
References: <1320215670-10157-1-git-send-email-heguanbo@gmail.com>
	<CAJd=RBD7iov62=OdZOb3L4S+2ok6CEconGMmmPrzFnzWkQJ+Rg@mail.gmail.com>
	<CAGW+__+=q6W92+0HZWeQsqKt+wiBu7sPU8jTOxbaR_JEfqo6Qw@mail.gmail.com>
Date: Fri, 4 Nov 2011 10:41:05 +0800
Message-ID: <CAGW+__LrtzqXem-o77UOzd0Fr8ORrHM7r_eiyMK8aX5t63+vBw@mail.gmail.com>
Subject: Re: [PATCH][mm] adjust the logic of checking THP
From: GuanJun He <heguanbo@gmail.com>
To: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: gjhe@suse.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 10:19 AM, GuanJun He <heguanbo@gmail.com> wrote:
> On Wed, Nov 2, 2011 at 8:17 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Wed, Nov 2, 2011 at 2:34 PM, Guanjun He <heguanbo@gmail.com> wrote:
>>>
>>> Acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits,
>>> it's a pmd entry bits, only mark a size, not a flag;As one can easily
>>> create the same pmd entry bits for some special use,then the check
>>> will get confused.And this patch is to adjust the logic to use the flag,
>>> it can perfectly avoid this potential issuse,and basically no impact
>>> to the current code.
>>>
>>>
>>> Signed-off-by: Guanjun He <heguanbo@gmail.com>
>>> ---
>>>  mm/memory.c |   28 +++++++++++++++-------------
>>>  1 files changed, 15 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index a56e3ba..a76b17f 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -3465,20 +3465,22 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>>        pmd = pmd_alloc(mm, pud, address);
>>>        if (!pmd)
>>>                return VM_FAULT_OOM;
>>> -       if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
>>> -               if (!vma->vm_ops)
>>> -                       return do_huge_pmd_anonymous_page(mm, vma, address,
>>> -                                                         pmd, flags);
>>> -       } else {
>>> -               pmd_t orig_pmd = *pmd;
>>> -               barrier();
>>> -               if (pmd_trans_huge(orig_pmd)) {
>>> -                       if (flags & FAULT_FLAG_WRITE &&
>>> -                           !pmd_write(orig_pmd) &&
>>> -                           !pmd_trans_splitting(orig_pmd))
>>> -                               return do_huge_pmd_wp_page(mm, vma, address,
>>> -                                                          pmd, orig_pmd);
>>> +       if (transparent_hugepage_enabled(vma)) {
>>
>> Well, how about THP not configured?
>
> What do you mean 'not configured'? assume not enabled.
> If THP not enabled, of course the transparent_hugepage_enabled(vma)
> will be false.

In the original logic,  it's possible that the code go into the logic
of THP while the THP is not enabled.
Just think, If build another module that make pmd with the same bits,
even THP is not enabled, the code can go into the logic of the THP.And
this adjust can avoid this.

best,
Guanjun

>
>>
>> Thanks,
>>              Hillf
>>
>>> +               if (pmd_none(*pmd)) {
>>> +                       if (!vma->vm_ops)
>>> +                               return do_huge_pmd_anonymous_page(mm, vma, address,
>>> +                                                                 pmd, flags);
>>> +               } else {
>>> +                       pmd_t orig_pmd = *pmd;
>>> +                       barrier();
>>> +                       if (pmd_trans_huge(orig_pmd)) {
>>> +                               if (flags & FAULT_FLAG_WRITE &&
>>> +                                   !pmd_write(orig_pmd) &&
>>> +                                   !pmd_trans_splitting(orig_pmd))
>>> +                                       return do_huge_pmd_wp_page(mm, vma, address,
>>> +                                                                  pmd, orig_pmd);
>>>                        return 0;
>>> +                       }
>>>                }
>>>        }
>>>
>>> --
>>> 1.7.7
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>
>
