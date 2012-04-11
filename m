Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab2DKRZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:25:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760711Ab2DKRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:25:11 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=SYwpt0jP41I9Y4JlBXoA:9 a=mA6tE1hawSyUz-inWQ0A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334165108.23924.275.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, Kirill Tkhai <tkhai@yandex.ru>
Date: Wed, 11 Apr 2012 13:25:08 -0400
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
>  static void set_cpus_allowed_dl(struct task_struct *p,
> @@ -622,10 +1346,145 @@ static void set_cpus_allowed_dl(struct task_struct *p,
>  
>  	BUG_ON(!dl_task(p));
>  
> +	/*
> +	 * Update only if the task is actually running (i.e.,
> +	 * it is on the rq AND it is not throttled).
> +	 */
> +	if (on_dl_rq(&p->dl) && (weight != p->dl.nr_cpus_allowed)) {
> +		struct rq *rq = task_rq(p);
> +
> +		if (!task_current(rq, p)) {
> +			/*
> +			 * If the task was on the pushable list,
> +			 * make sure it stays there only if the new
> +			 * mask allows that.
> +			 */
> +			if (p->dl.nr_cpus_allowed > 1)
> +				dequeue_pushable_dl_task(rq, p);
> +
> +			if (weight > 1)
> +				enqueue_pushable_dl_task(rq, p);
> +		}
> +
> +		if ((p->dl.nr_cpus_allowed <= 1) && (weight > 1)) {
> +			rq->dl.dl_nr_migratory++;
> +		} else if ((p->dl.nr_cpus_allowed > 1) && (weight <= 1)) {
> +			BUG_ON(!rq->dl.dl_nr_migratory);
> +			rq->dl.dl_nr_migratory--;
> +		}
> +
> +		update_dl_migration(&rq->dl);

Note, I'm in the process of testing this patch:

 https://lkml.org/lkml/2012/4/11/7

Just giving you a heads up, as this looks like you can benefit from this
change as well.

-- Steve


> +	}
> +
>  	cpumask_copy(&p->cpus_allowed, new_mask);
>  	p->dl.nr_cpus_allowed = weight;
>  }
> +


