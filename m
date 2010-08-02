Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0HBPRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:17:55 -0400
Received: from claw.goop.org ([74.207.240.146]:56839 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0HBPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:17:54 -0400
Message-ID: <4C56E1A1.6020005@goop.org>
Date: Mon, 02 Aug 2010 08:17:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>	 <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com> <1280761639.1923.213.camel@laptop>
In-Reply-To: <1280761639.1923.213.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 08:07 AM, Peter Zijlstra wrote:
> On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
>> +       register union {
>> +               struct __raw_tickets tickets;
>> +               unsigned short slock;
>> +       } inc = { .slock = 1<<  TICKET_SHIFT };
>    register arch_spinlock_t inc = { .tickets = { .head = 1, .tail = 0 } };
>
> > From a quick look you can basically replace all TICKET_SHIFT usage (1<<
> TICKET_SHIFT) with such a constant.

Mostly.  In the later patch to convert trylock in to C, you need it to 
construct an argument for cmpxchg (which can only take a scalar, even if 
it does have a struct packed into it).

> [ Also, does gcc really listen to the register hint these days? ]

It doesn't make much different in this case.  I think the only real 
effect is that its illegal to take the address of a register variable.

>> +       asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
>> +                     : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
>   "+Q" (inc->slock)
>
>> +       for (;;) {
>> +               if (inc.tickets.head == inc.tickets.tail)
>> +                       return;
>> +               cpu_relax();
>> +               inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
>> +       }
>> +       barrier();              /* make sure nothing creeps before the lock is taken */
>>   }
> How will it ever get to that barrier() ?

The compiler treats this as being:

	for (;;) {
		if (inc.tickets.head == inc.tickets.tail)
			goto out;
		...
	}
out:	barrier();
}

(Which would probably be a reasonable way to clarify the code.)

Without the barrier there's a risk of locked-region code being scheduled 
before the for(;;) loop.

     J
