Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2FORn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:43:29 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14005
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125Ab2FORn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:43:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5O6KA-01-JX6-02
X-M-MSG: 
Date: Fri, 15 Jun 2012 19:43:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, <tglx@linutronix.de>,
        <vweaver1@eecs.utk.edu>
CC: <linux-tip-commits@vger.kernel.org>
Subject: [PATCH] perf, amd: Fix rdpmc index calculation for AMD family 15h
Message-ID: <20120615174319.GF5046@erda.amd.com>
References: <alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu>
 <tip-c48b60538c3ba05a7a2713c4791b25405525431b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-c48b60538c3ba05a7a2713c4791b25405525431b@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.12 09:17:02, tip-bot for Vince Weaver wrote:
> Commit-ID:  c48b60538c3ba05a7a2713c4791b25405525431b
> Gitweb:     http://git.kernel.org/tip/c48b60538c3ba05a7a2713c4791b25405525431b
> Author:     Vince Weaver <vweaver1@eecs.utk.edu>
> AuthorDate: Thu, 1 Mar 2012 17:28:14 -0500
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 17:23:35 +0200
> 
> perf/x86: Use rdpmc() rather than rdmsr() when possible in the kernel
> 
> The rdpmc instruction is faster than the equivelant rdmsr call,
> so use it when possible in the kernel.
> 
> The perfctr kernel patches did this, after extensive testing showed
> rdpmc to always be faster (One can look in etc/costs in the perfctr-2.6
> package to see a historical list of the overhead).
> 
> I have done some tests on a 3.2 kernel, the kernel module I used
> was included in the first posting of this patch:
> 
>                    rdmsr           rdpmc
>  Core2 T9900:      203.9 cycles     30.9 cycles
>  AMD fam0fh:        56.2 cycles      9.8 cycles
>  Atom 6/28/2:      129.7 cycles     50.6 cycles
> 
> The speedup of using rdpmc is large.
> 
> [ It's probably possible (and desirable) to do this without
>   requiring a new field in the hw_perf_event structure, but
>   the fixed events make this tricky. ]
> 
> Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1203011724030.26934@cl320.eecs.utk.edu
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    4 +++-
>  include/linux/perf_event.h       |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)

This crashs on AMD family 15h. Fix below.

-Robert


>From cf346c12eb0878046d8326a003d4b86aafc8f923 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 15 Jun 2012 19:06:44 +0200
Subject: [PATCH] perf, amd: Fix rdpmc index calculation for AMD family 15h

The rdpmc index calculation is wrong for AMD family 15h (X86_FEATURE_
PERFCTR_CORE set). This leads to a GP when accessing the counter.
While the msr address offset is (index << 1) we must use index to
select the correct rdpmc.

 Pid: 2237, comm: syslog-ng Not tainted 3.5.0-rc1-perf-x86_64-standard-g130ff90 #135 AMD Pike/Pike
 RIP: 0010:[<ffffffff8100dc33>]  [<ffffffff8100dc33>] x86_perf_event_update+0x27/0x66
 RSP: 0000:ffff88042ec07d90  EFLAGS: 00010083
 RAX: 0000000000000005 RBX: 0000000000000005 RCX: 000000000000000a
 RDX: 0000000000000000 RSI: ffff8803f4a68160 RDI: ffff8803f4a68000
 RBP: ffff88042ec07d98 R08: ffffffffffff6c21 R09: 0000000000000030
 R10: ffff88041d33f000 R11: 000000000000001f R12: 0000000000000004
 R13: ffff88042ec0b790 R14: ffff88042ec0b998 R15: ffff8803f4a68000
 FS:  00007f109a313700(0000) GS:ffff88042ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffffff600400 CR3: 00000003f485f000 CR4: 00000000000407f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process syslog-ng (pid: 2237, threadinfo ffff8803f4972000, task ffff8803f4ed9850)
 Stack:
  0000000000000005 ffff88042ec07e48 ffffffff8100f5b9 ffff88042ec07ef8
  ffff88042ec0b990 00000000000001c7 00007f1099445f4d 000008bd000008bd
  0000004835d3bc7a 0000000000000000 0000000000000051 000000000000002a
 Call Trace:
  <NMI>
  [<ffffffff8100f5b9>] x86_pmu_handle_irq+0xc6/0x16a
  [<ffffffff8145db68>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff8145d4b2>] nmi_handle+0x4d/0x71
  [<ffffffff8145d57e>] do_nmi+0xa8/0x2b9
  [<ffffffff8145cce2>] end_repeat_nmi+0x1a/0x1e
  <<EOE>>
 Code: c9 c3 90 90 31 d2 83 bf 1c 01 00 00 30 55 44 8b 0d 83 c4 6f 00 48 89 e5 53 74 49 48 8d b7 60 01 00 00 4c 8b 06 8b 8f 18 01 00 00 <0f> 33 48 c1 e2 20 89 c0 48 09 c2 4c 89 c0 48 0f b1 16 4c 39 c0
 RIP  [<ffffffff8100dc33>] x86_perf_event_update+0x27/0x66
  RSP <ffff88042ec07d90>
 ---[ end trace 69da2f3afd06ff37 ]---
 Kernel panic - not syncing: Fatal exception in interrupt

Cc: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 000a474..e7540c8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -823,7 +823,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
-		hwc->event_base_rdpmc = x86_pmu_addr_offset(hwc->idx);
+		hwc->event_base_rdpmc = hwc->idx;
 	}
 }
 
-- 
1.7.8.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

