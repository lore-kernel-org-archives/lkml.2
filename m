Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2LVEoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:44:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab2LVEou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:44:50 -0500
Message-ID: <50D53B98.6070508@redhat.com>
Date: Fri, 21 Dec 2012 23:48:24 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/3] x86,smp: move waiting on contended lock out of
 line
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185038.43e8246c@annuminas.surriel.com> <CANN689GqkzUP6RsUvZYF1L=eBAwL0COnzp6jAokHABhN74tsUA@mail.gmail.com>
In-Reply-To: <CANN689GqkzUP6RsUvZYF1L=eBAwL0COnzp6jAokHABhN74tsUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 11:40 PM, Michel Lespinasse wrote:
> On Fri, Dec 21, 2012 at 3:50 PM, Rik van Riel <riel@redhat.com> wrote:

>> @@ -53,12 +55,11 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>
>>          inc = xadd(&lock->tickets, inc);

>> +       if (inc.head == inc.tail)
>> +               goto out;
>> +
>> +       ticket_spin_lock_wait(lock, inc);
>> + out:
>
> why not just:
>
> if (inc.head != inc.tail)
>    ticket_spin_lock_wait(lock, inc)

That makes the code nicer, thank you. Applied.

>> +++ b/arch/x86/kernel/smp.c
>> @@ -113,6 +113,20 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>>   static bool smp_no_nmi_ipi = false;
>>
>>   /*
>> + * Wait on a congested ticket spinlock.
>> + */
>> +void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>> +{
>> +       for (;;) {
>> +               cpu_relax();
>> +               inc.head = ACCESS_ONCE(lock->tickets.head);
>> +
>> +               if (inc.head == inc.tail)
>> +                       break;
>> +       }
>
> Why not just:
>
> do {
>    cpu_relax()
>    inc.head = ...
> } while (inc.head != inc.tail);
>
>
> Other than that, no problems with the principle of it.

In patch #3 I do something else inside the head == tail
conditional block, so this one is best left alone.

Thank you for the comments.

