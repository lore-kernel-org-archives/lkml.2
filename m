Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0FWHW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:22:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0FWHW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:22:58 -0400
Message-ID: <4C21B6FE.8060801@cn.fujitsu.com>
Date: Wed, 23 Jun 2010 15:25:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Miles Lane <miles.lane@gmail.com>, paulmck@linux.vnet.ibm.com,
       Vivek Goyal <vgoyal@redhat.com>, Eric Paris <eparis@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] sched: silence PROVE_RCU in sched_fork()
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>	 <20100608001929.GF2387@linux.vnet.ibm.com>	 <AANLkTikl13cJNuU32JzRarrUnoh5DYHr-Tbnv9B-UjsG@mail.gmail.com>	 <1275986441.5408.111.camel@twins>	 <AANLkTimXVlgzHivCQberLdrFP8BH_nJzt8_ozUNHG_aI@mail.gmail.com>	 <1276004075.2987.208.camel@twins>	 <AANLkTil6ucLZ0A6tWx-OQt_2EeKnx8nSx6rIg2t1L2t5@mail.gmail.com>	 <1276097068.1745.13.camel@laptop>	 <AANLkTinl2JKUX6859Ioa1y0DqHWXH5TrkissQ8BAF4cP@mail.gmail.com>	 <AANLkTilpM9O373rA0cw_wTYVfTiDPbjaKHScAGlt7IAr@mail.gmail.com>	 <1276106229.1745.65.camel@laptop> <1276107311.1745.66.camel@laptop>	 <AANLkTilG5bjN5QaOChmuVN6vT7kMK4eGaV-DvPynBn_t@mail.gmail.com>	 <1276118458.1745.144.camel@laptop>	 <AANLkTilsDv59zbL7rbAgJByz_vSnZ0QlbK3dVJUX2VYQ@mail.gmail.com> <1277199893.1875.690.camel@laptop>
In-Reply-To: <1277199893.1875.690.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Paul Menage, Li Zefan, any comments?
> 
> 
> ---
> Because cgroup_fork() is ran before sched_fork() [ from copy_process() ]
> and the child's pid is not yet visible the child is pinned to its
> cgroup. Therefore we can silence this warning.
> 

The explanation is correct.

We silenced another warning according to the same reason.

See freezer_fork() in kernel/cgroup_freezer.c

> A nicer solution would be moving cgroup_fork() to right after
> dup_task_struct() and exclude PF_STARTING from task_subsys_state().
> 

Seems PF_STARTING is set in copy_flags(), that's after dup_task_struct() and
before cgroup_fork(). But it's cleared after copy_process(), that's after
the task is linked into tasklist, so this doesn't seem work...

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

For this patch:

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/sched.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b697606..2e79518 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2561,7 +2561,16 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	if (p->sched_class->task_fork)
>  		p->sched_class->task_fork(p);
>  
> +	/*
> +	 * The child is not yet in the pid-hash so no cgroup attach races,
> +	 * and the cgroup is pinned to this child due to cgroup_fork()
> +	 * is ran before sched_fork().
> +	 *
> +	 * Silence PROVE_RCU.
> +	 */
> +	rcu_read_lock();
>  	set_task_cpu(p, cpu);
> +	rcu_read_unlock();
>  
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	if (likely(sched_info_on()))
> 
> 
> 
