Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0DZBtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 21:49:18 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:51803 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387Ab0DZBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 21:49:16 -0400
Date: Mon, 26 Apr 2010 11:49:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100426014908.GD11437@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
 <20100425033315.GC667@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100425033315.GC667@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 11:33:15PM -0400, tytso@mit.edu wrote:
> On Tue, Apr 20, 2010 at 12:41:53PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> > This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> > needs to terminate after a certain number of pages are written, not after a
> > certain number of calls to ->writepage are made. Make it observe the current
> > value of wbc->nr_to_write and treat a value of <= 0 as though it is a either a
> > termination condition or a trigger to reset to MAX_WRITEḆACK_PAGES for data
> > integrity syncs.
> 
> Be careful here.  If you are going to write more pages than what the
> writeback code has requested (the stupid no more than 1024 pages
> restriction in the writeback code before it jumps to start writing
> some other inode), you actually need to let the returned
> wbc->nr_to_write go negative, so that wb_writeback() knows how many
> pages it has written.
> 
> In other words, the writeback code assumes that 
> 
>   <orignal value of nr_to_write> - <returned wbc->nr_to_write>
> 
> is
> 
>   <number of pages actually written>

Yes, but that does not require a negative value to get right.  None
of the code relies on negative nr_to_write values to do anything
correctly, and all the termination checks are for wbc->nr_to-write
<= 0. And the tracing shows it behaves correctly when
wbc->nr_to_write = 0 on return. Requiring a negative number is not
documented in any of the comments, write_cache_pages() does not
return a negative number, etc, so I can't see why you think this is
necessary....

> If you don't let wbc->nr_to_write go negative, the writeback code will
> be confused about how many pages were _actually_ written, and the
> writeback code ends up writing too much.  See commit 2faf2e1.

ext4 added a "bump" to wbc->nr_to_write, then in some cases forgot
to remove it so it never returned to <= 0. Well, of course this
causes writeback to write too much! But that's an ext4 bug not
allowing nr_to_write to reach zero (not negative, but zero), not a
general writeback bug....

> All of this is a crock of course.  The file system shouldn't be
> second-guessing the writeback code.  Instead the writeback code should
> be adaptively measuring how long it takes to were written out N pages
> to a particular block device, and then decide what's the appropriate
> setting for nr_to_write.  What makes sense for a USB stick, or a 4200
> RPM laptop drive, may not make sense for a massive RAID array....

Why? Writeback should just keep pushing pages down until it congests
the block device. Then it throttles itself in get_request() and so
writeback already adapts to the load on the device.  Multiple passes
of 1024 pages per dirty inode is fine for this - a larger
nr_to_write doesn't get the block device to congestion any faster or
slower, nor does it change the behaviour once at congestion....

> But since we don't have that, both XFS and ext4 have workarounds for
> brain-damaged writeback behaviour.  (I did some testing, and even for
> standard laptop drives the cap of 1024 pages is just Way Too Small;
> that limit was set something like a decade ago, and everyone has been
> afraid to change it, even though disks have gotten a wee bit faster
> since those days.)

XFS put a workaround in for a different reason to ext4. ext4 put it
in to improve delayed allocation by working with larger chunks of
pages. XFS put it in to get large IOs to be issued through
submit_bio(), not to help the allocator...

And to be the nasty person to shoot down your modern hardware
theory: nr_to_write = 1024 pages works just fine on my laptop (XFS
on indilix SSD) as well as my big test server (XFS on 12 disk RAID0)
The server gets 1.5GB/s with pretty much perfect IO patterns with
the fixes I posted, unlike the mess of single page IOs that occurs
without them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
