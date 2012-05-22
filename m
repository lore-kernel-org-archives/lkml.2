Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2EVBMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2EVBL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:11:58 -0400
Date: Mon, 21 May 2012 21:11:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.4+ dcache BUG.
Message-ID: <20120522011152.GA18115@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this. Probably related to todays dcache changes ?

kernel BUG at fs/dcache.c:229!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 2 
Modules linked in: ipt_ULOG nfnetlink x25 phonet llc2 can rose af_key caif_socket caif netrom rds binfmt_misc bluetooth rfkill pppoe pppox ppp_generic slhc decnet ipx p8023 p8022 irda crc_ccitt atm appletalk psnap llc ax25 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw i2c_i801 usb_debug e1000e iTCO_wdt iTCO_vendor_support nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]

Pid: 15394, comm: cc1 Not tainted 3.4.0+ #17 
RIP: 0010:[<ffffffff811bb7ac>]  [<ffffffff811bb7ac>] d_free+0x6c/0x70
RSP: 0018:ffff88013230fe48  EFLAGS: 00010202
RAX: ffff880077134d40 RBX: ffff880111e45e10 RCX: 0000000000000000
RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffff880111e45e10
RBP: ffff88013230fe58 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880111c89c10
R13: ffff8801474139d0 R14: 0000000000000001 R15: ffff8801462bd1a0
FS:  00002b935ace1ec0(0000) GS:ffff880148000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b9361c49000 CR3: 00000001322d5000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 15394, threadinfo ffff88013230e000, task ffff880077134d40)
Stack:
 ffff8801474139d0 ffff880111e45e10 ffff88013230fe88 ffffffff811bc987
 ffff880111e45e10 ffff8801474139d0 ffff880111c89c10 ffff880111e45e70
 ffff88013230feb8 ffffffff811bcad2 ffff88007c47aec0 0000000000000010
Call Trace:
 [<ffffffff811bc987>] d_kill+0xb7/0x120
 [<ffffffff811bcad2>] dput+0xe2/0x1d0
 [<ffffffff811a6a0f>] fput+0x1cf/0x300
 [<ffffffff811a16b9>] filp_close+0x69/0xa0
 [<ffffffff811a223d>] sys_close+0xad/0x1a0
 [<ffffffff8165a612>] system_call_fastpath+0x16/0x1b
Code: 00 00 74 1b 48 c7 c6 d0 b6 1b 81 e8 6f fd f3 ff 48 83 c4 08 5b 5d c3 0f 1f 84 00 00 00 00 00 e8 2b ff ff ff 48 83 c4 08 5b 5d c3 <0f> 0b 66 90 55 48 89 e5 41 55 41 54 53 48 83 ec 28 66 66 66 66 


I'm not sure why, but the dcache.c line numbers don't match up..
This kernel was v3.3-rc7-14528-g29db10d which looked like..

 229  */
 230 static void d_free(struct dentry *dentry)
 231 {
 232         BUG_ON(dentry->d_count);
 233         this_cpu_dec(nr_dentry);


Hopefully that's close enough that that BUG_ON is the one that got hit.

	Dave


