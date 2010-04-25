Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0DYDd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 23:33:26 -0400
Received: from THUNK.ORG ([69.25.196.29]:33844 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0DYDdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 23:33:19 -0400
Date: Sat, 24 Apr 2010 23:33:15 -0400
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100425033315.GC667@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271731314-5893-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:41:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 
> This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> needs to terminate after a certain number of pages are written, not after a
> certain number of calls to ->writepage are made. Make it observe the current
> value of wbc->nr_to_write and treat a value of <= 0 as though it is a either a
> termination condition or a trigger to reset to MAX_WRITEḆACK_PAGES for data
> integrity syncs.

Be careful here.  If you are going to write more pages than what the
writeback code has requested (the stupid no more than 1024 pages
restriction in the writeback code before it jumps to start writing
some other inode), you actually need to let the returned
wbc->nr_to_write go negative, so that wb_writeback() knows how many
pages it has written.

In other words, the writeback code assumes that 

  <orignal value of nr_to_write> - <returned wbc->nr_to_write>

is

  <number of pages actually written>

If you don't let wbc->nr_to_write go negative, the writeback code will
be confused about how many pages were _actually_ written, and the
writeback code ends up writing too much.  See commit 2faf2e1.

All of this is a crock of course.  The file system shouldn't be
second-guessing the writeback code.  Instead the writeback code should
be adaptively measuring how long it takes to were written out N pages
to a particular block device, and then decide what's the appropriate
setting for nr_to_write.  What makes sense for a USB stick, or a 4200
RPM laptop drive, may not make sense for a massive RAID array....

But since we don't have that, both XFS and ext4 have workarounds for
brain-damaged writeback behaviour.  (I did some testing, and even for
standard laptop drives the cap of 1024 pages is just Way Too Small;
that limit was set something like a decade ago, and everyone has been
afraid to change it, even though disks have gotten a wee bit faster
since those days.)

    	   	      	       	     	 - Ted
