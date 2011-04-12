Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1DLAsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:48:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46406 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab1DLAsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:48:01 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110411171803.GG9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 19:47:56 -0500
Message-ID: <1302569276.2558.9.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Actually, I don't think it's anything to do with the user process stuff.
The problem seems to be that the block delay function ends up being the
last user of the SCSI device, so it does the final put of the sdev when
it's finished processing.  This will trigger queue destruction
(blk_cleanup_queue) and so on with your analysis.

The problem seems to be that with the new workqueue changes, the queue
itself may no longer be the last holder of a reference on the sdev
because the queue destruction is in the sdev release function and a
queue cannot now be destroyed from its own delayed work.  This is a bit
contrary to the principles SCSI was using, which was that we drive queue
lifetime from the sdev, not vice versa.

The obvious fix seems to be to move queue destruction earlier, but I'm
loth to do that because it will get us back into the old situation where
we no longer have a queue to do the teardown work.

How about moving the blk_sync_queue() call out of blk_cleanup_queue()?
Since that's the direct cause of this.

James


