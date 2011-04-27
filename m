Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1D0Avb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:51:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42673 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1D0Ava (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:51:30 -0400
X-AuditID: b753bd60-a3cf3ba000007186-b0-4db7688fe16a
X-AuditID: b753bd60-a3cf3ba000007186-b0-4db7688fe16a
Message-ID: <4DB7688B.7010503@hitachi.com>
Date: Wed, 27 Apr 2011 09:51:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes,x86: disable irq durinr optimized callback
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com> <20110426134625.GA21840@home.goodmis.org> <20110426141903.GC1896@jolsa.brq.redhat.com>
In-Reply-To: <20110426141903.GC1896@jolsa.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/26 23:19), Jiri Olsa wrote:
> On Tue, Apr 26, 2011 at 09:46:25AM -0400, Steven Rostedt wrote:
>> On Tue, Apr 26, 2011 at 03:01:31PM +0200, Jiri Olsa wrote:
>>> hi,
>>>
>>> attached patch is disabling irqs during optimized callback,
>>> so we dont miss any in-irq kprobes as missed.
>>>
>>> Also I think there's small window where current_kprobe variable
>>> could be touched in non-safe way, but I was not able to hit
>>> any issue.
>>>
>>> I'm not sure wether this is a bug or if it was intentional to have
>>> irqs enabled during the pre_handler callback.
>>
>> That's not very convincing. Did you see if we actually did miss events.
>> If that's the case then it is a bug. The conversion to optimizing should
>> not cause events to be missed.
> 
> yep, running following:
> 
> # cd /debug/tracing/
> # echo "p mutex_unlock" >> kprobe_events
> # echo "p _raw_spin_lock" >> kprobe_events
> # echo "p smp_apic_timer_interrupt" >> ./kprobe_events
> # echo 1 > events/enable
> 
> makes the optimized kprobes to be missed. They are not missed in
> same testcase for non-optimized kprobes. I should have mentioned
> that, sry ;)

Good catch! that's right! kprobes' int3 automatically disables
irq, but optimized path doesn't. And that causes unexpected
event loss.


> 
>>
>>
>>>
>>> wbr,
>>> jirka
>>>
>>> ---
>>> Disabling irqs during optimized callback, so we dont miss
>>> any in-irq kprobes as missed.
>>>
>>> Interrupts are also disabled during non-optimized kprobes callbacks.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
>>> ---
>>>  arch/x86/kernel/kprobes.c |    3 +++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
>>> index c969fd9..917cb31 100644
>>> --- a/arch/x86/kernel/kprobes.c
>>> +++ b/arch/x86/kernel/kprobes.c
>>> @@ -1183,11 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
>>>  					 struct pt_regs *regs)
>>>  {
>>>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
>>> +	unsigned long flags;
>>>  
>>>  	/* This is possible if op is under delayed unoptimizing */
>>>  	if (kprobe_disabled(&op->kp))
>>>  		return;
>>>  
>>> +	local_irq_save(flags);
>>>  	preempt_disable();
>>
>> No reason to disable preemption if you disabled interrupts.

Right,

> ops, missed that..  attaching new patch


> ---
> Disabling irqs during optimized callback, so we dont miss
> any in-irq kprobes as missed.
> 
> running following:
> 
> # cd /debug/tracing/
> # echo "p mutex_unlock" >> kprobe_events
> # echo "p _raw_spin_lock" >> kprobe_events
> # echo "p smp_apic_timer_interrupt" >> ./kprobe_events
> # echo 1 > events/enable
> 
> makes the optimized kprobes to be missed. None is missed
> if the kprobe optimatization is disabled.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


Ingo, could you pull this as a bugfix?

Thank you!


> ---
>  arch/x86/kernel/kprobes.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index c969fd9..f1a6244 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1183,12 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
>  					 struct pt_regs *regs)
>  {
>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +	unsigned long flags;
>  
>  	/* This is possible if op is under delayed unoptimizing */
>  	if (kprobe_disabled(&op->kp))
>  		return;
>  
> -	preempt_disable();
> +	local_irq_save(flags);
>  	if (kprobe_running()) {
>  		kprobes_inc_nmissed_count(&op->kp);
>  	} else {
> @@ -1207,7 +1208,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
>  		opt_pre_handler(&op->kp, regs);
>  		__this_cpu_write(current_kprobe, NULL);
>  	}
> -	preempt_enable_no_resched();
> +	local_irq_restore(flags);
>  }
>  
>  static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
