Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1C2Jp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:45:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1C2JpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hvr8rM0ctxymdfwGsobHrrNeJtYh9+bUFrHi5DOtOTLzV5XBMQOJyHQi6ovEWs/j7c
         rWpBnTsPXSlRols3bMme/TH4QSf2zWcWZvJEZ6GbsZd8WAthfAtGGovenO7cdPlhjIDw
         YRecWy8Lu44l/yngfqhKNr3yJgCWggikqAbUg=
MIME-Version: 1.0
In-Reply-To: <20101108131708.GC2580@linux.vnet.ibm.com>
References: <1288993499.2065.4.camel@cowboy>
	<20101106185350.GA23824@basil.fritz.box>
	<20101107133950.GV15561@linux.vnet.ibm.com>
	<1289215819.2318.3.camel@cowboy>
	<20101108131708.GC2580@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:45:23 +0200
Message-ID: <AANLkTikkQ6TdNzkBb6cusFTek7_y=bM1N=+X5zmp3eYY@mail.gmail.com>
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_log()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Davidlohr Bueso <dave@gnu.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Mon, Nov 08, 2010 at 08:30:19AM -0300, Davidlohr Bueso wrote:
>> On Sun, 2010-11-07 at 05:39 -0800, Paul E. McKenney wrote:
>> > On Sat, Nov 06, 2010 at 07:53:50PM +0100, Andi Kleen wrote:
>> > > On Fri, Nov 05, 2010 at 06:44:59PM -0300, Davidlohr Bueso wrote:
>> > > > Hi,
>> > > >
>> > > > Please review this patch, I am not very familiar with MCE/RCU so I'm not sure that this is the correct fix (otherwise consider it a bug report :)).
>> > > > This does "fix" the message though and I can use MCE normally.
>> > >
>> > > The patch is certainly not correct. The variable needs to be read
>> > > independently of the mutex.
>> >
>> > This code is simply checking the value of the pointer, and therefore
>> > need not protect any actual dereferences.  So why not replace the
>> > rcu_dereference_check_mce() with rcu_access_pointer()?  If this is
>> > OK, please see the patch below.
>> >
>> > BTW, assigning the value returned by rcu_access_pointer() into a
>> > variable often indicates a bug.  ;-)
>> >
>> >                                                     Thanx, Paul
>> >
>> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> >
>> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>> > index 7a35b72..4d29d50 100644
>> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> > @@ -1625,7 +1625,7 @@ out:
>> >  static unsigned int mce_poll(struct file *file, poll_table *wait)
>> >  {
>> >     poll_wait(file, &mce_wait, wait);
>> > -   if (rcu_dereference_check_mce(mcelog.next))
>> > +   if (rcu_access_pointer(mcelog.next))
>>
>> this doesn't compile (mcelog.next is an index):
>>
>> arch/x86/kernel/cpu/mcheck/mce.c: In function ‘mce_poll’:
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
>> ‘unary *’ (have ‘unsigned int’)
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
>> in declaration of ‘_________p1’
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
>> ‘unary *’ (have ‘unsigned int’)
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
>> in declaration of ‘type name’
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: cast to pointer from
>> integer of different size
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
>> ‘unary *’ (have ‘unsigned int’)
>> arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
>> in declaration of ‘type name’
>> make[4]: *** [arch/x86/kernel/cpu/mcheck/mce.o] Error 1
>>
>>
>> Since the mutex is independent, what about this patch?
>
> Looks good to me!
>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
>>  Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>>
>> ---
>>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
>> b/arch/x86/kernel/cpu/mcheck/mce.c
>> index 7a35b72..cc1c673 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -1625,7 +1625,7 @@ out:
>>  static unsigned int mce_poll(struct file *file, poll_table *wait)
>>  {
>>       poll_wait(file, &mce_wait, wait);
>> -     if (rcu_dereference_check_mce(mcelog.next))
>> +     if (rcu_dereference_index_check(mcelog.next,
>> rcu_read_lock_sched_held()))
>>               return POLLIN | POLLRDNORM;
>>       if (!mce_apei_read_done && apei_check_mce())
>>               return POLLIN | POLLRDNORM;



Any chance to have this ever fixed upstream ?
(still happens with today's vanialla build)

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
arch/x86/kernel/cpu/mcheck/mce.c:1629 invoked rcu_dereference_check()
without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
no locks held by mcelog/772.

stack backtrace:
Pid: 772, comm: mcelog Not tainted 2.6.38-09069-gc7dfeb9 #103
Call Trace:
 [<ffffffff8108bb7b>] lockdep_rcu_dereference+0xbb/0xc0
 [<ffffffff81017c55>] mce_poll+0xa5/0xd0
 [<ffffffff81161be0>] do_sys_poll+0x270/0x500
 [<ffffffff81160780>] ? poll_freewait+0xe0/0xe0
 [<ffffffff81160870>] ? __pollwait+0xf0/0xf0
 [<ffffffff81160870>] ? __pollwait+0xf0/0xf0
 [<ffffffff8111d678>] ? __do_fault+0x128/0x490
 [<ffffffff81009136>] ? native_sched_clock+0x26/0x70
 [<ffffffff8107d9b7>] ? local_clock+0x47/0x60
 [<ffffffff8108a558>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff8108dc00>] ? __lock_acquire+0x410/0x1bb0
 [<ffffffff81120284>] ? handle_pte_fault+0x84/0x900
 [<ffffffff811049dd>] ? __free_pages+0x2d/0x40
 [<ffffffff8111e0c0>] ? __pte_alloc+0xd0/0x120
 [<ffffffff81064a81>] ? sigprocmask+0x41/0x100
 [<ffffffff81498969>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8149528b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff81064a0b>] ? recalc_sigpending+0x1b/0x50
 [<ffffffff811620d4>] sys_ppoll+0xe4/0x180
 [<ffffffff812946ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8149c86b>] system_call_fastpath+0x16/0x1b


Zdenek
