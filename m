Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2KZSVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:21:41 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51269 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2KZSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:21:33 -0500
MIME-Version: 1.0
X-Originating-IP: [178.70.145.173]
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Mon, 26 Nov 2012 22:21:15 +0400
X-Google-Sender-Auth: qJxgdrQGkhd1woiGYXp_pjdQLPg
Message-ID: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
Subject: sles 11 sp2 srp and multipath issues
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg. Hello kernel team! I'm system enginer at clodo.ru
(russian cloud hosting provider) we are use xen and sles11-sp2 for our
compute xen nodes.
Each virtual machine (domU) have disks that attached by Infiniband
SRP. On top of disk that attached by srp we use multipath (to do
failover)
Now we have issues like all commands that uses multipath hang while
one storage is rebooted.
After some discussion with maintainer of linux-rdma (Bart Van Assche)
and using it backported ib_srp with HA patches we can't solve deadlock
issues. Bart thinks that SLES team does not backport some core scsi
patches to their kernel (3.0.42) to prevent multipath deadlock
(currently is about 2.5 minutes) on failed target.
Is that possible to determine or getting help to solve this issue?

P.S. Deadlock like this:
[ 1081.504939] SysRq : Show Blocked State
[ 1081.505059]   task                        PC stack   pid father
[ 1081.505105] multipathd      D 0000000000000000     0   335      1 0x00000000
[ 1081.505111]  ffff880112373ae8 0000000000000282 ffff880112373988
ffff880112373a68
[ 1081.505115]  ffff880112372010 ffff880112373ab0 ffff88011f9ba600
ffff88011f9ba600
[ 1081.505119]  ffff88011f9ba600 ffff880112373fd8 ffff880112373fd8
ffff88011f9ba600
[ 1081.505124] Call Trace:
[ 1081.505139]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505145]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505152]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505159]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505164]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505173]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505194]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505202]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505208]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505213]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505219]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505243]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505245] multipathd      D 0000000000000000     0   336      1 0x00000000
[ 1081.505249]  ffff880128dc9ae8 0000000000000282 0000000000000001
ffff880128dc9a68
[ 1081.505254]  ffff880128dc8010 ffff880128dc9ab0 ffff88010a68e480
ffff88010a68e480
[ 1081.505258]  ffff88010a68e480 ffff880128dc9fd8 ffff880128dc9fd8
ffff88010a68e480
[ 1081.505262] Call Trace:
[ 1081.505267]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505272]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505277]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505282]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505287]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505293]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505301]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505306]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505310]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505315]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505319]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505326]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505328] multipathd      D 0000000000000000     0   337      1 0x00000000
[ 1081.505332]  ffff88011fbafae8 0000000000000282 0000000000000000
ffff88011fbafa68
[ 1081.505336]  ffff88011fbae010 ffff88011fbafab0 ffff88011cee6040
ffff88011cee6040
[ 1081.505340]  ffff88011cee6040 ffff88011fbaffd8 ffff88011fbaffd8
ffff88011cee6040
[ 1081.505344] Call Trace:
[ 1081.505349]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505354]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505359]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505364]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505369]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505374]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505382]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505387]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505392]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505396]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505401]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505407]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505409] multipathd      D 0000000000000000     0   338      1 0x00000000
[ 1081.505413]  ffff880112369ae8 0000000000000282 ffff880112369988
ffff880112369a68
[ 1081.505417]  ffff880112368010 ffff880112369ab0 ffff88011536c580
ffff88011536c580
[ 1081.505421]  ffff88011536c580 ffff880112369fd8 ffff880112369fd8
ffff88011536c580
[ 1081.505425] Call Trace:
[ 1081.505430]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505435]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505440]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505445]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505450]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505456]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505464]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505469]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505473]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505478]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505482]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505489]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505491] multipathd      D 0000000000000000     0   345      1 0x00000000
[ 1081.505495]  ffff88010ac8dae8 0000000000000282 ffff88013ac2c260
ffff88010ac8da68
[ 1081.505499]  ffff88010ac8c010 ffff88010ac8dab0 ffff88011fa862c0
ffff88011fa862c0
[ 1081.505503]  ffff88011fa862c0 ffff88010ac8dfd8 ffff88010ac8dfd8
ffff88011fa862c0
[ 1081.505507] Call Trace:
[ 1081.505512]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505517]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505521]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505526]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505531]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505537]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505545]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505550]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505554]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505559]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505564]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505570]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505572] multipathd      D 0000000000000000     0   346      1 0x00000000
[ 1081.505576]  ffff88010ad05ae8 0000000000000282 ffff8801035b0708
ffff88010ad05a68
[ 1081.505580]  ffff88010ad04010 ffff88010ad05ab0 ffff8801067b8540
ffff8801067b8540
[ 1081.505584]  ffff8801067b8540 ffff88010ad05fd8 ffff88010ad05fd8
ffff8801067b8540
[ 1081.505588] Call Trace:
[ 1081.505593]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.505598]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.505603]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.505608]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.505612]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.505618]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.505626]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.505631]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.505636]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.505640]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.505645]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.505651]  [<00007fdfea571fa7>] 0x7fdfea571fa6
[ 1081.505671] md124_raid1     D ffff8801212172c0     0 19509      2 0x00000000
[ 1081.505676]  ffff88010d9f7bc0 0000000000000246 ffff880133193820
ffff88010d9f7b40
[ 1081.505680]  ffff88010d9f6010 ffff88010d9f7b88 ffff8800cf3f80c0
ffff8800cf3f80c0
[ 1081.505684]  ffff8800cf3f80c0 ffff88010d9f7fd8 ffff88010d9f7fd8
ffff8800cf3f80c0
[ 1081.505688] Call Trace:
[ 1081.505695]  [<ffffffff80314cc5>] md_super_wait+0x55/0xa0
[ 1081.505701]  [<ffffffff8032009a>] write_sb_page+0x7a/0x260
[ 1081.505706]  [<ffffffff80321415>] write_page+0x115/0x130
[ 1081.505711]  [<ffffffff80321ef6>] bitmap_daemon_work+0x506/0x640
[ 1081.505718]  [<ffffffff8031e4d8>] md_check_recovery+0x38/0x550
[ 1081.505724]  [<ffffffffa04d2307>] raid1d+0x27/0x380 [raid1]
[ 1081.505733]  [<ffffffff80315810>] md_thread+0x130/0x160
[ 1081.505740]  [<ffffffff80067b86>] kthread+0x96/0xa0
[ 1081.505746]  [<ffffffff80400ed4>] kernel_thread_helper+0x4/0x10
[ 1081.505750] md123_raid1     D ffff88010662a6c0     0 21228      2 0x00000000
[ 1081.505754]  ffff880121365bc0 0000000000000246 ffff880133193820
ffff880121365b40
[ 1081.505759]  ffff880121364010 ffff880121365b88 ffff88010b26c300
ffff88010b26c300
[ 1081.505763]  ffff88010b26c300 ffff880121365fd8 ffff880121365fd8
ffff88010b26c300
[ 1081.505767] Call Trace:
[ 1081.505772]  [<ffffffff80314cc5>] md_super_wait+0x55/0xa0
[ 1081.505776]  [<ffffffff8032009a>] write_sb_page+0x7a/0x260
[ 1081.505781]  [<ffffffff80321415>] write_page+0x115/0x130
[ 1081.505786]  [<ffffffff80321ef6>] bitmap_daemon_work+0x506/0x640
[ 1081.505792]  [<ffffffff8031e4d8>] md_check_recovery+0x38/0x550
[ 1081.505797]  [<ffffffffa04d2307>] raid1d+0x27/0x380 [raid1]
[ 1081.505805]  [<ffffffff80315810>] md_thread+0x130/0x160
[ 1081.505810]  [<ffffffff80067b86>] kthread+0x96/0xa0
[ 1081.505815]  [<ffffffff80400ed4>] kernel_thread_helper+0x4/0x10
[ 1081.505831] md113_raid1     D ffff88010dea5dc0     0  2546      2 0x00000000
[ 1081.505835]  ffff88010942bbc0 0000000000000246 ffff880133193820
ffff88010942bb40
[ 1081.505839]  ffff88010942a010 ffff88010942bb88 ffff88010dfba080
ffff88010dfba080
[ 1081.505843]  ffff88010dfba080 ffff88010942bfd8 ffff88010942bfd8
ffff88010dfba080
[ 1081.505847] Call Trace:
[ 1081.505852]  [<ffffffff80314cc5>] md_super_wait+0x55/0xa0
[ 1081.505856]  [<ffffffff8032009a>] write_sb_page+0x7a/0x260
[ 1081.505861]  [<ffffffff80321415>] write_page+0x115/0x130
[ 1081.505866]  [<ffffffff80321ef6>] bitmap_daemon_work+0x506/0x640
[ 1081.505871]  [<ffffffff8031e4d8>] md_check_recovery+0x38/0x550
[ 1081.505877]  [<ffffffffa04d2307>] raid1d+0x27/0x380 [raid1]
[ 1081.505885]  [<ffffffff80315810>] md_thread+0x130/0x160
[ 1081.505890]  [<ffffffff80067b86>] kthread+0x96/0xa0
[ 1081.505895]  [<ffffffff80400ed4>] kernel_thread_helper+0x4/0x10
[ 1081.505919] md96_raid1      D ffff880111055cc0     0  2187      2 0x00000000
[ 1081.505923]  ffff88011509fbc0 0000000000000246 ffff88010b064b20
ffff88011509fb40
[ 1081.505927]  ffff88011509e010 ffff88011509fb88 ffff88010de38040
ffff88010de38040
[ 1081.505931]  ffff88010de38040 ffff88011509ffd8 ffff88011509ffd8
ffff88010de38040
[ 1081.505935] Call Trace:
[ 1081.505940]  [<ffffffff80314cc5>] md_super_wait+0x55/0xa0
[ 1081.505944]  [<ffffffff8032009a>] write_sb_page+0x7a/0x260
[ 1081.505949]  [<ffffffff80321415>] write_page+0x115/0x130
[ 1081.505954]  [<ffffffff80321ef6>] bitmap_daemon_work+0x506/0x640
[ 1081.505960]  [<ffffffff8031e4d8>] md_check_recovery+0x38/0x550
[ 1081.505965]  [<ffffffffa04d2307>] raid1d+0x27/0x380 [raid1]
[ 1081.505974]  [<ffffffff80315810>] md_thread+0x130/0x160
[ 1081.505978]  [<ffffffff80067b86>] kthread+0x96/0xa0
[ 1081.505983]  [<ffffffff80400ed4>] kernel_thread_helper+0x4/0x10
[ 1081.505997] multipath       D 0000000000000000     0   342  32606 0x00000000
[ 1081.506001]  ffff8801002d9ae8 0000000000000286 ffff88013ac8c260
ffff8801002d9a68
[ 1081.506005]  ffff8801002d8010 ffff8801002d9ab0 ffff88010dfb47c0
ffff88010dfb47c0
[ 1081.506009]  ffff88010dfb47c0 ffff8801002d9fd8 ffff8801002d9fd8
ffff88010dfb47c0
[ 1081.506013] Call Trace:
[ 1081.506018]  [<ffffffff803f633d>] schedule_timeout+0x21d/0x2c0
[ 1081.506023]  [<ffffffff803f5225>] wait_for_common+0xe5/0x210
[ 1081.506028]  [<ffffffff801fb998>] blk_execute_rq+0xb8/0xf0
[ 1081.506033]  [<ffffffff80200c52>] sg_io+0x1d2/0x410
[ 1081.506038]  [<ffffffff8020147c>] scsi_cmd_ioctl+0x2ac/0x470
[ 1081.506044]  [<ffffffffa04b4ab4>] sd_ioctl+0xd4/0x130 [sd_mod]
[ 1081.506051]  [<ffffffff801fdf30>] blkdev_ioctl+0x2a0/0x710
[ 1081.506057]  [<ffffffff8015efd5>] block_ioctl+0x35/0x40
[ 1081.506061]  [<ffffffff8013b303>] do_vfs_ioctl+0x93/0x3f0
[ 1081.506066]  [<ffffffff8013b701>] sys_ioctl+0xa1/0xb0
[ 1081.506070]  [<ffffffff80400533>] system_call_fastpath+0x16/0x1b
[ 1081.506078]  [<00007f6d1609bfa7>] 0x7f6d1609bfa6
[ 1081.506082] Sched Debug Version: v0.10, 3.0.42-0.7-xen #1
[ 1081.506085] ktime                                   : 1081506.081092
[ 1081.506087] sched_clk                               : 1073329.747917
[ 1081.506090] cpu_clk                                 : 1081506.081311
[ 1081.506092] jiffies                                 : 4295162673
[ 1081.506094] sched_clock_stable                      : 0

--
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
