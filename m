Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2LUBM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:12:57 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57214 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab2LUBMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:12:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsKAP2101B5LG3x/2dsb2JhbAA9CLd0hXwXc4IeAQEEAScTHCMQCAMOCi4UJQMhE4gNBbd7FIxDF4QsA5YKkEmDCA
Date: Fri, 21 Dec 2012 12:12:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221011246.GZ15182@dastard>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard>
 <20121221005825.GC13474@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221005825.GC13474@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 01:58:25AM +0100, Jan Kara wrote:
> On Fri 21-12-12 11:14:57, Dave Chinner wrote:
> > On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
> > > The onus is currently on filesystems to call file_update_time
> > > somewhere in the page_mkwrite path.  This is unfortunate for three
> > > reasons:
> > > 
> > > 1. page_mkwrite on a locked page should be fast.  ext4, for example,
> > >    often sleeps while dirtying inodes.
> > 
> > That's an ext4 problem, not a page fault or timestamp update
> > problem. Fix ext4.
>   Well, XFS doesn't journal the timestamp update which is why it gets away
> without blocking on journal. Other filesystems (and I don't think it's just
> ext4) are so benevolent with timestamps so their updates are more costly...

XFS does journal it's timestamps now. We changed that code recently,
so XFs is no different to any other filesystem in this respect.

My point is, though, that this choice (of when to update the
timestamp) can already be made by filesytsems without changing the
high level code.

> > > 2. The current behavior is surprising -- the timestamp resulting from
> > >    an mmaped write will be before the write, not after.  This contradicts
> > >    the mmap(2) manpage, which says:
> > > 
> > >      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
> > >      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
> > >      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
> > >      occurs.
> > 
> > What you propose (time updates in do_writepages()) violates this.
> > msync(MS_ASYNC) doesn't actually start any IO, therefore the
> > timestamp wil not be updated.
> > 
> > Besides, what POSIX actually says is:
> > 
> > | The st_ctime and st_mtime fields of a file that is mapped with
> > | MAP_SHARED and PROT_WRITE shall be marked for update at some point
> > | in the interval between a write reference to the mapped region and
> > | the next call to msync() with MS_ASYNC or MS_SYNC for that portion
> > | of the file by any process.
> > 
> > Which means updating the timestamp during the first write is
> > perfectly acceptible. Indeed, by definition, we are compliant with
> > the man page because the update is after the write has occurred.
> > That is, the write triggered the page fault, so the page fault
> > processing where we update the timestamps is definitely after the
> > write occurred. :)
>   Well, but there can be more writes to the already write faulted page.
> They can come seconds after we called ->page_mkwrite() and thus updated
> time stamps. So Andy is correct we violate the spec AFAICT.

Depends how you read it. It can be updated at *any time* between the
write and the msync() call, which is exactly what happens right now.
The fact that second and subsequent writes between the first write
and the msync call do not change it is irrelevant, as the first one
is the one that matters... Indeed, if you read to the letter of the
posix definition, then updating timestamps in the msync call is also
incorrect, because that is not between the write and the msync()
call.

What I'm saying is saying the current behaviour is wrong is
dependent on a specific intepretation of the standard, and the same
arguments can be made against this proposal. Hence such arguments
are not a convincing/compelling reason to change behaviours.

> > Perhaps you should implement everything you want to do inside ext4
> > first, so we can get an idea of exactly what you want page_mkwrite()
> > to do, how you want it to behave, and how you expect filesystems to
> > handle the above situations correctly....
>   Ah, now I noticed we don't call file_update_time() from
> __block_page_mkwrite() so yes, just changing ext4 without touching generic
> code is easily possible.

Yup. I'm not opposed to making such changes, but I want to see the
bigger picture before making the little changes that start moving in
that direction. Until it's demonstrated as possible with a
custom page_mkwrite implementation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
