Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1FGOYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:24:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:59163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1FGOYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:24:45 -0400
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	 <1307454439.2322.260.camel@twins>
	 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 16:24:40 +0200
Message-ID: <1307456680.2322.270.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:10 +0800, Hillf Danton wrote:
> On Tue, Jun 7, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2011-06-07 at 21:41 +0800, Hillf Danton wrote:
> >> It is suppose to check the owner task that is not absolutly running on the
> >> local CPU,
> >
> > Oh, why do you think so?
> >
> as the comment in __mutex_lock_common() says,
> 
> #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
> 	/*
> 	 * Optimistic spinning.
> 	 *
> 	 * We try to spin for acquisition when we find that there are no
> 	 * pending waiters and the lock owner is currently running on a
> 	 ***************************
>          * (different) CPU.
> 	 ***************************
>          * .....
>          */

Which is exactly what owner_running() does, clearly it cannot run on the
current cpu, since then we wouldn't be running to check things, so for
as long as owner is on_cpu we spin.

However,

> need_resched is checked after true is returned by owner_running(),
> in other words, owner is still on its CPU, so owner should be check
> here. Even ower's CPU == this CPU, checking owner also gives
> correct result.

no, after rcu_read_unlock() in owner_running() -- read that comment
again -- the owner pointer can be free or reused memory.

Also, since we already check owner_running() this need_resched() is
clearly something different. By your argument it would be superfluous
not wrong.

Now since it appears superfluous, ask yourself why it would exist. The
answer is simple, we should not be greedy and consume our cpu when
there's someone else that wants to run, we should yield the cpu on
need_resched(), which is exactly what happens.


