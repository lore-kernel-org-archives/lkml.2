Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1DUIBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:01:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1DUIBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:01:14 -0400
Date: Thu, 21 Apr 2011 04:00:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/6] writeback: try more writeback as long as something
 was written
Message-ID: <20110421080038.GA4959@infradead.org>
References: <20110419030532.778889102@intel.com>
 <20110419102016.GD5257@quack.suse.cz>
 <20110419111601.GA18961@localhost>
 <20110419211008.GD9556@quack.suse.cz>
 <20110420075053.GB30672@localhost>
 <20110420152211.GC4991@quack.suse.cz>
 <20110421033325.GA13764@localhost>
 <20110421070947.GA12436@dastard>
 <20110421071426.GA24790@infradead.org>
 <20110421075258.GB12436@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421075258.GB12436@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:52:58PM +1000, Dave Chinner wrote:
> > We shouldn't have I_DIRTY_PAGES set for that case, as we only redirty
> > metadata.  But we're actually doing a xfs_mark_inode_dirty, which
> > dirties all of I_DIRTY, which includes I_DIRTY_PAGES.  I guess it
> > should change to
> > 
> > 	__mark_inode_dirty(inode, I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> 
> Probably should. Using xfs_mark_inode_dirty_sync() might be the best
> thing to do.

That's not correct either - we need to set I_DIRTY_DATASYNC so that it
gets caught by fsync and not just fdatasync.

But thinking about it I'm actually not sure we need it at all.  We already
wait for the i_iocount to go to zero both in fsync and ->sync_fs, which will
catch pending I/O completions even without any VFS dirty state.  So just
marking the inode dirty (as I_DIRTY_SYNC | I_DIRTY_DATASYNC) on I/O
completion should be enough these days.

