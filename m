Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1IWJNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:13:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1IWJND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:13:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=FwOkcRLEf4ec0yo87SC3Xsi4TEpwXQ7KZJif4nyxWZZm2vDqQ7gmQEXv34ZCyflMH
	Pah6XvB1qpw2IfecEsooQ==
Date: Fri, 23 Sep 2011 02:12:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>, Tejun Heo <htejun@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
In-Reply-To: <1316762345.8168.4.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Mike Galbraith wrote:

> Done, your ACK added as well.
> 
> kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> Allow them to be moved to the root cpuset so the cpuset can be destroyed.
> 

Thanks Li for the cc since I introduced this flag.

Does this even work?

You've modified cpuset_can_attach() to allow the attach for the cgroup 
interface, but the actual function that attaches the task in the cpuset 
code should fail since it does set_cpus_allowed_ptr() which should return 
-EINVAL because of the PF_THREAD_BOUND.  That should have emitted a 
WARN_ON() if this patch was tested.

kworkers can always move themselves to the root cpuset, so that's probably 
the better way of handling this than requiring userspace to do so.

And it seems like the workqueue code has a comment specifically about cpu 
hotplug and why changing their cpumask shouldn't be allowed that was added 
by Tejun Heo in db7bccf45cb8 ("workqueue: reimplement CPU hotplugging 
support using trustee").  So let's cc him here as well at his 
non-kernel.org address.

> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10131fd..b26f4c4 100644
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
