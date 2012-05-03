Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2ECKDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:03:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:56125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2ECKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148856333"
Date: Thu, 3 May 2012 18:02:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH] btrfs: lower metadata writeback threshold on low dirty
 threshold
Message-ID: <20120503100249.GA18819@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
 <20120412142634.GA16559@quack.suse.cz>
 <20120413014026.GA9027@localhost>
 <20120503034311.GA14081@localhost>
 <20120503092528.GA1104@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503092528.GA1104@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:25:28AM +0200, Jan Kara wrote:
> On Thu 03-05-12 11:43:11, Wu Fengguang wrote:
> > This helps write performance when setting the dirty threshold to tiny numbers.
> > 
> >      3.4.0-rc2         3.4.0-rc2-btrfs4+
> >   ------------  ------------------------
> >          96.92        -0.4%        96.54  bay/thresh=1000M/btrfs-100dd-1-3.4.0-rc2
> >          98.47        +0.0%        98.50  bay/thresh=1000M/btrfs-10dd-1-3.4.0-rc2
> >          99.38        -0.3%        99.06  bay/thresh=1000M/btrfs-1dd-1-3.4.0-rc2
> >          98.04        -0.0%        98.02  bay/thresh=100M/btrfs-100dd-1-3.4.0-rc2
> >          98.68        +0.3%        98.98  bay/thresh=100M/btrfs-10dd-1-3.4.0-rc2
> >          99.34        -0.0%        99.31  bay/thresh=100M/btrfs-1dd-1-3.4.0-rc2
> >   ==>    88.98        +9.6%        97.53  bay/thresh=10M/btrfs-10dd-1-3.4.0-rc2
> >   ==>    86.99       +13.1%        98.39  bay/thresh=10M/btrfs-1dd-1-3.4.0-rc2
> >   ==>     2.75     +2442.4%        69.88  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2
> >   ==>     3.31     +2634.1%        90.54  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2
> > 
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> > ---
> >  fs/btrfs/disk-io.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- linux-next.orig/fs/btrfs/disk-io.c	2012-05-02 14:04:00.989262395 +0800
> > +++ linux-next/fs/btrfs/disk-io.c	2012-05-02 14:04:01.773262414 +0800
> > @@ -930,7 +930,8 @@ static int btree_writepages(struct addre
> >  
> >  		/* this is a bit racy, but that's ok */
> >  		num_dirty = root->fs_info->dirty_metadata_bytes;
> > -		if (num_dirty < thresh)
> > +		if (num_dirty < min(thresh,
> > +				    global_dirty_limit << (PAGE_CACHE_SHIFT-2)))
> >  			return 0;
> >  	}
> >  	return btree_write_cache_pages(mapping, wbc);
>   Frankly, that whole condition on WB_SYNC_NONE in btree_writepages() looks
> like a hack. I think we also had problems with this condition when we tried
> to change b_more_io list handling. I found rather terse commit message
> explaining the code:
> Btrfs: Limit btree writeback to prevent seeks
> 
>   Which I kind of understand but is it that bad? Also I think last time we
> stumbled over this code we were discussing that these dirty metadata would
> be simply hidden from mm which would solve the problem of flusher thread
> trying to outsmart the filesystem... But I guess noone had time to
> implement this for btrfs.

Yeah I have the same uneasy feelings. Actually my first attempt was to
remove the heuristics in btree_writepages() altogether. The result is
more or less performance degradations in the normal cases:

wfg@bee /export/writeback% ./compare bay/*/*-{3.4.0-rc2,3.4.0-rc2-btrfs+} 
               3.4.0-rc2          3.4.0-rc2-btrfs+  
------------------------  ------------------------  
                  190.81        -6.8%       177.82  bay/JBOD-2HDD-thresh=1000M/btrfs-100dd-1-3.4.0-rc2
                  195.86        -3.3%       189.31  bay/JBOD-2HDD-thresh=1000M/btrfs-10dd-1-3.4.0-rc2
                  196.68        -1.7%       193.30  bay/JBOD-2HDD-thresh=1000M/btrfs-1dd-1-3.4.0-rc2
                  194.83       -24.4%       147.27  bay/JBOD-2HDD-thresh=100M/btrfs-100dd-1-3.4.0-rc2
                  196.60        -2.5%       191.61  bay/JBOD-2HDD-thresh=100M/btrfs-10dd-1-3.4.0-rc2
                  197.09        -0.7%       195.69  bay/JBOD-2HDD-thresh=100M/btrfs-1dd-1-3.4.0-rc2
                  181.64        -8.7%       165.80  bay/RAID0-2HDD-thresh=1000M/btrfs-100dd-1-3.4.0-rc2
                  186.14        -2.8%       180.85  bay/RAID0-2HDD-thresh=1000M/btrfs-10dd-1-3.4.0-rc2
                  191.10        -1.5%       188.23  bay/RAID0-2HDD-thresh=1000M/btrfs-1dd-1-3.4.0-rc2
                  191.30       -20.7%       151.63  bay/RAID0-2HDD-thresh=100M/btrfs-100dd-1-3.4.0-rc2
                  186.03        -2.4%       181.54  bay/RAID0-2HDD-thresh=100M/btrfs-10dd-1-3.4.0-rc2
                  170.18        -2.5%       165.97  bay/RAID0-2HDD-thresh=100M/btrfs-1dd-1-3.4.0-rc2
                   96.18        -1.9%        94.32  bay/RAID1-2HDD-thresh=1000M/btrfs-100dd-1-3.4.0-rc2
                   97.71        -1.4%        96.36  bay/RAID1-2HDD-thresh=1000M/btrfs-10dd-1-3.4.0-rc2
                   97.57        -0.4%        97.23  bay/RAID1-2HDD-thresh=1000M/btrfs-1dd-1-3.4.0-rc2
                   97.68        -6.0%        91.79  bay/RAID1-2HDD-thresh=100M/btrfs-100dd-1-3.4.0-rc2
                   97.76        -0.7%        97.07  bay/RAID1-2HDD-thresh=100M/btrfs-10dd-1-3.4.0-rc2
                   97.53        -0.3%        97.19  bay/RAID1-2HDD-thresh=100M/btrfs-1dd-1-3.4.0-rc2
                   96.92        -3.0%        94.03  bay/thresh=1000M/btrfs-100dd-1-3.4.0-rc2
                   98.47        -1.4%        97.08  bay/thresh=1000M/btrfs-10dd-1-3.4.0-rc2
                   99.38        -0.7%        98.66  bay/thresh=1000M/btrfs-1dd-1-3.4.0-rc2
                   98.04        -8.2%        89.99  bay/thresh=100M/btrfs-100dd-1-3.4.0-rc2
                   98.68        -0.6%        98.09  bay/thresh=100M/btrfs-10dd-1-3.4.0-rc2
                   99.34        -0.7%        98.62  bay/thresh=100M/btrfs-1dd-1-3.4.0-rc2
                   88.98        -0.5%        88.51  bay/thresh=10M/btrfs-10dd-1-3.4.0-rc2
                   86.99       +14.5%        99.60  bay/thresh=10M/btrfs-1dd-1-3.4.0-rc2
                    2.75     +1871.2%        54.18  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2
                    3.31     +2035.0%        70.70  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2
                 3635.55        -1.2%      3592.46  TOTAL write_bw

So I end up with the conservative fix in this patch.

FYI I also experimented with "global_dirty_limit << PAGE_CACHE_SHIFT"
w/o the further "/4" in this patch, however result is not good:

               3.4.0-rc2         3.4.0-rc2-btrfs3+
------------------------  ------------------------
                   96.92        -0.3%        96.62  bay/thresh=1000M/btrfs-100dd-1-3.4.0-rc2
                   98.47        +0.1%        98.56  bay/thresh=1000M/btrfs-10dd-1-3.4.0-rc2
                   99.38        -0.2%        99.23  bay/thresh=1000M/btrfs-1dd-1-3.4.0-rc2
                   98.04        +0.1%        98.15  bay/thresh=100M/btrfs-100dd-1-3.4.0-rc2
                   98.68        +0.3%        98.96  bay/thresh=100M/btrfs-10dd-1-3.4.0-rc2
                   99.34        -0.1%        99.20  bay/thresh=100M/btrfs-1dd-1-3.4.0-rc2
                   88.98        -0.3%        88.73  bay/thresh=10M/btrfs-10dd-1-3.4.0-rc2
                   86.99        +1.4%        88.23  bay/thresh=10M/btrfs-1dd-1-3.4.0-rc2
                    2.75      +232.0%         9.13  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2
                    3.31        +1.5%         3.36  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2

So this patch is kind of based on "experiment" rather than "reasoning".
And I took the easy way of using the global dirty threshold. Ideally
it should be based upon the per-bdi dirty threshold, but anyway...

Thanks,
Fengguang
