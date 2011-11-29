Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1K2EH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:07:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1K2EH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:07:58 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=igSVJdW6TNAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=33cRjKsNCfQ7InZ7y5sA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Perhaps a side effect regarding NMI returns
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 23:07:53 -0500
Message-ID: <1322539673.17003.45.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the return sequence of NMIs in x86_64 and I came across
this in entry_64.S:

	jz paranoid_swapgs
	movq %rsp,%rdi			/* &pt_regs */
	call sync_regs
	movq %rax,%rsp			/* switch stack for scheduling */
	testl $_TIF_NEED_RESCHED,%ebx
	jnz paranoid_schedule
	movl %ebx,%edx			/* arg3: thread flags */
	TRACE_IRQS_ON
	ENABLE_INTERRUPTS(CLBR_NONE)
	xorl %esi,%esi 			/* arg2: oldset */
	movq %rsp,%rdi 			/* arg1: &pt_regs */
	call do_notify_resume
	DISABLE_INTERRUPTS(CLBR_NONE)
	TRACE_IRQS_OFF
	jmp paranoid_userspace
paranoid_schedule:
	TRACE_IRQS_ON
	ENABLE_INTERRUPTS(CLBR_ANY)
	call schedule
	DISABLE_INTERRUPTS(CLBR_ANY)
	TRACE_IRQS_OFF
	jmp paranoid_userspace
	CFI_ENDPROC

Specifically the code after jnz paranoid_schedule.

Just before that jnz, we swap the stack back to the task's stack (no
more NMI stack). If NEED_RESCHED is set, we jump to paranoid_schedule
and enable interrupts and call schedule.

Is there a bit of a side effect here? What happens when you enable
interrupts in NMI context? Can more NMIs come in? If not, we just went
into schedule and went off and running, and NMIs will have to wait till
the next interrupt comes in and calls iretq to re-enable NMIs. If we
lock up here, don't expect NMI watchdog to help you out.

If enabling interrupts also enables NMIs, then there's no side effect.

This email is more of an FYI than anything else. Maybe there's an issue
here, and maybe there isn't. But this is so subtle that I figured I
would bring it to other people's attention. I'll let others do the hard
work to figure out if we should worry about this or not ;-)

-- Steve


