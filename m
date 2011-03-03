Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CCQGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:06:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:42471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1CCQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:06:50 -0500
Subject: Re: [PATCH 09/27] nfs: writeback pages wait queue
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <chris.mason@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110303074949.809203319@intel.com>
References: <20110303064505.718671603@intel.com>
	 <20110303074949.809203319@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:08:01 +0100
Message-ID: <1299168481.1310.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 14:45 +0800, Wu Fengguang wrote:
> +static void nfs_wakeup_congested(long nr,
> +                                struct backing_dev_info *bdi,
> +                                wait_queue_head_t *wqh)
> +{
> +       long limit = nfs_congestion_kb >> (PAGE_SHIFT - 10);
> +
> +       if (nr < 2 * limit - min(limit / 8, NFS_WAIT_PAGES)) {
> +               if (test_bit(BDI_sync_congested, &bdi->state)) {
> +                       clear_bdi_congested(bdi, BLK_RW_SYNC);
> +                       smp_mb__after_clear_bit();
> +               }
> +               if (waitqueue_active(&wqh[BLK_RW_SYNC]))
> +                       wake_up(&wqh[BLK_RW_SYNC]);
> +       }
> +       if (nr < limit - min(limit / 8, NFS_WAIT_PAGES)) {
> +               if (test_bit(BDI_async_congested, &bdi->state)) {
> +                       clear_bdi_congested(bdi, BLK_RW_ASYNC);
> +                       smp_mb__after_clear_bit();
> +               }
> +               if (waitqueue_active(&wqh[BLK_RW_ASYNC]))
> +                       wake_up(&wqh[BLK_RW_ASYNC]);
> +       }
> +} 

memory barriers want a comment - always - explaining what they order and
against whoem.

