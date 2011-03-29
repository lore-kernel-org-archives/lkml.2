Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1C2JrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:47:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1C2JrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:47:20 -0400
Message-ID: <4D91AAB9.2000800@cn.fujitsu.com>
Date: Tue, 29 Mar 2011 17:47:37 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Bug at for-2.6.39/core
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 17:45:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 17:45:41,
	Serialize complete at 2011-03-29 17:45:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I trigger an OOPS when testing, the following script can reproduce
this bug on my box.

#!/bin/sh

mkdir /mnt/blkio
mount -t cgroup -o blkio blkio /mnt/blkio/
mkdir /mnt/blkio/test1 /mnt/blkio/test2
echo noop > /sys/block/sdb/queue/scheduler
dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
echo $! > /mnt/blkio/test1/tasks
dd iflag=direct if=/dev/sdb of=/dev/null bs=4k &
echo $! > /mnt/blkio/test2/tasks
sleep 3
echo cfq > /sys/block/sdb/queue/scheduler

----
eBUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff812200e8>] cfq_completed_request+0x38/0x7f0
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devics/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sdb/queue/scheduler
CPU 1
Modules linked in: ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 sunrpc 8021q fcoe libfcoe libfc scsi_transport_fc scsi_tgt garp stp llc cachefiles fscache xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd raid0 dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm uinput wmi sg pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support r8169 mii snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: speedstep_lib]

Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc6-block-+ #197 LENOVO QiTianM7300/To be filled by O.E.M.
RIP: 0010:[<ffffffff812200e8>]  [<ffffffff812200e8>] cfq_completed_request+0x38/0x7f0
RSP: 0018:ffff8800bba83ca0  EFLAGS: 00010046
RAX: ffffffff812200b0 RBX: ffff88012d42b640 RCX: 00000000fffde49a
RDX: 0000000002204400 RSI: ffff88012fca7a38 RDI: ffff88012d42b640
RBP: ffff8800bba83cf0 R08: 00000000fffde49a R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88012fca7a38
R13: 0000000000000000 R14: 00000000fffde49a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800bba80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000003780d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:0 (pid: 0, threadinfo ffff880136c10000, task ffff880136c0cb30)
Stack:
 0000000000000000 ffff8800bba83d08 0000000000020000 ffff88012d4bc800
 0000000000800110 ffff88012d42b640 ffff88012fca7a38 0000000000000000
 0000000000000000 0000000000000000 ffff8800bba83d00 ffffffff812060ba
Call Trace:
 <IRQ>
 [<ffffffff812060ba>] elv_completed_request+0x4a/0x50
 [<ffffffff8120d4ac>] __blk_put_request+0x3c/0xf0
 [<ffffffff8120d761>] blk_finish_request+0x201/0x280
 [<ffffffff8120dbb4>] blk_end_bidi_request+0x54/0x80
 [<ffffffff8120dc30>] blk_end_request+0x10/0x20
 [<ffffffff8132068f>] scsi_io_completion+0xaf/0x560
 [<ffffffff81318086>] scsi_finish_command+0xc6/0x130
 [<ffffffff81320ca7>] scsi_softirq_done+0x147/0x170
 [<ffffffff81212bc2>] blk_done_softirq+0x82/0xa0
 [<ffffffff810684db>] __do_softirq+0xab/0x200
 [<ffffffff810c2a11>] ? handle_IRQ_event+0xf1/0x170
 [<ffffffff8100cebc>] call_softirq+0x1c/0x30
 [<ffffffff8100e8f5>] do_softirq+0x65/0xa0
 [<ffffffff810683a5>] irq_exit+0x85/0x90
 [<ffffffff814b3eb6>] do_IRQ+0x66/0xe0
 [<ffffffff814ac7d3>] ret_from_intr+0x0/0x15



