Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1IWUU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:20:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1IWUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:20:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=KPAFvbYV+UWYv+ThOv3YaPR+SF4sAxlbQlnpA468Dj6fgdLasoH+qOMf5+ha792Dk
	pJ4hwV/D+eI5Lw1Nyj4kg==
Date: Fri, 23 Sep 2011 13:20:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
In-Reply-To: <1316788392.6544.33.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1109231304310.11347@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Mike Galbraith wrote:

> I don't see why it's a kworker code problem.  The kworker code couldn't
> care less about cpusets.  But I don't care who fixes it or how.
> 

The problem is that PF_THREAD_BOUND means that nothing other than the task 
itself may change the set of allowed cpus to be different.  For this 
reason, they have always been declined to be moved amongst cpusets because 
even though their bound cpu may be a subset of the cpuset's cpumask at the 
time of attach, that cpuset mask may subsequently change and therefore try 
to force the PF_THREAD_BOUND off the cpu it is bound to resulting in an 
inconsistency between the cpuset's mask and an attached task's mask.

Allowing a PF_THREAD_BOUND thread to move to the root cpuset isn't so much 
of a problem because it's guaranteed to never exclude the bound cpu, but 
the problem already exists if the kworker is in the child cpuset and 
userspace attempts to change the mems of that cpuset to be disjoint.  That 
results in an inconsistency because the scheduler will refuse it.

> cpusets: disallow moving kthreadd into a cpuset.
> 
> If kthreadd is moved into a cpuset, it's child may then acquire
> PF_THREAD_BOUND and become trapped, making it's cpuset immortal.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10131fd..0d9cd04 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -59,6 +59,7 @@
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
>  #include <linux/cgroup.h>
> +#include <linux/kthread.h>
>  
>  /*
>   * Workqueue for cpuset related tasks.
> @@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
>  	 * applicable for such threads.  This prevents checking for success of
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> -	 * be changed.
> +	 * be changed.  We also disallow attaching kthreadd, to prevent it's
> +	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
>  		return -EINVAL;
>  
>  	return 0;

I like this much better, let's wait to hear from Tejun because he may 
shead some light on whether PF_THREAD_BOUND is really necessary for 
kworkers at all times.

Thanks.
