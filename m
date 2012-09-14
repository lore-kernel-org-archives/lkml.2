Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2INLe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:34:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58352 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2INLeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:34:17 -0400
Message-ID: <50531629.9020107@ahsoftware.de>
Date: Fri, 14 Sep 2012 13:34:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm currently experiencing some major problems trying to do a full 
backup. I've recently added an USB 3.0 card to my system and now it 
seems my full-backup routine evolved to a stress test. ;)

What I'm doing is either

tar cp . | mbuffer | bzip2smp >foo.tar.bz2

or

dd if=/dev/sdaN bs=4M | mbuffer | bzip2smp >foo.img.bz2

bzip2smp spawns 7 threads on this machine (an intel Core i7 860 @ 
2.80GHz) with HT enabled, which really seems to stress the HW (I get 
various throttling events).

Source is an SSD, target an USB 3.0 disk.

Besides a problem with USB 3.0 which just manifest in those 4 message:
-----
Sep 14 13:00:36 krabat kernel: [15189.243914] usb 2-2: reset SuperSpeed 
USB device number 2 using xhci_hcd
Sep 14 13:00:36 krabat kernel: [15189.259625] usb 2-2: Parent hub 
missing LPM exit latency info.  Power management will be impacted.
Sep 14 13:00:36 krabat kernel: [15189.259800] xhci_hcd 0000:02:00.0: 
xHCI xhci_drop_endpoint called with disabled ep ffff880215ad4380
Sep 14 13:00:36 krabat kernel: [15189.259806] xhci_hcd 0000:02:00.0: 
xHCI xhci_drop_endpoint called with disabled ep ffff880215ad43c0
-----

at least one (visible) bug occured:


-----
Sep 13 00:14:34 krabat kernel: [14450.085735] ------------[ cut here 
]------------
Sep 13 00:14:34 krabat kernel: [14450.085740] kernel BUG at 
fs/buffer.c:3205!
Sep 13 00:14:34 krabat kernel: [14450.085741] invalid opcode: 0000 [#1] SMP
Sep 13 00:14:34 krabat kernel: [14450.085743] CPU 0
Sep 13 00:14:34 krabat kernel: [14450.085743] Modules linked in: 
nls_iso8859_1 nls_cp850 vfat fat rfcomm fuse hidp ipt_MASQUERADE 
xt_CHECKSUM iptable_mangle iptable_nat nf_nat binfmt_misc sunrpc bridge 
stp llc it87 hwmon_vid ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
ip6table_filter ip6_tables xt_physdev ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter btusb bluetooth 
rfkill joydev usbhid usb_storage uas loop snd_hda_codec_hdmi 
snd_hda_codec_realtek coretemp crc32c_intel uhci_hcd snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm i7core_edac 
fglrx(PO) ehci_hcd edac_core xhci_hcd microcode sg snd_timer lpc_ich 
r8169 snd mfd_core mii usbcore soundcore usb_common snd_page_alloc 
virtio_blk virtio_balloon virtio_pci virtio_net virtio virtio_ring 
kvm_intel kvm ipv6 [last unloaded: scsi_wait_scan]
Sep 13 00:14:34 krabat kernel: [14450.085775]
Sep 13 00:14:34 krabat kernel: [14450.085777] Pid: 438, comm: kswapd0 
Tainted: P           O 3.5.3-00010-g0fc1af2 #220 Gigabyte Technology 
Co., Ltd. P55M-UD4/P55M-UD4
Sep 13 00:14:34 krabat kernel: [14450.085779] RIP: 
0010:[<ffffffff8111eb6e>]  [<ffffffff8111eb6e>] free_buffer_head+0x2e/0x30
Sep 13 00:14:34 krabat kernel: [14450.085785] RSP: 0018:ffff880216b4fb50 
  EFLAGS: 00010287
Sep 13 00:14:34 krabat kernel: [14450.085786] RAX: ffff8800949b7c78 RBX: 
ffff8800949b7bc8 RCX: 000000018027001d
Sep 13 00:14:34 krabat kernel: [14450.085787] RDX: 000000018027001e RSI: 
0000000000000001 RDI: ffff8800949b7c30
Sep 13 00:14:34 krabat kernel: [14450.085788] RBP: ffff88020480c520 R08: 
0000000000000000 R09: ffffffff8111eb5d
Sep 13 00:14:34 krabat kernel: [14450.085789] R10: ffffffff81856780 R11: 
000000000000007d R12: 0000000000000001
Sep 13 00:14:34 krabat kernel: [14450.085790] R13: 0000000000000001 R14: 
ffffea000020e880 R15: ffff880216b4fd18
Sep 13 00:14:34 krabat kernel: [14450.085791] FS: 
0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
Sep 13 00:14:34 krabat kernel: [14450.085793] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Sep 13 00:14:34 krabat kernel: [14450.085794] CR2: 00000000006d9504 CR3: 
0000000103659000 CR4: 00000000000007f0
Sep 13 00:14:34 krabat kernel: [14450.085795] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 13 00:14:34 krabat kernel: [14450.085796] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep 13 00:14:34 krabat kernel: [14450.085797] Process kswapd0 (pid: 438, 
threadinfo ffff880216b4e000, task ffff8802169112c0)
Sep 13 00:14:34 krabat kernel: [14450.085797] Stack:
Sep 13 00:14:34 krabat kernel: [14450.085798]  0000000000000001 
ffffffff8111ebec ffffea000020e900 ffff8800949b7d68
Sep 13 00:14:34 krabat kernel: [14450.085800]  ffffea00026f5240 
ffffea000020e8c0 ffff88020480c520 ffffffff810e851b
Sep 13 00:14:34 krabat kernel: [14450.085802]  0000000000000000 
ffff880200000000 000000000002ec2d 000000000002ec2d
Sep 13 00:14:34 krabat kernel: [14450.085804] Call Trace:
Sep 13 00:14:34 krabat kernel: [14450.085807]  [<ffffffff8111ebec>] ? 
try_to_free_buffers+0x7c/0xc0
Sep 13 00:14:34 krabat kernel: [14450.085810]  [<ffffffff810e851b>] ? 
move_to_new_page+0x20b/0x260
Sep 13 00:14:34 krabat kernel: [14450.085812]  [<ffffffff810e8ad7>] ? 
migrate_pages+0x407/0x4d0
Sep 13 00:14:34 krabat kernel: [14450.085814]  [<ffffffff810c79b0>] ? 
isolate_freepages_block+0x100/0x100
Sep 13 00:14:34 krabat kernel: [14450.085816]  [<ffffffff810c858c>] ? 
compact_zone+0x1ec/0x2f0
Sep 13 00:14:34 krabat kernel: [14450.085818]  [<ffffffff810c87cb>] ? 
__compact_pgdat+0x13b/0x180
Sep 13 00:14:34 krabat kernel: [14450.085820]  [<ffffffff810c89c7>] ? 
compact_pgdat+0x27/0x30
Sep 13 00:14:34 krabat kernel: [14450.085822]  [<ffffffff810bdd2d>] ? 
balance_pgdat+0x66d/0x6b0
Sep 13 00:14:34 krabat kernel: [14450.085824]  [<ffffffff810bdeed>] ? 
kswapd+0x17d/0x2e0
Sep 13 00:14:34 krabat kernel: [14450.085827]  [<ffffffff8104f280>] ? 
abort_exclusive_wait+0xb0/0xb0
Sep 13 00:14:34 krabat kernel: [14450.085829]  [<ffffffff810bdd70>] ? 
balance_pgdat+0x6b0/0x6b0
Sep 13 00:14:34 krabat kernel: [14450.085830]  [<ffffffff8104eb05>] ? 
kthread+0x85/0x90
Sep 13 00:14:34 krabat kernel: [14450.085834]  [<ffffffff8140cc94>] ? 
kernel_thread_helper+0x4/0x10
Sep 13 00:14:34 krabat kernel: [14450.085836]  [<ffffffff8104ea80>] ? 
kthread_freezable_should_stop+0x60/0x60
Sep 13 00:14:34 krabat kernel: [14450.085838]  [<ffffffff8140cc90>] ? 
gs_change+0xb/0xb
Sep 13 00:14:34 krabat kernel: [14450.085838] Code: 48 48 83 ec 08 48 39 
47 48 75 20 48 89 fe 48 8b 3d 58 d0 73 00 e8 d3 69 fc ff 65 ff 0c 25 a0 
e3 00 00 48 83 c4 08 e9 d2 fe ff ff <0f> 0b 41 54 55 53 48 89 fb 48 83 
ec 10 48 c7 44 24 08 00 00 00
Sep 13 00:14:34 krabat kernel: [14450.085857] RIP  [<ffffffff8111eb6e>] 
free_buffer_head+0x2e/0x30
Sep 13 00:14:34 krabat kernel: [14450.085859]  RSP <ffff880216b4fb50>
Sep 13 00:14:34 krabat kernel: [14450.085861] ---[ end trace 
515ca81189df54b2 ]---
-----
(that tainted is through fglrx)

I haven't looked at the source in the kernel and because I'm not 
familiar with the involved code, I thought I just paste that error here 
before trying if I can find the problem myself.

I had that error more than once, so it looks like I can reproduce it. If 
I can help more with logs or similiar, just ask.

Regards,

Alexander
