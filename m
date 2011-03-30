Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab1C3Lsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:48:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:54576 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1C3Lsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:48:35 -0400
Date: Wed, 30 Mar 2011 20:48:32 +0900 (JST)
Message-Id: <20110330.204832.186542149.ryusuke@osrg.net>
To: jaxboe@fusionio.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <4D93113E.2070805@fusionio.com>
References: <20110330.132555.158630340.ryusuke@osrg.net>
	<4D930F02.4070409@fusionio.com>
	<4D93113E.2070805@fusionio.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Mar 2011 20:48:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 13:17:18 +0200, Jens Axboe wrote:
> On 2011-03-30 13:07, Jens Axboe wrote:
> > On 2011-03-30 06:25, Ryusuke Konishi wrote:
> >> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> >> index 4d2a1ee..9d2dc6b 100644
> >> --- a/fs/nilfs2/page.c
> >> +++ b/fs/nilfs2/page.c
> >> @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
> >>  void nilfs_mapping_init(struct address_space *mapping,
> >>  			struct backing_dev_info *bdi)
> >>  {
> >> +	static const struct address_space_operations empty_aops;
> >> +
> >>  	mapping->host = NULL;
> >>  	mapping->flags = 0;
> >>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
> >>  	mapping->assoc_mapping = NULL;
> >>  	mapping->backing_dev_info = bdi;
> >> -	mapping->a_ops = NULL;
> >> +	mapping->a_ops = &empty_aops;
> >>  }
> > 
> > Hmm wait, inode init should set the mapping aops to an empty type
> > already. Does the OOPS go away if you just remove the mapping->a_ops =
> > NULL assignment?
> 
> In any case, I think this is a better fix.
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 5f4e11a..b818730 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -125,6 +125,13 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
>  static DECLARE_RWSEM(iprune_sem);
>  
>  /*
> + * Empty aops. Can be used for the cases where the user does not
> + * define any of the address_space operations.
> + */
> +const struct address_space_operations empty_aops = {
> +};
> +
> +/*
>   * Statistics gathering..
>   */
>  struct inodes_stat_t inodes_stat;
> @@ -176,7 +183,6 @@ int proc_nr_inodes(ctl_table *table, int write,
>   */
>  int inode_init_always(struct super_block *sb, struct inode *inode)
>  {
> -	static const struct address_space_operations empty_aops;
>  	static const struct inode_operations empty_iops;
>  	static const struct file_operations empty_fops;
>  	struct address_space *const mapping = &inode->i_data;
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 4d2a1ee..1168059 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -500,7 +500,7 @@ void nilfs_mapping_init(struct address_space *mapping,
>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>  	mapping->assoc_mapping = NULL;
>  	mapping->backing_dev_info = bdi;
> -	mapping->a_ops = NULL;
> +	mapping->a_ops = &empty_aops;
>  }
>  
>  /*
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index c74400f..403c192 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -80,7 +80,6 @@ enum {
>  };
>  
>  static const struct inode_operations none_inode_operations;
> -static const struct address_space_operations none_address_operations;
>  static const struct file_operations none_file_operations;
>  
>  /**
> @@ -130,7 +129,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
>  	}
>  
>  	/* Re-define all operations to be "nothing" */
> -	inode->i_mapping->a_ops = &none_address_operations;
> +	inode->i_mapping->a_ops = &empty_aops;
>  	inode->i_op = &none_inode_operations;
>  	inode->i_fop = &none_file_operations;
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 52f283c..1b95af3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -613,6 +613,8 @@ struct address_space_operations {
>  	int (*error_remove_page)(struct address_space *, struct page *);
>  };
>  
> +extern const struct address_space_operations empty_aops;
> +
>  /*
>   * pagecache_write_begin/pagecache_write_end must be used by general code
>   * to write into the pagecache.
> 
> -- 
> Jens Axboe

Sorry but I've already sent a pull request to Linus with your
Acked-by.  And, this seems to be doing two things.  One is for fixing
the current kerenl oops and another is for sharing the empty address
space operations.

I have no problem with both patches, but for the purpose of the bug
fix, the first one looks simpler.

Thanks,
Ryusuke Konishi
