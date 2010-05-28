Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0E1Gia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:38:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33602 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0E1Gi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:38:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <20100528062701.GA3519@balbir.in.ibm.com>
References: <20100528134133.7E24.A69D9226@jp.fujitsu.com> <20100528062701.GA3519@balbir.in.ibm.com>
Message-Id: <20100528153410.7E30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 15:38:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-05-28 13:46:53]:
> 
> > > * Luis Claudio R. Goncalves <lclaudio@uudg.org> [2010-05-28 00:51:47]:
> > > 
> > > > @@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
> > > >   */
> > > >  static void __oom_kill_task(struct task_struct *p, int verbose)
> > > >  {
> > > > +	struct sched_param param;
> > > > +
> > > >  	if (is_global_init(p)) {
> > > >  		WARN_ON(1);
> > > >  		printk(KERN_WARNING "tried to kill init!\n");
> > > > @@ -413,8 +415,9 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
> > > >  	 */
> > > >  	p->rt.time_slice = HZ;
> > > >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> > > > -
> > > >  	force_sig(SIGKILL, p);
> > > > +	param.sched_priority = MAX_RT_PRIO-1;
> > > > +	sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> > > >  }
> > > >
> > > 
> > > I would like to understand the visible benefits of this patch. Have
> > > you seen an OOM kill tasked really get bogged down. Should this task
> > > really be competing with other important tasks for run time?
> > 
> > What you mean important? Until OOM victim task exit completely, the system have no memory.
> > all of important task can't do anything.
> > 
> > In almost kernel subsystems, automatically priority boost is really bad idea because
> > it may break RT task's deterministic behavior. but OOM is one of exception. The deterministic
> > was alread broken by memory starvation.
> >
> 
> I am still not convinced, specially if we are running under mem
> cgroup. Even setting SCHED_FIFO does not help, you could have other
> things like cpusets that might restrict the CPUs you can run on, or
> any other policy and we could end up contending anyway with other
> SCHED_FIFO tasks.

Ah, right you are. I had missed mem-cgroup.
But I think memcgroup also don't need following two boost. Can we get rid of it?

	p->rt.time_slice = HZ;
	set_tsk_thread_flag(p, TIF_MEMDIE);


I mean we need distinguish global oom and memcg oom, perhapls. 


> > That's the reason I acked it.
> 
> If we could show faster recovery from OOM or anything else, I would be
> more convinced.






