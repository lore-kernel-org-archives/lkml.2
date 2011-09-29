Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1I2LvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:51:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1I2LvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:51:07 -0400
Date: Thu, 29 Sep 2011 13:51:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
Message-ID: <20110929115105.GE21113@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
 <20110928104445.GB15062@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928104445.GB15062@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-09-11 12:44:45, Michal Hocko wrote:
> On Tue 27-09-11 11:35:04, David Rientjes wrote:
> > On Tue, 27 Sep 2011, Michal Hocko wrote:
> > 
> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > index 626303b..c419a7e 100644
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/mempolicy.h>
> > >  #include <linux/security.h>
> > >  #include <linux/ptrace.h>
> > > +#include <linux/freezer.h>
> > >  
> > >  int sysctl_panic_on_oom;
> > >  int sysctl_oom_kill_allocating_task;
> > > @@ -451,10 +452,15 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> > >  				task_pid_nr(q), q->comm);
> > >  			task_unlock(q);
> > >  			force_sig(SIGKILL, q);
> > > +
> > > +			if (frozen(q))
> > > +				thaw_process(q);
> > >  		}
> > >  
> > >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> > >  	force_sig(SIGKILL, p);
> > > +	if (frozen(p))
> > > +		thaw_process(p);
> > >  
> > >  	return 0;
> > >  }
> > 
> > Also needs this...
> > 
> > 
> > oom: thaw threads if oom killed thread is frozen before deferring
> > 
> > If a thread has been oom killed and is frozen, thaw it before returning
> > to the page allocator.  Otherwise, it can stay frozen indefinitely and
> > no memory will be freed.
> 
> OK, I can see the race now:
> oom_kill_task				refrigerator
>   set_tsk_thread_flag(p, TIF_MEMDIE);
>   force_sig(SIGKILL, p);
>   if (frozen(p))
>   	thaw_process(p)
> 					  frozen_process();
> 					  [...]
> 					  if (!frozen(current))
> 					  	break;
> 					  schedule();
> 
> select_bad_process
>   [...]
>   if (test_tsk_thread_flag(p, TIF_MEMDIE))
> 	  return ERR_PTR(-1UL);
> 
> So we either have to make sure that TIF_MEMDIE task is not frozen in
> select_bad_process (your patch) or check for fatal_signal_pending
> in refrigerator before we schedule and break out of the loop. Maybe the
> later one is safer? Rafael?

What about this?
---
>From 2c9d15f19ae9b5e8f2497b41c1718782bc65e1e7 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 29 Sep 2011 13:45:22 +0200
Subject: [PATCH] freezer: Get out of refrigerator if fatal signals are
 pending

We should make sure that the current task doesn't enter refrigerator if
it has fatal signals pending because it should get to the signals
processing as soon as possible.

This closes a possible race when OOM killer selects a task which is
about to enter the fridge but it is not set as frozen yet. This will
lead to a livelock because select_bad_process would skip that task due
to TIF_MEMDIE set for the process but there is no chance for further
process.
oom_kill_task                           refrigerator
  set_tsk_thread_flag(p, TIF_MEMDIE);
  force_sig(SIGKILL, p);
  if (frozen(p))
        thaw_process(p)
                                          frozen_process();
                                          [...]
                                          if (!frozen(current))
                                                break;
                                          schedule();

select_bad_process
  [...]
  if (test_tsk_thread_flag(p, TIF_MEMDIE))
          return ERR_PTR(-1UL);

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/freezer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 7b01de9..74b8434 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -48,6 +48,10 @@ void refrigerator(void)
 	current->flags |= PF_FREEZING;
 
 	for (;;) {
+		if (fatal_signal_pending(current)) {
+			current->flags &= ~PF_FROZEN;
+			break;
+		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
-- 
1.7.6.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
