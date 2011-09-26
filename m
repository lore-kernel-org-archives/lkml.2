Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1IZI2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:28:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1IZI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:28:43 -0400
Date: Mon, 26 Sep 2011 10:28:37 +0200
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
Subject: [PATCH 1/2] oom: do not live lock on frozen tasks
Message-ID: <20110926082837.GC10156@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com>
 <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com>
 <20110825164758.GB22564@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz>
 <20110826085610.GA9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com>
 <20110826095356.GB9083@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's add some more people to CC list]

Sorry it took so long but I was quite bussy recently.

On Fri 26-08-11 11:13:40, David Rientjes wrote:
> On Fri, 26 Aug 2011, Michal Hocko wrote:
[...]
> > I am not saying the bonus is necessary, though. It depends on what
> > the freezer is used for (e.g. freeze a process which went wild and
> > debug what went wrong wouldn't welcome that somebody killed it or other
> > (mis)use which relies on D state).
> > 
> 
> I'd love to be able to do a thaw on a PF_FROZEN task in the oom killer 
> followed by a SIGKILL if that task is selected for oom kill without an 
> heuristic change.  Not sure if that's possible, so we'll wait for Rafael 
> to chime in.

We have discussed that with Rafael and it should be safe to do that. See
the patch bellow.
The only place I am not entirely sure about is run_guest
(drivers/lguest/core.c). It seems that the code is able to cope with
signals but it also calls lguest_arch_run_guest after try_to_freeze.
---
>From aea3c3fba1e172373877df03a335848cae4b717e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 16 Sep 2011 11:23:15 +0200
Subject: [PATCH 1/2] oom: do not live lock on frozen tasks

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
 mm/oom_kill.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 626303b..b9774f3 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -32,6 +32,7 @@
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -451,6 +452,9 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 				task_pid_nr(q), q->comm);
 			task_unlock(q);
 			force_sig(SIGKILL, q);
+
+			if (frozen(q))
+				thaw_process(q);
 		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
-- 
1.7.5.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
