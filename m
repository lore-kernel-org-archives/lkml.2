Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2DWPQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:16:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:54965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2DWPQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:16:11 -0400
Message-ID: <1335194148.28150.175.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 17:15:48 +0200
In-Reply-To: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> +static
> +int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
> +{
> +       int dmiss = dl_time_before(dl_se->deadline, rq->clock);
> +       int rorun = dl_se->runtime <= 0;
>+
> +       if (!rorun && !dmiss)
> +               return 0;
> +
> +       /*
> +        * If we are beyond our current deadline and we are still
> +        * executing, then we have already used some of the runtime of
> +        * the next instance. Thus, if we do not account that, we are
> +        * stealing bandwidth from the system at each deadline miss!
> +        */
> +       if (dmiss) {
> +               dl_se->runtime = rorun ? dl_se->runtime : 0;
> +               dl_se->runtime -= rq->clock - dl_se->deadline;
> +       }

So ideally this can't happen, but since we already leak time from the
system through means of hardirq / kstop / context-switch-overhead /
clock-jitter etc.. we avoid the error accumulating?

> +
> +       return 1;
> +} 


