Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2JWTur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab2JWTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:50:45 -0400
Date: Tue, 23 Oct 2012 15:50:26 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: MAX_LOCKDEP_ENTRIES too low
Message-ID: <20121023195026.GA2872@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20121018015312.GA29865@redhat.com>
 <507F9944.50505@kernel.dk>
 <20121019052136.GA30852@redhat.com>
 <1350650972.30157.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350650972.30157.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 02:49:32PM +0200, Peter Zijlstra wrote:

 > > Not sure why this suddenly got a lot worse in 3.7 
 > 
 > Did we add a static array of structures with locks in somewhere? Doing
 > that is a great way of blowing up the number of lock classes and the
 > resulting amount of lock dependency chains.

So I hit it again, but didn't see anything that I hadn't seen already
in /proc/lockdep.  I so tried doubling MAX_LOCKDEP_ENTRIES again.

A while later, I got this oops. I'm unsure now if this is a genuine bug,
or a side-effect of lockdep not working with such a large MAX_LOCKDEP_ENTRIES

opinions ?


BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
PGD 8e72c067 PUD 34f07067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: fuse nfnetlink ipt_ULOG binfmt_misc nfc caif_socket caif phonet can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel kvm usb_debug crc32c_intel ghash_clmulni_intel microcode pcspkr i2c_i801 e1000e uinput i915 video i2c_algo_bit drm_kms_helper drm i2c_core
CPU 7 
Pid: 27513, comm: trinity-child0 Not tainted 3.7.0-rc2+ #43 Intel Corporation 2012 Client Platform/Emerald Lake 2
RIP: 0010:[<ffffffff810e185e>]  [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
RSP: 0018:ffff8800803f7b28  EFLAGS: 00010046
RAX: 0000000000000086 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
RBP: ffff8800803f7c18 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 2222222222222222 R12: 0000000000000002
R13: ffff880051dd8000 R14: 0000000000000002 R15: 0000000000000018
FS:  00007f9fc6ccb740(0000) GS:ffff880148a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000008e6fb000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child0 (pid: 27513, threadinfo ffff8800803f6000, task ffff880051dd8000)
Stack:
 ffff8800803f7b48 ffffffff816c5c59 ffff8800803f7b48 ffff88014840ebc0
 ffff8800803f7b68 ffffffff816c18e3 ffff8800803f7d10 0000000000000001
 ffff8800803f7ba8 ffffffff810a1e62 ffff8800803f7d10 0000000000000282
Call Trace:
 [<ffffffff816c5c59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816c18e3>] ? _raw_spin_unlock_irqrestore+0x73/0xa0
 [<ffffffff810a1e62>] ? hrtimer_try_to_cancel+0x52/0x210
 [<ffffffff810eb9e5>] ? debug_rt_mutex_free_waiter+0x15/0x180
 [<ffffffff816c0107>] ? rt_mutex_slowlock+0x127/0x1b0
 [<ffffffff810b7039>] ? local_clock+0x89/0xa0
 [<ffffffff810e3ac2>] lock_acquire+0xa2/0x220
 [<ffffffff810e812c>] ? futex_lock_pi.isra.18+0x1cc/0x390
 [<ffffffff816c09e0>] _raw_spin_lock+0x40/0x80
 [<ffffffff810e812c>] ? futex_lock_pi.isra.18+0x1cc/0x390
 [<ffffffff810e812c>] futex_lock_pi.isra.18+0x1cc/0x390
 [<ffffffff810a1980>] ? update_rmtp+0x70/0x70
 [<ffffffff810e99e4>] do_futex+0x394/0xa50
 [<ffffffff8119ec43>] ? might_fault+0x53/0xb0
 [<ffffffff810ea12d>] sys_futex+0x8d/0x190
 [<ffffffff816ca288>] tracesys+0xe1/0xe6
Code: d8 45 0f 45 e0 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 f8 00 00 00 8b 05 22 fe f3 00 49 89 ff 89 f3 41 89 d2 85 c0 0f 84 02 01 00 00 <49> 8b 07 ba 01 00 00 00 48 3d c0 81 06 82 44 0f 44 e2 83 fb 01 
RIP  [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
 RSP <ffff8800803f7b28>
CR2: 0000000000000018


