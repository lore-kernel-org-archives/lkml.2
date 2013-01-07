Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AGJ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:58:36 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58800 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3AGJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:58:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130104150928.GC15633@mtj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
Date: Mon, 7 Jan 2013 15:28:33 +0530
Message-ID: <CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rostedt@goodmis.org, Tejun Heo <tj@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 4 January 2013 20:39, Tejun Heo <tj@kernel.org> wrote:
> I don't know either.  Changing behavior subtly like this is hard.  I
> usually try to spot some problem cases and try to identify patterns
> there.  Once you identify a few of them, understanding and detecting
> other problem cases get a lot easier.  In this case, maybe there are
> too many places to audit and the problems are too subtle, and, if we
> *have* to do it, the only thing we can do is implementing a debug
> option to make such problems more visible - say, always schedule to a
> different cpu on queue_work().
>
> That said, at this point, the patchset doesn't seem all that
> convincing to me and if I'm comprehending responses from others
> correctly that seems to be the consensus.  It might be a better
> approach to identify the specific offending workqueue users and make
> them handle the situation more intelligently than trying to impose the
> behavior on all workqueue users.  At any rate, we need way more data
> showing this actually helps and if so why.

I understand your concerns and believe me, even i feel the same :)
I had another idea, that i wanted to share.

Firstly the root cause of this patchset.

Myself and some others in Linaro are working on ARM future cores:
big.LITTLE systems.
Here we have few very powerful, high power consuming cores (big,
currently A15's) and
few very efficient ones (LITTLE, currently A7's).

The ultimate goal is to save as much power as possible without compromising
much with performance. For, that we wanted most of the stuff to run on LITTLE
cores and some performance-demanding stuff on big Cores. There are
multiple things
going around in this direction. Now, we thought A15's or big cores
shouldn't be used
for running small tasks like timers/workqueues and hence this patch is
an attempt
towards reaching that goal.

Over that we can do some load balancing of works within multiple alive
cpus, so that
it can get done quickly. Also, we shouldn't start using an idle cpu
just for processing
work :)

I have another idea that we can try:

queue_work_on_any_cpu().

With this we would not break any existing code and can try to migrate
old users to
this new infrastructure (atleast the ones which are rearming works from their
work_handlers). What do you say?

To take care of the cache locality issue, we can pass an argument to
this routine,
that can provide
- the mask of cpus to schedule this work on
  OR
- Sched Level (SD_LEVEL) of cpus to run it.

Waiting for your view on it :)

--
viresh
