Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HLC5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:57:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45262 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1HLC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:57:07 -0400
X-AuditID: b753bd60-a1479ba0000050a4-a1-4e44967fab81
X-AuditID: b753bd60-a1479ba0000050a4-a1-4e44967fab81
Message-ID: <4E44967C.1090101@hitachi.com>
Date: Fri, 12 Aug 2011 11:57:00 +0900
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
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace
 nops
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com>  <1313022842.18583.282.camel@gandalf.stny.rr.com>  <4E43769C.9000901@hitachi.com> <1313067691.18583.290.camel@gandalf.stny.rr.com>
In-Reply-To: <1313067691.18583.290.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/11 22:01), Steven Rostedt wrote:
> On Thu, 2011-08-11 at 15:28 +0900, Masami Hiramatsu wrote:
>> (2011/08/11 9:34), Steven Rostedt wrote:
>>> On Thu, 2011-08-11 at 09:21 +0900, Masami Hiramatsu wrote:
>>>> Hi Steven,
>>>>
>>>> Thanks for this nice feature!
>>>>
>>>> (2011/08/11 1:22), Steven Rostedt wrote:
>>>>> Hi All,
>>>>>
>>>>> I started working on adding the -mfentry switch to ftrace, which
>>>>> allows us to remove the frame pointers requirement from function tracing
>>>>> as well as makes mcount (fentry) work just better.
>>>>>
>>>>> But when I did this in another branch, I noticed that I broke kprobes
>>>>> in its most common usage. The attaching a probe at the beginning of
>>>>> a function to use get to its parameters.
>>>>>
>>>>> So I started this branch. This branch is to have kprobes use ftrace
>>>>> directly when a probe is attached to a ftrace nop. Currently, kprobes
>>>>> will just error when that happens. With this patch set, it will hook
>>>>> into the ftrace infrastructure and use ftrace instead. This is more
>>>>> like an optimized probe as no breakpoints need to be set. A call to
>>>>> the function is done directly via the mcount trampoline. If ftrace
>>>>> pt_regs is implemented for an arch, kprobes gets this feature for free.
>>>>
>>>> I agreed this idea, this looks good to me too :)
>>>> With -fentry, this can improve dynamic trace events very much.
>>>>
>>>> BTW (OT), it seems that current kprobe data structure becomes a bit
>>>> fat. Maybe what we need is just a "holder of hooking handler" as
>>>> what ftrace provides, not a full storage data structure of copied
>>>> instrucutions. Perhaps, we'd better diet the kprobe structure for
>>>> transparency of hooking infrastructure.
>>>
>>> Sure, I can make the ftrace_ops field in kprobes dynamically allocated
>>> instead. That shouldn't be an issue.
>>
>> By the way (again), perhaps, much simpler solution is using ftrace
>> not in kprobe, but in the trace_kprobe. Of course, there are several
>> pros and cons...
>>
>> The pros:
>> - Arch independent solution (anyway, ftrace still needs passing pt_regs
>>  to their handler)
>> - Don't need to introduce more complexity into kprobes itself.
>> - Maybe systemtap also can catch up with this as using same method.
>
> Note that systemtap and others will be hooking into kprobes version, not
> the trace_kprobe one. If we do it in trace_kprobe, then everyone else
> needs to reimplement it too.  I have bigger ideas for the future of
> this, and I really want to get this working. If it doesn't work for
> kprobes, then it won't work for anything else.

I don't think it won't work. It can work but on a long way.
Could you tell me your "bigger ideas"? Perhaps, we are on the different
way but aim to same goal.

>> The cons:
>> - Native kprobes users will be disappointed... anyway, they just need to
>>   move their probes to the next instruction (usually addr+=5 is OK).
>
> I've been told that doing the addr+=5 (which is also arch specific) can
> break things for other tools.

As I told in previous mail, I think kprobes can do that transparently.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
