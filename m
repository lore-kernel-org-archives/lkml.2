Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2H0BdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 21:33:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:54800 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2H0BdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 21:33:23 -0400
From: <Wei.Yang@windriver.com>
To: <mingo@kernel.org>, <robert.richter@amd.com>
CC: <linux-kernel@vger.kernel.org>, <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 1/1] x86/oprofile: Fix the calltrace upon profiling some specified events with oprofile
Date: Mon, 27 Aug 2012 09:32:13 +0800
Message-ID: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yang <Wei.Yang@windriver.com>

Upon enabling the call-graph functionality of oprofile, A few minutes
later the following calltrace will always occur.

BUG: unable to handle kernel paging request at 656d6153
IP: [<c10050f5>] print_context_stack+0x55/0x110
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in:
Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc3-WR5.0+snapshot-20120820_standard
EIP: 0060:[<c10050f5>] EFLAGS: 00010093 CPU: 0
EIP is at print_context_stack+0x55/0x110
EAX: 656d7ffc EBX: 656d6153 ECX: c1837ee0 EDX: 656d6153
ESI: 00000000 EDI: ffffe000 EBP: f600deac ESP: f600de88
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 656d6153 CR3: 01934000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process swapper/0 (pid: 0, ti=f600c000 task=c18411a0 task.ti=c1836000)
Stack:
1a7f76ea 656d7ffc 656d6000 c1837ee0 ffffe000 c1837ee0 656d6153 c188e27c
656d6000 f600dedc c10040f8 c188e27c f600def0 00000000 f600dec8 c1837ee0
00000000 f600ded4 c1837ee0 f600dfc4 0000001f f600df08 c1564d22 00000000
Call Trace:
[<c10040f8>] dump_trace+0x68/0xf0
[<c1564d22>] x86_backtrace+0xb2/0xc0
[<c1562dd2>] oprofile_add_sample+0xa2/0xc0
[<c1003fbf>] ? do_softirq+0x6f/0xa0
[<c1566519>] ppro_check_ctrs+0x79/0x100
[<c15664a0>] ? ppro_shutdown+0x60/0x60
[<c156552f>] profile_exceptions_notify+0x8f/0xb0
[<c1672248>] nmi_handle.isra.0+0x48/0x70
[<c1672343>] do_nmi+0xd3/0x3c0
[<c1033d39>] ? __local_bh_enable+0x29/0x70
[<c1034620>] ? ftrace_define_fields_irq_handler_entry+0x80/0x80
[<c1671a0d>] nmi_stack_correct+0x28/0x2d
[<c1034620>] ? ftrace_define_fields_irq_handler_entry+0x80/0x80
[<c1003fbf>] ? do_softirq+0x6f/0xa0
<IRQ>
[<c1034ad5>] irq_exit+0x65/0x70
[<c16776f9>] smp_apic_timer_interrupt+0x59/0x89
[<c16717da>] apic_timer_interrupt+0x2a/0x30
[<c135164d>] ? acpi_idle_enter_bm+0x245/0x273
[<c14f3a25>] cpuidle_enter+0x15/0x20
[<c14f4070>] cpuidle_idle_call+0xa0/0x320
[<c1009705>] cpu_idle+0x55/0xb0
[<c16519a8>] rest_init+0x6c/0x74
[<c18a291b>] start_kernel+0x2ec/0x2f3
[<c18a2467>] ? repair_env_string+0x51/0x51
[<c18a22a2>] i386_start_kernel+0x78/0x7d
Code: e0 ff ff 89 7d ec 74 5a 8d b4 26 00 00 00 00 8d bc 27 00 00
00 00 39 f3 72 0c 8b 45 f0 8d 64 24 18 5b 5e 5f 5d c3 3b 5d ec 72
ef <8b> 3b 89 f8 89 7d dc e8 ef 40 04 00 85 c0 74 20 8b 40
EIP: [<c10050f5>] print_context_stack+0x55/0x110 SS:ESP 0068:f600de88
CR2: 00000000656d6153
---[ end trace 751c9b47c6ff5e29 ]---

Let's assume a scenario that do_softirq() switches the stack to a soft irq
stack, and the soft irq stack is totally empty. At this moment, a nmi interrupt
occurs, subsequently, CPU does not automatically save SS and SP registers
and switch any stack, but instead only stores EFLAGS, CS and IP to the soft irq
stack. since the CPU is in kernel mode when the NMI exception occurs.
the layout of the current soft irq stack is this:

  +--------------+<-----the top of soft irq
  |   EFLAGS     |
  +--------------+
  |    CS        |
  +--------------+
  |    IP        |
  +--------------+
  |   SAVE_ALL   |
  +--------------+

but the return value of the function kernel_stack_pointer() is'&regs->sp'
(for x86_32 CPU), which is invoked by the x86_backtrace function. Since
the type of regs pointer is a pt_regs structure, the return value is not
in the range of the soft irq stack, as the SP register is not save in the
soft irq stack. Therefore, we need to check if the return value of the function
resides in valid range. Additionally, the changes has no impact on the normal
NMI exception.

Signed-off-by: Yang Wei <wei.yang@windriver.com>
---
 arch/x86/oprofile/backtrace.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d6aa6e8..a5fca0b 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -17,6 +17,11 @@
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 
+static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
+{
+	void *t = tinfo;
+	return p > t + sizeof(struct thread_info) && p < t + THREAD_SIZE;
+}
 static int backtrace_stack(void *data, char *name)
 {
 	/* Yes, we want all stacks */
@@ -110,9 +115,14 @@ void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct stack_frame *head = (struct stack_frame *)frame_pointer(regs);
+	struct thread_info *context;
 
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
+		context = (struct thread_info *)
+			(stack & (~(THREAD_SIZE - 1)));
+		if (!valid_stack_ptr(context, (void *)stack))
+			return;
 		if (depth)
 			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);
-- 
1.7.0.2

