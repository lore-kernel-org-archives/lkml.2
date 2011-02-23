Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1BWCnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:43:17 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49559 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1BWCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:43:16 -0500
Date: Wed, 23 Feb 2011 08:13:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
Message-ID: <20110223024305.GE3379@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.352204682@google.com>
 <4D646AC0.7030809@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D646AC0.7030809@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> [2011-02-23 11:02:40]:

> (2011/02/16 12:18), Paul Turner wrote:
> > @@ -1428,6 +1464,7 @@ enqueue_task_fair(struct rq *rq, struct 
> >  		update_cfs_shares(cfs_rq);
> >  	}
> >  
> > +	account_hier_tasks(&p->se, 1);
> >  	hrtick_update(rq);
> >  }
> >  
> > @@ -1461,6 +1498,7 @@ static void dequeue_task_fair(struct rq 
> >  		update_cfs_shares(cfs_rq);
> >  	}
> >  
> > +	account_hier_tasks(&p->se, -1);
> >  	hrtick_update(rq);
> >  }
> >  
> 
> Why hrtick_update() is need to be delayed after modifying nr_running? 
> You should not impact current hrtick logic without once mentioning.
> 
> > Index: tip/kernel/sched_rt.c
> > ===================================================================
> > --- tip.orig/kernel/sched_rt.c
> > +++ tip/kernel/sched_rt.c
> > @@ -906,6 +906,8 @@ enqueue_task_rt(struct rq *rq, struct ta
> >  
> >  	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
> >  		enqueue_pushable_task(rq, p);
> > +
> > +	inc_nr_running(rq);
> >  }
> >  
> >  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
> > @@ -916,6 +918,8 @@ static void dequeue_task_rt(struct rq *r
> >  	dequeue_rt_entity(rt_se);
> >  
> >  	dequeue_pushable_task(rq, p);
> > +
> > +	dec_nr_running(rq);
> >  }
> >  
> >  /*
> 
> I think similar change for sched_stoptask.c is required.
> 
> In fact I could not boot tip/master with this v4 patchset.
> It reports rcu stall warns without applying following tweak:
> 
> --- a/kernel/sched_stoptask.c
> +++ b/kernel/sched_stoptask.c
> @@ -35,11 +35,13 @@ static struct task_struct *pick_next_task_stop(struct rq *rq
>  static void
>  enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> +       inc_nr_running(rq);
>  }
> 
>  static void
>  dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> +       dec_nr_running(rq);
>  }
>

Good catch!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
