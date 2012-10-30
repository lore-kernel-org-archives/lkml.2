Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab2J3NWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:22:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2J3NWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:22:39 -0400
Date: Tue, 30 Oct 2012 09:21:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair G Kergon <agk@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] blkcg: fix "scheduling while atomic" in
 blk_queue_bypass_start
Message-ID: <20121030132151.GA2290@redhat.com>
References: <50890937.7010809@ce.jp.nec.com>
 <20121026202105.GF24687@redhat.com>
 <508E572C.6000707@ce.jp.nec.com>
 <20121029163845.GB7709@redhat.com>
 <1351529115.24721.40.camel@twins>
 <20121029171346.GC3308@redhat.com>
 <508F3AAB.6060204@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508F3AAB.6060204@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:25:47AM +0900, Jun'ichi Nomura wrote:

[..]
> This patch moves blk_queue_bypass_start() before radix_tree_preload()
> to avoid the sleeping call while preemption is disabled.
> 
>   BUG: scheduling while atomic: multipath/2460/0x00000002
>   1 lock held by multipath/2460:
>    #0:  (&md->type_lock){......}, at: [<ffffffffa019fb05>] dm_lock_md_type+0x17/0x19 [dm_mod]
>   Modules linked in: ...
>   Pid: 2460, comm: multipath Tainted: G        W    3.7.0-rc2 #1
>   Call Trace:
>    [<ffffffff810723ae>] __schedule_bug+0x6a/0x78
>    [<ffffffff81428ba2>] __schedule+0xb4/0x5e0
>    [<ffffffff814291e6>] schedule+0x64/0x66
>    [<ffffffff8142773a>] schedule_timeout+0x39/0xf8
>    [<ffffffff8108ad5f>] ? put_lock_stats+0xe/0x29
>    [<ffffffff8108ae30>] ? lock_release_holdtime+0xb6/0xbb
>    [<ffffffff814289e3>] wait_for_common+0x9d/0xee
>    [<ffffffff8107526c>] ? try_to_wake_up+0x206/0x206
>    [<ffffffff810c0eb8>] ? kfree_call_rcu+0x1c/0x1c
>    [<ffffffff81428aec>] wait_for_completion+0x1d/0x1f
>    [<ffffffff810611f9>] wait_rcu_gp+0x5d/0x7a
>    [<ffffffff81061216>] ? wait_rcu_gp+0x7a/0x7a
>    [<ffffffff8106fb18>] ? complete+0x21/0x53
>    [<ffffffff810c0556>] synchronize_rcu+0x1e/0x20
>    [<ffffffff811dd903>] blk_queue_bypass_start+0x5d/0x62
>    [<ffffffff811ee109>] blkcg_activate_policy+0x73/0x270
>    [<ffffffff81130521>] ? kmem_cache_alloc_node_trace+0xc7/0x108
>    [<ffffffff811f04b3>] cfq_init_queue+0x80/0x28e
>    [<ffffffffa01a1600>] ? dm_blk_ioctl+0xa7/0xa7 [dm_mod]
>    [<ffffffff811d8c41>] elevator_init+0xe1/0x115
>    [<ffffffff811e229f>] ? blk_queue_make_request+0x54/0x59
>    [<ffffffff811dd743>] blk_init_allocated_queue+0x8c/0x9e
>    [<ffffffffa019ffcd>] dm_setup_md_queue+0x36/0xaa [dm_mod]
>    [<ffffffffa01a60e6>] table_load+0x1bd/0x2c8 [dm_mod]
>    [<ffffffffa01a7026>] ctl_ioctl+0x1d6/0x236 [dm_mod]
>    [<ffffffffa01a5f29>] ? table_clear+0xaa/0xaa [dm_mod]
>    [<ffffffffa01a7099>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
>    [<ffffffff811479fc>] do_vfs_ioctl+0x3fb/0x441
>    [<ffffffff811b643c>] ? file_has_perm+0x8a/0x99
>    [<ffffffff81147aa0>] sys_ioctl+0x5e/0x82
>    [<ffffffff812010be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>    [<ffffffff814310d9>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alasdair G Kergon <agk@redhat.com>
> ---

Thanks Junichi. This patch looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  block/blk-cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d0b7703..954f4be 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -791,10 +791,10 @@ int blkcg_activate_policy(struct request_queue *q,
>  	if (!blkg)
>  		return -ENOMEM;
>  
> -	preloaded = !radix_tree_preload(GFP_KERNEL);
> -
>  	blk_queue_bypass_start(q);
>  
> +	preloaded = !radix_tree_preload(GFP_KERNEL);
> +
>  	/* make sure the root blkg exists and count the existing blkgs */
>  	spin_lock_irq(q->queue_lock);
>  
