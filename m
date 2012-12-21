Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2LUA6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:58:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2LUA62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:58:28 -0500
Date: Fri, 21 Dec 2012 01:58:25 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221005825.GC13474@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221001457.GY15182@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-12-12 11:14:57, Dave Chinner wrote:
> On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
> > The onus is currently on filesystems to call file_update_time
> > somewhere in the page_mkwrite path.  This is unfortunate for three
> > reasons:
> > 
> > 1. page_mkwrite on a locked page should be fast.  ext4, for example,
> >    often sleeps while dirtying inodes.
> 
> That's an ext4 problem, not a page fault or timestamp update
> problem. Fix ext4.
  Well, XFS doesn't journal the timestamp update which is why it gets away
without blocking on journal. Other filesystems (and I don't think it's just
ext4) are so benevolent with timestamps so their updates are more costly...

> > 2. The current behavior is surprising -- the timestamp resulting from
> >    an mmaped write will be before the write, not after.  This contradicts
> >    the mmap(2) manpage, which says:
> > 
> >      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
> >      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
> >      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
> >      occurs.
> 
> What you propose (time updates in do_writepages()) violates this.
> msync(MS_ASYNC) doesn't actually start any IO, therefore the
> timestamp wil not be updated.
> 
> Besides, what POSIX actually says is:
> 
> | The st_ctime and st_mtime fields of a file that is mapped with
> | MAP_SHARED and PROT_WRITE shall be marked for update at some point
> | in the interval between a write reference to the mapped region and
> | the next call to msync() with MS_ASYNC or MS_SYNC for that portion
> | of the file by any process.
> 
> Which means updating the timestamp during the first write is
> perfectly acceptible. Indeed, by definition, we are compliant with
> the man page because the update is after the write has occurred.
> That is, the write triggered the page fault, so the page fault
> processing where we update the timestamps is definitely after the
> write occurred. :)
  Well, but there can be more writes to the already write faulted page.
They can come seconds after we called ->page_mkwrite() and thus updated
time stamps. So Andy is correct we violate the spec AFAICT.

> > 3. (An ulterior motive) I'd like to use hardware dirty tracking for
> >    shared, locked, writable mappings (instead of page faults).  Moving
> >    important work out of the page_mkwrite path is an important first step.
> 
> I don't think you're going to get very far doing this. page_mkwrite
> needs to do:
> 
> 	a) block allocation in page_mkwrite() for faults over holes
> 	   to detect ENOSPC conditions immediately rather than in
> 	   writeback when such an error results in data loss.
> 	b) detect writes over unwritten extents so that the pages in
> 	   the page cache can be set up correctly for conversion to
> 	   occur during writeback.
> 
> Correcting these two problems was the reason for introducing
> page_mkwrite in the first place - we need to do this stuff before
> the page fault is completed, and that means, by definition,
> page_mkwrite needs to be able to block. Moving c/mtime updates out
> of the way does not, in any way, change these requirements.
  Here I completely agree. I wanted to comment on it in my post as well but
then forgot about it.

> Perhaps you should implement everything you want to do inside ext4
> first, so we can get an idea of exactly what you want page_mkwrite()
> to do, how you want it to behave, and how you expect filesystems to
> handle the above situations correctly....
  Ah, now I noticed we don't call file_update_time() from
__block_page_mkwrite() so yes, just changing ext4 without touching generic
code is easily possible.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
