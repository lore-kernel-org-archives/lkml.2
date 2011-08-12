Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1HLClv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:41:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33064 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1HLClt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:41:49 -0400
X-AuditID: b753bd60-9ea82ba000000655-ac-4e4492ea8b1e
X-AuditID: b753bd60-9ea82ba000000655-ac-4e4492ea8b1e
Message-ID: <4E4492E5.8030600@hitachi.com>
Date: Fri, 12 Aug 2011 11:41:41 +0900
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
Subject: Re: [PATCH 5/5][RFC] kprobes: Use ftrace hooks when probing ftrace
 nops
References: <20110810162222.017387055@goodmis.org>  <20110810163039.000615163@goodmis.org>  <4E4387A7.7040200@hitachi.com> <1313068956.18583.309.camel@gandalf.stny.rr.com>
In-Reply-To: <1313068956.18583.309.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/11 22:22), Steven Rostedt wrote:
> On Thu, 2011-08-11 at 16:41 +0900, Masami Hiramatsu wrote:
>> Hi Steven,
>>
>> As I suggested in another reply, I'm now attracted by the idea
>> of using ftrace in kprobe-tracer, because of simplicity.
>> Anyway, here is my review.
>
> It may be a little simpler, but it defeats the purpose of what I'm
> trying to accomplish. I do want the ability to expand this to do other
> things than just trace_kprobe.

OK, could you tell me what would you like to accomplish with this?
I thought this was a challange to trace function arguments with
low-overhead. And if so, I think expanding trace_kprobe (a.k.a.
dynamic-events) to handle ftrace with pt_regs is a better way.

What is the good point to expand kprobes itself instead of using
ftrace directly?

If you consider -mfentry reduces the kprobes usefulness because
it prevents probe function entry, I think we can put kprobes
just after mcount code  because mcount code does not change anything,
and this doesn't affect anything.

E.g. if user puts kprobe on a function+0, it automatically moved
to function+5, but kp->addr is still same as the function address.
With this change, we don't need to change anything. User will see
the IP address in pre_handler() is function+6 (5 for mcount and 1
for int3), and it will be acceptable because real probed IP address
must be gotten from kp->addr.


>> (2011/08/11 1:22), Steven Rostedt wrote:
>>> From: Steven Rostedt <srostedt@redhat.com>
>>>
>>> Currently, if a probe is set at an ftrace nop, the probe will fail.
>>>
>>> When -mfentry is used by ftrace (in the near future), the nop will be
>>> at the beginning of the function. This will prevent kprobes from hooking
>>> to the most common place that kprobes are attached.
>>>
>>> Now that ftrace supports individual users as well as pt_regs passing,
>>> kprobes can use the ftrace infrastructure when a probe is placed on
>>> a ftrace nop.
>>
>> My one general concern is the timing of enabling ftrace-based probe.
>> Breakpoint-based kprobe (including optimized kprobe) is enabled
>> right after registering. Users might expect that.
>> And AFAIK, dynamic ftraces handler will be enabled (activated)
>> after a while, because it has to wait for an NMI, doesn't it?
>
> There's no NMI needed. Not sure where you got that idea. When
> register_ftrace_function() is called, it will start tracing immediately.
> Note, stop_machine() is called, but we could fix that in the future too.

Ah, I see. So timing issue will be minor (even though calling stop_machine()
each time might be solved).

>> And theoretically, this ftrace-based probe can't support jprobe,
>> because it changes IP address. Nowadays, this may becomes minor
>> problem (because someone who wants to trace function args can
>> use kprobe-tracer), but still exist.
>
> I want to fix that too. :)
>
> We don't need to worry about that until -mfentry exists. But once that
> does, then, yes, I want the ftrace version working for jprobe too.

OK, changing IP is not so hard.


>>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>> ---
>>>  include/linux/kprobes.h |    6 ++
>>>  kernel/kprobes.c        |  163 ++++++++++++++++++++++++++++++++++++++++++++---
>>>  2 files changed, 160 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>>> index dd7c12e..5742071 100644
>>> --- a/include/linux/kprobes.h
>>> +++ b/include/linux/kprobes.h
>>> @@ -37,6 +37,7 @@
>>>  #include <linux/spinlock.h>
>>>  #include <linux/rcupdate.h>
>>>  #include <linux/mutex.h>
>>> +#include <linux/ftrace.h>
>>>
>>>  #ifdef CONFIG_KPROBES
>>>  #include <asm/kprobes.h>
>>> @@ -112,6 +113,11 @@ struct kprobe {
>>>  	/* copy of the original instruction */
>>>  	struct arch_specific_insn ainsn;
>>>
>>> +#ifdef CONFIG_FUNCTION_TRACER
>>> +	/* If it is possible to use ftrace to probe */
>>> +	struct ftrace_ops fops;
>>> +#endif
>>> +
>>>  	/*
>>>  	 * Indicates various status flags.
>>>  	 * Protected by kprobe_mutex after this kprobe is registered.
>>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>>> index e6c25eb..2160768 100644
>>> --- a/kernel/kprobes.c
>>> +++ b/kernel/kprobes.c
>>> @@ -102,6 +102,31 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
>>>  	{NULL}    /* Terminator */
>>>  };
>>>
>>> +#ifdef CONFIG_FUNCTION_TRACER
>>> +/* kprobe stub function for use when probe is not connected to ftrace */
>>> +static void
>>> +kprobe_ftrace_stub(unsigned long ip, unsigned long pip,
>>> +		   struct ftrace_ops *op, struct pt_regs *pt_regs)
>>> +{
>>> +}
>>> +
>>> +static bool ftrace_kprobe(struct kprobe *p)
>>> +{
>>> +	return p->fops.func && p->fops.func != kprobe_ftrace_stub;
>>> +}
>>> +
>>> +static void init_non_ftrace_kprobe(struct kprobe *p)
>>> +{
>>> +	p->fops.func = kprobe_ftrace_stub;
>>> +}
>>> +
>>> +#else
>>> +static bool ftrace_kprobe(struct kprobe *p)
>>> +{
>>> +	return false;
>>> +}
>>> +#endif
>>> +
>>>  #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
>>>  /*
>>>   * kprobe->ainsn.insn points to the copy of the instruction to be
>>> @@ -396,6 +421,9 @@ static __kprobes void free_aggr_kprobe(struct kprobe *p)
>>>  {
>>>  	struct optimized_kprobe *op;
>>>
>>> +	if (ftrace_kprobe(p))
>>> +		return;
>>> +
>>>  	op = container_of(p, struct optimized_kprobe, kp);
>>>  	arch_remove_optimized_kprobe(op);
>>>  	arch_remove_kprobe(p);
>>> @@ -759,6 +787,9 @@ static __kprobes void try_to_optimize_kprobe(struct
kprobe *p)
>>>  	struct kprobe *ap;
>>>  	struct optimized_kprobe *op;
>>>
>>> +	if (ftrace_kprobe(p))
>>> +		return;
>>> +
>>>  	ap = alloc_aggr_kprobe(p);
>>>  	if (!ap)
>>>  		return;
>>> @@ -849,6 +880,10 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
>>>  {
>>>  	struct kprobe *_p;
>>>
>>> +	/* Only arm non-ftrace probes */
>>> +	if (ftrace_kprobe(p))
>>> +		return;
>>> +
>>>  	/* Check collision with other optimized kprobes */
>>>  	_p = get_optimized_kprobe((unsigned long)p->addr);
>>>  	if (unlikely(_p))
>>> @@ -864,6 +899,10 @@ static void __kprobes __disarm_kprobe(struct kprobe *p,
>> bool reopt)
>>>  {
>>>  	struct kprobe *_p;
>>>
>>> +	/* Only disarm non-ftrace probes */
>>> +	if (ftrace_kprobe(p))
>>> +		return;
>>> +
>>>  	unoptimize_kprobe(p, false);	/* Try to unoptimize */
>>>
>>>  	if (!kprobe_queued(p)) {
>>> @@ -878,13 +917,26 @@ static void __kprobes __disarm_kprobe(struct kprobe *p,
>> bool reopt)
>>>
>>>  #else /* !CONFIG_OPTPROBES */
>>>
>>> +static void __kprobes __arm_kprobe(struct kprobe *p)
>>> +{
>>> +	/* Only arm non-ftrace probes */
>>> +	if (!ftrace_kprobe(p))
>>> +		arch_arm_kprobe(p);
>>> +}
>>> +
>>> +/* Remove the breakpoint of a probe. Must be called with text_mutex locked */
>>> +static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
>>> +{
>>> +	/* Only disarm non-ftrace probes */
>>> +	if (!ftrace_kprobe(p))
>>> +		arch_disarm_kprobe(p);
>>> +}
>>
>> If it ignores disabling/enabling, kprobe_ftrace_callback must
>> check kprobe_disabled(p) and skip it.
>
> No, the callers of __(dis)arm_kprobe() also call the (dis)arm_kprobe()
> later, which calls (un)register_ftrace_function(). The reason we can't
> call the ftrace register functions here is because they call
> stop_machine() and then we get into a deadlock with the text_mutex. The
> places that call __(dis)arm_kprobe() later call (dis)arm_kprobe() after
> releasing the text_mutex.

OK.

>>> +
>>>  #define optimize_kprobe(p)			do {} while (0)
>>>  #define unoptimize_kprobe(p, f)			do {} while (0)
>>>  #define kill_optimized_kprobe(p)		do {} while (0)
>>>  #define prepare_optimized_kprobe(p)		do {} while (0)
>>>  #define try_to_optimize_kprobe(p)		do {} while (0)
>>> -#define __arm_kprobe(p)				arch_arm_kprobe(p)
>>> -#define __disarm_kprobe(p, o)			arch_disarm_kprobe(p)
>>>  #define kprobe_disarmed(p)			kprobe_disabled(p)
>>>  #define wait_for_kprobe_optimizer()		do {} while (0)
>>>
>>> @@ -897,7 +949,9 @@ static void reuse_unused_kprobe(struct kprobe *ap)
>>>
>>>  static __kprobes void free_aggr_kprobe(struct kprobe *p)
>>>  {
>>> -	arch_remove_kprobe(p);
>>> +
>>> +	if (!ftrace_kprobe(p))
>>> +		arch_remove_kprobe(p);
>>>  	kfree(p);
>>>  }
>>>
>>> @@ -910,6 +964,12 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct
>> kprobe *p)
>>>  /* Arm a kprobe with text_mutex */
>>>  static void __kprobes arm_kprobe(struct kprobe *kp)
>>>  {
>>> +	/* ftrace probes can skip arch calls */
>>> +	if (ftrace_kprobe(kp)) {
>>> +		register_ftrace_function(&kp->fops);
>>> +		return;
>>> +	}
>>> +
>>>  	/*
>>>  	 * Here, since __arm_kprobe() doesn't use stop_machine(),
>>>  	 * this doesn't cause deadlock on text_mutex. So, we don't
>>> @@ -924,6 +984,12 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
>>>  static void __kprobes disarm_kprobe(struct kprobe *kp)
>>>  {
>>>  	/* Ditto */
>>> +
>>> +	if (ftrace_kprobe(kp)) {
>>> +		unregister_ftrace_function(&kp->fops);
>>> +		return;
>>> +	}
>>> +
>>>  	mutex_lock(&text_mutex);
>>>  	__disarm_kprobe(kp, true);
>>>  	mutex_unlock(&text_mutex);
>>> @@ -1313,6 +1379,56 @@ static inline int check_kprobe_rereg(struct kprobe *p)
>>>  	return ret;
>>>  }
>>>
>>> +#ifdef CONFIG_FUNCTION_TRACER
>>> +static notrace void
>>> +kprobe_ftrace_callback(unsigned long ip, unsigned long parent_ip,
>>> +		       struct ftrace_ops *op, struct pt_regs *pt_regs)
>>> +{
>>> +	struct kprobe *p = container_of(op, struct kprobe, fops);
>>> +
>>
>> Here, we need to set up kprobe_ctlblk and some of pt_regs members,
>> ip, cs and orig_ax as optimized_callback()@arch/x86/kernel/kprobes.c
>> does.
>
> I'm curious to what this is used for? It doesn't seem to be needed for
> the generic kprobes. Because we know the probe was on a nop, there's no
> need to simulate the operation. IOW, there's no need for singlestep() or
> other gdb like operations.

That is not for the singlestep but the handler may expect that, because
kprobes handler doesn't know it is hit on a breakpoint, jump or mcount
call.
So, we have to simulate it as much as possible. Or, it's not the kprobes.


>>
>>> +	/* A nop has been trapped, just run both handlers back to back */
>>> +	if (p->pre_handler)
>>> +		p->pre_handler(p, pt_regs);
>>
>> And increment regs->ip here for NOP.
>
> Does the post_handler() expect the ip to be after the call? Thus a
> post_handle() is the same as pre_handle() on rip+next_ins?

Usually, post_handler() is for watching the behavior of probed
instruction. If the kprobe puts a breakpoint on "addl $10, %eax",
post_handler() will see the value of %eax is incremented by 10.

>>> +	if (p->post_handler)
>>> +		p->post_handler(p, pt_regs, 0);
>>> +}
>>
>> Anyway, above operations strongly depends on arch, so
>> kprobe_ftrace_callback should be moved to arch/*/kprobes.c.
>>
>> And I think most of the code can be shared with optimized code.
>
> Not sure why. Except if regs->ip needs to be incremented. And that can
> be a per arch header file. Remember, the ftrace version has no need for
> single stepping like the optimized version does. ftrace replaces a nop,
> where as other kprobes replace actual instructions. This is what make
> the ftrace version so much less complex.

Yeah, I just meant about preparing code. Hmm, putting that kind of
register fixup in the arch header may be a good idea.

>>> +
>>> +static int use_ftrace_hook(struct kprobe *p)
>>> +{
>>> +	char str[KSYM_SYMBOL_LEN];
>>> +
>>> +	/* see if this is an ftrace function */
>>> +	if (!ftrace_text_reserved(p->addr, p->addr)) {
>>> +		/* make sure fops->func is nop */
>>> +		init_non_ftrace_kprobe(p);
>>> +		return 0;
>>> +	}
>>> +
>>> +	/* If arch does not support pt_regs passing, bail */
>>> +	if (!ARCH_SUPPORTS_FTRACE_SAVE_REGS)
>>> +		return -EINVAL;
>>
>> Hmm, I think this should be checked at build time...
>
> This is actually keeping the same logic that exists now. See below, we
> removed the check of ftrace_text_reserved() from the conditions that
> make register_kprobe() return -EINVAL. Now if the arch supports
> FTRACE_SAVE_REGS, it can handle the ftrace_text_reserved(), if not, then
> it goes back to its original behavior.
>
> The only way to remove the later code is with #ifdef ugliness, and I
> didn't want to add that.

OK, it's for avoiding ugliness.

>
>>
>>> +
>>> +	/* Use ftrace hook instead */
>>> +
>>> +	memset(&p->fops, 0, sizeof(p->fops));
>>> +
>>> +	/* Find the function this is connected with this addr */
>>> +	kallsyms_lookup((unsigned long)p->addr, NULL, NULL, NULL, str);
>>> +
>>> +	p->fops.flags = FTRACE_OPS_FL_SAVE_REGS;
>>> +	p->fops.func = kprobe_ftrace_callback;
>>> +
>>> +	ftrace_set_filter(&p->fops, str, strlen(str), 1);
>>
>> Hmm, IMHO, ftrace_set_filter should not be called here, because
>> there can be other kprobes are already registered on the same
>> address. In that case, it is natural that we use an aggr_kprobe
>> for handling several kprobes on same address. Or, kprobe hash table
>> will have several different probes on same address.
>
> The ftrace_set_filter() only updates the p->fops to what it will trace.
> It's the register_ftrace_function() that enables the ftrace tracing, and
> that is done with the arm_kprobe() call. If that's where the aggr_kprobe
> enables its call, then that will be the only probe that is called.

Ah, OK, I see. so ftrace_set_filter() just prepares p->fops, not
registers something in ftrace.


> Now I need to re-examine how the aggr_kprobes work. Does it have its own
> handler to call multiple probe->handlers?

Yes, aggr_pre/fault/post/break_handler() are those.

>>> +
>>> +	return 0;
>>> +}
>>> +#else
>>> +static int use_ftrace_hook(struct kprobe *p)
>>> +{
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>>  int __kprobes register_kprobe(struct kprobe *p)
>>>  {
>>>  	int ret = 0;
>>> @@ -1329,11 +1445,14 @@ int __kprobes register_kprobe(struct kprobe *p)
>>>  	if (ret)
>>>  		return ret;
>>>
>>> +	ret = use_ftrace_hook(p);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>  	jump_label_lock();
>>>  	preempt_disable();
>>>  	if (!kernel_text_address((unsigned long) p->addr) ||
>>>  	    in_kprobes_functions((unsigned long) p->addr) ||
>>> -	    ftrace_text_reserved(p->addr, p->addr) ||
>>>  	    jump_label_text_reserved(p->addr, p->addr))
>>>  		goto fail_with_jump_label;
>>>
>>> @@ -1384,15 +1503,17 @@ int __kprobes register_kprobe(struct kprobe *p)
>>>  		goto out;
>>>  	}
>>>
>>> -	ret = arch_prepare_kprobe(p);
>>> -	if (ret)
>>> -		goto out;
>>> +	if (!ftrace_kprobe(p)) {
>>> +		ret = arch_prepare_kprobe(p);
>>> +		if (ret)
>>> +			goto out;
>>> +	}
>>>
>>>  	INIT_HLIST_NODE(&p->hlist);
>>>  	hlist_add_head_rcu(&p->hlist,
>>>  		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
>>>
>>> -	if (!kprobes_all_disarmed && !kprobe_disabled(p))
>>> +	if (!ftrace_kprobe(p) && !kprobes_all_disarmed && !kprobe_disabled(p))
>>>  		__arm_kprobe(p);
>>>
>>>  	/* Try to optimize kprobe */
>>> @@ -1400,6 +1521,12 @@ int __kprobes register_kprobe(struct kprobe *p)
>>>
>>>  out:
>>>  	mutex_unlock(&text_mutex);
>>> +
>>> +	/* ftrace kprobes must be set outside of text_mutex */
>>> +	if (!ret && ftrace_kprobe(p) &&
>>> +	    !kprobes_all_disarmed && !kprobe_disabled(p))
>>> +		arm_kprobe(p);
>>> +
>>>  	put_online_cpus();
>>>  	jump_label_unlock();
>>>  	mutex_unlock(&kprobe_mutex);
>>
>> After this, we must handle some fails which can happen when probing
>> on a module.
>
> What problems that were added by ftrace that isn't a problem with normal
> probes?

It was my misunderstand of ftrace_set_filter(). No need to do anything.

>
>>
>>
>>> @@ -2134,6 +2261,14 @@ static void __kprobes arm_all_kprobes(void)
>>>  	}
>>>  	mutex_unlock(&text_mutex);
>>>
>>> +	/* ftrace kprobes are enabled outside of text_mutex */
>>> +	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>>> +		head = &kprobe_table[i];
>>> +		hlist_for_each_entry_rcu(p, node, head, hlist)
>>> +			if (ftrace_kprobe(p) && !kprobe_disabled(p))
>>> +				arm_kprobe(p);
>>> +	}
>>> +
>>>  	kprobes_all_disarmed = false;
>>>  	printk(KERN_INFO "Kprobes globally enabled\n");
>>>
>>> @@ -2164,11 +2299,21 @@ static void __kprobes disarm_all_kprobes(void)
>>>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>>>  		head = &kprobe_table[i];
>>>  		hlist_for_each_entry_rcu(p, node, head, hlist) {
>>> -			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
>>> +			if (!ftrace_kprobe(p) &&
>>> +			    !arch_trampoline_kprobe(p) && !kprobe_disabled(p))
>>>  				__disarm_kprobe(p, false);
>>>  		}
>>>  	}
>>>  	mutex_unlock(&text_mutex);
>>> +
>>> +	/* ftrace kprobes are disabled outside of text_mutex */
>>> +	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>>> +		head = &kprobe_table[i];
>>> +		hlist_for_each_entry_rcu(p, node, head, hlist) {
>>> +			if (ftrace_kprobe(p) && !kprobe_disabled(p))
>>> +				disarm_kprobe(p);
>>> +		}
>>> +	}
>>>  	mutex_unlock(&kprobe_mutex);
>>>
>>>  	/* Wait for disarming all kprobes by optimizer */
>>
>> Thank you,
>>
>
> Thanks for taking the time for your review!
>
> -- Steve
>
>


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
