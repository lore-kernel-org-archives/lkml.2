Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1GGKWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:22:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37167 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1GGKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:22:39 -0400
Date: Thu, 7 Jul 2011 15:52:32 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, anton@samba.org,
        benh@kernel.crashing.org, torvalds@linux-foundation.org
Subject: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110707102107.GA16666@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux-3.0-rc fails to boot on a power7 system with 1TB ram and 896 CPUs.
While the initial boot log shows a soft-lockup [1], the machine is hung after.
Dropping into xmon shows the cpus are all struck at:
--------------------
cpu 0xa: Vector: 100 (System Reset) at [c000000fae51fae0]
    pc: c0000000000596b8: .plpar_hcall_norets+0x80/0xd0
    lr: c00000000005b9a4: .pseries_dedicated_idle_sleep+0x194/0x210
    sp: c000000fae51fd60
   msr: 8000000000089032
  current = 0xc000000fae49d990
  paca    = 0xc00000000ebb1900
    pid   = 0, comm = kworker/0:1
cpu 0x41: Vector: 100 (System Reset) at [c000000fac01bae0]
    pc: c0000000000596b8: .plpar_hcall_norets+0x80/0xd0
    lr: c00000000005b9a4: .pseries_dedicated_idle_sleep+0x194/0x210
    sp: c000000fac01bd60
   msr: 8000000000089032
  current = 0xc000000faefbf210
  paca    = 0xc00000000ebba280
    pid   = 0, comm = kworker/0:1
cpu 0x21: Vector: 100 (System Reset) at [c000000fae9abae0]
    pc: c0000000000596b8: .plpar_hcall_norets+0x80/0xd0
    lr: c00000000005b9a4: .pseries_dedicated_idle_sleep+0x194/0x210
    sp: c000000fae9abd60
   msr: 8000000000089032
  current = 0xc000000fae998590
  paca    = 0xc00000000ebb5280
    pid   = 0, comm = kworker/0:1
cpu 0xb8: Vector: 100 (System Reset) at [c000000fab3dbae0]
    pc: c0000000000596b8: .plpar_hcall_norets+0x80/0xd0
    lr: c00000000005b9a4: .pseries_dedicated_idle_sleep+0x194/0x210
    sp: c000000fab3dbd60
   msr: 8000000000089032
  current = 0xc000000fab3a2710
  paca    = 0xc00000000ebccc00
    pid   = 0, comm = kworker/0:1
......
......
And shows same for all the CPUs.
a:mon> t
[link register   ] c00000000005b9a4 .pseries_dedicated_idle_sleep+0x194/0x210
[c000000fae51fd60] 00000000134d0000 (unreliable)
[c000000fae51fe20] c000000000018b64 .cpu_idle+0x164/0x210
[c000000fae51fed0] c0000000005d55b0 .start_secondary+0x348/0x354
[c000000fae51ff90] c000000000009268 .start_secondary_prolog+0x10/0x14
a:mon> S
msr  = 8000000000001032  sprg0= 0000000000000000
pvr  = 00000000003f0201  sprg1= c00000000ebb1900
dec  = 0000000030fb5b4f  sprg2= c00000000ebb1900
sp   = c000000fae51f440  sprg3= 000000000000000a
toc  = c000000000e21f90  dar  = c000011aee0c20e8
a:mon>
--------------------

2.6.39 booted fine on the system and a git bisect shows commit cd4ea6ae -
"sched: Change NODE sched_domain group creation" as the cause.

Thanks,
-Mahesh.

[1]:
POWER7 performance monitor hardware support registered
Brought up 896 CPUs
Enabling Asymmetric SMT scheduling
BUG: soft lockup - CPU#0 stuck for 22s! [swapper:1]
Modules linked in:
NIP: c000000000074b90 LR: c00000000008a1c4 CTR: 0000000000000000
REGS: c000000fae25f9c0 TRAP: 0901   Not tainted  (3.0.0-rc6)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000088  XER: 00000004
TASK = c000000fae248490[1] 'swapper' THREAD: c000000fae25c000 CPU: 0
GPR00: 0000e2a55cbeec50 c000000fae25fc40 c000000000e21f90 c000007b2b34cb00
GPR04: 0000000000000100 0000000000000100 c000011adcf23418 0000000000000000
GPR08: 0000000000000000 c000008b2b7d4480 c000007b2b35ef80 00000000000024ac
GPR12: 0000000044000042 c00000000ebb0000
NIP [c000000000074b90] .update_group_power+0x50/0x190
LR [c00000000008a1c4] .build_sched_domains+0x434/0x490
Call Trace:
[c000000fae25fc40] [c000000fae25fce0] 0xc000000fae25fce0 (unreliable)
[c000000fae25fce0] [c00000000008a1c4] .build_sched_domains+0x434/0x490
[c000000fae25fdd0] [c000000000867370] .sched_init_smp+0xa8/0x224
[c000000fae25fee0] [c000000000850274] .kernel_init+0x10c/0x1fc
[c000000fae25ff90] [c000000000023884] .kernel_thread+0x54/0x70
Instruction dump:
f821ff61 ebc2b1a0 7c7f1b78 7c9c2378 e9230008 eba30010 2fa90000 419e0054
e9490010 38000000 7d495378 60000000 <8169000c> e9290000 7faa4800 7c005a14

