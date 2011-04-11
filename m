Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1DKRtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab1DKRtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:49:23 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20110411171803.GG9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Apr 2011 18:52:10 +0100
Message-ID: <1302544330.2596.31.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-04-12 at 02:18 +0900, Tejun Heo wrote:
> Hello,
> 
> (cc'ing James.  The original message is http://lkml.org/lkml/2011/4/11/175 )
> 
> Please read from the bottom up.
> 
> On Mon, Apr 11, 2011 at 03:56:03PM +0100, Steven Whitehouse wrote:
> >  [<ffffffff8167b8e5>] schedule_timeout+0x295/0x310
> >  [<ffffffff8167a650>] wait_for_common+0x120/0x170
> >  [<ffffffff8167a748>] wait_for_completion+0x18/0x20
> >  [<ffffffff810aba4c>] wait_on_cpu_work+0xec/0x100
> >  [<ffffffff810abb3b>] wait_on_work+0xdb/0x150
> >  [<ffffffff810abc33>] __cancel_work_timer+0x83/0x130
> >  [<ffffffff810abced>] cancel_delayed_work_sync+0xd/0x10
> 
> 4. which in turn tries to sync cancel q->delay_work.  Oops, deadlock.
> 
> >  [<ffffffff813b24b4>] blk_sync_queue+0x24/0x50
> 
> 3. and calls into blk_sync_queue()
> 
> >  [<ffffffff813b24ef>] blk_cleanup_queue+0xf/0x60
> >  [<ffffffff81479a89>] scsi_free_queue+0x9/0x10
> >  [<ffffffff8147d30b>] scsi_device_dev_release_usercontext+0xeb/0x140
> >  [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
> 
> 2. It triggers SCSI device release
> 
> >  [<ffffffff8147d1f7>] scsi_device_dev_release+0x17/0x20
> >  [<ffffffff814609f2>] device_release+0x22/0x90
> >  [<ffffffff813c8165>] kobject_release+0x45/0x90
> >  [<ffffffff813c9767>] kref_put+0x37/0x70
> >  [<ffffffff813c8027>] kobject_put+0x27/0x60
> >  [<ffffffff81460822>] put_device+0x12/0x20
> >  [<ffffffff81478bd9>] scsi_request_fn+0xb9/0x4a0
> >  [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
> >  [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
> 
> 1. Workqueue starting execution of q->delay_work and scsi_request_fn()
>    is run from there.
> 
> >  [<ffffffff810aa9c7>] process_one_work+0x197/0x520
> >  [<ffffffff810acfec>] worker_thread+0x15c/0x330
> >  [<ffffffff810b1f16>] kthread+0xa6/0xb0
> >  [<ffffffff81687064>] kernel_thread_helper+0x4/0x10
> 
> So, q->delay_work ends up waiting for itself.  I'd like to blame SCSI
> (as it also fits my agenda to kill execute_in_process_context ;-) for
> diving all the way into blk_cleanup_queue() directly from request_fn.
> 
> Does the following patch fix the problem?
> 
Unfortunately not:

scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.07 PQ: 0
ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0
ANSI: 5
scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         1.22 PQ: 0
ANSI: 5
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
Hardware name: PowerEdge R710
Modules linked in:
Pid: 12, comm: kworker/2:0 Not tainted 2.6.39-rc2+ #188
Call Trace:
 [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
 [<ffffffff813c97cd>] kref_get+0x2d/0x30
 [<ffffffff813c81ca>] kobject_get+0x1a/0x30
 [<ffffffff814607f4>] get_device+0x14/0x20
 [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ec66>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167f018>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816870e0>] ? gs_change+0x13/0x13
---[ end trace 3681e9da2630a94b ]---

Steve.


