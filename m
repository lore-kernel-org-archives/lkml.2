Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1I0QoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:44:10 -0400
Received: from claw.goop.org ([74.207.240.146]:35189 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1I0QoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:44:08 -0400
Message-ID: <4E81FD52.50106@goop.org>
Date: Tue, 27 Sep 2011 09:44:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: xen-devel@lists.xensource.com, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <3300108.XQUp9Wrktc@chlor>
In-Reply-To: <3300108.XQUp9Wrktc@chlor>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 02:34 AM, Stephan Diestelhorst wrote:
> On Wednesday 14 September 2011, 17:31:32 Jeremy Fitzhardinge wrote:
>> This series replaces the existing paravirtualized spinlock mechanism
>> with a paravirtualized ticketlock mechanism.
> [...] 
>> The unlock code is very straightforward:
>> 	prev = *lock;
>> 	__ticket_unlock_release(lock);
>> 	if (unlikely(__ticket_in_slowpath(lock)))
>> 		__ticket_unlock_slowpath(lock, prev);
>>
>> which generates:
>> 	push   %rbp
>> 	mov    %rsp,%rbp
>>
>>     movzwl (%rdi),%esi
>> 	addb   $0x2,(%rdi)
>>     movzwl (%rdi),%eax
>> 	testb  $0x1,%ah
>> 	jne    1f
>>
>> 	pop    %rbp
>> 	retq   
>>
>> 	### SLOWPATH START
>> 1:	movzwl (%rdi),%edx
>> 	movzbl %dh,%ecx
>> 	mov    %edx,%eax
>> 	and    $-2,%ecx	# clear TICKET_SLOWPATH_FLAG
>> 	mov    %cl,%dh
>> 	cmp    %dl,%cl	# test to see if lock is uncontended
>> 	je     3f
>>
>> 2:	movzbl %dl,%esi
>> 	callq  *__ticket_unlock_kick	# kick anyone waiting
>> 	pop    %rbp
>> 	retq   
>>
>> 3:	lock cmpxchg %dx,(%rdi)	# use cmpxchg to safely write back flag
>> 	jmp    2b
>> 	### SLOWPATH END
> [...]
>> Thoughts? Comments? Suggestions?
> You have a nasty data race in your code that can cause a losing
> acquirer to sleep forever, because its setting the TICKET_SLOWPATH flag
> can race with the lock holder releasing the lock.
>
> I used the code for the slow path from the GIT repo.
>
> Let me try to point out an interleaving:
>
> Lock is held by one thread, contains 0x0200.
>
> _Lock holder_                   _Acquirer_
>                                 mov    $0x200,%eax
>                                 lock xadd %ax,(%rdi)
>                                 // ax:= 0x0200, lock:= 0x0400
>                                 ...
>                                 // this guy spins for a while, reading
>                                 // the lock
>                                 ...
> //trying to free the lock
> movzwl (%rdi),%esi (esi:=0x0400)
> addb   $0x2,(%rdi) (LOCAL copy of lock is now: 0x0402)
> movzwl (%rdi),%eax (local forwarding from previous store: eax := 0x0402)
> testb  $0x1,%ah    (no wakeup of anybody)
> jne    1f
>
>                                 callq  *__ticket_lock_spinning
>                                   ...
>                                   // __ticket_enter_slowpath(lock)
>                                   lock or (%rdi), $0x100
>                                   // (global view of lock := 0x0500)
> 						...
>                                   ACCESS_ONCE(lock->tickets.head) == want
>                                   // (reads 0x00)
> 						...
>                                   xen_poll_irq(irq); // goes to sleep
> ...
> [addb   $0x2,(%rdi)]
> // (becomes globally visible only now! global view of lock := 0x0502)
> ...
>
> Your code is reusing the (just about) safe version of unlocking a
> spinlock without understanding the effect that close has on later
> memory ordering. It may work on CPUs that cannot do narrow -> wide
> store to load forwarding and have to make the addb store visible
> globally. This is an implementation artifact of specific uarches, and
> you mustn't rely on it, since our specified memory model allows looser
> behaviour.

Ah, thanks for this observation.  I've seen this bug before when I
didn't pay attention to the unlock W vs flag R ordering at all, and I
was hoping the aliasing would be sufficient - and certainly this seems
to have been OK on my Intel systems.  But you're saying that it will
fail on current AMD systems?  Have you tested this, or is this just from
code analysis (which I agree with after reviewing the ordering rules in
the Intel manual).

> Since you want to get that addb out to global memory before the second
> read, either use a LOCK prefix for it, add an MFENCE between addb and
> movzwl, or use a LOCKed instruction that will have a fencing effect
> (e.g., to top-of-stack)between addb and movzwl.

Hm.  I don't really want to do any of those because it will probably
have a significant effect on the unlock performance; I was really trying
to avoid adding any more locked instructions.  A previous version of the
code had an mfence in here, but I hit on the idea of using aliasing to
get the ordering I want - but overlooked the possible effect of store
forwarding.

I guess it comes down to throwing myself on the efficiency of some kind
of fence instruction.  I guess an lfence would be sufficient; is that
any more efficient than a full mfence?  At least I can make it so that
its only present when pv ticket locks are actually in use, so it won't
affect the native case.

Could you give me a pointer to AMD's description of the ordering rules?

Thanks,
    J
