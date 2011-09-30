Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1I3P6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:58:09 -0400
Received: from websrv.saout.de ([78.46.99.52]:46520 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab1I3P6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:58:07 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Sep 2011 11:58:06 EDT
Subject: Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 17:51:57 +0200
Message-ID: <1317397918.27140.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Today I was trying to boot a new 3.1 RC kernel on one of our server
machines and ran into a weird block-related crash.

Whenever I was trying to access some filesystem on the external RAID, I
would soon run into the crash seen below, followed by a total lockup a
bit later.

The external RAID is accessed via multipath and simple logical volumes
(both device-mapper) on top. The local hard disks work just fine (LVM on
top of an Areca hardware RAID).

The bug seems to be introduced between rc2 and rc3. Up to rc2 everything
is fine, and rc3 and also the latest kernel shows this bug. From the git
log I can see that the block/ directory has seen some larger update, but
this is just a wild guess.

The crash has been seen with ext3 and GFS2, apparently when processing
write requests (writing files or on umount). All kinds of crashes are
identical up to generic_make_request.

(oh, and this machine runs as Dom0 under XEN, but I can reproduce the 
 issue when booting natively too, so that's unrelated)

I think you guys should know - maybe you have an idea or have something
for me to test.  I would have tried to file a bug somewhere, but half of
the infrastructure is down at the moment.

Thanks a lot,

	Christophe


Sep 30 10:05:26 vserv80 kernel: CPU 2 
Sep 30 10:05:26 vserv80 kernel: Modules linked in: xenfs gfs2 fuse dlm configfs dummy bonding xt_TPROXY nf_tproxy_core xt_socket xt_owner xt_connmark iptable_mangle ipt_MASQUERADE iptable_nat ipt_ULOG ipt_REJECT xt_mark iptable_filter iptable_raw ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state xt_tcpudp xt_physdev xt_hashlimit xt_multiport ip6table_filter ip6_tables ebt_redirect ebt_ip ebt_mark_m ebtable_broute bridge stp llc ebtable_nat ext4 jbd2 dm_round_robin dm_multipath ebtable_filter ebtables x_tables nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_h323 nf_conntrack_h323 nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack xen_netback xen_blkback xen_gntdev ipmi_si ipmi_devintf ipmi_msghandler loop e1000e ohci_hcd tpm_tis tpm ehci_hcd qla2xxx pata_atiixp tpm_bios igb i2c_piix4 scsi_transport_fc
Sep 30 10:05:26 vserv80 kernel:
Sep 30 10:05:26 vserv80 kernel: Pid: 27551, comm: umount Not tainted 3.1.0-rc3 #1 Supermicro H8DG6/H8DGi/H8DG6/H8DGi
Sep 30 10:05:26 vserv80 kernel: RIP: e030:[<ffffffff8121a2e4>]  [<ffffffff8121a2e4>] blk_insert_flush+0x134/0x140
Sep 30 10:05:26 vserv80 kernel: RSP: e02b:ffff880098c89988  EFLAGS: 00010046
Sep 30 10:05:26 vserv80 kernel: RAX: 0000000000000000 RBX: ffff880098e4c018 RCX: ffff88009a158698
Sep 30 10:05:26 vserv80 kernel: RDX: 0000000000000005 RSI: 0000000000000001 RDI: ffff880098e4c018
Sep 30 10:05:26 vserv80 kernel: RBP: ffff880098c89988 R08: 0000000000000001 R09: 0000000000000001
Sep 30 10:05:26 vserv80 kernel: R10: ffff8800a0e44080 R11: 0000000000000000 R12: ffff88009a158698
Sep 30 10:05:26 vserv80 kernel: R13: 00000000ffff00fb R14: 0000000000000005 R15: ffff88009ed37c44
Sep 30 10:05:26 vserv80 kernel: FS:  00007faaaf8e6740(0000) GS:ffff8800d75f8000(0000) knlGS:0000000000000000
Sep 30 10:05:26 vserv80 kernel: CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 30 10:05:26 vserv80 kernel: CR2: 00007faaaf01f0b0 CR3: 000000009aa99000 CR4: 0000000000000660
Sep 30 10:05:26 vserv80 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep 30 10:05:26 vserv80 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 30 10:05:26 vserv80 kernel: Process umount (pid: 27551, threadinfo ffff880098c88000, task ffff8800924a8000)
Sep 30 10:05:26 vserv80 kernel: ffff880098c899b8 ffffffff812110a2 ffff880098e4c018 ffff88009a158698
Sep 30 10:05:26 vserv80 kernel: 00000000ffff00fb ffff88009ed37c00 ffff880098c899e8 ffffffff81215bd4
Sep 30 10:05:26 vserv80 kernel: ffff880098c899e8 ffff880000000005 ffff880098e4c018 ffff88009a158698
Sep 30 10:05:26 vserv80 kernel: [<ffffffff812110a2>] __elv_add_request+0x172/0x240
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81215bd4>] add_acct_request+0x34/0x40
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81215c4b>] blk_insert_cloned_request+0x6b/0x90
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8138ec39>] dm_dispatch_request+0x39/0x70
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8139011b>] dm_request_fn+0x1ab/0x2b0
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81211a56>] __blk_run_queue+0x16/0x20
Sep 30 10:05:26 vserv80 kernel: [<ffffffff812182ed>] __make_request+0x2ed/0x330
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8138fd3e>] dm_request+0x16e/0x1e0
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81216077>] generic_make_request+0x2d7/0x520
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8104be91>] ? get_parent_ip+0x11/0x50
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81216321>] submit_bio+0x61/0xd0
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81146c86>] submit_bh+0xe6/0x120
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa034c338>] log_write_header+0x208/0x4b0 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffff814c85c5>] ? sub_preempt_count+0x95/0xd0
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa034c698>] gfs2_log_shutdown+0xb8/0x280 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa0362908>] gfs2_make_fs_ro+0x78/0xc0 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa03628e9>] ? gfs2_make_fs_ro+0x59/0xc0 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa0362b38>] gfs2_put_super+0x1e8/0x210 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8111c64d>] generic_shutdown_super+0x5d/0xe0
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8111c6fc>] kill_block_super+0x2c/0x80
Sep 30 10:05:26 vserv80 kernel: [<ffffffffa035465c>] gfs2_kill_sb+0x5c/0x90 [gfs2]
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8111ca08>] deactivate_locked_super+0x38/0x90
Sep 30 10:05:26 vserv80 kernel: [<ffffffff8111d4e5>] deactivate_super+0x45/0x60
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81137a77>] mntput_no_expire+0xe7/0x130
Sep 30 10:05:26 vserv80 kernel: [<ffffffff81138489>] sys_umount+0x79/0x390
Sep 30 10:05:26 vserv80 kernel: [<ffffffff814cbed2>] system_call_fastpath+0x16/0x1b
Sep 30 10:05:26 vserv80 kernel: RSP <ffff880098c89988>
Sep 30 10:05:26 vserv80 kernel: ---[ end trace 906f3285f4cc5ae9 ]---
Sep 30 10:05:26 vserv80 kernel: note: umount[27551] exited with preempt_count 1

Message from syslogd@vserv80 at Sep 30 17:37:08 ...
 kernel:------------[ cut here ]------------

Message from syslogd@vserv80 at Sep 30 17:37:08 ...
 kernel:invalid opcode: 0000 [#1] PREEMPT SMP 

Message from syslogd@vserv80 at Sep 30 17:37:08 ...
 kernel:Stack:

Message from syslogd@vserv80 at Sep 30 17:37:08 ...
 kernel:Call Trace:

Message from syslogd@vserv80 at Sep 30 17:37:08 ...
 kernel:Code: d2 e8 31 c6 ff ff c9 c3 0f 1f 80 00 00 00 00 48 8b 41 08 48 89 79 08 48 89 0f 48 89 47 08 48 89 38 48 89 cf e8 2e d8 ff ff c9 c3 <0f> 0b eb fe 0f 1f 84 00 00 00 00 00 55 89 f2 be 02 00 00 00 48 

(half of the stuff ended up on the console and no in the logfile, dunno why)

