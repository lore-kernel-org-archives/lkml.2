Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1JQDCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 23:02:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1JQDCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 23:02:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xtvRiMoNAoEyQ8aOhSbyL0NGiOkCvNtE3xllE9jBvGVDRXAJhD7qP9vxiCQK14Ly4
	ZZI7lfZMRNMtmURDu5b1Q==
MIME-Version: 1.0
In-Reply-To: <CA+55aFyTif3k0-wb+1zS8b+hKT13pL0T_qtVzAz2HW5U9=yoMg@mail.gmail.com>
References: <201110122012.33767.pluto@agmk.net>
	<alpine.LSU.2.00.1110131547550.1346@sister.anvils>
	<CA+55aFyTif3k0-wb+1zS8b+hKT13pL0T_qtVzAz2HW5U9=yoMg@mail.gmail.com>
Date: Sun, 16 Oct 2011 20:02:16 -0700
Message-ID: <CANsGZ6Zs0sPMqcToGpw8H1vLcAewyj4aii+iy0V9oyhk7RqzjA@mail.gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
From: Hugh Dickins <hughd@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pawel Sikora <pluto@agmk.net>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not read through and digested Andrea's reply yet, but I'd say
this is not something we need to rush into 3.1 at the last moment,
before it's been fully considered: the bug here is hard to hit,
ancient, made more likely in 2.6.35 by compaction and in 2.6.38 by
THP's reliance on compaction, but not a regression in 3.1 at all - let
it wait until stable.

Hugh

On Sun, Oct 16, 2011 at 3:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> What's the status of this thing? Is it stable/3.1 material? Do we have
> ack/nak's for it? Anybody?
>
>                               Linus
>
> On Thu, Oct 13, 2011 at 4:16 PM, Hugh Dickins <hughd@google.com> wrote:
>>
>> [PATCH] mm: add anon_vma locking to mremap move
>>
>> I don't usually pay much attention to the stale "? " addresses in
>> stack backtraces, but this lucky report from Pawel Sikora hints that
>> mremap's move_ptes() has inadequate locking against page migration.
>>
>>  3.0 BUG_ON(!PageLocked(p)) in migration_entry_to_page():
>>  kernel BUG at include/linux/swapops.h:105!
>>  RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>]
>>                       migration_entry_wait+0x156/0x160
>>  [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
>>  [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
>>  [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
>>  [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
>>  [<ffffffff81106097>] ? vma_adjust+0x537/0x570
>>  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
>>  [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
>>  [<ffffffff81421d5f>] page_fault+0x1f/0x30
>>
>> mremap's down_write of mmap_sem, together with i_mmap_mutex/lock,
>> and pagetable locks, were good enough before page migration (with its
>> requirement that every migration entry be found) came in; and enough
>> while migration always held mmap_sem.  But not enough nowadays, when
>> there's memory hotremove and compaction: anon_vma lock is also needed,
>> to make sure a migration entry is not dodging around behind our back.
>>
>> It appears that Mel's a8bef8ff6ea1 "mm: migration: avoid race between
>> shift_arg_pages() and rmap_walk() during migration by not migrating
>> temporary stacks" was actually a workaround for this in the special
>> common case of exec's use of move_pagetables(); and we should probably
>> now remove that VM_STACK_INCOMPLETE_SETUP stuff as a separate cleanup.
>>
>> Reported-by: Pawel Sikora <pluto@agmk.net>
>> Cc: stable@kernel.org
>> Signed-off-by: Hugh Dickins <hughd@google.com>
>> ---
>>
>>  mm/mremap.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> --- 3.1-rc9/mm/mremap.c 2011-07-21 19:17:23.000000000 -0700
>> +++ linux/mm/mremap.c   2011-10-13 14:36:25.097780974 -0700
>> @@ -77,6 +77,7 @@ static void move_ptes(struct vm_area_str
>>                unsigned long new_addr)
>>  {
>>        struct address_space *mapping = NULL;
>> +       struct anon_vma *anon_vma = vma->anon_vma;
>>        struct mm_struct *mm = vma->vm_mm;
>>        pte_t *old_pte, *new_pte, pte;
>>        spinlock_t *old_ptl, *new_ptl;
>> @@ -95,6 +96,8 @@ static void move_ptes(struct vm_area_str
>>                mapping = vma->vm_file->f_mapping;
>>                mutex_lock(&mapping->i_mmap_mutex);
>>        }
>> +       if (anon_vma)
>> +               anon_vma_lock(anon_vma);
>>
>>        /*
>>         * We don't have to worry about the ordering of src and dst
>> @@ -121,6 +124,8 @@ static void move_ptes(struct vm_area_str
>>                spin_unlock(new_ptl);
>>        pte_unmap(new_pte - 1);
>>        pte_unmap_unlock(old_pte - 1, old_ptl);
>> +       if (anon_vma)
>> +               anon_vma_unlock(anon_vma);
>>        if (mapping)
>>                mutex_unlock(&mapping->i_mmap_mutex);
>>        mmu_notifier_invalidate_range_end(vma->vm_mm, old_start, old_end);
>
