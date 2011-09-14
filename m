Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab1INPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:51:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:54953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1INPvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:51:51 -0400
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Wed, 14 Sep 2011 17:51:38 +0200
In-Reply-To: <4E70CC3B.4000905@linux.intel.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.831707072@chello.nl> <4E70CC3B.4000905@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316015498.5040.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 08:46 -0700, Darren Hart wrote:
> 
> On 09/14/2011 06:30 AM, Peter Zijlstra wrote:
> > Use the brand spanking new wake_list to delay the futex wakeups until
> > after we've released the hash bucket locks. This avoids the newly
> > woken tasks from immediately getting stuck on the hb lock.
> > 
> > This is esp. painful on -rt, where the hb lock is preemptible.
> 
> Nice!
> 
> Have you run this through the functional and performance tests from
> futextest? Looks like I should also add a multiwake test to really
> showcase this.

Not more functional than booting, but a very similar patch used to live
in 33-rt.. I lost the use-case we had that led to that patch, for -rt it
made a huge difference because we endlessly scheduled back and forth
between the waker and the wakee bouncing on the hb lock.

> If you don't have it local I can setup a github repository for futextest
> until korg is back.... or do the testing myself... right.

Right, I don't think I have futextest, or I might, I'd have to dig
around a bit.

> > @@ -988,7 +986,7 @@ futex_wake(u32 __user *uaddr, unsigned i
> >  			if (!(this->bitset & bitset))
> >  				continue;
> >  
> > -			wake_futex(this);
> > +			wake_futex(&wake_list, this);
> 
> 
> I guess this is OK. wake_futex_pi will always be one task I believe, so
> the list syntax might confuse newcomers... Would it make sense to have a
> wake_futex_list() call? Thinking outloud...

To what purpose? Even delaying a single wakeup until after we release
the hb lock is useful. On it matters even on !-rt since the woken task
can wake on another cpu and then spin on hb-lock.
 
> > @@ -1437,6 +1441,7 @@ static int futex_requeue(u32 __user *uad
> >  	put_futex_key(&key2);
> >  out_put_key1:
> >  	put_futex_key(&key1);
> > +	wake_up_list(&wake_list, TASK_NORMAL);
> >  out:
> >  	if (pi_state != NULL)
> >  		free_pi_state(pi_state);
> > 
> > 
> 
> I _think_ requeue_pi is in the clear here as it uses
> requeue_pi_wake_futex, which calls wake_up_state directly. Still, some
> testing with futextest functional/futex_requeue_pi is in order.

Ah, right, that might want frobbing too..
