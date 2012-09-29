Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2I2THv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 15:07:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50795 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab2I2THt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 15:07:49 -0400
Message-ID: <506746EF.5070000@ahsoftware.de>
Date: Sat, 29 Sep 2012 21:07:27 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de> <20120927200342.GB12553@quack.suse.cz>
In-Reply-To: <20120927200342.GB12553@quack.suse.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 22:03, schrieb Jan Kara:
> On Thu 27-09-12 17:46:48, Alexander Holler wrote:
>> Hello,
>>
>> Am 27.09.2012 17:12, schrieb Jan Kara:
>>>    Just some thoughts about your oops:
>>> The assertion which fails is:
>>> BUG_ON(!list_empty(&bh->b_assoc_buffers));
>>>
>>> Now b_assoc_buffers isn't used very much. In particular ext4 which you seem
>>> to be using doesn't use this list at all (except when mounted in nojournal
>>> mode but that doesn't seem to be your case). That would point rather
>>> strongly at a memory corruption issue.
>>>
>>> So if you can reproduce the oops, it might be interesting to print
>>> bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is found
>>> to be non-empty.
>>
>> Hmm, a loose pointer would explain it all too. Especially the cases
>> when I just have seen wrong content in the archive without having
>> any oops. I try to reproduce it with
>>
>> pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
>> &bh->b_assoc_buffers.next);
>> after the BUG_ON().
>    It should have been:
> 	if (!list_empty(&bh->b_assoc_buffers))
> 		pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
> 			&bh->b_assoc_buffers.next);
>    *before* BUG_ON().
>
>    What you saw in the logs were just pointers showing the list is empty
> (naturally as otherwise we'd see the BUG_ON trigger).

Yes, I've already wondered what you want to read in the output. ;)

Btw. I've just had that bug while doing sha1sum /dev/sr0, where sr0 is a 
dvd-writer attached to a sata-port. No USB involved. Before the sha1sum 
I did an mbuffer < /dev/sr0 | bzip2smp >foo.iso.bz2. But that needed 
only a few minutes (8GB) and I haven't had any throttle events or 
similiar, so Idon't think the cpu (or whatever) got hot.

---------
Sep 29 20:38:20 krabat kernel: [ 1652.879952] ------------[ cut here 
]------------
Sep 29 20:38:20 krabat kernel: [ 1652.879956] kernel BUG at 
fs/buffer.c:3199!
Sep 29 20:38:20 krabat kernel: [ 1652.879957] invalid opcode: 0000 [#1] SMP
Sep 29 20:38:20 krabat kernel: [ 1652.879959] CPU 2
Sep 29 20:38:20 krabat kernel: [ 1652.879960] Modules linked in: nfs 
rfcomm fuse hidp ebtable_nat ebtables ipt_MASQUERADE xt_CHECKSUM 
iptable_mangle iptable_nat nf_nat bridge stp llc it87 hwmon_vid 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 
xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
nf_conntrack iptable_filter btusb bluetooth rfkill joydev hid_logitech 
ff_memless usbhid pata_jmicron binfmt_misc usb_storage uas virtio_blk 
virtio_net virtio_balloon virtio_pci virtio_ring virtio vhost_net tun 
macvtap macvlan snd_hda_codec_hdmi snd_hda_codec_realtek coretemp 
kvm_intel snd_hda_intel snd_hda_codec kvm snd_hwdep uhci_hcd uinput 
snd_seq crc32c_intel snd_seq_device sr_mod snd_pcm xhci_hcd cdrom 
i7core_edac microcode ehci_hcd snd_page_alloc dm_mod edac_core fglrx(PO) 
r8169 snd_timer lpc_ich mii snd jmicron mfd_core soundcore agpgart 
usbcore usb_common nfsd nfs_acl auth_rpcgss lockd sunrpc ipv6 [last 
unloaded: scsi_wait_scan]
Sep 29 20:38:20 krabat kernel: [ 1652.879992]
Sep 29 20:38:20 krabat kernel: [ 1652.879993] Pid: 4670, comm: sha1sum 
Tainted: P           O 3.5.4-00009-gfa43f23-dirty #228 Gigabyte 
Technology Co., Ltd. P55M-UD4/P55M-UD4
Sep 29 20:38:20 krabat kernel: [ 1652.879995] RIP: 
0010:[<ffffffff8111f84d>]  [<ffffffff8111f84d>] free_buffer_head+0x4d/0x50
Sep 29 20:38:20 krabat kernel: [ 1652.880000] RSP: 0018:ffff880087ca3d80 
  EFLAGS: 00010287
Sep 29 20:38:20 krabat kernel: [ 1652.880001] RAX: ffff8800949b7c78 RBX: 
ffff8800949b7c30 RCX: 0000000000000000
Sep 29 20:38:20 krabat kernel: [ 1652.880002] RDX: 0000000000000000 RSI: 
0000000000001000 RDI: ffff8800949b7c30
Sep 29 20:38:20 krabat kernel: [ 1652.880003] RBP: ffff88020d44c220 R08: 
6010000000000000 R09: 00949b7c30080000
Sep 29 20:38:20 krabat kernel: [ 1652.880004] R10: ff4d64a8f6d70c02 R11: 
0000000000000210 R12: 0000000000000001
Sep 29 20:38:20 krabat kernel: [ 1652.880004] R13: ffff88020d44c220 R14: 
0000000000000000 R15: 000000000011a33d
Sep 29 20:38:20 krabat kernel: [ 1652.880006] FS: 
00007f88516c0740(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
Sep 29 20:38:20 krabat kernel: [ 1652.880006] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Sep 29 20:38:20 krabat kernel: [ 1652.880007] CR2: 00007f0d0bc67000 CR3: 
000000008767d000 CR4: 00000000000007e0
Sep 29 20:38:20 krabat kernel: [ 1652.880008] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 29 20:38:20 krabat kernel: [ 1652.880009] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep 29 20:38:20 krabat kernel: [ 1652.880010] Process sha1sum (pid: 
4670, threadinfo ffff880087ca2000, task ffff8802160d44c0)
Sep 29 20:38:20 krabat kernel: [ 1652.880010] Stack:
Sep 29 20:38:20 krabat kernel: [ 1652.880011]  ffffffff8111f8c1 
ffff88020d44c220 ffff8800949b7c30 ffffea000020ec40
Sep 29 20:38:20 krabat kernel: [ 1652.880013]  ffff88020d44c220 
ffffffffffffffff ffffffff810ba74d ffffea000020ec00
Sep 29 20:38:20 krabat kernel: [ 1652.880014]  ffffea000020ec40 
0000000000000002 ffffffff810ba866 ffff880215af9800
Sep 29 20:38:20 krabat kernel: [ 1652.880016] Call Trace:
Sep 29 20:38:20 krabat kernel: [ 1652.880018]  [<ffffffff8111f8c1>] ? 
try_to_free_buffers+0x71/0xc0
Sep 29 20:38:20 krabat kernel: [ 1652.880021]  [<ffffffff810ba74d>] ? 
truncate_inode_page+0x8d/0xa0
Sep 29 20:38:20 krabat kernel: [ 1652.880023]  [<ffffffff810ba866>] ? 
truncate_inode_pages_range+0x106/0x390
Sep 29 20:38:20 krabat kernel: [ 1652.880025]  [<ffffffff81125249>] ? 
__blkdev_put+0x69/0x1c0
Sep 29 20:38:20 krabat kernel: [ 1652.880027]  [<ffffffff81206f8c>] ? 
disk_flush_events+0x6c/0x70
Sep 29 20:38:20 krabat kernel: [ 1652.880030]  [<ffffffff810f6128>] ? 
fput+0xe8/0x280
Sep 29 20:38:20 krabat kernel: [ 1652.880032]  [<ffffffff810f2842>] ? 
filp_close+0x52/0x90
Sep 29 20:38:20 krabat kernel: [ 1652.880033]  [<ffffffff810f28f4>] ? 
sys_close+0x74/0xc0
Sep 29 20:38:20 krabat kernel: [ 1652.880036]  [<ffffffff8140b562>] ? 
system_call_fastpath+0x16/0x1b
Sep 29 20:38:20 krabat kernel: [ 1652.880036] Code: 65 ff 0c 25 a0 e3 00 
00 65 0f c1 04 25 a4 e3 00 00 3d ff 0f 00 00 7e 0e 48 83 c4 08 e9 1d ec 
ff ff 0f 1f 44 00 00 48 83 c4 08 c3 <0f> 0b 90 41 54 55 53 48 89 fb 48 
83 ec 10 48 c7 44 24 08 00 00
Sep 29 20:38:20 krabat kernel: [ 1652.880052] RIP  [<ffffffff8111f84d>] 
free_buffer_head+0x4d/0x50
Sep 29 20:38:20 krabat kernel: [ 1652.880054]  RSP <ffff880087ca3d80>
Sep 29 20:38:20 krabat kernel: [ 1652.880056] ---[ end trace 
41c0c1ec8ac02267 ]---
---------

Problem is, I haven't had the (corrected) pr_info() in the kernel. Will 
do that now and will check out (tomorrow or such, maybe already with 
3.5.5) if I can get that bug again.

Regards,

Alexander

