Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab0DMS4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:56:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0DMS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:56:12 -0400
X-Authority-Analysis: v=1.1 cv=1q2Jdmkya6HpgEM2jHRumxnsV1n7rNYmAqK1mJgD7XY= c=1 sm=0 a=oGiRKSgVe0sA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=EOmwEXn-UUGbao6RjUwA:9 a=e3cWyBv-m3qlbYQRBZmh7_fx0ZkA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 02/11] sched: SCHED_DEADLINE policy implementation.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1271182937.4807.1879.camel@twins>
References: <1267383976.13676.79.camel@Palantir>
	 <1267384639.13676.87.camel@Palantir>  <1271182937.4807.1879.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:55:54 -0400
Message-ID: <1271184954.7962.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 20:22 +0200, Peter Zijlstra wrote:
> On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> > +/*
> > + * Here we check if --at time t-- a task (which is probably being
> > + * [re]activated or, in general, enqueued) can use its remaining runtime
> > + * and its current deadline _without_ exceeding the bandwidth it is
> > + * assigned (function returns true if it can).
> > + *
> > + * For this to hold, we must check if:
> > + *   runtime / (deadline - t) < dl_runtime / dl_deadline .
> > + */
> > +static bool dl_check_bandwidth(struct sched_dl_entity *dl_se, u64 t)
> > +{
> > +       u64 left, right;
> > +
> > +       /*
> > +        * left and right are the two sides of the equation above,
> > +        * after a bit of shuffling to use multiplications instead
> > +        * of divisions.
> > +        */
> > +       left = dl_se->dl_deadline * dl_se->runtime;
> > +       right = (dl_se->deadline - t) * dl_se->dl_runtime;
> > +
> > +       return dl_time_before(left, right);
> > +} 
> 
> So what happens when we overflow u64?

Is the resolution in nanosecs starting from zero? If so, then we don't
need to worry about overflow for 583 years? And that is only if the
difference in time is greater than 292 years since dl_time_before() does
a:

  (s64)(a - b) < 0

The (s64)(a - b) returns the difference even on overflow as long as the
difference is not greater than 2^63


-- Steve


