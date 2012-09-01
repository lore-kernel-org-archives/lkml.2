Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2IAOBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 10:01:34 -0400
Received: from hurricane.eginity.com ([138.210.133.129]:47935 "EHLO
	zazu.eginity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2IAOBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 10:01:32 -0400
X-Greylist: delayed 1189 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2012 10:01:32 EDT
Message-ID: <50421091.4030902@gmail.com>
Date: Sat, 01 Sep 2012 09:41:37 -0400
From: Dan Merillat <dan.merillat@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: IO stalls on one disk stall entire system
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a known-broken WD15EADS, which has the hilariously terrible
1000ms IO response time.  Yes, that's the right number of zeros.  I'm
using it as a convenient way to hunt down a general feeling of
unresponsiveness under disk load

In this case, the failing drive is mounted to /backup, and I'm copying
large random files to it.  Firefox is operating on my normal system
drives, and takes up to two-minute stalls:

Aug 26 17:41:13 fileserver kernel: [919921.115258] INFO: task
firefox-bin:17616 blocked for more than 120 seconds.
Aug 26 17:41:13 fileserver kernel: [919921.115261] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 26 17:41:13 fileserver kernel: [919921.115264] firefox-bin     D
ffff88012fd12440     0 17616  17525 0x00000000
Aug 26 17:41:13 fileserver kernel: [919921.115270]  ffff8800ba87dd60
0000000000000082 00007f5d00000000 ffff8800ba87dfd8
Aug 26 17:41:13 fileserver kernel: [919921.115277]  0000000000004000
0000000000012440 ffff88012aeb96a0 ffff8800ba952d40
Aug 26 17:41:13 fileserver kernel: [919921.115283]  700401208b000000
0000000014040800 0000000002000000 000000005cdbbb01
Aug 26 17:41:13 fileserver kernel: [919921.115289] Call Trace:
Aug 26 17:41:13 fileserver kernel: [919921.115296]  [<ffffffff81508453>]
? inet_sendmsg+0x93/0x9c
Aug 26 17:41:13 fileserver kernel: [919921.115301]  [<ffffffff8159a155>]
schedule+0x5f/0x61
Aug 26 17:41:13 fileserver kernel: [919921.115305]  [<ffffffff8159ac3b>]
rwsem_down_failed_common+0xdb/0x10d
Aug 26 17:41:13 fileserver kernel: [919921.115310]  [<ffffffff8159ac94>]
rwsem_down_read_failed+0x12/0x14
Aug 26 17:41:13 fileserver kernel: [919921.115314]  [<ffffffff81369fc4>]
call_rwsem_down_read_failed+0x14/0x30
Aug 26 17:41:13 fileserver kernel: [919921.115318]  [<ffffffff815991f0>]
? down_read+0x12/0x14
Aug 26 17:41:13 fileserver kernel: [919921.115326]  [<ffffffff8159db2f>]
do_page_fault+0x259/0x45d
Aug 26 17:41:13 fileserver kernel: [919921.115332]  [<ffffffff8110acc2>]
? vfsmount_lock_local_unlock+0x21/0x3c
Aug 26 17:41:13 fileserver kernel: [919921.115337]  [<ffffffff8110b6dd>]
? mntput_no_expire+0x2a/0x101
Aug 26 17:41:13 fileserver kernel: [919921.115343]  [<ffffffff81104d19>]
? __d_free+0x4e/0x53
Aug 26 17:41:13 fileserver kernel: [919921.115347]  [<ffffffff8110b7dc>]
? mntput+0x28/0x2a
Aug 26 17:41:13 fileserver kernel: [919921.115351]  [<ffffffff8136a0ca>]
? trace_hardirqs_off_thunk+0x3a/0x6c
Aug 26 17:41:13 fileserver kernel: [919921.115356]  [<ffffffff8159b61f>]
page_fault+0x1f/0x30

Linux fileserver 3.4.0-dan-00002-ga84219d #2 SMP PREEMPT Mon May 21
09:36:23 EDT 2012 x86_64 GNU/Linux

The only hardware shared between the bad drive and the rest of the
system is the first AHCI controller:
> 00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]

Some other drives are on this one:
> 02:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 03)


This is obviously an extreme case, but I've felt this IO stalling in
other contexts, like doing a recursive shasum on large bodies of data.
 I purposely have /home and /root on separate spindles from the bulk
data, but I still get IO stalls when /largevol is being used.

It's pretty easy to reproduce, just a pain to work on it when I do.
That's a two minute failure to satisfy a pagefault on an otherwise idle
drive (I.E. not the slow one), so it really bogs down badly when it
fails.  This continues until I ^C the rsync process - and wait for it to
finish flushing the current set of dirtied pages.

This may involve btrfs, as that's the underlying filesystem on the
target drive and on /largevol.  Root on a LV, physically located on yet
another, separate drive (lots of disks here).

2x250gb SATA MD-raid1 LVM - / (reiserfs), swap
1x40gb IDE - LVM /home/me/.mozilla btrfs,
4x2tb MD-raid5 - (no LVM) /largevol, btrfs
1x1.5TB SLOW ESATA - /backup

So I should have tons of spindle independence, but I'm just not seeing it.
