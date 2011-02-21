Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1BUW7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:59:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50305 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1BUW7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EQxd4r/2q77f86iUtI+RsNzOFgMMS3tXBkSIKGSTHwnK96h0nvRmfMWNnuxOFUbDBU
         3AG71E/OeEVfYY3DIMRqWTstbVuUF5zrY1nYzbUr7Lw39SyG/j6F6rXK8w42QneLdKAb
         cASHoBxua1B6qO/pdQdwKNwiVukul10gnBUUw=
MIME-Version: 1.0
In-Reply-To: <20110221190713.GM13092@random.random>
References: <cover.1298212517.git.minchan.kim@gmail.com>
	<20110221190713.GM13092@random.random>
Date: Tue, 22 Feb 2011 07:59:51 +0900
Message-ID: <AANLkTimOhgK953rmOw4PqnoFq_e7y6j1m+NBDYJehkds@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] fadvise(DONTNEED) support
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Tue, Feb 22, 2011 at 4:07 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hello,
>
> On Sun, Feb 20, 2011 at 11:43:35PM +0900, Minchan Kim wrote:
>> Recently, there was a reported problem about thrashing.
>> (http://marc.info/?l=rsync&m=128885034930933&w=2)
>> It happens by backup workloads(ex, nightly rsync).
>> That's because the workload makes just use-once pages
>> and touches pages twice. It promotes the page into
>
> "recently" and "thrashing horribly" seem to signal a regression. Ok
> that trying to have backup not messing up the VM working set, but by
> any means running rsync in a loop shouldn't lead a server into
> "trashing horribly" (other than for the additional disk I/O, just like
> if rsync would be using O_DIRECT).
>
> This effort in teaching rsync to tell the VM it's likely an used-once
> type of access to the cache is good (tar will need it too), but if
> this is a regression like it appears from the words above ("recently"
> and "trashing horribly"), I suspect it's much higher priority to fix a
> VM regression than to add fadvise support in rsync/tar. Likely if the
> system didn't start "trashing horribly", they wouldn't need rsync.
>
> Then fadvise becomes an improvement on top of that.
>
> It'd be nice if at least it was tested if older kernel wouldn't trash
> horribly after being left inactive overnight. If it still trashes
> horribly with 2.6.18 ok... ignore this, otherwise we need a real fix.

I don't have a reproducible experiment.
I started the series with Ben's complain.
http://marc.info/?l=rsync&m=128885034930933&w=2
I don't know Ben could test it with older kernel since recently he got silent.

I am not sure older kernel worked well such as workload.
That's because Rik had been pointed out rsync's two touch
problem(http://linux-mm.org/PageReplacementRequirements) and solved
part of the problem with remaining half of the active file pages(look
at inactive_file_is_low) on 2.6.28's big change reclaim.
So I think the problem about such workload have been in there.

>
> I'm quite comfortable that older kernels would do perfectly ok with a
> loop of rsync overnight while the system was idle. I also got people
> asking me privately what to do to avoid the backup to swapout, that
> further make me believe something regressed recently as older VM code
> would never swapout on such a workload, even if you do used twice or 3
> times in a row. If it swapout that's the real bug.

Hmm,,,

>
> I had questions about limiting the pagecache size to a certain amount,
> that works too, but that's again a band aid like fadvise, and it's
> real minor issue compared to fixing the VM so that at least you can
> tell the kernel "nuke all clean cache first", being able to tell the
> kernel just that (even if some VM clever algorithm thinks swapping is
> better and we want to swap by default) will fix it. We still need a
> way to make the kernel behave perfect with zero swapping without
> fadvise and without limiting the cache. Maybe setting swappiness to 0
> just does that, I suggested that and I heard nothing back.

I don't think it's desirable to set swappiness to 0 since it changes
system global reclaim policy for preventing just a backing program's
wrong behavior.
And this patch's benefit is not only for preventing working set.
Before this patch, application should sync the data before fadvise to
take a effect but it's very inefficient by slow sync operation. If the
invalidation meet dirty page, it can skip the page. But after this
patch, application could fdavise without sync because we could move
the page of head/or tail of inactive list.

So I think the patch is valuable enough to merge?

>
> If you can reproduce I suggest making sure that at least it doesn't
> swap anything during the overnight workload as that would signal a
> definitive problem.
>
with swappiness = 0?
As I said, I don't like the solution.

And as I said, I need Ben's help but I am not sure he can.
Thanks for the review, Andrea.


-- 
Kind regards,
Minchan Kim
