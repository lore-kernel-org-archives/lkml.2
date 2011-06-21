Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1FUJ6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab1FUJ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:58:29 -0400
Subject: Re: [PATCH 7/7] writeback: timestamp based bdi dirty_exceeded state
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110620200950.GA18537@infradead.org>
References: <20110619150108.691351746@intel.com>
	 <20110619150510.717948499@intel.com> <20110620200950.GA18537@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 21 Jun 2011 11:00:03 +0100
Message-ID: <1308650403.2762.12.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-06-20 at 16:09 -0400, Christoph Hellwig wrote:
> On Sun, Jun 19, 2011 at 11:01:15PM +0800, Wu Fengguang wrote:
> > When there are only one (or several) dirtiers, dirty_exceeded is always
> > (or mostly) off. Converting to timestamp avoids this problem. It helps
> > to use smaller write_chunk for smoother throttling.
> 
> In current mainline gfs2 has grown a non-trivial reference to
> backing_dev_info.dirty_exceeded, which needs to be dealt with.
> 
So let me try and explain whats going on there... the basic issue is
that writeback is done on a per-inode basis, but pages are accounted for
on a per-address space basis.

In GFS2, glocks referring to inodes and rgrps (resource groups) both
have an address space associated with them. These address spaces contain
the metadata that would normally be in the block device address space,
but have been separated so that we can sync and/or invalidate metadata
easily on a per-inode basis. Note that we have the additional
requirement to be able to track clean metadata, so that the existing
per-inode list of dirty metadata doesn't work for GFS2. Due to the
lifetime rules for the glocks, and the lack of an inode for rgrps, the
mapping->host for the glock address spaces has to point at the block
device inode.

Now in the normal inode case, that isn't a problem - writeback calls
->write_inode which can then write out the dirty metadata pages (if
any). The issue we've hit has been with rgrps and in particular if the
total dirty data associated with rgrps exceeds the per-bdi dirty limit.

In that case we found that writeback was spinning without making any
progress since it was trying to writeback inodes (all by that stage
clean) and it didn't have any way to start writeback on rgrps. So the
simplest solution was to check the dirty exceeded flag during inode
writeback, and if set try writing back more data than actually requested
via the ail lists. This list contains all the dirty metadata, so it
includes the rgrps too. Due to the way in which rgrps are used, it is
impossible to dirty one without also dirtying at least one inode.

In addition to that, the ordering of data blocks on the ail list is
often more optimal (especially for workloads with lots of small files)
and we get a performance improvement by doing writeback that way too.

Having said that, I know its not ideal, and I'm open to any suggestions
for better solutions,

Steve.


