Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3ACLmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:42:42 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61311 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3ACLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAC4Lta3D5BWnQ5vYjyZTgEvvdSiBK4=i8iaPZN6Ru+jt75hZwQ@mail.gmail.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
	<20130103002222.166611a8@annuminas.surriel.com>
	<CAC4Lta3D5BWnQ5vYjyZTgEvvdSiBK4=i8iaPZN6Ru+jt75hZwQ@mail.gmail.com>
Date: Thu, 3 Jan 2013 03:42:39 -0800
Message-ID: <CANN689FQomfT3yEKeyL_YdK9aO83V6MWkgJFVwnuqgH0WSTD6A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
From: Michel Lespinasse <walken@google.com>
To: Raghavendra KT <raghavendra.kt.linux@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:35 AM, Raghavendra KT
<raghavendra.kt.linux@gmail.com> wrote:
> [Ccing IBM id]
> On Thu, Jan 3, 2013 at 10:52 AM, Rik van Riel <riel@redhat.com> wrote:
>> Simple fixed value proportional backoff for ticket spinlocks.
>> By pounding on the cacheline with the spin lock less often,
>> bus traffic is reduced. In cases of a data structure with
>> embedded spinlock, the lock holder has a better chance of
>> making progress.
>>
>> If we are next in line behind the current holder of the
>> lock, we do a fast spin, so as not to waste any time when
>> the lock is released.
>>
>> The number 50 is likely to be wrong for many setups, and
>> this patch is mostly to illustrate the concept of proportional
>> backup. The next patch automatically tunes the delay value.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>> ---
>>  arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
>>  1 files changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>> index 20da354..9c56fe3 100644
>> --- a/arch/x86/kernel/smp.c
>> +++ b/arch/x86/kernel/smp.c
>> @@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
>>   */
>>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>>  {
>> +       __ticket_t head = inc.head, ticket = inc.tail;
>> +       __ticket_t waiters_ahead;
>> +       unsigned loops;
>> +
>>         for (;;) {
>> -               cpu_relax();
>> -               inc.head = ACCESS_ONCE(lock->tickets.head);
>> +               waiters_ahead = ticket - head - 1;
>                                              ^^^^^^^^^^^^^^
> Just wondering,
> Does wraparound affects this?

The result gets stored in waiters_ahead, which is unsigned and has
same bit size as ticket and head. So, this takes care of the
wraparound issue.

In other words, you may have to add 1<<8 or 1<<16 if the integer
difference was negative; but you get that for free by just computing
the difference as a 8 or 16 bit unsigned value.


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
