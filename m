Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1DEN2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:54506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1DEN2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:22 -0400
Subject: Re: [patch 05/15] sched: unthrottle cfs_rq(s) who ran out of quota
 at period refresh
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
In-Reply-To: <20110323030449.142198821@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.142198821@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:13 +0200
Message-ID: <1302010093.2225.1328.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> +static u64 distribute_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 runtime)
> +{
> +       int i;
> +       u64 quota, remaining = runtime;
> +       const struct cpumask *span;
> +
> +       rcu_read_lock();
> +       span = sched_bw_period_mask();
> +       for_each_cpu(i, span) {
> +               struct rq *rq = cpu_rq(i);
> +               struct cfs_rq *cfs_rq = cfs_bandwidth_tg(cfs_b)->cfs_rq[i];
> +
> +               raw_spin_lock(&rq->lock);
> +               if (within_bandwidth(cfs_rq))
> +                       goto next;
> +
> +               quota = -cfs_rq->quota_remaining;
> +               quota += sched_cfs_bandwidth_slice();
> +               quota = min(quota, remaining);
> +               remaining -= quota;
> +
> +               cfs_rq->quota_remaining += quota;
> +               if (cfs_rq_throttled(cfs_rq) && cfs_rq->quota_remaining > 0)
> +                       unthrottle_cfs_rq(cfs_rq);
> +
> +next:
> +               raw_spin_unlock(&rq->lock);
> +
> +               if (!remaining)
> +                       break;
> +       }
> +       rcu_read_unlock();
> +
> +       return remaining;
> +}
> +
>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  {
> +       u64 runtime, runtime_assigned;
> +       int idle;
> +
> +       raw_spin_lock(&cfs_b->lock);
> +       runtime = cfs_b->quota;
> +       idle = cfs_b->runtime == cfs_b->runtime_assigned;
> +       raw_spin_unlock(&cfs_b->lock);
> +
> +       if (runtime == RUNTIME_INF)
> +               return 1;
> +
> +       runtime *= overrun;
> +       runtime_assigned = runtime;
> +
> +       runtime = distribute_cfs_bandwidth(cfs_b, runtime);
> +
> +       raw_spin_lock(&cfs_b->lock);
> +       cfs_b->runtime = runtime;
> +       cfs_b->runtime_assigned = runtime_assigned;
> +       raw_spin_unlock(&cfs_b->lock);
> +
> +       return idle;
>  } 

There's something fishy there, it looks like ->runtime can end up being
> ->quota in case of overrun > 1, that shouldn't be possible, the
refresh timer should never over-fill the bucket.

The whole ->runtime_assigned stuff had me confused for a while, but I
guess its the easiest way to determine if we indeed had runtime
consumption.
