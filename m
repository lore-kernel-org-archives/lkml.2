Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0E1FjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:39:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53662 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0E1FjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:39:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <AANLkTilimqXmhOSEvL7DKW9rmsczkv-u2p4vwAX3aPdd@mail.gmail.com>
References: <20100528134133.7E24.A69D9226@jp.fujitsu.com> <AANLkTilimqXmhOSEvL7DKW9rmsczkv-u2p4vwAX3aPdd@mail.gmail.com>
Message-Id: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 14:39:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi, Kosaki.
> 
> On Fri, May 28, 2010 at 1:46 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> * Luis Claudio R. Goncalves <lclaudio@uudg.org> [2010-05-28 00:51:47]:
> >>
> >> > @@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
> >> >   */
> >> >  static void __oom_kill_task(struct task_struct *p, int verbose)
> >> >  {
> >> > +   struct sched_param param;
> >> > +
> >> >     if (is_global_init(p)) {
> >> >             WARN_ON(1);
> >> >             printk(KERN_WARNING "tried to kill init!\n");
> >> > @@ -413,8 +415,9 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
> >> >      */
> >> >     p->rt.time_slice = HZ;
> >> >     set_tsk_thread_flag(p, TIF_MEMDIE);
> >> > -
> >> >     force_sig(SIGKILL, p);
> >> > +   param.sched_priority = MAX_RT_PRIO-1;
> >> > +   sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> >> >  }
> >> >
> >>
> >> I would like to understand the visible benefits of this patch. Have
> >> you seen an OOM kill tasked really get bogged down. Should this task
> >> really be competing with other important tasks for run time?
> >
> > What you mean important? Until OOM victim task exit completely, the system have no memory.
> > all of important task can't do anything.
> >
> > In almost kernel subsystems, automatically priority boost is really bad idea because
> > it may break RT task's deterministic behavior. but OOM is one of exception. The deterministic
> > was alread broken by memory starvation.
> 
> Yes or No.
> 
> IMHO, normally RT tasks shouldn't use dynamic allocation(ie,
> non-deterministic functions or system calls) in place which is needed
> deterministic. So memory starvation might not break real-time
> deterministic.

I think It's impossible. Normally RT task use mlock and it prevent almost page
allocation. but every syscall internally call kmalloc(). They can't avoid
it practically.

How do you perfectly avoid dynamic allocation?


