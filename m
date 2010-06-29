Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0F2NCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:02:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0F2NCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:02:16 -0400
Date: Tue, 29 Jun 2010 09:02:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       torvalds@osdl.org
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Message-ID: <20100629130214.GA21410@infradead.org>
References: <20100624030212.676457061@suse.de>
 <20100624030725.885831564@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030725.885831564@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should actually be on it's way to Linus for .35, shouldn't it?

On Thu, Jun 24, 2010 at 01:02:14PM +1000, npiggin@suse.de wrote:
> list_for_each_entry_safe is not suitable to protect against concurrent
> modification of the list. 6754af6 introduced a race in sb walking.
> 
> list_for_each_entry can use the trick of pinning the current entry in
> the list before we drop and retake the lock because it subsequently
> follows cur->next. However list_for_each_entry_safe saves n=cur->next
> for following before entering the loop body, so when the lock is
> dropped, n may be deleted.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/dcache.c          |    2 ++
>  fs/super.c           |    6 ++++++
>  include/linux/list.h |   15 +++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c
> +++ linux-2.6/fs/dcache.c
> @@ -590,6 +590,8 @@ static void prune_dcache(int count)
>  			up_read(&sb->s_umount);
>  		}
>  		spin_lock(&sb_lock);
> +		/* lock was dropped, must reset next */
> +		list_safe_reset_next(sb, n, s_list);
>  		count -= pruned;
>  		__put_super(sb);
>  		/* more work left to do? */
> Index: linux-2.6/fs/super.c
> ===================================================================
> --- linux-2.6.orig/fs/super.c
> +++ linux-2.6/fs/super.c
> @@ -374,6 +374,8 @@ void sync_supers(void)
>  			up_read(&sb->s_umount);
>  
>  			spin_lock(&sb_lock);
> +			/* lock was dropped, must reset next */
> +			list_safe_reset_next(sb, n, s_list);
>  			__put_super(sb);
>  		}
>  	}
> @@ -405,6 +407,8 @@ void iterate_supers(void (*f)(struct sup
>  		up_read(&sb->s_umount);
>  
>  		spin_lock(&sb_lock);
> +		/* lock was dropped, must reset next */
> +		list_safe_reset_next(sb, n, s_list);
>  		__put_super(sb);
>  	}
>  	spin_unlock(&sb_lock);
> @@ -585,6 +589,8 @@ static void do_emergency_remount(struct
>  		}
>  		up_write(&sb->s_umount);
>  		spin_lock(&sb_lock);
> +		/* lock was dropped, must reset next */
> +		list_safe_reset_next(sb, n, s_list);
>  		__put_super(sb);
>  	}
>  	spin_unlock(&sb_lock);
> Index: linux-2.6/include/linux/list.h
> ===================================================================
> --- linux-2.6.orig/include/linux/list.h
> +++ linux-2.6/include/linux/list.h
> @@ -544,6 +544,21 @@ static inline void list_splice_tail_init
>  	     &pos->member != (head); 					\
>  	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
>  
> +/**
> + * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
> + * @pos:	the loop cursor used in the list_for_each_entry_safe loop
> + * @n:		temporary storage used in list_for_each_entry_safe
> + * @member:	the name of the list_struct within the struct.
> + *
> + * list_safe_reset_next is not safe to use in general if the list may be
> + * modified concurrently (eg. the lock is dropped in the loop body). An
> + * exception to this is if the cursor element (pos) is pinned in the list,
> + * and list_safe_reset_next is called after re-taking the lock and before
> + * completing the current iteration of the loop body.
> + */
> +#define list_safe_reset_next(pos, n, member)				\
> +	n = list_entry(pos->member.next, typeof(*pos), member)
> +
>  /*
>   * Double linked lists with a single pointer list head.
>   * Mostly useful for hash tables where the two pointer list head is
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
