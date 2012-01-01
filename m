Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2AARf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 12:35:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45757 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2AARfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 12:35:22 -0500
MIME-Version: 1.0
Date: Sun, 1 Jan 2012 17:35:21 +0000
X-Google-Sender-Auth: IR8fWFmHrJARKztKcWLPB99Ro5I
Message-ID: <CAO+b5-p9etyTKwAVr3jLYv+xrf1yK6EswvT7zXkq0kvOm2MR=g@mail.gmail.com>
Subject: Re: block: deadlock between disk_block_events() and blk_execute_rq()
From: Bart Van Assche <bvanassche@acm.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 5:22 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> In a workload that involves a lot of scsi_remove_hosts() calls (srp-ha
> patch set stress test) I get the call stack below after about 30 to 50
> iterations. Is this a known issue ? Does this indicate a race
> condition in the block layer ? I can trigger this issue not only with
> 3.2-rc7 but also with 3.1.6. I haven't tried any other kernel versions
> yet.

(replying to my own e-mail)

By the way, I've been able to trigger a deadlock between
disk_block_events() and blk_execute_rq() with the same workload. I'm
not sure though whether this is an independent issue or a consequence
of the aforementioned warning. This issue is also reproducible with
both 3.1.6 and 3.2-rc7. See below for the two call stacks of the tasks
involved in the deadlock. Any feedback is welcome.

(1)

INFO: task kworker/1:2:9322 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:2     D ffff880150603d80     0  9322      2 0x00000000
 ffff88015071f8d0 0000000000000046 0000000050603d80 0000000000000046
 0000000000000005 ffff88015071ffd8 ffff88015071ffd8 ffff88015071ffd8
 ffff880150603d80 ffff88015071ffd8 ffff88015071ffd8 ffff88015071e000
Call Trace:
 [<ffffffff813dac8f>] schedule+0x3f/0x60
 [<ffffffff813db14d>] schedule_timeout+0x1bd/0x2d0
 [<ffffffff813dd587>] ? _raw_spin_lock_irq+0x17/0x60
 [<ffffffff813dddd0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff81082fad>] ? trace_hardirqs_on_caller+0x11d/0x1b0
 [<ffffffff813da2c0>] wait_for_common+0x120/0x170
 [<ffffffff8103d890>] ? try_to_wake_up+0x2b0/0x2b0
 [<ffffffff81082fad>] ? trace_hardirqs_on_caller+0x11d/0x1b0
 [<ffffffff813da3ed>] wait_for_completion+0x1d/0x20
 [<ffffffff810624c2>] wait_on_cpu_work+0xf2/0x130
 [<ffffffff81061170>] ? do_work_for_cpu+0x30/0x30
 [<ffffffff810631de>] wait_on_work+0xfe/0x150
 [<ffffffff810630e0>] ? rescuer_thread+0x230/0x230
 [<ffffffff813dd5ec>] ? _raw_spin_lock_irqsave+0x1c/0x60
 [<ffffffff81063383>] __cancel_work_timer+0x83/0x130
 [<ffffffff81063442>] cancel_delayed_work_sync+0x12/0x20
 [<ffffffff811e13a3>] disk_block_events+0xa3/0xb0
 [<ffffffff811e13da>] del_gendisk+0x2a/0x1f0
 [<ffffffff81297ca7>] ? put_device+0x17/0x20
 [<ffffffff81298743>] ? device_del+0x173/0x1b0
 [<ffffffffa015181d>] sd_remove+0x6d/0xc0 [sd_mod]
 [<ffffffff8129bb9c>] __device_release_driver+0x7c/0xe0
 [<ffffffff8129be8f>] device_release_driver+0x2f/0x50
 [<ffffffff8129b617>] bus_remove_device+0x87/0x100
 [<ffffffff812986fd>] device_del+0x12d/0x1b0
 [<ffffffffa003d545>] __scsi_remove_device+0xc5/0xd0 [scsi_mod]
 [<ffffffffa003c03f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
 [<ffffffffa00316ca>] scsi_remove_host+0x7a/0x130 [scsi_mod]
 [<ffffffffa03a53b5>] srp_remove_target+0xe5/0x140 [ib_srp]
 [<ffffffffa03a55f4>] srp_remove_work+0x64/0x90 [ib_srp]
 [<ffffffff81062ae8>] process_one_work+0x198/0x520
 [<ffffffff81062a79>] ? process_one_work+0x129/0x520
 [<ffffffffa03a5590>] ? srp_remove_one+0x180/0x180 [ib_srp]
 [<ffffffff810647ca>] worker_thread+0x16a/0x350
 [<ffffffff81064660>] ? manage_workers+0x250/0x250
 [<ffffffff81069776>] kthread+0x96/0xa0
 [<ffffffff813e7ff4>] kernel_thread_helper+0x4/0x10
 [<ffffffff813de21d>] ? retint_restore_args+0xe/0xe
 [<ffffffff810696e0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff813e7ff0>] ? gs_change+0xb/0xb
5 locks held by kworker/1:2/9322:
 #0:  (events_long){.+.+.+}, at: [<ffffffff81062a79>]
process_one_work+0x129/0x520
 #1:  ((&target->remove_work)){+.+.+.}, at: [<ffffffff81062a79>]
process_one_work+0x129/0x520
 #2:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffffa0031676>]
scsi_remove_host+0x26/0x130 [scsi_mod]
 #3:  (&__lockdep_no_validate__){......}, at: [<ffffffff8129be87>]
device_release_driver+0x27/0x50
 #4:  (&ev->block_mutex){+.+...}, at: [<ffffffff811e1342>]
disk_block_events+0x42/0xb0

(2) (obtained via sysrq)

kworker/1:4     D ffff8801bfc91bc0     0  4547      2 0x00000000
 ffff8801a4083900 0000000000000046 ffff8801a7825c40 0000000000000006
 0000000000000001 ffff8801a4083fd8 ffff8801a4083fd8 ffff8801a4083fd8
 ffff8801a7825c40 ffff8801a4083fd8 ffff8801a4083fd8 ffff8801a4082000
Call Trace:
 [<ffffffff81082fad>] ? trace_hardirqs_on_caller+0x11d/0x1b0
 [<ffffffff813dac8f>] schedule+0x3f/0x60
 [<ffffffff813db0f7>] schedule_timeout+0x167/0x2d0
 [<ffffffff810555c0>] ? del_timer+0xf0/0xf0
 [<ffffffff813da2c0>] wait_for_common+0x120/0x170
 [<ffffffff8103d890>] ? try_to_wake_up+0x2b0/0x2b0
 [<ffffffff813dddd0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff813da3c3>] wait_for_completion_timeout+0x13/0x20
 [<ffffffff811dc97b>] blk_execute_rq+0x10b/0x180
 [<ffffffff811d75e9>] ? get_request_wait+0x29/0x1c0
 [<ffffffffa0037fbe>] scsi_execute+0xee/0x180 [scsi_mod]
 [<ffffffffa003823f>] scsi_execute_req+0xbf/0x130 [scsi_mod]
 [<ffffffffa003834b>] scsi_test_unit_ready+0x9b/0x150 [scsi_mod]
 [<ffffffffa01643ee>] sd_check_events+0x12e/0x1c0 [sd_mod]
 [<ffffffff811df844>] disk_events_workfn+0x64/0x120
 [<ffffffff81062ae8>] process_one_work+0x198/0x520
 [<ffffffff81062a79>] ? process_one_work+0x129/0x520
 [<ffffffff811df7e0>] ? __disk_unblock_events+0x110/0x110
 [<ffffffff810647ca>] worker_thread+0x16a/0x350
 [<ffffffff81064660>] ? manage_workers+0x250/0x250
 [<ffffffff81069776>] kthread+0x96/0xa0
 [<ffffffff813e7ff4>] kernel_thread_helper+0x4/0x10
 [<ffffffff813de21d>] ? retint_restore_args+0xe/0xe
 [<ffffffff810696e0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff813e7ff0>] ? gs_change+0xb/0xb
