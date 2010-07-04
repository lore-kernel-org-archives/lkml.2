Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0GDLkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 07:40:08 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1484 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0GDLkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 07:40:05 -0400
Date: Sun, 4 Jul 2010 07:37:11 -0400
From: me@bobcopeland.com
To: Davidlohr Bueso <dave.bueso@gmail.com>
Cc: linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] omfs: fix memory leak
Message-ID: <20100704113711.GA15067@hash.localnet>
References: <1278210828.27014.2.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278210828.27014.2.camel@cowboy>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 10:33:48PM -0400, Davidlohr Bueso wrote:
> Hi,
> 
> In omfs_fill_super(), when returning on error, sbi is not being freed.
> 
> Thanks,
> Davidlohr.

Hi Davidlohr,

I don't think this is right:

fill_super:
  err = omfs_fill_super()
  if (err)
     deactivate_locked_super(sb)
        kill_sb()
          generic_shutdown_super()
            sop->put_super()
  ...
  omfs_put_super()
    kfree(sbi->s_imap);
    kfree(sbi);

So your change would cause a crash at the first kfree in omfs_put_super().

It looks fine to me as-is, or am I missing something?

> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/omfs/inode.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> index 089839a..253846e 100644
> --- a/fs/omfs/inode.c
> +++ b/fs/omfs/inode.c
> @@ -523,12 +523,14 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
>  
> -	ret = 0;
> +	ret = 0; /* success */
>  out_brelse_bh2:
>  	brelse(bh2);
>  out_brelse_bh:
>  	brelse(bh);
>  end:
> +	if (ret != 0)
> +		kfree(sbi);
>  	return ret;
>  }

-- 
Bob Copeland %% www.bobcopeland.com

