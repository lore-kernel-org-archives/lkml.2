Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1GALNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:13:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51196 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1GALNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:13:21 -0400
X-AuditID: b753bd60-a32aeba0000019f4-66-4e0dabcd8e6c
X-AuditID: b753bd60-a32aeba0000019f4-66-4e0dabcd8e6c
Message-ID: <4E0DABCC.1090303@hitachi.com>
Date: Fri, 01 Jul 2011 20:13:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for kprobes
References: <1309440213.26417.76.camel@gandalf.stny.rr.com> <1309449117.26417.90.camel@gandalf.stny.rr.com> <4E0D5682.3050806@hitachi.com>
In-Reply-To: <4E0D5682.3050806@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

(2011/07/01 14:09), Masami Hiramatsu wrote:
> (2011/07/01 0:51), Steven Rostedt wrote:
>> Kprobes requires preemption to be disabled as it single steps the code
>> it replaced with a breakpoint. But because the code that is single
>> stepped could be reading the preempt count, the kprobe disabling of the
>> preempt count can cause the wrong value to end up as a result. Here's an
>> example:
>>
>> If we add a kprobe on a inc_preempt_count() call:
> 
> BTW, on my tip tree, add_preempt_count (a.k.a. inc_preempt_count())
> is marked as __kprobes, so it can not be probed. Is there any change?

Finally, I've stacked on this point. It seems that
the add_preempt_count() (or inc_preempt_count) is called somewhere
inside the do_int3 and it causes double fault and reboot.

I guess following loop could be happen,
inc_preempt_count->int3->do_int3->preempt_conditional_sti->inc_preempt_count..

I'm still investigating that. Could you tell me what the basic tree
you are working on? I'm using the latest -tip tree.

Thank you,

> 
> Anyway, I'll send the removing preempt_disable from kprobe patch.
> 
> Thank you,
> 
>>
>> 	[ preempt_count = 0 ]
>>
>> 	ld preempt_count, %eax	<<--- trap
>>
>> 		<trap>
>> 		preempt_disable();
>> 		[ preempt_count = 1]
>> 		setup_singlestep();
>> 		<trap return>
>>
>> 	[ preempt_count = 1 ]
>>
>> 	ld preempt_count, %eax
>>
>> 	[ %eax = 1 ]
>>
>> 		<trap>
>> 		post_kprobe_handler()
>> 			preempt_enable_no_resched();
>> 			[ preempt_count = 0 ]
>> 		<trap return>
>>
>> 	[ %eax = 1 ]
>>
>> 	add %eax,1
>>
>> 	[ %eax = 2 ]
>>
>> 	st %eax, preempt_count
>>
>> 	[ preempt_count = 2 ]
>>
>>
>> We just caused preempt count to increment twice when it should have only
>> incremented once, and this screws everything else up.
>>
>> To solve this, I've added a per_cpu variable called
>> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
>> the preempt_schedule() will not preempt the code.
>>
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
