Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1DORE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:04:26 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38334 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1DOREZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:04:25 -0400
Message-ID: <4DA87A72.50809@candelatech.com>
Date: Fri, 15 Apr 2011 10:03:46 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
 (bisected)
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com> <4DA5F3BA.3060404@candelatech.com>
In-Reply-To: <4DA5F3BA.3060404@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, it took a while, but I think I have this thing somewhat bisected.

Starting at commit 4cc4d24efce4672f9b0e7fa27963770ae602998f, I see hard-drive
issues.  Commits right before this (in git bisect) crash in the networking code
quite often, but the hard-drive logic seems to work at least.

In later builds (ie, -rc3), the crashes and warnings are different, but
they have something to do with the file system.  It's difficult to bisect
it any better because of all the instability...


Here are some console logs from a 4cc4d24efce4672f9b0e7fa27963770ae602998f boot:

dracut: Loading SELinux policy
SELinux:  Disabled at runtime.
type=1404 audit(1302886498.339:2): selinux=0 auid=4294967295 ses=4294967295
dracut: /sbin/load_policy: Can't load policy: No such file or directory
dracut: Switching root
readahead: starting
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.01: failed command: READ DMA
ata1.01: cmd c8/00:70:70:05:10/00:00:00:00:00/f0 tag 0 dma 57344 in
          res 40/00:01:00:00:00/00:00:00:00:00/10 Emask 0x4 (timeout)
ata1.01: status: { DRDY }
ata1: link is slow to respond, please be patient (ready=0)
ata1: device not ready (errno=-16), forcing hardreset
ata1: soft resetting link
ata1.01: qc timeout (cmd 0xec)
ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.01: revalidation failed (errno=-5)
ata1: link is slow to respond, please be patient (ready=0)
ata1: device not ready (errno=-16), forcing hardreset
ata1: soft resetting link
ata1.01: qc timeout (cmd 0xec)
ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.01: revalidation failed (errno=-5)
ata1: link is slow to respond, please be patient (ready=0)
ata1: device not ready (errno=-16), forcing hardreset
ata1: soft resetting link

end_request: I/O error, dev sda, sector 1049976
------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux-2.6/drivers/scsi/scsi_lib.c:1147!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/loop1/uevent
Modules linked in: i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]

Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.38+ #15 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<c0690254>] EFLAGS: 00010046 CPU: 0
EIP is at scsi_setup_fs_cmnd+0x47/0xaa
EAX: 00000000 EBX: 001005a0 ECX: 00000002 EDX: f4550000
ESI: f4550000 EDI: f559b800 EBP: f54a9de0 ESP: f54a9dd4
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process ksoftirqd/0 (pid: 3, ti=f54a8000 task=f5491480 task.ti=f54a8000)
Stack:
  001005a0 00000000 f4f5cc00 f54a9e30 c069997b 00000000 00002681 f4f60000
  00000000 00000000 00008000 00000000 f559b800 00000001 00000000 00000023
  0065432b f4550000 00003e28 f4f602c0 f4550000 f4f60000 f541383c f54a9e48
Call Trace:
  [<c069997b>] sd_prep_fn+0x287/0xb61
  [<c05b5328>] blk_peek_request+0xd3/0x191
  [<c068f91f>] scsi_request_fn+0x78/0x45f
  [<c05b5d3c>] __blk_run_queue+0x43/0x71
  [<c05b5e0e>] blk_run_queue+0x22/0x33
  [<c068f39b>] scsi_run_queue+0x28a/0x30e
  [<c069043f>] scsi_requeue_command+0x5f/0x65
  [<c06909cc>] scsi_io_completion+0x3df/0x41f
  [<c068a823>] scsi_finish_command+0xc5/0xcd
  [<c0690afd>] scsi_softirq_done+0xdd/0xe5
  [<c05b9276>] blk_done_softirq+0x66/0x73
  [<c043fb72>] __do_softirq+0xb1/0x17c
  [<c043fcad>] run_ksoftirqd+0x70/0x10c
  [<c043fc3d>] ? run_ksoftirqd+0x0/0x10c
  [<c0451cf9>] kthread+0x67/0x6c
  [<c0451c92>] ? kthread+0x0/0x6c
  [<c07f2386>] kernel_thread_helper+0x6/0x10
Code: 8b 87 0c 05 00 00 85 c0 74 17 8b 00 85 c0 74 11 8b 48 28 85 c9 74 0a 89 f2 89 f8 ff d1 85 c0 75 68 66 83 be 80 00 00 00 00 75 04 <0f> 0b eb fe
EIP: [<c0690254>] scsi_setup_fs_cmnd+0x47/0xaa SS:ESP 0068:f54a9dd4
---[ end trace 0e5e3206e149972b ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 3, comm: ksoftirqd/0 Tainted: G      D     2.6.38+ #15
Call Trace:
  [<c07e9941>] panic+0x55/0x15a
  [<c07ed799>] oops_end+0x97/0xa6
  [<c0404d01>] die+0x58/0x5e
  [<c07ed098>] do_trap+0x8e/0xa7
  [<c04035c3>] ? do_invalid_op+0x0/0x80
  [<c0403639>] do_invalid_op+0x76/0x80
  [<c0690254>] ? scsi_setup_fs_cmnd+0x47/0xaa
  [<c04617d9>] ? mark_lock+0x1e/0x1de
  [<c04617d9>] ? mark_lock+0x1e/0x1de
  [<c04d83ee>] ? __slab_free+0x97/0x133
  [<c0461c2d>] ? trace_hardirqs_on_caller+0xf5/0x12f
  [<c05cd938>] ? trace_hardirqs_off_thunk+0xc/0x10
  [<c07ece1f>] error_code+0x5f/0x70
  [<c04035c3>] ? do_invalid_op+0x0/0x80
  [<c0690254>] ? scsi_setup_fs_cmnd+0x47/0xaa
  [<c069997b>] sd_prep_fn+0x287/0xb61
  [<c05b5328>] blk_peek_request+0xd3/0x191
  [<c068f91f>] scsi_request_fn+0x78/0x45f
  [<c05b5d3c>] __blk_run_queue+0x43/0x71
  [<c05b5e0e>] blk_run_queue+0x22/0x33
  [<c068f39b>] scsi_run_queue+0x28a/0x30e
  [<c069043f>] scsi_requeue_command+0x5f/0x65
  [<c06909cc>] scsi_io_completion+0x3df/0x41f
  [<c068a823>] scsi_finish_command+0xc5/0xcd
  [<c0690afd>] scsi_softirq_done+0xdd/0xe5
  [<c05b9276>] blk_done_softirq+0x66/0x73
  [<c043fb72>] __do_softirq+0xb1/0x17c
  [<c043fcad>] run_ksoftirqd+0x70/0x10c
  [<c043fc3d>] ? run_ksoftirqd+0x0/0x10c
  [<c0451cf9>] kthread+0x67/0x6c
  [<c0451c92>] ? kthread+0x0/0x6c
  [<c07f2386>] kernel_thread_helper+0x6/0x10
panic occurred, switching back to text console


Thanks,
Ben


On 04/13/2011 12:04 PM, Ben Greear wrote:
> On 04/13/2011 09:56 AM, Ben Greear wrote:
>> On 04/13/2011 09:29 AM, Ben Greear wrote:
>>> This on an multi-core Atom based appliance. Using SSD for hard-drive.
>>> Fedora 14 OS.
>>>
>>> 2.6.39-rc* has been very flaky for me on this system (haven't tried
>>> other
>>> machines yet), and I'm pretty sure I saw similar bugs on earlier 39-rc
>>> kernels though
>>> they often crashed on other things as well...
>>
>> I found someone else reporting this bug against -rc1, and folks
>> requested lspci -nn. It's included below. This is from a different
>> boot, but appears to be the same bug. System didn't lock hard right away,
>> but crashed shortly after I gathered this info.
>
> And, same warning in latest linux-2.6 (no extra patches, from a few
> minutes ago).
>
> System worked for a bit, then this splat:
>
> [root@lec2010-ath9k-1 ~]# INFO: task readahead:259 blocked for more than
> 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> readahead D 00000002 0 259 1 0x00000000
> f4511cf8 00000046 21ede952 00000002 c0b17600 f466a940 c0b17600 c0b17600
> f466abb4 c0b17600 001a27c1 00000000 f457fb80 00000002 f466a940 f466a940
> f466a940 00000000 00000006 f4511ccc b25a0d89 f4511cd0 c045935d f45cff94
> Call Trace:
> [<c045935d>] ? timekeeping_get_ns+0x16/0x52
> [<c045a58b>] ? ktime_get_ts+0x98/0xa2
> [<c07f2943>] io_schedule+0x72/0xab
> [<c0506949>] sleep_on_buffer+0xd/0x11
> [<c07f2e74>] __wait_on_bit_lock+0x39/0x75
> [<c050693c>] ? unmap_underlying_metadata+0x51/0x51
> [<c050693c>] ? unmap_underlying_metadata+0x51/0x51
> [<c07f2f50>] out_of_line_wait_on_bit_lock+0xa0/0xa8
> [<c0452114>] ? autoremove_wake_function+0x34/0x34
> [<c050720e>] __lock_buffer+0x24/0x27
> [<c054a8b3>] lock_buffer+0x33/0x36
> [<c054a9d6>] __ext4_get_inode_loc+0x120/0x34e
> [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
> [<c04f864a>] ? iget_locked+0xdb/0x101
> [<c054bbd9>] ext4_iget+0x57/0x6a8
> [<c0552137>] ext4_lookup+0x66/0xb8
> [<c04ed4da>] d_alloc_and_lookup+0x3d/0x54
> [<c04eeadd>] walk_component+0x138/0x2b7
> [<c04ef1e8>] ? link_path_walk+0x8a/0x394
> [<c04eed59>] do_last+0xfd/0x502
> [<c04ef602>] path_openat+0x9b/0x28a
> [<c0463385>] ? lock_release_non_nested+0x86/0x1d8
> [<c04c1071>] ? might_fault+0x4c/0x86
> [<c04ef8bc>] do_filp_open+0x3d/0x62
> [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
> [<c04f968d>] ? alloc_fd+0x137/0x144
> [<c04e3e29>] do_sys_open+0x59/0xd8
> [<c04e3ef4>] sys_open+0x23/0x2b
> [<c07fa3dc>] sysenter_do_call+0x12/0x38
> 1 lock held by readahead/259:
> #0: (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04eeabc>]
> walk_component+0x117/0x2b7
> INFO: task gnome-session:1522 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> gnome-session D 00000000 0 1522 1342 0x00000000
> f206ddf0 00200046 00001bcf 00000000 c0b17600 f2054830 c0b17600 c0b17600
> f2054aa4 c0b17600 af6ef63b 0000000a 00000000 0000000a f2054830 f53935e8
> 00000000 f206ddc0 c0461849 00200246 f2054830 f2054830 00000000 00000006
> Call Trace:
> [<c0461849>] ? mark_lock+0x1e/0x1de
> [<c0461a50>] ? mark_held_locks+0x47/0x5f
> [<c07f3460>] ? __mutex_lock_common+0x1ca/0x2e8
> [<c0461cb6>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c07f346e>] __mutex_lock_common+0x1d8/0x2e8
> [<c07f362b>] mutex_lock_nested+0x35/0x3d
> [<c04eeabc>] ? walk_component+0x117/0x2b7
> [<c04eeabc>] walk_component+0x117/0x2b7
> [<c04ef1e8>] ? link_path_walk+0x8a/0x394
> [<c04eed59>] do_last+0xfd/0x502
> [<c04ef602>] path_openat+0x9b/0x28a
> [<c0463385>] ? lock_release_non_nested+0x86/0x1d8
> [<c04c1071>] ? might_fault+0x4c/0x86
> [<c04ef8bc>] do_filp_open+0x3d/0x62
> [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
> [<c04f968d>] ? alloc_fd+0x137/0x144
> [<c04e3e29>] do_sys_open+0x59/0xd8
> [<c04e3ef4>] sys_open+0x23/0x2b
> [<c07fa3dc>] sysenter_do_call+0x12/0x38
> 1 lock held by gnome-session/1522:
> #0: (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04eeabc>]
> walk_component+0x117/0x2b7
>
>
>
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

