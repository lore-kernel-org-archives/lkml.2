Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1GACXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:23:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58046 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1GACXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:23:32 -0400
X-AuditID: b753bd60-a50b1ba0000019f4-44-4e0d2fa2b1d6
X-AuditID: b753bd60-a50b1ba0000019f4-44-4e0d2fa2b1d6
Message-ID: <4E0D2F9F.9040102@hitachi.com>
Date: Fri, 01 Jul 2011 11:23:27 +0900
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
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>	 <4E0D1EE3.6080607@hitachi.com> <1309484007.26417.121.camel@gandalf.stny.rr.com>
In-Reply-To: <1309484007.26417.121.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 10:33), Steven Rostedt wrote:
> On Fri, 2011-07-01 at 10:12 +0900, Masami Hiramatsu wrote:
> 
>>> Do we really need to have preemption disabled throughout this? Is it
>>> because we don't want to migrate or call schedule? Not sure what the
>>> best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
>>> is checked as well?
>>
>> I think the best way to do that is just removing preemption disabling
>> code, because
>> - breakpoint exception itself disables interrupt (at least on x86)
>> - While single stepping, interrupts also be disabled.
> 
> I guess the above point is critical. If interrupts are disabled through
> out the entire walk through, then we are fine, as that just guarantees
> preemption is disabled anyway. But! if it does get enabled anywhere,
> then we will have issues as the two traps require using the same state
> data that is stored per cpu.

That should be a bug, or kprobe's assumption was so fragile (and must
be rewritten.)

Anyway, kprobe_handler() in arch/x86/kernel/kprobes.c expects that
it is executed in a critical section, and it ensures that if there
is no other kprobes running on that processor. (however, as you can
see in reenter_kprobe(), if the breakpoint hits under single stepping,
it calls BUG() because kprobes guess that someone put another kprobe
inside kprobe's critical section)

>> (BTW, theoretically, boosted and optimized kprobes shouldn't have
>> this problem, because those doesn't execute single-stepping)
> 
> Does the optimized kprobes even disable preemption?

Yeah, just while calling its handler, since someone will
call may_sleep() in it... Anyway, nowadays it disables
interruption for emulating breakpoint behavior.

>>
>> So, I think there is no reason of disabling preemption.
> 
> That would be the best solution.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
