Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1KEAVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:21:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35792 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1KEAVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <20111104235603.GT18879@redhat.com>
References: <20111031171441.GD3466@redhat.com>
	<1320082040-1190-1-git-send-email-aarcange@redhat.com>
	<alpine.LSU.2.00.1111032318290.2058@sister.anvils>
	<20111104235603.GT18879@redhat.com>
Date: Sat, 5 Nov 2011 08:21:03 +0800
Message-ID: <CAPQyPG5i87VcnwU5UoKiT6_=tzqO_NOPXFvyEooA1Orbe_ztGQ@mail.gmail.com>
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 5, 2011 at 7:56 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Fri, Nov 04, 2011 at 12:31:04AM -0700, Hugh Dickins wrote:
>> On Mon, 31 Oct 2011, Andrea Arcangeli wrote:
>> > diff --git a/mm/mmap.c b/mm/mmap.c
>> > index a65efd4..a5858dc 100644
>> > --- a/mm/mmap.c
>> > +++ b/mm/mmap.c
>> > @@ -2339,7 +2339,15 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>> >              */
>> >             if (vma_start >= new_vma->vm_start &&
>> >                 vma_start < new_vma->vm_end)
>> > +                   /*
>> > +                    * No need to call anon_vma_order_tail() in
>> > +                    * this case because the same PT lock will
>> > +                    * serialize the rmap_walk against both src
>> > +                    * and dst vmas.
>> > +                    */
>>
>> Really?  Please convince me: I just do not see what ensures that
>> the same pt lock covers both src and dst areas in this case.
>
> Right, vma being the same for src/dst doesn't mean the PT lock is the
> same, it might be if source pte entry fit in the same pagetable but
> maybe not if the vma is >2M (the max a single pagetable can point to).
>
>> >                     *vmap = new_vma;
>> > +           else
>> > +                   anon_vma_order_tail(new_vma);
>>
>> And if this puts new_vma in the right position for the normal
>> move_page_tables(), as anon_vma_clone() does in the block below,
>> aren't they both in exactly the wrong position for the abnormal
>> move_page_tables(), called to put ptes back where they were if
>> the original move_page_tables() fails?
>
> Failure paths. Good point, they'd need to be reversed again in that
> case.
>
>> It might be possible to argue that move_page_tables() can only
>> fail by failing to allocate memory for pud or pmd, and that (perhaps)
>> could only happen if the task was being OOM-killed and ran out of
>> reserves at this point, and if it's being OOM-killed then we don't
>> mind losing a migration entry for a moment... perhaps.
>
> Hmm no it wouldn't be ok, or I wouldn't want to risk that.
>
>> Certainly I'd agree that it's a very rare case.  But it feels wrong
>> to be attempting to fix the already unlikely issue, while ignoring
>> this aspect, or relying on such unrelated implementation details.
>
> Agreed.
>
>> Perhaps some further anon_vma_ordering could fix it up,
>> but that would look increasingly desperate.
>
> I think what Nai didn't consider in explaining this theoretical race
> that I noticed now is the anon_vma root lock taken by adjust_vma.
>
> If the merge succeeds adjust_vma will take the lock and flush away
> from all others CPUs any sign of rmap_walk before the move_page_tables
> can start.
>
> So it can't happen that you do rmap_walk, check vma1, mremap moves
> stuff from vma2 to vma1 (wrong order), and then rmap_walk continues
> checking vma2 where the pte won't be there anymore. It can't happen
> because mremap would block in vma_merge waiting the rmap_walk to
> complete. Before proceeding moving any pte. Thanks to the anon_vma
> lock already taken by adjust_vma.

Still,  I think it's not rmap_walk() ---> mremap() --> rmap_walk() that trigger
the bug,  but this events would:

copy_vma() ---> rmap_walk() scan dst VMA --> move_page_tables() moves src to dst
--->  rmap_walk() scan src VMA.  :D

I might be wrong. But thank you all for the time and patience for
playing this racing game
with me. It's really an honor to exhaust my mind on a daunting thing
with you. :)


Best Regards,

Nai
