Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1F3Iel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:34:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:50130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1F3Iea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20778167"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
In-Reply-To: <CAOM-RdMkEKvrh9Vo15WgkfZiFLsMzdss+6XAn2w4Z-oXbt+pkA@mail.gmail.com>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins> <1308876099.23204.124.camel@debian>
	 <1309219329.14604.11.camel@debian> <1309273180.6701.213.camel@twins>
	 <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
	 <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
	 <CAOM-RdMkEKvrh9Vo15WgkfZiFLsMzdss+6XAn2w4Z-oXbt+pkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 16:34:21 +0800
Message-ID: <1309422861.14604.472.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 08:07 +0800, Nikhil Rao wrote:
> On Tue, Jun 28, 2011 at 7:30 PM, Nikhil Rao <ncrao@google.com> wrote:
> > Looking at the schedstat data Alex posted:
> > - Distribution of load balances across cores looks about the same.
> > - Load balancer does more idle balances on 3.0-rc4 as compared to
> > 2.6.39 on SMT and NUMA domains. Busy and newidle balances are a mixed
> > bag.
> > - I see far fewer affine wakeups on 3.0-rc4 as compared to 2.6.39.
> > About half as many affine wakeups on SMT and about a quarter as many
> > on NUMA.
> >
> > I'm investigating the impact of the load resolution patchset on
> > effective load and wake affine calculations. This seems to be the most
> > obvious difference from the schedstat data.
> >
> 
> I went through the math in effective load and wake affine and I think
> it should be OK. There are a couple of corner cases where increasing
> sched load resolution can change the result of wake affine -- I've
> listed them below. However, I not convinced you are hitting these
> cases often enough to make a noticeable difference. I'm looking into
> the other LB paths...
> 
> - One corner case is because of rounding error in the shares update
> path. Let's say the shares update logic assigned weight A to a sched
> entity in the case with scaled resolution, and it assigned weight B
> without scaling weights. Now, we expect A/1024 = B, but this is not
> always the case because of rounding error. The difference between (A
> and B*1024) gets amplified in wake_affine() since it multiplies
> (weight+effective load) with imbalance pct and cpu power -- we
> effectively scale this up by 5 orders of magnitude. In cases where
> prev_eff_load and this_eff_load are pretty close, this difference can
> result in a different result in wake_affine().
> 
> - There's a corner case in effective_load(), where if a task wakes up
> on an empty cfs_rq, you could hit the clamp in effective_load (i.e. <
> MIN_SHARES) which can affect prev_eff_load (you get a lower number --
> making it less likely to do an affine wakeup). I think this patch
> (against 3.0-rc4) will address that issue -- can you please give this
> a try?

I had tried disable CONFIG_FAIR_GROUP_SCHED, and the problem still here.
So, it won't have effect. 
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 433491c..6fcfbfc 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1442,8 +1442,8 @@ static long effective_load(struct task_group
> *tg, int cpu, long wl, long wg)
>                         wl = tg->shares;
> 
>                 /* zero point is MIN_SHARES */
> -               if (wl < MIN_SHARES)
> -                       wl = MIN_SHARES;
> +               if (wl < scale_load(MIN_SHARES))
> +                       wl = scale_load(MIN_SHARES);
>                 wl -= se->load.weight;
>                 wg = 0;
>         }


