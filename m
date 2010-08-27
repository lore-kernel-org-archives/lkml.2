Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0H0Isc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:48:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab0H0Is3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:48:29 -0400
Message-ID: <4C777C04.7080906@cn.fujitsu.com>
Date: Fri, 27 Aug 2010 16:49:08 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091121 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [Patch] ext4: avoid null dereference
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ac->inode is set to null in function ext4_mb_release_group_pa(),
and then trace_ext4_mballoc_discard(ac) is called, the kernel
will panic.

BUG: unable to handle kernel NULL pointer dereference at 000000a4
IP: [<f87e1714>] ftrace_raw_event_ext4__mballoc+0x54/0xc0 [ext4]
*pdpt = 0000000000abd001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index1/shared_cpu_map
Modules linked in: autofs4 sunrpc p4_clockmod ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod raid0 floppy e1000 sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support i6300esb sky2 e752x_edac edac_core ext4 mbcache jbd2 sd_mod crc_t10dif mptspi mptscsih mptbase scsi_transport_spi pata_acpi ata_generic ata_piix [last unloaded: mperf]

Pid: 550, comm: flush-8:16 Not tainted 2.6.36-rc1 #1 SE7320EP2/Altos G530
EIP: 0060:[<f87e1714>] EFLAGS: 00010206 CPU: 1
EIP is at ftrace_raw_event_ext4__mballoc+0x54/0xc0 [ext4]
EAX: f32ac840 EBX: f3f1cf88 ECX: f32ac840 EDX: 00000000
ESI: f32ac83c EDI: f880b9d8 EBP: 00000000 ESP: f4b77ae4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process flush-8:16 (pid: 550, ti=f4b76000 task=f613e540 task.ti=f4b76000)
Stack:
 00000286 00000000 00000286 f705ec80 f304ad90 f3f1cf88 f4b77b74 f63dc600
<0> f87f5ac1 0000000d f4b77b18 f304a490 00000000 00007df3 00000012 f3c204f8
<0> f3c20184 f3c20508 f3f1cf88 f87f8356 0000002b 95ac1b28 95ac41fc 00000001
Call Trace:
 [<f87f5ac1>] ? ext4_mb_release_group_pa+0x121/0x150 [ext4]
 [<f87f8356>] ? ext4_mb_discard_group_preallocations+0x336/0x400 [ext4]
 [<f87fb7f1>] ? ext4_mb_new_blocks+0x3d1/0x4f0 [ext4]
 [<c05a6c5b>] ? __make_request+0x10b/0x440
 [<f87f1fb4>] ? ext4_ext_map_blocks+0x1334/0x1980 [ext4]
 [<c04ac78a>] ? rb_reserve_next_event+0xaa/0x3b0
 [<f87d18d6>] ? ext4_map_blocks+0xd6/0x1d0 [ext4]
 [<f87d2da7>] ? mpage_da_map_blocks+0xc7/0x8a0 [ext4]
 [<c04c8a68>] ? find_get_pages_tag+0x38/0x110
 [<c04d23a5>] ? __pagevec_release+0x15/0x20
 [<f87d3ca5>] ? ext4_da_writepages+0x2b5/0x5d0 [ext4]
 [<c04cfbe0>] ? __writepage+0x0/0x30
 [<c04d0e34>] ? do_writepages+0x14/0x30
 [<c0526600>] ? writeback_single_inode+0xa0/0x240
 [<c0526971>] ? writeback_sb_inodes+0xc1/0x180
 [<c0526ab8>] ? writeback_inodes_wb+0x88/0x140
 [<c0526d7b>] ? wb_writeback+0x20b/0x320
 [<c045aca7>] ? lock_timer_base+0x27/0x50
 [<c0526fe0>] ? wb_do_writeback+0x150/0x190
 [<c05270a8>] ? bdi_writeback_thread+0x88/0x1f0
 [<c043b680>] ? complete+0x40/0x60
 [<c0527020>] ? bdi_writeback_thread+0x0/0x1f0
 [<c0469474>] ? kthread+0x74/0x80
 [<c0469400>] ? kthread+0x0/0x80
 [<c040a23e>] ? kernel_thread_helper+0x6/0x10
Code: e0 ff ff 8b 57 24 8b 68 14 8d 44 24 0c 89 0c 24 b9 24 00 00 00 89 6c 24 04 e8 a9 cf cc c7 85 c0 89 c6 74 47 e8 1e 8a cc c7 8b 13 <8b> 92 a4 00 00 00 89 c1 8b 52 08 89 50 0c 8b 13 8b 52 20 89 50
EIP: [<f87e1714>] ftrace_raw_event_ext4__mballoc+0x54/0xc0 [ext4] SS:ESP 0068:f4b77ae4
CR2: 00000000000000a4

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

---
 include/trace/events/ext4.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 01e9e00..6a1fcff 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -796,8 +796,9 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= ac->ac_inode->i_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
+		__entry->dev		= ac->ac_sb->s_dev;
+		__entry->ino		= ac->ac_inode ?
+						ac->ac_inode->i_ino : 0;
 		__entry->result_logical	= ac->ac_b_ex.fe_logical;
 		__entry->result_start	= ac->ac_b_ex.fe_start;
 		__entry->result_group	= ac->ac_b_ex.fe_group;
-- 
1.6.0.2.GIT



















