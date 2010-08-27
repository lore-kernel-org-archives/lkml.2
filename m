Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0H0QJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:09:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51740 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752318Ab0H0QJs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:09:48 -0400
Date: Fri, 27 Aug 2010 12:09:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827160946.GG14926@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop> <20100827152125.GB14926@Krystal> <1282923686.1975.2780.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1282923686.1975.2780.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:51:27 up 216 days, 18:28,  5 users,  load average: 0.20, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-08-27 at 11:21 -0400, Mathieu Desnoyers wrote:
> >        SIGEV_THREAD
> >               Upon  timer  expiration,  invoke  sigev_notify_function as if it
> >               were the start function of a new thread.  (Among the implementa‐
> >               tion  possibilities  here are that each timer notification could
> >               result in the creation of a new thread, or that a single  thread
> >               is  created  to  receive  all  notifications.)   The function is
> >               invoked   with   sigev_value   as   its   sole   argument.    If
> >               sigev_notify_attributes  is  not  NULL,  it  should  point  to a
> >               pthread_attr_t structure that defines  attributes  for  the  new
> >               thread (see pthread_attr_init(3).
> > 
> > So basically, it's the glibc implementation that is broken, not the standard.
> 
> The standard is broken too, what context will the new thread inherit?

Besides pthread_attr_t, thinking of the scheduler/cgroups/etc stuff, I'd think
it might be expected to inherit the state of the thread which calls
timer_create(). But this is not what glibc does right now, and it is not spelled
out clearly by the standard.

> The pthread_attr_t stuff tries to cover some of that, but pthread_attr_t
> doesn't cover all inherited task attributes, and allows for some very
> 'interesting' bugs [1].

(see below)

> 
> The specification also doesn't cover the case where the handler takes
> more time to execute than the timer interval.

Why should it ? It seems valid for a workload to result in spawning many threads
bound to more than a single core on a multi-core system. So concurrency
management should be performed by the application.

> 
> [1] - consider the case where pthread_attr_t includes the stack and we
> use a spawn thread on expire policy and then run into the situation
> where the handler is delayed past the next expiration.

Setting a thread stack and generating the signal more than once is taken into
account in the standard. It leads to unspecified result (IOW: don't do this):

http://www.opengroup.org/onlinepubs/009695399/functions/timer_create.html

"If evp->sigev_sigev_notify is SIGEV_THREAD and sev->sigev_notify_attributes is
not NULL, if the attribute pointed to by sev->sigev_notify_attributes has a
thread stack address specified by a call to pthread_attr_setstack() or
pthread_attr_setstackaddr(), the results are unspecified if the signal is
generated more than once."

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
