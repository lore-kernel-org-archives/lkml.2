Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1EPKFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:05:35 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:51427 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1EPKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:05:34 -0400
From: Nix <nix@esperi.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, "Ted Ts'o" <theotso@us.ibm.com>
Subject: Re: [BISECTED] 2.6.39rc: kobject-related reboot after RAID array initialization(?) post-QUEUE_FLAG_REENTER-removal
References: <8762pboc0j.fsf@spindle.srvr.nix>
	<20110516092113.60ed64d5@notabene.brown>
Emacs: there's a reason it comes with a built-in psychotherapist.
Date: Mon, 16 May 2011 11:05:18 +0100
In-Reply-To: <20110516092113.60ed64d5@notabene.brown> (NeilBrown's message of
	"Mon, 16 May 2011 09:21:13 +1000")
Message-ID: <877h9reza9.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2011, NeilBrown said:

> On Sun, 15 May 2011 23:05:32 +0100 Nix <nix@esperi.org.uk> wrote:
>
>> After this change:
>> 
>> commit c21e6beba8835d09bb80e34961430b13e60381c5
>> Author: Jens Axboe <jaxboe@fusionio.com>
>> Date:   Tue Apr 19 13:32:46 2011 +0200
>> 
>>     block: get rid of QUEUE_FLAG_REENTER
>> 
>>     We are currently using this flag to check whether it's safe
>>     to call into ->request_fn(). If it is set, we punt to kblockd.
>>     But we get a lot of false positives and excessive punts to
>>     kblockd, which hurts performance.
>> 
>>     The only real abuser of this infrastructure is SCSI. So export
>>     the async queue run and convert SCSI over to use that. There's
>>     room for improvement in that SCSI need not always use the async
>>     call, but this fixes our performance issue and they can fix that
>>     up in due time.
>> 
>>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> 
>> my system panics and reboots in early userspace. It is slightly
>> difficult to figure out where -- the reboot happens so fast -- but it is
>> either triggered by
>> 
>> /sbin/mdadm --assemble --scan --auto=md
>> 
>> (with mdadm v2.6.9, yes, I know, it's quite old but it works)
>> 
>> or by
>> 
>> /sbin/lvm vgscan --ignorelockingfailure --mknodes

No it isn't. I'm sorry for misleading you. I ran the commands manually
one by one in an emergency boot shell until I got a panic, and md is
blameless. More below.

>> (most probably the former, since I don't see any sign of lvm running in
>> the text that blinks up right before the reboot, and the oops below
>> mentions md1, not anything lvmish.
>> 
>> netconsole reports this (ignore the fact that md1 is resyncing, that's
>> because of previous instances of this bug!):
>> 
>> [    6.773532] md: md0 stopped.
>> [    6.976368] md: bind<sdb1>
>> [    6.978284] md: bind<sda1>
>> [    6.980162] bio: create slab <bio-1> at 1
>> [    6.981992] md/raid1:md0: active with 2 out of 2 mirrors
>> [    6.983745] md0: detected capacity change from 0 to 271319040
>> [    6.987345] md: md1 stopped.
>> [    6.989411]  md0: unknown partition table
>> [    7.000464] md: bind<sdb3>
>> [    7.002247] md: bind<sda3>
>> [    7.003998] md/raid1:md1: not clean -- starting background reconstruction
>> [    7.005669] md/raid1:md1: active with 2 out of 2 mirrors
>> [    7.007330] md1: detected capacity change from 0 to 486936436736
>> [    7.008982] md: resync of RAID array md1
>> [    7.008984] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> [    7.008985] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
>> [    7.008988] md: using 128k window, over a total of 475523864 blocks.
>> [    7.008990] md: resuming resync of md1 from checkpoint.
>> [    7.176568]  md1: unknown partition table
>> [    7.350823] general protection fault: 0000 [#1] PREEMPT SMP
>> [    7.353166] last sysfs file: /sys/devices/virtual/block/md1/dev
>> [    7.355496] CPU 1 
>> [    7.355514] Modules linked in: 
>> [    7.360073] 
>> [    7.362310] Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-rc4-00119-g584f790-dirty #11
>>  System manufacturer System Product Name /P6T 
>> [    7.364629] RIP: 0010:[<ffffffff8122bb01>] [<ffffffff8122bb01>] kobject_put+0x11/0x4b
>> [    7.366921] RSP: 0018:ffff88033fc0e510  EFLAGS: 00010202
>> [    7.369178] RAX: 0000000400000008 RBX: 3d9e2838ffff8813 RCX: 0000000000000003
>> [    7.371417] RDX: ffff8803396feec8 RSI: ffff8803391ea800 RDI: 3d9e2838ffff8813
>> [    7.373621] RBP: ffff88033fc0e520 R08: ffff88033fc0e530 R09: 00000000000003e8
>> [    7.375827] R10: 0000000001887509 R11: 0000000200000000 R12: ffff8803391ea800
>> [    7.378040] R13: ffff8803396fee00 R14: ffff88033d9e2848 R15: 0000000000001055
>> [    7.380265] FS:  0000000000000000(0000) GS:ffff88033fc40000(0000) knlGS:0000000000000000
>> [    7.382514] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    7.384765] CR2: 00000000004051d0 CR3: 000000033a22c000 CR4: 00000000000006e0
>> [    7.387037] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [    7.389325] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [    7.391610] Process kworker/0:0 (pid: 0, threadinfo ffff88033e256000, task ffff88033e254300)
>> [    7.393914] Stack:
>> [    7.396196]  ffff88033fc0e530 ffff88033d9e2800 ffff88033fc0e530 ffffffff81367f19 
>> [    7.398544]  ffff88033fc0e580 ffffffff81381614 ffff88033a2669c0 3d9e2838ffff8803 
>> [    7.400876]  0000000000000053 ffff8803396fee00 0000000000000202 0000000000000246 
>> [    7.403207] Call Trace:
>> [    7.405481] Code: 89 de 48 c7 c7 d8 ee 7d 81 31 c0 e8 c8 7b 33 00 e8
>> 9d 79 33 00 5b 41 5c c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff
>> 74 36 <f6> 47 3c 01 75 20 49 89 f8 48 8b 0f 48 c7 c2 ed ee 7d 81 be 53 
>> 
>> [    7.411141] RIP [<ffffffff8122bb01>] kobject_put+0x11/0x4b
>> [    7.413725]  RSP <ffff88033fc0e510>
>> [    7.416289] ---[ end trace 2a57282106bd5f52 ]---
>> [    7.418831] Kernel panic - not syncing: Fatal exception in interrupt
>> [    7.421364] Pid: 0, comm: kworker/0:0 Tainted: G      D     2.6.39-rc4-00119-g584f790-dirty #11
>> [    7.423926] Call Trace:

This crash is caused by *fsck*, to be specific by this line in my
initramfs:

fsck -t $TYPE -a $ROOT

where $TYPE is "ext4" and $ROOT is "/dev/main/root", an filesystem atop
LVM atop md.

fsck kicks up, does a journal replay, and then we panic. Why we panic is
unclear: it's hard to save output from strace in an emergency boot shell
with nothing mounted, and I suspect that if fsck panics, mount will
panic too (but I haven't tried it yet).

-- 
NULL && (void)
