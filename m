Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0KCSAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:00:40 -0400
Received: from claw.goop.org ([74.207.240.146]:47531 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0KCSAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:00:38 -0400
Message-ID: <4CD1A33E.6040105@goop.org>
Date: Wed, 03 Nov 2010 14:00:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>	 <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com> <1288797218.2511.143.camel@edumazet-laptop>
In-Reply-To: <1288797218.2511.143.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 11:13 AM, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 10:59 -0400, Jeremy Fitzhardinge a
> écrit :
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> If we don't need to use a locked inc for unlock, then implement it in C.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/include/asm/spinlock.h |   33 ++++++++++++++++++---------------
>>  1 files changed, 18 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
>> index 6711d36..082990a 100644
>> --- a/arch/x86/include/asm/spinlock.h
>> +++ b/arch/x86/include/asm/spinlock.h
>> @@ -33,9 +33,23 @@
>>   * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>   * (PPro errata 66, 92)
>>   */
>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	if (sizeof(lock->tickets.head) == sizeof(u8))
>> +		asm (LOCK_PREFIX "incb %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>> +	else
>> +		asm (LOCK_PREFIX "incw %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>> +
>> +}
>>  #else
>> -# define UNLOCK_LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	barrier();
> technically speaking, it should be : smp_wmb()

Perhaps.  In practise it won't make a difference because it is defined
as barrier() unless OOSTORE is defined, in which case we need to do a
locked increment anyway.

Thanks,
    J
