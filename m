Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1EPN0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:26:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46733 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1EPN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DkpXrzEoTUqY8Woa2R6X8FQCY/WcnK7nDhff2gccWoYIgbHrcRbCqCOcenowHWJEg9
         mJp2lzFIcGhpglsdO9HHW8Xws0NQe7+AasEwpr6DMiM5lNPKrH2THwaNx47cj3mixghq
         XIgBzFdu1mxQla1umItz83SfbhGpLPAJnu2Z4=
Date: Mon, 16 May 2011 21:26:23 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
Message-ID: <20110516132623.GA2058@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110428161149.GA15658@redhat.com>
 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
 <1305129929.2914.247.camel@laptop>
 <4DCCC61F.80408@jp.fujitsu.com>
 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
 <20110515185547.GL2258@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110515185547.GL2258@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:55:47AM -0700, Paul E. McKenney wrote:
> > Seems rcu_spawn_one_cpu_kthread() call wake_up_process() directly,
> > which is under hotplug event CPU_UP_PREPARE. Maybe it should be
> > under CPU_ONLINE.
> 
> Sorry, but this does not work.  The kthread must be running by the time

Yup, I also noticed that from the comments of rcu_spawn_one_cpu_kthread();

> the CPU appears, otherwise RCU grace periods in CPU_ONLINE notifiers
> will never complete.
> 
> This did turn out to be a scheduler bug -- see Cheng Xu's recent patch.
> (chengxu@linux.vnet.ibm.com)

Hmmm, I don't think they are same issue.

The patch sent by Cheng Xu is about rt runtime normalization during
CPU hotplug.

But this one is about too earlier rt_rq load balance.

Let consider this:

		on boot CPU
	...
	kernel_init();
	  smp_init();
	    _cpu_up();
	      __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
	        rcu_cpu_notify();
		  rcu_online_kthreads();
		    rcu_spawn_one_node_kthread();
		      wake_up_process();
		        try_to_wake_up();
			  select_task_rq();
			    select_fallback_rq();
			      cpuset_cpus_allowed_fallback();
			        /* here the rcu_thread's cpus_allowed will be set
				   to cpu_possible_mask, but now we only have the
				   boot cpu online, so it will run on the boot cpu
				   So if we have KOSAKI's patch applied,
				   p->rt.nr_cpus_allowed will be set to
				   cpumask_weight(cpu_possible_mask);
				 */
		      sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
		        __sched_setscheduler();
			  check_class_changed();
			    p->sched_class->switched_to(rq, p); /* rt_class */
			      push_rt_task();
			        find_lock_lowest_rq();
				  find_lowest_rq();
				    /* crash here because local_cpu_mask is uninitialized */


Thanks,
Yong
