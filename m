Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1EADZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 23:25:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:61548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1EADZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 23:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,296,1301900400"; 
   d="scan'208";a="686573595"
Date: Sun, 1 May 2011 11:25:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mmotm: fix hang at startup
Message-ID: <20110501032507.GA21118@localhost>
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
 <alpine.LSU.2.00.1104301929520.1343@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1104301929520.1343@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 10:35:38AM +0800, Hugh Dickins wrote:
> Yesterday's mmotm hangs at startup, and with lockdep it reports:
> BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
> called from bdev_inode_switch_bdi() in the backtrace.  It appears
> that this function is sometimes called with new the same as old.
>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Thanks!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> Fix to
> writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
> 
>  fs/block_dev.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- 2.6.39-rc5-mm1/fs/block_dev.c	2011-04-29 18:20:09.183314733 -0700
> +++ linux/fs/block_dev.c	2011-04-30 17:55:45.718785263 -0700
> @@ -57,6 +57,8 @@ static void bdev_inode_switch_bdi(struct
>  {
>  	struct backing_dev_info *old = inode->i_data.backing_dev_info;
>  
> +	if (dst == old)
> +		return;

nitpick: it could help to add a comment

        /* avoid spinlock recursion */

to indicate that's not merely an optional optimization, but indeed
required for correctness.

Thanks,
Fengguang

>  	bdi_lock_two(&old->wb, &dst->wb);
>  	spin_lock(&inode->i_lock);
>  	inode->i_data.backing_dev_info = dst;
