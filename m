Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1IWN1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:27:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1IWN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:27:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jfXJcA1/uRir/FTNocsE+8yDlk2rYhYpdkCoxg/lc3uabR3CGC5PLQ8HSIoq1WGrt
	Kk0WL7bYvqBaOMXlAFbow==
Date: Fri, 23 Sep 2011 06:27:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
In-Reply-To: <1316775204.7562.9.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Mike Galbraith wrote:

> cpusets: allow PF_THREAD_BOUND kworkers to escape from a cpuset
> 
> kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> Allow them to be moved to the root cpuset so the cpuset can be destroyed
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>

Did Li ack this version?

> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10131fd..3769f9e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1384,7 +1384,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
>  	 * be changed.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND && cont != cont->top_cgroup)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -1426,9 +1426,14 @@ static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
>  	/*
>  	 * can_attach beforehand should guarantee that this doesn't fail.
>  	 * TODO: have a better way to handle failure here
> +	 * 
> +	 * Special case: bound kthreads born in a cpuset may be moved to
> +	 * the top level cpuset without attempting to diddle their mask.
>  	 */
> -	err = set_cpus_allowed_ptr(tsk, cpus_attach);
> -	WARN_ON_ONCE(err);
> +	if (!(tsk->flags & PF_THREAD_BOUND && cont == cont->top_cgroup)) {
> +		err = set_cpus_allowed_ptr(tsk, cpus_attach);
> +		WARN_ON_ONCE(err);
> +	}
>  
>  	cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
>  	cpuset_update_task_spread_flag(cs, tsk);

This doesn't make any sense, the user can now change the cpumask of the 
kworker with cpusets but not with sched_setaffinity().

PF_THREAD_BOUND is set specifically so threads cannot move from the cpu 
that they are bound to, that's why the cpuset code and sched_setaffinity() 
reject such a configuration.  So the problem isn't in the cpuset code or 
scheduler at all, you would need to deal with this in the kworker code by 
either not setting PF_THREAD_BOUND (which, according to the comment, Tejun 
thinks is pretty important) or manage the worker threads in a way such 
that the new cpumask (all cpus, since it's in the root cpuset) actually 
make sense for that kworker.  The cpuset code won't care if the kworker 
has a cpumask of all online cpus.
