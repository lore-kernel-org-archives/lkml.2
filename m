Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0DNWCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:02:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9381 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab0DNWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:02:42 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADbYxUurR7Hu/2dsb2JhbACbWHGjTpoJhQ0E
X-IronPort-AV: E=Sophos;i="4.52,207,1270425600"; 
   d="scan'208";a="515055862"
Message-ID: <4BC63B7B.7000303@cisco.com>
Date: Wed, 14 Apr 2010 18:02:35 -0400
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux_arch@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
References: <20100412060338.GA24296@dvomlehn-lnx2.corp.sa.net> <20100412145757.7d0297bb.akpm@linux-foundation.org>
In-Reply-To: <20100412145757.7d0297bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 11 Apr 2010 23:03:38 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
>
>   
>> This patch makes panic() and die() registers available to, for example,
>> panic notifier functions.  Panic notifier functions are quite useful
>> for recording crash information, but they don't get passed the register
>> values. This makes it hard to print register contents, do stack
>> backtraces, etc. The changes in this patch save the register state when
>> panic() is called and introduce a function for die() to call that allows
>> it to pass in the registers it was passed.
>>
>> Following this patch are more patches, one per architecture. These include
>> two types of changes:
>> o  A save_ptregs() function for the processor. I've taken a whack at
>>    doing this for all of the processors. I have tested x86 and MIPS
>>    versions. I was able to find cross compilers for ARM, ... and the
>>    code compiles cleanly. Everything else, well, what you see is sheer
>>    fantasy. You are welcome to chortle with merriment.
>> o  When I could figure it out, I replaced the calls to panic() in
>>    exception handling functions with calls to panic_with_regs() so
>>    that everyone can leverage these changes without much effort. Again,
>>    not all the code was transparent, so there are likely some places
>>    that should have additional work done.
>>
>> Note that the pointer to the struct pt_regs may be NULL. This is to
>> accomodate those processors which don't have a working save_ptregs(). I'd
>> love to eliminate this case by providing a save_ptregs() for all
>> architectures, but I'll need help to so.
>>
>>     
>
> It would make life easier if you could describe (or send) a means by
> which arch maintainers can easily test these changes.
>   
Great idea. It should be pretty easy to brew up an LKM to do this.
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>>
>> ...
>>
>> +/* Registers stored in calls to panic() */
>> +static DEFINE_PER_CPU(struct pt_regs, panic_panic_regs);
>> +static DEFINE_PER_CPU(const struct pt_regs *, panic_regs);
>> +
>> +/**
>> + * get_panic_regs - return the current pointer to panic register values
>> + */
>> +const struct pt_regs *get_panic_regs()
>> +{
>> +	return __get_cpu_var(panic_regs);
>> +}
>> +EXPORT_SYMBOL(get_panic_regs);
>> +
>> +/**
>> + * set_panic_regs - Set a pointer to the values of registers on panic()
>> + * @new_regs:	Pointer to register values
>> + *
>> + * Returns: Pointer to the previous panic registers, if any.
>> + */
>> +const struct pt_regs *set_panic_regs(const struct pt_regs *new_regs)
>> +{
>> +	const struct pt_regs *old_regs, **pp_regs;
>> +
>> +	pp_regs = &__get_cpu_var(panic_regs);
>> +	old_regs = *pp_regs;
>> +	*pp_regs = new_regs;
>> +	return old_regs;
>> +}
>>     
>
> What's going on here?  We define storage for a set of pt_regs and also
> storage for a set of pt_regs pointers, and provide the ability for
> callers to rewrite the thing which the pt_regs*'s point at.
>   
It's a stack of pt_regs. It's not on the processor's stack since that 
would use a fair
amount of memory. In this way, it is possible to construct code to handle
nested exceptions. Since, on some processors, interrupts are handle the 
same as
other exceptions, so nested exceptions are fairly common. On the other hand,
if the consensus is that this is not going to be used, I'm find with 
just keeping
around a pointer.

It should be possible to have an interface which doesn't preclude 
pt_regs stacks
but which is simpler, so I'll shoot for that.
> Seems complex.  Why not simply provide a set of pt_regs and permit
> callers to copy their own pt_regs sets into that area?
>   
I was trying to avoid overflowing the panic-time stack with pt_regs. My 
32-bit
MIPS pt_regs is around 160 bytes. I think the 64-bit MIPS pt_regs is about
twice that. That's enough that it gave me pause. But other points of 
view would
be helpful.
> Secondly, this code implicitly assumes that the panicing code is pinned
> to the panicing CPU and cannot be preempted and migrated to a different
> CPU.  Is that true - do we take steps to ensure this anywhere?
>   
The get_panic_regs() functions is intended to be called only from panic 
notifier
functions. In the patch, these are now called from vpanic_with_regs, which
is called from panic() and panic_with_regs(), both of which disable
preemption, so I think the code won't slip off the right processor. Assuming
that's right, I can make it clearer that get_panic_regs() should only be
called from a panic notifier function. Enforcing such a restriction from
a panic notifier function seems fruitless--what would I do, panic?
> Thirdly and relatedly, the code assumes that callers have disabled
> preemption (otherwise __get_cpu_var->smp_processor_id() will whine). 
> Where does this get reliably assured?
>   
I think this is covered above, with the caveat that it really has to be 
plain
that you shouldn't call get_panic_regs() unless you are in a panic notifier
function.
--
David VL
