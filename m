Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1HOSBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:01:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HOSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:01:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=MdVCcljnUSHqU3z4Wa982S/s6GLIT+HWxHPGwIoQvY5vEY5wvIm+IBweCR2uciLlT
	oDIABAi3+Qbcq5O11uW0g==
Date: Mon, 15 Aug 2011 11:00:22 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: David Gibson <dwg@au1.ibm.com>
cc: David Gibson <david@gibson.dropbear.id.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>, qemu-devel@nongnu.org, agraf@suse.de,
        kvm <kvm@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Fix refcounting in hugetlbfs quota handling
In-Reply-To: <20110813010839.GC30552@yookeroo.fritz.box>
Message-ID: <alpine.LSU.2.00.1108151057380.1394@sister.anvils>
References: <20110811064059.GU6342@yookeroo.fritz.box> <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com> <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com> <alpine.LSU.2.00.1108121126560.1290@sister.anvils>
 <20110813010839.GC30552@yookeroo.fritz.box>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Aug 2011, David Gibson wrote:
> On Fri, Aug 12, 2011 at 12:15:21PM -0700, Hugh Dickins wrote:
> > 
> > Setting that aside, I think this thing of grabbing a reference to inode
> > for each page just does not work as you wish: when we unlink an inode,
> > all its pages should be freed; but because they are themselves holding
> > references to the inode, it and its pages stick around forever.
> 
> Ugh, yes.  You're absolutely right.  That circular reference will mess
> everything up.  Thinking it through and testing fail.
> 
> > A quick experiment with your patch versus without confirmed that:
> > meminfo HugePages_Free stayed down with your patch, but went back to
> > HugePages_Total without it.  Please check, perhaps I'm just mistaken.
> > 
> > Sorry, I've not looked into what a constructive alternative might be;
> > and it's not the first time we've had this difficulty - it came up last
> > year when the ->freepage function was added, that the inode may be gone
> > by the time ->freepage(page) is called.
> 
> Ok, so.  In fact the quota functions we call at free time only need
> the super block, not the inode per se.  If we put a superblock pointer
> instead of an inode pointer in page private, and refcounted that, I
> think that should remove the circular ref.  The only reason I didn't
> do it before is that the superblock refcounting functions didn't seem
> to be globally visible in an obvious way.
> 
> Does that sound like a reasonable approach?

That does sound closer to a reaonable approach, but my guess is that it
will suck you into a world of superblock mutexes and semaphores, which
you cannot take at free_huge_page() time.

It might be necessary to hang your own tiny structure off the superblock,
with one refcount for the superblock, and one for each hugepage attached,
you freeing that structure when the count goes down to zero from either
direction.

Whatever you do needs testing with lockdep and atomic sleep checks.

I do dislike tying these separate levels together in such an unusual way,
but it is a difficult problem and I don't know of an easy answer.  Maybe
we'll need to find a better answer for other reasons, it does come up
from time to time e.g. recent race between evicting inode and nrpages
going down to 0.

You might care to take a look at how tmpfs (mm/shmem.c) deals with
the equivalent issue there (sbinfo->used_blocks).  But I expect you to
conclude that hugetlbfs cannot afford the kind of approximations that
tmpfs can afford.

Although I think tmpfs is more correct, to be associating the count
with pagecache (so the count goes down as soon as a page is truncated
or evicted from pagecache), your fewer and huger pages, and reservation
conventions, may well demand that the count stays up until the page is
actually freed back to hugepool.  And let's not pretend that what tmpfs
does is wonderful: the strange shmem_recalc_inode() tries its best to
notice when memory pressure has freed clean pages, but it never looks
beyond the inode being accessed at the times it's called.  Not at all
satisfactory, but not actually an issue in practice, since we stopped
allocating pages for simple reads from sparse file.  I did want to
convert tmpfs to use ->freepage(), but couldn't manage it without
stable mapping - same problem as you have.

Hugh
