Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1J2JBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 05:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1J2JBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 05:01:08 -0400
Date: Sat, 29 Oct 2011 11:01:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] oom: do not live lock on frozen tasks
Message-ID: <20111029090105.GB6203@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <20111028152321.103189a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028152321.103189a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-10-11 15:23:21, Andrew Morton wrote:
> On Tue, 27 Sep 2011 10:01:47 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Konstantin Khlebnikov has reported (https://lkml.org/lkml/2011/8/23/45)
> > that OOM can end up in a live lock if select_bad_process picks up a frozen
> > task.
> > Unfortunately we cannot mark such processes as unkillable to ignore them
> > because we could panic the system even though there is a chance that
> > somebody could thaw the process so we can make a forward process (e.g. a
> > process from another cpuset or with a different nodemask).
> > 
> > Let's thaw an OOM selected frozen process right after we've sent fatal
> > signal from oom_kill_task.
> > Thawing is safe if the frozen task doesn't access any suspended device
> > (e.g. by ioctl) on the way out to the userspace where we handle the
> > signal and die. Note, we are not interested in the kernel threads because
> > they are not oom killable.
> > 
> > Accessing suspended devices by a userspace processes shouldn't be an
> > issue because devices are suspended only after userspace is already
> > frozen and oom is disabled at that time.
> > 
> > Other than that userspace accesses the fridge only from the
> > signal handling routines so we are able to handle SIGKILL without any
> > negative side effects or we always check for pending signals after
> > we return from try_to_freeze (e.g. in lguest).
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: David Rientjes <rientjes@google.com>
> > ---
> >  mm/oom_kill.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 626303b..c419a7e 100644
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
> > @@ -451,10 +452,15 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> >  				task_pid_nr(q), q->comm);
> >  			task_unlock(q);
> >  			force_sig(SIGKILL, q);
> > +
> > +			if (frozen(q))
> > +				thaw_process(q);
> >  		}
> >  
> >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> >  	force_sig(SIGKILL, p);
> > +	if (frozen(p))
> > +		thaw_process(p);
> >  
> >  	return 0;
> >  }
> 
> I'm not sure this is 1000% correct.  Perhaps there's a conceivable
> window after the "if (frozen)" test where the task can flip itself into
> the frozen state.

Yes and David's patch
(oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch)
is much better in that regards. So we should go with the other patch.

> 
> thaw_process() itself appears to be callable regardless of the frozen
> state and will do the right thing under the right lock.  So this code
> would be safer, correcter and slower if it unconditionally called
> thaw_process().
> 
> I'm sure it doesn't matter though ;)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
