Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2KZQkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:40:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2KZQkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:40:31 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0Dr-bvbIo-YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=r0ZjosXJyycA:10 a=KKAkSRfTAAAA:8 a=Vt2AcnKqAAAA:8 a=gQGbs8_HAAAA:8 a=L5T9VTwNJepWW_80ed4A:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353948027.6276.38.camel@gandalf.local.home>
Subject: Re: [PATCH V2 Resend 0/4] Create sched_select_cpu() and use it for
 workqueues and timers
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Mon, 26 Nov 2012 11:40:27 -0500
In-Reply-To: <CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	 <CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 20:30 +0530, Viresh Kumar wrote:
> On 6 November 2012 16:08, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > This is V2 Resend of my sched_select_cpu() work. Resend because didn't got much
> > attention on V2. Including more guys now in cc :)
> >
> > In order to save power, it would be useful to schedule work onto non-IDLE cpus
> > instead of waking up an IDLE one.
> >
> > To achieve this, we need scheduler to guide kernel frameworks (like: timers &
> > workqueues) on which is the most preferred CPU that must be used for these
> > tasks.
> >
> > This patchset is about implementing this concept.
> >
> > - The first patch adds sched_select_cpu() routine which returns the preferred
> >   cpu which is non-idle.
> > - Second patch removes idle_cpu() calls from timer & hrtimer.
> > - Third patch is about adapting this change in workqueue framework.
> > - Fourth patch add migration capability in running timer
> >
> > Earlier discussions over v1 can be found here:
> > http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html
> >
> > Earlier discussions over this concept were done at last LPC:
> > http://summit.linuxplumbersconf.org/lpc-2012/meeting/90/lpc2012-sched-timer-workqueue/
> >
> > Module created for testing this behavior is present here:
> > http://git.linaro.org/gitweb?p=people/vireshk/module.git;a=summary
> 
> Ping!!

This is a really bad time of year to post new patches :-/
A lot of people are trying to get their own work done by year end and
then there's holidays and such that are also distractions. Not to
mention that a new merge window will be opening soon.

That said...

As workqueues are set off by the CPU that queued it, what real benefit
does this give? A CPU was active when it queued the work and the work
should be done before it gets back to sleep.

OK, an interrupt happens on an idle CPU and queues some work. That work
should execute before the CPU gets back to sleep, right? I fail to see
the benefit of trying to move that work elsewhere. The CPU had to wake
up to execute the interrupt. It's no longer in a deep sleep (or any
sleep for that matter).

To me it seems best to avoid waking up an idle CPU in the first place.

I'm still working off a turkey overdose, so maybe I'm missing something
obvious.

-- Steve


