Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112Ab0HFWba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:31:30 -0400
Received: from claw.goop.org ([74.207.240.146]:40709 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0HFWb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:31:27 -0400
Message-ID: <4C5C86CD.2000109@goop.org>
Date: Fri, 06 Aug 2010 15:03:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Beulich <JBeulich@novell.com>, Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Nick Piggin <npiggin@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com> <1280761639.1923.213.camel@laptop> <4C56E1A1.6020005@goop.org> <4C5C1F80020000780000EA6D@vpn.id2.novell.com> <4C5C21E3.1020004@goop.org> <4C5C6DCE.4020206@zytor.com> <4C5C71A5.3050500@goop.org> <4C5C7A0A.9080107@zytor.com>
In-Reply-To: <4C5C7A0A.9080107@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/06/2010 02:09 PM, H. Peter Anvin wrote:
> On 08/06/2010 01:33 PM, Jeremy Fitzhardinge wrote:
>> On 08/06/2010 01:17 PM, H. Peter Anvin wrote:
>>> On 08/06/2010 07:53 AM, Jeremy Fitzhardinge wrote:
>>>> On 08/06/2010 05:43 AM, Jan Beulich wrote:
>>>>> You certainly mean "the compiler currently treats this as being:" - I
>>>>> don't think there's a guarantee it'll always be doing so.
>>>>>
>>>>>> for (;;) {
>>>>>> if (inc.tickets.head == inc.tickets.tail)
>>>>>> goto out;
>>>>>> ...
>>>>>> }
>>>>>> out: barrier();
>>>>>> }
>>>>>>
>>>>>> (Which would probably be a reasonable way to clarify the code.)
>>>>> I therefore think it needs to be written this way.
>>>>
>>>> Agreed.
>>>>
>>>
>>> A call/return to an actual out-of-line function is a barrier (and will
>>> always be a barrier, as it is the fundamental ABI sequence points),
>>> but to an inline function it is not.
>>
>> Yes. So the goto explicitly puts the barrier into the control flow which
>> should stop the compiler from doing anything unexpected.
>>
>
> In this particular case, though, I would somewhat expect the more 
> conventional:
>
> while (inc.tickets.head != inc.tickets.tail) {
>     cpu_relax();
>     inc.tickets.head = ACCESS_ONCE(lock->tickets_head);
> }

Yes, that makes sense for the plain spinlock version.  But the full 
code, including the pv-ticketlock spin timeout, ends up being:

static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
{
	register struct __raw_tickets inc;

	inc = __ticket_spin_claim(lock);

	for (;;) {
		unsigned count = SPIN_THRESHOLD;

		do {
			if (inc.head == inc.tail)
				goto out;
			cpu_relax();
			inc.head = ACCESS_ONCE(lock->tickets.head);
		} while (--count);
		__ticket_lock_spinning(lock, inc.tail);
	}
out:	barrier();		/* make sure nothing creeps before the lock is taken */
}

So the goto form is closer to the final form.  If it weren't for this, 
I'd also prefer the while() form.

(If you config PARAVIRT_SPINLOCKS=n, then __ticket_lock_spinning() 
becomes an empty inline, which causes gcc to collapse the whole thing 
into a simple infinite loop (ie, it eliminates "count" and the inner loop).)


     J
