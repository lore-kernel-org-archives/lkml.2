Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab2K0GZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:25:21 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34551 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2K0GZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <1353948027.6276.38.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
	<1353948027.6276.38.camel@gandalf.local.home>
Date: Tue, 27 Nov 2012 11:55:19 +0530
Message-ID: <CAKohpon_kUMQxtgTipcGm8qy35_C7_Y87KV1ohbexbeqwYSy5A@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 0/4] Create sched_select_cpu() and use it for
 workqueues and timers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thanks for sharing your opinion. :)

As, this went out to be a long thread of discussion (thanks Paul), i will try to
answer everything here.

On 26 November 2012 22:10, Steven Rostedt <rostedt@goodmis.org> wrote:
> This is a really bad time of year to post new patches :-/
> A lot of people are trying to get their own work done by year end and
> then there's holidays and such that are also distractions. Not to
> mention that a new merge window will be opening soon.

Patches are there since End of September and it was just a ping now (actually
with bad timing - merge window).

> As workqueues are set off by the CPU that queued it, what real benefit
> does this give? A CPU was active when it queued the work and the work
> should be done before it gets back to sleep.
>
> OK, an interrupt happens on an idle CPU and queues some work. That work
> should execute before the CPU gets back to sleep, right? I fail to see
> the benefit of trying to move that work elsewhere. The CPU had to wake
> up to execute the interrupt. It's no longer in a deep sleep (or any
> sleep for that matter).
>
> To me it seems best to avoid waking up an idle CPU in the first place.
>
> I'm still working off a turkey overdose, so maybe I'm missing something
> obvious.

Ok, here is the story behind these patches. The idea was first discussed
by Vincent in LPC this year:

http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/08/lpc2012-sched-timer-workqueue.pdf

Specifically slides: 12 & 19.

cpu idleness here means idleness from scheduler's perspective, i.e.
For the scheduler CPU is idle, if all below are true:
- current task is idle task
- nr_running == 0
- wake_list is empty


There are two use cases of workqueue patch 3/4:

- queue-work from timer interrupt, which re-arms itself (slide 12):
  Whether timer is deferred or not, it will queue the work on current
cpu once cpu
  wakes up. The cpu could have immediately gone back to idle state again, if the
  work is not queued on it. So, because this cpu is idle (from
schedulers point of
  view), we can move this work to other cpu.

- delayed-work, which rearm's itself (slide 19):
  Again the same thing, we could have kept the cpu in idle state for
some more time.

There might not be many users with this behavior, but a single user can actually
have significant impact.

For now, it doesn't take care of big LITTLE stuff that Paul pointed
out, but yes that
is in plan. Some work is going on in that direction too:

http://linux.kernel.narkive.com/mCyvFVUX/rfc-0-6-sched-packing-small-tasks

The very first reason of having this patchset was to have a single
preferred_cpu()
routine, which can be used by all frameworks. Timers being the first
user (already),
workqueues tried to be the second one.

I tested it more from functionality point of view rather than with
power figures :(
And i understood, that it is very much required.

Having said that, I believe all the questions raised are on PATCH 3/4
(workqueue).
And other 3 patches should be fine. Can you share your opinion on those patches,
I will then split this patchset and send workqueue stuff after doing some power
measurements later.

--
viresh
