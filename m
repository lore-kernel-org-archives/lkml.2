Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2JPDAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:00:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59624 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2JPDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5F_1mid05WZ8i=GOjX4zb1HLNEp3K5EipuxHBUP7Zg5iyHJw@mail.gmail.com>
References: <CAC5F_1mid05WZ8i=GOjX4zb1HLNEp3K5EipuxHBUP7Zg5iyHJw@mail.gmail.com>
From: Michael Spang <spang@google.com>
Date: Mon, 15 Oct 2012 22:59:58 -0400
Message-ID: <CAC5F_1kp-GiDO=gLv6gHCDrc512=XDgPU4dHvLP3Xz_iHGSggQ@mail.gmail.com>
Subject: Re: hung task when USB storage probe occurs during suspend
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tejun Heo <tejun@google.com>, Derek Basehore <dbasehore@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[oops, fixing LKML address]

If you plug in a USB storage device and then suspend, resume, and
quickly suspend again, the system may freeze. 2 minutes later you'll
get the following message.

I believe this is a regression introduced in 62d3c543 ("Block: use a
freezable workqueue for disk-event polling"). Reverting that patch
prevents the deadlock.

<3>[  240.107877] INFO: task kworker/u:2:64 blocked for more than 120 seconds.
<3>[  240.107888] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
<6>[  240.107899] kworker/u:2     D ffff880149f61908     0    64
2 0x00000000
<5>[  240.107914]  ffff880149f719f0 0000000000000046 ffff8801495e3250
ffff8801495e3250
<5>[  240.107923]  ffff880149f615d8 ffff880149f61590 ffff880149f71fd8
ffff880149f71fd8
<5>[  240.107931]  0000000000012180 ffff880149f61590 ffff88014fa92208
7fffffffffffffff
<5>[  240.107939] Call Trace:
<5>[  240.107955]  [<ffffffff8145d819>] schedule+0x64/0x66
<5>[  240.107966]  [<ffffffff8145c45d>] schedule_timeout+0x34/0xde
<5>[  240.107973]  [<ffffffff8145d681>] wait_for_common+0xcd/0x14b
<5>[  240.107983]  [<ffffffff810524c0>] ? try_to_wake_up+0x1e0/0x1e0
<5>[  240.107990]  [<ffffffff8145d7b3>] wait_for_completion+0x1d/0x1f
<5>[  240.107998]  [<ffffffff81040b67>] flush_work+0x2e/0x34
<5>[  240.108004]  [<ffffffff8103f726>] ? do_work_for_cpu+0x27/0x27
<5>[  240.108011]  [<ffffffff81040f09>] flush_delayed_work+0x49/0x4e
<5>[  240.108019]  [<ffffffff811cc420>] disk_clear_events+0x97/0xfb
<5>[  240.108029]  [<ffffffff810fe7c5>] check_disk_change+0x2d/0x5f
<5>[  240.108039]  [<ffffffff812e5673>] sd_open+0xb1/0x160
<5>[  240.108047]  [<ffffffff810fefc5>] __blkdev_get+0xbf/0x3b0
<5>[  240.108054]  [<ffffffff810ff495>] blkdev_get+0x1df/0x2d8
<5>[  240.108064]  [<ffffffff810e7245>] ? unlock_new_inode+0x5c/0x61
<5>[  240.108074]  [<ffffffff812c268f>] ? put_device+0x17/0x19
<5>[  240.108083]  [<ffffffff811cae3b>] ? disk_put_part+0x12/0x14
<5>[  240.108089]  [<ffffffff811cbcd1>] add_disk+0x29f/0x3e6
<5>[  240.108096]  [<ffffffff812e7e66>] sd_probe_async+0x124/0x1c4
<5>[  240.108103]  [<ffffffff8104b7a9>] ? async_schedule+0x17/0x17
<5>[  240.108108]  [<ffffffff8104b84b>] async_run_entry_fn+0xa2/0x153
<5>[  240.108115]  [<ffffffff81041300>] process_one_work+0x199/0x2b8
<5>[  240.108123]  [<ffffffff81041d80>] worker_thread+0x13c/0x222
<5>[  240.108130]  [<ffffffff81041c44>] ? manage_workers.isra.26+0x171/0x171
<5>[  240.108138]  [<ffffffff81045709>] kthread+0x8b/0x93
<5>[  240.108147]  [<ffffffff8145fcd4>] kernel_thread_helper+0x4/0x10
<5>[  240.108155]  [<ffffffff8104567e>] ? __init_kthread_worker+0x39/0x39
<5>[  240.108163]  [<ffffffff8145fcd0>] ? gs_change+0xb/0xb
<0>[  240.108169] Kernel panic - not syncing: hung_task: blocked tasks

This async SCSI probe is stuck trying to flush the
system_nrt_freezable_wq workqueue, which is frozen.

<6>[  169.464976] powerd_suspend  D ffff880101d2e818     0  5687
5686 0x00000000
<5>[  169.464981]  ffff880101f2bcd8 0000000000000082 0000000000000246
ffffffff81813020
<5>[  169.464988]  0000000000000246 ffff880101d2e4a0 ffff880101f2bfd8
ffff880101f2bfd8
<5>[  169.464996]  0000000000012180 ffff880101d2e4a0 ffff880101f2bcc8
0000000000000217
<5>[  169.465002] Call Trace:
<5>[  169.465009]  [<ffffffff812e1507>] ? scsi_bus_resume_common+0x8d/0x8d
<5>[  169.465015]  [<ffffffff8145d819>] schedule+0x64/0x66
<5>[  169.465023]  [<ffffffff8104b598>]
async_synchronize_cookie_domain+0xb6/0x112
<5>[  169.465029]  [<ffffffff81045df3>] ? __init_waitqueue_head+0x32/0x32
<5>[  169.465038]  [<ffffffff8104b609>] async_synchronize_cookie+0x15/0x17
<5>[  169.465046]  [<ffffffff8104b620>] async_synchronize_full+0x15/0x31
<5>[  169.465052]  [<ffffffff812e1524>] scsi_bus_prepare+0x1d/0x36
<5>[  169.465059]  [<ffffffff812cc804>] dpm_prepare+0xdd/0x18d
<5>[  169.465065]  [<ffffffff812cc8c9>] dpm_suspend_start+0x15/0x40
<5>[  169.465073]  [<ffffffff8105c1a0>] suspend_devices_and_enter+0x78/0x27f
<5>[  169.465081]  [<ffffffff8105c4db>] pm_suspend+0x134/0x1a9
<5>[  169.465088]  [<ffffffff8105b7b8>] state_store+0x9c/0xc5
<5>[  169.465098]  [<ffffffff811d740f>] kobj_attr_store+0x17/0x19
<5>[  169.465105]  [<ffffffff8112419e>] sysfs_write_file+0x104/0x140
<5>[  169.465111]  [<ffffffff810d3b2f>] vfs_write+0xa8/0xcf
<5>[  169.465117]  [<ffffffff810d3cdd>] sys_write+0x4a/0x71
<5>[  169.465124]  [<ffffffff8145ec52>] system_call_fastpath+0x16/0x1b

The powerd_suspend task is blocked waiting for SCSI probes to complete.

We've worked around this issue in the chromium tree by partially
reverting 62d3c543 (see
https://gerrit.chromium.org/gerrit/#/c/35324/).

Thanks,
Michael
