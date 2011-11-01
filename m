Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1KAK5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1KAK47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:56:59 -0400
Date: Tue, 1 Nov 2011 11:55:53 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
Message-ID: <20111101105553.GG5819@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
 <1317367044-475-4-git-send-email-jweiner@redhat.com>
 <20110930142805.GC869@tiehlicka.suse.cz>
 <20111028201829.GA20607@localhost>
 <20111031113321.GA30890@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031113321.GA30890@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 07:33:21PM +0800, Wu Fengguang wrote:
> > //regression
> > 3) much increased cpu %user and %system for btrfs
> 
> Sorry I find out that the CPU time regressions for btrfs are caused by
> some additional trace events enabled on btrfs (for debugging an
> unrelated btrfs hang bug) which results in 7 times more trace event
> lines:
> 
>  2701238 /export/writeback/thresh=1000M/btrfs-1dd-4k-8p-2941M-1000M:10-3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+
> 19054054 /export/writeback/thresh=1000M/btrfs-1dd-4k-8p-2941M-1000M:10-3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+
> 
> So no real regressions.

Phew :-)

> Besides, the patchset also performs good on random writes:
> 
> 3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+  3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+  
> ------------------------  ------------------------  
>                     1.65        -5.1%         1.57  MMAP-RANDWRITE-4K/btrfs-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
>                    18.65        -6.4%        17.46  MMAP-RANDWRITE-4K/ext3-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
>                     2.09        +1.2%         2.12  MMAP-RANDWRITE-4K/ext4-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
>                     2.49        -0.3%         2.48  MMAP-RANDWRITE-4K/xfs-fio_fat_mmap_randwrite_4k-4k-8p-4096M-20:10-X
>                    51.35        +0.0%        51.36  MMAP-RANDWRITE-64K/btrfs-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
>                    45.20        +0.5%        45.43  MMAP-RANDWRITE-64K/ext3-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
>                    44.77        +0.7%        45.10  MMAP-RANDWRITE-64K/ext4-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
>                    45.11        +2.5%        46.23  MMAP-RANDWRITE-64K/xfs-fio_fat_mmap_randwrite_64k-64k-8p-4096M-20:10-X
>                   211.31        +0.2%       211.74  TOTAL write_bw

Hmm, mmapped IO page allocations are not annotated yet, so I expect
this to be just runtime variations?

> And writes to USB key:
> 
> 3.1.0-rc9-ioless-full-nfs-wq5-next-20111014+  3.1.0-rc9-ioless-full-per-zone-dirty-next-20111014+  
> ------------------------  ------------------------  
>                     5.94        +0.8%         5.99  UKEY-thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
>                     2.64        -0.8%         2.62  UKEY-thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
>                     5.10        +0.3%         5.12  UKEY-thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
>                     3.26        -0.8%         3.24  UKEY-thresh=1G/ext3-2dd-4k-8p-4096M-1024M:10-X
>                     5.63        -0.5%         5.60  UKEY-thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
>                     6.04        -0.1%         6.04  UKEY-thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
>                     5.90        -0.2%         5.88  UKEY-thresh=1G/ext4-2dd-4k-8p-4096M-1024M:10-X
>                     2.45       +22.6%         3.00  UKEY-thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
>                     6.18        -0.4%         6.16  UKEY-thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
>                     4.81        +0.0%         4.81  UKEY-thresh=1G/xfs-2dd-4k-8p-4096M-1024M:10-X
>                    47.94        +1.1%        48.45  TOTAL write_bw
> 
> In summary, I see no problem at all in these trivial writeback tests.
> 
> Tested-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks!
