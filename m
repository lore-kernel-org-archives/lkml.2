Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1H2R45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:56:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34049 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1H2R4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
 <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 29 Aug 2011 19:56:33 +0200
X-Google-Sender-Auth: kGycPZW_VWV4yLIufI-J_-CLfxc
Message-ID: <CAO+b5-qBCBuROmqSPHofQ4A4xxpaUVJL8AzGDHfy7k8QcWYzWw@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
To: Lukas Czerner <lczerner@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Sat, 27 Aug 2011, Bart Van Assche wrote:
>
>> Apparently blkdev_issue_discard() never times out, not even if the
>> device has been removed. This is what appeared in the kernel log after
>> device removal (triggered by running mkfs.ext4 on an SRP SCSI device
>> node):
>>
>> sd 15:0:0:0: [sdb] Attached SCSI disk
>> scsi host15: SRP abort called
>> scsi host15: SRP reset_device called
>> scsi host15: ib_srp: SRP reset_host called
>> scsi host15: ib_srp: connection closed
>> scsi host15: ib_srp: Got failed path rec status -110
>> scsi host15: ib_srp: Path record query failed
>> scsi host15: ib_srp: reconnect failed (-110), removing target port.
>> sd 15:0:0:0: Device offlined - not ready after error recovery
>> INFO: task mkfs.ext4:4304 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mkfs.ext4       D 0000000000000000     0 4304 3649 0x00000000
>>  ffff88006c313b98 0000000000000046 ffffffff813e3038 ffffffff81e6b580
>>  0000000000000082 000000010003cfdc ffff88006c313fd8 ffff880070fbcbc0
>>  00000000001d1f40 ffff88006c313fd8 ffff88006c312000 ffff88006c312000
>> Call Trace:
>>  [<ffffffff813e3038>] ? schedule+0x628/0x830
>>  [<ffffffff813e3835>] schedule_timeout+0x1d5/0x310
>>  [<ffffffff810805de>] ? put_lock_stats+0xe/0x40
>>  [<ffffffff81080e05>] ? lock_release_holdtime+0xb5/0x160
>>  [<ffffffff813e6ac0>] ? _raw_spin_unlock_irq+0x30/0x60
>>  [<ffffffff8103f7d9>] ? sub_preempt_count+0xa9/0xe0
>>  [<ffffffff813e28e0>] wait_for_common+0x110/0x160
>>  [<ffffffff810425f0>] ? try_to_wake_up+0x2c0/0x2c0
>>  [<ffffffff813e2a0d>] wait_for_completion+0x1d/0x20
>>  [<ffffffff811de93a>] blkdev_issue_discard+0x27a/0x2c0
>>  [<ffffffff813e2806>] ? wait_for_common+0x36/0x160
>>  [<ffffffff811df371>] blkdev_ioctl+0x701/0x760
>>  [<ffffffff8112b7bf>] ? kmem_cache_free+0x6f/0x160
>>  [<ffffffff811755b7>] block_ioctl+0x47/0x50
>>  [<ffffffff81151b78>] do_vfs_ioctl+0x98/0x570
>>  [<ffffffff813e76dc>] ? sysret_check+0x27/0x62
>>  [<ffffffff8115209f>] sys_ioctl+0x4f/0x80
>>  [<ffffffff813e76ab>] system_call_fastpath+0x16/0x1b
>> no locks held by mkfs.ext4/4304.
>>
>> The above message kept repeating forever until system reboot.
>>
>> Kernel version:
>> $ git show | head -n 1
>> commit ed8f37370d83e695c0a4fa5d5fc7a83ecb947526
>> $ git describe
>> v3.0-7216-ged8f373
>>
>> I'm considering this as a bug because the state described above makes it
>> impossible to kill the mkfs process and also makes it impossible to remove the
>> kernel module ib_srp. That's why I also reported this as
>> https://bugzilla.kernel.org/show_bug.cgi?id=40472.
>
> I am trying to find some race condition that would cause the problem in
> blkdev_issue_discard(), however I can not see anything.

I'm not sure why you are looking for a race condition - this looks
like a plain deadlock to me.

> The only reason for this to happen I can see is that the last bio was
> not completed yet (e.g. the bio_batch_end_io() callback has not been
> called by the last submitted bio). Does bios have some sort of timeout
> after it dies out? Is it possible that we can lose bio like that ?

A key fact here is that the block device to which the discard request
was issued is gone, so the discard request will never finish
successfully. Do all relevant error paths guarantee that
blkdev_issue_discard() will finish in a finite time ?

Bart.
