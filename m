Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1LFESl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 23:18:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48393 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab1LFESk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 23:18:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111123000417.GE8397@redhat.com>
References: <1320215670-10157-1-git-send-email-heguanbo@gmail.com>
	<20111123000417.GE8397@redhat.com>
Date: Tue, 6 Dec 2011 12:18:39 +0800
Message-ID: <CAGW+__LQJx0Gk5aPtenxYUqCVHLmMrdXrkgtNs2KmKRQDoe_QQ@mail.gmail.com>
Subject: Re: [PATCH][mm] adjust the logic of checking THP
From: GuanJun He <heguanbo@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 8:04 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Wed, Nov 02, 2011 at 02:34:30PM +0800, Guanjun He wrote:
>>
>> Acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits,
>> it's a pmd entry bits, only mark a size, not a flag;As one can easily
>> create the same pmd entry bits for some special use,then the check
>> will get confused.And this patch is to adjust the logic to use the flag,
>> it can perfectly avoid this potential issuse,and basically no impact
>> to the current code.
>
> You can't use _PAGE_PSE for special use for the pmd. Besides this is
> common code, archs without such bit can define pmd_trans_huge to
> return 0 like it happens with TRANSPARENT_HUGEPAGE=n.

ok, even _PAGE_PSE can not be used for special use for the pmd,
This check is more efficient.
the original code always check 2 items " pmd_none(*pmd) &&
transparent_hugepage_enabled(vma) ",
even TRANSPARENT_HUGEPAGE not enabled.

>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index a56e3ba..a76b17f 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3465,20 +3465,22 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>       pmd = pmd_alloc(mm, pud, address);
>>       if (!pmd)
>>               return VM_FAULT_OOM;
>> -     if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
>> -             if (!vma->vm_ops)
>> -                     return do_huge_pmd_anonymous_page(mm, vma, address,
>> -                                                       pmd, flags);
>> -     } else {
>> -             pmd_t orig_pmd = *pmd;
>> -             barrier();
>> -             if (pmd_trans_huge(orig_pmd)) {
>> -                     if (flags & FAULT_FLAG_WRITE &&
>> -                         !pmd_write(orig_pmd) &&
>> -                         !pmd_trans_splitting(orig_pmd))
>> -                             return do_huge_pmd_wp_page(mm, vma, address,
>> -                                                        pmd, orig_pmd);
>> +     if (transparent_hugepage_enabled(vma)) {
>> +             if (pmd_none(*pmd)) {
>> +                     if (!vma->vm_ops)
>> +                             return do_huge_pmd_anonymous_page(mm, vma, address,
>> +                                                               pmd, flags);
>> +             } else {
>> +                     pmd_t orig_pmd = *pmd;
>> +                     barrier();
>> +                     if (pmd_trans_huge(orig_pmd)) {
>> +                             if (flags & FAULT_FLAG_WRITE &&
>> +                                 !pmd_write(orig_pmd) &&
>> +                                 !pmd_trans_splitting(orig_pmd))
>> +                                     return do_huge_pmd_wp_page(mm, vma, address,
>> +                                                                pmd, orig_pmd);
>>                       return 0;
>> +                     }
>
> This will infinite loop if you disable THP at runtime while some
> mapping needing cow is established.
