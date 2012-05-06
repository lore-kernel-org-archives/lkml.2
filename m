Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2EFJKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:10:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:6808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab2EFJKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149797009"
Date: Sun, 6 May 2012 14:01:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write time
Message-ID: <20120506060107.GA11474@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
 <20120412142634.GA16559@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412142634.GA16559@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:26:34PM +0200, Jan Kara wrote:
>   Hi Fengguang,
> 
> On Thu 12-04-12 10:20:40, Wu Fengguang wrote:
> > > > > > Note that plugging for O_SYNC writes is also removed. The user may pass
> > > > > > arbitrary @size arguments, which may be much larger than the preferable
> > > > > > I/O size, or may cross extent/device boundaries. Let the lower layers
> > > > > > handle the plugging. Otherwise the plugging code here will turn the
> > > > > > low level plugging into no-ops.
> > > > > 
> > > > > I assume you have some numbers to back this up, right?  Care to share
> > > > > those?
> > > > 
> > > > Yes please.
> > > > 
> > > > We've broken this stuff a few times recently - we should review and
> > > > test carefully.
> > > 
> > > Yes sure. Last time I posted the patch, I did some tests and found no
> > > performance changes. Now for 3.3, the tests started days ago have not
> > > finished now (partly because it is stalled for quite long time due to
> > > unknown reason). The now-available numbers for bs=4k dd's look fine.
> > > The pending tests are for bs=1M dd's and some random fio workloads.
> > > 
> > 
> > The changes are basically small enough to be considered noises.
> > But anyway here are some interpretations:
> > 
> > - application visible data write performance (write_bw) is almost the same
> > - it slightly reduces the real IOs that hit disk (io_wkB_s, io_rkB_s)
> > - disk utilization slightly increased
> > - CPU time is slightly reduced
> > 
>   Well, two of the throughput numbers stand out (in both directions
> actually) although they seem to be more extreme configurations so maybe it
> is a noise. But maybe it would deserve further check:
> 
> > $ ./compare-io bay/*/*-{3.3.0,3.3.0-plug+}
> >                    3.3.0               3.3.0-plug+
> > ------------------------  ------------------------
> ...
> >                     2.60        +7.1%         2.78  bay/thresh=1M/btrfs-10dd-1-3.3.0
> >                     3.72       -12.5%         3.25  bay/thresh=1M/btrfs-1dd-1-3.3.0

For that btrfs performance bug, Yan Zheng helped me track down the
root cause to be the hack in btree_writepages(), as we are discussing
solutions to this in the other emails.

>   I looked at other iostat numbers as well, but seeing quite some changes
> in both directions I'd say that those iostat numbers are too noisy to draw
> serious conclusion from them.

So let's proceed with the plugging change? I'll repost the split
plugging patches.

Thanks,
Fengguang
