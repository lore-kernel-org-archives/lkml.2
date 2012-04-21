Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2DUGzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:55:14 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:51765 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUGzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:55:12 -0400
Date: Sat, 21 Apr 2012 14:54:58 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-reply-to: <1334986264.5428.1.camel@marge.simpson.net>
X-Originating-IP: [10.166.88.147]
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-id: <4F9259C2.9040305@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <1333475906.7439.7.camel@marge.simpson.net>
 <20120420175751.GF32324@google.com> <1334986264.5428.1.camel@marge.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:

> On Fri, 2012-04-20 at 10:57 -0700, Tejun Heo wrote: 
>> Hello, Mike.
>>
>> This is dragging out too long but can you please update the patch so
>> that both kthreadd and PF_THREAD_BOUND tasks are disallowed from !root
>> cgroups?
> 
> cgroups: disallow attaching kthreadd or PF_THREAD_BOUND threads
> 
> Allowing kthreadd to be moved to a non-root group makes no sense, it being
> a global resource, and needlessly leads unsuspecting users toward trouble.
> 
> 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> allocated is not schedulable.  Simple user error, but harmful to the box.
> 
> 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> rendering the cpuset immortal.
> 
> Save the user some unexpected trouble, just say no.
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>

> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/cgroup.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -60,6 +60,7 @@
>  #include <linux/eventfd.h>
>  #include <linux/poll.h>
>  #include <linux/flex_array.h> /* used in cgroup_attach_proc */
> +#include <linux/kthread.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -2172,6 +2173,17 @@ static int attach_task_by_pid(struct cgr
>  
>  	if (threadgroup)
>  		tsk = tsk->group_leader;
> +
> +	/*
> +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> +	 * with no rt_runtime allocated.  Just say no.
> +	 */
> +	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
> +		ret = -EINVAL;
> +		goto out_unlock_cgroup;


forgot rcu_read_unlock() ?

Otherwise Acked-by: Li Zefan <lizefan@huawei.com>

> +	}
> +
>  	get_task_struct(tsk);
>  	rcu_read_unlock();

