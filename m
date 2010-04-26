Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0DZCnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 22:43:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:49529 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0DZCnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 22:43:08 -0400
Date: Sun, 25 Apr 2010 22:43:02 -0400
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100426024302.GC13043@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
 <20100425033315.GC667@thunk.org>
 <20100426014908.GD11437@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426014908.GD11437@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 11:49:08AM +1000, Dave Chinner wrote:
> 
> Yes, but that does not require a negative value to get right.  None
> of the code relies on negative nr_to_write values to do anything
> correctly, and all the termination checks are for wbc->nr_to-write
> <= 0. And the tracing shows it behaves correctly when
> wbc->nr_to_write = 0 on return. Requiring a negative number is not
> documented in any of the comments, write_cache_pages() does not
> return a negative number, etc, so I can't see why you think this is
> necessary....

In fs/fs-writeback.c, wb_writeback(), around line 774:

   		      wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;

If we want "wrote" to be reflect accurately the number of pages that
the filesystem actually wrote, then if you write more pages than what
was requested by wbc.nr_to_write, then it needs to be negative.

> XFS put a workaround in for a different reason to ext4. ext4 put it
> in to improve delayed allocation by working with larger chunks of
> pages. XFS put it in to get large IOs to be issued through
> submit_bio(), not to help the allocator...

That's why I put in ext4 at least initially, yes.  I'm working on
rewriting the ext4_writepages() code to make this unnecessary....

However...

> And to be the nasty person to shoot down your modern hardware
> theory: nr_to_write = 1024 pages works just fine on my laptop (XFS
> on indilix SSD) as well as my big test server (XFS on 12 disk RAID0)
> The server gets 1.5GB/s with pretty much perfect IO patterns with
> the fixes I posted, unlike the mess of single page IOs that occurs
> without them....

Have you tested with multiple files that are subject to writeout at
the same time?  After all, if your I/O allocator does a great job of
keeping the files contiguous in chunks larger tham 4MB, then if you
have two or more files that need to be written out, the page allocator
will round robin between the two files in 4MB chunks, and that might
not be considered an ideal I/O pattern.

Regards,

					- Ted
