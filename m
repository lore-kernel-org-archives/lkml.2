Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1IZP0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:26:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1IZP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:26:51 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=lt9i076Wqa4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=Hkz9nI-ESCQZV4ay8xYA:9 a=nZH5pUFlx90dsmdSqP8A:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH 2/3][RT] sched: Do not compare cpu masks in scheduler
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 26 Sep 2011 11:26:50 -0400
In-Reply-To: <20110926150946.844914281@goodmis.org>
References: <20110926150835.107371360@goodmis.org>
	 <20110926150946.844914281@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317050811.26514.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 11:08 -0400, Steven Rostedt wrote:

Grumble. Quilt seemed to have ignored the From: Peter ... part. 

The last two patches are Peter's not mine. I took his changes from a
patch he gave me on top of my patch.

-- Steve

> plain text document attachment
> (peterz-migrate-disable-no-cpu-compare.patch)
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Index: linux-rt.git/kernel/sched.c
> ===================================================================
> --- linux-rt.git.orig/kernel/sched.c
> +++ linux-rt.git/kernel/sched.c
> @@ -4235,16 +4235,12 @@ static inline void update_migrate_disabl
>  	 */
>  	mask = tsk_cpus_allowed(p);
>  
> -	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
> +	if (p->sched_class->set_cpus_allowed)
> +		p->sched_class->set_cpus_allowed(p, mask);
> +	p->rt.nr_cpus_allowed = cpumask_weight(mask);
>  
> -	if (!cpumask_equal(&p->cpus_allowed, mask)) {
> -		if (p->sched_class->set_cpus_allowed)
> -			p->sched_class->set_cpus_allowed(p, mask);
> -		p->rt.nr_cpus_allowed = cpumask_weight(mask);
> -
> -		/* Let migrate_enable know to fix things back up */
> -		p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
> -	}
> +	/* Let migrate_enable know to fix things back up */
> +	p->migrate_disable |= MIGRATE_DISABLE_SET_AFFIN;
>  }
>  
>  void migrate_disable(void)


