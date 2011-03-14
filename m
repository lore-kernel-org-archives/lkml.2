Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1CNVgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:36:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1CNVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:36:02 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=xhGTy1HZDggA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ipVQNDbXozVtx4Q8krgA:9 a=u21-jV3ZDdianZwZgeoA:7 a=DJ3uB8hdMvxDrSHSm7J-8EO7vPkA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 14 Mar 2011 17:35:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [RFC][PATCH 02/14] sched: Simplify cpu_power initialization
Message-ID: <20110314213559.GE20259@home.goodmis.org>
References: <20110314150613.749843433@chello.nl>
 <20110314152226.541815887@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314152226.541815887@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 04:06:15PM +0100, Peter Zijlstra wrote:
> The code in update_group_power() does what init_sched_groups_power()
> does and more, so remove the special init_ code and call the generic
> code instead.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  kernel/sched.c |   44 +++++---------------------------------------
>  1 file changed, 5 insertions(+), 39 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -6655,9 +6655,6 @@ cpu_attach_domain(struct sched_domain *s
>  	struct rq *rq = cpu_rq(cpu);
>  	struct sched_domain *tmp;
>  
> -	for (tmp = sd; tmp; tmp = tmp->parent)
> -		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
> -
>  	/* Remove the sched domains which do not contribute to scheduling. */
>  	for (tmp = sd; tmp; ) {
>  		struct sched_domain *parent = tmp->parent;

This and ...

[ snip what was explained in change log ]

>  
>  /*
> @@ -7483,7 +7446,7 @@ static int __build_sched_domains(const s
>  {
>  	enum s_alloc alloc_state = sa_none;
>  	struct s_data d;
> -	struct sched_domain *sd;
> +	struct sched_domain *sd, *tmp;
>  	int i;
>  #ifdef CONFIG_NUMA
>  	d.sd_allnodes = 0;
> @@ -7506,6 +7469,9 @@ static int __build_sched_domains(const s
>  		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
>  		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
>  		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
> +
> +		for (tmp = sd; tmp; tmp = tmp->parent)
> +			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
>  	}
>  
>  	for_each_cpu(i, cpu_map) {
> 

this, looks like a separate change than what was explained in the change
log. Did you forget a "quilt new" between these two changes?

-- Steve

