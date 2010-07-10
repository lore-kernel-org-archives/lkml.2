Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0GJKFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:05:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0GJKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=g7NVl0txczC57msqqrMwWRlgvZegcYDmOEOmaPbECw0kuWIktf3DZG8KQLM8KsmlmU
         CGdG3fiQ1LnVHDSQU+FIQ6QWdlw8T/cAggoKeU9Z1LC6FdTnwXjxkGMDvZbqA8Vq56yG
         ajg+GaBU+1pYhjeGjWMB8864iYe4AAPqBfkT4=
Date: Sat, 10 Jul 2010 13:04:43 +0300
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3: Load average climbing to 3+ with no apparent
 reason: CPU 98% idle, with hardly no I/O
Message-ID: <20100710130443.036e4fb2@debian>
In-Reply-To: <20100706194017.a543dfb9.akpm@linux-foundation.org>
References: <20100701104022.404410d6@debian>
	<20100706194017.a543dfb9.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010 19:40:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 1 Jul 2010 10:40:22 +0300 T__r__k Edwin
> <edwintorok@gmail.com> wrote:
> 
> > Hi,
> > 
> > I just noticed that my load average is 2.99 and climbing (it is 3.11
> > right now).
> > CPU is 98% idle, with hardly any I/O at all so I don't know what is
> > causing this:
> >  10:32:55 up  1:01,  5 users,  load average: 3.28, 3.31, 3.09
> > 
> > $ vmstat 5
> > procs -----------memory---------- ---swap-- -----io---- -system--
> > ----cpu---- r  b   swpd   free   buff  cache   si   so    bi
> > bo   in   cs us sy id wa 0  0      0 492412 490320 1716264    0
> > 0   122    79  331  419  2  1 93  4 0  0      0 492388 490320
> > 1716264    0    0     0    13  755  983  0  1 99  0 0  0      0
> > 492632 490324 1716040    0    0     1    71 1013 1455  1  1 98  0
> > 1  0      0 492132 490340 1716264    0    0     4  1651  947 1223
> > 2  1 96  1 0  0      0 491972 490340 1716272    0    0     0    69
> > 1122 1586  2  2 96  0 0  0      0 491788 490340 1716272    0
> > 0     0    41 1527 2517  3  2 95  0 0  0      0 491884 490340
> > 1716272    0    0     0   107 1419 2193  2 1 97  0
> > 
> > This happens with 2.6.35-rc3-00001-g6bdebf9 (where the -00001 patch
> > is this bugfix required for networking to work at all: "net: fix
> > deliver_no_wcard regression on loopback device")
> > 
> > I have attached the output of cfs-debug-info.sh:
> > cfs-debug-info-2010.07.01-10.29.57.gz
> > 
> > I don't see anything special in dmesg, just the continous reset of
> > ata9 (CDROM) that I reported about already:
> > http://lkml.org/lkml/2010/6/27/83 Could this cause load average
> > calculation to go wrong?
> 
> Could be.  Run `ps aux' and see which tasks are stuck in "D" state (if
> any).  Use sysrq-W or `echo w > /proc/sysrq-trigger' (do `dmesg -n 8'
> first) to get stack traces of any stuck tasks.  Try to prevent email
> client wordwrapping when sending that info out, please.
> 

The increased load average is definetely due to the faulty CDROM drive, it only occurs when I plug it back in.
Also these are the tasks stuck in D state:

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       610  0.2  0.0      0     0 ?        D    12:42   0:01 [scsi_eh_8]
timidity  6263  0.0  0.1  75864  5784 ?        S    12:44   0:00 /usr/bin/timidity -Os -iAD
root      6901  0.0  0.0  24324   884 ?        D    12:44   0:00 hald-addon-storage: polling /dev/sr0 (every 2 sec)
root      6909  0.0  0.0  24324  1212 ?        D    12:44   0:00 hald-addon-storage: polling /dev/sr1 (every 2 sec)
root      8210  0.0  0.0   3912   572 ?        D<   12:49   0:00 /lib/udev/cdrom_id --export /dev/sr1
root      8211  0.0  0.0  21996   868 ?        D    12:49   0:00 /usr/lib/hal/hald-probe-storage --only-check-for-media
edwin     8237  0.0  0.0   7600   796 pts/1    S+   12:50   0:00 grep D

They aren't stuck for too long (a minute or so), just while Linux is resetting the ATA link.
Of course this reset occurs multiple times so these tasks become stuck again, load average starts to climb again, then it drops, then it climbs, etc.

Although this happens with no CDROM in the drive too, it is easier to trigger the climb of load average by just inserting a CD into the drive.

Here is the dmesg where I did 'echo w >/proc/sysrq-trigger':
[  431.379754] ata9: drained 65536 bytes to clear DRQ.
[  431.488820] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  431.488823] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
[  431.488833] ata9.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[  431.488837]          res 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
[  431.488845] ata9.01: status: { DRDY DF DRQ ERR }
[  431.488866] ata9: soft resetting link
[  436.684012] ata9: link is slow to respond, please be patient (ready=0)
[  441.500016] ata9: SRST failed (errno=-16)
[  441.500026] ata9: soft resetting link
[  446.696024] ata9: link is slow to respond, please be patient (ready=0)
[  451.512016] ata9: SRST failed (errno=-16)
[  451.512027] ata9: soft resetting link
[  456.716013] ata9: link is slow to respond, please be patient (ready=0)
[  465.124076] ata9.01: link status unknown, clearing UNKNOWN to NONE
[  465.140171] ata9.01: both IDENTIFYs aborted, assuming NODEV
[  465.140173] ata9.01: revalidation failed (errno=-2)
[  470.124028] ata9: soft resetting link
[  470.320659] ata9.00: configured for UDMA/33
[  475.336033] ata9.01: qc timeout (cmd 0xef)
[  475.336039] ata9.01: failed to set xfermode (err_mask=0x4)
[  475.336043] ata9.01: limiting speed to UDMA/33:PIO3
[  480.384014] ata9: link is slow to respond, please be patient (ready=0)
[  481.505240] SysRq : Show Blocked State
[  481.505243]   task                        PC stack   pid father
[  481.505251] scsi_eh_8     D 0000000000000001     0   610      2 0x00000000
[  481.505254]  ffff88012db999e0 0000000000000046 0000000000015742 0000000000000000
[  481.505258]  ffff88012db99fd8 ffff88012ec80000 ffff88012db99fd8 ffff88012db98000
[  481.505260]  ffff88012db98000 ffff88012db99fd8 ffff88012db98000 ffff88012db99fd8
[  481.505263] Call Trace:
[  481.505270]  [<ffffffff813cc368>] schedule_timeout+0x24b/0x275
[  481.505273]  [<ffffffff810480b2>] ? process_timeout+0x0/0xb
[  481.505277]  [<ffffffff812edcc0>] ? ata_sff_check_ready+0x0/0x2a
[  481.505279]  [<ffffffff813cc3ab>] schedule_timeout_uninterruptible+0x19/0x1b
[  481.505282]  [<ffffffff81047f81>] msleep+0x16/0x1d
[  481.505285]  [<ffffffff812e0fdd>] ata_wait_ready+0x165/0x182
[  481.505287]  [<ffffffff812f0609>] ata_sff_wait_ready+0x10/0x12
[  481.505289]  [<ffffffff812f08f9>] ata_sff_prereset+0x43/0xaf
[  481.505292]  [<ffffffff812f8ac2>] jmicron_pre_reset+0x113/0x129
[  481.505294]  [<ffffffff812f89af>] ? jmicron_pre_reset+0x0/0x129
[  481.505296]  [<ffffffff812ea589>] ata_eh_reset+0x221/0xc94
[  481.505299]  [<ffffffff813cb2ed>] ? printk+0x3c/0x3f
[  481.505301]  [<ffffffff812ef2a6>] ? ata_sff_postreset+0x0/0x89
[  481.505303]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505305]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505307]  [<ffffffff812ec109>] ata_eh_recover+0x2d3/0xda7
[  481.505310]  [<ffffffff812ef2a6>] ? ata_sff_postreset+0x0/0x89
[  481.505312]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505314]  [<ffffffff812f89af>] ? jmicron_pre_reset+0x0/0x129
[  481.505316]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505318]  [<ffffffff812ecd89>] ata_do_eh+0x46/0x93
[  481.505321]  [<ffffffff812ef2a6>] ? ata_sff_postreset+0x0/0x89
[  481.505323]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505325]  [<ffffffff812f89af>] ? jmicron_pre_reset+0x0/0x129
[  481.505327]  [<ffffffff812f071c>] ? ata_sff_softreset+0x0/0x19a
[  481.505329]  [<ffffffff812ef139>] ata_sff_error_handler+0xde/0xeb
[  481.505332]  [<ffffffff812ef236>] ata_bmdma_error_handler+0xf0/0xf9
[  481.505334]  [<ffffffff812ed714>] ata_scsi_error+0x339/0x693
[  481.505337]  [<ffffffff812d237c>] scsi_error_handler+0xc3/0x403
[  481.505339]  [<ffffffff812d22b9>] ? scsi_error_handler+0x0/0x403
[  481.505343]  [<ffffffff81053503>] kthread+0x7a/0x82
[  481.505346]  [<ffffffff81003754>] kernel_thread_helper+0x4/0x10
[  481.505348]  [<ffffffff81053489>] ? kthread+0x0/0x82
[  481.505350]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[  481.505361] hald-addon-st D 0000000000000000     0  6901   6047 0x00000000
[  481.505364]  ffff88011c5abaf8 0000000000000086 0000000000013d00 0000000000000286
[  481.505367]  ffff88011c5abfd8 ffff88012db30000 ffff88011c5abfd8 ffff88011c5aa000
[  481.505370]  ffff88011c5aa000 ffff88011c5abfd8 ffff88011c5aa000 ffff88011c5abfd8
[  481.505372] Call Trace:
[  481.505375]  [<ffffffff81053c0b>] ? prepare_to_wait+0x71/0x7c
[  481.505378]  [<ffffffff812d274d>] scsi_block_when_processing_errors+0x91/0xc2
[  481.505380]  [<ffffffff810539c9>] ? autoremove_wake_function+0x0/0x34
[  481.505383]  [<ffffffff812303c3>] ? get_disk+0xd9/0xfd
[  481.505396]  [<ffffffffa0096301>] sr_open+0x11/0x1b [sr_mod]
[  481.505400]  [<ffffffffa007f086>] cdrom_open+0x4d/0x47b [cdrom]
[  481.505403]  [<ffffffff812bed6a>] ? kobj_lookup+0x1c0/0x1fb
[  481.505406]  [<ffffffff8123b3f8>] ? kobject_get+0x1a/0x22
[  481.505410]  [<ffffffffa009649b>] sr_block_open+0x8b/0xa8 [sr_mod]
[  481.505413]  [<ffffffff812b9593>] ? get_device+0x14/0x1a
[  481.505416]  [<ffffffff8110c0bc>] __blkdev_get+0xda/0x391
[  481.505419]  [<ffffffff8110c37e>] blkdev_get+0xb/0xd
[  481.505421]  [<ffffffff8110c427>] blkdev_open+0xa7/0xe6
[  481.505423]  [<ffffffff8110c380>] ? blkdev_open+0x0/0xe6
[  481.505426]  [<ffffffff810e2f5a>] __dentry_open+0x1ce/0x2fd
[  481.505428]  [<ffffffff810e314e>] nameidata_to_filp+0x3a/0x4b
[  481.505431]  [<ffffffff810eea7e>] do_last+0x4e5/0x64b
[  481.505433]  [<ffffffff810f0843>] do_filp_open+0x202/0x641
[  481.505435]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  481.505438]  [<ffffffff810f96e0>] ? alloc_fd+0x111/0x123
[  481.505440]  [<ffffffff810e2ca3>] do_sys_open+0x5e/0x10a
[  481.505442]  [<ffffffff810e2d78>] sys_open+0x1b/0x1d
[  481.505445]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  481.505446] hald-addon-st D 0000000000000001     0  6909   6047 0x00000000
[  481.505449]  ffff88011ab7bbe8 0000000000000086 0000000000000286 ffffffff00000000
[  481.505452]  ffff88011ab7bfd8 ffff88012cc59870 ffff88011ab7bfd8 ffff88011ab7a000
[  481.505455]  ffff88011ab7a000 ffff88011ab7bfd8 ffff88011ab7a000 ffff88011ab7bfd8
[  481.505458] Call Trace:
[  481.505460]  [<ffffffff8110ae41>] bd_prepare_to_claim+0xcf/0x107
[  481.505463]  [<ffffffff810539c9>] ? autoremove_wake_function+0x0/0x34
[  481.505465]  [<ffffffff8110b72d>] bd_start_claiming+0x7c/0xbd
[  481.505468]  [<ffffffff8110c3ee>] blkdev_open+0x6e/0xe6
[  481.505470]  [<ffffffff8110c380>] ? blkdev_open+0x0/0xe6
[  481.505472]  [<ffffffff810e2f5a>] __dentry_open+0x1ce/0x2fd
[  481.505474]  [<ffffffff810e314e>] nameidata_to_filp+0x3a/0x4b
[  481.505477]  [<ffffffff810eea7e>] do_last+0x4e5/0x64b
[  481.505479]  [<ffffffff810f0843>] do_filp_open+0x202/0x641
[  481.505481]  [<ffffffff810f96e0>] ? alloc_fd+0x111/0x123
[  481.505483]  [<ffffffff810e2ca3>] do_sys_open+0x5e/0x10a
[  481.505485]  [<ffffffff810e2d78>] sys_open+0x1b/0x1d
[  481.505488]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  481.505508] cdrom_id      D 0000000000000001     0  8210   7575 0x00000000
[  481.505511]  ffff880110557b98 0000000000000086 ffffffff817338c0 0000000000000000
[  481.505514]  ffff880110557fd8 ffff880114618000 ffff880110557fd8 ffff880110556000
[  481.505517]  ffff880110556000 ffff880110557fd8 ffff880110556000 ffff880110557fd8
[  481.505520] Call Trace:
[  481.505523]  [<ffffffff813cc79f>] __mutex_lock_slowpath+0x121/0x193
[  481.505525]  [<ffffffff8122fdf7>] ? exact_match+0x0/0xa
[  481.505527]  [<ffffffff813cc5e1>] mutex_lock+0x16/0x2d
[  481.505530]  [<ffffffff8110c06b>] __blkdev_get+0x89/0x391
[  481.505532]  [<ffffffff8110c37e>] blkdev_get+0xb/0xd
[  481.505534]  [<ffffffff8110c427>] blkdev_open+0xa7/0xe6
[  481.505536]  [<ffffffff8110c380>] ? blkdev_open+0x0/0xe6
[  481.505538]  [<ffffffff810e2f5a>] __dentry_open+0x1ce/0x2fd
[  481.505541]  [<ffffffff810e314e>] nameidata_to_filp+0x3a/0x4b
[  481.505543]  [<ffffffff810eea7e>] do_last+0x4e5/0x64b
[  481.505545]  [<ffffffff810f0843>] do_filp_open+0x202/0x641
[  481.505548]  [<ffffffff810c7bae>] ? unmap_region+0x141/0x176
[  481.505550]  [<ffffffff810f96e0>] ? alloc_fd+0x111/0x123
[  481.505552]  [<ffffffff810e2ca3>] do_sys_open+0x5e/0x10a
[  481.505555]  [<ffffffff810e2d78>] sys_open+0x1b/0x1d
[  481.505557]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  481.505559] hald-probe-st D 0000000000000000     0  8211   6047 0x00000004
[  481.505561]  ffff88010d4c7aa8 0000000000000082 ffff88010d4c79f8 ffffffff812f0bcf
[  481.505564]  ffff88010d4c7fd8 ffff88012cc5b0e0 ffff88010d4c7fd8 ffff88010d4c6000
[  481.505567]  ffff88010d4c6000 ffff88010d4c7fd8 ffff88010d4c6000 ffff88010d4c7fd8
[  481.505570] Call Trace:
[  481.505572]  [<ffffffff812f0bcf>] ? ata_bmdma_qc_issue+0x41/0x152
[  481.505574]  [<ffffffff812e625a>] ? ata_scsi_translate+0x108/0x141
[  481.505577]  [<ffffffff812ce515>] ? scsi_done+0x0/0x72
[  481.505579]  [<ffffffff813cc145>] schedule_timeout+0x28/0x275
[  481.505582]  [<ffffffff81229cd9>] ? blk_peek_request+0x1c1/0x1d9
[  481.505584]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  481.505586]  [<ffffffff813cb4c6>] wait_for_common+0xc2/0x13c
[  481.505589]  [<ffffffff8103798d>] ? default_wake_function+0x0/0xf
[  481.505591]  [<ffffffff813cb5da>] wait_for_completion+0x18/0x1a
[  481.505594]  [<ffffffff8122ddef>] blk_execute_rq+0x85/0x9e
[  481.505596]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  481.505598]  [<ffffffff812d4b88>] scsi_execute+0xf1/0x143
[  481.505601]  [<ffffffff812d4cd7>] scsi_execute_req+0xfd/0x12f
[  481.505604]  [<ffffffff812cf763>] T.641+0x3a/0x106
[  481.505606]  [<ffffffff812cf876>] scsi_set_medium_removal+0x47/0x6c
[  481.505610]  [<ffffffffa0097220>] sr_lock_door+0x1b/0x1d [sr_mod]
[  481.505614]  [<ffffffffa007d5e6>] cdrom_release+0x17f/0x1dd [cdrom]
[  481.505616]  [<ffffffff8122f4dc>] ? __blkdev_driver_ioctl+0x90/0x9e
[  481.505619]  [<ffffffffa0096402>] sr_block_release+0x19/0x27 [sr_mod]
[  481.505622]  [<ffffffff8110be96>] __blkdev_put+0x8b/0x166
[  481.505624]  [<ffffffff8110af12>] ? block_ioctl+0x32/0x36
[  481.505627]  [<ffffffff8110bf7c>] blkdev_put+0xb/0xd
[  481.505629]  [<ffffffff8110bfb7>] blkdev_close+0x39/0x3e
[  481.505631]  [<ffffffff810e565d>] fput+0x109/0x1c8
[  481.505633]  [<ffffffff810e2b59>] filp_close+0x63/0x6d
[  481.505635]  [<ffffffff810e2c0b>] sys_close+0xa8/0xe2
[  481.505638]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  481.505641] Sched Debug Version: v0.09, 2.6.35-rc3-00001-g6bdebf9 #82
[  481.505642] now at 481505.641045 msecs
[  481.505644]   .jiffies                                 : 4295012672
[  481.505645]   .sysctl_sched_latency                    : 18.000000
[  481.505647]   .sysctl_sched_min_granularity            : 6.000000
[  481.505648]   .sysctl_sched_wakeup_granularity         : 3.000000
[  481.505650]   .sysctl_sched_child_runs_first           : 0.000000
[  481.505651]   .sysctl_sched_features                   : 15471
[  481.505653]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  481.505655] 
[  481.505655] cpu#0, 2833.203 MHz
[  481.505656]   .nr_running                    : 0
[  481.505658]   .load                          : 0
[  481.505659]   .nr_switches                   : 181383
[  481.505660]   .nr_load_updates               : 41390
[  481.505662]   .nr_uninterruptible            : 2
[  481.505663]   .next_balance                  : 4295.012671
[  481.505664]   .curr->pid                     : 0
[  481.505666]   .clock                         : 481499.900017
[  481.505667]   .cpu_load[0]                   : 0
[  481.505668]   .cpu_load[1]                   : 0
[  481.505669]   .cpu_load[2]                   : 0
[  481.505670]   .cpu_load[3]                   : 0
[  481.505671]   .cpu_load[4]                   : 0
[  481.505673]   .yld_count                     : 156
[  481.505674]   .sched_switch                  : 0
[  481.505675]   .sched_count                   : 184820
[  481.505676]   .sched_goidle                  : 71401
[  481.505678]   .avg_idle                      : 1000000
[  481.505679]   .ttwu_count                    : 102998
[  481.505680]   .ttwu_local                    : 65912
[  481.505681]   .bkl_count                     : 1326
[  481.505683] 
[  481.505683] cfs_rq[0]:/
[  481.505685]   .exec_clock                    : 12103.772700
[  481.505686]   .MIN_vruntime                  : 0.000001
[  481.505688]   .min_vruntime                  : 25915.805009
[  481.505689]   .max_vruntime                  : 0.000001
[  481.505691]   .spread                        : 0.000000
[  481.505692]   .spread0                       : 0.000000
[  481.505693]   .nr_running                    : 0
[  481.505694]   .load                          : 0
[  481.505695]   .nr_spread_over                : 128
[  481.505697]   .shares                        : 0
[  481.505698] 
[  481.505699] rt_rq[0]:
[  481.505700]   .rt_nr_running                 : 0
[  481.505701]   .rt_throttled                  : 0
[  481.505702]   .rt_time                       : 0.000000
[  481.505704]   .rt_runtime                    : 950.000000
[  481.505705] 
[  481.505706] runnable tasks:
[  481.505706]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  481.505707] ----------------------------------------------------------------------------------------------------------
[  481.505718] 
[  481.505719] cpu#1, 2833.203 MHz
[  481.505720]   .nr_running                    : 1
[  481.505721]   .load                          : 1024
[  481.505722]   .nr_switches                   : 201126
[  481.505724]   .nr_load_updates               : 48336
[  481.505725]   .nr_uninterruptible            : 2
[  481.505726]   .next_balance                  : 4295.012673
[  481.505727]   .curr->pid                     : 8238
[  481.505729]   .clock                         : 481505.011439
[  481.505730]   .cpu_load[0]                   : 0
[  481.505731]   .cpu_load[1]                   : 0
[  481.505732]   .cpu_load[2]                   : 0
[  481.505733]   .cpu_load[3]                   : 0
[  481.505735]   .cpu_load[4]                   : 24
[  481.505736]   .yld_count                     : 43
[  481.505737]   .sched_switch                  : 0
[  481.505738]   .sched_count                   : 203548
[  481.505739]   .sched_goidle                  : 88095
[  481.505741]   .avg_idle                      : 881956
[  481.505742]   .ttwu_count                    : 103413
[  481.505743]   .ttwu_local                    : 63824
[  481.505744]   .bkl_count                     : 1037
[  481.505745] 
[  481.505746] cfs_rq[1]:/
[  481.505747]   .exec_clock                    : 10363.523991
[  481.505749]   .MIN_vruntime                  : 0.000001
[  481.505750]   .min_vruntime                  : 64200.373942
[  481.505751]   .max_vruntime                  : 0.000001
[  481.505753]   .spread                        : 0.000000
[  481.505754]   .spread0                       : 38284.568933
[  481.505755]   .nr_running                    : 1
[  481.505757]   .load                          : 1024
[  481.505758]   .nr_spread_over                : 459
[  481.505759]   .shares                        : 0
[  481.505760] 
[  481.505761] rt_rq[1]:
[  481.505762]   .rt_nr_running                 : 0
[  481.505763]   .rt_throttled                  : 0
[  481.505764]   .rt_time                       : 0.000000
[  481.505766]   .rt_runtime                    : 950.000000
[  481.505767] 
[  481.505768] runnable tasks:
[  481.505768]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  481.505769] ----------------------------------------------------------------------------------------------------------
[  481.505776] R           bash  8238     64191.373942        42   120     64191.373942       154.345217      1276.132980 /
[  481.505781] 
[  481.505781] cpu#2, 2833.203 MHz
[  481.505783]   .nr_running                    : 0
[  481.505784]   .load                          : 0
[  481.505785]   .nr_switches                   : 183448
[  481.505786]   .nr_load_updates               : 43681
[  481.505787]   .nr_uninterruptible            : 0
[  481.505789]   .next_balance                  : 4295.012673
[  481.505790]   .curr->pid                     : 0
[  481.505791]   .clock                         : 481505.012725
[  481.505793]   .cpu_load[0]                   : 0
[  481.505794]   .cpu_load[1]                   : 0
[  481.505795]   .cpu_load[2]                   : 0
[  481.505796]   .cpu_load[3]                   : 0
[  481.505797]   .cpu_load[4]                   : 0
[  481.505798]   .yld_count                     : 103
[  481.505800]   .sched_switch                  : 0
[  481.505801]   .sched_count                   : 186659
[  481.505802]   .sched_goidle                  : 73485
[  481.505803]   .avg_idle                      : 1000000
[  481.505805]   .ttwu_count                    : 101704
[  481.505806]   .ttwu_local                    : 61715
[  481.505807]   .bkl_count                     : 944
[  481.505808] 
[  481.505809] cfs_rq[2]:/
[  481.505810]   .exec_clock                    : 14799.407139
[  481.505812]   .MIN_vruntime                  : 0.000001
[  481.505813]   .min_vruntime                  : 52128.827076
[  481.505814]   .max_vruntime                  : 0.000001
[  481.505816]   .spread                        : 0.000000
[  481.505817]   .spread0                       : 26213.022067
[  481.505818]   .nr_running                    : 0
[  481.505819]   .load                          : 0
[  481.505821]   .nr_spread_over                : 104
[  481.505822]   .shares                        : 0
[  481.505823] 
[  481.505823] rt_rq[2]:
[  481.505824]   .rt_nr_running                 : 0
[  481.505826]   .rt_throttled                  : 0
[  481.505827]   .rt_time                       : 0.000000
[  481.505828]   .rt_runtime                    : 950.000000
[  481.505830] 
[  481.505830] runnable tasks:
[  481.505831]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  481.505832] ----------------------------------------------------------------------------------------------------------
[  481.505839] 
[  481.505839] cpu#3, 2833.203 MHz
[  481.505841]   .nr_running                    : 0
[  481.505842]   .load                          : 0
[  481.505843]   .nr_switches                   : 159290
[  481.505844]   .nr_load_updates               : 39628
[  481.505845]   .nr_uninterruptible            : 1
[  481.505847]   .next_balance                  : 4295.012689
[  481.505848]   .curr->pid                     : 0
[  481.505849]   .clock                         : 481505.509347
[  481.505851]   .cpu_load[0]                   : 0
[  481.505852]   .cpu_load[1]                   : 0
[  481.505853]   .cpu_load[2]                   : 9
[  481.505854]   .cpu_load[3]                   : 28
[  481.505855]   .cpu_load[4]                   : 39
[  481.505857]   .yld_count                     : 26
[  481.505858]   .sched_switch                  : 0
[  481.505859]   .sched_count                   : 162684
[  481.505860]   .sched_goidle                  : 68562
[  481.505861]   .avg_idle                      : 688353
[  481.505863]   .ttwu_count                    : 81963
[  481.505864]   .ttwu_local                    : 33081
[  481.505865]   .bkl_count                     : 419
[  481.505866] 
[  481.505867] cfs_rq[3]:/
[  481.505868]   .exec_clock                    : 12894.469353
[  481.505870]   .MIN_vruntime                  : 0.000001
[  481.505871]   .min_vruntime                  : 66857.085100
[  481.505872]   .max_vruntime                  : 0.000001
[  481.505874]   .spread                        : 0.000000
[  481.505875]   .spread0                       : 40941.280091
[  481.505876]   .nr_running                    : 0
[  481.505877]   .load                          : 0
[  481.505879]   .nr_spread_over                : 407
[  481.505880]   .shares                        : 0
[  481.505881] 
[  481.505881] rt_rq[3]:
[  481.505883]   .rt_nr_running                 : 0
[  481.505884]   .rt_throttled                  : 0
[  481.505885]   .rt_time                       : 0.000000
[  481.505886]   .rt_runtime                    : 950.000000
[  481.505888] 
[  481.505888] runnable tasks:
[  481.505889]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  481.505890] ----------------------------------------------------------------------------------------------------------
[  481.505897] 
[  485.368016] ata9: device not ready (errno=-16), forcing hardreset
[  485.368027] ata9: soft resetting link
[  490.568025] ata9: link is slow to respond, please be patient (ready=0)
[  495.388011] ata9: SRST failed (errno=-16)
[  495.388021] ata9: soft resetting link
[  500.584012] ata9: link is slow to respond, please be patient (ready=0)
[  505.416012] ata9: SRST failed (errno=-16)
[  505.416022] ata9: soft resetting link
[  510.620524] ata9: link is slow to respond, please be patient (ready=0)
[  519.040066] ata9.01: link status unknown, clearing UNKNOWN to NONE
[  524.048159] ata9.01: qc timeout (cmd 0xa1)
[  524.048163] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[  524.048165] ata9.01: revalidation failed (errno=-5)
[  524.048167] ata9.01: disabled
[  524.048171] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  524.048173] ata9.00: revalidation failed (errno=-5)
[  529.088024] ata9: link is slow to respond, please be patient (ready=0)
[  534.072013] ata9: device not ready (errno=-16), forcing hardreset
[  534.072023] ata9: soft resetting link
[  539.268026] ata9: link is slow to respond, please be patient (ready=0)
[  544.088025] ata9: SRST failed (errno=-16)
[  544.088035] ata9: soft resetting link
[  549.284024] ata9: link is slow to respond, please be patient (ready=0)
[  552.644561] ata9.01: link status unknown, clearing UNKNOWN to NONE
[  557.644031] ata9.00: qc timeout (cmd 0xa1)
[  557.644035] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  557.644038] ata9.00: revalidation failed (errno=-5)
[  562.688011] ata9: link is slow to respond, please be patient (ready=0)
[  567.672026] ata9: device not ready (errno=-16), forcing hardreset
[  567.672036] ata9: soft resetting link
[  572.868014] ata9: link is slow to respond, please be patient (ready=0)
[  577.692017] ata9: SRST failed (errno=-16)
[  577.692026] ata9: soft resetting link
[  582.888514] ata9: link is slow to respond, please be patient (ready=0)
[  586.260065] ata9.01: link status unknown, clearing UNKNOWN to NONE
[  596.260033] ata9.00: qc timeout (cmd 0xa1)
[  596.260038] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  596.260041] ata9.00: revalidation failed (errno=-5)
[  596.260044] ata9.00: disabled
[  600.537539] INFO: task hald-addon-stor:6901 blocked for more than 120 seconds.
[  600.537543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.537545] hald-addon-st D 0000000000000000     0  6901   6047 0x00000000
[  600.537550]  ffff88011c5abaf8 0000000000000086 0000000000013d00 0000000000000286
[  600.537554]  ffff88011c5abfd8 ffff88012db30000 ffff88011c5abfd8 ffff88011c5aa000
[  600.537558]  ffff88011c5aa000 ffff88011c5abfd8 ffff88011c5aa000 ffff88011c5abfd8
[  600.537562] Call Trace:
[  600.537569]  [<ffffffff81053c0b>] ? prepare_to_wait+0x71/0x7c
[  600.537575]  [<ffffffff812d274d>] scsi_block_when_processing_errors+0x91/0xc2
[  600.537578]  [<ffffffff810539c9>] ? autoremove_wake_function+0x0/0x34
[  600.537582]  [<ffffffff812303c3>] ? get_disk+0xd9/0xfd
[  600.537596]  [<ffffffffa0096301>] sr_open+0x11/0x1b [sr_mod]
[  600.537602]  [<ffffffffa007f086>] cdrom_open+0x4d/0x47b [cdrom]
[  600.537606]  [<ffffffff812bed6a>] ? kobj_lookup+0x1c0/0x1fb
[  600.537609]  [<ffffffff8123b3f8>] ? kobject_get+0x1a/0x22
[  600.537618]  [<ffffffffa009649b>] sr_block_open+0x8b/0xa8 [sr_mod]
[  600.537622]  [<ffffffff812b9593>] ? get_device+0x14/0x1a
[  600.537625]  [<ffffffff8110c0bc>] __blkdev_get+0xda/0x391
[  600.537627]  [<ffffffff8110c37e>] blkdev_get+0xb/0xd
[  600.537630]  [<ffffffff8110c427>] blkdev_open+0xa7/0xe6
[  600.537632]  [<ffffffff8110c380>] ? blkdev_open+0x0/0xe6
[  600.537635]  [<ffffffff810e2f5a>] __dentry_open+0x1ce/0x2fd
[  600.537637]  [<ffffffff810e314e>] nameidata_to_filp+0x3a/0x4b
[  600.537640]  [<ffffffff810eea7e>] do_last+0x4e5/0x64b
[  600.537642]  [<ffffffff810f0843>] do_filp_open+0x202/0x641
[  600.537644]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  600.537647]  [<ffffffff810f96e0>] ? alloc_fd+0x111/0x123
[  600.537649]  [<ffffffff810e2ca3>] do_sys_open+0x5e/0x10a
[  600.537651]  [<ffffffff810e2d78>] sys_open+0x1b/0x1d
[  600.537654]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  600.537675] INFO: task cdrom_id:8210 blocked for more than 120 seconds.
[  600.537676] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.537678] cdrom_id      D 0000000000000001     0  8210   7575 0x00000000
[  600.537681]  ffff880110557b98 0000000000000086 ffffffff817338c0 0000000000000000
[  600.537684]  ffff880110557fd8 ffff880114618000 ffff880110557fd8 ffff880110556000
[  600.537687]  ffff880110556000 ffff880110557fd8 ffff880110556000 ffff880110557fd8
[  600.537689] Call Trace:
[  600.537693]  [<ffffffff813cc79f>] __mutex_lock_slowpath+0x121/0x193
[  600.537695]  [<ffffffff8122fdf7>] ? exact_match+0x0/0xa
[  600.537698]  [<ffffffff813cc5e1>] mutex_lock+0x16/0x2d
[  600.537700]  [<ffffffff8110c06b>] __blkdev_get+0x89/0x391
[  600.537703]  [<ffffffff8110c37e>] blkdev_get+0xb/0xd
[  600.537705]  [<ffffffff8110c427>] blkdev_open+0xa7/0xe6
[  600.537707]  [<ffffffff8110c380>] ? blkdev_open+0x0/0xe6
[  600.537709]  [<ffffffff810e2f5a>] __dentry_open+0x1ce/0x2fd
[  600.537711]  [<ffffffff810e314e>] nameidata_to_filp+0x3a/0x4b
[  600.537714]  [<ffffffff810eea7e>] do_last+0x4e5/0x64b
[  600.537716]  [<ffffffff810f0843>] do_filp_open+0x202/0x641
[  600.537719]  [<ffffffff810c7bae>] ? unmap_region+0x141/0x176
[  600.537721]  [<ffffffff810f96e0>] ? alloc_fd+0x111/0x123
[  600.537723]  [<ffffffff810e2ca3>] do_sys_open+0x5e/0x10a
[  600.537725]  [<ffffffff810e2d78>] sys_open+0x1b/0x1d
[  600.537728]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  600.537730] INFO: task hald-probe-stor:8211 blocked for more than 120 seconds.
[  600.537731] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.537733] hald-probe-st D 0000000000000000     0  8211   6047 0x00000004
[  600.537736]  ffff88010d4c7aa8 0000000000000082 ffff88010d4c79f8 ffffffff812f0bcf
[  600.537738]  ffff88010d4c7fd8 ffff88012cc5b0e0 ffff88010d4c7fd8 ffff88010d4c6000
[  600.537741]  ffff88010d4c6000 ffff88010d4c7fd8 ffff88010d4c6000 ffff88010d4c7fd8
[  600.537744] Call Trace:
[  600.537747]  [<ffffffff812f0bcf>] ? ata_bmdma_qc_issue+0x41/0x152
[  600.537750]  [<ffffffff812e625a>] ? ata_scsi_translate+0x108/0x141
[  600.537752]  [<ffffffff812ce515>] ? scsi_done+0x0/0x72
[  600.537754]  [<ffffffff813cc145>] schedule_timeout+0x28/0x275
[  600.537757]  [<ffffffff81229cd9>] ? blk_peek_request+0x1c1/0x1d9
[  600.537759]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  600.537762]  [<ffffffff813cb4c6>] wait_for_common+0xc2/0x13c
[  600.537764]  [<ffffffff8103798d>] ? default_wake_function+0x0/0xf
[  600.537767]  [<ffffffff813cb5da>] wait_for_completion+0x18/0x1a
[  600.537769]  [<ffffffff8122ddef>] blk_execute_rq+0x85/0x9e
[  600.537771]  [<ffffffff8123b2cf>] ? kobject_put+0x47/0x4b
[  600.537774]  [<ffffffff812d4b88>] scsi_execute+0xf1/0x143
[  600.537776]  [<ffffffff812d4cd7>] scsi_execute_req+0xfd/0x12f
[  600.537779]  [<ffffffff812cf763>] T.641+0x3a/0x106
[  600.537782]  [<ffffffff812cf876>] scsi_set_medium_removal+0x47/0x6c
[  600.537785]  [<ffffffffa0097220>] sr_lock_door+0x1b/0x1d [sr_mod]
[  600.537789]  [<ffffffffa007d5e6>] cdrom_release+0x17f/0x1dd [cdrom]
[  600.537791]  [<ffffffff8122f4dc>] ? __blkdev_driver_ioctl+0x90/0x9e
[  600.537795]  [<ffffffffa0096402>] sr_block_release+0x19/0x27 [sr_mod]
[  600.537797]  [<ffffffff8110be96>] __blkdev_put+0x8b/0x166
[  600.537800]  [<ffffffff8110af12>] ? block_ioctl+0x32/0x36
[  600.537802]  [<ffffffff8110bf7c>] blkdev_put+0xb/0xd
[  600.537804]  [<ffffffff8110bfb7>] blkdev_close+0x39/0x3e
[  600.537807]  [<ffffffff810e565d>] fput+0x109/0x1c8
[  600.537809]  [<ffffffff810e2b59>] filp_close+0x63/0x6d
[  600.537811]  [<ffffffff810e2c0b>] sys_close+0xa8/0xe2
[  600.537813]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[  601.312511] ata9: link is slow to respond, please be patient (ready=0)
[  606.296014] ata9: device not ready (errno=-16), forcing hardreset
[  606.296025] ata9: soft resetting link
[  611.492013] ata9: link is slow to respond, please be patient (ready=0)
[  616.312027] ata9: SRST failed (errno=-16)
[  616.312038] ata9: soft resetting link
[  619.888068] ata9.01: link status unknown, clearing UNKNOWN to NONE
[  619.888078] ata9: EH complete
[  654.381414] irq 19: nobody cared (try booting with the "irqpoll" option)
[  654.381419] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-00001-g6bdebf9 #82
[  654.381422] Call Trace:
[  654.381424]  <IRQ>  [<ffffffff810871d2>] __report_bad_irq+0x38/0x87
[  654.381433]  [<ffffffff81087334>] note_interrupt+0x113/0x177
[  654.381436]  [<ffffffff81087ab3>] handle_fasteoi_irq+0xa8/0xd2
[  654.381440]  [<ffffffff81004d97>] handle_irq+0x1f/0x28
[  654.381443]  [<ffffffff810043ba>] do_IRQ+0x57/0xbe
[  654.381446]  [<ffffffff813ce313>] ret_from_intr+0x0/0xa
[  654.381448]  <EOI>  [<ffffffffa003e25b>] ? acpi_safe_halt+0x24/0x37 [processor]
[  654.381466]  [<ffffffffa003e34d>] acpi_idle_enter_c1+0x71/0xc8 [processor]
[  654.381470]  [<ffffffff81339d85>] ? menu_select+0x163/0x276
[  654.381474]  [<ffffffff81338ead>] cpuidle_idle_call+0x91/0x11c
[  654.381478]  [<ffffffff81001cbd>] cpu_idle+0x5c/0x9c
[  654.381481]  [<ffffffff813c8572>] start_secondary+0x1c6/0x1ca
[  654.381484] handlers:
[  654.381485] [<ffffffff812f006f>] (ata_bmdma_interrupt+0x0/0x1ab)
[  654.381490] [<ffffffffa000d2ae>] (usb_hcd_irq+0x0/0x60 [usbcore])
[  654.381502] Disabling IRQ #19

> Robert thinks that your hardware might be busted.  Did you investigate
> that further?  Have you rechecked earlier kernel versions to see if
> they work OK?

Yes, it is a hardware problem I just tested (BIOS hangs in detecting IDE drives too for a while), and it is just 1 of the CDROM drives
that has a problem (the older one, no surprise there).

I'm not sure if anything should be done about the load average, at least it is an indication that something is wrong...

Best regards,
--Edwin
