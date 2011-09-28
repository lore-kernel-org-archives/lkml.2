Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1I1RuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:50:15 -0400
Received: from claw.goop.org ([74.207.240.146]:38593 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1I1RuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:50:13 -0400
Message-ID: <4E835E50.2020307@goop.org>
Date: Wed, 28 Sep 2011 10:50:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        xen-devel@lists.xensource.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org> <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com> <4E835F8C0200007800058461@nat28.tlf.novell.com> <CA+55aFyVoZpZZp7ejypTv21Cx_qJWkZQdpJOnxBa_jUxsCjhuw@mail.gmail.com> <4E834FBA.1080709@goop.org> <CA+55aFzGZp8YaQMMUMwV+pd_vnqR14CtiTmTtkXuotQBg0zspg@mail.gmail.com> <4E835851.7070502@zytor.com>
In-Reply-To: <4E835851.7070502@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 10:24 AM, H. Peter Anvin wrote:
> On 09/28/2011 10:22 AM, Linus Torvalds wrote:
>> On Wed, Sep 28, 2011 at 9:47 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> Could do something like:
>>>
>>>        if (ticket->head >= 254)
>>>                prev = xadd(&ticket->head_tail, 0xff02);
>>>        else
>>>                prev = xadd(&ticket->head_tail, 0x0002);
>>>
>>> to compensate for the overflow.
>> Oh wow. You havge an even more twisted mind than I do.
>>
>> I guess that will work, exactly because we control "head" and thus can
>> know about the overflow in the low byte. But boy is that ugly ;)
>>
>> But at least you wouldn't need to do the loop with cmpxchg. So it's
>> twisted and ugly, but migth be practical.
>>
> I suspect it should be coded as -254 in order to use a short immediate
> if that is even possible...

I'm about to test:

static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
{
	if (TICKET_SLOWPATH_FLAG && unlikely(arch_static_branch(&paravirt_ticketlocks_enabled))) {
		arch_spinlock_t prev;
		__ticketpair_t inc = TICKET_LOCK_INC;

		if (lock->tickets.head >= (1 << TICKET_SHIFT) - TICKET_LOCK_INC)
			inc += -1 << TICKET_SHIFT;

		prev.head_tail = xadd(&lock->head_tail, inc);

		if (prev.tickets.tail & TICKET_SLOWPATH_FLAG)
			__ticket_unlock_slowpath(lock, prev);
	} else
		__ticket_unlock_release(lock);
}

Which, frankly, is not something I particularly want to put my name to.

It makes gcc go into paroxysms of trickiness:

 4a8:   80 3f fe                cmpb   $0xfe,(%rdi)
 4ab:   19 f6                   sbb    %esi,%esi
 4ad:   66 81 e6 00 01          and    $0x100,%si
 4b2:   66 81 ee fe 00          sub    $0xfe,%si
 4b7:   f0 66 0f c1 37          lock xadd %si,(%rdi)

...which is pretty neat, actually.

    J
