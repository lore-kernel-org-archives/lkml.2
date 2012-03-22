Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2CVDJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:09:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46736 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2CVDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:08:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rjw@sisk.pl, tglx@linutronix.de
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/smp: Fix bringup bug in AP code.
Date: Wed, 21 Mar 2012 23:04:09 -0400
Message-Id: <1332385449-29281-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332385449-29281-1-git-send-email-konrad.wilk@oracle.com>
References: <1332347541.18960.498.camel@twins>
 <1332385449-29281-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F6A97B1.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU hotplug code has now a callback to help bring up the CPU.
Without the call we end up getting:

 BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]
Modules linked in:
CPU ] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
.. snip..
Call Trace:
 [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
 [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
 [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
 [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
 [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
 [<ffffffff8108dc76>] kthread+0x96/0xa0
 [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815aacbc>] ? retint_restore_ar

This fixes it.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 315d8fa..02900e8 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -75,8 +75,14 @@ static void __cpuinit cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
+	notify_cpu_starting(cpu);
+
+	ipi_call_lock();
 	set_cpu_online(cpu, true);
+	ipi_call_unlock();
+
 	this_cpu_write(cpu_state, CPU_ONLINE);
+
 	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
-- 
1.7.7.5

