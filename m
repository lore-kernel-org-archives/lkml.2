Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1EMC4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:56:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:54123 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1EMC4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:56:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="642085549"
Date: Fri, 13 May 2011 10:56:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] writeback: introduce .tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110513025607.GA8016@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140030.759385136@intel.com>
 <20110512224013.GH19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512224013.GH19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:40:13AM +0800, Dave Chinner wrote:
> On Thu, May 12, 2011 at 09:57:07PM +0800, Wu Fengguang wrote:
> > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> > livelock prevention for it, too.
> > 
> > Note that writeback_inodes_sb() is called by not only sync(), they are
> > treated the same because the other callers also need livelock prevention.
> > 
> > Impact:  It changes the order in which pages/inodes are synced to disk.
> > Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> > until finished with the current inode.
> 
> What about all the filesystems that implement their own
> .writepages()/write_cache_pages() functions or have
> have special code that checks WB_SYNC_ALL in .writepages (e.g. gfs2,
> ext4, btrfs and perhaps others). Don't they all need to be aware of
> this tagged_sync field?

Right, good point. Currently only ext4 is updated. The other
filesystems --- afs, btrfs, cifs, gfs2 --- do not even use
PAGECACHE_TAG_TOWRITE for livelock prevention. My plan was to add
PAGECACHE_TAG_TOWRITE and tagged_sync code to them as the next step,
when tagged_sync is accepted and proved to work fine.

Thanks,
Fengguang
