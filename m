Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1HKG2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:28:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34245 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1HKG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:28:49 -0400
X-AuditID: b753bd60-a14abba0000019f4-ae-4e43769ea8d9
X-AuditID: b753bd60-a14abba0000019f4-ae-4e43769ea8d9
Message-ID: <4E43769C.9000901@hitachi.com>
Date: Thu, 11 Aug 2011 15:28:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace
 nops
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com> <1313022842.18583.282.camel@gandalf.stny.rr.com>
In-Reply-To: <1313022842.18583.282.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/11 9:34), Steven Rostedt wrote:
> On Thu, 2011-08-11 at 09:21 +0900, Masami Hiramatsu wrote:
>> Hi Steven,
>>
>> Thanks for this nice feature!
>>
>> (2011/08/11 1:22), Steven Rostedt wrote:
>>> Hi All,
>>>
>>> I started working on adding the -mfentry switch to ftrace, which
>>> allows us to remove the frame pointers requirement from function tracing
>>> as well as makes mcount (fentry) work just better.
>>>
>>> But when I did this in another branch, I noticed that I broke kprobes
>>> in its most common usage. The attaching a probe at the beginning of
>>> a function to use get to its parameters.
>>>
>>> So I started this branch. This branch is to have kprobes use ftrace
>>> directly when a probe is attached to a ftrace nop. Currently, kprobes
>>> will just error when that happens. With this patch set, it will hook
>>> into the ftrace infrastructure and use ftrace instead. This is more
>>> like an optimized probe as no breakpoints need to be set. A call to
>>> the function is done directly via the mcount trampoline. If ftrace
>>> pt_regs is implemented for an arch, kprobes gets this feature for free.
>>
>> I agreed this idea, this looks good to me too :)
>> With -fentry, this can improve dynamic trace events very much.
>>
>> BTW (OT), it seems that current kprobe data structure becomes a bit
>> fat. Maybe what we need is just a "holder of hooking handler" as
>> what ftrace provides, not a full storage data structure of copied
>> instrucutions. Perhaps, we'd better diet the kprobe structure for
>> transparency of hooking infrastructure.
>
> Sure, I can make the ftrace_ops field in kprobes dynamically allocated
> instead. That shouldn't be an issue.

By the way (again), perhaps, much simpler solution is using ftrace
not in kprobe, but in the trace_kprobe. Of course, there are several
pros and cons...

The pros:
- Arch independent solution (anyway, ftrace still needs passing pt_regs
 to their handler)
- Don't need to introduce more complexity into kprobes itself.
- Maybe systemtap also can catch up with this as using same method.

The cons:
- Native kprobes users will be disappointed... anyway, they just need to
  move their probes to the next instruction (usually addr+=5 is OK).

... are there any other cons? :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
