Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1KQQky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:40:54 -0500
Received: from gretna.indigovision.com ([62.7.85.227]:49940 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab1KQQkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:40:51 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Nov 2011 11:40:51 EST
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Thu, 17 Nov 2011 16:35:20 +0000
Subject: BUG_ON triggered in worker_enter_idle, after power failure caused
 potential RAID corruption (kernel 2.6.39.4)
Thread-Topic: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Thread-Index: AcylRuW19Yk6+6oHT4iCMvhUD0LgmQ==
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D9AEC5CE6@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an arm board running kernel 2.6.39.4, with four disks partitioned into
a number of RAID arrays.  A power loss event appears to have clobbered the
storage, and when the unit is rebooted, I see the following BUG_ON triggered
soon after the RAID arrays are started (but before filesystems are mounted.)

md/raid:md2: not clean -- starting background reconstruction
md/raid:md2: device sda3 operational as raid disk 0
md/raid:md2: device sdd3 operational as raid disk 3
md/raid:md2: device sdc3 operational as raid disk 2
md/raid:md2: device sdb3 operational as raid disk 1
md/raid:md2: allocated 4218kB
md/raid:md2: raid level 5 active with 4 out of 4 devices, algorithm 2
md2: detected capacity change from 0 to 2999619354624
mdadm: /dev/md2 has been started with 4 drives.
md: resync of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 976438592 blocks.
kernel BUG at kernel/workqueue.c:1196!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_
mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1
000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Not tainted  (2.6.39.4-iv5 #1)
pc : [<c0032458>]    lr : [<c0032454>]    psr: 60000093
sp : df867f98  ip : c0261a08  fp : 00000000
r10: c0256338  r9 : 00000009  r8 : c0256338
r7 : c0256338  r6 : c0282be0  r5 : df866000  r4 : c0256338
r3 : 00000000  r2 : df867f8c  r1 : c0204f47  r0 : 0000002d
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 1d71c018  DAC: 00000035
Process kworker/0:1 (pid: 154, stack limit = 0xdf866270)
Stack: (0xdf867f98 to 0xdf868000)
7f80:                                                       0000000d c0051684
7fa0: 00000000 df8cdea0 df866000 c0054108 df82df30 df8cdea0 c0053e3c 00000013
7fc0: 00000000 00000000 00000000 c0057640 00000000 00000000 df8cdea0 00000000
7fe0: df867fe0 df867fe0 df82df30 c00575c4 c0030714 c0030714 849a653c a6d38502
Function entered at [<c0032458>] from [<c0051684>]
Function entered at [<c0051684>] from [<c0054108>]
Function entered at [<c0054108>] from [<c0057640>]
Function entered at [<c0057640>] from [<c0030714>]
Code: e59f0010 e1a01003 eb0700d6 e3a03000 (e5833000)
---[ end trace 4dd7435f9823dd59 ]---
note: kworker/0:1[154] exited with preempt_count 1
Unable to handle kernel paging request at virtual address fffffffc
pgd = c0004000
[fffffffc] *pgd=1fffe821, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#2] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_
mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1
000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Tainted: G      D      (2.6.39.4-iv5 #1)
pc : [<c00577b8>]    lr : [<c00541bc>]    psr: 00000093
sp : df867db8  ip : df8ff820  fp : df867ddc
r10: df8ff8f4  r9 : df8ff818  r8 : df8ff970
r7 : df813d60  r6 : c0254c30  r5 : df8ff820  r4 : 00000000
r3 : 00000000  r2 : c0259c48  r1 : 00000000  r0 : df8ff820
Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 1d71c018  DAC: 00000015
Process kworker/0:1 (pid: 154, stack limit = 0xdf866270)
Stack: (0xdf867db8 to 0xdf868000)
7da0:                                                       df866000 c01f4278
7dc0: df8ff820 ffffffff df866000 df813d60 df8ff8f4 df8ff8f4 00000001 c00432b0
7de0: c020505b df867de4 df867de4 df8ff93c df867e04 df866000 df867e52 00000035

The kernel continues generating diagnostics until the hardware watchdog resets
the board.

kernel/workqueue.c line 1196 corresponds to the following line in
worker_enter_idle:

 BUG_ON(worker->flags & WORKER_IDLE);

I have done quite a bit of system testing with this kernel and it seems to be
very stable otherwise.

Has anyone seen similar problems with RAID issues triggering this or similar
BUG_ON statements in workqueue?  I have done some extensive web searching and
delving through the latest git repositories, but have not found anything
that stands out so far.

I shall scan the mailing lists, but if you could also reply directly to the
email address below, it would be most appreciated.

Kind Regards,

Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/index.php/en/news.html
