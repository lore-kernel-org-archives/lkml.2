Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1IZJOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:14:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1IZJOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:14:43 -0400
Date: Mon, 26 Sep 2011 11:14:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] oom: do not live lock on frozen tasks
Message-ID: <20110926091440.GE10156@tiehlicka.suse.cz>
References: <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
 <20110926082837.GC10156@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1109260154510.1389@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109260154510.1389@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-09-11 01:56:57, David Rientjes wrote:
> On Mon, 26 Sep 2011, Michal Hocko wrote:
> 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 626303b..b9774f3 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/mempolicy.h>
> >  #include <linux/security.h>
> >  #include <linux/ptrace.h>
> > +#include <linux/freezer.h>
> >  
> >  int sysctl_panic_on_oom;
> >  int sysctl_oom_kill_allocating_task;
> > @@ -451,6 +452,9 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> >  				task_pid_nr(q), q->comm);
> >  			task_unlock(q);
> >  			force_sig(SIGKILL, q);
> > +
> > +			if (frozen(q))
> > +				thaw_process(q);
> >  		}
> >  
> >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> 
> This is in the wrong place, oom_kill_task() iterates over all threads that 
> are _not_ in the same thread group as the chosen thread and kills them 
> without giving them access to memory reserves.  The chosen task, p, could 
> still be frozen and may not exit.

Ahh, right you are. I ave missed that one. Updated patch bellow.

> 
> Once that's fixed, feel free to add my
> 
> 	Acked-by: David Rientjes <rientjes@google.com>

Thanks

> 
> once Rafael sends his acked-by or reviewed-by.
---
>From f935ed4558c2fb033ef5c14e02b28e12a615f80e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 16 Sep 2011 11:23:15 +0200
Subject: [PATCH] oom: do not live lock on frozen tasks

Konstantin Khlebnikov has reported (https://lkml.org/lkml/2011/8/23/45)
that OOM can end up in a live lock if select_bad_process picks up a frozen
task.
Unfortunately we cannot mark such processes as unkillable to ignore them
because we could panic the system even though there is a chance that
somebody could thaw the process so we can make a forward process (e.g. a
process from another cpuset or with a different nodemask).

Let's thaw an OOM selected frozen process right after we've sent fatal
signal from oom_kill_task.
Thawing is safe if the frozen task doesn't access any suspended device
(e.g. by ioctl) on the way out to the userspace where we handle the
signal and die. Note, we are not interested in the kernel threads because
they are not oom killable.

Accessing suspended devices by a userspace processes shouldn't be an
issue because devices are suspended only after userspace is already
frozen and oom is disabled at that time.

run_guest (drivers/lguest/core.c) calls try_to_freeze with an user
context but it seems it is able to cope with signals because it
explicitly checks for pending signals so we should be safe.

Other than that userspace accesses the fridge only from the
signal handling routines so we are able to handle SIGKILL without any
negative side effects.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/oom_kill.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 626303b..c419a7e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -32,6 +32,7 @@
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -451,10 +452,15 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 				task_pid_nr(q), q->comm);
 			task_unlock(q);
 			force_sig(SIGKILL, q);
+
+			if (frozen(q))
+				thaw_process(q);
 		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
+	if (frozen(p))
+		thaw_process(p);
 
 	return 0;
 }
-- 
1.7.5.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
