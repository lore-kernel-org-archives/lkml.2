Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1JJFe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:34:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1JJFe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:34:56 -0400
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <1316788392.6544.33.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 07:34:52 +0200
Message-ID: <1318224892.6161.45.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Maybe the below (which seems to have been stillborn) should be done to
cgroups as well.  Postmortem: kthreadd is attached to a cgroup with no
rt_runtime allocated, gives birth to severely handicapped kstop threads,
humongous crash dump follows.

Fiddling with kthreadd is user error, but since it makes no sense to
move the thing, why not just say no, and save the user's toes some
needless wear and tear.

> If cpusets doesn't want to let PF_THREAD_BOUND threads out, how about
> cpusets not letting userland scripts attach kthreadd instead?
> 
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
> 


