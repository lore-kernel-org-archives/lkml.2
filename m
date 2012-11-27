Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2K0PFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:05:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2K0PFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:05:03 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=f2n6SYgbXc8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIjj_We_h9UA:10 a=zEd6NGsiv2MS_FDxLnYA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354028699.6276.83.camel@gandalf.local.home>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Tue, 27 Nov 2012 10:04:59 -0500
In-Reply-To: <CAKfTPtD6T8oTHFeB82NFDOt6anAL=23vaShsDws0c7812=GkFQ@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	 <1354022770.6276.63.camel@gandalf.local.home>
	 <CAKohpok5toHdxxjBU+bPJwkZt9Sv-QGY8o8X6HErza1WT-DWOA@mail.gmail.com>
	 <1354024743.6276.79.camel@gandalf.local.home>
	 <CAKfTPtD6T8oTHFeB82NFDOt6anAL=23vaShsDws0c7812=GkFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 15:55 +0100, Vincent Guittot wrote:
> On 27 November 2012 14:59, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2012-11-27 at 19:18 +0530, Viresh Kumar wrote:
> >> On 27 November 2012 18:56, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > A couple of things. The sched_select_cpu() is not cheap. It has a double
> >> > loop of domains/cpus looking for a non idle cpu. If we have 1024 CPUs,
> >> > and we are CPU 1023 and all other CPUs happen to be idle, we could be
> >> > searching 1023 CPUs before we come up with our own.
> >>
> >> Not sure if you missed the first check sched_select_cpu()
> >>
> >> +int sched_select_cpu(unsigned int sd_flags)
> >> +{
> >> +       /* If Current cpu isn't idle, don't migrate anything */
> >> +       if (!idle_cpu(cpu))
> >> +               return cpu;
> >>
> >> We aren't going to search if we aren't idle.
> >
> > OK, we are idle, but CPU 1022 isn't. We still need a large search. But,
> > heh we are idle we can spin. But then why go through this in the first
> > place ;-)
> 
> By migrating it now, it will create its activity and wake up on the
> right CPU next time.
> 
> If migrating on any CPUs seems a bit risky, we could restrict the
> migration on a CPU on the same node. We can pass such contraints on
> sched_select_cpu
> 

That's assuming that the CPUs stay idle. Now if we move the work to
another CPU and it goes idle, then it may move that again. It could end
up being a ping pong approach.

I don't think idle is a strong enough heuristic for the general case. If
interrupts are constantly going off on a CPU that happens to be idle
most of the time, it will constantly be moving work onto CPUs that are
currently doing real work, and by doing so, it will be slowing those
CPUs down.

-- Steve


