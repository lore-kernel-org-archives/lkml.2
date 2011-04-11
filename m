Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1DKR3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:29:18 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53047 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1DKR3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:29:16 -0400
Message-ID: <4DA33A68.7040707@fusionio.com>
Date: Mon, 11 Apr 2011 19:29:12 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Steven Whitehouse <swhiteho@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Strange block/scsi/workqueue issue
References: <1302533763.2596.23.camel@dolmen> <20110411171803.GG9673@mtj.dyndns.org>
In-Reply-To: <20110411171803.GG9673@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 19:18, Tejun Heo wrote:
> Hello,
> 
> (cc'ing James.  The original message is http://lkml.org/lkml/2011/4/11/175 )
> 
> Please read from the bottom up.
> 
> On Mon, Apr 11, 2011 at 03:56:03PM +0100, Steven Whitehouse wrote:
>>  [<ffffffff8167b8e5>] schedule_timeout+0x295/0x310
>>  [<ffffffff8167a650>] wait_for_common+0x120/0x170
>>  [<ffffffff8167a748>] wait_for_completion+0x18/0x20
>>  [<ffffffff810aba4c>] wait_on_cpu_work+0xec/0x100
>>  [<ffffffff810abb3b>] wait_on_work+0xdb/0x150
>>  [<ffffffff810abc33>] __cancel_work_timer+0x83/0x130
>>  [<ffffffff810abced>] cancel_delayed_work_sync+0xd/0x10
> 
> 4. which in turn tries to sync cancel q->delay_work.  Oops, deadlock.
> 
>>  [<ffffffff813b24b4>] blk_sync_queue+0x24/0x50
> 
> 3. and calls into blk_sync_queue()
> 
>>  [<ffffffff813b24ef>] blk_cleanup_queue+0xf/0x60
>>  [<ffffffff81479a89>] scsi_free_queue+0x9/0x10
>>  [<ffffffff8147d30b>] scsi_device_dev_release_usercontext+0xeb/0x140
>>  [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
> 
> 2. It triggers SCSI device release
> 
>>  [<ffffffff8147d1f7>] scsi_device_dev_release+0x17/0x20
>>  [<ffffffff814609f2>] device_release+0x22/0x90
>>  [<ffffffff813c8165>] kobject_release+0x45/0x90
>>  [<ffffffff813c9767>] kref_put+0x37/0x70
>>  [<ffffffff813c8027>] kobject_put+0x27/0x60
>>  [<ffffffff81460822>] put_device+0x12/0x20
>>  [<ffffffff81478bd9>] scsi_request_fn+0xb9/0x4a0
>>  [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
>>  [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
> 
> 1. Workqueue starting execution of q->delay_work and scsi_request_fn()
>    is run from there.
> 
>>  [<ffffffff810aa9c7>] process_one_work+0x197/0x520
>>  [<ffffffff810acfec>] worker_thread+0x15c/0x330
>>  [<ffffffff810b1f16>] kthread+0xa6/0xb0
>>  [<ffffffff81687064>] kernel_thread_helper+0x4/0x10
> 
> So, q->delay_work ends up waiting for itself.  I'd like to blame SCSI
> (as it also fits my agenda to kill execute_in_process_context ;-) for
> diving all the way into blk_cleanup_queue() directly from request_fn.
> 
> Does the following patch fix the problem?

Thanks, that looks a lot saner. This is/was a time bomb waiting to blow
up.

-- 
Jens Axboe

