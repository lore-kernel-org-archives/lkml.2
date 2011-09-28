Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1I1S1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:27:47 -0400
Received: from claw.goop.org ([74.207.240.146]:38713 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1I1S1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:27:46 -0400
Message-ID: <4E83671E.9070202@goop.org>
Date: Wed, 28 Sep 2011 11:27:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
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
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <4E835851.7070502@zytor.com> <4E835E50.2020307@goop.org> <201109282008.17722.stephan.diestelhorst@amd.com>
In-Reply-To: <201109282008.17722.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 11:08 AM, Stephan Diestelhorst wrote:
> On Wednesday 28 September 2011 19:50:08 Jeremy Fitzhardinge wrote:
>> On 09/28/2011 10:24 AM, H. Peter Anvin wrote:
>>> On 09/28/2011 10:22 AM, Linus Torvalds wrote:
>>>> On Wed, Sep 28, 2011 at 9:47 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>> Could do something like:
>>>>>
>>>>>        if (ticket->head >= 254)
>>>>>                prev = xadd(&ticket->head_tail, 0xff02);
>>>>>        else
>>>>>                prev = xadd(&ticket->head_tail, 0x0002);
>>>>>
>>>>> to compensate for the overflow.
>>>> Oh wow. You havge an even more twisted mind than I do.
>>>>
>>>> I guess that will work, exactly because we control "head" and thus can
>>>> know about the overflow in the low byte. But boy is that ugly ;)
>>>>
>>>> But at least you wouldn't need to do the loop with cmpxchg. So it's
>>>> twisted and ugly, but migth be practical.
>>>>
>>> I suspect it should be coded as -254 in order to use a short immediate
>>> if that is even possible...
>> I'm about to test:
>>
>> static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
>> {
>> 	if (TICKET_SLOWPATH_FLAG && unlikely(arch_static_branch(&paravirt_ticketlocks_enabled))) {
>> 		arch_spinlock_t prev;
>> 		__ticketpair_t inc = TICKET_LOCK_INC;
>>
>> 		if (lock->tickets.head >= (1 << TICKET_SHIFT) - TICKET_LOCK_INC)
>> 			inc += -1 << TICKET_SHIFT;
>>
>> 		prev.head_tail = xadd(&lock->head_tail, inc);
>>
>> 		if (prev.tickets.tail & TICKET_SLOWPATH_FLAG)
>> 			__ticket_unlock_slowpath(lock, prev);
>> 	} else
>> 		__ticket_unlock_release(lock);
>> }
>>
>> Which, frankly, is not something I particularly want to put my name to.
> I must have missed the part when this turned into the propose-the-
> craziest-way-that-this-still-works.contest :)
>
> What is wrong with converting the original addb into a lock addb? The
> crazy wrap around tricks add a conditional and lots of headache. The
> lock addb/w is clean. We are paying an atomic in both cases, so I just
> don't see the benefit of the second solution.

Well, it does end up generating surprisingly nice code.  And to be
honest, being able to do the unlock and atomically fetch the flag as one
operation makes it much easier to reason about.

I'll do a locked add variant as well to see how it turns out.

Do you think locked add is better than unlocked + mfence?

Thanks,
    J
