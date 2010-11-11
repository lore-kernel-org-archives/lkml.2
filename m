Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0KKObT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:31:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59710 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0KKObS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:31:18 -0500
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333876.8661.147.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 15:31:01 +0100
Message-ID: <1289485861.2084.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:31 +0200, Raistlin wrote:
> 
> There sometimes is the need of executing a task as if it would
> have the maximum possible priority in the entire system, i.e.,
> whenever it gets ready it must run! This is for example the case
> for some maintainance kernel thread like migration and (sometimes)
> watchdog or ksoftirq.
> 
> Since SCHED_DEADLINE is now the highest priority scheduling class
> these tasks have to be handled therein, but it is not obvious how
> to choose a runtime and a deadline that guarantee what explained
> above. Therefore, we need a mean of recognizing system tasks inside
> the -deadline class and always run them as soon as possible, without
> any kind of runtime and bandwidth limitation.
> 
> This patch:
>  - adds the SF_HEAD flag, which identify a special task that need
>    absolute prioritization among any other task;
>  - ensures that special tasks always preempt everyone else (and,
>    obviously, are not preempted by non special tasks);
>  - disables runtime and bandwidth checking for such tasks, hoping
>    that the interference they cause is small enough.
> 

Yet in the previous patch you had this hunk:

> +++ b/kernel/sched_stoptask.c
> @@ -81,7 +81,7 @@ get_rr_interval_stop(struct rq *rq, struct
> task_struct *task)
>   * Simple, special scheduling class for the per-CPU stop tasks:
>   */
>  static const struct sched_class stop_sched_class = {
> -       .next                   = &rt_sched_class,
> +       .next                   = &dl_sched_class,
>  
>         .enqueue_task           = enqueue_task_stop,
>         .dequeue_task           = dequeue_task_stop,

