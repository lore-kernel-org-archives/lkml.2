Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0DUGEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:04:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0DUGEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:04:34 -0400
Date: Wed, 21 Apr 2010 08:04:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Miles Lane <miles.lane@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Eric Paris <eparis@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100421060428.GA3839@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Miles Lane <miles.lane@gmail.com>, paulmck@linux.vnet.ibm.com,
	Eric Paris <eparis@redhat.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1271242058.32749.19.camel@laptop>
 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
 <20100419230136.GA16856@linux.vnet.ibm.com>
 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
 <20100420030452.GB2905@linux.vnet.ibm.com>
 <4BCD646B.1080206@cn.fujitsu.com>
 <1271766716.2972.16.camel@dhcp231-113.rdu.redhat.com>
 <j2ya44ae5cd1004200545q6be4ec82o18ae99d93e8c29c7@mail.gmail.com>
 <20100420135227.GC2628@linux.vnet.ibm.com>
 <t2la44ae5cd1004200838w87256e80v9dcde91342b321db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <t2la44ae5cd1004200838w87256e80v9dcde91342b321db@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a plain -rc5 triggers at net/core/dev.c:1993 here too:

[   12.889090] ===================================================
[   12.889387] [ INFO: suspicious rcu_dereference_check() usage. ]
[   12.889533] ---------------------------------------------------
[   12.889679] net/core/dev.c:1993 invoked rcu_dereference_check() without protection!
[   12.889929] 
[   12.889929] other info that might help us debug this:
[   12.889930] 
[   12.890368] 
[   12.890369] rcu_scheduler_active = 1, debug_locks = 0
[   12.890659] 2 locks held by swapper/0:
[   12.890803]  #0:  (&idev->mc_ifc_timer){+.-...}, at: [<ffffffff81045f4a>] run_timer_softirq+0x266/0x503
[   12.891227]  #1:  (rcu_read_lock_bh){.+....}, at: [<ffffffff81397eb4>] dev_queue_xmit+0x153/0x512
[   12.891647] 
[   12.891648] stack backtrace:
[   12.891934] Pid: 0, comm: swapper Not tainted 2.6.34-rc5 #1
[   12.892085] Call Trace:
[   12.892231]  <IRQ>  [<ffffffff81065d8f>] lockdep_rcu_dereference+0xaa/0xb2
[   12.892430]  [<ffffffff81397fbf>] dev_queue_xmit+0x25e/0x512
[   12.892576]  [<ffffffff81397eb4>] ? dev_queue_xmit+0x153/0x512
[   12.892723]  [<ffffffff81066a4a>] ? trace_hardirqs_on+0xd/0xf
[   12.892871]  [<ffffffff8103f4fb>] ? local_bh_enable_ip+0xbc/0xda
[   12.893024]  [<ffffffff8139ea67>] neigh_resolve_output+0x323/0x36a
[   12.893183]  [<ffffffffa00ae6b7>] ? ipv6_chk_mcast_addr+0x0/0x1fa [ipv6]
[   12.893338]  [<ffffffffa0094860>] ip6_output_finish+0x81/0xb9 [ipv6]
[   12.893492]  [<ffffffffa0096067>] ip6_output2+0x2a9/0x2b4 [ipv6]
[   12.893644]  [<ffffffffa0096c33>] ip6_output+0xbc1/0xbd0 [ipv6]
[   12.893797]  [<ffffffffa00a2a06>] ? fib6_force_start_gc+0x30/0x32 [ipv6]
[   12.893951]  [<ffffffffa00b04e8>] mld_sendpack+0x30b/0x435 [ipv6]
[   12.894109]  [<ffffffffa00b01dd>] ? mld_sendpack+0x0/0x435 [ipv6]
[   12.894264]  [<ffffffff8106676d>] ? mark_held_locks+0x52/0x70
[   12.894418]  [<ffffffffa00b0d2d>] mld_ifc_timer_expire+0x254/0x28d [ipv6]
[   12.894570]  [<ffffffff81046065>] run_timer_softirq+0x381/0x503
[   12.894717]  [<ffffffff81045f4a>] ? run_timer_softirq+0x266/0x503
[   12.894870]  [<ffffffffa00b0ad9>] ? mld_ifc_timer_expire+0x0/0x28d [ipv6]
[   12.895024]  [<ffffffff8103f708>] ? __do_softirq+0x79/0x2f5
[   12.895174]  [<ffffffff8103f80f>] __do_softirq+0x180/0x2f5
[   12.895323]  [<ffffffff810030cc>] call_softirq+0x1c/0x28
[   12.895472]  [<ffffffff81004d91>] do_softirq+0x3d/0x85
[   12.895619]  [<ffffffff8103f2b5>] irq_exit+0x4a/0x95
[   12.895766]  [<ffffffff81413a3d>] smp_apic_timer_interrupt+0x8c/0x9a
[   12.895913]  [<ffffffff81002b93>] apic_timer_interrupt+0x13/0x20
[   12.896065]  <EOI>  [<ffffffff81412e1e>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[   12.896363]  [<ffffffff8100a189>] ? default_idle+0xd8/0x10a
[   12.896512]  [<ffffffff8100a187>] ? default_idle+0xd6/0x10a
[   12.896658]  [<ffffffff8100a5b3>] c1e_idle+0xcd/0xf4
[   12.896805]  [<ffffffff8100138c>] cpu_idle+0x5e/0xb5
[   12.896952]  [<ffffffff813ff0eb>] rest_init+0xff/0x106
[   12.897104]  [<ffffffff813fefec>] ? rest_init+0x0/0x106
[   12.897260]  [<ffffffff818e7c2a>] start_kernel+0x30f/0x31a
[   12.897409]  [<ffffffff818e726d>] x86_64_start_reservations+0x7d/0x81
[   12.897560]  [<ffffffff818e7355>] x86_64_start_kernel+0xe4/0xeb


-- 
Regards/Gruss,
    Boris.
