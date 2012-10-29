Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2J2CeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:34:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:18086 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab2J2CeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,668,1344236400"; 
   d="scan'208,223";a="210525994"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Jun" <jun.zhang@intel.com>
Subject: [PATCH] Sometimes, there is OOPS happened when we use oprofile. 
Thread-Topic: [PATCH] Sometimes, there is OOPS happened when we use
 oprofile. 
Thread-Index: Ac21fdbrMGxdLfDSTxOYLdnLhBOHyg==
Date: Mon, 29 Oct 2012 02:33:54 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7E416@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fff479313342940372444797814edee996b18fc9 Mon Sep 17 00:00:00 2001
From: jzha144 <jun.zhang@intel.com>
Date: Mon, 29 Oct 2012 09:07:22 +0800
Subject: [PATCH] Sometimes, there is OOPS happened when we use oprofile. next
 is the call stack. From call stack, we find in
 call_on_stack if there is a nmi interrupt between "xchgl
 %%ebx,%%esp" and "call *%%edi", system will OOPS.

 BUG: unable to handle kernel paging request at ff06383f
 IP: [<c12051cd>] print_context_stack+0x4d/0x100
 *pde = 00000000
 Oops: 0000 [#1] PREEMPT SMP
 Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211
 compat btwilink atomisp lm3554 mt9m114 mt9e013 videobuf2_memops videobuf2_core st_drv matrix(C)

 Pid: 162, comm: adbd Tainted: G        WC  3.0.34-140446-g9e77874-dirty #1 Intel Corporation
 EIP: 0060:[<c12051cd>] EFLAGS: 00010083 CPU: 1
 EIP is at print_context_stack+0x4d/0x100
 EAX: ff063ffc EBX: ff06383f ECX: f4a0bd74 EDX: ff06383f
 ESI: 00000000 EDI: ffffe000 EBP: f58dbe48 ESP: f58dbe24
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 Process adbd (pid: 162, ti=f58da000 task=f430a730 task.ti=f4a0a000)
 Stack:
  0000000c ff063ffc f4a0bd74 ffffe000 ff062000 f4a0bd74 ff06383f c1b2b1c0
  ff062000 f58dbe74 c120428f c1b2b1c0 f58dbe98 00000000 f58dbe60 00000000
  00000000 f4a0bd74 f58dbfc4 00000005 f58dbebc c172d52f f4a0bd74 c1b2b1c0
 Call Trace:
  [<c120428f>] dump_trace+0x7f/0xf0
  [<c172d52f>] x86_backtrace+0x13f/0x150
  [<c172b504>] ? op_cpu_buffer_write_commit+0x14/0x20
  [<c172b66e>] ? log_sample+0x8e/0xb0
  [<c172b8ca>] oprofile_add_sample+0x9a/0xc0
  [<c172f09e>] ppro_check_ctrs+0x8e/0x110
  [<c12a31ce>] ? rb_reserve_next_event+0x3e/0x370
  [<c172d8d7>] profile_exceptions_notify+0x67/0x70
  [<c18694c7>] notifier_call_chain+0x47/0x90
  [<c1869548>] __atomic_notifier_call_chain+0x38/0x50
  [<c1250930>] ? remote_softirq_receive+0x110/0x110
  [<c186957f>] atomic_notifier_call_chain+0x1f/0x30
  [<c18695bd>] notify_die+0x2d/0x30
  [<c1867390>] do_nmi+0xb0/0x300
  [<c124fcef>] ? __local_bh_enable+0x4f/0xa0
  [<c1866f95>] nmi_stack_correct+0x28/0x2d
  [<c1250930>] ? remote_softirq_receive+0x110/0x110
  [<c120412f>] ? do_softirq+0x8f/0xe0
  <IRQ>
  [<c1250e26>] irq_exit+0x86/0xd0
  [<c186cb49>] smp_apic_timer_interrupt+0x59/0x88
  [<c1496738>] ? trace_hardirqs_off_thunk+0xc/0x14
  [<c1866ca7>] apic_timer_interrupt+0x2f/0x34
  [<c122007b>] ? handle_vm86_fault+0x78b/0x9b0
  [<c186661f>] ? _raw_spin_unlock_irqrestore+0x3f/0x50
  [<c1230d3c>] __wake_up_sync_key+0x4c/0x60
  [<c17353f0>] sock_def_readable+0x40/0x70
  [<c17d050d>] unix_stream_sendmsg+0x22d/0x390
  [<c173103b>] sock_aio_write+0x11b/0x140
  [<c186375d>] ? __schedule+0x23d/0x8d0
  [<c1866f95>] ? nmi_stack_correct+0x28/0x2d
  [<c12feaf9>] do_sync_write+0xa9/0xe0
  [<c186942d>] ? sub_preempt_count+0x3d/0x50
  [<c12ff321>] vfs_write+0x151/0x160
  [<c1300798>] ? fget_light+0x58/0xd0
  [<c12ff53d>] sys_write+0x3d/0x70
  [<c18669a1>] syscall_call+0x7/0xb
 Code: f6 89 4d f0 89 4d e4 89 45 e0 89 7d e8 74 5e 8d b4 26 00 00 00 00 39
 f3 72 0c 8b 45 f0 83 c4 18 5b 5e 5f 5d c3 90 3b 5d e8 72 ef <8b> 3b 89 f8
 89 7d dc e8 c7 07 06 00 85 c0 74 2b 8b 45 f0 83 c0
 EIP: [<c12051cd>] print_context_stack+0x4d/0x100 SS:ESP 0068:f58dbe24
 CR2: 00000000ff06383f

Signed-off-by: jzha144 <jun.zhang@intel.com>
---
 arch/x86/oprofile/backtrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d6aa6e8..c1af4f0 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -113,6 +113,10 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
+
+		if (!((unsigned long)stack & (THREAD_SIZE - 1)))
+			stack = 0;
+
 		if (depth)
 			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);
-- 
1.7.6
