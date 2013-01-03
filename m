Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3ACSVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:21:35 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48552 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3ACSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:21:33 -0500
Message-ID: <50E5CBAD.7000607@linux.vnet.ibm.com>
Date: Thu, 03 Jan 2013 23:49:25 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Subject: Re: [RFC PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
References: <20130103001536.7fd1e952@annuminas.surriel.com> <20130103002222.166611a8@annuminas.surriel.com> <CAC4Lta3D5BWnQ5vYjyZTgEvvdSiBK4=i8iaPZN6Ru+jt75hZwQ@mail.gmail.com> <CANN689FQomfT3yEKeyL_YdK9aO83V6MWkgJFVwnuqgH0WSTD6A@mail.gmail.com>
In-Reply-To: <CANN689FQomfT3yEKeyL_YdK9aO83V6MWkgJFVwnuqgH0WSTD6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010318-9574-0000-0000-000006071F88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 05:12 PM, Michel Lespinasse wrote:
> On Thu, Jan 3, 2013 at 3:35 AM, Raghavendra KT
> <raghavendra.kt.linux@gmail.com> wrote:
>> [Ccing IBM id]
>> On Thu, Jan 3, 2013 at 10:52 AM, Rik van Riel <riel@redhat.com> wrote:
>>> Simple fixed value proportional backoff for ticket spinlocks.
>>> By pounding on the cacheline with the spin lock less often,
>>> bus traffic is reduced. In cases of a data structure with
>>> embedded spinlock, the lock holder has a better chance of
>>> making progress.
>>>
>>> If we are next in line behind the current holder of the
>>> lock, we do a fast spin, so as not to waste any time when
>>> the lock is released.
>>>
>>> The number 50 is likely to be wrong for many setups, and
>>> this patch is mostly to illustrate the concept of proportional
>>> backup. The next patch automatically tunes the delay value.
>>>
>>> Signed-off-by: Rik van Riel <riel@redhat.com>
>>> Signed-off-by: Michel Lespinasse <walken@google.com>
>>> ---
>>>   arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
>>>   1 files changed, 20 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>>> index 20da354..9c56fe3 100644
>>> --- a/arch/x86/kernel/smp.c
>>> +++ b/arch/x86/kernel/smp.c
>>> @@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
>>>    */
>>>   void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>>>   {
>>> +       __ticket_t head = inc.head, ticket = inc.tail;
>>> +       __ticket_t waiters_ahead;
>>> +       unsigned loops;
>>> +
>>>          for (;;) {
>>> -               cpu_relax();
>>> -               inc.head = ACCESS_ONCE(lock->tickets.head);
>>> +               waiters_ahead = ticket - head - 1;
>>                                               ^^^^^^^^^^^^^^
>> Just wondering,
>> Does wraparound affects this?
>
> The result gets stored in waiters_ahead, which is unsigned and has
> same bit size as ticket and head. So, this takes care of the
> wraparound issue.
>
> In other words, you may have to add 1<<8 or 1<<16 if the integer
> difference was negative; but you get that for free by just computing
> the difference as a 8 or 16 bit unsigned value.
>

Michael,
Sorry for the noise and for missing the simple math :) and Thanks for 
explanation.

