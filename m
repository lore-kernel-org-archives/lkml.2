Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1DVBBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:01:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45757 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DVBBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OYUGqh3tSARI2fb4JzCNvFIJItVCoQ/M2Yyy8IAF0i9d0AtzcJAIUDs/DvcT3Mc4kC
         U0vFxMO/z9jzxjbTonvoFPgW1DgrvlhLTw6yhCLrv7LGsgpuaQ05FhpmzEcdTQkVYSQT
         MC2Pxl52aomcx3Xb08v4bpGcq9lCY2UlR7rsg=
MIME-Version: 1.0
In-Reply-To: <20110421160057.GA28712@suse.de>
References: <20110415101248.GB22688@suse.de>
	<BANLkTik7H+cmA8iToV4j1ncbQqeraCaeTg@mail.gmail.com>
	<20110421110841.GA612@suse.de>
	<20110421142636.GA1835@barrios-desktop>
	<20110421160057.GA28712@suse.de>
Date: Fri, 22 Apr 2011 10:01:11 +0900
Message-ID: <BANLkTinqjO9aNUWC6xBg+VdcO6s4gPqsBg@mail.gmail.com>
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        raz ben yehuda <raziebe@gmail.com>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 1:00 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Thu, Apr 21, 2011 at 11:26:36PM +0900, Minchan Kim wrote:
>> On Thu, Apr 21, 2011 at 12:08:41PM +0100, Mel Gorman wrote:
>> > On Thu, Apr 21, 2011 at 03:59:47PM +0900, Minchan Kim wrote:
>> > > Hi Mel,
>> > >
>> > > On Fri, Apr 15, 2011 at 7:12 PM, Mel Gorman <mgorman@suse.de> wrote:
>> > > > With transparent hugepage support, handle_mm_fault() has to be careful
>> > > > that a normal PMD has been established before handling a PTE fault. To
>> > > > achieve this, it used __pte_alloc() directly instead of pte_alloc_map
>> > > > as pte_alloc_map is unsafe to run against a huge PMD. pte_offset_map()
>> > > > is called once it is known the PMD is safe.
>> > > >
>> > > > pte_alloc_map() is smart enough to check if a PTE is already present
>> > > > before calling __pte_alloc but this check was lost. As a consequence,
>> > > > PTEs may be allocated unnecessarily and the page table lock taken.
>> > > > Thi useless PTE does get cleaned up but it's a performance hit which
>> > > > is visible in page_test from aim9.
>> > > >
>> > > > This patch simply re-adds the check normally done by pte_alloc_map to
>> > > > check if the PTE needs to be allocated before taking the page table
>> > > > lock. The effect is noticable in page_test from aim9.
>> > > >
>> > > > AIM9
>> > > >                2.6.38-vanilla 2.6.38-checkptenone
>> > > > creat-clo      446.10 ( 0.00%)   424.47 (-5.10%)
>> > > > page_test       38.10 ( 0.00%)    42.04 ( 9.37%)
>> > > > brk_test        52.45 ( 0.00%)    51.57 (-1.71%)
>> > > > exec_test      382.00 ( 0.00%)   456.90 (16.39%)
>> > > > fork_test       60.11 ( 0.00%)    67.79 (11.34%)
>> > > > MMTests Statistics: duration
>> > > > Total Elapsed Time (seconds)                611.90    612.22
>> > > >
>> > > > (While this affects 2.6.38, it is a performance rather than a
>> > > > functional bug and normally outside the rules -stable. While the big
>> > > > performance differences are to a microbench, the difference in fork
>> > > > and exec performance may be significant enough that -stable wants to
>> > > > consider the patch)
>> > > >
>> > > > Reported-by: Raz Ben Yehuda <raziebe@gmail.com>
>> > > > Signed-off-by: Mel Gorman <mgorman@suse.de>
>> > > > --
>> > > >  mm/memory.c |    2 +-
>> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/mm/memory.c b/mm/memory.c
>> > > > index 5823698..1659574 100644
>> > > > --- a/mm/memory.c
>> > > > +++ b/mm/memory.c
>> > > > @@ -3322,7 +3322,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>> > > >         * run pte_offset_map on the pmd, if an huge pmd could
>> > > >         * materialize from under us from a different thread.
>> > > >         */
>> > > > -       if (unlikely(__pte_alloc(mm, vma, pmd, address)))
>> > > > +       if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
>> > > >                return VM_FAULT_OOM;
>> > > >        /* if an huge pmd materialized from under us just retry later */
>> > > >        if (unlikely(pmd_trans_huge(*pmd)))
>> > > >
>> > >
>> > > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>> > >
>> > > Sorry for jumping in too late. I have a just nitpick.
>> > >
>> >
>> > Better late than never :)
>> >
>> > > We have another place, do_huge_pmd_anonymous_page.
>> > > Although it isn't workload of page_test, is it valuable to expand your
>> > > patch to cover it?
>> > > If there is workload there are many thread and share one shared anon
>> > > vma in ALWAYS THP mode, same problem would happen.
>> >
>> > We already checked pmd_none() in handle_mm_fault() before calling
>> > into do_huge_pmd_anonymous_page(). We could race for the fault while
>> > attempting to allocate a huge page but it wouldn't be as severe a
>> > problem particularly as it is encountered after failing a 2M allocation.
>>
>> Right you are. Fail ot 2M allocation would affect as throttle.
>> Thanks.
>>
>> As I failed let you add the check, I have to reveal my mind. :)
>> Actually, what I want is consistency of the code.
>
> This is a stronger arguement than as a performance fix. I was concerned
> that if such a check was added that it would confuse someone in a years
> time trying to figure out why the pmd_none check was really necessary.
>
>> The code have been same in two places but you find the problem in page_test of aim9,
>> you changed one of them slightly. I think in future someone will
>> have a question about that and he will start grep git log but it will take
>> a long time as the log is buried other code piled up.
>>
>
> Fair point.
>
>> I hope adding the comment in this case.
>>
>>         /*
>>          * PTEs may be allocated unnecessarily and the page table lock taken.
>>          * The useless PTE does get cleaned up but it's a performance hit in
>>          * some micro-benchmark. Let's check pmd_none before __pte_alloc to
>>          * reduce the overhead.
>>          */
>> -       if (unlikely(__pte_alloc(mm, vma, pmd, address)))
>> +       if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
>>
>
> I think a better justification is
>
>        /*
>         * Even though handle_mm_fault has already checked pmd_none, we
>         * have failed a huge allocation at this point during which a
>         * valid PTE could have been inserted. Double check a PTE alloc
>         * is still necessary to avoid additional overhead
>         */
>

Hmm. If we disable thp, the comment about failing a huge allocation.
was not true. So I prefer mine :)
But Andrea suggested defining new pte_alloc which checks pmd_none
internally for code consistency POV.
In such case, I have no concern about comment.
Is it okay?

>> If you mind it as someone who have a question can find the log at last
>> although he need some time, I wouldn't care of the nitpick any more. :)
>> It's up to you.
>>
>
> If you want to create a new patch with either your comment or mine
> (whichever you prefer) I'll add my ack. I'm about to drop offline
> for a few days but if it's still there Tuesday, I'll put together an
> appropriate patch and submit. I'd keep it separate from the other patch
> because it's a performance fix (which I'd like to see in -stable) where
> as this is more of a cleanup IMO.

Okay.
Thanks, Mel.

-- 
Kind regards,
Minchan Kim
