Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1FHLPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:15:31 -0400
Received: from mars.netasq.com ([91.212.116.3]:37379 "EHLO work.netasq.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752180Ab1FHLP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:15:29 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jun 2011 07:15:28 EDT
Date: Wed, 8 Jun 2011 13:07:55 +0200
From: Clement LECIGNE <clement.lecigne@netasq.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] hfs_find_init() sb->ext_tree NULL pointer dereference
Message-ID: <20110608110731.GA69446@clem1.netasq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

hfs_find_init() is wrongly assuming that sb->ext_tree has already been opened
and is not NULL but this function can be called when sb->ext_tree is currently
being opened (NULL deref).

Indeed when we have the following call path, the NULL deref. occurs:

In hfs_mdb_get() we have (at this stage ext_tree == NULL):

 HFS_SB(sb)->ext_tree = hfs_btree_open(sb, HFS_EXT_CNID, hfs_ext_keycmp);

hfs_btree_open() is calling read_mapping_page() which is indirectly a call
to hfs_readpage(). Then hfs_readpage() can make the following calls:

 hfs_readpage() -> hfs_get_block() -> alloc_buffer_head() -> hfs_ext_read_extent()

Then hfs_ext_read_extent() calls hfs_find_init() with an ext_tree == NULL. Then
we have a NULL dereference in hfs_find_init().

 ptr = kmalloc(tree->max_key_len (...));

Due to the huge call stack from hfs_btree_open() to hfs_find_init() there
are many ways to fix this dereference but I can't find the proper way to
fix it.

Moreover if we look at the code in hfs_find_init().

 20        ptr = kmalloc(tree->max_key_len * 2 + 4, GFP_KERNEL);
 21        if (!ptr)
 22                return -ENOMEM;
 23        fd->search_key = ptr;
 24        fd->key = ptr + tree->max_key_len + 2;

We can make "max_key_len * 2 + 4" wrap and have an fd->key pointing outside of
the kmalloc()'ed space. Moreover we can make space in fd->search_key lower
than max_key_len and bad things can occur.

Here are the Oops for the NULL dereference. If you are interested I can
provide you a fake image device (mount -o loop) which triggers this
dereference.

[  435.802462] BUG: unable to handle kernel NULL pointer dereference at 00000034
[  435.803563] IP: [<d9fff69f>] hfs_find_init+0x10/0x45 [hfs]
[  435.804037] *pde = 00000000
[  435.804037] Oops: 0000 [#1] SMP
[  435.804037] last sysfs file: /sys/module/nls_base/initstate
[  435.804037] Modules linked in: hfs dlm configfs fuse loop
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer parport_pc snd
parport psmouse soundcore i2c_piix4 joydev i2c_core ac battery button
pcspkr evdev serio_raw snd_page_alloc vboxguest ext3 jbd mbcache
dm_mod btrfs zlib_deflate crc32c libcrc32c sg usbhid hid sr_mod sd_mod
crc_t10dif cdrom ata_generic ata_piix ohci_hcd ahci thermal libata
ehci_hcd thermal_sys scsi_mod e1000 usbcore nls_base [last unloaded:
scsi_wait_scan]
[  435.804037]
[  435.804037] Pid: 1321, comm: mount Not tainted (2.6.32-5-686 #1) VirtualBox
[  435.804037] EIP: 0060:[<d9fff69f>] EFLAGS: 00010202 CPU: 0
[  435.804037] EIP is at hfs_find_init+0x10/0x45 [hfs]
[  435.804037] EAX: 00000000 EBX: d6e05c64 ECX: 00000000 EDX: d6e05c64
[  435.804037] ESI: 00000000 EDI: 00000004 EBP: d6226088 ESP: d6e05c58
[  435.804037]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  435.804037] Process mount (pid: 1321, ti=d6e04000 task=d6135100
task.ti=d6e04000)
[  435.804037] Stack:
[  435.804037]  00000004 00000000 da002466 00000001 00000246 00000000
00000000 c10cd056
[  435.804037] <0> 00000040 00000000 d76a7ac0 00000000 00000004
d6226000 d6226040 00000004
[  435.804037] <0> da002af5 d66a8480 c1767820 d6226088 d5d34e00
0000003f 00000000 00000004
[  435.804037] Call Trace:
[  435.804037]  [<da002466>] ? hfs_ext_read_extent+0x42/0x61 [hfs]
[  435.804037]  [<c10cd056>] ? alloc_buffer_head+0xd/0x34
[  435.804037]  [<da002af5>] ? hfs_get_block+0xc9/0x1cc [hfs]
[  435.804037]  [<c10cfdd8>] ? block_read_full_page+0x15a/0x26e
[  435.804037]  [<da002a2c>] ? hfs_get_block+0x0/0x1cc [hfs]
[  435.804037]  [<c1087b89>] ? do_read_cache_page+0x7e/0xf8
[  435.804037]  [<da002da8>] ? hfs_readpage+0x0/0xc [hfs]
[  435.804037]  [<c1087c30>] ? read_cache_page_async+0x14/0x18
[  435.804037]  [<c1087c3d>] ? read_cache_page+0x9/0xf
[  435.804037]  [<da0012b8>] ? hfs_btree_open+0x169/0x291 [hfs]
[  435.804037]  [<da002226>] ? hfs_ext_keycmp+0x0/0x45 [hfs]
[  435.804037]  [<da004437>] ? hfs_mdb_get+0x530/0x625 [hfs]
[  435.804037]  [<c10c0d5b>] ? __d_lookup+0x9e/0xd3
[  435.804037]  [<da004f1a>] ? hfs_fill_super+0x460/0x47d [hfs]
[  435.804037]  [<c10c4e5b>] ? mntput_no_expire+0x17/0xb6
[  435.804037]  [<c113a1f0>] ? string+0x33/0x81
[  435.804037]  [<c113acae>] ? vsnprintf+0x194/0x372
[  435.804037]  [<c11b4b33>] ? kobj_lookup+0x132/0x161
[  435.804037]  [<c113aeee>] ? snprintf+0x16/0x18
[  435.804037]  [<c10ee022>] ? disk_name+0x1f/0x5b
[  435.804037]  [<c10b52af>] ? get_sb_bdev+0x11d/0x16f
[  435.804037]  [<da004aba>] ? hfs_fill_super+0x0/0x47d [hfs]
[  435.804037]  [<c10c5830>] ? alloc_vfsmnt+0x7b/0x106
[  435.804037]  [<da0048d1>] ? hfs_get_sb+0x12/0x16 [hfs]
[  435.804037]  [<da004aba>] ? hfs_fill_super+0x0/0x47d [hfs]
[  435.804037]  [<c10b4f5d>] ? vfs_kern_mount+0x85/0x11c
[  435.804037]  [<c10b5032>] ? do_kern_mount+0x2f/0xb8
[  435.804037]  [<c10c6380>] ? do_mount+0x64a/0x69e
[  435.804037]  [<c113b8d3>] ? copy_from_user+0x27/0x10e
[  435.804037]  [<c10c643a>] ? sys_mount+0x66/0x98
[  435.804037]  [<c10031dc>] ? syscall_call+0x7/0xb
[  435.804037] Code: 43 04 e8 00 f0 0a e7 8b 43 08 83 c0 3c e8 1f 7e
04 e7 c7 43 08 00 00 00 00 5b c3 56 89 c6 53 89 d3 89 43 08 c7 42 0c
00 00 00 00 <8b> 40 34 ba d0 00 00 00 8d 44 00 04 e8 45 f5 0a e7 89 c2
b8 f4
[  435.804037] EIP: [<d9fff69f>] hfs_find_init+0x10/0x45 [hfs] SS:ESP
0068:d6e05c58
[  435.804037] CR2: 0000000000000034

Best regards,

-- 
Clément LECIGNE,
"FreeBSD is ancien beardedland word meaning, I can't implement ASLR."
