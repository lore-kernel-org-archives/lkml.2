Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0FURNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:13:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38736 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0FURNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:13:08 -0400
Date: Mon, 21 Jun 2010 10:13:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-ID: <20100621171300.GF2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:16:23PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> fs/fs-writeback.c between commits 7f0e7bed936a0c422641a046551829a01341dd80
> ("writeback: fix writeback completion notifications") and
> 3c4d716538f3eefb1c1f10961a047a6456a2b590 ("writeback: queue work on stack
> in writeback_inodes_sb") from the block tree and commit
> b97181f24212f4c29197890ce1b2b9100bcc184d ("fs: remove all rcu head
> initializations, except on_stack initializations") from the tip tree.
> 
> I fixed it up (I hope - see below) and can carry the fix as necessary.

I took a look, and all of the changes from "fs: remove all rcu head
initializations, except on_stack initializations" are reflected in -next.

							Thanx, Paul

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/fs-writeback.c
> index 5455009,af92100..0000000
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@@ -63,16 -63,45 +63,37 @@@ struct bdi_work 
>   };
>   
>   enum {
>  -	WS_USED_B = 0,
>  -	WS_ONSTACK_B,
>  +	WS_INPROGRESS = 0,
>  +	WS_ONSTACK,
>   };
>   
> - static inline void bdi_work_init(struct bdi_work *work,
> - 				 struct wb_writeback_args *args)
>  -#define WS_USED (1 << WS_USED_B)
>  -#define WS_ONSTACK (1 << WS_ONSTACK_B)
>  -
>  -static inline bool bdi_work_on_stack(struct bdi_work *work)
>  -{
>  -	return test_bit(WS_ONSTACK_B, &work->state);
>  -}
>  -
> + static inline void __bdi_work_init(struct bdi_work *work,
> + 				   struct wb_writeback_args *args,
> + 				   int on_stack)
>   {
> - 	INIT_RCU_HEAD(&work->rcu_head);
>   	work->args = *args;
>  -	work->state = WS_USED;
>  +	__set_bit(WS_INPROGRESS, &work->state);
> + 	if (on_stack) {
>  -		work->state |= WS_ONSTACK;
> ++		__set_bit(WS_ONSTACK, &work->state);
> + 		init_rcu_head_on_stack(&work->rcu_head);
> + 	}
> + }
> + 
> + static inline void bdi_work_init(struct bdi_work *work,
> + 				 struct wb_writeback_args *args)
> + {
> + 	__bdi_work_init(work, args, false);
> + }
> + 
> + static inline void bdi_work_init_on_stack(struct bdi_work *work,
> + 					  struct wb_writeback_args *args)
> + {
> + 	__bdi_work_init(work, args, true);
> + }
> + 
> + static inline void bdi_destroy_work_on_stack(struct bdi_work *work)
> + {
> + 	destroy_rcu_head_on_stack(&work->rcu_head);
>   }
>   
>   /**
> @@@ -182,19 -239,26 +203,19 @@@ static void bdi_alloc_queue_work(struc
>    * @sb: write inodes from this super_block
>    *
>    * Description:
>  - *   This does WB_SYNC_ALL data integrity writeback and waits for the
>  - *   IO to complete. Callers must hold the sb s_umount semaphore for
>  + *   This function initiates writeback and waits for the operation to
>  + *   complete. Callers must hold the sb s_umount semaphore for
>    *   reading, to avoid having the super disappear before we are done.
>    */
>  -static void bdi_sync_writeback(struct backing_dev_info *bdi,
>  -			       struct super_block *sb)
>  +static void bdi_queue_work_onstack(struct wb_writeback_args *args)
>   {
>  -	struct wb_writeback_args args = {
>  -		.sb		= sb,
>  -		.sync_mode	= WB_SYNC_ALL,
>  -		.nr_pages	= LONG_MAX,
>  -		.range_cyclic	= 0,
>  -	};
>   	struct bdi_work work;
>   
> - 	bdi_work_init(&work, args);
> - 	__set_bit(WS_ONSTACK, &work.state);
>  -	bdi_work_init_on_stack(&work, &args);
> ++	bdi_work_init_on_stack(&work, args);
>   
>  -	bdi_queue_work(bdi, &work);
>  -	bdi_wait_on_work_clear(&work);
>  +	bdi_queue_work(args->sb->s_bdi, &work);
>  +	bdi_wait_on_work_done(&work);
> + 	bdi_destroy_work_on_stack(&work);
>   }
>   
>   /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
