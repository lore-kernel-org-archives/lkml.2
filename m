Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0JEPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:25:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33876 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0JEPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:25:58 -0400
Subject: Re: [RFC][PATCH] try not to let dirty inodes fester
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        lnxninja@linux.vnet.ibm.com, axboe@kernel.dk, pbadari@us.ibm.com,
        Yuri L Volobuev <volobuev@us.ibm.com>
In-Reply-To: <20101002113238.GF4681@dastard>
References: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
	 <20101002113238.GF4681@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 08:25:45 -0700
Message-ID: <1286292345.9970.4231.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 21:32 +1000, Dave Chinner wrote:
> On Fri, Oct 01, 2010 at 12:14:49PM -0700, Dave Hansen wrote:
> > 
> > I've got a bug that I've been investigating.  The inode cache for a
> > certain fs grows and grows, desptite running
> > 
> > 	echo 2 > /proc/sys/vm/drop_caches
> > 
> > all the time.  Not that running drop_caches is a good idea, but it
> > _should_ force things to stay under control.  That is, unless the
> > inodes are dirty.
> 
> What's the filesystem, and what's the test case?

It's GPFS, which is a binary blob to me, unfortunately.  I've seen some
of the same behavior with ext3, but only after changing some of the
dirty writeout tunables to absurd values.  I think the complication with
GPFS in particular is that it doesn't use Linux's buffer cache.  We
don't trigger any of the page-based dirty watermarks since no _pages_
are being dirtied.

I've seen it happen when creating or touching large numbers of empty
files.  Yuri (cc'd) has seen it happen when mmap()'ing files but not
modifying them, since noatime is not set.

The original case that we were seeing was an NFS server serving up a
GPFS filesystem.

> > I think I'm seeing a case where the inode's dentry goes away, it
> > hits iput_final().  It is dirty, so it stays off the inode_unused
> > list waiting around for writeback.
> 
> Right - it should be on the bdi->wb->b_dirty list waiting to be
> expired and written back or already of the expired writeback queueѕ
> and waiting to be written again.
> 
> > Then, the periodic writeback happens, and we end up in
> > wb_writeback().  One of the first things we do in the loop (before
> > writing out inodes) is this:
> > 
> > 	if (work->for_background && !over_bground_thresh())
> > 		break;
> 
> Sure, but the periodic ->for_kupdate flushing should be writing
> any inode older than 30s and should be running every 5s. hence the
> background writeback aborting should not be affecting the cleaning
> of dirty inodes. Hence I don't think this is the problem your are
> looking for.

Yeah, I think you're right.  I missed that call site when I was going
through it.

> Without knowing what filesystem or what you are doing to grow the
> inode cache, it's pretty hard to say much more than this....

Thanks for looking at it.  I'm trying to see if I can reproduce any of
this with any of the in-tree fs's.  

-- Dave

