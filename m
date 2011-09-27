Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1I0Je7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:34:59 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:15007
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab1I0Jez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:34:55 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zzdf9M1432N98dKzz1202hzz8275bhz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LS6D9Y-01-2UL-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: <xen-devel@lists.xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Tue, 27 Sep 2011 11:34:45 +0200
Message-ID: <3300108.XQUp9Wrktc@chlor>
Organization: AMD OSRC
User-Agent: KMail/4.7.0  (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
In-Reply-To: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 September 2011, 17:31:32 Jeremy Fitzhardinge wrote:
> This series replaces the existing paravirtualized spinlock mechanism
> with a paravirtualized ticketlock mechanism.
[...] 
> The unlock code is very straightforward:
> 	prev = *lock;
> 	__ticket_unlock_release(lock);
> 	if (unlikely(__ticket_in_slowpath(lock)))
> 		__ticket_unlock_slowpath(lock, prev);
> 
> which generates:
> 	push   %rbp
> 	mov    %rsp,%rbp
> 
>     movzwl (%rdi),%esi
> 	addb   $0x2,(%rdi)
>     movzwl (%rdi),%eax
> 	testb  $0x1,%ah
> 	jne    1f
> 
> 	pop    %rbp
> 	retq   
> 
> 	### SLOWPATH START
> 1:	movzwl (%rdi),%edx
> 	movzbl %dh,%ecx
> 	mov    %edx,%eax
> 	and    $-2,%ecx	# clear TICKET_SLOWPATH_FLAG
> 	mov    %cl,%dh
> 	cmp    %dl,%cl	# test to see if lock is uncontended
> 	je     3f
> 
> 2:	movzbl %dl,%esi
> 	callq  *__ticket_unlock_kick	# kick anyone waiting
> 	pop    %rbp
> 	retq   
> 
> 3:	lock cmpxchg %dx,(%rdi)	# use cmpxchg to safely write back flag
> 	jmp    2b
> 	### SLOWPATH END
[...]
> Thoughts? Comments? Suggestions?

You have a nasty data race in your code that can cause a losing
acquirer to sleep forever, because its setting the TICKET_SLOWPATH flag
can race with the lock holder releasing the lock.

I used the code for the slow path from the GIT repo.

Let me try to point out an interleaving:

Lock is held by one thread, contains 0x0200.

_Lock holder_                   _Acquirer_
                                mov    $0x200,%eax
                                lock xadd %ax,(%rdi)
                                // ax:= 0x0200, lock:= 0x0400
                                ...
                                // this guy spins for a while, reading
                                // the lock
                                ...
//trying to free the lock
movzwl (%rdi),%esi (esi:=0x0400)
addb   $0x2,(%rdi) (LOCAL copy of lock is now: 0x0402)
movzwl (%rdi),%eax (local forwarding from previous store: eax := 0x0402)
testb  $0x1,%ah    (no wakeup of anybody)
jne    1f

                                callq  *__ticket_lock_spinning
                                  ...
                                  // __ticket_enter_slowpath(lock)
                                  lock or (%rdi), $0x100
                                  // (global view of lock := 0x0500)
						...
                                  ACCESS_ONCE(lock->tickets.head) == want
                                  // (reads 0x00)
						...
                                  xen_poll_irq(irq); // goes to sleep
...
[addb   $0x2,(%rdi)]
// (becomes globally visible only now! global view of lock := 0x0502)
...

Your code is reusing the (just about) safe version of unlocking a
spinlock without understanding the effect that close has on later
memory ordering. It may work on CPUs that cannot do narrow -> wide
store to load forwarding and have to make the addb store visible
globally. This is an implementation artifact of specific uarches, and
you mustn't rely on it, since our specified memory model allows looser
behaviour.

Since you want to get that addb out to global memory before the second
read, either use a LOCK prefix for it, add an MFENCE between addb and
movzwl, or use a LOCKed instruction that will have a fencing effect
(e.g., to top-of-stack)between addb and movzwl.

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com
Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo 
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551


