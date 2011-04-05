Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1DEN2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1DEN2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:22 -0400
Subject: Re: [patch 09/15] sched: add exports tracking cfs bandwidth
 control statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110323030449.528412206@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.528412206@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:11 +0200
Message-ID: <1302010091.2225.1316.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> @@ -1431,10 +1432,15 @@ static void unthrottle_cfs_rq(struct cfs
>         struct rq *rq = rq_of(cfs_rq);
>         struct sched_entity *se;
>         struct tg_unthrottle_down_data udd;
> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
>  
>         se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
>  
>         update_rq_clock(rq);
> +       raw_spin_lock(&cfs_b->lock);
> +       cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
> +       raw_spin_unlock(&cfs_b->lock);
> +       cfs_rq->throttled_timestamp = 0;
>  
>         /* don't include throttled window for load statistics */
>         udd.cpu = rq->cpu;

> @@ -1523,6 +1530,11 @@ static int do_sched_cfs_period_timer(str
>         raw_spin_lock(&cfs_b->lock);
>         cfs_b->runtime = runtime;
>         cfs_b->runtime_assigned = runtime_assigned;
> +
> +       /* update throttled stats */
> +       cfs_b->nr_periods++;

Aren't you under-counting the periods, shouldn't that be += overrun?

> +       if (throttled)
> +               cfs_b->nr_throttled++;

idem?

>         raw_spin_unlock(&cfs_b->lock);
>  
>         return idle;

