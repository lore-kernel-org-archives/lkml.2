Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1FGOgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:36:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46185 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1FGOgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wt8zM+S1EmAyUGeEyg0rOl5DOYaTIslQrlM10Y0rWlvkB0eFkpnVq+rhh/EkD9Z+z3
         eg/0g8o/QvTqUlSh9CE6dESQSFdjalxrUr6f8Ul+RIV6oAxrXDLf77jDU/tXzOPvk/kl
         GzgbF1AyyXan84G127NxBtZalYpbD8iGhszBY=
MIME-Version: 1.0
In-Reply-To: <1307456680.2322.270.camel@twins>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	<1307454439.2322.260.camel@twins>
	<BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
	<1307456680.2322.270.camel@twins>
Date: Tue, 7 Jun 2011 22:36:13 +0800
Message-ID: <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
Subject: Re: [PATCH] sched: correct testing need_resched in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 10:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-07 at 22:10 +0800, Hillf Danton wrote:
>> On Tue, Jun 7, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2011-06-07 at 21:41 +0800, Hillf Danton wrote:
>> >> It is suppose to check the owner task that is not absolutly running on the
>> >> local CPU,
>> >
>> > Oh, why do you think so?
>> >
>> as the comment in __mutex_lock_common() says,
>>
>> #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>>       /*
>>        * Optimistic spinning.
>>        *
>>        * We try to spin for acquisition when we find that there are no
>>        * pending waiters and the lock owner is currently running on a
>>        ***************************
>>          * (different) CPU.
>>        ***************************
>>          * .....
>>          */
>
> Which is exactly what owner_running() does, clearly it cannot run on the
> current cpu, since then we wouldn't be running to check things, so for
> as long as owner is on_cpu we spin.
>
> However,
>
>> need_resched is checked after true is returned by owner_running(),
>> in other words, owner is still on its CPU, so owner should be check
>> here. Even ower's CPU == this CPU, checking owner also gives
>> correct result.
>
> no, after rcu_read_unlock() in owner_running() -- read that comment
> again -- the owner pointer can be free or reused memory.
>
> Also, since we already check owner_running() this need_resched() is
> clearly something different. By your argument it would be superfluous
> not wrong.
>
> Now since it appears superfluous, ask yourself why it would exist. The
> answer is simple, we should not be greedy and consume our cpu when
> there's someone else that wants to run, we should yield the cpu on
> need_resched(), which is exactly what happens.
>
If you are right, the following comment also in __mutex_lock_common()

	for (;;) {
		struct task_struct *owner;

		/*
		 * If there's an owner, wait for it to either
		 * release the lock or go to sleep.
		 */
		owner = ACCESS_ONCE(lock->owner);
		if (owner && !mutex_spin_on_owner(lock, owner))
			break;

looks misleading too, but if owner is on this CPU, for what does we wait?

thanks
           Hillf
