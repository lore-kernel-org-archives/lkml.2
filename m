Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0DDMTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 08:19:09 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60655 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0DDMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 08:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pnXIMJDaWUbEZ2498uiufnhw3lngRmbvLiRgmxWAJNhXAeNsJjDPwKTk5ilydXrfnH
         +Y4hsNY9kMzrr2A851bCuatqbFQhfgh8GjlBV5uW/ZjQd3jyF+RMdIzXqqMoTRiFoxgn
         eGVssc5nlk8U6Fa/5+uyvBZWmMJa4fzJTy+hc=
Date: Sun, 4 Apr 2010 14:18:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>,
       SparcLinux <sparclinux@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Random scheduler/unaligned accesses crashes with perf lock events
	on sparc 64
Message-ID: <20100404121851.GC5177@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On tip:master, while turning on lock events with perf through

	perf lock record

I get random kernel crashes, sometimes about weird unaligned
accesses, sometimes about scheduler that complains.

I hope someone has an idea about this.

In three different attempts (got to force reboot each time), I got:

First (task_tgid_nr_ns() is called from perf_event_pid()):

[  565.464201] Kernel unaligned access at TPC[486b74] task_tgid_nr_ns+0x8/0x54
[  565.475801] sun4v_data_access_exception: ADDR[000060f8b13a2004] CTX[0000] TYPE[0009], going.
[  565.488610]               \|/ ____ \|/
1>[  565.492705] Unable to handle kernel NULL pointer dereference
[  565.492719] Unable to handle kernel NULL pointer dereference
[  565.492733] Unable to handle kernel NULL pointer dereference
[  565.492747] Unable to handle kernel NULL pointer dereference
[  565.492761] Unable to handle kernel NULL pointer dereference
[  565.492776] Unable to handle kernel NULL pointer dereference
[  565.492790] Unable to handle kernel NULL pointer dereference
[  565.492804] Unable to handle kernel NULL pointer dereference
[  565.492818] Unable to handle kernel NULL pointer dereference
[  565.492832] Unable to handle kernel NULL pointer dereference
[  565.492847] Unable to handle kernel NULL pointer dereference

Second:

[  250.508047] Kernel unaligned access at TPC[4d1a0c] perf_swevent_ctx_event+0x16c/0x1b0

(this one happened in asm/processor_64.h: prefetch(), probably while
walking to the context's event list)

Third:

[   60.147895] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  130.637924] sun4v_data_access_exception: ADDR[ffffa010933a6060] CTX[0000] TYPE[0009], going.
[  130.639329] kernel BUG at kernel/sched.c:1166!
[  130.639364]               \|/ ____ \|/
[  130.639370]               "@'/ .. \`@"
[  130.639377]               /_| \__/ |_\
[  130.639382]                  \__U_/
[  130.639394] swapper(0): Kernel bad sw trap 5 [#1]
[  130.639430] TSTATE: 0000000080e01605 TPC: 000000000045a02c TNPC: 000000000045a030 Y: 00000000    Tainted: G        
W 
[  130.639462] TPC: <resched_task+0x44/0xa8>
[  130.639475] g0: fffff803f685d980 g1: 0000000000000000 g2: 0000000000000027 g3: 0000000000007d0d
[  130.639493] g4: fffff803f685d980 g5: fffff800160a0000 g6: fffff803f6864000 g7: 0000000000b54c00
[  130.639511] o0: 0000000000828580 o1: 000000000000048e o2: 0000000000000000 o3: 0000000000000000
[  130.639528] o4: 0000000000000002 o5: 0000000000000001 sp: fffff803ff932ff1 ret_pc: 000000000045a024
[  130.639548] RPC: <resched_task+0x3c/0xa8>
[  130.639561] l0: 0000000000000000 l1: 000000000000000e l2: ffffffffffffffff l3: 0000000000000104
[  130.639580] l4: fffff803f685d980 l5: 0006000000000000 l6: 000000000000000e l7: 00000000008a4180
[  130.639597] i0: fffff803f62c6960 i1: fffff803f7fa18e0 i2: 0000000000000001 i3: 0000000000000000
[  130.639616] i4: 0000000000b28340 i5: 0000000000b25cc0 i6: fffff803ff9330b1 i7: 0000000000461bc8
[  130.639644] I7: <check_preempt_wakeup+0x148/0x1f8>
[  130.639655] Instruction DUMP: 9210248e  7fff3f4d  90122180 <91d02005> c25a6008  82086008  0ac84014  92026008  
4005c092 
[  130.639703] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  130.639715] Call Trace:
[  130.639742]  [000000000073795c] panic+0x58/0x124
[  130.639763]  [000000000046fb80] do_exit+0x64/0x770
[  130.639782]  [0000000000427d4c] die_if_kernel+0x264/0x290
[  130.639801]  [000000000042a138] bad_trap+0x78/0xe8
[  130.639824]  [00000000004220b0] tl0_resv104+0x30/0xa0
[  130.639841]  [000000000045a02c] resched_task+0x44/0xa8
[  130.639861]  [0000000000461bc8] check_preempt_wakeup+0x148/0x1f8
[  130.639883]  [0000000000466554] try_to_wake_up+0x484/0x570
[  130.639902]  [000000000046668c] wake_up_process+0xc/0x20
[  130.639920]  [00000000004678b4] load_balance+0xfb4/0x10f0
[  130.639940]  [0000000000467b60] rebalance_domains+0x170/0x204
[  130.639960]  [0000000000467c30] run_rebalance_domains+0x3c/0x100
[  130.639985]  [00000000004734a4] __do_softirq+0x1b8/0x378
[  130.640004]  [000000000042a354] do_softirq+0x8c/0xcc
[  130.640021]  [0000000000472ec0] irq_exit+0x68/0xd0
[  130.640044]  [000000000042f0f8] timer_interrupt+0xb8/0xec

