Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0EaF6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:58:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34346 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab0EaF6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:58:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 May 2010 14:54:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-Id: <20100531145415.5e53f837.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTil75ziCd6bivhpmwojvhaJ2LVxwEaEaBEmZf2yN@mail.gmail.com>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	<AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	<20100528145329.7E2D.A69D9226@jp.fujitsu.com>
	<20100528125305.GE11364@uudg.org>
	<20100528140623.GA11041@barrios-desktop>
	<20100528143617.GF11364@uudg.org>
	<20100528151249.GB12035@barrios-desktop>
	<20100528152842.GH11364@uudg.org>
	<20100528154549.GC12035@barrios-desktop>
	<20100528164826.GJ11364@uudg.org>
	<20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikFk_HnZWPG0s_VrRkro2rruEc8OBX5KfKp_QdX@mail.gmail.com>
	<20100531140443.b36a4f02.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTil75ziCd6bivhpmwojvhaJ2LVxwEaEaBEmZf2yN@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 14:46:05 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Mon, May 31, 2010 at 2:04 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 31 May 2010 14:01:03 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> Hi, Kame.
> >>
> >> On Mon, May 31, 2010 at 9:21 AM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> > On Fri, 28 May 2010 13:48:26 -0300
> >> > "Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:
> >> >>
> >> >> oom-killer: give the dying task rt priority (v3)
> >> >>
> >> >> Give the dying task RT priority so that it can be scheduled quickly and die,
> >> >> freeing needed memory.
> >> >>
> >> >> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
> >> >>
> >> >> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> >> >> index 84bbba2..2b0204f 100644
> >> >> --- a/mm/oom_kill.c
> >> >> +++ b/mm/oom_kill.c
> >> >> @@ -266,6 +266,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints)
> >> >>   */
> >> >>  static void __oom_kill_task(struct task_struct *p, int verbose)
> >> >>  {
> >> >> +     struct sched_param param;
> >> >> +
> >> >>       if (is_global_init(p)) {
> >> >>               WARN_ON(1);
> >> >>               printk(KERN_WARNING "tried to kill init!\n");
> >> >> @@ -288,6 +290,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
> >> >>        * exit() and clear out its resources quickly...
> >> >>        */
> >> >>       p->time_slice = HZ;
> >> >> +     param.sched_priority = MAX_RT_PRIO-10;
> >> >> +     sched_setscheduler(p, SCHED_FIFO, &param);
> >> >>       set_tsk_thread_flag(p, TIF_MEMDIE);
> >> >>
> >> >
> >> > BTW, how about the other threads which share mm_struct ?
> >>
> >> Could you elaborate your intention? :)
> >>
> >
> > IIUC, the purpose of rising priority is to accerate dying thread to exit()
> > for freeing memory AFAP. But to free memory, exit, all threads which share
> > mm_struct should exit, too. I'm sorry if I miss something.
> 
> How do we kill only some thread and what's the benefit of it?
> I think when if some thread receives  KILL signal, the process include
> the thread will be killed.
> 
yes, so, if you want a _process_ die quickly, you have to acceralte the whole
threads on a process. Acceralating a thread in a process is not big help.

Thanks,
-Kame

