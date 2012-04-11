Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2DKOKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:10:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2DKOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:10:53 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=f1VtjnAB8uqazjxa5owA:9 a=mXX03aRx6WGuHNVuXs8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334153450.23924.243.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fcheccon@jasper.es
Date: Wed, 11 Apr 2012 10:10:50 -0400
In-Reply-To: <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 21:39 +0800, Hillf Danton wrote:

> > +static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
> > +{
> > +       dl_rq = &rq_of_dl_rq(dl_rq)->dl;
> > +
> > +       dl_rq->dl_nr_total++;
> > +       if (dl_se->nr_cpus_allowed > 1)
> > +               dl_rq->dl_nr_migratory++;
> > +
> > +       update_dl_migration(dl_rq);
> 
> 	if (dl_se->nr_cpus_allowed > 1) {
> 		dl_rq->dl_nr_migratory++;
> 		/* No change in migratory, no update of migration */

This is not true. As dl_nr_total changed. If there was only one dl task
queued that can migrate, and then another dl task is queued but this
task can not migrate, the update_dl_migration still needs to be called.
As dl_nr_migratory would be 1, but now dl_nr_total > 1. This means we
are now overloaded.

> 		update_dl_migration(dl_rq);
> 	}
> 
> > +}
> > +
> > +static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
> > +{
> > +       dl_rq = &rq_of_dl_rq(dl_rq)->dl;
> > +
> > +       dl_rq->dl_nr_total--;
> > +       if (dl_se->nr_cpus_allowed > 1)
> > +               dl_rq->dl_nr_migratory--;
> > +
> > +       update_dl_migration(dl_rq);
> 
> ditto

ditto.

> 
> > +}
> > +
> > +/*
> > + * The list of pushable -deadline task is not a plist, like in
> > + * sched_rt.c, it is an rb-tree with tasks ordered by deadline.

-- Steve


