Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1FVXTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:19:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44522 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1FVXTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWlfnRuKzUFd7KMWeweNODBvrFCXaBct5UlNi6nR7DkmfwBage4ztH5DTWfvHMdncJ
         2dnsAg+2U39gCieE04jE9r2iOLq1hPe1oDRvt7aXhSfAC4ddrQoTBqLPY0hJO7fg0zmY
         T/CuZe7hVwnlJ8LDLya7bItrxOa/EGQGRsXW0=
MIME-Version: 1.0
In-Reply-To: <20110622150350.GX20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<20110622150350.GX20843@redhat.com>
Date: Thu, 23 Jun 2011 07:19:06 +0800
Message-ID: <BANLkTim85ghrK9D4f19Pt5v1+HTMzVXxnw@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:03 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, Jun 21, 2011 at 09:32:39PM +0800, Nai Xia wrote:
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index d48ec60..b407a69 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -4674,6 +4674,7 @@ static int __init vmx_init(void)
>>               kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
>>                               VMX_EPT_EXECUTABLE_MASK);
>>               kvm_enable_tdp();
>> +             kvm_dirty_update = 0;
>>       } else
>>               kvm_disable_tdp();
>>
>
> Why not return !shadow_dirty_mask instead of adding a new var?
>
>>  struct mmu_notifier_ops {
>> +     int (*dirty_update)(struct mmu_notifier *mn,
>> +                          struct mm_struct *mm);
>> +
>
> Needs some docu.
>
> I think dirty_update isn't self explanatory name. I think
> "has_test_and_clear_dirty" would be better.
>
> If we don't flush the smp tlb don't we risk that we'll insert pages in
> the unstable tree that are volatile just because the dirty bit didn't
> get set again on the spte?
>
> The first patch I guess it's a sign of hugetlbfs going a little over
> the edge in trying to mix with the core VM... Passing that parameter
> &need_pte_unmap all over the place not so nice, maybe it'd be possible
> to fix within hugetlbfs to use a different method to walk the hugetlb
> vmas. I'd prefer that if possible.

OK, I'll have a try over other workarounds.
I am not feeling good about need_pte_unmap myself. :-)

Thanks for viewing!

-Nai

>
> Thanks,
> Andrea
>
