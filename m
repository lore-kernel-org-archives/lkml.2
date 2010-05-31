Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0EaHaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:30:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59935 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0EaHaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:30:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 May 2010 16:25:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-Id: <20100531162552.f7439bc0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTilYtODW-8Ey2IUTT2lRR3sy0kgSOO7rN32rjvux@mail.gmail.com>
References: <20100529125136.62CA.A69D9226@jp.fujitsu.com>
	<AANLkTimg3PuUAmUUib2pdXNyEeniccLSCEvAm9jtKNji@mail.gmail.com>
	<20100531152424.739D.A69D9226@jp.fujitsu.com>
	<AANLkTilYtODW-8Ey2IUTT2lRR3sy0kgSOO7rN32rjvux@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 16:05:48 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Mon, May 31, 2010 at 3:35 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> >> Hi, Kosaki.
> >>
> >> On Sat, May 29, 2010 at 12:59 PM, KOSAKI Motohiro
> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> > Hi
> >> >
> >> >> oom-killer: give the dying task rt priority (v3)
> >> >>
> >> >> Give the dying task RT priority so that it can be scheduled quickly and die,
> >> >> freeing needed memory.
> >> >>
> >> >> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
> >> >
> >> > Almostly acceptable to me. but I have two requests,
> >> >
> >> > - need 1) force_sig() 2)sched_setscheduler() order as Oleg mentioned
> >> > - don't boost priority if it's in mem_cgroup_out_of_memory()
> >>
> >> Why do you want to not boost priority if it's path of memcontrol?
> >>
> >> If it's path of memcontrol and CONFIG_CGROUP_MEM_RES_CTLR is enabled,
> >> mem_cgroup_out_of_memory will select victim task in memcg.
> >> So __oom_kill_task's target task would be in memcg, I think.
> >
> > Yep.
> > But priority boost naturally makes CPU starvation for out of the group
> > processes.
> > It seems to break cgroup's isolation concept.
> >
> >> As you and memcg guys don't complain this, I would be missing something.
> >> Could you explain it? :)
> >
> > So, My points are,
> >
> > 1) Usually priority boost is wrong idea. It have various side effect, but
> >   system wide OOM is one of exception. In such case, all tasks aren't
> >   runnable, then, the downside is acceptable.
> > 2) memcg have OOM notification mechanism. If the admin need priority boost,
> >   they can do it by their OOM-daemon.
> 
> Is it possible kill the hogging task immediately when the daemon send
> kill signal?
> I mean we can make OOM daemon higher priority than others and it can
> send signal to normal process. but when is normal process exited after
> receiving kill signal from OOM daemon? Maybe it's when killed task is
> executed by scheduler. It's same problem again, I think.
> 
> Kame, Do you have an idea?
> 
This is just an idea and I have no implementaion, yet.

With memcg, oom situation can be recovered by "enlarging limit temporary".
Then, what the daemon has to do is

 1. send signal (kill or other signal to abort for coredump.) 
 2. move a problematic task to a jail if necessary.
 3. enlarge limit for indicating "Go"
 4. After stabilization, reduce the limit.

This is the fastest. Admin has to think of extra-room or jails and
the daemon should be enough clever. But in most case, I think this works well.

Thanks,
-Kame

