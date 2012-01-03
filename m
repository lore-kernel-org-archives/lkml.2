Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2ACS2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:28:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2ACS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:28:32 -0500
Date: Tue, 3 Jan 2012 10:28:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: deadlock between disk_block_events() and
 blk_execute_rq()
Message-ID: <20120103182827.GD31746@google.com>
References: <CAO+b5-p9etyTKwAVr3jLYv+xrf1yK6EswvT7zXkq0kvOm2MR=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-p9etyTKwAVr3jLYv+xrf1yK6EswvT7zXkq0kvOm2MR=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bart.

On Sun, Jan 01, 2012 at 05:35:21PM +0000, Bart Van Assche wrote:
> On Sun, Jan 1, 2012 at 5:22 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> > In a workload that involves a lot of scsi_remove_hosts() calls (srp-ha
> > patch set stress test) I get the call stack below after about 30 to 50
> > iterations. Is this a known issue ? Does this indicate a race
> > condition in the block layer ? I can trigger this issue not only with
> > 3.2-rc7 but also with 3.1.6. I haven't tried any other kernel versions
> > yet.
> 
> (replying to my own e-mail)
> 
> By the way, I've been able to trigger a deadlock between
> disk_block_events() and blk_execute_rq() with the same workload. I'm
> not sure though whether this is an independent issue or a consequence
> of the aforementioned warning. This issue is also reproducible with
> both 3.1.6 and 3.2-rc7. See below for the two call stacks of the tasks
> involved in the deadlock. Any feedback is welcome.

I don't think this is a deadlock.

> INFO: task kworker/1:2:9322 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/1:2     D ffff880150603d80     0  9322      2 0x00000000
>  ffff88015071f8d0 0000000000000046 0000000050603d80 0000000000000046
>  0000000000000005 ffff88015071ffd8 ffff88015071ffd8 ffff88015071ffd8
>  ffff880150603d80 ffff88015071ffd8 ffff88015071ffd8 ffff88015071e000
> Call Trace:
>  [<ffffffff813dac8f>] schedule+0x3f/0x60
>  [<ffffffff813db14d>] schedule_timeout+0x1bd/0x2d0
>  [<ffffffff813da2c0>] wait_for_common+0x120/0x170
>  [<ffffffff813da3ed>] wait_for_completion+0x1d/0x20
>  [<ffffffff810624c2>] wait_on_cpu_work+0xf2/0x130
>  [<ffffffff810631de>] wait_on_work+0xfe/0x150
>  [<ffffffff81063383>] __cancel_work_timer+0x83/0x130
>  [<ffffffff81063442>] cancel_delayed_work_sync+0x12/0x20
>  [<ffffffff811e13a3>] disk_block_events+0xa3/0xb0
>  [<ffffffff811e13da>] del_gendisk+0x2a/0x1f0
>  [<ffffffffa015181d>] sd_remove+0x6d/0xc0 [sd_mod]
>  [<ffffffff8129bb9c>] __device_release_driver+0x7c/0xe0
>  [<ffffffff8129be8f>] device_release_driver+0x2f/0x50
>  [<ffffffff8129b617>] bus_remove_device+0x87/0x100
>  [<ffffffff812986fd>] device_del+0x12d/0x1b0
>  [<ffffffffa003d545>] __scsi_remove_device+0xc5/0xd0 [scsi_mod]
>  [<ffffffffa003c03f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
>  [<ffffffffa00316ca>] scsi_remove_host+0x7a/0x130 [scsi_mod]
>  [<ffffffffa03a53b5>] srp_remove_target+0xe5/0x140 [ib_srp]
>  [<ffffffffa03a55f4>] srp_remove_work+0x64/0x90 [ib_srp]
>  [<ffffffff81062ae8>] process_one_work+0x198/0x520
>  [<ffffffff810647ca>] worker_thread+0x16a/0x350
>  [<ffffffff81069776>] kthread+0x96/0xa0
>  [<ffffffff813e7ff4>] kernel_thread_helper+0x4/0x10

This is queue removal waiting for event work to finish.

> kworker/1:4     D ffff8801bfc91bc0     0  4547      2 0x00000000
>  ffff8801a4083900 0000000000000046 ffff8801a7825c40 0000000000000006
>  0000000000000001 ffff8801a4083fd8 ffff8801a4083fd8 ffff8801a4083fd8
>  ffff8801a7825c40 ffff8801a4083fd8 ffff8801a4083fd8 ffff8801a4082000
> Call Trace:
>  [<ffffffff813dac8f>] schedule+0x3f/0x60
>  [<ffffffff813db0f7>] schedule_timeout+0x167/0x2d0
>  [<ffffffff813da2c0>] wait_for_common+0x120/0x170
>  [<ffffffff813da3c3>] wait_for_completion_timeout+0x13/0x20
>  [<ffffffff811dc97b>] blk_execute_rq+0x10b/0x180
>  [<ffffffffa0037fbe>] scsi_execute+0xee/0x180 [scsi_mod]
>  [<ffffffffa003823f>] scsi_execute_req+0xbf/0x130 [scsi_mod]
>  [<ffffffffa003834b>] scsi_test_unit_ready+0x9b/0x150 [scsi_mod]
>  [<ffffffffa01643ee>] sd_check_events+0x12e/0x1c0 [sd_mod]
>  [<ffffffff811df844>] disk_events_workfn+0x64/0x120
>  [<ffffffff81062ae8>] process_one_work+0x198/0x520
>  [<ffffffff810647ca>] worker_thread+0x16a/0x350
>  [<ffffffff81069776>] kthread+0x96/0xa0
>  [<ffffffff813e7ff4>] kernel_thread_helper+0x4/0x10

This is event work item waiting for the probing request to finish, so
they aren't deadlocking - it's just missing request execution /
completion.  On pre 3.2-rc kernel, blk_cleanup_queue() had a race
condition where it can lose requests when raced against request
submission but the above hang is from device removal path and
blk_cleanup_queue() hasn't happened yet.  For some reason, a request
got lost somewhere between the request_queue and device.

Thanks.

-- 
tejun
