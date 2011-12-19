Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1LSFrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:47:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:13686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1LSFrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:47:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="88921224"
Date: Mon, 19 Dec 2011 13:44:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111219054444.GA7030@localhost>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
 <20111216003157.GA23662@dastard>
 <20111216015311.GA15996@localhost>
 <20111216042508.GE23662@dastard>
 <20111216051609.GA4502@localhost>
 <20111219015716.GL23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219015716.GL23662@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 09:57:16AM +0800, Dave Chinner wrote:
> On Fri, Dec 16, 2011 at 01:16:09PM +0800, Wu Fengguang wrote:
> > On Fri, Dec 16, 2011 at 12:25:08PM +0800, Dave Chinner wrote:
> > > On Fri, Dec 16, 2011 at 09:53:11AM +0800, Wu Fengguang wrote:
> > > > I'm indeed happy that you don't care that much on that regression
> > > > introduced by me ;-)
> > > 
> > > Heh.
> > > 
> > > BTW, do these tests run to ENOSPC?
> > 
> > Nope. Shall ENOSPC (performance) be tested?
> > 
> > > >                 10829.00        +4.3%     11296.00  TOTAL xfs:xfs_delalloc_enospc
> > > 
> > > This implies that it does.
> > 
> > Not really. The USB key partition size is 7.1GB.
> > Even in the fastest 1dd case, only 4GB data is written:
> 
> There's a couple of ways this can be tripping ENOSPC during delayed
> allocation. Speculative preallocation is the most likely cause given
> that for a 4GB file being written sequentially it will try to
> preallocate a 4GB chunk for the next delalloc extent....

Yeah I suspected some heuristic allocation, too.

> And by triggering this path, it will force data writeback to occur
> through the xfssyncd workqueue. i.e. the writeback behaviour that is
> occurring is not what you are expecting it to be - XFS is detecting
> a potential ENOSPC problem, and taking steps to flush delalloc data
> much faster than writeback is doing.

OK.

> > wfg@bee /export/writeback% cat fat/UKEY-thresh=100M/xfs-1dd-1-3.2.0-rc3/ls-files 
> > 131 -rw-rw-r-- 1 root root 4060078080 Dec  8 15:57 /fs/sdb3/zero-1
> 
> What's the dd command line you are using?

It's a loop of

        dd bs=$bs if=/dev/zero of=$mnt/zero-$i &

where bs=4k by default.

Thanks,
Fengguang
