Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2DWLzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:55:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:51574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWLzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:55:38 -0400
Message-ID: <1335182113.28150.132.camel@twins>
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
Date: Mon, 23 Apr 2012 13:55:13 +0200
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
> +/*
> + * Here we check if --at time t-- an entity (which is probably being
> + * [re]activated or, in general, enqueued) can use its remaining runtime
> + * and its current deadline _without_ exceeding the bandwidth it is
> + * assigned (function returns true if it can).
> + *
> + * For this to hold, we must check if:
> + *   runtime / (deadline - t) < dl_runtime / dl_deadline .

It might be good to put a few words in as to why that is.. I know I
always forget (but know where to find it by now), also might be good to
refer those papers Tommaso listed when Steven asked this a while back.

> + */
> +static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
> +{
> +       u64 left, right;
> +
> +       /*
> +        * left and right are the two sides of the equation above,
> +        * after a bit of shuffling to use multiplications instead
> +        * of divisions.
> +        *
> +        * Note that none of the time values involved in the two
> +        * multiplications are absolute: dl_deadline and dl_runtime
> +        * are the relative deadline and the maximum runtime of each
> +        * instance, runtime is the runtime left for the last instance
> +        * and (deadline - t), since t is rq->clock, is the time left
> +        * to the (absolute) deadline. Therefore, overflowing the u64
> +        * type is very unlikely to occur in both cases.
> +        */
> +       left = dl_se->dl_deadline * dl_se->runtime;
> +       right = (dl_se->deadline - t) * dl_se->dl_runtime;


>From what I can see there are no constraints on the values in
__setparam_dl() so the above left term can be constructed to be an
overflow.

Ideally we'd use u128 here, but I don't think people will let us :/

> +       return dl_time_before(right, left);
> +} 
