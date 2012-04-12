Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab2DLBc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:32:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:45057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab2DLBc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:32:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131419213"
Date: Thu, 12 Apr 2012 09:32:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write time
Message-ID: <20120412013224.GA5859@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411161344.309f12ef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 04:13:44PM -0700, Andrew Morton wrote:
> On Mon, 09 Apr 2012 10:34:44 -0400
> Jeff Moyer <jmoyer@redhat.com> wrote:
> 
> > Wu Fengguang <fengguang.wu@intel.com> writes:
> > 
> > > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > > handle plug in generic_file_aio_write().
> > [snip, moved]
> > > Note that plugging for O_SYNC writes is also removed. The user may pass
> > > arbitrary @size arguments, which may be much larger than the preferable
> > > I/O size, or may cross extent/device boundaries. Let the lower layers
> > > handle the plugging. Otherwise the plugging code here will turn the
> > > low level plugging into no-ops.
> > 
> > I assume you have some numbers to back this up, right?  Care to share
> > those?
> 
> Yes please.
> 
> We've broken this stuff a few times recently - we should review and
> test carefully.

Yes sure. Last time I posted the patch, I did some tests and found no
performance changes. Now for 3.3, the tests started days ago have not
finished now (partly because it is stalled for quite long time due to
unknown reason). The now-available numbers for bs=4k dd's look fine.
The pending tests are for bs=1M dd's and some random fio workloads.

$ ./compare bay/*/*-{3.3.0,3.3.0-plug+}
                   3.3.0               3.3.0-plug+
------------------------  ------------------------
                  196.94        -0.0%       196.86  bay/JBOD-2HDD-thresh=1000M/btrfs-10dd-1-3.3.0
                  196.67        +0.2%       196.99  bay/JBOD-2HDD-thresh=1000M/btrfs-1dd-1-3.3.0
                  134.34        -0.1%       134.26  bay/JBOD-2HDD-thresh=1000M/ext3-100dd-1-3.3.0
                  141.75        +0.1%       141.92  bay/JBOD-2HDD-thresh=1000M/ext3-10dd-1-3.3.0
                  166.74        +0.1%       166.89  bay/JBOD-2HDD-thresh=1000M/ext3-1dd-1-3.3.0
                  165.90        -0.1%       165.69  bay/JBOD-2HDD-thresh=1000M/ext4-100dd-1-3.3.0
                  186.83        +0.9%       188.60  bay/JBOD-2HDD-thresh=1000M/ext4-10dd-1-3.3.0
                  193.30        -0.1%       193.04  bay/JBOD-2HDD-thresh=1000M/ext4-1dd-1-3.3.0
                  168.34        +0.1%       168.48  bay/JBOD-2HDD-thresh=1000M/xfs-100dd-1-3.3.0
                  193.43        -0.3%       192.91  bay/JBOD-2HDD-thresh=1000M/xfs-10dd-1-3.3.0
                  197.59        -0.2%       197.14  bay/JBOD-2HDD-thresh=1000M/xfs-1dd-1-3.3.0
                  197.09        -0.1%       196.90  bay/JBOD-2HDD-thresh=100M/btrfs-10dd-1-3.3.0
                  197.20        +0.1%       197.48  bay/JBOD-2HDD-thresh=100M/btrfs-1dd-1-3.3.0
                  139.07        -0.6%       138.24  bay/JBOD-2HDD-thresh=100M/ext3-10dd-1-3.3.0
                  157.10        -0.1%       156.99  bay/JBOD-2HDD-thresh=100M/ext3-1dd-1-3.3.0
                  113.36        -0.6%       112.73  bay/JBOD-2HDD-thresh=100M/ext4-100dd-1-3.3.0
                  159.88        -0.5%       159.09  bay/JBOD-2HDD-thresh=100M/ext4-10dd-1-3.3.0
                  191.53        +0.3%       192.09  bay/JBOD-2HDD-thresh=100M/ext4-1dd-1-3.3.0
                   83.65        +0.4%        83.99  bay/JBOD-2HDD-thresh=100M/xfs-100dd-1-3.3.0
                  163.12        +0.3%       163.54  bay/JBOD-2HDD-thresh=100M/xfs-10dd-1-3.3.0
                  194.25        +0.3%       194.88  bay/JBOD-2HDD-thresh=100M/xfs-1dd-1-3.3.0
                  194.98        +0.2%       195.34  bay/RAID0-2HDD-thresh=1000M/btrfs-10dd-1-3.3.0
                  194.78        +0.1%       194.96  bay/RAID0-2HDD-thresh=1000M/btrfs-1dd-1-3.3.0
                  133.07        -0.1%       132.95  bay/RAID0-2HDD-thresh=1000M/ext3-10dd-1-3.3.0
                  136.90        -0.8%       135.82  bay/RAID0-2HDD-thresh=1000M/ext3-1dd-1-3.3.0
                  167.61        -1.2%       165.65  bay/RAID0-2HDD-thresh=1000M/ext4-100dd-1-3.3.0
                  188.04        +1.1%       190.10  bay/RAID0-2HDD-thresh=1000M/ext4-10dd-1-3.3.0
                  187.74        -0.3%       187.27  bay/RAID0-2HDD-thresh=1000M/ext4-1dd-1-3.3.0
                  169.01        +0.5%       169.80  bay/RAID0-2HDD-thresh=1000M/xfs-100dd-1-3.3.0
                  192.03        +0.0%       192.10  bay/RAID0-2HDD-thresh=1000M/xfs-10dd-1-3.3.0
                  196.06        +0.0%       196.14  bay/RAID0-2HDD-thresh=1000M/xfs-1dd-1-3.3.0
                  189.04        -0.6%       187.92  bay/RAID0-2HDD-thresh=100M/btrfs-10dd-1-3.3.0
                  183.23        -0.6%       182.05  bay/RAID0-2HDD-thresh=100M/btrfs-1dd-1-3.3.0
                  137.19        -0.1%       137.12  bay/RAID0-2HDD-thresh=100M/ext3-10dd-1-3.3.0
                  140.61        -0.1%       140.54  bay/RAID0-2HDD-thresh=100M/ext3-1dd-1-3.3.0
                  114.32        -2.3%       111.71  bay/RAID0-2HDD-thresh=100M/ext4-100dd-1-3.3.0
                  162.42        -0.1%       162.31  bay/RAID0-2HDD-thresh=100M/ext4-10dd-1-3.3.0
                  183.84        -0.9%       182.19  bay/RAID0-2HDD-thresh=100M/ext4-1dd-1-3.3.0
                   89.10        -0.3%        88.84  bay/RAID0-2HDD-thresh=100M/xfs-100dd-1-3.3.0
                  162.48        -0.2%       162.20  bay/RAID0-2HDD-thresh=100M/xfs-10dd-1-3.3.0
                  188.15        +0.5%       189.12  bay/RAID0-2HDD-thresh=100M/xfs-1dd-1-3.3.0
                   97.79        -0.0%        97.76  bay/RAID1-2HDD-thresh=1000M/btrfs-10dd-1-3.3.0
                   97.69        +0.0%        97.71  bay/RAID1-2HDD-thresh=1000M/btrfs-1dd-1-3.3.0
                   69.84        -1.1%        69.05  bay/RAID1-2HDD-thresh=1000M/ext3-10dd-1-3.3.0
                   76.62        -0.0%        76.59  bay/RAID1-2HDD-thresh=1000M/ext3-1dd-1-3.3.0
                   83.97        -0.0%        83.95  bay/RAID1-2HDD-thresh=1000M/ext4-100dd-1-3.3.0
                   94.87        -0.1%        94.79  bay/RAID1-2HDD-thresh=1000M/ext4-10dd-1-3.3.0
                   96.87        +0.6%        97.46  bay/RAID1-2HDD-thresh=1000M/ext4-1dd-1-3.3.0
                   84.57        -0.1%        84.50  bay/RAID1-2HDD-thresh=1000M/xfs-100dd-1-3.3.0
                   95.51        +0.2%        95.67  bay/RAID1-2HDD-thresh=1000M/xfs-10dd-1-3.3.0
                   97.44        -0.3%        97.12  bay/RAID1-2HDD-thresh=1000M/xfs-1dd-1-3.3.0
                   97.69        -0.1%        97.56  bay/RAID1-2HDD-thresh=100M/btrfs-10dd-1-3.3.0
                   97.75        +0.1%        97.87  bay/RAID1-2HDD-thresh=100M/btrfs-1dd-1-3.3.0
                   66.68        -0.3%        66.45  bay/RAID1-2HDD-thresh=100M/ext3-10dd-1-3.3.0
                   76.23        -0.7%        75.73  bay/RAID1-2HDD-thresh=100M/ext3-1dd-1-3.3.0
                   59.36        +0.9%        59.93  bay/RAID1-2HDD-thresh=100M/ext4-100dd-1-3.3.0
                   82.63        -0.1%        82.56  bay/RAID1-2HDD-thresh=100M/ext4-10dd-1-3.3.0
                   95.77        +0.1%        95.86  bay/RAID1-2HDD-thresh=100M/ext4-1dd-1-3.3.0
                   43.77        -0.1%        43.71  bay/RAID1-2HDD-thresh=100M/xfs-100dd-1-3.3.0
                   84.24        +0.3%        84.48  bay/RAID1-2HDD-thresh=100M/xfs-10dd-1-3.3.0
                   97.81        -0.1%        97.76  bay/RAID1-2HDD-thresh=100M/xfs-1dd-1-3.3.0
                   99.27        -0.0%        99.25  bay/thresh=1000M/btrfs-10dd-1-3.3.0
                   99.39        +0.0%        99.39  bay/thresh=1000M/btrfs-1dd-1-3.3.0
                   69.75        +0.2%        69.86  bay/thresh=1000M/ext3-100dd-1-3.3.0
                   71.79        -0.0%        71.76  bay/thresh=1000M/ext3-10dd-1-3.3.0
                   80.00        -0.0%        79.99  bay/thresh=1000M/ext3-1dd-1-3.3.0
                   89.38        -0.1%        89.30  bay/thresh=1000M/ext4-100dd-1-3.3.0
                   96.43        +0.2%        96.63  bay/thresh=1000M/ext4-10dd-1-3.3.0
                   98.57        -0.3%        98.28  bay/thresh=1000M/ext4-1dd-1-3.3.0
                   93.97        -0.2%        93.76  bay/thresh=1000M/xfs-100dd-1-3.3.0
                   97.51        +0.1%        97.57  bay/thresh=1000M/xfs-10dd-1-3.3.0
                   99.68        +0.1%        99.74  bay/thresh=1000M/xfs-1dd-1-3.3.0
                   97.82        -0.2%        97.64  bay/thresh=1000M:990M/btrfs-10dd-1-3.3.0
                   98.93        +0.7%        99.58  bay/thresh=1000M:990M/btrfs-1dd-1-3.3.0
                   69.60        -0.0%        69.58  bay/thresh=1000M:990M/ext3-100dd-1-3.3.0
                   72.97        -0.2%        72.83  bay/thresh=1000M:990M/ext3-10dd-1-3.3.0
                   79.76        +0.3%        79.99  bay/thresh=1000M:990M/ext3-1dd-1-3.3.0
                   90.58        -2.1%        88.70  bay/thresh=1000M:990M/ext4-100dd-1-3.3.0
                   95.27        -0.2%        95.06  bay/thresh=1000M:990M/ext4-10dd-1-3.3.0
                   96.91        +1.6%        98.48  bay/thresh=1000M:990M/ext4-1dd-1-3.3.0
                   93.79        -0.4%        93.41  bay/thresh=1000M:990M/xfs-100dd-1-3.3.0
                   97.07        -0.4%        96.70  bay/thresh=1000M:990M/xfs-10dd-1-3.3.0
                   99.09        -0.0%        99.04  bay/thresh=1000M:990M/xfs-1dd-1-3.3.0
                   96.28        -0.2%        96.06  bay/thresh=1000M:999M/btrfs-10dd-1-3.3.0
                   94.83        +1.4%        96.15  bay/thresh=1000M:999M/btrfs-1dd-1-3.3.0
                   69.70        +0.2%        69.81  bay/thresh=1000M:999M/ext3-100dd-1-3.3.0
                   72.79        -0.3%        72.55  bay/thresh=1000M:999M/ext3-10dd-1-3.3.0
                   79.75        -0.1%        79.69  bay/thresh=1000M:999M/ext3-1dd-1-3.3.0
                   87.95        +1.6%        89.38  bay/thresh=1000M:999M/ext4-100dd-1-3.3.0
                   95.18        +0.0%        95.20  bay/thresh=1000M:999M/ext4-10dd-1-3.3.0
                   98.58        -2.3%        96.36  bay/thresh=1000M:999M/ext4-1dd-1-3.3.0
                   92.54        -0.1%        92.46  bay/thresh=1000M:999M/xfs-100dd-1-3.3.0
                   96.81        -0.4%        96.42  bay/thresh=1000M:999M/xfs-10dd-1-3.3.0
                   99.29        -0.4%        98.91  bay/thresh=1000M:999M/xfs-1dd-1-3.3.0
                   99.03        +0.1%        99.13  bay/thresh=100M/btrfs-10dd-1-3.3.0
                   99.55        -0.1%        99.40  bay/thresh=100M/btrfs-1dd-1-3.3.0
                   55.68        -0.4%        55.48  bay/thresh=100M/ext3-100dd-1-3.3.0
                   71.40        -0.6%        70.95  bay/thresh=100M/ext3-10dd-1-3.3.0
                   79.82        +0.1%        79.88  bay/thresh=100M/ext3-1dd-1-3.3.0
                   63.21        -0.4%        62.99  bay/thresh=100M/ext4-100dd-1-3.3.0
                   84.42        +0.0%        84.45  bay/thresh=100M/ext4-10dd-1-3.3.0
                   95.65        +1.9%        97.44  bay/thresh=100M/ext4-1dd-1-3.3.0
                   49.61        +0.5%        49.87  bay/thresh=100M/xfs-100dd-1-3.3.0
                   87.76        -0.0%        87.76  bay/thresh=100M/xfs-10dd-1-3.3.0
                   99.34        +0.0%        99.36  bay/thresh=100M/xfs-1dd-1-3.3.0
                   92.98        -0.7%        92.29  bay/thresh=10M/btrfs-10dd-1-3.3.0
                   89.07        +0.4%        89.44  bay/thresh=10M/btrfs-1dd-1-3.3.0
                   61.76        +0.1%        61.80  bay/thresh=10M/ext3-10dd-1-3.3.0
                   75.72        +0.3%        75.96  bay/thresh=10M/ext3-1dd-1-3.3.0
                   67.89        -0.2%        67.77  bay/thresh=10M/ext4-10dd-1-3.3.0
                   92.00        -0.3%        91.73  bay/thresh=10M/ext4-1dd-1-3.3.0
                   69.71        -0.4%        69.45  bay/thresh=10M/xfs-10dd-1-3.3.0
                   92.23        +1.8%        93.89  bay/thresh=10M/xfs-1dd-1-3.3.0
                    2.60        +7.1%         2.78  bay/thresh=1M/btrfs-10dd-1-3.3.0
                    3.72       -12.5%         3.25  bay/thresh=1M/btrfs-1dd-1-3.3.0
                   62.41        +0.3%        62.60  bay/thresh=1M/ext3-10dd-1-3.3.0
                   58.61        +0.4%        58.82  bay/thresh=1M/ext3-1dd-1-3.3.0
                   70.70        -1.1%        69.92  bay/thresh=1M/ext4-10dd-1-3.3.0
                   84.81        +0.1%        84.90  bay/thresh=1M/ext4-1dd-1-3.3.0
                   66.05        -0.1%        65.97  bay/thresh=1M/xfs-10dd-1-3.3.0
                   74.81        +0.1%        74.85  bay/thresh=1M/xfs-1dd-1-3.3.0
                13467.55        -0.0%     13460.98  TOTAL write_bw

> > > Also moves unplugging for direct I/O from around ->direct_IO() down to
> > > do_blockdev_direct_IO().
> > 
> > This could be handled in a separate patch.
> 
> I think that would be better.

OK. I'll split it on next post, after the tests complete.

Thanks,
Fengguang
