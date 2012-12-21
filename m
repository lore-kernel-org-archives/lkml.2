Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2LUKvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:51:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2LUKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:51:30 -0500
Date: Fri, 21 Dec 2012 11:51:26 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221105126.GD17357@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard>
 <CALCETrXT2uYwuYR3402LUO2uw3d++=f9vxtFLq8Ez62VdAgOcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXT2uYwuYR3402LUO2uw3d++=f9vxtFLq8Ez62VdAgOcw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-12-12 21:36:58, Andy Lutomirski wrote:
> On Thu, Dec 20, 2012 at 4:14 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
> >> The onus is currently on filesystems to call file_update_time
> >> somewhere in the page_mkwrite path.  This is unfortunate for three
> >> reasons:
> >>
> >> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
> >>    often sleeps while dirtying inodes.
> >
> > That's an ext4 problem, not a page fault or timestamp update
> > problem. Fix ext4.
> 
> I could fix ext4 (or rather, someone who understands jbd2 could fix
> ext4), but I think my approach is considerably simpler and fixes all
> filesystems at once.
  Well, you could implement the fix you did just inside ext4. Remove
timestamp update from ext4_page_mkwrite(), just set some inode flag there,
update times in ext4_writepages(), ext4_sync_file(), and
ext4_release_file(). It won't be as elegant but it would work.

> >> 3. (An ulterior motive) I'd like to use hardware dirty tracking for
> >>    shared, locked, writable mappings (instead of page faults).  Moving
> >>    important work out of the page_mkwrite path is an important first step.
> >
> > I don't think you're going to get very far doing this. page_mkwrite
> > needs to do:
> >
> >         a) block allocation in page_mkwrite() for faults over holes
> >            to detect ENOSPC conditions immediately rather than in
> >            writeback when such an error results in data loss.
> >         b) detect writes over unwritten extents so that the pages in
> >            the page cache can be set up correctly for conversion to
> >            occur during writeback.
> >
> > Correcting these two problems was the reason for introducing
> > page_mkwrite in the first place - we need to do this stuff before
> > the page fault is completed, and that means, by definition,
> > page_mkwrite needs to be able to block. Moving c/mtime updates out
> > of the way does not, in any way, change these requirements.
> 
> I was unclear.  I have no problem if PROT_WRITE, MAP_SHARED pages
> start out write protected.  I want two changes from the status quo,
> though:
> 
> 1. ptes (maybe only if mlocked or maybe even only if some new madvise
> flag is set) should be marked clean but stay writable during and after
> writeback.  (This would only work when stable pages are not in
> effect.)
  This is actually problematic - s390 architecture doesn't have PTE dirty
bit. It has per page HW dirty bit but that's problematic to use so it's
completely relying on page being protected after writeback so that it hits
page fault when it should be dirtied again. Also memory management uses
these page faults to track number of dirty pages which is then important to
throttle aggressive writers etc. (we used to do what you describe sometimes
in early 2.6 days but then we switched to writeprotecting the page for
writeback to be able to do dirty page tracking).

If we limit the behavior you desribe to mlocked pages, I could imagine
things would work out from the accounting POV (we could treat mlocked pages
as always dirty for accounting purposes) but it's definitely not a change
to be easily made.

> 2. There should be a way to request that pages be made clean-but-writable.
> 
> #1 should be mostly fine already from the filesystems' point of view.
> #2 would involve calling page_mkwrite or some equivalent.
> 
> I suspect that there are bugs that are currently untriggerable
> involving clean-but-writable pages.  For example, what happens if cpu
> 0 (atomically) changes a pte from clean/writable to not present, but
> cpu 1 writes the page before the TLB flush happens.  I think the pte
> ends up not present + dirty, but the current unmapping code won't
> notice.
> 
> This would involve splitting page_mkclean into "make clean and write
> protect" and "make clean but leave writable".
> 
> Doing this would avoid ~1M "soft" page faults per day in a single
> real-time thread in my software.  (The file time patches are to make
> sure that the "soft" page faults actually don't sleep.)
  Yes, there's a non-negligible cost of writeprotecting the page during
writeback. But the avoidance of OOM conditions due to too aggressive
writers simply has precedence... Anyway, if you want to push more in this
direction, I suggest to move this discussion to linux-mm@kvack.org as there
are lingering more appropriate listeners :). I'm just a filesystem guy with
some basic knowledge of MM.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
