Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0DANbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0DANaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:30:55 -0400
Date: Thu, 1 Apr 2010 15:13:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 0/1] oom: fix the unsafe usage of badness() in
	proc_oom_score()
Message-ID: <20100401131321.GA11291@redhat.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com> <20100331091628.GA11438@redhat.com> <20100331201746.GC11635@redhat.com> <alpine.DEB.2.00.1004010029260.6285@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004010029260.6285@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, David Rientjes wrote:
>
> On Wed, 31 Mar 2010, Oleg Nesterov wrote:
>
> > But. Oh well. David, oom-badness-heuristic-rewrite.patch changed badness()
> > to consult p->signal->oom_score_adj. Until recently this was wrong when it
> > is called from proc_oom_score().
> >
> > This means oom-badness-heuristic-rewrite.patch depends on
> > signals-make-task_struct-signal-immutable-refcountable.patch, or we
> > need the pid_alive() check again.
> >
>
> oom-badness-heuristic-rewrite.patch didn't change anything, Linus' tree
> currently dereferences p->signal->oom_adj

Yes, I wrongly blaimed oom-badness-heuristic-rewrite.patch, vanilla does
the same.

Now this is really bad, and I am resending my patch.

David, Andrew, I understand it (textually) conflicts with
oom-badness-heuristic-rewrite.patch, but this bug should be fixed imho
before other changes. I hope it will be easy to fixup this chunk

	@@ -447,7 +447,13 @@ static int proc_oom_score(struct task_st

		do_posix_clock_monotonic_gettime(&uptime);
		read_lock(&tasklist_lock);
	-       points = badness(task->group_leader, uptime.tv_sec);
	+       points = oom_badness(task->group_leader,

in that patch.

> >  	do_posix_clock_monotonic_gettime(&uptime);
> >  	read_lock(&tasklist_lock);
> > -	points = oom_badness(task->group_leader,
> > +	if (pid_alive(task))
> > +		points = oom_badness(task,
> >  				global_page_state(NR_INACTIVE_ANON) +
> >  				global_page_state(NR_ACTIVE_ANON) +
> >  				global_page_state(NR_INACTIVE_FILE) +
>
> This should be protected by the get_proc_task() on the inode before
> this function is called from proc_info_read().

No, get_proc_task() shouldn't (and can't) do this. To clarify,
get_proc_task() does check the task wasn't unhashed, but nothing can
prevent from release_task() after that. Once again, only task_struct
itself is protected by get_task_struct(), nothing more.

Oleg.

