Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab1JFWDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:03:42 -0400
Received: from websrv.saout.de ([78.46.99.52]:55870 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929Ab1JFWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:03:40 -0400
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 00:02:54 +0200
Message-ID: <1317938574.7593.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> > Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);
> 
> OK, it turns out my testing was incomplete.  I only tested targets that
> had a write-through cache, so I didn't hit this problem.  It reproduces
> pretty easily with just multipath involved (no linear target on top) when
> running against the right storage.
> 
> So, here's a patch, but I don't have a full explanation for it just yet.
> What I observed was that, on fsync, blkdev_issue_flush was called.
> Eventually, the flush request gets cloned, and blk_insert_cloned_request
> is called.  This cloned request never actually gets issued to the
> q->requst_fn (scsi_request_fn in my case).  So, it may be that there is
> no plug list for this, so the queue isn't goosed?  I'll try to come up
> with a better explanation, or Tejun may just know off the top of his
> head what's going on.
> 
> So, the patch works for me, but is very much just an RFC.

It does?  If I apply the patch, the system dies while booting when
scanning the volume groups:

Setting up LVM Volume GroupsBUG: unable to handle kernel NULL pointer
dereference at 0000000000000308
IP: [<ffffffff8130675b>] sd_prep_fn+0x16b/0xa70
PGD 9c96c067 PUD 9f69f067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
CPU 14 
Modules linked in: dm_round_robin dm_multipath ebtable_filter ebtables
x_tables nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
nf_nat_irc nf_conntrack_irc nf_nat_h323 nf_conntrack_h323 nf_nat_ftp
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack
xen_netback xen_blkback xen_gntdev ipmi_si ipmi_devintf ipmi_msghandler
loop tpm_tis tpm igb tpm_bios ohci_hcd e1000e pata_atiixp qla2xxx
scsi_transport_fc i2c_piix4 ehci_hcd

Pid: 2520, comm: kpartx Not tainted 3.1.0-rc8 #1 Supermicro
H8DG6/H8DGi/H8DG6/H8DGi
RIP: e030:[<ffffffff8130675b>]  [<ffffffff8130675b>] sd_prep_fn
+0x16b/0xa70
RSP: e02b:ffff88009c973918  EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff88009cea0018 RCX: 0000000000001000
RDX: 0000000000000000 RSI: ffff88009e61d440 RDI: 0000000000000000
RBP: ffff88009c973978 R08: ffff8800a0b40700 R09: 0000000000000001
R10: 0000000000000001 R11: ffff88009e61d440 R12: ffff8800a042b480
R13: 0000000000000000 R14: ffff88009ee7c000 R15: 0000000000000000
FS:  00007f7d769617a0(0000) GS:ffff8800d74cf000(0000)
knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000308 CR3: 000000009c979000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kpartx (pid: 2520, threadinfo ffff88009c972000, task
ffff88009c898000)
Stack:
 ffff88009c973928 ffffffff810ceef0 0000000000000000 ffffffff00001000
 0000000000000000 ffff8800a0b72a00 ffff88009c898000 ffff88009cea0018
 ffff8800a042b480 ffff88009cea0018 ffff88009c972000 ffff88009c973fd8
Call Trace:
 [<ffffffff810ceef0>] ? mempool_alloc_slab+0x10/0x20
 [<ffffffff81215e72>] blk_peek_request+0xd2/0x270
 [<ffffffff812f8acb>] scsi_request_fn+0x4b/0x3c0
 [<ffffffff8120fa46>] __blk_run_queue+0x16/0x20
 [<ffffffff8120ef03>] __elv_add_request+0xb3/0x270
 [<ffffffff81213494>] add_acct_request+0x34/0x40
 [<ffffffff812134fd>] blk_insert_cloned_request+0x5d/0x80
 [<ffffffff8138bff9>] dm_dispatch_request+0x39/0x70
 [<ffffffff8138db3c>] dm_request_fn+0x17c/0x280
 [<ffffffff81214f98>] queue_unplugged+0x48/0x100
 [<ffffffff81216335>] blk_flush_plug_list+0x1e5/0x230
 [<ffffffff8100b30f>] ? xen_restore_fl_direct_reloc+0x4/0x4
 [<ffffffff810ccac0>] ? sleep_on_page+0x10/0x10
 [<ffffffff814c0704>] io_schedule+0x44/0x80
 [<ffffffff810ccac9>] sleep_on_page_killable+0x9/0x40
 [<ffffffff814c0d42>] __wait_on_bit_lock+0x52/0xb0
 [<ffffffff8114b7a0>] ? I_BDEV+0x10/0x10
 [<ffffffff810cca32>] __lock_page_killable+0x62/0x70
 [<ffffffff81075330>] ? autoremove_wake_function+0x40/0x40
 [<ffffffff810ce608>] generic_file_aio_read+0x718/0x750
 [<ffffffff810053c9>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
 [<ffffffff81118142>] do_sync_read+0xd2/0x110
 [<ffffffff8114b9fc>] ? block_ioctl+0x3c/0x40
 [<ffffffff81129bd6>] ? do_vfs_ioctl+0x96/0x4f0
 [<ffffffff811188c3>] vfs_read+0xc3/0x170
 [<ffffffff811189bc>] sys_read+0x4c/0x90
 [<ffffffff814c9612>] system_call_fastpath+0x16/0x1b
Code: 4c 89 f7 48 89 55 b0 89 4d b8 e8 b1 16 ff ff 85 c0 41 89 c5 48 8b
55 b0 8b 4d b8 0f 85 00 ff ff ff 4d 85 f6 4c 8b 83 d8 00 00 00 <4c> 8b
8a 08 03 00 00 0f 84 c0 02 00 00 41 8b 86 10 06 00 00 31 
RIP  [<ffffffff8130675b>] sd_prep_fn+0x16b/0xa70
 RSP <ffff88009c973918>
CR2: 0000000000000308
---[ end trace 7def99230bac37fd ]---


	Christophe


