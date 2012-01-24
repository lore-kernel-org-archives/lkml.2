Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2AXTO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:14:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2AXTO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:14:57 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=gCIPlA5aq9oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=6MSCdwiEAuKsn8EJPUgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120124185350.092483803@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 24 Jan 2012 13:53:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 0/2][RFC] preempt-rt/x86: Handle sending signals from do_trap() by gdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this patchset is focused on PREEMPT_RT, but as it affects some of
the x86 code, so I wanted a wider audience. The first patch is not PREEMPT_RT
specific and can go into mainline now.

Here's the issue:

In PREEMPT_RT, every spin_lock() in the kernel turns into a mutex. I wont
go into the details of why this is done, but it helps with latencies, and
we do it in a manner that it just works, except for when it doesn't (like
this patch series is to correct).

When int3 is triggered by gdb, the int3 trap will call do_trap(), and
the do_trap() will call force_sig() to send a SIG_TRAP to the process.

The do_int3() code (as well as do_debug() which gdb also triggers)
calls preempt_conditional_sti() and preemp_conditional_cli() which
will increment/decrement the preempt count to disable preemption, and
will conditionally enable/disable interrupts, depending on if the code
that triggered the trap had interrupts disabled.

Now, that force_sig() that is called grabs a signal spin_lock, which in
PREEMPT_RT happens to be a mutex. If that mutex is under contention, the
task will schedule, and we hit the scheduling while atomic code.

What's worse, in x86_64 the int3 and debug traps switch to a per CPU debug
stack set by the IST. If we schedule with this stack, and another task comes
in and uses the debug stack, the kernel stack can become corrupted and we
crash the system.

On x86_32, the stack is the same as the task's kernel stack and scheduling
should not be an issue. The first patch solves this bug by just not
disabling preemption for x86_32.

The second patch is a bit more involed, and is used to solve the issue on
x86_64. Since we can not simply enable preemption because the current task
is using a per CPU debug stack, we need to postpone the force_sig() and
force_sig_info() calls.

I created a wrapper of these calls with an _rt() extension. This version
will do some checks and if we need to send the SIG_TRAP, it will store the
signal information in the current tasks task_struct and set a new TIF flag
TIF_FORCE_SIG_TRAP.

I added to the paranoid_exit routine in entry_64.S, where it switches the
stack back to the user stack and then enables interrupts and may call schedule
if NEED_RESCHED is set.

In order to not make that code more complex, when the signal needs to be
delayed, the NEED_RESCHED flag is set to force us into that code path.
With the FORCE_SIG_TRAP also set, we can do a check and call a routine to
do the delayed force_sig() after the task's stack is switched back to its
kernel stack and interrupts are reenabled.

Comments? Also anyone see holes in this code?

Thanks,

-- Steve

