Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1LMP1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:27:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38429 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab1LMP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:27:06 -0500
Date: Tue, 13 Dec 2011 15:26:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: perf NULL pointer dereference on -rc5
Message-ID: <20111213152651.GP20297@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Commit 10c6db11 ("perf: Fix loss of notification with multi-event") seems to
dereference a NULL event->rb in the wakeup handler during Vince Weaver's perf
tests (specifically corner_cases/overflow_requires_mmap).

This diff seems to fix the problem, but I'm not sure if it just hides something else:


diff --git a/kernel/events/core.c b/kernel/events/core.c
index d3b9df5..b466e7fc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3558,9 +3558,13 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
        rcu_read_lock();
        rb = rcu_dereference(event->rb);
+       if (!rb)
+               goto unlock;
+
        list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
                wake_up_all(&event->waitq);
        }
+unlock:
        rcu_read_unlock();
 }


Log follows...

Cheers,

Will


[   77.705045] Unable to handle kernel NULL pointer dereference at virtual address 0000004c
[   77.732457] pgd = ef254000
[   77.740547] [0000004c] *pgd=9f81f831
[   77.751258] Internal error: Oops: 17 [#1] PREEMPT SMP
[   77.766382] Modules linked in:
[   77.775527] CPU: 0    Tainted: G        W     (3.2.0-rc5 #5)
[   77.792491] PC is at perf_event_wakeup+0x18/0x88
[   77.806315] LR is at perf_event_wakeup+0x10/0x88
[   77.820143] pc : [<c007fbec>]    lr : [<c007fbe4>]    psr: 20000193
[   77.820153] sp : ef271e80  ip : 00000007  fp : 00000118
[   77.854552] r10: ef270000  r9 : 00000000  r8 : 00000001
[   77.870199] r7 : ef357800  r6 : ef271e88  r5 : 00000000  r4 : ef3579e0
[   77.889753] r3 : ef8cd6a0  r2 : 00000001  r1 : ef270000  r0 : ef357800
[   77.909310] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   77.930949] Control: 10c5387d  Table: 8f25404a  DAC: 00000015
[   77.948159] Process overflow_requir (pid: 3092, stack limit = 0xef2702f8)
[   77.968495] Stack: (0xef271e80 to 0xef272000)
[   77.981545] 1e80: 00000001 00000000 000f4071 ef3579e0 00000000 00000000 00000002 c007b30c
[   78.006056] 1ea0: c0401da8 00000007 00000000 c0418d08 c0d3d160 c00168a8 00000002 ef3578c8
[   78.030568] 1ec0: 00000100 ef271fb0 00000001 00000000 00008a5a 00000000 ef357000 ef82f700
[   78.055077] 1ee0: ef821000 00000000 00000000 00000000 c03fe2b4 c01ec0a0 ef357000 c03fe080
[   78.079588] 1f00: ef402c60 40000193 000f4240 00000000 ef1b9dc0 00000000 00000000 ef1c1640
[   78.104098] 1f20: ef80a654 00000000 00000000 0000005c c0424198 ef80a600 00000001 c006ea94
[   78.128608] 1f40: 00000001 00000c14 ef1b9140 ef80a600 ef80a654 ef1c1640 0000005c 00000000
[   78.153118] 1f60: 00000004 000f4240 00000000 c006ebfc ef80a600 ef80a654 00000001 c0071500
[   78.177628] 1f80: 0000005c c03f9c4c ef270000 c006e3e0 c03feb30 c000e9e4 00008a5a 20000030
[   78.202138] 1fa0: f8e00100 00000003 00000001 c000deb4 00000000 00002400 00938462 00000000
[   78.226648] 1fc0: becc46a0 00000000 000121f8 00000003 00000001 00000004 000f4240 00000000
[   78.251159] 1fe0: 0001203c becc45c0 00008a4d 00008a5a 20000030 ffffffff 8f538c6b 2493cd43
[   78.275697] [<c007fbec>] (perf_event_wakeup+0x18/0x88) from [<c007b30c>] (irq_work_run+0x90/0xc4)
[   78.302314] [<c007b30c>] (irq_work_run+0x90/0xc4) from [<c00168a8>] (armv7pmu_handle_irq+0x104/0x17c)
[   78.329970] [<c00168a8>] (armv7pmu_handle_irq+0x104/0x17c) from [<c006ea94>] (handle_irq_event_percpu+0x54/0x180)
[   78.360741] [<c006ea94>] (handle_irq_event_percpu+0x54/0x180) from [<c006ebfc>] (handle_irq_event+0x3c/0x5c)
[   78.390213] [<c006ebfc>] (handle_irq_event+0x3c/0x5c) from [<c0071500>] (handle_fasteoi_irq+0x9c/0x140)
[   78.418379] [<c0071500>] (handle_fasteoi_irq+0x9c/0x140) from [<c006e3e0>] (generic_handle_irq+0x20/0x30)
[   78.447078] [<c006e3e0>] (generic_handle_irq+0x20/0x30) from [<c000e9e4>] (handle_IRQ+0x58/0xac)
[   78.473420] [<c000e9e4>] (handle_IRQ+0x58/0xac) from [<c000deb4>] (__irq_usr+0x34/0xa0)
[   78.497411] Code: e24dd00c ebffcdef e59751b4 e28d6008 (e5b5304c) 
[   78.515665] ---[ end trace 1b75b31a2719ed1e ]---
[   78.529490] Kernel panic - not syncing: Fatal exception in interrupt
[   78.548543] [<c0013e7c>] (unwind_backtrace+0x0/0xf8) from [<c02e6cc0>] (panic+0x7c/0x1bc)
[   78.573069] [<c02e6cc0>] (panic+0x7c/0x1bc) from [<c00118a8>] (die+0x1f4/0x1f8)
[   78.594987] [<c00118a8>] (die+0x1f4/0x1f8) from [<c0017f60>] (__do_kernel_fault+0x74/0x84)
[   78.619766] [<c0017f60>] (__do_kernel_fault+0x74/0x84) from [<c001810c>] (do_page_fault+0x19c/0x2f0)
[   78.647149] [<c001810c>] (do_page_fault+0x19c/0x2f0) from [<c00083f0>] (do_DataAbort+0x34/0x9c)
[   78.673228] [<c00083f0>] (do_DataAbort+0x34/0x9c) from [<c000dc58>] (__dabt_svc+0x38/0x60)
[   78.697992] Exception stack(0xef271e38 to 0xef271e80)
[   78.713119] 1e20:                                                       ef357800 ef270000
[   78.737630] 1e40: 00000001 ef8cd6a0 ef3579e0 00000000 ef271e88 ef357800 00000001 00000000
[   78.762141] 1e60: ef270000 00000118 00000007 ef271e80 c007fbe4 c007fbec 20000193 ffffffff
[   78.786658] [<c000dc58>] (__dabt_svc+0x38/0x60) from [<c007fbec>] (perf_event_wakeup+0x18/0x88)
[   78.812739] [<c007fbec>] (perf_event_wakeup+0x18/0x88) from [<c007b30c>] (irq_work_run+0x90/0xc4)
[   78.839341] [<c007b30c>] (irq_work_run+0x90/0xc4) from [<c00168a8>] (armv7pmu_handle_irq+0x104/0x17c)
[   78.866986] [<c00168a8>] (armv7pmu_handle_irq+0x104/0x17c) from [<c006ea94>] (handle_irq_event_percpu+0x54/0x180)
[   78.897754] [<c006ea94>] (handle_irq_event_percpu+0x54/0x180) from [<c006ebfc>] (handle_irq_event+0x3c/0x5c)
[   78.927221] [<c006ebfc>] (handle_irq_event+0x3c/0x5c) from [<c0071500>] (handle_fasteoi_irq+0x9c/0x140)
[   78.955385] [<c0071500>] (handle_fasteoi_irq+0x9c/0x140) from [<c006e3e0>] (generic_handle_irq+0x20/0x30)
[   78.984071] [<c006e3e0>] (generic_handle_irq+0x20/0x30) from [<c000e9e4>] (handle_IRQ+0x58/0xac)
[   79.010410] [<c000e9e4>] (handle_IRQ+0x58/0xac) from [<c000deb4>] (__irq_usr+0x34/0xa0)

