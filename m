Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0JBLeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:34:12 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:53787 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755111Ab0JBLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:34:11 -0400
Date: Sat, 2 Oct 2010 21:32:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        lnxninja@linux.vnet.ibm.com, axboe@kernel.dk, pbadari@us.ibm.com
Subject: Re: [RFC][PATCH] try not to let dirty inodes fester
Message-ID: <20101002113238.GF4681@dastard>
References: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 12:14:49PM -0700, Dave Hansen wrote:
> 
> I've got a bug that I've been investigating.  The inode cache for a
> certain fs grows and grows, desptite running
> 
> 	echo 2 > /proc/sys/vm/drop_caches
> 
> all the time.  Not that running drop_caches is a good idea, but it
> _should_ force things to stay under control.  That is, unless the
> inodes are dirty.

What's the filesystem, and what's the test case?

> I think I'm seeing a case where the inode's dentry goes away, it
> hits iput_final().  It is dirty, so it stays off the inode_unused
> list waiting around for writeback.

Right - it should be on the bdi->wb->b_dirty list waiting to be
expired and written back or already of the expired writeback queueѕ
and waiting to be written again.

> Then, the periodic writeback happens, and we end up in
> wb_writeback().  One of the first things we do in the loop (before
> writing out inodes) is this:
> 
> 	if (work->for_background && !over_bground_thresh())
> 		break;

Sure, but the periodic ->for_kupdate flushing should be writing
any inode older than 30s and should be running every 5s. hence the
background writeback aborting should not be affecting the cleaning
of dirty inodes. Hence I don't think this is the problem your are
looking for.

Without knowing what filesystem or what you are doing to grow the
inode cache, it's pretty hard to say much more than this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
