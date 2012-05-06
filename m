Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2EFJ6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:58:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:62885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2EFJ6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:58:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149802022"
Date: Sun, 6 May 2012 17:58:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write time
Message-ID: <20120506095810.GA17590@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412013224.GA5859@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 09:32:24AM +0800, Fengguang Wu wrote:
> On Wed, Apr 11, 2012 at 04:13:44PM -0700, Andrew Morton wrote:
> > On Mon, 09 Apr 2012 10:34:44 -0400
> > Jeff Moyer <jmoyer@redhat.com> wrote:
> > 
> > > Wu Fengguang <fengguang.wu@intel.com> writes:
> > > 
> > > > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > > > handle plug in generic_file_aio_write().
> > > [snip, moved]
> > > > Note that plugging for O_SYNC writes is also removed. The user may pass
> > > > arbitrary @size arguments, which may be much larger than the preferable
> > > > I/O size, or may cross extent/device boundaries. Let the lower layers
> > > > handle the plugging. Otherwise the plugging code here will turn the
> > > > low level plugging into no-ops.
> > > 
> > > I assume you have some numbers to back this up, right?  Care to share
> > > those?
> > 
> > Yes please.
> > 
> > We've broken this stuff a few times recently - we should review and
> > test carefully.
> 
> Yes sure. Last time I posted the patch, I did some tests and found no
> performance changes. Now for 3.3, the tests started days ago have not
> finished now (partly because it is stalled for quite long time due to
> unknown reason). The now-available numbers for bs=4k dd's look fine.

> The pending tests are for bs=1M dd's and some random fio workloads.

The bs=1M and fio performance numbers are also unchanged (within the error range):

wfg@bee /export/writeback% ./compare -g bs=1M bay/*/*-{3.3.0,3.3.0-plug+}
                   3.3.0               3.3.0-plug+
------------------------  ------------------------
                  196.56        +0.4%       197.32  bay/JBOD-2HDD-thresh=1000M/xfs-1dd:bs=1M-1-3.3.0
                   99.47        -0.2%        99.31  bay/thresh=1000M/xfs-1dd:bs=1M-1-3.3.0
                   99.19        +0.0%        99.20  bay/thresh=1000M:990M/xfs-1dd:bs=1M-1-3.3.0
                   99.03        +0.6%        99.64  bay/thresh=1000M:999M/xfs-1dd:bs=1M-1-3.3.0
                   99.37        -0.1%        99.22  bay/thresh=100M/xfs-1dd:bs=1M-1-3.3.0
                   92.62        -0.6%        92.07  bay/thresh=10M/xfs-1dd:bs=1M-1-3.3.0
                    7.38        +4.2%         7.69  bay/thresh=1M/btrfs-10dd:bs=1M-1-3.3.0
                    7.52        -0.9%         7.45  bay/thresh=1M/btrfs-10dd:bs=1M-2-3.3.0
                    8.41        +0.3%         8.44  bay/thresh=1M/btrfs-1dd:bs=1M-1-3.3.0
                    8.63        -2.9%         8.38  bay/thresh=1M/btrfs-1dd:bs=1M-2-3.3.0
                   68.98        -1.0%        68.28  bay/thresh=1M/xfs-1dd:bs=1M-1-3.3.0
                  787.17        -0.0%       786.99  TOTAL write_bw

The random writes see more fluctuations:

wfg@bee /export/writeback% ./compare fat/*/*-{3.3.0,3.3.0-plug+}      
                   3.3.0               3.3.0-plug+  
------------------------  ------------------------  
                   15.38        -8.1%        14.13  fat/fio/btrfs-fio_fat_mmap_randwrite_4k-1-3.3.0
                   15.63       -15.9%        13.14  fat/fio/btrfs-fio_fat_mmap_randwrite_4k-2-3.3.0
                   53.96        -1.3%        53.26  fat/fio/btrfs-fio_fat_mmap_randwrite_64k-1-3.3.0
                   53.36        +0.4%        53.56  fat/fio/btrfs-fio_fat_mmap_randwrite_64k-2-3.3.0
                   56.40        +1.4%        57.19  fat/fio/btrfs-fio_fat_rates-1-3.3.0
                   56.15        -0.5%        55.88  fat/fio/btrfs-fio_fat_rates-2-3.3.0
                    9.55        -2.5%         9.31  fat/fio/ext3-fio_fat_mmap_randwrite_4k-1-3.3.0
                    9.28        +2.9%         9.55  fat/fio/ext3-fio_fat_mmap_randwrite_4k-2-3.3.0
                   10.55        +2.0%        10.77  fat/fio/ext3-fio_fat_mmap_randwrite_64k-1-3.3.0
                   10.23        +5.1%        10.76  fat/fio/ext3-fio_fat_mmap_randwrite_64k-2-3.3.0
                   40.24        -0.5%        40.05  fat/fio/ext3-fio_fat_rates-1-3.3.0
                   40.11        +0.2%        40.19  fat/fio/ext3-fio_fat_rates-2-3.3.0
                    2.49        -1.3%         2.46  fat/fio/ext4-fio_fat_mmap_randwrite_4k-1-3.3.0
                    2.33        -4.6%         2.23  fat/fio/ext4-fio_fat_mmap_randwrite_4k-2-3.3.0
                    8.61        -4.5%         8.22  fat/fio/ext4-fio_fat_mmap_randwrite_64k-1-3.3.0
                    8.32        -2.5%         8.11  fat/fio/ext4-fio_fat_mmap_randwrite_64k-2-3.3.0
                   49.43        +5.8%        52.30  fat/fio/ext4-fio_fat_rates-1-3.3.0
                   50.26        +5.9%        53.25  fat/fio/ext4-fio_fat_rates-2-3.3.0
                    2.29        -1.4%         2.25  fat/fio/ext4:wb-fio_fat_mmap_randwrite_4k-1-3.3.0
                    2.76        +0.0%         2.76  fat/fio/ext4:wb-fio_fat_mmap_randwrite_4k-2-3.3.0
                    8.36        +3.5%         8.65  fat/fio/ext4:wb-fio_fat_mmap_randwrite_64k-1-3.3.0
                    8.21        -0.7%         8.16  fat/fio/ext4:wb-fio_fat_mmap_randwrite_64k-2-3.3.0
                   51.32        +2.5%        52.62  fat/fio/ext4:wb-fio_fat_rates-1-3.3.0
                   53.53        -0.4%        53.31  fat/fio/ext4:wb-fio_fat_rates-2-3.3.0
                    9.17        +4.6%         9.59  fat/fio/xfs-fio_fat_mmap_randwrite_4k-1-3.3.0
                    9.36        -0.9%         9.28  fat/fio/xfs-fio_fat_mmap_randwrite_4k-2-3.3.0
                   44.24        -0.4%        44.06  fat/fio/xfs-fio_fat_mmap_randwrite_64k-1-3.3.0
                   43.03        -0.8%        42.70  fat/fio/xfs-fio_fat_mmap_randwrite_64k-2-3.3.0
                   55.74        -7.4%        51.61  fat/fio/xfs-fio_fat_rates-1-3.3.0
                   51.64        -1.1%        51.05  fat/fio/xfs-fio_fat_rates-2-3.3.0
                  831.94        -0.2%       830.38  TOTAL write_bw

Thanks,
Fengguang
