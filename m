Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1JMSBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:01:55 -0400
Received: from claw.goop.org ([74.207.240.146]:49838 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1JMSBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:01:53 -0400
Message-ID: <4E971580.6030300@goop.org>
Date: Thu, 13 Oct 2011 09:44:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins>
In-Reply-To: <1318503245.24856.12.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 03:54 AM, Peter Zijlstra wrote:
> On Wed, 2011-10-12 at 17:51 -0700, Jeremy Fitzhardinge wrote:
>> This is is all unnecessary complication if you're not using PV ticket
>> locks, it also uses the jump-label machinery to use the standard
>> "add"-based unlock in the non-PV case.
>>
>>         if (TICKET_SLOWPATH_FLAG &&
>>             unlikely(static_branch(&paravirt_ticketlocks_enabled))) {
>>                 arch_spinlock_t prev;
>>
>>                 prev = *lock;
>>                 add_smp(&lock->tickets.head, TICKET_LOCK_INC);
>>
>>                 /* add_smp() is a full mb() */
>>
>>                 if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
>>                         __ticket_unlock_slowpath(lock, prev);
>>         } else
>>                 __add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX); 
> Not that I mind the jump_label usage, but didn't paravirt have an
> existing alternative() thingy to do things like this? Or is the
> alternative() stuff not flexible enough to express this?

Yeah, that's a good question.  There are three mechanisms with somewhat
overlapping concerns:

  * alternative()
  * pvops patching
  * jump_labels

Alternative() is for low-level instruction substitution, and really only
makes sense at the assembler level with one or two instructions.

pvops is basically a collection of ordinary _ops structures full of
function pointers, but it has a layer of patching to help optimise it. 
In the common case, this just replaces an indirect call with a direct
one, but in some special cases it can inline code.  This is used for
small, extremely performance-critical things like cli/sti, but it
awkward to use in general because you have to specify the inlined code
as a parameterless asm.

Jump_labels is basically an efficient way of doing conditionals
predicated on rarely-changed booleans - so it's similar to pvops in that
it is effectively a very ordinary C construct optimised by dynamic code
patching.


So for _arch_spin_unlock(), what I'm trying to go for is that if you're
not using PV ticketlocks, then the unlock sequence is unchanged from
normal.  But also, even if you are using PV ticketlocks, I want the
fastpath to be inlined, with the call out to a special function only
happening on the slow path.  So the result is that if().  If the
static_branch is false, then the executed code sequence is:

	nop5
	addb $2, (lock)
	ret

which is pretty much ideal.  If the static_branch is true, then it ends
up being:

	jmp5 1f
	[...]

1:	lock add $2, (lock)
	test $1, (lock.tail)
	jne slowpath
	ret
slowpath:...

which is also pretty good, given all the other constraints.

While I could try use inline patching to get a simply add for the non-PV
unlock case (it would be awkward without asm parameters), but I wouldn't
be able to also get the PV unlock fastpath code to be (near) inline. 
Hence jump_label.

Thanks,
    J
