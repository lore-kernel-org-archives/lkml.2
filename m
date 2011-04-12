Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1DLIj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1DLIj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:39:26 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302584571.2558.24.camel@mulgrave.site>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Apr 2011 09:42:17 +0100
Message-ID: <1302597737.2661.5.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-04-12 at 00:02 -0500, James Bottomley wrote:
> On Mon, 2011-04-11 at 23:49 -0500, James Bottomley wrote:
> > The entangled deadlock seems to have been introduced by commit
> > 3cca6dc1c81e2407928dc4c6105252146fd3924f prior to that, there was no
> > synchronous cancel in the destroy path.
> > 
> > A fix might be to shunt more stuff off to workqueues, but that's
> > producing a more complex system which would be prone to entanglements
> > that would be even harder to spot.
> > 
> > Perhaps a better solution is just not to use sync cancellations in
> > block?  As long as the work in the queue holds a queue ref, they can be
> > done asynchronously.
> 
> So this is a possible implementation, does this fix the problem?
> (compile tested only).
> 
> James
> 
> ---
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 90f22cc..f600f88 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -219,6 +219,7 @@ static void blk_delay_work(struct work_struct *work)
>  	spin_lock_irq(q->queue_lock);
>  	__blk_run_queue(q, false);
>  	spin_unlock_irq(q->queue_lock);
> +	blk_put_queue(q);
>  }
>  
>  /**
> @@ -233,7 +234,8 @@ static void blk_delay_work(struct work_struct *work)
>   */
>  void blk_delay_queue(struct request_queue *q, unsigned long msecs)
>  {
> -	schedule_delayed_work(&q->delay_work, msecs_to_jiffies(msecs));
> +	if (!blk_get_queue(q))
> +		schedule_delayed_work(&q->delay_work, msecs_to_jiffies(msecs));
>  }
>  EXPORT_SYMBOL(blk_delay_queue);
>  
> @@ -271,7 +273,8 @@ EXPORT_SYMBOL(blk_start_queue);
>   **/
>  void blk_stop_queue(struct request_queue *q)
>  {
> -	__cancel_delayed_work(&q->delay_work);
> +	if (__cancel_delayed_work(&q->delay_work))
> +		blk_put_queue(q);
>  	queue_flag_set(QUEUE_FLAG_STOPPED, q);
>  }
>  EXPORT_SYMBOL(blk_stop_queue);
> @@ -297,7 +300,8 @@ EXPORT_SYMBOL(blk_stop_queue);
>  void blk_sync_queue(struct request_queue *q)
>  {
>  	del_timer_sync(&q->timeout);
> -	cancel_delayed_work_sync(&q->delay_work);
> +	if (__cancel_delayed_work(&q->delay_work))
> +		blk_put_queue(q);
>  	queue_sync_plugs(q);
>  }
>  EXPORT_SYMBOL(blk_sync_queue);
> 
> 

Just done a couple of tests, with the following results:

#1. Including Tejun's patch:

scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0 ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 18, comm: kworker/4:0 Not tainted 2.6.39-rc2+ #189
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c983d>] kref_get+0x2d/0x30
 [<ffffffff813c823a>] kobject_get+0x1a/0x30
 [<ffffffff81460864>] get_device+0x14/0x20
 [<ffffffff81478bc7>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b2481>] blk_delay_work+0x31/0x60
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b2450>] ? blk_alloc_queue+0x10/0x10
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff81687164>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ecd6>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f098>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81687160>] ? gs_change+0x13/0x13
---[ end trace c35781f847a41f31 ]---

#2 On its own:

scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0 ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0 ANSI: 5
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff810ab4d3>] __queue_work+0x403/0x460
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-rc2+ #190 Dell Inc. PowerEdge R710/0N047H
RIP: 0010:[<ffffffff810ab4d3>]  [<ffffffff810ab4d3>] __queue_work+0x403/0x460
RSP: 0018:ffff8800c90abb20  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8800c56a8c58 RCX: ffff8800c56a8c60
RDX: ffff8800c56a8c60 RSI: 0000000000000000 RDI: ffff8800cb00e388
RBP: ffff8800c90abb70 R08: 0000000000000900 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800cb00e340
R13: 0000000000000000 R14: ffff8800cb1d6700 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800cb000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000001c33000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ksoftirqd/0 (pid: 3, threadinfo ffff8800c90aa000, task ffff8800c90a80c0)
Stack:
 ffff8800c90abb90 0000000000000086 0000000000000000 0000000000000086
 ffff8800c90a80c0 ffff8800c92ebe00 ffff8800c56a8c58 ffff8800c88bac28
 ffff8800c90abc30 ffff8800c565c080 ffff8800c90abb80 ffffffff810ab59d
Call Trace:
 [<ffffffff810ab59d>] queue_work_on+0x1d/0x30
 [<ffffffff810ac749>] queue_work+0x29/0x60
 [<ffffffff810ac865>] queue_delayed_work+0x25/0x30
 [<ffffffff813aff75>] __blk_run_queue+0xb5/0x110
 [<ffffffff813b04ed>] blk_run_queue+0x2d/0x50
 [<ffffffff8147715a>] scsi_run_queue+0xea/0x3f0
 [<ffffffff814710cf>] ? __scsi_put_command+0x5f/0xa0
 [<ffffffff814793cd>] scsi_next_command+0x3d/0x60
 [<ffffffff81479602>] scsi_io_completion+0x1b2/0x630
 [<ffffffff81470cd7>] scsi_finish_command+0xc7/0x130
 [<ffffffff8147936f>] scsi_softirq_done+0x13f/0x160
 [<ffffffff813b8252>] blk_done_softirq+0xa2/0xc0
 [<ffffffff810970ac>] __do_softirq+0xdc/0x290
 [<ffffffff81097395>] run_ksoftirqd+0x135/0x250
 [<ffffffff81097260>] ? __do_softirq+0x290/0x290
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec56>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
Code: 8b 44 24 48 49 8d 7c 24 48 48 83 e8 08 31 f6 eb 27 0f 1f 80 00 00 00 00 48 8b 00 49 89 c0 41 80 e0 00 a8 04 48 89 f0 49 0f 45 c0 
 8b 40 08 f6 00 10 74 14 48 8d 41 f8 48 8b 48 08 48 8d 50 08 
RIP  [<ffffffff810ab4d3>] __queue_work+0x403/0x460
 RSP <ffff8800c90abb20>
CR2: 0000000000000008
---[ end trace 52fce2e9afb9bf59 ]---
Kernel panic - not syncing: Fatal exception in interrupt

These are both on the same base kernel as yesterday (i.e. Linus tree
from this time yesterday morning) plus a few GFS2 patches, but they
only affect the GFS2 module which is not loaded.

I don't do anything special to trigger the problem - it happens of its
own accord during normal boot. The initscripts are those from f14.

Steve.



