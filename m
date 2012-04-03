Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2DCStH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:49:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2DCStF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:49:05 -0400
Date: Tue, 3 Apr 2012 11:49:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120403184901.GC27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333475906.7439.7.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 07:58:26PM +0200, Mike Galbraith wrote:
> @@ -1894,6 +1895,14 @@ int cgroup_attach_task(struct cgroup *cg
>  	if (tsk->flags & PF_EXITING)
>  		return -ESRCH;
>  
> +	/*
> +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> +	 * with no rt_runtime allocated.  Just say no.
> +	 */
> +	if (tsk == kthreadd_task)
> +		return -EINVAL;
> +
>  	/* Nothing to do if the task is already in that cgroup */
>  	oldcgrp = task_cgroup_from_root(tsk, root);
>  	if (cgrp == oldcgrp)
> @@ -2172,6 +2181,17 @@ static int attach_task_by_pid(struct cgr
>  
>  	if (threadgroup)
>  		tsk = tsk->group_leader;
> +
> +	/*
> +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> +	 * with no rt_runtime allocated.  Just say no.
> +	 */
> +	if (tsk == kthreadd_task) {
> +		ret = -EINVAL;
> +		goto out_unlock_cgroup;
> +	}

If we have this test here, do we need the same check in
cgroup_attach_task()/

Thanks.

-- 
tejun
