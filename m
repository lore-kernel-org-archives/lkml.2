Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2K0Nsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:48:42 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35745 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2K0Nsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:48:41 -0500
MIME-Version: 1.0
In-Reply-To: <1354022770.6276.63.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<1354022770.6276.63.camel@gandalf.local.home>
Date: Tue, 27 Nov 2012 19:18:40 +0530
Message-ID: <CAKohpok5toHdxxjBU+bPJwkZt9Sv-QGY8o8X6HErza1WT-DWOA@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
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

On 27 November 2012 18:56, Steven Rostedt <rostedt@goodmis.org> wrote:
> A couple of things. The sched_select_cpu() is not cheap. It has a double
> loop of domains/cpus looking for a non idle cpu. If we have 1024 CPUs,
> and we are CPU 1023 and all other CPUs happen to be idle, we could be
> searching 1023 CPUs before we come up with our own.

Not sure if you missed the first check sched_select_cpu()

+int sched_select_cpu(unsigned int sd_flags)
+{
+       /* If Current cpu isn't idle, don't migrate anything */
+       if (!idle_cpu(cpu))
+               return cpu;

We aren't going to search if we aren't idle.

> Also, I really don't like this as a default behavior. It seems that this
> solution is for a very special case, and this can become very intrusive
> for the normal case.

We tried with an KCONFIG option for it, which Tejun rejected.

> To be honest, I'm uncomfortable with this approach. It seems to be
> fighting a symptom and not the disease. I'd rather find a way to keep
> work from being queued on wrong CPU. If it is a timer, find a way to
> move the timer. If it is something else, lets work to fix that. Doing
> searches of possibly all CPUs (unlikely, but it is there), just seems
> wrong to me.

As Vincent pointed out, on big LITTLE systems we just don't want to
serve works on big cores. That would be wasting too much of power.
Specially if we are going to wake up big cores.

It would be difficult to control the source driver (which queues work) to
little cores. We thought, if somebody wanted to queue work on current
cpu then they must use queue_work_on().

--
viresh
