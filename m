Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1GABMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:12:09 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45704 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1GABMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:12:07 -0400
X-AuditID: b753bd60-a50b1ba0000019f4-d9-4e0d1ee439c9
X-AuditID: b753bd60-a50b1ba0000019f4-d9-4e0d1ee439c9
Message-ID: <4E0D1EE3.6080607@hitachi.com>
Date: Fri, 01 Jul 2011 10:12:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [BUG] kprobes crashing because of preempt count
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
In-Reply-To: <1309440213.26417.76.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/30 22:23), Steven Rostedt wrote:
> Hi Masami,
> 
> While testing some changes in -rt against kprobes, I hit a crash that
> exists in mainline. If we stick a probe in a location that reads
> preempt_count, we corrupt the kernel itself.
> 
> Reason is that the kprobe single step handler disables preemption, sets
> up the single step, returns to the code to execute that single step,
> takes the trap, enables preemption, and continues.
> 
> The issue, is because we disabled preemption in the trap, returned, then
> enabled it again in another trap, we just changed what the code sees
> that does that single step.
> 
> If we add a kprobe on a inc_preempt_count() call:
> 
> 	[ preempt_count = 0 ]
> 
> 	ld preempt_count, %eax	<<--- trap
> 
> 		<trap>
> 		preempt_disable();
> 		[ preempt_count = 1]
> 		setup_singlestep();
> 		<trap return>
> 
> 	[ preempt_count = 1 ]
> 
> 	ld preempt_count, %eax
> 
> 	[ %eax = 1 ]
> 
> 		<trap>
> 		post_kprobe_handler()
> 			preempt_enable_no_resched();
> 			[ preempt_count = 0 ]
> 		<trap return>
> 
> 	[ %eax = 1 ]
> 
> 	add %eax,1
> 
> 	[ %eax = 2 ]
> 
> 	st %eax, preempt_count
> 
> 	[ preempt_count = 2 ]
> 
> 
> We just caused preempt count to increment twice when it should have only
> incremented once, and this screws everything else up.

Ah! right!

> Do we really need to have preemption disabled throughout this? Is it
> because we don't want to migrate or call schedule? Not sure what the
> best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
> is checked as well?

I think the best way to do that is just removing preemption disabling
code, because
- breakpoint exception itself disables interrupt (at least on x86)
- While single stepping, interrupts also be disabled.
(BTW, theoretically, boosted and optimized kprobes shouldn't have
this problem, because those doesn't execute single-stepping)

So, I think there is no reason of disabling preemption.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
