Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0DVKNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:13:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42021 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0DVKNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H4jAAfyutQlFJEiyrllJ1uDdQhPjGrJasQuokaMnoGPEk+ni4BI4R2YF7Ck2ov+8Ik
         s10z2M8jtzHijd2h9eer9lWjdtOVhHNrWa89Kp6Kaelq93YsGrgtsXnqt4gvzX9cdlGm
         osLGtAsWYpr/yjN6Znx6Eh1sYYXVwKAe/viok=
MIME-Version: 1.0
In-Reply-To: <20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
	 <alpine.DEB.2.00.1004210927550.4959@router.home>
	 <20100421150037.GJ30306@csn.ul.ie>
	 <alpine.DEB.2.00.1004211004360.4959@router.home>
	 <20100421151417.GK30306@csn.ul.ie>
	 <alpine.DEB.2.00.1004211027120.4959@router.home>
	 <20100421153421.GM30306@csn.ul.ie>
	 <alpine.DEB.2.00.1004211038020.4959@router.home>
	 <20100422092819.GR30306@csn.ul.ie>
	 <20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 22 Apr 2010 19:13:12 +0900
Message-ID: <x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 6:46 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 22 Apr 2010 10:28:20 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> On Wed, Apr 21, 2010 at 10:46:45AM -0500, Christoph Lameter wrote:
>> > On Wed, 21 Apr 2010, Mel Gorman wrote:
>> >
>> > > > > 2. Is the BUG_ON check in
>> > > > >    include/linux/swapops.h#migration_entry_to_page() now wrong? (I
>> > > > >    think yes, but I'm not sure and I'm having trouble verifying it)
>> > > >
>> > > > The bug check ensures that migration entries only occur when the page
>> > > > is locked. This patch changes that behavior. This is going too oops
>> > > > therefore in unmap_and_move() when you try to remove the migration_ptes
>> > > > from an unlocked page.
>> > > >
>> > >
>> > > It's not unmap_and_move() that the problem is occurring on but during a
>> > > page fault - presumably in do_swap_page but I'm not 100% certain.
>> >
>> > remove_migration_pte() calls migration_entry_to_page(). So it must do that
>> > only if the page is still locked.
>> >
>>
>> Correct, but the other call path is
>>
>> do_swap_page
>>   -> migration_entry_wait
>>     -> migration_entry_to_page
>>
>> with migration_entry_wait expecting the page to be locked. There is a dangling
>> migration PTEs coming from somewhere. I thought it was from unmapped swapcache
>> first, but that cannot be the case. There is a race somewhere.
>>
>> > You need to ensure that the page is not unlocked in move_to_new_page() if
>> > the migration ptes are kept.
>> >
>> > move_to_new_page() only unlocks the new page not the original page. So that is safe.
>> >
>> > And it seems that the old page is also unlocked in unmap_and_move() only
>> > after the migration_ptes have been removed? So we are fine after all...?
>> >
>>
>> You'd think but migration PTEs are being left behind in some circumstance. I
>> thought it was due to this series, but it's unlikely. It's more a case that
>> compaction heavily exercises migration.
>>
>> We can clean up the old migration PTEs though when they are encountered
>> like in the following patch for example? I'll continue investigating why
>> this dangling migration pte exists as closing that race would be a
>> better fix.
>>
>> ==== CUT HERE ====
>> mm,migration: Remove dangling migration ptes pointing to unlocked pages
>>
>> Due to some yet-to-be-identified race, it is possible for migration PTEs
>> to be left behind, When later paged-in, a BUG is triggered that assumes
>> that all migration PTEs are point to a page currently being migrated and
>> so must be locked.
>>
>> Rather than calling BUG, this patch notes the existance of dangling migration
>> PTEs in migration_entry_wait() and cleans them up.
>>
>
> I use similar patch for debugging. In my patch, this when this function founds
> dangling migration entry, return error code and do_swap_page() returns
> VM_FAULT_SIGBUS.
>
>
> Hmm..in my test, the case was.
>
> Before try_to_unmap:
>        mapcount=1, SwapCache, remap_swapcache=1
> After remap
>        mapcount=0, SwapCache, rc=0.
>
> So, I think there may be some race in rmap_walk() and vma handling or
> anon_vma handling. migration_entry isn't found by rmap_walk.
>
> Hmm..it seems this kind patch will be required for debug.

I looked do_swap_page, again.
lock_page is called long after migration_entry_wait.
It means lock_page can't close the race.

So I think this BUG is possible.
What do you think?

> -Kame
>
>
>
>



-- 
Kind regards,
Minchan Kim
