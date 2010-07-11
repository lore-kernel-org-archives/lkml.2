Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0GKHdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 03:33:24 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:39466 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0GKHdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 03:33:23 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
Date: Sun, 11 Jul 2010 09:32:42 +0200
Cc: Peter Zijlstra <peterz@infradead.org>, Raistlin <raistlin@linux.it>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685800.1900.212.camel@laptop> <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com> <1278786710.1998.63.camel@laptop> <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
To: Harald Gustafsson <hgu1972@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 10, 2010, at 10:08 PM, Harald Gustafsson wrote:
> 2010/7/10 Peter Zijlstra <peterz@infradead.org>
>> 
>> 
>> That is a very delicate point, the whole reason SCHED_FIFO and friends
>> suck so much is that they don't provide any kind of isolation, and thus,
>> as an Operating-System abstraction they're an utter failure.
>> 
>> If you take out admission control you end up with a similar situation.
> 
> OK, I see your point, and I also want to keep the isolation, its just
> that I thought that the complexity might be too large to be accepted
> by mainline. Let's work towards a solution with good admission
> control, i.e. having more complex admission control to handle this.
> 
>> In general the sporadic task model schedulers don't need to be
>> privileged because it does provide isolation. But the moment you allow
>> by-passing the admission control everything goes out the window. So even
>> a simple privileged flag telling the admission control to stuff it would
>> render the whole system unusable, you'd have to start failing everything
>> not having that flag, simply because the admission control is rendered
>> useless.
> 
> Yes, thats true if you have any truly hard RT tasks in the system.
> Could we have a way of making tasks with deadline=period also go into
> the soft deadline RT policy and not just always run before any
> deadline<period tasks? Maybe utilizing the flags field. In this way we
> rather demote all tasks than elevate some tasks above other tasks, and
> then the system designer could make sure that only using hard RT when
> needed (and supported by the admission control). Since the fact that
> it can be easily admission controlled is maybe not a sufficient fact
> for making the user want to have it as a hard RT task, running before
> tasks needing complex admission control. Also, without such notion the
> behavior might change with new kernel releases when the admission
> control is developed i.e suddenly some tasks will be scheduled as hard
> that was previously scheduled as soft deadline RT.

Trying to infer whether a task is "hard" or "soft" from task parameters is not a good idea, IMO. It's much better to make this an explicit part of the task model that is configured via sched_setparam. By default, tasks should be marked "soft" (this leaves more wiggle room to the kernel); users who care can change the flag to "hard".

Taking a step back, I think the problem here is that we are trying to shove too many concepts and properties into a single scheduler. Hard (no tardiness) is different from soft (bounded tardiness) is different from global is different from partitioned.

>From my point of view, it makes no sense to support hard deadlines under G-EDF (this is backed up by our schedulability studies [1]). Hard deadlines are best served by a P-EDF implementation (that only migrates on task creation/admission).

Also, it makes little sense to worry about supporting both hard and soft in a P-EDF implementation. Just schedule everything by its deadline and both hard and soft tasks will be fine (if the admissions test was passed).

In my opinion, it is much more useful to have a two-level scheduling framework: a truly partitioned EDF implementation at the top level to support "hard" tasks, and a truly global EDF implementation at the second level for "soft" tasks, with the property that the second level implementation is only invoked if the first level is idle. This nicely matches Linux's scheduling class hierarchy. This leaves the question how to avoid starving the second level if the first level has "large" budgets (e.g., wcet 1 hour, period 2 hours), but this can be done with some additional budget tracking and job slicing. This is explained in detail in [2] (please forgive me for promoting my own work, but I think it is relevant).

Here is what I think could work for the first iteration:

1) Set period, relative deadline, budget, and the hard-soft-flag with set_schedparam.
2) For hard tasks, the kernel finds the CPU with the lowest total utilization that is marked in the affinity masks and that passes a P-EDF admissions test.
3) Hard tasks are scheduled by a P-EDF implementation as described in [2].
4) For soft tasks, the kernel requires that _all_ CPUs are marked in the affinity mask. 
5) Soft tasks are scheduled with G-EDF as described in [2].

Under this approach, both the P-EDF and G-EDF scheduling classes become simpler to implement since they only deal with one kind of task. In particular, load balancing under P-EDF is only required at admissions time, the kernel is not required to infer anything, and the policy is well-defined and predictable, and manual partitioning is available for "hard" tasks.

I assume that this works across 2-8 cores with shared caches, but (of course) G-EDF is not going to scale to largish numbers of cores and NUMA platforms. Thus, in later iterations 4) should be relaxed to allow clustered EDF.

If, however, you are more interested in supporting both hard and soft under a single G-EDF scheduler, then I recommend taking a look at [3].

- Björn

[1] A. Bastoni, B. Brandenburg, and J. Anderson, An Empirical Comparison of Global, Partitioned, and Clustered Multiprocessor Real-Time Schedulers, in submission, May 2010. http://www.cs.unc.edu/~anderson/papers/rtss10c.pdf

[2] B. Brandenburg and J. Anderson, Integrating Hard/Soft Real-Time Tasks and Best-Effort Jobs on Multiprocessors, Proceedings of the 19th Euromicro Conference on Real-Time Systems, pp. 61-70, July 2007. http://www.cs.unc.edu/~anderson/papers/ecrts07b.pdf

[3] H. Leontyev and J. Anderson, A Unified Hard/Soft Real-Time Schedulability Test for Global EDF Multiprocessor Scheduling, Proceedings of the 29th IEEE Real-Time Systems Symposium, pp. 375-384, December 2008.  http://www.cs.unc.edu/~anderson/papers/rtss08a.pdf

---
Björn B. Brandenburg
Ph.D. Student 
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.cs.unc.edu/~bbb




