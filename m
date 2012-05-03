Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2ECMcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:32:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43162 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2ECMce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:32:34 -0400
Date: Thu, 3 May 2012 08:31:45 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH] btrfs: lower metadata writeback threshold on low dirty
 threshold
Message-ID: <20120503123145.GO25477@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Shaohua Li <shli@fusionio.com>
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
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

It is definitely a hack ;)  The basic point is that once we write a
metadata block, we have to cow it for any future changes.  So writing
the metadata has a pretty big impact on performance, and I'd rather
write everything else that is dirty first.  When that code was added I
was finding the metadata going to disk very soon under memory pressure.

I'm open to any ideas on this one.

-chris
