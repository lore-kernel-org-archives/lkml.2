Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0DMSWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0DMSWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:22:43 -0400
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
Message-ID: <1271182937.4807.1879.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> +/*
> + * Here we check if --at time t-- a task (which is probably being
> + * [re]activated or, in general, enqueued) can use its remaining runtime
> + * and its current deadline _without_ exceeding the bandwidth it is
> + * assigned (function returns true if it can).
> + *
> + * For this to hold, we must check if:
> + *   runtime / (deadline - t) < dl_runtime / dl_deadline .
> + */
> +static bool dl_check_bandwidth(struct sched_dl_entity *dl_se, u64 t)
> +{
> +       u64 left, right;
> +
> +       /*
> +        * left and right are the two sides of the equation above,
> +        * after a bit of shuffling to use multiplications instead
> +        * of divisions.
> +        */
> +       left = dl_se->dl_deadline * dl_se->runtime;
> +       right = (dl_se->deadline - t) * dl_se->dl_runtime;
> +
> +       return dl_time_before(left, right);
> +} 

So what happens when we overflow u64?
