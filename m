Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HYI6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:58:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44535 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1HYI6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:58:17 -0400
Subject: Re: [RFC] lockdep: Add helper function for dir vs file i_mutex
 annotation
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, davej@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Aug 2011 10:58:03 +0200
In-Reply-To: <20110825013746.GM2270@zod.bos.redhat.com>
References: <20110825013746.GM2270@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314262683.12180.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 21:37 -0400, Josh Boyer wrote:

> and make it work.  Given that the helper function calls
> lockdep_match_key and that isn't defined unless CONFIG_DEBUG_LOCK_ALLOC
> is set, I opted to make the caller require #ifdefing it still.  If that's
> too ugly, I could define it in both cases but then we'd have an exported
> symbol that did nothing when the config option is disabled.


> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 87b6e04..ab956c8 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -491,6 +491,9 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb, uid_t uid,
>  			inode->i_op = &page_symlink_inode_operations;
>  			break;
>  		}
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +		lockdep_annotate_inode_mutex_key(inode);
> +#endif
>  	}
>  	return inode;
>  }
> diff --git a/fs/inode.c b/fs/inode.c
> index 73920d5..ec1c612 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -848,16 +848,9 @@ struct inode *new_inode(struct super_block *sb)
>  }
>  EXPORT_SYMBOL(new_inode);
>  
> -/**
> - * unlock_new_inode - clear the I_NEW state and wake up any waiters
> - * @inode:	new inode to unlock
> - *
> - * Called when the inode is fully initialised to clear the new state of the
> - * inode and wake up anyone waiting for the inode to finish initialisation.
> - */
> -void unlock_new_inode(struct inode *inode)
> -{
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> +void lockdep_annotate_inode_mutex_key(struct inode *inode)
> +{
>  	if (S_ISDIR(inode->i_mode)) {
>  		struct file_system_type *type = inode->i_sb->s_type;
>  
> @@ -873,6 +866,21 @@ void unlock_new_inode(struct inode *inode)
>  					  &type->i_mutex_dir_key);
>  		}
>  	}
> +}
> +EXPORT_SYMBOL(lockdep_annotate_inode_mutex_key);
> +#endif
> +
> +/**
> + * unlock_new_inode - clear the I_NEW state and wake up any waiters
> + * @inode:	new inode to unlock
> + *
> + * Called when the inode is fully initialised to clear the new state of the
> + * inode and wake up anyone waiting for the inode to finish initialisation.
> + */
> +void unlock_new_inode(struct inode *inode)
> +{

> +	lockdep_annotate_inode_mutex_key(inode);

>  	spin_lock(&inode->i_lock);
>  	WARN_ON(!(inode->i_state & I_NEW));
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 178cdb4..a29f9af 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2318,6 +2318,9 @@ extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*te
>  extern struct inode * iget_locked(struct super_block *, unsigned long);
>  extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
>  extern int insert_inode_locked(struct inode *);
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +extern void lockdep_annotate_inode_mutex_key(struct inode *inode);

#else
static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };

> +#endif
>  extern void unlock_new_inode(struct inode *);
>  extern unsigned int get_next_ino(void);


Will avoid all the ifdeffery at usage sites nor need the pointless
export.
