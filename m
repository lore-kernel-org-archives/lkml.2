Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2JKSzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2JKSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:55:42 -0400
Date: Thu, 11 Oct 2012 14:55:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
Message-ID: <20121011185536.GE28268@redhat.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50762182.5090806@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:31:46AM +0900, Jun'ichi Nomura wrote:

[..]
> Below is the updated version of the patch.
> 
> ======================================================================
> blk_put_rl() does not call blkg_put() for q->root_rl because we
> don't take request list reference on q->root_blkg.
> However, if root_blkg is once attached then detached (freed),
> blk_put_rl() is confused by the bogus pointer in q->root_blkg.
> 
> For example, with !CONFIG_BLK_DEV_THROTTLING && CONFIG_CFQ_GROUP_IOSCHED,
> switching IO scheduler from cfq to deadline will cause system stall
> after the following warning with 3.6:
> 
> > WARNING: at /work/build/linux/block/blk-cgroup.h:250 blk_put_rl+0x4d/0x95()
> > Modules linked in: bridge stp llc sunrpc acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> > Pid: 0, comm: swapper/0 Not tainted 3.6.0 #1
> > Call Trace:
> >  <IRQ>  [<ffffffff810453bd>] warn_slowpath_common+0x85/0x9d
> >  [<ffffffff810453ef>] warn_slowpath_null+0x1a/0x1c
> >  [<ffffffff811d5f8d>] blk_put_rl+0x4d/0x95
> >  [<ffffffff811d614a>] __blk_put_request+0xc3/0xcb
> >  [<ffffffff811d71a3>] blk_finish_request+0x232/0x23f
> >  [<ffffffff811d76c3>] ? blk_end_bidi_request+0x34/0x5d
> >  [<ffffffff811d76d1>] blk_end_bidi_request+0x42/0x5d
> >  [<ffffffff811d7728>] blk_end_request+0x10/0x12
> >  [<ffffffff812cdf16>] scsi_io_completion+0x207/0x4d5
> >  [<ffffffff812c6fcf>] scsi_finish_command+0xfa/0x103
> >  [<ffffffff812ce2f8>] scsi_softirq_done+0xff/0x108
> >  [<ffffffff811dcea5>] blk_done_softirq+0x8d/0xa1
> >  [<ffffffff810915d5>] ? generic_smp_call_function_single_interrupt+0x9f/0xd7
> >  [<ffffffff8104cf5b>] __do_softirq+0x102/0x213
> >  [<ffffffff8108a5ec>] ? lock_release_holdtime+0xb6/0xbb
> >  [<ffffffff8104d2b4>] ? raise_softirq_irqoff+0x9/0x3d
> >  [<ffffffff81424dfc>] call_softirq+0x1c/0x30
> >  [<ffffffff81011beb>] do_softirq+0x4b/0xa3
> >  [<ffffffff8104cdb0>] irq_exit+0x53/0xd5
> >  [<ffffffff8102d865>] smp_call_function_single_interrupt+0x34/0x36
> >  [<ffffffff8142486f>] call_function_single_interrupt+0x6f/0x80
> >  <EOI>  [<ffffffff8101800b>] ? mwait_idle+0x94/0xcd
> >  [<ffffffff81018002>] ? mwait_idle+0x8b/0xcd
> >  [<ffffffff81017811>] cpu_idle+0xbb/0x114
> >  [<ffffffff81401fbd>] rest_init+0xc1/0xc8
> >  [<ffffffff81401efc>] ? csum_partial_copy_generic+0x16c/0x16c
> >  [<ffffffff81cdbd3d>] start_kernel+0x3d4/0x3e1
> >  [<ffffffff81cdb79e>] ? kernel_init+0x1f7/0x1f7
> >  [<ffffffff81cdb2dd>] x86_64_start_reservations+0xb8/0xbd
> >  [<ffffffff81cdb3e3>] x86_64_start_kernel+0x101/0x110
> 
> This patch clears q->root_blkg and q->root_rl.blkg when root blkg
> is destroyed.
> __blk_queue_next_rl(), which uses q->root_blkg without check,
> is changed to exit early when all blkg's are destroyed.
> 

Thanks. This patch looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index f3b44a6..a31e678 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -285,6 +285,13 @@ static void blkg_destroy_all(struct request_queue *q)
>  		blkg_destroy(blkg);
>  		spin_unlock(&blkcg->lock);
>  	}
> +
> +	/*
> +	 * root blkg is destroyed.  Just clear the pointer since
> +	 * root_rl does not take reference on root blkg.
> +	 */
> +	q->root_blkg = NULL;
> +	q->root_rl.blkg = NULL;
>  }
>  
>  static void blkg_rcu_free(struct rcu_head *rcu_head)
> @@ -326,6 +333,9 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
>  	 */
>  	if (rl == &q->root_rl) {
>  		ent = &q->blkg_list;
> +		/* There are no more block groups, hence no request lists */
> +		if (list_empty(ent))
> +			return NULL;
>  	} else {
>  		blkg = container_of(rl, struct blkcg_gq, rl);
>  		ent = &blkg->q_node;
