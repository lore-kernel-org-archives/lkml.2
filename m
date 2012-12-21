Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2LUAPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:15:06 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39277 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab2LUAPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:15:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsKALGo01B5LG3x/2dsb2JhbAA9CLd0hXsXc4IeAQEEATocIwULCAMOCi4UJQMhE4gNBbgqFIxDF4QsA5YKkEmDCA
Date: Fri, 21 Dec 2012 11:14:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221001457.GY15182@dastard>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
> The onus is currently on filesystems to call file_update_time
> somewhere in the page_mkwrite path.  This is unfortunate for three
> reasons:
> 
> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>    often sleeps while dirtying inodes.

That's an ext4 problem, not a page fault or timestamp update
problem. Fix ext4.

> 2. The current behavior is surprising -- the timestamp resulting from
>    an mmaped write will be before the write, not after.  This contradicts
>    the mmap(2) manpage, which says:
> 
>      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
>      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
>      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
>      occurs.

What you propose (time updates in do_writepages()) violates this.
msync(MS_ASYNC) doesn't actually start any IO, therefore the
timestamp wil not be updated.

Besides, what POSIX actually says is:

| The st_ctime and st_mtime fields of a file that is mapped with
| MAP_SHARED and PROT_WRITE shall be marked for update at some point
| in the interval between a write reference to the mapped region and
| the next call to msync() with MS_ASYNC or MS_SYNC for that portion
| of the file by any process.

Which means updating the timestamp during the first write is
perfectly acceptible. Indeed, by definition, we are compliant with
the man page because the update is after the write has occurred.
That is, the write triggered the page fault, so the page fault
processing where we update the timestamps is definitely after the
write occurred. :)

> 3. (An ulterior motive) I'd like to use hardware dirty tracking for
>    shared, locked, writable mappings (instead of page faults).  Moving
>    important work out of the page_mkwrite path is an important first step.

I don't think you're going to get very far doing this. page_mkwrite
needs to do:

	a) block allocation in page_mkwrite() for faults over holes
	   to detect ENOSPC conditions immediately rather than in
	   writeback when such an error results in data loss.
	b) detect writes over unwritten extents so that the pages in
	   the page cache can be set up correctly for conversion to
	   occur during writeback.

Correcting these two problems was the reason for introducing
page_mkwrite in the first place - we need to do this stuff before
the page fault is completed, and that means, by definition,
page_mkwrite needs to be able to block. Moving c/mtime updates out
of the way does not, in any way, change these requirements.

Perhaps you should implement everything you want to do inside ext4
first, so we can get an idea of exactly what you want page_mkwrite()
to do, how you want it to behave, and how you expect filesystems to
handle the above situations correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
