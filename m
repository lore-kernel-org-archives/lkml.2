Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab2JKBcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:32:50 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:51093 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934330Ab2JKBcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:32:43 -0400
Message-ID: <50762182.5090806@ce.jp.nec.com>
Date: Thu, 11 Oct 2012 10:31:46 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
References: <50750367.2070508@ce.jp.nec.com> <20121010155929.GA18733@redhat.com>
In-Reply-To: <20121010155929.GA18733@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek, thank you for comments.

On 10/11/12 00:59, Vivek Goyal wrote:
> I think patch looks reasonable to me. Just that some more description
> would be nice. In fact, I will prefer some code comments too as I
> had to scratch my head for a while to figure out how did we reach here.
> 
> So looks like we deactivated cfq policy (most likely changed IO
> scheduler). That will destroy all the block groups (disconnect blkg
> from list and drop policy reference on group). If there are any pending
> IOs, then group will not be destroyed till IO is completed. (Because
> of cfqq reference on blkg and because of request list reference on
> blkg).
> 
> Now, all request list take a refenrece on associated blkg except
> q->root_rl. This means when last IO finished, it must have dropped
> the reference on cfqq which will drop reference on associated cfqg/blkg
> and immediately root blkg will be destroyed. And now we will call
> blk_put_rl() and that will try to access root_rl>blkg which has
> been just freed as last IO completed.

Yes, and for completion of any new IOs, blk_put_rl() is misled.

I'll try to extend the description according to your comments.

> 
> So problem here is that we don't take request list reference on
> root blkg and that creates all these corner cases.
> 
> So clearing q->root_blkg and q->root_rl.blkg during policy activation
> makes sense. That means that from queue and request list point of view
> root blkg is gone and you can't get to it. (It might still be around for
> some more time due to pending IOs though).
> 
> Some minor comments below.
> 
>>
>> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index f3b44a6..5015764 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -285,6 +285,9 @@ static void blkg_destroy_all(struct request_queue *q)
>>  		blkg_destroy(blkg);
>>  		spin_unlock(&blkcg->lock);
>>  	}
>> +
>> +	q->root_blkg = NULL;
>> +	q->root_rl.blkg = NULL;
> 
> I think some of the above description about we not taking root_rl
> reference on root group can go here so that next time I don't have
> to scratch my head for a long time.

I put the following comment:
      /*
       * root blkg is destroyed.  Just clear the pointer since
       * root_rl does not take reference on root blkg.
       */

> 
>>  }
>>  
>>  static void blkg_rcu_free(struct rcu_head *rcu_head)
>> @@ -333,7 +336,7 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
>>  
>>  	/* walk to the next list_head, skip root blkcg */
>>  	ent = ent->next;
>> -	if (ent == &q->root_blkg->q_node)
>> +	if (q->root_blkg && ent == &q->root_blkg->q_node)
> 
> Can we fix it little differently. Little earlier in the code, we check for
> if q->blkg_list is empty, then all the groups are gone, and there are
> no more request lists hence and return NULL.
> 
> Current code:
>         if (rl == &q->root_rl) {
>                 ent = &q->blkg_list;
> 
> Modified code:
>         if (rl == &q->root_rl) {
>                 ent = &q->blkg_list;
> 		/* There are no more block groups, hence no request lists */
> 		if (list_empty(ent))
> 			return NULL;
> 	}

OK. I changed that.

Below is the updated version of the patch.

======================================================================
blk_put_rl() does not call blkg_put() for q->root_rl because we
don't take request list reference on q->root_blkg.
However, if root_blkg is once attached then detached (freed),
blk_put_rl() is confused by the bogus pointer in q->root_blkg.

For example, with !CONFIG_BLK_DEV_THROTTLING && CONFIG_CFQ_GROUP_IOSCHED,
switching IO scheduler from cfq to deadline will cause system stall
after the following warning with 3.6:

> WARNING: at /work/build/linux/block/blk-cgroup.h:250 blk_put_rl+0x4d/0x95()
> Modules linked in: bridge stp llc sunrpc acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> Pid: 0, comm: swapper/0 Not tainted 3.6.0 #1
> Call Trace:
>  <IRQ>  [<ffffffff810453bd>] warn_slowpath_common+0x85/0x9d
>  [<ffffffff810453ef>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff811d5f8d>] blk_put_rl+0x4d/0x95
>  [<ffffffff811d614a>] __blk_put_request+0xc3/0xcb
>  [<ffffffff811d71a3>] blk_finish_request+0x232/0x23f
>  [<ffffffff811d76c3>] ? blk_end_bidi_request+0x34/0x5d
>  [<ffffffff811d76d1>] blk_end_bidi_request+0x42/0x5d
>  [<ffffffff811d7728>] blk_end_request+0x10/0x12
>  [<ffffffff812cdf16>] scsi_io_completion+0x207/0x4d5
>  [<ffffffff812c6fcf>] scsi_finish_command+0xfa/0x103
>  [<ffffffff812ce2f8>] scsi_softirq_done+0xff/0x108
>  [<ffffffff811dcea5>] blk_done_softirq+0x8d/0xa1
>  [<ffffffff810915d5>] ? generic_smp_call_function_single_interrupt+0x9f/0xd7
>  [<ffffffff8104cf5b>] __do_softirq+0x102/0x213
>  [<ffffffff8108a5ec>] ? lock_release_holdtime+0xb6/0xbb
>  [<ffffffff8104d2b4>] ? raise_softirq_irqoff+0x9/0x3d
>  [<ffffffff81424dfc>] call_softirq+0x1c/0x30
>  [<ffffffff81011beb>] do_softirq+0x4b/0xa3
>  [<ffffffff8104cdb0>] irq_exit+0x53/0xd5
>  [<ffffffff8102d865>] smp_call_function_single_interrupt+0x34/0x36
>  [<ffffffff8142486f>] call_function_single_interrupt+0x6f/0x80
>  <EOI>  [<ffffffff8101800b>] ? mwait_idle+0x94/0xcd
>  [<ffffffff81018002>] ? mwait_idle+0x8b/0xcd
>  [<ffffffff81017811>] cpu_idle+0xbb/0x114
>  [<ffffffff81401fbd>] rest_init+0xc1/0xc8
>  [<ffffffff81401efc>] ? csum_partial_copy_generic+0x16c/0x16c
>  [<ffffffff81cdbd3d>] start_kernel+0x3d4/0x3e1
>  [<ffffffff81cdb79e>] ? kernel_init+0x1f7/0x1f7
>  [<ffffffff81cdb2dd>] x86_64_start_reservations+0xb8/0xbd
>  [<ffffffff81cdb3e3>] x86_64_start_kernel+0x101/0x110

This patch clears q->root_blkg and q->root_rl.blkg when root blkg
is destroyed.
__blk_queue_next_rl(), which uses q->root_blkg without check,
is changed to exit early when all blkg's are destroyed.

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f3b44a6..a31e678 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -285,6 +285,13 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
+
+	/*
+	 * root blkg is destroyed.  Just clear the pointer since
+	 * root_rl does not take reference on root blkg.
+	 */
+	q->root_blkg = NULL;
+	q->root_rl.blkg = NULL;
 }
 
 static void blkg_rcu_free(struct rcu_head *rcu_head)
@@ -326,6 +333,9 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
 	 */
 	if (rl == &q->root_rl) {
 		ent = &q->blkg_list;
+		/* There are no more block groups, hence no request lists */
+		if (list_empty(ent))
+			return NULL;
 	} else {
 		blkg = container_of(rl, struct blkcg_gq, rl);
 		ent = &blkg->q_node;
