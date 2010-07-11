Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0GKGnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:43:39 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:51679 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0GKGni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:43:38 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1278752489.4390.97.camel@Palantir>
Date: Sun, 11 Jul 2010 08:42:59 +0200
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-Id: <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop> <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu> <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>
To: Raistlin <raistlin@linux.it>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 10, 2010, at 11:01 AM, Raistlin wrote:
> On Fri, 2010-07-09 at 18:35 +0200, Peter Zijlstra wrote:
>> It will very much depend on how we're going to go about doing things
>> with that 'load-balancer' thingy anyway.
>> 
> Agree. The "load-balancer" right now pushes/pulls tasks to/from the
> various runqueue --just how the saame thing happens in sched-rt-- to,
> say, approximate G-EDF. Code is on the git... I just need some time to
> clean up a little bit more and post the patches, but it's already
> working at least... :-)
> 
>> The idea is that we approximate G-EDF by moving tasks around, but Dario
>> told me the admission tests are still assuming P-EDF.
>> 
> Yep, as said above, that's what we've done since now. Regarding
> "partitioned admission", let me try to explain this.
> 
> You asked me to use sched_dl_runtime_us/sched_dl_period_us to let people
> decide how much bandwidth should be devoted to EDF tasks. This obviously
> yields to _only_one_ bandwidth value that is then utilized as the
> utilization cap on *each* CPU, mainly for consistency reasons with
> sched_rt_{runtime,period}_us. At that time I was using such value as the
> "overall EDF bandwidth", but I changed to your suggested semantic.
> 
> Obviously this works perfectly as long as tasks stay on the CPU were
> they are created, and if they're manually migrated (by explicitly
> changing their affinity) I can easily check if there's enough bandwidth
> on the target CPU, and if yes move the task and its bandwidth there.
> That's how things were before the 'load-balancer' (and still does, if
> you set affinities of tasks so to have a fully partitioned setup).
> 
> With global scheduling in place, we have this new situation. A task is
> forked on a CPU (say 0), and I allow that if there's enough bandwidth
> for it on that processor (and obviously, if yes, I also consume such
> amount of bw). When the task is dynamically migrated to CPU 1 I have two
> choices:
> (a) I move the bandwidth it occupies from 0 to 1 or,
> (b) I leave it (the bw, not the task) where it is, on 0.
> 
[...]
> 
> If we want something better I cannot think on anything that doesn't
> include having a global (per-domain should be fine as well) mechanism
> for bandwidth accounting...


Now I am getting quite confused. In particular, all of the admission test discussion yesterday was P-EDF-specific, but it seems that now the discussion is about G-EDF.

Is the kernel implementing G-EDF or P-EDF? These are two different schedulers, with different admissions test. You can't just magically apply a test for P-EDF on each CPU and make claims about schedulability under G-EDF. Tracking per-CPU budgets under G-EDF is also meaningless.

Either this is a P-EDF implementation, in which case you need to track per-CPU utilization and move budgets around when you migrate tasks (i.e., (a) above) and you perform a P-EDF admissions test prior to _each_ migration (can you move the task as desired without causing some deadline to be missed on the target processor?), or it is a G-EDF implementation, in which case you only track total global utilization and perform G-EDF admissions tests on task creation (and no tests on task migration).

If you want to do G-EDF with limited and different budgets on each CPU (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but for 400 out of 1000 ms on CPU 1), then you are entering the domain of restricted-supply scheduling, which is significantly more complicated to analyze (see [1,2]). 

As far as I know there is no exiting analysis for "almost G-EDF", i.e.,  the case where each task may only migrate among a subset of the processors (= affinity masks), except for the special case of clustered EDF (C-EDF), wherein the subsets of processors are non-overlapping. 

- Björn

[1] I. Shin, A. Easwaran, I. Lee, Hierarchical Scheduling Framework for Virtual Clustering of Multiprocessors, in: Proceedings of the 20th Euromicro Conference on Real-Time Systems, 181–190, 2008.
[2] H. Leontyev and J. Anderson, Generalized Tardiness Bounds for Global Multiprocessor Scheduling, Real-Time Systems, Volume 44, Number 1, pages 26-71, February 2010. http://www.cs.unc.edu/~anderson/papers/rtj09.pdf


---
Björn B. Brandenburg
Ph.D. Student 
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.cs.unc.edu/~bbb




