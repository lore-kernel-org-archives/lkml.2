Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0DVSaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:30:11 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:50439 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0DVSaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:30:05 -0400
X-Greylist: delayed 2488 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 14:30:05 EDT
Subject: Re: Considerations on sched APIs under RT patch
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=windows-1252
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1271953686.1776.372.camel@laptop>
Date: Thu, 22 Apr 2010 13:48:10 -0400
Cc: Primiano Tucci <p.tucci@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Andrea Bastoni <bastoni@cs.unc.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <0248814C-F012-4E01-856B-0BDE95990086@email.unc.edu>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com> <1271839772.1776.58.camel@laptop> <1271854016.10448.172.camel@gandalf.stny.rr.com> <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com> <1271879833.1776.186.camel@laptop> <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com> <1271883496.1776.263.camel@laptop> <1271942430.10448.196.camel@gandalf.stny.rr.com> <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com> <1271944622.1776.349.camel@laptop> <k2gc5b2c05b1004220840z59f9417fy723a36a6fe9924dc@mail.gmail.com> <1271953686.1776.372.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 22, 2010, at 12:28 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 17:40 +0200, Primiano Tucci wrote:
> 
>>> Its a well studied
>>> algorithm and even available in commercial SMP operating systems
>> 
>> Can you cite me a commercial SMP system that supports
>> multicore/multiprocessor G-EDF?
> 
> From: http://www.cs.unc.edu/~anderson/papers/rtlws09.pdf
> 
> "Regarding the frequently voiced objections to G-
> EDF’s viability in a “real” system, it should be noted that
> xnu, the kernel underlying Apple’s multimedia-friendly
> OS X, has been relying on G-EDF to support real-time
> applications on multiprocessors for several years [5]."
> 
> "[5] Apple Inc. xnu source code.
> http://opensource.apple.com/source/xnu/."

Since that reference is a bit coarse-grained, let me clarify by pointing out the actual implementation.

In particular, if you look at /usr/include/mach/thread_policy.h (on OS X, of course), you'll find:

> /*
>  * THREAD_TIME_CONSTRAINT_POLICY:
>  *
>  * This scheduling mode is for threads which have real time
>  * constraints on their execution.
>  *
>  * Parameters:
>  *
>  * period: This is the nominal amount of time between separate
>  * processing arrivals, specified in absolute time units.  A
>  * value of 0 indicates that there is no inherent periodicity in
>  * the computation.
>  *
>  * computation: This is the nominal amount of computation
>  * time needed during a separate processing arrival, specified
>  * in absolute time units.
>  *
>  * constraint: This is the maximum amount of real time that
>  * may elapse from the start of a separate processing arrival
>  * to the end of computation for logically correct functioning,
>  * specified in absolute time units.  Must be (>= computation).
>  * Note that latency = (constraint - computation).
>  *
>  * preemptible: This indicates that the computation may be
>  * interrupted, subject to the constraint specified above.
>  */
> 

I.e., THREAD_TIME_CONSTRAINT_POLICY implements the sporadic task model.

Global EDF is implemented in osfmk/kern/sched_prim.c (line numbers pertain to XNU 1504.3.12):

In line 473:

> 	/*
> 	 * Calculate deadline for real-time threads.
> 	 */
> 	if (thread->sched_mode & TH_MODE_REALTIME) {
> 		thread->realtime.deadline = mach_absolute_time();
> 		thread->realtime.deadline += thread->realtime.constraint;
> 	}

Further, in choose_processor() starting at line 26:

> 		if (thread->sched_pri >= BASEPRI_RTQUEUES) {
> 			/*
> 			 *	For an RT thread, iterate through active processors, first fit.
> 			 */
> 			processor = (processor_t)queue_first(&cset->active_queue);
> 			while (!queue_end(&cset->active_queue, (queue_entry_t)processor)) {
> 				if (thread->sched_pri > processor->current_pri ||
> 						thread->realtime.deadline < processor->deadline)
> 					return (processor);

And in thread_setrun() at line 2482:

> 		if (thread->last_processor != PROCESSOR_NULL) {
> 			/*
> 			 *	Simple (last processor) affinity case.
> 			 */
> 			processor = thread->last_processor;
> 			pset = processor->processor_set;
> 			pset_lock(pset);
> 
> 			/*
> 			 *	Choose a different processor in certain cases.
> 			 */
> 			if (thread->sched_pri >= BASEPRI_RTQUEUES) {
> 				/*
> 				 *	If the processor is executing an RT thread with
> 				 *	an earlier deadline, choose another.
> 				 */
> 				if (thread->sched_pri <= processor->current_pri ||
> 						thread->realtime.deadline >= processor->deadline)
> 					processor = choose_processor(pset, PROCESSOR_NULL, thread);
> 			}
> 


This Global EDF implementation might have been inherited from RT Mach, but I'm not sure about that. 

In LITMUS^RT [1], we implement Global EDF a bit differently. Instead of iterating over all processors, we keep the processors in a max heap (ordered by deadline, with no RT task == infinity). The xnu variant may be beneficial if you only expect a few RT tasks at any time, whereas ours is based on the assumption that most processors will be scheduling RT tasks most of the time.

- Björn

[1] http://www.cs.unc.edu/~anderson/litmus-rt (The posted patch is horribly out of date; we'll have something more recent based on 2.6.32 up soon.)

---
Björn B. Brandenburg
Ph.D. Candidate 
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.cs.unc.edu/~bbb




