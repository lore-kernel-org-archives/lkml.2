Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1IVR0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:26:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1IVR0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:26:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 22 Sep 2011 19:26:14 +0200
X-Google-Sender-Auth: 94qtz_Utt6CoeZvGCUSIugLV8aM
Message-ID: <CAO+b5-qxCADmkg+p_xC_AP=FYPELp1+ZqBNQ7PYbHtsAEwivOA@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
To: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 8:11 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> Apparently blkdev_issue_discard() never times out, not even if the
> device has been removed. This is what appeared in the kernel log after
> device removal (triggered by running mkfs.ext4 on an SRP SCSI device
> node):
>
> [ ... ]

In case anyone is interested, I ran into a similar call stack with
3.1-rc6 for the truncate_inode_pages() call. I/O was started while the
SRP connection was fully operational and the call stack was reported
after ib_srp had invoked scsi_remove_host(). That excludes the ib_srp
driver as a potential cause of this hang, isn't it ?

INFO: task fio:17621 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fio             D 000000010003baef     0 17621  17606 0x00000004
 ffff8800952498c8 0000000000000046 ffffffff813d81ef ffffffff81082bee
 ffff880000000000 ffff880095249fd8 ffff880095249fd8 ffff880095249fd8
 ffff8801a8bf4ce0 ffff880095249fd8 ffff880095249fd8 ffff880095248000
Call Trace:
 [<ffffffff813d81ef>] ? __schedule+0x66f/0x7d0
 [<ffffffff81082bee>] ? mark_held_locks+0x6e/0x130
 [<ffffffff810e04e0>] ? __lock_page+0x70/0x70
 [<ffffffff8103d21f>] schedule+0x3f/0x60
 [<ffffffff813d8440>] io_schedule+0x60/0x80
 [<ffffffff810e04ee>] sleep_on_page+0xe/0x20
 [<ffffffff813d8a4a>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff810e2f6f>] ? find_get_pages+0x10f/0x1c0
 [<ffffffff810e2e60>] ? filemap_fault+0x4b0/0x4b0
 [<ffffffff810e04d7>] __lock_page+0x67/0x70
 [<ffffffff81069d10>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff810ee793>] truncate_inode_pages_range+0x493/0x4a0
 [<ffffffff810ee7b5>] truncate_inode_pages+0x15/0x20
 [<ffffffff8116ff07>] kill_bdev+0x37/0x40
 [<ffffffff81170da4>] __blkdev_put+0x74/0x1c0
 [<ffffffff81170f50>] blkdev_put+0x60/0x190
 [<ffffffff811710a4>] blkdev_close+0x24/0x30
 [<ffffffff8113c138>] fput+0xf8/0x230
 [<ffffffff811381d6>] filp_close+0x66/0x90
 [<ffffffff81049302>] put_files_struct+0xf2/0x1d0
 [<ffffffff81049248>] ? put_files_struct+0x38/0x1d0
 [<ffffffff810494a2>] exit_files+0x52/0x60
 [<ffffffff81049978>] do_exit+0x158/0x850
 [<ffffffff8105b2ee>] ? get_signal_to_deliver+0xee/0x5d0
 [<ffffffff813dacb7>] ? _raw_spin_lock_irq+0x17/0x60
 [<ffffffff813db500>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff8104a30c>] do_group_exit+0x5c/0xd0
 [<ffffffff8105b430>] get_signal_to_deliver+0x230/0x5d0
 [<ffffffff8100219b>] do_signal+0x6b/0x750
 [<ffffffff8106dd02>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff813d9db4>] ? do_nanosleep+0xa4/0xd0
 [<ffffffff8106eb4c>] ? hrtimer_nanosleep+0xac/0x150
 [<ffffffff813e36b1>] ? sysret_signal+0x5/0x3d
 [<ffffffff810028fd>] do_notify_resume+0x5d/0x70
 [<ffffffff811ebe2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff813e38cb>] int_signal+0x12/0x17
1 lock held by fio/17621:
 #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81170d6f>]
__blkdev_put+0x3f/0x1c0

Bart.
