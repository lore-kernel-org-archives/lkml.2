Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1JHMF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 08:05:56 -0400
Received: from websrv.saout.de ([78.46.99.52]:54004 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1JHMFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 08:05:53 -0400
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Shaohua Li <shli@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Oct 2011 14:05:05 +0200
Message-ID: <1318075505.4933.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

> >> Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);
> >
> > OK, it turns out my testing was incomplete.  I only tested targets that
> > had a write-through cache, so I didn't hit this problem.  It reproduces
> > pretty easily with just multipath involved (no linear target on top) when
> > running against the right storage.
> >
> > So, here's a patch, but I don't have a full explanation for it just yet.
> > What I observed was that, on fsync, blkdev_issue_flush was called.
> > Eventually, the flush request gets cloned, and blk_insert_cloned_request
> > is called.  This cloned request never actually gets issued to the
> > q->requst_fn (scsi_request_fn in my case).  So, it may be that there is
> > no plug list for this, so the queue isn't goosed?  I'll try to come up
> > with a better explanation, or Tejun may just know off the top of his
> > head what's going on.
> >
> > So, the patch works for me, but is very much just an RFC.
> [...]
> Looks the dm request based flush logic is broken.
> 
> saved_make_request_fn
>   __make_request
>     blk_insert_flush
> but blk_insert_flush doesn't put the original request to list, instead, the
> q->flush_rq is in list.
> then
> dm_request_fn
>   blk_peek_request
>     dm_prep_fn
>       clone_rq
>   map_request
>     blk_insert_cloned_request
> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flush_rq
> and use it to do flush. map_request even could assign a different blockdev to
> the cloned request.
> 
> Clone q->flush_rq is absolutely wrong. we can clear ogirinal request's flush bit
> and set cloned request flush bit, so we can skip the blk_insert_flush logic for
> original request.
> 
> can you please try this patch. Only compilation tested.

Now I get a different BUG when doing what triggered the original BUG
(e.g. unmounting the filesystem):

------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1152!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 7 
Modules linked in: xenfs gfs2 fuse dlm configfs dummy bonding xt_TPROXY nf_tproxy_core xt_socket xt_owner xt_connmark iptable_mangle ipt_MASQUERADE iptable_nat ipt_ULOG ipt_REJECT xt_mark iptable_filter iptable_raw ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state xt_tcpudp xt_physdev xt_hashlimit xt_multiport ip6table_filter ip6_tables ebt_redirect ebt_ip ebt_mark_m ebtable_broute bridge stp llc ebtable_nat ext4 jbd2 dm_round_robin dm_multipath ebtable_filter ebtables x_tables nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_h323 nf_conntrack_h323 nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack xen_netback xen_blkback xen_gntdev ipmi_si ipmi_devintf ipmi_msghandler loop ohci_hcd ehci_hcd e1000e tpm_tis igb qla2xxx tpm tpm_bios scsi_transport_fc pata_atiixp i2c_piix4

Pid: 5056, comm: kworker/7:2 Not tainted 3.1.0-rc8 #1 Supermicro H8DG6/H8DGi/H8DG6/H8DGi
RIP: e030:[<ffffffff812f7eae>]  [<ffffffff812f7eae>] scsi_setup_fs_cmnd+0x9e/0xe0
RSP: e02b:ffff88009b299b70  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88009b9cc018 RCX: 0000000000000000
RDX: ffff88009f193c00 RSI: ffff88009b9cc018 RDI: ffff88009b905800
RBP: ffff88009b299b80 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: ffff8800a0e40700 R12: ffff88009b905800
R13: 0000000000000001 R14: ffff88009b905800 R15: 0000000000000000
FS:  00007fc76ab77700(0000) GS:ffff8800d767f000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fc76a1d0beb CR3: 0000000001805000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/7:2 (pid: 5056, threadinfo ffff88009b298000, task ffff88009ed68000)
Stack:
 ffff88009b9cc018 ffff88009e5f1a60 ffff88009b299bf0 ffffffff8130675f
 ffff88009b299ba0 ffffffff810ceef0 ffff88009f193c00 ffffffff00000000
 ffffffff8100ab6d ffff88009b299c60 ffff88009ed68000 ffff88009b9cc018
Call Trace:
 [<ffffffff8130675f>] sd_prep_fn+0x14f/0xa70
 [<ffffffff810ceef0>] ? mempool_alloc_slab+0x10/0x20
 [<ffffffff8100ab6d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffff81215db2>] blk_peek_request+0xd2/0x270
 [<ffffffff812f8aeb>] scsi_request_fn+0x4b/0x3c0
 [<ffffffff8120fa46>] __blk_run_queue+0x16/0x20
 [<ffffffff8120ef03>] __elv_add_request+0xb3/0x270
 [<ffffffff81213494>] add_acct_request+0x34/0x40
 [<ffffffff8121350b>] blk_insert_cloned_request+0x6b/0x90
 [<ffffffff8138c049>] dm_dispatch_request+0x39/0x70
 [<ffffffff8138db9c>] dm_request_fn+0x17c/0x280
 [<ffffffff8100b322>] ? check_events+0x12/0x20
 [<ffffffff81222db0>] ? cfq_init_queue+0x430/0x430
 [<ffffffff8120fa46>] __blk_run_queue+0x16/0x20
 [<ffffffff81222de4>] cfq_kick_queue+0x34/0x50
 [<ffffffff8106e039>] process_one_work+0x129/0x4a0
 [<ffffffff81070401>] worker_thread+0x161/0x340
 [<ffffffff810702a0>] ? manage_workers.clone.22+0x230/0x230
 [<ffffffff81074d36>] kthread+0x96/0xa0
 [<ffffffff814cb7b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814c9873>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff814c2dc0>] ? retint_restore_args+0x5/0x6
 [<ffffffff814cb7b0>] ? gs_change+0x13/0x13
Code: ff 5b 41 5c c9 c3 0f 1f 80 00 00 00 00 4c 89 e7 be 20 00 00 00 e8 a3 a2 ff ff 48 85 c0 48 89 c7 74 36 48 89 83 e0 00 00 00 eb 9b <0f> 0b 48 8b 00 48 85 c0 0f 84 77 ff ff ff 48 8b 40 50 48 85 c0 
RIP  [<ffffffff812f7eae>] scsi_setup_fs_cmnd+0x9e/0xe0
 RSP <ffff88009b299b70>
---[ end trace 35f29bc1fdb897a6 ]---
note: kworker/7:2[5056] exited with preempt_count 1

(followed by an oops and the machine is dead in an instant)

	Christophe


