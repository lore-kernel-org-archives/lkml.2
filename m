Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1I1SJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:09:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37541 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1I1SJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:09:57 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzz8275dhz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LS8VSB-01-QGO-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Wed, 28 Sep 2011 20:08:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.4-030004-generic; KDE/4.7.1; x86_64; ; )
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <4E835851.7070502@zytor.com> <4E835E50.2020307@goop.org>
In-Reply-To: <4E835E50.2020307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <201109282008.17722.stephan.diestelhorst@amd.com>
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011 19:50:08 Jeremy Fitzhardinge wrote:
> On 09/28/2011 10:24 AM, H. Peter Anvin wrote:
> > On 09/28/2011 10:22 AM, Linus Torvalds wrote:
> >> On Wed, Sep 28, 2011 at 9:47 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>> Could do something like:
> >>>
> >>>        if (ticket->head >= 254)
> >>>                prev = xadd(&ticket->head_tail, 0xff02);
> >>>        else
> >>>                prev = xadd(&ticket->head_tail, 0x0002);
> >>>
> >>> to compensate for the overflow.
> >> Oh wow. You havge an even more twisted mind than I do.
> >>
> >> I guess that will work, exactly because we control "head" and thus can
> >> know about the overflow in the low byte. But boy is that ugly ;)
> >>
> >> But at least you wouldn't need to do the loop with cmpxchg. So it's
> >> twisted and ugly, but migth be practical.
> >>
> > I suspect it should be coded as -254 in order to use a short immediate
> > if that is even possible...
> 
> I'm about to test:
> 
> static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
> {
> 	if (TICKET_SLOWPATH_FLAG && unlikely(arch_static_branch(&paravirt_ticketlocks_enabled))) {
> 		arch_spinlock_t prev;
> 		__ticketpair_t inc = TICKET_LOCK_INC;
> 
> 		if (lock->tickets.head >= (1 << TICKET_SHIFT) - TICKET_LOCK_INC)
> 			inc += -1 << TICKET_SHIFT;
> 
> 		prev.head_tail = xadd(&lock->head_tail, inc);
> 
> 		if (prev.tickets.tail & TICKET_SLOWPATH_FLAG)
> 			__ticket_unlock_slowpath(lock, prev);
> 	} else
> 		__ticket_unlock_release(lock);
> }
> 
> Which, frankly, is not something I particularly want to put my name to.

I must have missed the part when this turned into the propose-the-
craziest-way-that-this-still-works.contest :)

What is wrong with converting the original addb into a lock addb? The
crazy wrap around tricks add a conditional and lots of headache. The
lock addb/w is clean. We are paying an atomic in both cases, so I just
don't see the benefit of the second solution.

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo;
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551 

