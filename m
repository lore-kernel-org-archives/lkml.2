Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab1F3NXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:23:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1F3NXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:23:35 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=Rw23DLKw10QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IF-L7c8KoyR6mwv_RI8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [BUG] kprobes crashing because of preempt count
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 09:23:33 -0400
Message-ID: <1309440213.26417.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

While testing some changes in -rt against kprobes, I hit a crash that
exists in mainline. If we stick a probe in a location that reads
preempt_count, we corrupt the kernel itself.

Reason is that the kprobe single step handler disables preemption, sets
up the single step, returns to the code to execute that single step,
takes the trap, enables preemption, and continues.

The issue, is because we disabled preemption in the trap, returned, then
enabled it again in another trap, we just changed what the code sees
that does that single step.

If we add a kprobe on a inc_preempt_count() call:

	[ preempt_count = 0 ]

	ld preempt_count, %eax	<<--- trap

		<trap>
		preempt_disable();
		[ preempt_count = 1]
		setup_singlestep();
		<trap return>

	[ preempt_count = 1 ]

	ld preempt_count, %eax

	[ %eax = 1 ]

		<trap>
		post_kprobe_handler()
			preempt_enable_no_resched();
			[ preempt_count = 0 ]
		<trap return>

	[ %eax = 1 ]

	add %eax,1

	[ %eax = 2 ]

	st %eax, preempt_count

	[ preempt_count = 2 ]


We just caused preempt count to increment twice when it should have only
incremented once, and this screws everything else up.

Do we really need to have preemption disabled throughout this? Is it
because we don't want to migrate or call schedule? Not sure what the
best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
is checked as well?

-- Steve


