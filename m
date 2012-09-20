Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2ITII5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:08:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34401 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2ITIIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:08:50 -0400
Message-ID: <505ACE36.80603@parallels.com>
Date: Thu, 20 Sep 2012 12:05:10 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <lizefan@huawei.com>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <kay.sievers@vrfy.org>,
        <mzxreary@0pointer.de>, <davej@redhat.com>, <ben@decadent.org.uk>,
        <pjt@google.com>
Subject: Re: [PATCH 2/3] cgroup, sched: let cpu serve the same files as cpuacct
References: <1348094625-4471-1-git-send-email-tj@kernel.org> <1348094625-4471-3-git-send-email-tj@kernel.org>
In-Reply-To: <1348094625-4471-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 02:43 AM, Tejun Heo wrote:
> +
> +void task_group_charge(struct task_struct *tsk, u64 cputime)
> +{
> +	struct task_group *tg;
> +	int cpu = task_cpu(tsk);
> +
> +	rcu_read_lock();
> +
> +	tg = container_of(task_subsys_state(tsk, cpu_cgroup_subsys_id),
> +			  struct task_group, css);
> +
> +	for (; tg; tg = tg->parent) {
> +		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
> +		*cpuusage += cputime;
> +	}
> +
> +	rcu_read_unlock();
> +}
>  #endif /* CONFIG_CGROUP_SCHED */

The whole point of this merge is that this is not needed.
This information is already available from exec_clock for fair tasks.
for rt tasks, we have no exec clock, but do have a hierarchy walk a bit
below the current cpuacct charge, that can be used for that purpose.

