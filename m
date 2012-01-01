Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab2AADfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 22:35:13 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:48349 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2AADfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 22:35:11 -0500
X-Greylist: delayed 2828 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Dec 2011 22:35:10 EST
Date: Sun, 1 Jan 2012 03:47:58 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: 3.2.0-rc5 oops in ext4
Message-ID: <20120101024754.GA14376@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 3.2.0-rc5 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During relatively heavy write load, my 3.2.0-rc5 kernel oopsed (after sixteen
days of uptime, so this is not easily reproducible):

Jan  1 03:21:41 pannekake kernel: [1439120.482015] PGD 0 
Jan  1 03:21:41 pannekake kernel: [1439120.488213] CPU 4 
Jan  1 03:21:41 pannekake kernel: [1439120.490228] Modules linked in: ipt_REJECT iptable_filter ip_tables sha256_generic cryptd aes_x86_64 aes_generic af_packet microcode bridge stp llc ext4 jbd2 crc16 ext2 fuse dm_snapshot dm_crypt kvm_intel kvm coretemp w83627ehf hwmon_vid ip_gre gre sg ide_generic ide_gd_mod ide_cd_mod cdrom i2c_i801 psmouse i2c_core serio_raw pcspkr evdev ext3 jbd mbcache dm_mod raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 md_mod usbhid ide_pci_generic ide_core uhci_hcd ata_piix e1000e ehci_hcd sd_mod unix [last unloaded: scsi_wait_scan]
Jan  1 03:21:41 pannekake kernel: [1439120.543854] 
Jan  1 03:21:41 pannekake kernel: [1439120.545732] Pid: 26600, comm: apache2 Not tainted 3.2.0-rc5 #2 Supermicro X8DTL/X8DTL
Jan  1 03:21:41 pannekake kernel: [1439120.554226] RIP: 0010:[<ffffffff81355161>]  [<ffffffff81355161>] _raw_spin_lock+0x9/0x20
Jan  1 03:21:41 pannekake kernel: [1439120.562935] RSP: 0018:ffff88002a6259e8  EFLAGS: 00010202
Jan  1 03:21:41 pannekake kernel: [1439120.568660] RAX: 0000000000000100 RBX: ffffea0000bdb240 RCX: 0000000000000000
Jan  1 03:21:41 pannekake kernel: [1439120.576458] RDX: ffff880033231f70 RSI: ffff88002f6c9000 RDI: 0000000000000098
Jan  1 03:21:41 pannekake kernel: [1439120.584190] RBP: ffff88002a6259e8 R08: 0000000000000001 R09: 0000000000000001
Jan  1 03:21:41 pannekake kernel: [1439120.591952] R10: ffff880623d0fe28 R11: 0000000000000000 R12: 0000000000000000
Jan  1 03:21:41 pannekake kernel: [1439120.599697] R13: ffff880033231f70 R14: 0000000000000001 R15: 000000000003300c
Jan  1 03:21:41 pannekake kernel: [1439120.607482] FS:  00007f43323c0740(0000) GS:ffff880627280000(0000) knlGS:0000000000000000
Jan  1 03:21:41 pannekake kernel: [1439120.616190] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  1 03:21:41 pannekake kernel: [1439120.622311] CR2: 0000000000000098 CR3: 00000001289cd000 CR4: 00000000000006e0
Jan  1 03:21:41 pannekake kernel: [1439120.630095] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  1 03:21:41 pannekake kernel: [1439120.637828] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  1 03:21:41 pannekake kernel: [1439120.645558] Process apache2 (pid: 26600, threadinfo ffff88002a624000, task ffff880621254320)
Jan  1 03:21:41 pannekake kernel: [1439120.662206]  ffff88002a625a18 ffffffff8110d19e ffff8806207a8800 ffff880588804f10
Jan  1 03:21:41 pannekake kernel: [1439120.670260]  0000000000000033 ffffea0000bdb240 ffff88002a625ae8 ffffffffa030c003
Jan  1 03:21:41 pannekake kernel: [1439120.678351]  ffff88061f9c2498 ffff880588804f10 ffffea0000bdb240 0000000100001000
Jan  1 03:21:41 pannekake kernel: [1439120.689297]  [<ffffffff8110d19e>] create_empty_buffers+0x43/0xae
Jan  1 03:21:41 pannekake kernel: [1439120.695723]  [<ffffffffa030c003>] ext4_discard_partial_page_buffers_no_lock+0x9d/0x3ee [ext4]
Jan  1 03:21:41 pannekake kernel: [1439120.704817]  [<ffffffffa0308860>] ? ext4_dirty_inode+0x42/0x47 [ext4]
Jan  1 03:21:41 pannekake kernel: [1439120.711660]  [<ffffffff811081f0>] ? __mark_inode_dirty+0x2c/0x1e5
Jan  1 03:21:41 pannekake kernel: [1439120.718151]  [<ffffffffa030c60f>] ext4_da_write_end+0x231/0x2df [ext4]
Jan  1 03:21:41 pannekake kernel: [1439120.725050]  [<ffffffff810aaa25>] ? iov_iter_copy_from_user_atomic+0x6e/0xde
Jan  1 03:21:41 pannekake kernel: [1439120.732736]  [<ffffffff810aad0d>] generic_file_buffered_write+0x16a/0x251
Jan  1 03:21:41 pannekake kernel: [1439120.739931]  [<ffffffff810ac871>] __generic_file_aio_write+0x340/0x375
Jan  1 03:21:41 pannekake kernel: [1439120.746850]  [<ffffffff81353dce>] ? __mutex_lock_slowpath+0x240/0x24f
Jan  1 03:21:41 pannekake kernel: [1439120.753674]  [<ffffffff810ac907>] generic_file_aio_write+0x61/0xb6
Jan  1 03:21:41 pannekake kernel: [1439120.760275]  [<ffffffffa0304ab2>] ext4_file_write+0x1e2/0x240 [ext4]
Jan  1 03:21:41 pannekake kernel: [1439120.767004]  [<ffffffff810c86ef>] ? handle_pte_fault+0x248/0x6d8
Jan  1 03:21:41 pannekake kernel: [1439120.773379]  [<ffffffff810379d8>] ? __dequeue_entity+0x2e/0x33
Jan  1 03:21:41 pannekake kernel: [1439120.779635]  [<ffffffff810e75dd>] do_sync_write+0xc9/0x106
Jan  1 03:21:41 pannekake kernel: [1439120.785517]  [<ffffffff81156f13>] ? security_file_permission+0x1e/0x86
Jan  1 03:21:41 pannekake kernel: [1439120.792429]  [<ffffffff810e7fae>] vfs_write+0xae/0x153
Jan  1 03:21:41 pannekake kernel: [1439120.798019]  [<ffffffff810e810c>] sys_write+0x45/0x6c
Jan  1 03:21:41 pannekake kernel: [1439120.803447]  [<ffffffff8135b63b>] system_call_fastpath+0x16/0x1b
Jan  1 03:21:41 pannekake kernel: [1439120.837058]  RSP <ffff88002a6259e8>
Jan  1 03:21:41 pannekake kernel: [1439120.867912] ---[ end trace 4335ee5e6a2dc567 ]---

Rebooted, fsck-ing now. Happy new year :-)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
