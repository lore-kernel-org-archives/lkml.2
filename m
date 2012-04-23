Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2DWOMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:12:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:53897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2DWOMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:12:18 -0400
Message-ID: <1335190308.28150.146.camel@twins>
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
Date: Mon, 23 Apr 2012 16:11:48 +0200
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
> +static int start_dl_timer(struct sched_dl_entity *dl_se)
> +{
> +       struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +       struct rq *rq = rq_of_dl_rq(dl_rq);
> +       ktime_t now, act;
> +       ktime_t soft, hard;
> +       unsigned long range;
> +       s64 delta;
> +
> +       /*
> +        * We want the timer to fire at the deadline, but considering
> +        * that it is actually coming from rq->clock and not from
> +        * hrtimer's time base reading.
> +        */
> +       act = ns_to_ktime(dl_se->deadline);
> +       now = hrtimer_cb_get_time(&dl_se->dl_timer);
> +       delta = ktime_to_ns(now) - rq->clock;
> +       act = ktime_add_ns(act, delta);


Right, this all is very sad.. but I guess we'll have to like live with
it. The only other option is adding another timer base that tries to
keep itself in sync with rq->clock but that all sounds very painful
indeed.

Keeping up with rq->clock_task would be even more painful since it slows
the clock down in random fashion making the timer fire early.
Compensating that is going to be both fun and expensive.

> +       /*
> +        * If the expiry time already passed, e.g., because the value
> +        * chosen as the deadline is too small, don't even try to
> +        * start the timer in the past!
> +        */
> +       if (ktime_us_delta(act, now) < 0)
> +               return 0;
> +
> +       hrtimer_set_expires(&dl_se->dl_timer, act);
> +
> +       soft = hrtimer_get_softexpires(&dl_se->dl_timer);
> +       hard = hrtimer_get_expires(&dl_se->dl_timer);
> +       range = ktime_to_ns(ktime_sub(hard, soft));
> +       __hrtimer_start_range_ns(&dl_se->dl_timer, soft,
> +                                range, HRTIMER_MODE_ABS, 0);
> +
> +       return hrtimer_active(&dl_se->dl_timer);
> +} 

/me reminds himself to make __hrtimer_start_range_ns() return -ETIME.
