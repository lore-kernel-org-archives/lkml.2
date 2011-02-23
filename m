Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1BWCD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:03:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51103 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1BWCD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:03:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D646AC0.7030809@jp.fujitsu.com>
Date: Wed, 23 Feb 2011 11:02:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task accounting
 for SCHED_OTHER
References: <20110216031831.571628191@google.com> <20110216031841.352204682@google.com>
In-Reply-To: <20110216031841.352204682@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/16 12:18), Paul Turner wrote:
> @@ -1428,6 +1464,7 @@ enqueue_task_fair(struct rq *rq, struct 
>  		update_cfs_shares(cfs_rq);
>  	}
>  
> +	account_hier_tasks(&p->se, 1);
>  	hrtick_update(rq);
>  }
>  
> @@ -1461,6 +1498,7 @@ static void dequeue_task_fair(struct rq 
>  		update_cfs_shares(cfs_rq);
>  	}
>  
> +	account_hier_tasks(&p->se, -1);
>  	hrtick_update(rq);
>  }
>  

Why hrtick_update() is need to be delayed after modifying nr_running? 
You should not impact current hrtick logic without once mentioning.

> Index: tip/kernel/sched_rt.c
> ===================================================================
> --- tip.orig/kernel/sched_rt.c
> +++ tip/kernel/sched_rt.c
> @@ -906,6 +906,8 @@ enqueue_task_rt(struct rq *rq, struct ta
>  
>  	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
>  		enqueue_pushable_task(rq, p);
> +
> +	inc_nr_running(rq);
>  }
>  
>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
> @@ -916,6 +918,8 @@ static void dequeue_task_rt(struct rq *r
>  	dequeue_rt_entity(rt_se);
>  
>  	dequeue_pushable_task(rq, p);
> +
> +	dec_nr_running(rq);
>  }
>  
>  /*

I think similar change for sched_stoptask.c is required.

In fact I could not boot tip/master with this v4 patchset.
It reports rcu stall warns without applying following tweak:

--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -35,11 +35,13 @@ static struct task_struct *pick_next_task_stop(struct rq *rq
 static void
 enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+       inc_nr_running(rq);
 }

 static void
 dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+       dec_nr_running(rq);
 }


Thanks,
H.Seto

