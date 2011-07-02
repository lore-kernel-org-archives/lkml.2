Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1GBQbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:31:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52746 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1GBQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:29:54 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] x86: Fetch stack from regs when possible in dump_trace()
Date: Sat,  2 Jul 2011 18:29:40 +0200
Message-Id: <1309624184-9790-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When regs are passed to dump_stack(), we fetch the frame
pointer from the regs but the stack pointer is taken from
the current frame.

Thus the frame and stack pointers may not come from the same
context. For example this can result in the unwinder to
think the context is in irq, due to the current value of
the stack, but the frame pointer coming from the regs points
to a frame from another place. It then tries to fix up
the irq link but ends up dereferencing a random frame
pointer that doesn't belong to the irq stack:

[ 9131.706906] ------------[ cut here ]------------
[ 9131.707003] WARNING: at arch/x86/kernel/dumpstack_64.c:129 dump_trace+0x2aa/0x330()
[ 9131.707003] Hardware name: AMD690VM-FMH
[ 9131.707003] Perf: bad frame pointer = 0000000000000005 in callchain
[ 9131.707003] Modules linked in:
[ 9131.707003] Pid: 1050, comm: perf Not tainted 3.0.0-rc3+ #181
[ 9131.707003] Call Trace:
[ 9131.707003]  <IRQ>  [<ffffffff8104bd4a>] warn_slowpath_common+0x7a/0xb0
[ 9131.707003]  [<ffffffff8104be21>] warn_slowpath_fmt+0x41/0x50
[ 9131.707003]  [<ffffffff8178b873>] ? bad_to_user+0x6d/0x10be
[ 9131.707003]  [<ffffffff8100c2da>] dump_trace+0x2aa/0x330
[ 9131.707003]  [<ffffffff810107d3>] ? native_sched_clock+0x13/0x50
[ 9131.707003]  [<ffffffff8101b164>] perf_callchain_kernel+0x54/0x70
[ 9131.707003]  [<ffffffff810d391f>] perf_prepare_sample+0x19f/0x2a0
[ 9131.707003]  [<ffffffff810d546c>] __perf_event_overflow+0x16c/0x290
[ 9131.707003]  [<ffffffff810d5430>] ? __perf_event_overflow+0x130/0x290
[ 9131.707003]  [<ffffffff810107d3>] ? native_sched_clock+0x13/0x50
[ 9131.707003]  [<ffffffff8100fbb9>] ? sched_clock+0x9/0x10
[ 9131.707003]  [<ffffffff810752e5>] ? T.375+0x15/0x90
[ 9131.707003]  [<ffffffff81084da4>] ? trace_hardirqs_on_caller+0x64/0x180
[ 9131.707003]  [<ffffffff810817bd>] ? trace_hardirqs_off+0xd/0x10
[ 9131.707003]  [<ffffffff810d5764>] perf_event_overflow+0x14/0x20
[ 9131.707003]  [<ffffffff810d588c>] perf_swevent_hrtimer+0x11c/0x130
[ 9131.707003]  [<ffffffff817821a1>] ? error_exit+0x51/0xb0
[ 9131.707003]  [<ffffffff81072e93>] __run_hrtimer+0x83/0x1e0
[ 9131.707003]  [<ffffffff810d5770>] ? perf_event_overflow+0x20/0x20
[ 9131.707003]  [<ffffffff81073256>] hrtimer_interrupt+0x106/0x250
[ 9131.707003]  [<ffffffff812a3bfd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 9131.707003]  [<ffffffff81024833>] smp_apic_timer_interrupt+0x53/0x90
[ 9131.707003]  [<ffffffff81789053>] apic_timer_interrupt+0x13/0x20
[ 9131.707003]  <EOI>  [<ffffffff817821a1>] ? error_exit+0x51/0xb0
[ 9131.707003]  [<ffffffff8178219c>] ? error_exit+0x4c/0xb0
[ 9131.707003] ---[ end trace b2560d4876709347 ]---

Fix this by simply taking the stack pointer from regs->sp
when regs are provided.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/dumpstack_64.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index e71c98d..788295c 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -155,9 +155,12 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		task = current;
 
 	if (!stack) {
-		stack = &dummy;
-		if (task && task != current)
+		if (regs)
+			stack = (unsigned long *)regs->sp;
+		else if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
+		else
+			stack = &dummy;
 	}
 
 	if (!bp)
-- 
1.7.5.4

