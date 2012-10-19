Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2JSOn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab2JSOnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:43:55 -0400
Date: Fri, 19 Oct 2012 10:43:51 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: weird use-after-free bug in module_put
Message-ID: <20121019144351.GA1532@redhat.com>
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

I've hit this twice in the last two days while fuzz testing.
(Both times on i686 only, my x86-64 tests aren't hitting it
 for some reason).

BUG: unable to handle kernel paging request at 6b6b6ce3
IP: [<c10b52fe>] module_put+0x1e/0x160
*pdpt = 0000000025a4b001 *pde = 0000000000000000 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: fuse tun binfmt_misc nfnetlink nfc caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 ip6table_filter ip6_tables nf_defrag_ipv4 xt_state nf_conntrack kvm_intel kvm microcode serio_raw pcspkr i2c_i801 tg3 i2c_core shpchp raid0 ata_piix
Pid: 512, comm: acpid Not tainted 3.7.0-rc1+ #11 Dell Inc.                 Precision WorkStation 490    /0DT031
EIP: 0060:[<c10b52fe>] EFLAGS: 00010246 CPU: 1
EIP is at module_put+0x1e/0x160
EAX: 00000000 EBX: 6b6b6b6b ECX: 00000000 EDX: c118509c
ESI: 00000010 EDI: 6b6b6b6b EBP: e5ae9f44 ESP: e5ae9f34
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 6b6b6ce3 CR3: 25a4a000 CR4: 000007f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process acpid (pid: 512, ti=e5ae8000 task=e6311680 task.ti=e5ae8000)
Stack:
 e6062140 6b6b6b6b 00000010 f01ce540 e5ae9f50 c118509c e6062140 e5ae9f80
 c11821ed 00000001 00000000 00000000 f2073410 ef256814 ef256814 e6062148
 00000000 e6311a60 e6311680 e5ae9f88 c118226d e5ae9f9c c1062f19 00000002
Call Trace:
 [<c118509c>] cdev_put+0x1c/0x20
 [<c11821ed>] __fput+0x20d/0x280
 [<c118226d>] ____fput+0xd/0x10
 [<c1062f19>] task_work_run+0x89/0xb0
 [<c1002c41>] do_notify_resume+0x61/0xa0
 [<c15d32f0>] work_notifysig+0x29/0x31
Code: 51 00 eb df 89 f6 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 04 66 66 66 66 90 85 c0 89 c7 74 44 b8 01 00 00 00 e8 c2 14 52 00 <8b> 87 78 01 00 00 64 ff 40 04 8b 45 04 89 45 f0 66 66 66 66 90


It looks like the chardev went away under our feet.
How can this happen ?

	Dave
