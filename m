Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1KUJbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:31:15 -0500
Received: from gretna.indigovision.com ([62.7.85.227]:23292 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1KUJbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:31:13 -0500
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Mon, 21 Nov 2011 09:30:51 +0000
Subject: RE: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Thread-Topic: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Thread-Index: AcylRuW19Yk6+6oHT4iCMvhUD0LgmQAyeWdg
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D9AEC6006@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Has anyone seen similar problems with RAID issues triggering this or similar
> BUG_ON statements in workqueue?  I have done some extensive web searching and
> delving through the latest git repositories, but have not found anything that
> stands out so far.

I've reproduced the problem a few times and the various different failures are
suggesting some sort of kernel memory corruption when handling a a RAID that
is in an inconsistent state.  Below are two partial logs show a null pointer
dereference (looks like execution jumped into the weeds) and another kernel
BUG_ON, this time in sched.c.

Regards,

Bruce.


---snip
md1: unknown partition table
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c0004000
[00000004] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Not tainted  (2.6.39.4-iv-dev+ #1)
pc : [<c0053f2c>]    lr : [<c01f4530>]    psr: 60000093
sp : dd751fb0  ip : 00000000  fp : 00000000
r10: c0256338  r9 : 00000009  r8 : c0256338
r7 : c0256338  r6 : c0282be0  r5 : dd750000  r4 : dd7f07e0
r3 : df8cdea0  r2 : 00000000  r1 : df8ff820  r0 : de45ae20
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 1acf8018  DAC: 00000035
Process kworker/0:2 (pid: 1108, stack limit = 0xdd750270)
Stack: (0xdd751fb0 to 0xdd752000)
1fa0:                                     df82df30 dd7f07e0 c0053e3c 00000013
1fc0: 00000000 00000000 00000000 c0057640 00000000 00000000 dd7f07e0 00000000
1fe0: dd751fe0 dd751fe0 df82df30 c00575c4 c0030714 c0030714 00000000 00000000
Function entered at [<c0053f2c>] from [<c0057640>] -- at worker_thread
Function entered at [<c0057640>] from [<c0030714>] -- at kthread
Code: e5983014 e2433001 e5883014 e894000c (e5823004)
---[ end trace 6e6694822fa0d216 ]---
note: kworker/0:2[1108] exited with preempt_count 1
Unable to handle kernel paging request at virtual address fffffffc
pgd = c0004000
[fffffffc] *pgd=1fffe821, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#2] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Tainted: G      D      (2.6.39.4-iv-dev+ #1)
pc : [<c00577b8>]    lr : [<c00541bc>]    psr: 00000093
sp : dd751dd0  ip : de43b2e0  fp : dd751df4
r10: de43b3b4  r9 : de43b2d8  r8 : de43b430
r7 : df813d60  r6 : c0254c30  r5 : de43b2e0  r4 : 00000000
r3 : 00000000  r2 : c0259c48  r1 : 00000000  r0 : de43b2e0
Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 1acf8018  DAC: 00000015
Process kworker/0:2 (pid: 1108, stack limit = 0xdd750270)
Stack: (0xdd751dd0 to 0xdd752000)
1dc0:                                     dd750000 c01f4278 de43b2e0 ffffffff
1de0: dd750000 df813d60 de43b3b4 de43b3b4 00000001 c00432b0 c020505b dd751dfc
1e00: dd751dfc de43b3fc dd751e1c dd750000 dd751e6a 00000035 00000000 c0053f2c
1e20: c0205063 00000000 c020505b c0032950 dd750270 0000000b 65000001 33383935
---snip

---snip
kernel BUG at kernel/sched.c:2560!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Not tainted  (2.6.39.4-iv-dev+ #1)
pc : [<c0032458>]    lr : [<c0032454>]    psr: 60000093
sp : df867ef0  ip : c0261a08  fp : df867f14
r10: c0289324  r9 : 00000000  r8 : df8ff970
r7 : df8ff820  r6 : c0254c30  r5 : df8ff820  r4 : df866000
r3 : 00000000  r2 : df867ee4  r1 : c0204f47  r0 : 00000029
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 1ae08018  DAC: 00000035
Process kworker/0:1 (pid: 154, stack limit = 0xdf866270)
Stack: (0xdf867ef0 to 0xdf868000)
7ee0:                                     df8ff820 c01f43fc ffff97e3 df866000
7f00: ffff97e1 c0281b80 00002098 c0289324 c016bc98 c01f4ef8 c02822a4 c02822a4
7f20: ffff97e3 c0281b80 c0049c64 df8ff820 ffffffff a0000013 df867f5c defb4000
7f40: 00000000 00000002 defb40a4 c004a2e4 207007e0 c015915c defb4060 defb4000
7f60: defb53b0 c016bd98 df8cdea0 df8a6400 df8a6405 00000000 defb4060 00000009
7f80: 00000088 c0053494 df8a6405 df8cdea0 df866000 c0282be0 c0256338 df8cdeb0
7fa0: 00000009 c0256338 00000000 c0054020 df82df30 df8cdea0 c0053e3c 00000013
7fc0: 00000000 00000000 00000000 c0057640 00000000 00000000 df8cdea0 00000000
7fe0: df867fe0 df867fe0 df82df30 c00575c4 c0030714 c0030714 828a84ba 3db86028
Function entered at [<c0032458>] from [<c01f43fc>] -- at __bug
Function entered at [<c01f43fc>] from [<c01f4ef8>] -- at schedule
Function entered at [<c01f4ef8>] from [<c004a2e4>] -- at schedule_timeout
Function entered at [<c004a2e4>] from [<c015915c>] -- at msleep
Function entered at [<c015915c>] from [<c016bd98>] -- at ata_msleep
Function entered at [<c016bd98>] from [<c0053494>] -- at ata_sff_pio_task
Function entered at [<c0053494>] from [<c0054020>] -- at process_one_work
Function entered at [<c0054020>] from [<c0057640>] -- at worker_thread
Function entered at [<c0057640>] from [<c0030714>] -- at kthread
Code: e59f0010 e1a01003 eb0700d6 e3a03000 (e5833000)
---[ end trace 6e6694822fa0d216 ]---
note: kworker/0:1[154] exited with preempt_count 2
Unable to handle kernel paging request at virtual address fffffffc
pgd = c0004000
[fffffffc] *pgd=1fffe821, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#2] PREEMPT
last sysfs file: /sys/devices/virtual/block/md2/md/stripe_cache_size
Modules linked in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy raid1 raid0 md_mod raid_class sata_mv lm90 sd_mod ext4 crc16 ext3 mbcache jbd2 jbd nfs lockd sunrpc af_packet bonding e1000 softdog rtc_m41t11 vp8xx_reset i2c_iop3xx
CPU: 0    Tainted: G      D      (2.6.39.4-iv-dev+ #1)
pc : [<c00577b8>]    lr : [<c00541bc>]    psr: 00000093
sp : df867d10  ip : 00000005  fp : df867d34
r10: df8ff8f4  r9 : df8ff818  r8 : df8ff970
r7 : df813d60  r6 : c0254c30  r5 : df8ff820  r4 : 00000000
r3 : 00000000  r2 : 00000001  r1 : 00000000  r0 : df8ff820
Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 1ae08018  DAC: 00000015
Process kworker/0:1 (pid: 154, stack limit = 0xdf866270)
Stack: (0xdf867d10 to 0xdf868000)
7d00:                                     df866000 c01f4278 df8ff820 ffffffff
7d20: df866000 df813d60 df8ff8f4 df8ff8f4 00000001 c00432b0 c020505b df867d3c
7d40: df867d3c df8ff93c df867d5c df866000 df867daa 00000035 00000000 c0032458
---snip


Latest News at: http://www.indigovision.com/index.php/en/news.html
