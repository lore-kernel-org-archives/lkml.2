Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab1IBEs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 00:48:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58680 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1IBEsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 00:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110901140254.GH14369@suse.de>
References: <cover.1321112552.git.minchan.kim@gmail.com>
	<8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
	<20110831111954.GB17512@redhat.com>
	<20110831144150.GA1860@barrios-desktop>
	<20110901140254.GH14369@suse.de>
Date: Fri, 2 Sep 2011 13:48:54 +0900
Message-ID: <CAEwNFnCmZ5tJ2Fy9Qt8=GBZN2=YhrX4ZiWmMPx0mAVXtvZj_Pg@mail.gmail.com>
Subject: Re: [PATCH 2/3] compaction: compact unevictable page
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 11:02 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Aug 31, 2011 at 11:41:50PM +0900, Minchan Kim wrote:
>> On Wed, Aug 31, 2011 at 01:19:54PM +0200, Johannes Weiner wrote:
>> > On Sun, Nov 13, 2011 at 01:37:42AM +0900, Minchan Kim wrote:
>> > > Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
>> > > which doesn't consider unevicatable page. It has been used by just lumpy so
>> > > it was pointless that it isolates unevictable page. But the situation is
>> > > changed. Compaction could handle unevictable page and it can help getting
>> > > big contiguos pages in fragment memory by many pinned page with mlock.
>> >
>> > This may result in applications unexpectedly faulting and waiting on
>> > mlocked pages under migration.  I wonder how realtime people feel
>> > about that?
>>
>> I didn't consider it but it's very important point.
>> The migrate_page can call pageout on dirty page so RT process could wait on the
>> mlocked page during very long time.
>
> On the plus side, the filesystem that is likely to suffer from this
> is btrfs. The other important cases avoid the writeout.

You mean only btrfs does write in reclaim context?
It's the oppose I have known.
Anyway, it would be mitigated if we merge your patch "Reduce
filesystem writeback from page reclaim".
But we have other problem as I said.
We can suffer from unmapping page of many ptes.

>
>> I can mitigate it with isolating mlocked page in case of !sync but still we can't
>> guarantee the time because we can't know how many vmas point the page so that try_to_unmap
>> could spend lots of time.
>>
>
> This loss of guarantee arguably violates POSIX 1B as part of the
> real-time extension. The wording is "The function mlock shall cause
> those whole pages containing any part of the address space of the
> process starting at address addr and continuing for len bytes to be
> memory resident until unlocked or until the process exits or execs
> another process image."
>
> It defines locking as "memory locking guarantees the residence of
> portions of the address space. It is implementation defined whether
> locking memory guarantees fixed translation between virtual addresses
> (as seen by the process) and physical addresses."
>
> As it's up to the implementation whether to preserve the physical
> page mapping, it's allowed for compaction to move that page. However,
> as it mlock is recommended for use by time-critical applications,
> I fear we would be breaking developer expectations on the behaviour
> of mlock even if it is permitted by POSIX.

Agree.

>
>> We can think it's a trade off between high order allocation VS RT latency.
>> Now I am biasing toward RT latency as considering mlock man page.
>>
>> Any thoughts?
>>
>
> At the very least it should not be the default behaviour. I do not have
> suggestions on how it could be enabled though. It's a bit obscure to
> have as a kernel parameter or even a proc tunable and it's not a perfect
> for /sys/kernel/mm/transparent_hugepage/defrag either.
>
> How big of a problem is it that mlocked pages are not compacted at the
> moment?

I found it by just code review and didn't see any reports about that.
But it is quite possible that someone calls mlock with small request sparsely.
And logically, compaction could be a feature to solve it if user
endures the pain.
(But still, I am not sure how many of user on mlock can bear it)

We can solve a bit that by another approach if it's really problem
with RT processes. The another approach is to separate mlocked pages
with allocation time like below pseudo patch which just show the
concept)

ex)
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..8ae2e60 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -175,7 +175,8 @@ static inline struct page *
 alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
                                        unsigned long vaddr)
 {
-       return __alloc_zeroed_user_highpage(__GFP_MOVABLE, vma, vaddr);
+       gfp_t gfp_flag = vma->vm_flags & VM_LCOKED ? 0 : __GFP_MOVABLE;
+       return __alloc_zeroed_user_highpage(gfp_flag, vma, vaddr);
 }

But it's a solution about newly allocated page on mlocked vma.
Old pages in the VMA is still a problem.
We can solve it at mlock system call through migrating the pages to
UNMOVABLE block.

What we need is just VOC. Who know there are such systems which call
mlock call frequently with small pages?
If any customer doesn't require it strongly, I can drop this patch.

-- 
Kind regards,
Minchan Kim
