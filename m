Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0E2D7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:59:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52197 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0E2D7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:59:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <20100528164826.GJ11364@uudg.org>
References: <20100528154549.GC12035@barrios-desktop> <20100528164826.GJ11364@uudg.org>
Message-Id: <20100529125136.62CA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 29 May 2010 12:59:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> oom-killer: give the dying task rt priority (v3)
> 
> Give the dying task RT priority so that it can be scheduled quickly and die,
> freeing needed memory.
> 
> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>

Almostly acceptable to me. but I have two requests, 

- need 1) force_sig() 2)sched_setscheduler() order as Oleg mentioned
- don't boost priority if it's in mem_cgroup_out_of_memory()

Can you accept this? if not, can you please explain the reason?

Thanks.

> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 84bbba2..2b0204f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -266,6 +266,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints)
>   */
>  static void __oom_kill_task(struct task_struct *p, int verbose)
>  {
> +	struct sched_param param;
> +
>  	if (is_global_init(p)) {
>  		WARN_ON(1);
>  		printk(KERN_WARNING "tried to kill init!\n");
> @@ -288,6 +290,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  	 * exit() and clear out its resources quickly...
>  	 */
>  	p->time_slice = HZ;
> +	param.sched_priority = MAX_RT_PRIO-10;
> +	sched_setscheduler(p, SCHED_FIFO, &param);
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
>  
>  	force_sig(SIGKILL, p);
> -- 
> [ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
> [ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]
> 



