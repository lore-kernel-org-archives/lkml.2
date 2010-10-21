Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0JUMKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:10:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52870 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0JUMKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:10:18 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1287595605.3488.52.camel@twins>
References: <20100929070153.GA2200@brouette>
	 <20101014145813.GA2185@brouette>  <20101020132732.GA30024@brouette>
	 <1287581440.3488.16.camel@twins>  <1287582208.3488.20.camel@twins>
	 <1287584073.3488.22.camel@twins>  <1287595605.3488.52.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 14:09:59 +0200
Message-ID: <1287662999.3488.117.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 19:26 +0200, Peter Zijlstra wrote:

> -static void calc_load_account_idle(struct rq *this_rq)
> +void calc_load_account_idle(void)
>  {
> +	struct rq *this_rq = this_rq();
>  	long delta;
>  
>  	delta = calc_load_fold_active(this_rq);
> +	this_rq->calc_load_inactive = delta;
> +	this_rq->calc_load_seq = atomic_read(&calc_load_seq);
> +
>  	if (delta)
>  		atomic_long_add(delta, &calc_load_tasks_idle);
>  }
>  
> +void calc_load_account_nonidle(void)
> +{
> +	struct rq *this_rq = this_rq();
> +
> +	if (atomic_read(&calc_load_seq) == this_rq->calc_load_seq) {
> +		atomic_long_sub(this_rq->calc_load_inactive, &calc_load_tasks_idle);
> +		/*
> +		 * Undo the _fold_active() from _account_idle(). This
> +		 * avoids us loosing active tasks and creating a negative
> +		 * bias
> +		 */
> +		this_rq->calc_load_active -= this_rq->calc_load_inactive;
> +	}
> +}

Ok, so while trying to write a changelog on this patch I got myself
terribly confused again..

calc_load_active_fold() is a relative operation and simply gives delta
values since the last time it got called. That means that the sum of
multiple invocations in a given time interval should be identical to a
single invocation.

Therefore, the going idle multiple times during LOAD_FREQ hypothesis
doesn't really make sense. 

Even if it became idle but wasn't idle at the LOAD_FREQ turn-over it
shouldn't matter, since the calc_load_account_active() call will simply
fold the remaining delta with the accrued idle delta and the total
should all match up once we fold into the global calc_load_tasks.

So afaict its should all have worked and this patch is a big NOP,.
except it isn't.. 

Damn I hate this bug.. ;-) Anybody?
