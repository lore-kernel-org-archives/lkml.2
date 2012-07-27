Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2G0DWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:22:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44314 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752681Ab2G0DWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:22:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/X8NtAmMPXoED6sSiCtmDiKZJCyeVMPVkEmWOeqN
	/iDP4n7NzoRZ59
Message-ID: <1343359346.6818.37.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] sched: recover SD_WAKE_AFFINE in
 select_task_rq_fair and code clean up
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com
Date: Fri, 27 Jul 2012 05:22:26 +0200
In-Reply-To: <5011F323.10202@intel.com>
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
	 <1343295457.6863.43.camel@marge.simpson.net> <5011F323.10202@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 09:47 +0800, Alex Shi wrote: 
> On 07/26/2012 05:37 PM, Mike Galbraith wrote:
> 
> > On Thu, 2012-07-26 at 13:27 +0800, Alex Shi wrote:
> > 
> >> 	if (affine_sd) {
> >> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> >> +		if (wake_affine(affine_sd, p, sync))
> >>  			prev_cpu = cpu;
> >>  
> >>  		new_cpu = select_idle_sibling(p, prev_cpu);
> > 
> > Hm, if cpu == prev_cpu, asking wake_affine() if it's ok to put wakee
> > back where it came from is wasted cycles.. that's where the task is
> > headed regardless of reply.
> > 
> > -Mike
> > 
> 
> 
> 
> 
> Sure. I modified the patch as below:

(dang, plain text can't make upside down ack;)


> ===
> From 610515185d8a98c14c7c339c25381bc96cd99d93 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Thu, 26 Jul 2012 08:55:34 +0800
> Subject: [PATCH 1/3] sched: recover SD_WAKE_AFFINE in select_task_rq_fair and
>  code clean up
> 
> Since power saving code was removed from sched now, the implement
> code is out of service in this function, and even pollute other logical.
> like, 'want_sd' never has chance to be set '0', that remove the effect
> of SD_WAKE_AFFINE here.
> 
> So, clean up the obsolete code and some other unnecessary code.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |   32 +++-----------------------------
>  1 files changed, 3 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 22321db..53fd8db 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2686,7 +2686,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	int prev_cpu = task_cpu(p);
>  	int new_cpu = cpu;
>  	int want_affine = 0;
> -	int want_sd = 1;
>  	int sync = wake_flags & WF_SYNC;
>  
>  	if (p->nr_cpus_allowed == 1)
> @@ -2704,48 +2703,23 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  			continue;
>  
>  		/*
> -		 * If power savings logic is enabled for a domain, see if we
> -		 * are not overloaded, if so, don't balance wider.
> -		 */
> -		if (tmp->flags & (SD_PREFER_LOCAL)) {
> -			unsigned long power = 0;
> -			unsigned long nr_running = 0;
> -			unsigned long capacity;
> -			int i;
> -
> -			for_each_cpu(i, sched_domain_span(tmp)) {
> -				power += power_of(i);
> -				nr_running += cpu_rq(i)->cfs.nr_running;
> -			}
> -
> -			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
> -
> -			if (nr_running < capacity)
> -				want_sd = 0;
> -		}
> -
> -		/*
>  		 * If both cpu and prev_cpu are part of this domain,
>  		 * cpu is a valid SD_WAKE_AFFINE target.
>  		 */
>  		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
>  		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
>  			affine_sd = tmp;
> -			want_affine = 0;
> -		}
> -
> -		if (!want_sd && !want_affine)
>  			break;
> +		}
>  
>  		if (!(tmp->flags & sd_flag))
>  			continue;
>  
> -		if (want_sd)
> -			sd = tmp;
> +		sd = tmp;
>  	}
>  
>  	if (affine_sd) {
> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
>  
>  		new_cpu = select_idle_sibling(p, prev_cpu);


