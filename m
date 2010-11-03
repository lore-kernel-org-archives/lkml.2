Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0KCPjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:39:13 -0400
Received: from claw.goop.org ([74.207.240.146]:60963 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0KCPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:39:11 -0400
Message-ID: <4CD18213.4030105@goop.org>
Date: Wed, 03 Nov 2010 11:38:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/20] x86/ticketlock: convert spin loop to C
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>	 <3d9083892c28a7d3ed5a0191b0b4cd013022a186.1288794124.git.jeremy.fitzhardinge@citrix.com> <1288797092.2511.141.camel@edumazet-laptop>
In-Reply-To: <1288797092.2511.141.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 11:11 AM, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 10:59 -0400, Jeremy Fitzhardinge a
> écrit :
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> The inner loop of __ticket_spin_lock isn't doing anything very special,
>> so reimplement it in C.
>>
>> For the 8 bit ticket lock variant, we use a register union to get direct
>> access to the lower and upper bytes in the tickets, but unfortunately gcc
>> won't generate a direct comparison between the two halves of the register,
>> so the generated asm isn't quite as pretty as the hand-coded version.
>> However benchmarking shows that this is actually a small improvement in
>> runtime performance on some benchmarks, and never a slowdown.
>>
>> We also need to make sure there's a barrier at the end of the lock loop
>> to make sure that the compiler doesn't move any instructions from within
>> the locked region into the region where we don't yet own the lock.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/include/asm/spinlock.h |   58 +++++++++++++++++++-------------------
>>  1 files changed, 29 insertions(+), 29 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
>> index d6d5784..6711d36 100644
>> --- a/arch/x86/include/asm/spinlock.h
>> +++ b/arch/x86/include/asm/spinlock.h
>> @@ -58,21 +58,21 @@
>>  #if (NR_CPUS < 256)
>>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>  {
>> -	unsigned short inc = 1 << TICKET_SHIFT;
>> -
>> -	asm volatile (
>> -		LOCK_PREFIX "xaddw %w0, %1\n"
>> -		"1:\t"
>> -		"cmpb %h0, %b0\n\t"
>> -		"je 2f\n\t"
>> -		"rep ; nop\n\t"
>> -		"movb %1, %b0\n\t"
>> -		/* don't need lfence here, because loads are in-order */
>> -		"jmp 1b\n"
>> -		"2:"
>> -		: "+Q" (inc), "+m" (lock->slock)
>> -		:
>> -		: "memory", "cc");
>> +	register union {
>> +		struct __raw_tickets tickets;
>> +		unsigned short slock;
>> +	} inc = { .slock = 1 << TICKET_SHIFT };
>> +
>> +	asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
>> +		      : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
>> +
>> +	for (;;) {
>> +		if (inc.tickets.head == inc.tickets.tail)
>> +			return;
>> +		cpu_relax();
>> +		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
>> +	}
>> +	barrier();		/* make sure nothing creeps before the lock is taken */
> Isnt this barrier() never reached ?

Sorry, a later patch makes this clearer.  I should have folded it in.

    J
