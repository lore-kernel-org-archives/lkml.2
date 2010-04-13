Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0DMSWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0DMSWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:22:33 -0400
Subject: Re: [RFC][PATCH 02/11] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267384639.13676.87.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
	 <1267384639.13676.87.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 20:22:17 +0200
Message-ID: <1271182937.4807.1878.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> +/*
> + * When a -deadline task is queued back on the runqueue, its runtime and
> + * deadline might need updating.
> + *
> + * The policy here is that we update the deadline of the task only if:
> + *  - the current deadline is in the past,
> + *  - using the remaining remaining with the current deadline would make

"remaining runtime", I presume?

> + *    the task exceed its bandwidth.
> + */
> +static void update_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +       struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +       struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +       /*
> +        * The arrival of a new task (or of a new task instance) needs
> +        * special treatment. The actual scheduling parameters have to be
> +        * "renewed" instead of recalculatetd accordingly to the bandwidth
> +        * enforcement rule.
> +        */
> +       if (dl_se->flags & DL_NEW) {
> +               setup_new_dl_entity(dl_se);
> +               return;
> +       }
> +
> +       if (dl_time_before(dl_se->deadline, rq->clock))
> +               goto update;
> +
> +       if (!dl_check_bandwidth(dl_se, rq->clock)) {
> +update:
> +               dl_se->deadline = rq->clock + dl_se->dl_deadline;
> +               dl_se->runtime = dl_se->dl_runtime;
> +       }
> +} 

We could write that as:

  if (dl_time_before(dl_se, rq->clock) ||
      !dl_check_bandwidth(dl_se, rq->clock)) {
	/* reset parameters */
  }

Also, I was wondering about a more descriptive name for
dl_check_bandwidth(), check _what_ about the bandwidth!?

dl_bandwidth_overflow() perhaps, that would also remove that negation.
