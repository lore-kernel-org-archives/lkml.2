Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2DHRzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab2DHRzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:55:02 -0400
Date: Sun, 8 Apr 2012 19:49:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 01/16] sched: add sched_class->task_dead.
Message-ID: <20120408174919.GA28428@redhat.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com> <1333696481-3433-2-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333696481-3433-2-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Juri Lelli wrote:
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3219,6 +3219,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	if (mm)
>  		mmdrop_delayed(mm);
>  	if (unlikely(prev_state == TASK_DEAD)) {
> +		if (prev->sched_class->task_dead)
> +			prev->sched_class->task_dead(prev);
> +

And 5/16 adds

	+static void task_dead_dl(struct task_struct *p)
	+{
	+       struct hrtimer *timer = &p->dl.dl_timer;
	+
	+	if (hrtimer_active(timer))
	+               hrtimer_try_to_cancel(timer);
	+}

This looks suspicious. finish_task_switch() does put_task_struct()
after that, it is quite possible this actually frees the memory.

What if hrtimer_try_to_cancel() fails because the timer is running?
In this case __run_hrtimer() can play with the freed timer. Say, to
clear HRTIMER_STATE_CALLBACK. Not to mention dl_task_timer() itself.

Oleg.

