Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1I1OBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:01:52 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30396 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1I1OBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:01:50 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zzbb2dK9371Kdf9M1432N98dKzz1202hzz8275bhz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LS8K66-01-1DX-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Wed, 28 Sep 2011 15:58:55 +0200
Message-ID: <33782147.oLTY4kzH1r@chlor>
Organization: AMD OSRC
User-Agent: KMail/4.7.0  (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E81FD52.50106@goop.org>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, 12:44:02 Jeremy Fitzhardinge wrote:
> On 09/27/2011 02:34 AM, Stephan Diestelhorst wrote:
> > On Wednesday 14 September 2011, 17:31:32 Jeremy Fitzhardinge wrote:
> >> This series replaces the existing paravirtualized spinlock mechanism
> >> with a paravirtualized ticketlock mechanism.
> > [...] 
> >> The unlock code is very straightforward:
> >> 	prev = *lock;
> >> 	__ticket_unlock_release(lock);
> >> 	if (unlikely(__ticket_in_slowpath(lock)))
> >> 		__ticket_unlock_slowpath(lock, prev);
> >>
> >> which generates:
> >> 	push   %rbp
> >> 	mov    %rsp,%rbp
> >>
> >>     movzwl (%rdi),%esi
> >> 	addb   $0x2,(%rdi)
> >>     movzwl (%rdi),%eax
> >> 	testb  $0x1,%ah
> >> 	jne    1f
> >>
> >> 	pop    %rbp
> >> 	retq   
> >>
> >> 	### SLOWPATH START
> >> 1:	movzwl (%rdi),%edx
> >> 	movzbl %dh,%ecx
> >> 	mov    %edx,%eax
> >> 	and    $-2,%ecx	# clear TICKET_SLOWPATH_FLAG
> >> 	mov    %cl,%dh
> >> 	cmp    %dl,%cl	# test to see if lock is uncontended
> >> 	je     3f
> >>
> >> 2:	movzbl %dl,%esi
> >> 	callq  *__ticket_unlock_kick	# kick anyone waiting
> >> 	pop    %rbp
> >> 	retq   
> >>
> >> 3:	lock cmpxchg %dx,(%rdi)	# use cmpxchg to safely write back flag
> >> 	jmp    2b
> >> 	### SLOWPATH END
> > [...]
> >> Thoughts? Comments? Suggestions?
> > You have a nasty data race in your code that can cause a losing
> > acquirer to sleep forever, because its setting the TICKET_SLOWPATH flag
> > can race with the lock holder releasing the lock.
> >
> > I used the code for the slow path from the GIT repo.
> >
> > Let me try to point out an interleaving:
> >
> > Lock is held by one thread, contains 0x0200.
> >
> > _Lock holder_                   _Acquirer_
> >                                 mov    $0x200,%eax
> >                                 lock xadd %ax,(%rdi)
> >                                 // ax:= 0x0200, lock:= 0x0400
> >                                 ...
> >                                 // this guy spins for a while, reading
> >                                 // the lock
> >                                 ...
> > //trying to free the lock
> > movzwl (%rdi),%esi (esi:=0x0400)
> > addb   $0x2,(%rdi) (LOCAL copy of lock is now: 0x0402)
> > movzwl (%rdi),%eax (local forwarding from previous store: eax := 0x0402)
> > testb  $0x1,%ah    (no wakeup of anybody)
> > jne    1f
> >
> >                                 callq  *__ticket_lock_spinning
> >                                   ...
> >                                   // __ticket_enter_slowpath(lock)
> >                                   lock or (%rdi), $0x100
> >                                   // (global view of lock := 0x0500)
> > 						...
> >                                   ACCESS_ONCE(lock->tickets.head) == want
> >                                   // (reads 0x00)
> > 						...
> >                                   xen_poll_irq(irq); // goes to sleep
> > ...
> > [addb   $0x2,(%rdi)]
> > // (becomes globally visible only now! global view of lock := 0x0502)
> > ...
> >
> > Your code is reusing the (just about) safe version of unlocking a
> > spinlock without understanding the effect that close has on later
> > memory ordering. It may work on CPUs that cannot do narrow -> wide
> > store to load forwarding and have to make the addb store visible
> > globally. This is an implementation artifact of specific uarches, and
> > you mustn't rely on it, since our specified memory model allows looser
> > behaviour.
> 
> Ah, thanks for this observation.  I've seen this bug before when I
> didn't pay attention to the unlock W vs flag R ordering at all, and I
> was hoping the aliasing would be sufficient - and certainly this seems
> to have been OK on my Intel systems.  But you're saying that it will
> fail on current AMD systems?

I have tested this and have not seen it fail on publicly released AMD
systems. But as I have tried to point out, this does not mean it is
safe to do in software, because future microarchtectures may have more
capable forwarding engines.

> Have you tested this, or is this just from code analysis (which I
> agree with after reviewing the ordering rules in the Intel manual).

We have found a similar issue in Novell's PV ticket lock implementation
during internal product testing.

> > Since you want to get that addb out to global memory before the second
> > read, either use a LOCK prefix for it, add an MFENCE between addb and
> > movzwl, or use a LOCKed instruction that will have a fencing effect
> > (e.g., to top-of-stack)between addb and movzwl.
> 
> Hm.  I don't really want to do any of those because it will probably
> have a significant effect on the unlock performance; I was really trying
> to avoid adding any more locked instructions.  A previous version of the
> code had an mfence in here, but I hit on the idea of using aliasing to
> get the ordering I want - but overlooked the possible effect of store
> forwarding.

Well, I'd be curious about the actual performance impact. If the store
needs to commit to memory due to aliasing anyways, this would slow down
execution, too. After all it is better to write working than fast code,
no? ;-)

> I guess it comes down to throwing myself on the efficiency of some kind
> of fence instruction.  I guess an lfence would be sufficient; is that
> any more efficient than a full mfence?

An lfence should not be sufficient, since that essentially is a NOP on
WB memory. You really want a full fence here, since the store needs to
be published before reading the lock with the next load.

> At least I can make it so that its only present when pv ticket locks
> are actually in use, so it won't affect the native case.

That would be a good thing, indeed. Of course, always relative to an
actual performance comparison.

> Could you give me a pointer to AMD's description of the ordering rules?

They should be in "AMD64 Architecture Programmer's Manual Volume 2:
System Programming", Section 7.2 Multiprocessor Memory Access Ordering.

http://developer.amd.com/documentation/guides/pages/default.aspx#manuals

Let me know if you have some clarifying suggestions. We are currently
revising these documents...

Cheers,
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


