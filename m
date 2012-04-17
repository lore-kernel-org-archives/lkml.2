Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2DQRVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2DQRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:21:50 -0400
Date: Tue, 17 Apr 2012 13:21:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120417172142.GA30237@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My syscall fuzzer started showing up some cases where it we seem to be
overrunning the stack.  I added a WARN_ON when the stack is really low,
to see if there's a deep call trace, but it's not really telling me much ..

	Dave

[ 5393.970003] trinity used greatest stack depth: 1048 bytes left
[ 5419.095374] trinity used greatest stack depth: 8 bytes left
[ 5419.095864] ------------[ cut here ]------------
[ 5419.096611] WARNING: at kernel/exit.c:892 do_exit+0xb77/0xb80()
[ 5419.097830] Hardware name: Precision WorkStation 490    
[ 5419.098908] Modules linked in: scsi_transport_iscsi ipt_ULOG dccp_ipv6 tun hidp dccp_ipv4 dccp bnep can_raw sctp binfmt_misc l2tp_ppp l2tp_netlink l2tp_core can_bcm ip_queue rfcomm cmtp kernelcapi af_802154 phonet bluetooth rfkill can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 atm appletalk ipx p8022 psnap llc p8023 nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c dm_mirror dm_region_hash dm_log coretemp raid0 ppdev dcdbas usb_debug microcode snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm serio_raw i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support tg3 snd_timer i5000_edac snd edac_core soundcore snd_page_alloc i5k_amb shpchp parport_pc parport sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[ 5419.107431] Pid: 841, comm: trinity Tainted: G        W    3.4.0-rc3+ #45
[ 5419.108688] Call Trace:
[ 5419.109803]  [<ffffffff81065a9f>] warn_slowpath_common+0x7f/0xc0
[ 5419.111023]  [<ffffffff81065afa>] warn_slowpath_null+0x1a/0x20
[ 5419.112463]  [<ffffffff8106bba7>] do_exit+0xb77/0xb80
[ 5419.113525]  [<ffffffff8106beff>] do_group_exit+0x4f/0xc0
[ 5419.114946]  [<ffffffff8107eace>] get_signal_to_deliver+0x20e/0x880
[ 5419.116063]  [<ffffffff8107bda0>] ? __send_signal+0x150/0x7f0
[ 5419.117469]  [<ffffffff8108b820>] ? task_tgid_nr_ns+0x20/0x20
[ 5419.118805]  [<ffffffff8101b315>] do_signal+0x65/0x5d0
[ 5419.120161]  [<ffffffff816aed01>] ? _raw_spin_unlock_irq+0x41/0x70
[ 5419.121662]  [<ffffffff8107f312>] ? set_current_blocked+0x52/0x60
[ 5419.122583]  [<ffffffff813360de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5419.123994]  [<ffffffff816aed01>] ? _raw_spin_unlock_irq+0x41/0x70
[ 5419.125064]  [<ffffffff8101b905>] do_notify_resume+0x65/0x80
[ 5419.126505]  [<ffffffff813360de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5419.127668]  [<ffffffff816b74e2>] int_signal+0x12/0x17
[ 5419.129118] ---[ end trace bed9ff07ecc14c9d ]---
[ 5419.143061] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[ 5419.143712] IP: [<ffffffff8106b230>] do_exit+0x200/0xb80
[ 5419.144004] PGD 202d44067 PUD 201876067 PMD 0 
[ 5419.144004] Thread overran stack, or stack corrupted
[ 5419.144004] Oops: 0000 [#1] PREEMPT SMP 
[ 5419.144004] CPU 0 
[ 5419.144004] Modules linked in: scsi_transport_iscsi ipt_ULOG dccp_ipv6 tun hidp dccp_ipv4 dccp bnep can_raw sctp binfmt_misc l2tp_ppp l2tp_netlink l2tp_core can_bcm ip_queue rfcomm cmtp kernelcapi af_802154 phonet bluetooth rfkill can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 atm appletalk ipx p8022 psnap llc p8023 nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c dm_mirror dm_region_hash dm_log coretemp raid0 ppdev dcdbas usb_debug microcode snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm serio_raw i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support tg3 snd_timer i5000_edac snd edac_core soundcore snd_page_alloc i5k_amb shpchp parport_pc parport sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[ 5419.144004] 
[ 5419.144004] Pid: 841, comm: trinity Tainted: G        W    3.4.0-rc3+ #45 Dell Inc.                 Precision WorkStation 490    /0DT031
[ 5419.144004] RIP: 0010:[<ffffffff8106b230>]  [<ffffffff8106b230>] do_exit+0x200/0xb80
[ 5419.144004] RSP: 0018:ffff88006f2dfcc8  EFLAGS: 00010246
[ 5419.144004] RAX: 0000000000000000 RBX: ffff880028820000 RCX: 0000000000000030
[ 5419.144004] RDX: 0000000000000030 RSI: 0000000000000001 RDI: 0000000000000000
[ 5419.144004] RBP: ffff88006f2dfd48 R08: 0000000000000000 R09: 0000000000000001
[ 5419.144004] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
[ 5419.144004] R13: 00007ffffffff000 R14: 0000000000000349 R15: ffff880028820000
[ 5419.144004] FS:  00007f8742d4f700(0000) GS:ffff880236600000(0000) knlGS:0000000000000000
[ 5419.144004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5419.144004] CR2: 0000000000000048 CR3: 00000001090fd000 CR4: 00000000000007f0
[ 5419.144004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5419.144004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5419.144004] Process trinity (pid: 841, threadinfo ffff88006f2de000, task ffff880028820000)
[ 5419.144004] Stack:
[ 5419.144004]  0000000000000000 0000000128820000 0000000000000000 00007fff00000000
[ 5419.144004]  dead4ead00000000 ffffffffffffffff ffffffffffffffff ffffffff829bce50
[ 5419.144004]  0000000000000000 0000000000000000 ffffffff819c7001 0000000000000086
[ 5419.144004] Call Trace:
[ 5419.144004]  [<ffffffff8106beff>] do_group_exit+0x4f/0xc0
[ 5419.144004]  [<ffffffff8107eace>] get_signal_to_deliver+0x20e/0x880
[ 5419.144004]  [<ffffffff8107bda0>] ? __send_signal+0x150/0x7f0
[ 5419.144004]  [<ffffffff8108b820>] ? task_tgid_nr_ns+0x20/0x20
[ 5419.144004]  [<ffffffff8101b315>] do_signal+0x65/0x5d0
[ 5419.144004]  [<ffffffff816aed01>] ? _raw_spin_unlock_irq+0x41/0x70
[ 5419.144004]  [<ffffffff8107f312>] ? set_current_blocked+0x52/0x60
[ 5419.144004]  [<ffffffff813360de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5419.144004]  [<ffffffff816aed01>] ? _raw_spin_unlock_irq+0x41/0x70
[ 5419.194777]  [<ffffffff8101b905>] do_notify_resume+0x65/0x80
[ 5419.194777]  [<ffffffff813360de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5419.194777]  [<ffffffff816b74e2>] int_signal+0x12/0x17
[ 5419.194777] Code: df e8 55 74 0e 00 be 01 00 00 00 48 89 df e8 d8 3e 08 00 44 8b 55 8c 45 85 d2 0f 85 49 05 00 00 48 8b 43 08 49 89 df 48 8b 40 08 <48> 8b 78 48 e8 37 37 07 00 48 89 df e8 7f fd 3a 00 48 89 df e8 
[ 5419.194777] RIP  [<ffffffff8106b230>] do_exit+0x200/0xb80
[ 5419.194777]  RSP <ffff88006f2dfcc8>
[ 5419.194777] CR2: 0000000000000048

