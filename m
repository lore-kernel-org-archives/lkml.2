Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1CHSe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:34:59 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34415 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab1CHSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:34:57 -0500
Date: Wed, 9 Mar 2011 00:04:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is
 enabled
Message-ID: <20110308183442.GL2868@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
 <20110304072517.GC2868@balbir.in.ibm.com>
 <AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
 <AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
 <AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
 <AANLkTimy5mPqCEbMv_68XMa7Pq_n_-jq0Pdor8+ck64B@mail.gmail.com>
 <AANLkTi=CxyXHXpa-=CNyyJPOHe-OV0xGr3USKx+TyeqK@mail.gmail.com>
 <20110304121146.GG2868@balbir.in.ibm.com>
 <AANLkTinLe8bMUCTp8Kmv98=s8D8-1qUo78Vff_-Vpgfv@mail.gmail.com>
 <AANLkTi=9nivjLwxACYJUNS6nC0zqOo-EVZbh3am+Cs4C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=9nivjLwxACYJUNS6nC0zqOo-EVZbh3am+Cs4C@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yong Zhang <yong.zhang0@gmail.com> [2011-03-08 16:42:00]:

> On Mon, Mar 7, 2011 at 3:00 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> >
> > I have tested with the attached(web mail will mangle it) patch with
> > yours applied. But I failed to trigger that WARNING.
> >
> > Below is my steps:
> > 1)mount -t cgroup -ocpu cpu /mnt
> > 2)mkdir /mnt/test-1
> > 3)mkdir /mnt/test-1-1
> > 4)set rt_runtime to 100000 for test-1 and test-1-1
> > 5)run a loop task and attach it to test-1-1
> >
> > So I thought out a scenario to satisfy your description,
> > but it's based on the unpatched(without your patch) kernel:
> > Let's assume a dual-core system with test-1/test-1-1
> > for rt group, a loop task is running on CPU 1 and test-1
> > and test-1-1 are both throttled.
> >
> >              CPU-0                                  CPU-1
> > do_sched_rt_period_timer(test-1-1)
> > {
> >  for CPU-1
> >    unthrottled test-1-1.rt_rq[1];
> >      but fail to enqueue it because
> >      we alway get test-1-1.rt_se[0]
> >      due to smp_processor_id();
> >      thus test-1.rt_rq[1].nr_running == 0;
> >      and it returned with run_time == 0;
> > }
> > do_sched_rt_period_timer(test-1)
> >  unthrottle test-1.rt_rt[1] but
> >  fail to enqueue test-1.rt_rt[1];
> >  because nr_running == 0;
> >
> >                           So if we have your patch for issue-1, when
> >                           the hrtimer is running on CPU-1, test-1-1
> >                           and test-1 will be queued because that
> >                           additional check in run_timer == 0 case.
> >
> > But once we have your patch for issue-2, the above
> > problem will be killed by it. right?
> 
> And another finding is that the top rt_rq could trigger your
> additional code, but we don't need to enqueue
> root_task_group.rt_se[].
> 
> BTW, I update my patch(attached) to void testing on top rt_rq.
> 
> Thanks,
> Yong
> 
> 
> -- 
> Only stand for myself

> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 01f75a5..b02b516 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -568,8 +568,14 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>  			raw_spin_unlock(&rt_rq->rt_runtime_lock);
>  		} else if (rt_rq->rt_nr_running) {
>  			idle = 0;
> -			if (!rt_rq_throttled(rt_rq))
> +			if (!rt_rq_throttled(rt_rq)) {
> +				struct sched_rt_entity *rt_se;
> +				int cpu = cpu_of(rq_of_rt_rq(rt_rq));
> +
> +				rt_se = rt_rq->tg->rt_se[cpu];
> +				WARN_ON(rt_se && !on_rt_rq(rt_se));
>  				enqueue = 1;

Fair enough, I think it is good to have the warning in there.

> +			}
>  		}
>  
>  		if (enqueue)


-- 
	Three Cheers,
	Balbir
