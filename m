Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2FMA7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:59:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:36120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2FMA7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164885063"
Date: Wed, 13 Jun 2012 08:59:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] writeback: fix hung_task alarm when sync block
Message-ID: <20120613005945.GA24091@localhost>
References: <1339548774-4834-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339548774-4834-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:52:53AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> I use several dd processes to write a slow SD card
> dd if=/dev/sda1 of=/dev/sdc4 bs=1M count=4000
> and several sync commands(maybe > 10),dmesg show this:
> 
> [  366.888741] INFO: task sync:3518 blocked for more than 120 seconds.
> [  366.888742] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  366.888746] sync            D 00000201     0  3518   3462 0x00000000

> Too many similar messages flood the logs. So I use a present method to 
> fix this issue.
> ------------------------------------------
> Author: Mark Lord <kernel@teksavvy.com>
> Date:   Fri Sep 24 09:51:13 2010 -0400
> 
>     block: Prevent hang_check firing during long I/O
> ------------------------------------------
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Yeah that's also what I'd like to do. So you've tested it?

> ---
>  fs/fs-writeback.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index f2d0109..5d403a1 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1300,6 +1300,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  			    enum wb_reason reason)
>  {
>  	DECLARE_COMPLETION_ONSTACK(done);
> +	unsigned long hangcheck;
>  	struct wb_writeback_work work = {
>  		.sb			= sb,
>  		.sync_mode		= WB_SYNC_NONE,
> @@ -1311,7 +1312,12 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  	bdi_queue_work(sb->s_bdi, &work);
> -	wait_for_completion(&done);
> +	hangcheck = sysctl_hung_task_timeout_secs;
> +	if (hangcheck)

The hangcheck variable looks redundant.

> +		while (!wait_for_completion_timeout(&done, HZ/2))
> +			;
> +	else
> +		wait_for_completion(&done);
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr);
>  
> -- 
> 1.7.9.5
