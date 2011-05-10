Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1EJK5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:57:55 -0400
Received: from arcss01.ait.ac.at ([62.218.164.126]:42204 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752679Ab1EJK5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:57:54 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 06:57:54 EDT
From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 May 2011 12:52:45 +0200
Subject: cryptoloop device write lockup on initrd
Thread-Topic: cryptoloop device write lockup on initrd
Thread-Index: AcwO/zV2NkGXRzI2QGG4gMQmwevQDQ==
Message-ID: <9F69795E29C890408AC2DAF646C89BB3799E704A6B@MAILBOX.arc.local>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

The following sequence of commands causes in 30%-50% of execution attempts  a lockup of the mke2fs process on an udev-running custom initrd, mke2fs cannot be killed afterwards. This only occurs on the first attempt after loading the initrd. If commands succeeded once, failure rate is 0% in repeated attempts on same initrd, even after unload of all modules.

# Get a second chance for debugging (works only if openvt included in initrd)
openvt -c 2 /bin/bash
echo x > /key
modprobe cryptoloop
losetup -e aes-cbc-essiv:sha256 -k 256 --pass-fd 0 /dev/loop0 /dev/sda2 < /key
mke2fs -t ext4 /dev/loop0 

Since debugging on initrd is problematic, information is sparse. Could someone please do a quick check, if issue is even worth debugging. Since there seem to be no other reports and the workaround to reboot setup environment until successful is OK for me. If worth debugging, I could perform additional tests or try to create a minimal initrd stripped of private parts for public testing.


cat /proc/version
Linux version 2.6.38-8-generic (buildd@vernadsky) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu3) ) #42-Ubuntu SMP Mon Apr 11 03:31:50 UTC 2011
(This is standard ubuntu natty stock kernel.)

ps aux | grep loop
0          293  0.0  0.0      0     0 ?        S<   09:49   0:00 [loop0]
0          307  0.1  0.4   2480  1220 ?        D    09:49   0:01 mke2fs -t ext4 /dev/loop0
0          747  0.0  0.1   1948   392 ?        S    10:06   0:00 grep loop

cat /proc/307/stack     (mke2fs process)
[<c10eaa64>] balance_dirty_pages.clone.9+0x1e4/0x390
[<c10eac71>] balance_dirty_pages_ratelimited_nr+0x61/0x70
[<c10e190a>] generic_perform_write+0x14a/0x1b0
[<c10e19c4>] generic_file_buffered_write+0x54/0x90
[<c10e3910>] __generic_file_aio_write+0x220/0x4e0
[<c115389c>] blkdev_aio_write+0x3c/0xa0
[<c11269e4>] do_sync_write+0xa4/0xe0
[<c11271a2>] vfs_write+0xa2/0x170
[<c1127482>] sys_write+0x42/0x70
[<c1509bf4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

cat /proc/293/stack (loop kernel thread)
[<c1341280>] loop_thread+0x100/0x200
[<c106ce04>] kthread+0x74/0x80
[<c100367e>] kernel_thread_helper+0x6/0x10
[<ffffffff>] 0xffffffff

cat /proc/modules
cryptd 19801 0 - Live 0xd083f000
aes_i586 16956 1 - Live 0xd0838000
aes_generic 38023 1 aes_i586, Live 0xd082c000
cryptoloop 12570 1 - Live 0xd07fc000
ahci 21591 1 - Live 0xd080d000
libahci 25548 1 ahci, Live 0xd0818000
pcnet32 36760 0 - Live 0xd0802000

(Strange - no sha256 module needed for essiv? Module also missing when mkfs works)

End of dmesg log:
[    3.152609] sd 2:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
[    3.154885] sd 2:0:0:0: [sda] Write Protect is off
[    3.159671] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.160079] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    3.161818] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.166600]  sda: sda1 sda2 sda3
[    3.168131] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.598755] pcnet32 0000:00:03.0: eth0: link up
[   15.042681] eth0: no IPv6 routers present
[   70.532863]  sda: sda1 sda2 sda3
[   70.545142]  sda: sda1 sda2 sda3
[   73.673463] Intel AES-NI instructions are not detected.

To consider:
* If a dd if=/dev/zero count=1024 of=/dev/loop0 is put immediately in from of mkfs, dd  succeeds but mkfs fail. With 3 mkfs fails, no dd fail was observed before.
* if a "dd if=/dev/zero of=/dev/loop0" is used, dd itself fails, syscall stack same as with mkfs (2 test, 1 fail). When dd OK, than mkfs also
* When dd is working as usually, stack of dd can be same as in problematic dd/mkfs case, but stack changes to sync_buffer/cond_resched sometimes.
* Could it be, that loading of crypt components is racy?

Kind regards,
Roman Fiedler
