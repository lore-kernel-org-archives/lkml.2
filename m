Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0JASHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:07:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41836 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0JASHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:07:04 -0400
Date: Fri, 1 Oct 2010 19:07:02 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: overlayfs: BUG in ovl_whiteout
Message-ID: <20101001180702.GD2832@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been playing with overlayfs for a bit now and there seems to
be something a little dodgy when unmounting and remounting an overlay.
I modified some files in the overlay, immediatly unmounted the overlay and
again immediatly remounted it.  On touching the same files in the overlay
I triggered the following BUG (dmesg fragment at the bottom of this email).
When trying to reproduce this I also triggered a hard hang.

This is the specific BUG in my source:

    static int ovl_whiteout(struct dentry *upperdir, struct dentry *dentry)
    {
    [...]
        /* Just been removed within the same locked region */
        BUG_ON(newdentry->d_inode);
    [...]
    }

All of this is against the V3 patches.

-apw

[ 3828.863867] ------------[ cut here ]------------
[ 3828.863898] kernel BUG at /home/apw/build/maverick/ubuntu-natty/fs/overlayfs/overlayfs.c:1441!
[ 3828.863940] invalid opcode: 0000 [#1] SMP 
[ 3828.863965] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.6/local_cpus
[ 3828.863998] CPU 1 
[ 3828.864010] Modules linked in: overlayfs binfmt_misc ppdev kvm_intel kvm i915 drm_kms_helper snd_hda_codec_idt drm snd_hda_intel i2c_algo_bit snd_hda_codec video snd_hwdep tpm_tis tpm coretemp snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event output snd_seq tpm_bios intel_agp snd_timer lp snd_seq_device parport snd soundcore snd_page_alloc hid_belkin usbhid hid ahci e1000e libahci
[ 3828.864254] 
[ 3828.864266] Pid: 18395, comm: apt-get Not tainted 2.6.36-0-generic #1~overlayfs201010011723 BB Name To be filled by O.E.M./Product Name To Be Filled By O.E.M.
[ 3828.864330] RIP: 0010:[<ffffffffa02ca173>]  [<ffffffffa02ca173>] ovl_whiteout+0x113/0x120 [overlayfs]
[ 3828.864379] RSP: 0018:ffff8800670e1c28  EFLAGS: 00010282
[ 3828.864405] RAX: ffff8800263f3600 RBX: ffff88006711ec00 RCX: 0000000000000000
[ 3828.864439] RDX: ffff8800263f3600 RSI: ffff88006aefe4c2 RDI: ffff8800263f3608
[ 3828.864472] RBP: ffff8800670e1c58 R08: 0000000000000650 R09: ffff8800765d7e80
[ 3828.864506] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800263f3600
[ 3828.864539] R13: ffff88006e097240 R14: ffff880063881780 R15: 00000000fffffff4
[ 3828.864573] FS:  0000000000000000(0000) GS:ffff880001e80000(0063) knlGS:00000000f73d26d0
[ 3828.864612] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[ 3828.864639] CR2: 00000000f770e4c0 CR3: 000000007808d000 CR4: 00000000000406e0
[ 3828.864673] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3828.864706] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3828.864740] Process apt-get (pid: 18395, threadinfo ffff8800670e0000, task ffff88006f4f2dc0)
[ 3828.864779] Stack:
[ 3828.864790]  ffff8800670e1c58 ffff8800263bba80 ffff8800263bba80 0000000000000000
[ 3828.864832] <0> ffff8800263f3600 ffff880063881780 ffff8800670e1cf8 ffffffffa02cbbe9
[ 3828.864877] <0> ffff8800670e1d08 0000000000000001 ffff880063881701 ffff8800263f3600
[ 3828.864924] Call Trace:
[ 3828.864940]  [<ffffffffa02cbbe9>] ovl_rename+0x319/0x3d0 [overlayfs]
[ 3828.864976]  [<ffffffff8126af5f>] ? security_inode_permission+0x1f/0x30
[ 3828.865009]  [<ffffffff81163db9>] ? dentry_permission+0x99/0xc0
[ 3828.865038]  [<ffffffff81163a4b>] vfs_rename_other+0xcb/0x130
[ 3828.865067]  [<ffffffff81164fdb>] vfs_rename+0x14b/0x240
[ 3828.865094]  [<ffffffff81163555>] ? __lookup_hash+0x55/0xe0
[ 3828.865121]  [<ffffffff8126af5f>] ? security_inode_permission+0x1f/0x30
[ 3828.865154]  [<ffffffff81166d04>] sys_renameat+0x254/0x280
[ 3828.865184]  [<ffffffff8159615e>] ? _raw_spin_lock+0xe/0x20
[ 3828.865212]  [<ffffffff812c3bcd>] ? _atomic_dec_and_lock+0x4d/0x80
[ 3828.865243]  [<ffffffff8159615e>] ? _raw_spin_lock+0xe/0x20
[ 3828.865271]  [<ffffffff81157993>] ? sys_fchmodat+0x73/0x110
[ 3828.865300]  [<ffffffff81048173>] ? sys32_stat64+0x33/0x40
[ 3828.865328]  [<ffffffff81166d4b>] sys_rename+0x1b/0x20
[ 3828.865354]  [<ffffffff81047230>] sysenter_dispatch+0x7/0x2e
[ 3828.865382] Code: eb d4 eb 04 90 90 90 90 48 8b 35 a1 2a 00 00 45 31 c0 b9 01 00 00 00 48 c7 c2 25 ce 2c a0 4c 89 e7 e8 92 fa ea e0 41 89 c7 eb 91 <0f> 0b eb fe 41 89 c7 eb 90 eb 02 90 90 55 48 89 e5 48 83 ec 20 
[ 3828.865610] RIP  [<ffffffffa02ca173>] ovl_whiteout+0x113/0x120 [overlayfs]
[ 3828.866873]  RSP <ffff8800670e1c28>
[ 3828.889817] ---[ end trace ae40f79401a99f83 ]---

