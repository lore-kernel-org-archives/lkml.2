Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2DXHVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:21:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57622 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2DXHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:21:27 -0400
Message-ID: <4F965471.2030905@gmail.com>
Date: Tue, 24 Apr 2012 09:21:21 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
CC: Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>  <1335191701.28150.155.camel@twins> <4F9577CF.2020400@gmail.com> <1335195826.28150.177.camel@twins> <4F958627.8070109@gmail.com> <4F95D41F.5060700@sssup.it>
In-Reply-To: <4F95D41F.5060700@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 12:13 AM, Tommaso Cucinotta wrote:
> Il 23/04/2012 17:41, Juri Lelli ha scritto:
>> The user could call __setparam_dl on a throttled task through
>> __sched_setscheduler.
>
> in case it can be related: a scenario that used to break isolation
> (in the old aquosa crap): 1) create a deadline task 2) (actively)
> wait till it's just about to be throttled 3) remove reservation
> (i.e., return the task to the normal system policy and destroy
> reservation info in the kernel) 4) reserve it again
>

Yes, this is very similar to what I thought just after I've sent the
email (ouch! :-)).
  
> Assuming the borderline condition of a nearly fully saturated system,
> if 3)-4) manage to happen sufficiently close to each other and right
> after 2), now the task budget is refilled with a deadline which is
> where it should not be, according to the admission control rules. In
> other words, we may break guarantees of other tasks by a properly
> misbehaving task. Something relevant when considering misbehaviour
> and admission control from a security perspective [1].
>

Thanks for the ref., I'll read it!

> At that time, I was persuaded that the right way to avoid this would
> be to avoid to free system cpu bw immediately when a reservation is
> destroyed, but rather wait till its current abs deadline, then "free"
> the bandwidth. A new task trying to re-create the reservation too
> early, i.e., at step 4) above, would be rejected by the system as it
> would still see a fully occupied cpu bw. Never implemented of course
> :-)...
>

A kind of "two steps" approach. It would work, I just have to think how
to implement it (and let the system survive ;-)). Then create some
bench to test it.

> And also, from a security perspective, a misbehaving (sched_other)
> task might thrash the system with useless nansosleeps forcing the OS
> to continuously schedule/deschedule it. Equivalently, with a deadline
> scheduler, you could try to set a very small period/deadline. That's
> why in [1], among the configurable variables, there was a minimum
> allowed reservation period.
>

Yes, this should be easily controlled at admission time.

> Nothing really urgent, just something you might want to keep in mind
> for the future, I thought.
>

Well, depends on how much effort will this turn to require. I personally
would prefer to be able to come out with a new release ASAP. Just to
continue the discussion with the most of the comments addressed and a
more updated code (I also have a mainline version of the patchset
quite ready).

Thanks a lot,

- Juri

