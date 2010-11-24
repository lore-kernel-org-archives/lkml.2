Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0KXMuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:50:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0KXMub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:50:31 -0500
Date: Wed, 24 Nov 2010 13:50:29 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] quota: Use %pV and __attribute__((format (printf in
 __quota_error and fix fallout
Message-ID: <20101124125029.GO6113@quack.suse.cz>
References: <1290566994.11971.26.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290566994.11971.26.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-11-10 18:49:54, Joe Perches wrote:
> Use %pV in __quota_error so a single printk can not be
> interleaved with other logging messages.
> Add __attribute__((format (printf, 3, 4))) so format
> and arguments can be verified by compiler.
> Make sure printk formats and arguments match.
> 
> Block # needed a pointer dereference.
  I already had a similar patch from you in my tree. So I've replaced it.

								Honza
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/quota/dquot.c         |   18 +++++++++++-------
>  fs/quota/quota_tree.c    |    9 +++++----
>  include/linux/quotaops.h |    5 +++--
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 0fed41e..84becd3 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -133,16 +133,20 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
>  EXPORT_SYMBOL(dq_data_lock);
>  
>  void __quota_error(struct super_block *sb, const char *func,
> -		  const char *fmt, ...)
> +		   const char *fmt, ...)
>  {
> -	va_list args;
> -
>  	if (printk_ratelimit()) {
> +		va_list args;
> +		struct va_format vaf;
> +
>  		va_start(args, fmt);
> -		printk(KERN_ERR "Quota error (device %s): %s: ",
> -		       sb->s_id, func);
> -		vprintk(fmt, args);
> -		printk("\n");
> +
> +		vaf.fmt = fmt;
> +		vaf.va = &args;
> +
> +		printk(KERN_ERR "Quota error (device %s): %s: %pV\n",
> +		       sb->s_id, func, &vaf);
> +
>  		va_end(args);
>  	}
>  }
> diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
> index 9e48874..e41c1becf 100644
> --- a/fs/quota/quota_tree.c
> +++ b/fs/quota/quota_tree.c
> @@ -468,8 +468,8 @@ static int remove_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  		return -ENOMEM;
>  	ret = read_blk(info, *blk, buf);
>  	if (ret < 0) {
> -		quota_error(dquot->dq_sb, "Can't read quota data "
> -			    "block %u", blk);
> +		quota_error(dquot->dq_sb, "Can't read quota data block %u",
> +			    *blk);
>  		goto out_buf;
>  	}
>  	newblk = le32_to_cpu(ref[get_index(info, dquot->dq_id, depth)]);
> @@ -493,8 +493,9 @@ static int remove_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  		} else {
>  			ret = write_blk(info, *blk, buf);
>  			if (ret < 0)
> -				quota_error(dquot->dq_sb, "Can't write quota "
> -					    "tree block %u", blk);
> +				quota_error(dquot->dq_sb,
> +					    "Can't write quota tree block %u",
> +					    *blk);
>  		}
>  	}
>  out_buf:
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index d1a9193..223b14c 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -31,8 +31,9 @@ static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
>  #define quota_error(sb, fmt, args...) \
>  	__quota_error((sb), __func__, fmt , ## args)
>  
> -extern void __quota_error(struct super_block *sb, const char *func,
> -			 const char *fmt, ...);
> +extern __attribute__((format (printf, 3, 4)))
> +void __quota_error(struct super_block *sb, const char *func,
> +		   const char *fmt, ...);
>  
>  /*
>   * declaration of quota_function calls in kernel.
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
