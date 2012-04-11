Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2DKQOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:14:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab2DKQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:14:46 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=rcl-2mVQVphY_GoDj8kA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334160884.23924.260.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 12:14:44 -0400
In-Reply-To: <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

> +static int latest_cpu_find(struct cpumask *span,
> +			   struct task_struct *task,
> +			   struct cpumask *later_mask)
>  {
> +	const struct sched_dl_entity *dl_se = &task->dl;
> +	int cpu, found = -1, best = 0;
> +	u64 max_dl = 0;
> +
> +	for_each_cpu(cpu, span) {
> +		struct rq *rq = cpu_rq(cpu);
> +		struct dl_rq *dl_rq = &rq->dl;
> +
> +		if (cpumask_test_cpu(cpu, &task->cpus_allowed) &&
> +		    (!dl_rq->dl_nr_running || dl_time_before(dl_se->deadline,
> +		     dl_rq->earliest_dl.curr))) {
> +			if (later_mask)
> +				cpumask_set_cpu(cpu, later_mask);
> +			if (!best && !dl_rq->dl_nr_running) {

I hate to say this (and I also have yet to look at the patches after
this) but we should really take into account the RT tasks. It would suck
to preempt a normal RT task when a non RT task is running on another
CPU.

-- Steve

> +				best = 1;
> +				found = cpu;
> +			} else if (!best &&
> +				   dl_time_before(max_dl,
> +						  dl_rq->earliest_dl.curr)) {
> +				max_dl = dl_rq->earliest_dl.curr;
> +				found = cpu;
> +			}
> +		} else if (later_mask)
> +			cpumask_clear_cpu(cpu, later_mask);
> +	}
> +
> +	return found;
> +}


