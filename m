Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1FWCBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:01:32 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39917 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1FWCB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:01:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jgarzik@pobox.com>,
        Peter Zijlstra <peterz@infradead.org>,
        IngIngo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: mmotm 2011-06-22 - inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
In-Reply-To: Your message of "Wed, 22 Jun 2011 13:05:19 PDT."
             <201106222042.p5MKgiEe025352@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201106222042.p5MKgiEe025352@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308794391_4530P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jun 2011 21:59:51 -0400
Message-ID: <6189.1308794391@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E029E1D.00DD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308794391_4530P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Jun 2011 13:05:19 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2011-06-22-13-05 has been uploaded to

Nothing obvious to cause it, and I didn't see it in -rc3-mmotm0615, so I'll toss this at
Andrew and everybody mentioned in MAINTAINERS for SATA, IRQs, and Lockdep and
see if anybody has a brilliant idea.

Quite probably relevant - kernel was booted with 'threadirqs', but that's been in
there since 39-rc7 and I haven't seen this before.

Threw an amazing traceback on boot while trying to fsck the / filesystem on a
LUKS-encrypted LVM partition:

[    3.828296] dracut: luksOpen /dev/sda2 luks-715ceabf-6f58-4251-9373-ed29e8629a7c
[   18.127342] dracut: Scanning devices dm-0  for LVM volume groups 
[   18.164842] dracut: Reading all physical volumes. This may take a while...
[   18.164995] dracut: Found volume group "vg_blackice" using metadata type lvm2
[   18.557728] blkid used greatest stack depth: 3904 bytes left
[   20.095210] dracut: 12 logical volume(s) in volume group "vg_blackice" now active
[   20.174640] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   20.233169] dracut: Checking filesystems
[   20.233210] dracut: fsck -T -t noopts=_netdev -A -a
[   20.253331] 
[   20.253500] =================================
[   20.253803] [ INFO: inconsistent lock state ]
[   20.254107] 3.0.0-rc4-mmotm0622 #1
[   20.254275] ---------------------------------
[   20.254275] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   20.254275] irq/45-ahci/47 [HC0[0]:SC1[1]:HE0:SE0] takes:
[   20.254275]  (&(&mapping->tree_lock)->rlock){+.?...}, at: [<ffffffff810c031a>] test_clear_page_writeback+0x39/0xd3
[   20.254275] {SOFTIRQ-ON-W} state was registered at:
[   20.254275]   [<ffffffff8106973b>] mark_irqflags+0xf2/0x13e
[   20.254275]   [<ffffffff810699b2>] __lock_acquire+0x22b/0x3e2
[   20.254275]   [<ffffffff8106a09f>] lock_acquire+0x103/0x153
[   20.254275]   [<ffffffff8157bb01>] _raw_spin_lock+0x36/0x45
[   20.254275]   [<ffffffff8110ddf8>] end_writeback+0x33/0x103
[   20.254275]   [<ffffffff81125425>] bdev_evict_inode+0x3e/0xbe
[   20.254275]   [<ffffffff8110df78>] evict+0xb0/0x173
[   20.254275]   [<ffffffff8110e1ea>] iput_final+0x171/0x17a
[   20.254275]   [<ffffffff8110e241>] iput+0x4e/0x53
[   20.254275]   [<ffffffff81125cad>] __blkdev_put+0x1c0/0x1eb
[   20.254275]   [<ffffffff81125ebe>] blkdev_put+0x1e6/0x1f5
[   20.254275]   [<ffffffff8121d143>] register_disk+0xea/0x13c
[   20.254275]   [<ffffffff8121d2c4>] add_disk+0x12f/0x1a4
[   20.254275]   [<ffffffff812ef339>] sd_probe_async+0x115/0x1b5
[   20.254275]   [<ffffffff8105ce2f>] async_run_entry_fn+0x99/0x12a
[   20.254275]   [<ffffffff810505e8>] process_one_work+0x25d/0x467
[   20.254275]   [<ffffffff81051ddb>] worker_thread+0x152/0x206
[   20.254275]   [<ffffffff810561fa>] kthread+0x7f/0x87
[   20.254275]   [<ffffffff815835d4>] kernel_thread_helper+0x4/0x10
[   20.254275] irq event stamp: 115999
[   20.254275] hardirqs last  enabled at (115998): [<ffffffff81562e60>] end_buffer_async_write.part.14+0x117/0x154
[   20.254275] hardirqs last disabled at (115999): [<ffffffff8157bbd0>] _raw_spin_lock_irqsave+0x1a/0x57
[   20.254275] softirqs last  enabled at (115966): [<ffffffff8108d689>] irq_forced_thread_fn+0x35/0x40
[   20.254275] softirqs last disabled at (115967): [<ffffffff815836cc>] call_softirq+0x1c/0x30
[   20.254275] 
[   20.254275] other info that might help us debug this:
[   20.254275]  Possible unsafe locking scenario:
[   20.254275] 
[   20.254275]        CPU0
[   20.254275]        ----
[   20.254275]   lock(&(&mapping->tree_lock)->rlock);
[   20.254275]   <Interrupt>
[   20.254275]     lock(&(&mapping->tree_lock)->rlock);
[   20.254275] 
[   20.254275]  *** DEADLOCK ***
[   20.254275] 
[   20.254275] no locks held by irq/45-ahci/47.
[   20.254275] 
[   20.254275] stack backtrace:
[   20.254275] Pid: 47, comm: irq/45-ahci Not tainted 3.0.0-rc4-mmotm0622 #1
[   20.254275] Call Trace:
[   20.254275]  <IRQ>  [<ffffffff8155c50e>] print_usage_bug+0x1f5/0x206
[   20.254275]  [<ffffffff81068837>] ? print_irq_inversion_bug.part.15+0x1ae/0x1ae
[   20.254275]  [<ffffffff8155c58e>] mark_lock_irq+0x6f/0x120
[   20.254275]  [<ffffffff810695d6>] mark_lock+0xaf/0x122
[   20.254275]  [<ffffffff810696cb>] mark_irqflags+0x82/0x13e
[   20.254275]  [<ffffffff810699b2>] __lock_acquire+0x22b/0x3e2
[   20.254275]  [<ffffffff810c031a>] ? test_clear_page_writeback+0x39/0xd3
[   20.254275]  [<ffffffff8106a09f>] lock_acquire+0x103/0x153
[   20.254275]  [<ffffffff810c031a>] ? test_clear_page_writeback+0x39/0xd3
[   20.254275]  [<ffffffff8157bbfa>] _raw_spin_lock_irqsave+0x44/0x57
[   20.254275]  [<ffffffff810c031a>] ? test_clear_page_writeback+0x39/0xd3
[   20.254275]  [<ffffffff81027b66>] ? __wake_up+0x1d/0x48
[   20.254275]  [<ffffffff810c031a>] test_clear_page_writeback+0x39/0xd3
[   20.254275]  [<ffffffff810b7ae1>] end_page_writeback+0x2a/0x4c
[   20.254275]  [<ffffffff81562e6b>] end_buffer_async_write.part.14+0x122/0x154
[   20.254275]  [<ffffffff8106a55d>] ? trace_hardirqs_on_caller+0xfd/0x13b
[   20.254275]  [<ffffffff811209c4>] end_buffer_async_write+0x3e/0x47
[   20.254275]  [<ffffffff8111f595>] end_bio_bh_io_sync+0x53/0x63
[   20.254275]  [<ffffffff8111f542>] ? invalidate_inode_buffers+0x5c/0x5c
[   20.254275]  [<ffffffff81122d87>] bio_endio+0x28/0x2a
[   20.254275]  [<ffffffff8139e56c>] dec_pending+0x190/0x1b2
[   20.254275]  [<ffffffff8139e631>] clone_endio+0xa3/0xb0
[   20.254275]  [<ffffffff81122d87>] bio_endio+0x28/0x2a
[   20.254275]  [<ffffffff8139e56c>] dec_pending+0x190/0x1b2
[   20.254275]  [<ffffffff8139e631>] clone_endio+0xa3/0xb0
[   20.254275]  [<ffffffff81122d87>] bio_endio+0x28/0x2a
[   20.254275]  [<ffffffff813a6163>] crypt_dec_pending+0x75/0xa1
[   20.254275]  [<ffffffff813a705f>] crypt_endio+0xba/0xc9
[   20.254275]  [<ffffffff8121263a>] ? rcu_read_lock+0x35/0x35
[   20.254275]  [<ffffffff81122d87>] bio_endio+0x28/0x2a
[   20.254275]  [<ffffffff8121281e>] req_bio_endio+0xc1/0xcd
[   20.254275]  [<ffffffff8121461a>] blk_update_request+0x15e/0x389
[   20.254275]  [<ffffffff81214865>] blk_update_bidi_request+0x20/0x90
[   20.254275]  [<ffffffff81214a39>] blk_end_bidi_request+0x1a/0x58
[   20.254275]  [<ffffffff81214af3>] blk_end_request+0xb/0xd
[   20.254275]  [<ffffffff812e644a>] scsi_io_completion+0x1cc/0x4c7
[   20.254275]  [<ffffffff812df07e>] scsi_finish_command+0xab/0xb4
[   20.254275]  [<ffffffff812e61d6>] scsi_softirq_done+0xed/0xf6
[   20.254275]  [<ffffffff81219c34>] blk_done_softirq+0x6c/0x80
[   20.254275]  [<ffffffff8103e699>] __do_softirq+0x110/0x278
[   20.254275]  [<ffffffff8108d654>] ? irq_thread_fn+0x37/0x37
[   20.254275]  [<ffffffff815836cc>] call_softirq+0x1c/0x30
[   20.254275]  <EOI>  [<ffffffff810031eb>] ? do_softirq+0x44/0xf1
[   20.254275]  [<ffffffff8103e25a>] _local_bh_enable_ip+0x12a/0x178
[   20.254275]  [<ffffffff8103e2c0>] local_bh_enable+0xd/0xf
[   20.254275]  [<ffffffff8108d689>] irq_forced_thread_fn+0x35/0x40
[   20.254275]  [<ffffffff8108d54a>] irq_thread+0xf6/0x1c9
[   20.254275]  [<ffffffff8108d454>] ? irq_finalize_oneshot+0xc9/0xc9
[   20.254275]  [<ffffffff810561fa>] kthread+0x7f/0x87
[   20.254275]  [<ffffffff815835d4>] kernel_thread_helper+0x4/0x10
[   20.254275]  [<ffffffff8157c884>] ? retint_restore_args+0xe/0xe
[   20.254275]  [<ffffffff8105617b>] ? __init_kthread_worker+0x55/0x55
[   20.254275]  [<ffffffff815835d0>] ? gs_change+0xb/0xb
[   20.820457] dracut: /dev/mapper/vg_blackice-root: clean, 18016/65536 files, 181204/262144 blocks
[   20.862866] dracut: Remounting /dev/mapper/vg_blackice-root with -o ro,quota,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0
[   20.886535] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: quota,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0
[   20.927228] dracut: Mounted root filesystem /dev/mapper/vg_blackice-root
[   21.147364] dracut: Switching root


--==_Exmh_1308794391_4530P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOAp4XcC3lWbTT17ARAgWFAKCRZq9rBC3NoZdG5s2ygLNvX0brZgCgt3J6
oUh34jW5xrAfg/uxyonFZcY=
=/c4E
-----END PGP SIGNATURE-----

--==_Exmh_1308794391_4530P--

