Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab2DKQdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:33:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7911 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638Ab2DKQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:33:40 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=tO1z9qkOFB1u5LoMgrsA:9 a=CBzvUs5njFLkA3ZKQxMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334162018.23924.268.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 12:33:38 -0400
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
>  
> @@ -543,6 +897,9 @@ static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
>  {
>  	update_curr_dl(rq);
>  	p->se.exec_start = 0;
> +
> +	if (on_dl_rq(&p->dl) && p->dl.nr_cpus_allowed > 1)
> +		enqueue_pushable_dl_task(rq, p);
>  }

Ouch! We need to fix this. This has nothing to do with your patch
series, but if you look at schedule():

	put_prev_task(rq, prev);
	next = pick_next_task(rq);


We put the prev task and then pick the next task. If we call schedule
for some reason when we don't need to really schedule, then we just
added and removed from the pushable rb tree the same task. That is, we
did the rb manipulation twice, for no good reason.

Not sure how to fix this. But it will require a generic change.

-- Steve


