Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1BPOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:35:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1BPOfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:35:33 -0500
Date: Wed, 16 Feb 2011 15:35:30 +0100
From: Jan Kara <jack@suse.cz>
To: Feng Tang <feng.tang@intel.com>
Cc: jack@suse.cz, op.q.liu@gmail.com, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, akpm@linux-foundation.org, axboe@kernel.dk
Subject: Re: ext2 write performance regression from 2.6.32
Message-ID: <20110216143530.GA5592@quack.suse.cz>
References: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
 <AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
 <20110215144641.05318556@feng-i7>
 <20110215111126.GD17313@quack.suse.cz>
 <AANLkTikGdud4FX0TcC-Sf_-_V-i8doZ73m63B=JA4kWp@mail.gmail.com>
 <20110216174031.183180c4@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216174031.183180c4@feng-i7>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-02-11 17:40:31, Feng Tang wrote:
> Hi,
> 
> I made out a debug patch which try to delay the pure FS metadata writeback
> (maxim 30 seconds to match current writeback expire time). It works for me
> on 2.6.32, and the dd performance is restored.
> 
> Please help to review it, thanks!
> 
> btw, I've sent out the block dump info requested by Jan Kara, but didn't see
> it on LKML, so attached them again.
> 
> - Feng
> 
> From c35548c7d0c3a334d24c26adab277ef62b9825db Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Wed, 16 Feb 2011 17:27:36 +0800
> Subject: [PATCH] writeback: delay the file system metadata writeback in 30 seconds
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  fs/fs-writeback.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 9d5360c..418fd9e 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -635,6 +635,16 @@ static void writeback_inodes_wb(struct bdi_writeback *wb,
>  			continue;
>  		}
>  
> +		if ((wbc->sync_mode != WB_SYNC_ALL)
> +			&& !inode->i_ino
> +			&& !strcmp(inode->i_sb->s_id, "bdev")) {
> +			if (inode->dirtied_when + 30 * HZ >  jiffies) {
> +				list_move(&inode->i_list, &wb->b_dirty);
> +				continue;
> +			} 
> +		}
> +
> +
  Doh, this is a crude hack! Nice for debugging but no way to get this into
the kernel. We have to find a cleaner way to speedup the writeback...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
