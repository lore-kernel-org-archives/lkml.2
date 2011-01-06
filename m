Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1AFS2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:28:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab1AFS2c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <20110106092833.GA16125@elte.hu>
References: <20110106092833.GA16125@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 10:28:11 -0800
Message-ID: <AANLkTinotRxScOHEb0HgFgSpGPkq_6jKTv5CfvnQM=ee@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler changes for v2.6.38
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, can we please not do things like this:

> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 155a415..562c56e 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -558,7 +558,7 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
>  static int trace_wakeup_test_thread(void *data)
>  {
>        /* Make this a RT thread, doesn't need to be too high */
> -       struct sched_param param = { .sched_priority = 5 };
> +       static struct sched_param param = { .sched_priority = 5 };
>        struct completion *x = data;
>
>        sched_setscheduler(current, SCHED_FIFO, &param);
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 5b08215..c812c49 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -307,7 +307,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  */
>  static int watchdog(void *unused)
>  {
> -       struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +       static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>        struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>
>        sched_setscheduler(current, SCHED_FIFO, &param);

It's just nasty and horrible.

Now, something like

    "static const struct sched_param param = .."

is fine, if it's really a const thing. But if it's non-const, don't
make it be a static inside a function. Please.

                            Linus
