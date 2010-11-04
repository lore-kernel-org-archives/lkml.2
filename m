Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0KDDl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:41:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:32916 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab0KDDlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:41:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,293,1286175600"; 
   d="scan'208";a="854004163"
Date: Thu, 4 Nov 2010 11:41:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 00/17] [RFC] soft and dynamic dirty throttling limits
Message-ID: <20101104034119.GA18910@localhost>
References: <20100912154945.758129106@intel.com>
 <20101012141716.GA26702@infradead.org>
 <20101013030733.GV4681@dastard>
 <20101013082611.GA6733@localhost>
 <20101013092627.GY4681@dastard>
 <20101101062446.GK2715@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101062446.GK2715@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Nov 01, 2010 at 02:24:46PM +0800, Dave Chinner wrote:
> On Wed, Oct 13, 2010 at 08:26:27PM +1100, Dave Chinner wrote:
> > On Wed, Oct 13, 2010 at 04:26:12PM +0800, Wu Fengguang wrote:
> > > On Wed, Oct 13, 2010 at 11:07:33AM +0800, Dave Chinner wrote:
> > > > On Tue, Oct 12, 2010 at 10:17:16AM -0400, Christoph Hellwig wrote:
> > > > > Wu, what's the state of this series?  It looks like we'll need it
> > > > > rather sooner than later - try to get at least the preparations in
> > > > > ASAP would be really helpful.
> > > > 
> > > > Not ready in it's current form. This load (creating millions of 1
> > > > byte files in parallel):
> > > > 
> > > > $ /usr/bin/time ./fs_mark -D 10000 -S0 -n 100000 -s 1 -L 63 \
> > > > > -d /mnt/scratch/0 -d /mnt/scratch/1 \
> > > > > -d /mnt/scratch/2 -d /mnt/scratch/3 \
> > > > > -d /mnt/scratch/4 -d /mnt/scratch/5 \
> > > > > -d /mnt/scratch/6 -d /mnt/scratch/7
> > > > 
> > > > Locks up all the fs_mark processes spinning in traces like the
> > > > following and no further progress is made when the inode cache
> > > > fills memory.
> > > 
> > > I reproduced the problem on a 6G/8p 2-socket 11-disk box.
> > > 
> > > The root cause is, pageout() is somehow called with low scan priority,
> > > which deserves more investigation.
> > > 
> > > The direct cause is, balance_dirty_pages() then keeps nr_dirty too low,
> > > which can be improved easily by not pushing down the soft dirty limit
> > > to less than 1-second worth of dirty pages.
> > > 
> > > My test box has two nodes, and their memory usage are rather unbalanced:
> > > (Dave, maybe you have NUMA setup too?)
> > 
> > No, I'm running the test in a single node VM.
> > 
> > FYI, I'm running the test on XFS (16TB 12 disk RAID0 stripe), using
> > the mount options "inode64,nobarrier,logbsize=262144,delaylog".
> 
> Any update on the current status of this patchset?

The last 3 patches to dynamically lower the 20% dirty limit seem
to hurt writeback throughput when it goes too small. That's not
surprising. I tried moderately increase the low bound of dynamic
dirty limit but tests show that it's still not enough. Days ago I
came up with another low bound scheme, however the test box has
been running LKP (and other) benchmarks for the new -rc1 release..

Anyway I see some tricky points in deciding the low bound for dynamic
dirty limit. It seems reasonable to bypass this feature for now, and
to test/submit the other important parts first.

I'm feeling relatively good about the first 14 patches to do IO-less
balance_dirty_pages() and larger writeback chunk size. I'll repost
them separately as v2 after returning to Shanghai.

Some days ago I prepared some slides which has some figures on the old
and new dirty throttling schemes. Hope it helps.

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling.pdf

Thanks,
Fengguang
