Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0EVKEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:04:30 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:58856 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751852Ab0EVKE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:04:27 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 May 2010 06:04:27 EDT
Message-ID: <4BF7A9BD.6070806@nagafix.co.uk>
Date: Sat, 22 May 2010 16:54:05 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       hugh.dickins@tiscali.co.uk
Subject: large IO over loop mount can cause one CPU to block in wait state
 (was: KVM repeatable hang...)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be related to
"Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels"
http://lkml.org/lkml/2010/5/21/387

And also:
" Re: Gentoo guest with smp: emerge freeze while recompile world"
http://www.mail-archive.com/kvm@vger.kernel.org/msg34629.html

As both the symptom and the way to trigger the problem are similar.
I originally posted this to KVM ML as the problem was only occurring on 
virtual machines at the time (IMO because they have less RAM).

Cheers
Antoine


-------- Original Message --------
Subject: 	Re: repeatable hang with loop mount and heavy IO in guest (now 
in host - not KVM then..)
Date: 	Fri, 21 May 2010 16:38:41 +0700
From: 	Antoine Martin <antoine@nagafix.co.uk>
To: 	Michael Tokarev <mjt@tls.msk.ru>
CC: 	kvm@vger.kernel.org



On 02/27/2010 12:38 AM, Antoine Martin wrote:
>>>    1   0   0  98   0   1|   0     0 |  66B  354B|   0     0 |  30    11
>>>    1   1   0  98   0   0|   0     0 |  66B  354B|   0     0 |  29    11
>>>   From that point onwards, nothing will happen.
>>>  The host has disk IO to spare... So what is it waiting for??
>>  Moved to an AMD64 host. No effect.
>>  Disabled swap before running the test. No effect.
>>  Moved the guest to a fully up-to-date FC12 server
>>  (2.6.31.6-145.fc12.x86_64), no effect.
[snip]

Well, well. I've just hit the exact same bug on another *host* (not a
guest this time), running stock Fedora 12.
So this isn't a kvm bug after all. Definitely a loop+ext(4?) bug.
Looks like you need a pretty big loop mounted partition to trigger it.
(bigger than available ram?)

This is what triggered it on a quad amd system with 8Gb of ram, software
raid-1 partition:
mount -o loop 2GB.dd source
dd if=/dev/zero of=8GB.dd bs=1048576 count=8192
mkfs.ext4 -f 8GB.dd
mount -o loop 8GB.dd dest
rsync -rplogtD source/* dest/
umount source
umount dest
^ this is where it hangs (for over 10 minutes), I then tried to issue a 'sync' from another
terminal, which also hung.
It took more than 10 minutes to settle itself, during that time one CPU
was stuck in wait state. Apart from that the box is mostly idle.
dstat reported almost no IO at the time (<1MB/s)
I assume dstat reports page write back like any other disk IO?
That raid partition does ~60MB/s, so writing back 8GB shouldn't take much more than a couple of minutes. (that's even assuming it would have to write back the whole 8GB at umount time - which should not be the case)

Cheers
Antoine

Here's the hung trace:
INFO: task umount:526 blocked for more than 120 seconds.
"echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D 0000000000000002     0   526  32488 0x00000000
  ffff880140f9fc88 0000000000000086 ffff880008e3c228 ffffffff810d5fd9
  ffff880140f9fc28 ffff880140f9fcd8 ffff880140f9ffd8 ffff880140f9ffd8
  ffff88021b5e03d8 000000000000f980 0000000000015740 ffff88021b5e03d8
Call Trace:
  [<ffffffff810d5fd9>] ? sync_page+0x0/0x4a
  [<ffffffff81046fbd>] ? __enqueue_entity+0x7b/0x7d
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff8113a055>] bdi_sched_wait+0xe/0x12
  [<ffffffff814549f0>] __wait_on_bit+0x48/0x7b
  [<ffffffff8102649f>] ? native_smp_send_reschedule+0x5c/0x5e
  [<ffffffff81454a91>] out_of_line_wait_on_bit+0x6e/0x79
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
  [<ffffffff8113ad0b>] wait_on_bit.clone.1+0x1e/0x20
  [<ffffffff8113ad71>] bdi_sync_writeback+0x64/0x6b
  [<ffffffff8113ad9a>] sync_inodes_sb+0x22/0xec
  [<ffffffff8113e547>] __sync_filesystem+0x4e/0x77
  [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
  [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
  [<ffffffff8111d7a2>] kill_block_super+0x27/0x3f
  [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
  [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
  [<ffffffff8113482a>] sys_umount+0x2d5/0x304
  [<ffffffff81458133>] ? do_page_fault+0x270/0x2a0
  [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
INFO: task umount:526 blocked for more than 120 seconds.
"echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D 0000000000000002     0   526  32488 0x00000000
  ffff880140f9fc88 0000000000000086 ffff880008e3c228 ffffffff810d5fd9
  ffff880140f9fc28 ffff880140f9fcd8 ffff880140f9ffd8 ffff880140f9ffd8
  ffff88021b5e03d8 000000000000f980 0000000000015740 ffff88021b5e03d8
Call Trace:
  [<ffffffff810d5fd9>] ? sync_page+0x0/0x4a
  [<ffffffff81046fbd>] ? __enqueue_entity+0x7b/0x7d
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff8113a055>] bdi_sched_wait+0xe/0x12
  [<ffffffff814549f0>] __wait_on_bit+0x48/0x7b
  [<ffffffff8102649f>] ? native_smp_send_reschedule+0x5c/0x5e
  [<ffffffff81454a91>] out_of_line_wait_on_bit+0x6e/0x79
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
  [<ffffffff8113ad0b>] wait_on_bit.clone.1+0x1e/0x20
  [<ffffffff8113ad71>] bdi_sync_writeback+0x64/0x6b
  [<ffffffff8113ad9a>] sync_inodes_sb+0x22/0xec
  [<ffffffff8113e547>] __sync_filesystem+0x4e/0x77
  [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
  [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
  [<ffffffff8111d7a2>] kill_block_super+0x27/0x3f
  [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
  [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
  [<ffffffff8113482a>] sys_umount+0x2d5/0x304
  [<ffffffff81458133>] ? do_page_fault+0x270/0x2a0
  [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
INFO: task umount:526 blocked for more than 120 seconds.
"echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D 0000000000000002     0   526  32488 0x00000000
  ffff880140f9fc88 0000000000000086 ffff880008e3c228 ffffffff810d5fd9
  ffff880140f9fc28 ffff880140f9fcd8 ffff880140f9ffd8 ffff880140f9ffd8
  ffff88021b5e03d8 000000000000f980 0000000000015740 ffff88021b5e03d8
Call Trace:
  [<ffffffff810d5fd9>] ? sync_page+0x0/0x4a
  [<ffffffff81046fbd>] ? __enqueue_entity+0x7b/0x7d
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff8113a055>] bdi_sched_wait+0xe/0x12
  [<ffffffff814549f0>] __wait_on_bit+0x48/0x7b
  [<ffffffff8102649f>] ? native_smp_send_reschedule+0x5c/0x5e
  [<ffffffff81454a91>] out_of_line_wait_on_bit+0x6e/0x79
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
  [<ffffffff8113ad0b>] wait_on_bit.clone.1+0x1e/0x20
  [<ffffffff8113ad71>] bdi_sync_writeback+0x64/0x6b
  [<ffffffff8113ad9a>] sync_inodes_sb+0x22/0xec
  [<ffffffff8113e547>] __sync_filesystem+0x4e/0x77
  [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
  [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
  [<ffffffff8111d7a2>] kill_block_super+0x27/0x3f
  [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
  [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
  [<ffffffff8113482a>] sys_umount+0x2d5/0x304
  [<ffffffff81458133>] ? do_page_fault+0x270/0x2a0
  [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
INFO: task umount:526 blocked for more than 120 seconds.
"echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D 0000000000000002     0   526  32488 0x00000000
  ffff880140f9fc88 0000000000000086 ffff880008e3c228 ffffffff810d5fd9
  ffff880140f9fc28 ffff880140f9fcd8 ffff880140f9ffd8 ffff880140f9ffd8
  ffff88021b5e03d8 000000000000f980 0000000000015740 ffff88021b5e03d8
Call Trace:
  [<ffffffff810d5fd9>] ? sync_page+0x0/0x4a
  [<ffffffff81046fbd>] ? __enqueue_entity+0x7b/0x7d
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff8113a055>] bdi_sched_wait+0xe/0x12
  [<ffffffff814549f0>] __wait_on_bit+0x48/0x7b
  [<ffffffff8102649f>] ? native_smp_send_reschedule+0x5c/0x5e
  [<ffffffff81454a91>] out_of_line_wait_on_bit+0x6e/0x79
  [<ffffffff8113a047>] ? bdi_sched_wait+0x0/0x12
  [<ffffffff810748dc>] ? wake_bit_function+0x0/0x33
  [<ffffffff8113ad0b>] wait_on_bit.clone.1+0x1e/0x20
  [<ffffffff8113ad71>] bdi_sync_writeback+0x64/0x6b
  [<ffffffff8113ad9a>] sync_inodes_sb+0x22/0xec
  [<ffffffff8113e547>] __sync_filesystem+0x4e/0x77
  [<ffffffff8113e71d>] sync_filesystem+0x4b/0x4f
  [<ffffffff8111d6d9>] generic_shutdown_super+0x27/0xc9
  [<ffffffff8111d7a2>] kill_block_super+0x27/0x3f
  [<ffffffff8111ded7>] deactivate_super+0x56/0x6b
  [<ffffffff81134262>] mntput_no_expire+0xb4/0xec
  [<ffffffff8113482a>] sys_umount+0x2d5/0x304
  [<ffffffff81458133>] ? do_page_fault+0x270/0x2a0
  [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b
INFO: task sync:741 blocked for more than 120 seconds.
"echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 0000000000000000     0   741    552 0x00000000
  ffff88003c31fed8 0000000000000086 0000000000000000 ffff8801b7472ec0
  ffff88003c31fe38 0000000000000246 ffff88003c31ffd8 ffff88003c31ffd8
  ffff8801b7473298 000000000000f980 0000000000015740 ffff8801b7473298
Call Trace:
  [<ffffffff81455a2e>] __down_read+0x92/0xaa
  [<ffffffff814550e1>] down_read+0x31/0x35
  [<ffffffff8113e5f6>] sync_filesystems+0x86/0xf6
  [<ffffffff8113e6b6>] sys_sync+0x17/0x33
  [<ffffffff81011d32>] system_call_fastpath+0x16/0x1b


