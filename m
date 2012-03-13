Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2CMA7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617Ab2CMA7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:59:01 -0400
Date: Mon, 12 Mar 2012 20:58:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [3.3-rc7] sys_poll use after free (hibernate)
Message-ID: <20120313005855.GA24639@redhat.com>
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

While trying to reproduce the i915 memory corruption problem with hibernate,
I've hit the following use-after-free quite a few times, by running my
syscall fuzzer and hibernating/resuming in a loop.

oops below on 3.3rc7, but same problem also affects 3.2.9, and probably
many versions before that.

	Dave

general protection fault: 0000 [#1] PREEMPT SMP 
CPU 3 
Modules linked in: binfmt_misc cmtp kernelcapi hidp can_bcm sctp dccp_ipv6 dccp_ipv4 dccp af_802154 phonet bluetooth rfkill can pppo
e pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 atm appletalk ipx p8022 psnap llc p8023 nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
xt_state nf_conntrack ip6table_filter ip6_tables btrfs dm_mirror dm_region_hash dm_log zlib_deflate libcrc32c snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq sunrpc ppd
ev snd_seq_device snd_pcm tg3 iTCO_wdt parport_pc microcode snd_timer snd raid0 i5000_edac iTCO_vendor_support dcdbas parport soundcore usb_debug shpchp pcspkr serio_raw floppy edac_co
re snd_page_alloc i2c_i801 i5k_amb firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]

Pid: 18277, comm: trinity Not tainted 3.3.0-rc7+ #11 Dell Inc.                 Precision WorkStation 490    /0DT031
RIP: 0010:[<ffffffff81233e3e>]  [<ffffffff81233e3e>] proc_sys_poll+0x4e/0x90
RSP: 0018:ffff880207167b08  EFLAGS: 00010246
RAX: 0000000000000145 RBX: ffff88020cab6940 RCX: 0000000000000000
RDX: ffffffff81233df0 RSI: 6b6b6b6b6b6b6b6b RDI: ffff88020cab6940
RBP: ffff880207167b28 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802085fd510
R13: 0000000000000000 R14: ffff8802098c63e4 R15: 0000000000000000
FS:  00007fa1a4f70700(0000) GS:ffff880236c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000021d8928 CR3: 000000012dff9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity (pid: 18277, threadinfo ffff880207166000, task ffff880233300000)
Stack:
 000000000000002a ffff8802098c5dfc 000000000000002a ffff88020cab6940
 ffff880207167f38 ffffffff811d4360 00000000021d7a10 ffffc900000000e1
 00000000021d7920 ffff880233300000 0000000000000000 ffff880207167b88
Call Trace:
 [<ffffffff811d4360>] do_sys_poll+0x280/0x500
 [<ffffffff811d2e20>] ? poll_freewait+0xe0/0xe0
 [<ffffffff81179c9a>] ? do_wp_page+0x1da/0x720
 [<ffffffff810a09a1>] ? get_parent_ip+0x11/0x50
 [<ffffffff816a1bad>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8169d8e5>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff81179dc8>] ? do_wp_page+0x308/0x720
 [<ffffffff81333e74>] ? debug_object_activate+0x84/0x1a0
 [<ffffffff8117b92d>] ? handle_pte_fault+0x27d/0xa10
 [<ffffffff811b1d71>] ? mem_cgroup_count_vm_event+0x31/0x1a0
 [<ffffffff816a1bad>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff811d46bb>] sys_poll+0x6b/0x100
 [<ffffffff816a5ae9>] system_call_fastpath+0x16/0x1b
Code: 00 48 89 fb 48 89 f1 48 8b 40 30 4c 8b 60 e8 b8 45 01 00 00 49 83 7c 24 28 00 74 2e 49 8b 74 24 30 48 85 f6 74 24 48 85 c9 75 32 <8b> 16 b8 45 01 00 00 48 63 d2 49 39 d5 74 10 8b 06 48 98 48 89 

