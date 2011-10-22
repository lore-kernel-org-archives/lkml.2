Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1JVErO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 00:47:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:29047 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1JVErM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 00:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,390,1315206000"; 
   d="scan'208";a="65180473"
Date: Sat, 22 Oct 2011 12:46:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked
 inodes
Message-ID: <20111022044642.GA10393@localhost>
References: <20111020152240.751936131@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020152240.751936131@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get some test results for this patch: basically it's good until
patch 4. Further more, I got minor regressions when apply several
combinations of patches 5-7 and Jan's patch for the I_SYNC case.

[PATCH 1/7] writeback: introduce queue b_more_io_wait
[PATCH 2/7] writeback: avoid redirtying when ->write_inode failed to clear I_DIR
[PATCH 3/7] writeback: update wb->last_active on written pages/inodes
[PATCH 4/7] writeback: Retry kupdate work early if we need to retry some inode w

[PATCH 5/7] writeback: requeue_io_wait() on pages_skipped inode
[PATCH 6/7] writeback: requeue_io_wait() on blocked inode
[PATCH 7/7] writeback: requeue_io_wait() when failed to grab superblock

Based on the below results, I'd like to push only patches 1-4 to
linux-next and hold back the other patches for more investigation.

Overall throughput increases +1.2% if applying only patches 1-4:

3.1.0-rc9-ioless-full-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-5-next-20111014+  
------------------------  ------------------------  
                   56.47        +3.1%        58.22  thresh=100M/btrfs-10dd-4k-8p-4096M-100M:10-X
                   56.28        +1.6%        57.20  thresh=100M/btrfs-1dd-4k-8p-4096M-100M:10-X
                   56.11        +2.6%        57.56  thresh=100M/btrfs-2dd-4k-8p-4096M-100M:10-X
                   37.86        +3.5%        39.20  thresh=100M/ext3-10dd-4k-8p-4096M-100M:10-X
                   45.91        +2.2%        46.92  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
                   41.87        +2.7%        42.98  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
                   45.68        +1.7%        46.43  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
                   55.74        +1.2%        56.41  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
                   53.32        +0.7%        53.71  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
                   46.20        -2.6%        44.99  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
                   55.72        +3.9%        57.90  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   54.01        +0.4%        54.21  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   55.08        +2.0%        56.17  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   55.49        +1.3%        56.24  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   55.38        +1.7%        56.30  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.70        +0.7%        36.96  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   40.64        +0.3%        40.77  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   48.65        +1.6%        49.45  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   49.84        -2.6%        48.53  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   56.03        -1.2%        55.34  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   57.42        +0.2%        57.52  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.74        +0.4%        45.92  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   54.19        -0.7%        53.79  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.93        -0.4%        55.72  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                   35.78        -0.0%        35.77  thresh=8M/ext4-10dd-4k-8p-4096M-8M:10-X
                   55.29        +2.1%        56.43  thresh=8M/ext4-1dd-4k-8p-4096M-8M:10-X
                   51.12        +1.6%        51.94  thresh=8M/ext4-2dd-4k-8p-4096M-8M:10-X
                   31.21        +0.9%        31.48  thresh=8M/xfs-10dd-4k-8p-4096M-8M:10-X
                   54.10        +3.9%        56.22  thresh=8M/xfs-1dd-4k-8p-4096M-8M:10-X
                   46.97        +3.8%        48.75  thresh=8M/xfs-2dd-4k-8p-4096M-8M:10-X
                 1490.73        +1.2%      1509.03  TOTAL write_bw

Overall throughput after the patchset increases +1.6% if replacing
patch 5 with another patch to remove redirty_tail() on pages_skipped:

3.1.0-rc9-ioless-full-more_io_wait-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-7-next-20111014+  
------------------------  ------------------------  
                   46.22        +0.8%        46.58  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
                   42.19        +1.2%        42.68  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
                   45.50        +1.2%        46.06  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
                   54.51        +0.9%        54.97  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
                   53.19        +1.2%        53.83  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
                   43.98        +0.3%        44.11  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
                   55.76        +2.7%        57.25  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   52.94        +2.5%        54.29  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   54.52        +1.6%        55.36  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   54.94        +0.8%        55.40  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   53.91        +1.9%        54.96  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.15        +1.0%        36.53  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   38.25        +6.7%        40.80  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   45.30        +8.7%        49.24  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.23        +1.5%        48.93  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   54.21        +0.4%        54.41  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   56.07        +1.4%        56.86  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.12        -5.8%        42.52  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.94        +1.3%        54.67  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.66        +2.7%        57.15  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                  990.58        +1.6%      1006.59  TOTAL write_bw

But in general the performance is slightly worse when doing anything
more than patches 1-4.

patches 1-4 VS patches 1-4 plus requeue_io_wait() on I_SYNC

3.1.0-rc9-ioless-full-more_io_wait-5-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-9-next-20111014+  
------------------------  ------------------------  
                   58.22        -3.2%        56.38  thresh=100M/btrfs-10dd-4k-8p-4096M-100M:10-X
                   57.20        -1.1%        56.56  thresh=100M/btrfs-1dd-4k-8p-4096M-100M:10-X
                   57.56        -2.3%        56.26  thresh=100M/btrfs-2dd-4k-8p-4096M-100M:10-X
                   39.20        -0.8%        38.87  thresh=100M/ext3-10dd-4k-8p-4096M-100M:10-X
                   46.92        +0.1%        46.98  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
                   42.98        -0.7%        42.70  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
                   46.43        -0.6%        46.14  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
                   56.41        +0.1%        56.47  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
                   53.71        +1.6%        54.58  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
                   44.99        +0.4%        45.18  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
                   57.90        -0.4%        57.66  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   54.21        +1.2%        54.85  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   56.17        -0.6%        55.81  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   56.24        -1.8%        55.20  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   56.30        -2.1%        55.13  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.96        -2.0%        36.23  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   40.77        -0.2%        40.68  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   49.45        -0.6%        49.14  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.53        -1.6%        47.77  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   55.34        -0.8%        54.89  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   57.52        -1.5%        56.67  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.92        -7.2%        42.63  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.79        -1.0%        53.25  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.72        +2.4%        57.04  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                   56.22        -2.2%        54.96  thresh=8M/xfs-1dd-4k-8p-4096M-8M:10-X
                 1284.66        -1.0%      1272.05  TOTAL write_bw

patches 1-4 VS patches 1-4,7 and remove redirty_tail() on pages_skipped

3.1.0-rc9-ioless-full-more_io_wait-5-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-8-next-20111014+
------------------------  ------------------------
                   58.22        -2.9%        56.55  thresh=100M/btrfs-10dd-4k-8p-4096M-100M:10-X
                   57.20        -2.0%        56.03  thresh=100M/btrfs-1dd-4k-8p-4096M-100M:10-X
                   57.56        -2.1%        56.38  thresh=100M/btrfs-2dd-4k-8p-4096M-100M:10-X
                   39.20        -0.4%        39.06  thresh=100M/ext3-10dd-4k-8p-4096M-100M:10-X
                   46.92        -0.5%        46.68  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
                   42.98        -1.2%        42.45  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
                   46.43        -1.2%        45.89  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
                   56.41        -2.5%        54.98  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
                   53.71        -1.4%        52.96  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
                   44.99        -1.4%        44.36  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
                   57.90        -0.8%        57.42  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   54.21        -0.7%        53.84  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   56.17        -1.1%        55.57  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   56.24        -1.1%        55.61  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   56.30        -1.5%        55.47  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.96        -2.0%        36.23  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   40.77        -0.8%        40.45  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   49.45        -1.5%        48.71  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.53        -2.8%        47.17  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   55.34        -2.3%        54.05  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   57.52        -3.6%        55.47  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.92        +3.0%        47.30  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.79        -2.3%        52.54  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.72        +2.3%        57.02  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                   35.77        -0.7%        35.54  thresh=8M/ext4-10dd-4k-8p-4096M-8M:10-X
                   56.43        -2.8%        54.86  thresh=8M/ext4-1dd-4k-8p-4096M-8M:10-X
                   51.94        -2.7%        50.52  thresh=8M/ext4-2dd-4k-8p-4096M-8M:10-X
                   31.48        -0.7%        31.25  thresh=8M/xfs-10dd-4k-8p-4096M-8M:10-X
                   56.22        -2.2%        55.00  thresh=8M/xfs-1dd-4k-8p-4096M-8M:10-X
                   48.75        -2.1%        47.73  thresh=8M/xfs-2dd-4k-8p-4096M-8M:10-X
                 1509.03        -1.5%      1487.08  TOTAL write_bw

patches 1-4 VS patches 1-4,6 and remove redirty_tail() on pages_skipped

3.1.0-rc9-ioless-full-more_io_wait-5-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-6-next-20111014+  
------------------------  ------------------------  
                   57.90        -0.7%        57.48  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   54.21        -0.4%        54.01  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   56.17        -1.1%        55.57  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   56.24        -1.5%        55.37  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   56.30        -1.6%        55.38  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.96        -1.8%        36.28  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   40.77        -1.0%        40.37  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   49.45        -0.5%        49.20  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.53        +0.3%        48.68  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   55.34        -1.8%        54.34  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   57.52        -0.9%        57.03  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.92        -0.5%        45.68  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.79        +3.2%        55.52  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.72        +3.2%        57.51  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                  724.81        -0.3%       722.43  TOTAL write_bw

patches 1-4 VS patches 1-4,6,7 and remove redirty_tail() on pages_skipped

3.1.0-rc9-ioless-full-more_io_wait-5-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-7-next-20111014+  
------------------------  ------------------------  
                   46.92        -0.7%        46.58  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
                   42.98        -0.7%        42.68  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
                   46.43        -0.8%        46.06  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
                   56.41        -2.5%        54.97  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
                   53.71        +0.2%        53.83  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
                   44.99        -2.0%        44.11  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
                   57.90        -1.1%        57.25  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
                   54.21        +0.1%        54.29  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
                   56.17        -1.4%        55.36  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
                   56.24        -1.5%        55.40  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
                   56.30        -2.4%        54.96  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
                   36.96        -1.2%        36.53  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
                   40.77        +0.1%        40.80  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
                   49.45        -0.4%        49.24  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.53        +0.8%        48.93  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   55.34        -1.7%        54.41  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   57.52        -1.2%        56.86  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.92        -7.4%        42.52  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.79        +1.6%        54.67  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.72        +2.6%        57.15  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                 1016.26        -1.0%      1006.59  TOTAL write_bw

Thanks,
Fengguang
