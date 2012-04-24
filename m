Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2DXNPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:15:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2DXNPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:15:52 -0400
Message-ID: <1335273316.28150.194.camel@twins>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 24 Apr 2012 15:15:16 +0200
In-Reply-To: <1334162018.23924.268.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <1334162018.23924.268.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 12:33 -0400, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >  
> > @@ -543,6 +897,9 @@ static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
> >  {
> >  	update_curr_dl(rq);
> >  	p->se.exec_start = 0;
> > +
> > +	if (on_dl_rq(&p->dl) && p->dl.nr_cpus_allowed > 1)
> > +		enqueue_pushable_dl_task(rq, p);
> >  }
> 
> Ouch! We need to fix this. This has nothing to do with your patch
> series, but if you look at schedule():
> 
> 	put_prev_task(rq, prev);
> 	next = pick_next_task(rq);
> 
> 
> We put the prev task and then pick the next task. If we call schedule
> for some reason when we don't need to really schedule, then we just
> added and removed from the pushable rb tree the same task. That is, we
> did the rb manipulation twice, for no good reason.
> 
> Not sure how to fix this. But it will require a generic change.


Something like so: https://lkml.org/lkml/2012/2/16/487 ?
