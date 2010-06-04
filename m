Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0FDCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:42:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0FDCmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:42:18 -0400
Message-ID: <4C0868A0.5080508@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 10:44:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious rcu_dereference_check()
 usage
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com> <20100602145653.GA2385@linux.vnet.ibm.com> <4C07743C.7030204@cn.fujitsu.com> <20100603183040.GA2385@linux.vnet.ibm.com>
In-Reply-To: <20100603183040.GA2385@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems worth reviewing the other uses of task_group():
> 
> 1.	set_task_rq() -- only a runqueue and a sched_rt_entity leave
> 	the RCU read-side critical section.  Runqueues do persist.
> 	I don't claim to understand the sched_rt_entity life cycle.
> 
> 2.	__sched_setscheduler() -- not clear to me that this one is
> 	protected to begin with.  If it is somehow correctly protected,
> 	it discards the RCU-protected pointer immediately, so is OK
> 	otherwise.
> 
> 3.	cpu_cgroup_destroy() -- ditto.
> 
> 4.	cpu_shares_read_u64() -- ditto.
> 
> 5.	print_task() -- protected by rcu_read_lock() and discards the
> 	RCU-protected pointer immediately, so this one is OK.
> 
> Any task_group() experts able to weigh in on #2, #3, and #4?
> 

#3 and #4 are safe, because it's not calling task_group(), but
cgroup_tg():

	struct task_group *tg = cgroup_tg(cgrp);

As long as it's safe to access cgrp, it's safe to access tg.

> 							Thanx, Paul
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 50ec9ea..224ef98 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1251,7 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	}
>  
>  	tg = task_group(p);
> -	rcu_read_unlock();
>  	weight = p->se.load.weight;
>  
>  	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
> @@ -1268,6 +1267,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	balanced = !this_load ||
>  		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
>  		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
> +	rcu_read_unlock();
>  

This is fine.

Another way is :

rcu_read_lock();
tg = task_group(p);
css_get(&tg->css);
rcu_read_unlock();

/* do something */
...

css_put(&tg->css);
