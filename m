Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab2ILCmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:42:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:54106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122Ab2ILCmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:42:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="220996402"
Date: Wed, 12 Sep 2012 10:42:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120912024249.GB17922@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wr002z39.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:28:42AM +0900, OGAWA Hirofumi wrote:
> 
> If bdi has BDI_CAP_NO_WRITEBACK, bdi_forker_thread() doesn't start
> writeback thread. This means there is no consumer of work item made
> by bdi_queue_work().
> 
> This adds to checking of !bdi_cap_writeback_dirty(sb->s_bdi) before
> calling bdi_queue_work(), otherwise queued work never be consumed.

Thanks for catching this! Does this bug have any side effects other
than memory leaking? It may be possible for some caller that actually
expect it to do some work to make progress, otherwise will eventually
block.  If so, we'll need to fix the caller.

Thanks,
Fengguang

> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/fs-writeback.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff -puN fs/fs-writeback.c~noop_backing_dev_info-check-fix fs/fs-writeback.c
> --- linux/fs/fs-writeback.c~noop_backing_dev_info-check-fix	2012-09-11 06:12:30.000000000 +0900
> +++ linux-hirofumi/fs/fs-writeback.c	2012-09-11 06:12:30.000000000 +0900
> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
>  {
>  	struct wb_writeback_work *work;
>  
> +	if (!bdi_cap_writeback_dirty(bdi))
> +		return;
> +
>  	/*
>  	 * This is WB_SYNC_NONE writeback, so if allocation fails just
>  	 * wakeup the thread for old dirty data writeback
> @@ -1310,7 +1313,7 @@ void writeback_inodes_sb_nr(struct super
>  		.reason			= reason,
>  	};
>  
> -	if (sb->s_bdi == &noop_backing_dev_info)
> +	if (!bdi_cap_writeback_dirty(sb->s_bdi))
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  	bdi_queue_work(sb->s_bdi, &work);
> @@ -1396,7 +1399,7 @@ void sync_inodes_sb(struct super_block *
>  	};
>  
>  	/* Nothing to do? */
> -	if (sb->s_bdi == &noop_backing_dev_info)
> +	if (!bdi_cap_writeback_dirty(sb->s_bdi))
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> _
> 
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
