Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab1JNOS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:18:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1JNOS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:18:27 -0400
Date: Fri, 14 Oct 2011 10:17:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
Message-ID: <20111014141701.GA2433@redhat.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
 <1318503245.24856.12.camel@twins>
 <4E971580.6030300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E971580.6030300@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 09:44:48AM -0700, Jeremy Fitzhardinge wrote:
> On 10/13/2011 03:54 AM, Peter Zijlstra wrote:
> > On Wed, 2011-10-12 at 17:51 -0700, Jeremy Fitzhardinge wrote:
> >> This is is all unnecessary complication if you're not using PV ticket
> >> locks, it also uses the jump-label machinery to use the standard
> >> "add"-based unlock in the non-PV case.
> >>
> >>         if (TICKET_SLOWPATH_FLAG &&
> >>             unlikely(static_branch(&paravirt_ticketlocks_enabled))) {
> >>                 arch_spinlock_t prev;
> >>
> >>                 prev = *lock;
> >>                 add_smp(&lock->tickets.head, TICKET_LOCK_INC);
> >>
> >>                 /* add_smp() is a full mb() */
> >>
> >>                 if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
> >>                         __ticket_unlock_slowpath(lock, prev);
> >>         } else
> >>                 __add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX); 
> > Not that I mind the jump_label usage, but didn't paravirt have an
> > existing alternative() thingy to do things like this? Or is the
> > alternative() stuff not flexible enough to express this?
> 
> Yeah, that's a good question.  There are three mechanisms with somewhat
> overlapping concerns:
> 
>   * alternative()
>   * pvops patching
>   * jump_labels
> 
> Alternative() is for low-level instruction substitution, and really only
> makes sense at the assembler level with one or two instructions.
> 
> pvops is basically a collection of ordinary _ops structures full of
> function pointers, but it has a layer of patching to help optimise it. 
> In the common case, this just replaces an indirect call with a direct
> one, but in some special cases it can inline code.  This is used for
> small, extremely performance-critical things like cli/sti, but it
> awkward to use in general because you have to specify the inlined code
> as a parameterless asm.
> 

I haven't look at the pvops patching (probably should), but I was
wondering if jump labels could be used for it? Or is there something
that the pvops patching is doing that jump labels can't handle?


> Jump_labels is basically an efficient way of doing conditionals
> predicated on rarely-changed booleans - so it's similar to pvops in that
> it is effectively a very ordinary C construct optimised by dynamic code
> patching.
> 

Another thing is that it can be changed at run-time...Can pvops be
adjusted at run-time as opposed to just boot-time?

thanks,

-Jason
