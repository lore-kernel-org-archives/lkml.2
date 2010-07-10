Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0GJHQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:16:54 -0400
Received: from mail2.unitn.it ([193.205.206.54]:43173 "EHLO mail2.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0GJHQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:16:53 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jul 2010 03:16:53 EDT
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Luca Abeni <lucabe72@email.it>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278682707.6083.227.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
Content-Type: text/plain
Date: Sat, 10 Jul 2010 09:09:21 +0200
Message-Id: <1278745761.5248.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

first of all, thanks for including me in these emails, and sorry for the
delay...

On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> Hi all,
> 
> So, talking to Peter and Thomas at the OSPERT workshop in Brussels [1],
> the so called "sporaidic task model" came out many many times!
I assume here you are simply talking about tasks with relative deadline
different from period, right? (the term "sporadic" is more often
associated with non-periodic activation patterns).

[...]
>  - do you think it could be useful to have a different syscall to deal
>    with the period parameter (if it's different from deadline), e.g.,
>    something useful to make the task periodic as you have (if I remember
>    well) in Xenomai or RTAI?
Maybe I am confused because I missed the initial part of the discussion,
but here I think there is the risk to mix two different concepts: the
"reservation period" (that is, the period P used to postpone the
scheduling deadline when the budget arrives to 0), and the "task
period" (which has to do with the periodicity of tasks activations). For
implementing a periodic behaviour in the task (this is, AFAIK, what RTAI
similar API provide), no new syscall is needed: clock_nanosleep() is
enough. See http://www.disi.unitn.it/~abeni/RTOS/rtapi.pdf for a
(stupid) example.
The reservation period, on the other hand, is a scheduling parameter,
and I think that setting it with extended versions of sched_setparam(),
sched_setscheduler() and similar is ok.


>    If you think it's worth doing that, do you think the
>    task_wait_interval() syscall that we already added could/should do
>    the job?
I do not remember what task_wait_interval() does :)
Is it the syscall you added to indicate the end of a job?


> Basically, from the scheduling point of view, what it could happen is
> that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
> D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
> for scheduling but the passing of the simple in-kernel admission test
> Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
> jobs before D.
I think if you want a different P_i and D_i you can use D_i for
generating new scheduling deadlines on task arrivals as "d = t + D_i",
and P_i to postpone the scheduling deadlines as "d = d + T_i" when the
budget is 0.
Depending on the replenishment amount you use, you might need to modify
the admission test as "Sum_i(Q_i/min{P_i,D_i}) < 1" or not (if you
always replenish to Q_i, then you need a modified admission test;
otherwise, you can compute the replenishment amount so that the
admission test is unaffected).


			Thanks,
				Luca

