Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1IBUHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:07:32 -0400
Received: from claw.goop.org ([74.207.240.146]:45218 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1IBUHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:07:30 -0400
Message-ID: <4E61377B.4020600@goop.org>
Date: Fri, 02 Sep 2011 13:07:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <CA+55aFxpz+1bXVsg7kMeozePa=j_2-OaOuidQ4Y9Bg063=HMfg@mail.gmail.com>
In-Reply-To: <CA+55aFxpz+1bXVsg7kMeozePa=j_2-OaOuidQ4Y9Bg063=HMfg@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 08:38 AM, Linus Torvalds wrote:
> On Thu, Sep 1, 2011 at 5:54 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> The inner part of ticket lock code becomes:
>>        inc = xadd(&lock->tickets, inc);
>>        inc.tail &= ~TICKET_SLOWPATH_FLAG;
>>
>>        for (;;) {
>>                unsigned count = SPIN_THRESHOLD;
>>
>>                do {
>>                        if (inc.head == inc.tail)
>>                                goto out;
>>                        cpu_relax();
>>                        inc.head = ACCESS_ONCE(lock->tickets.head);
>>                } while (--count);
>>                __ticket_lock_spinning(lock, inc.tail);
>>        }
> Hmm. It strikes me that I don't think you should touch the
> TICKET_SLOWPATH_FLAG in the fastpath at all.
>
> Can't you just do this:
>
>    inc = xadd(&lock->tickets, inc);
>    if (likely(inc.head == inc.tail))
>      goto out;
>
>    ### SLOWPATH ###
>    inc.tail &= ~TICKET_SLOWPATH_FLAG;
>    for (;;) {
>       .. as before ..
>
> which might alleviate the problem with the fastpath being polluted by
> all those silly slowpath things.  Hmm?
>
> (This assumes that TICKET_SLOWPATH_FLAG is never set in inc.head, so
> if it's set that equality check will fail. I didn't actually check if
> that assumption was correct)

Yes, nice idea.  That ends up making the overall code slightly longer,
but the fastpath becomes identical to the non-pv case:

	mov    $512,%ecx
	lock xadd %cx,(%rdi)
	movzbl %ch,%edx
	cmp    %cl,%dl
	je     2f

	### SLOWPATH START
	and    $-2,%edx
	mov    $8192,%eax
	movzbl %dl,%esi
1:	cmp    %dl,%cl
	je     2f
	pause  
	dec    %eax
	mov    (%rdi),%cl
	jne    1b
	callq  __ticket_lock_spinning
	mov    $8192,%eax
	jmp    1b
	### SLOWPATH ENDS

2:


It's especially nice that it also moves the spin counter and arg setup
into the slowpath code.

And that entire piece of slowpath code can be moved out into its own
function, so the fastpath becomes:

	mov    $512,%eax
	lock xadd %ax,(%rdi)
	movzbl %ah,%esi
	cmp    %al,%sil
	je     1f

	movzbl %sil,%esi
	callq  __ticket_lock_slow
1:

I don't know whether that fastpath code is small enough to consider
inlining everywhere?

    J
