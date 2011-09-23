Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1IWOdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:33:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55254 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754140Ab1IWOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:33:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+idSUp2AuitTrpeeqnub8JPmq2BvBHzMEmVTWiRn
	z3s9zV2MekN1LM
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 16:33:12 +0200
Message-ID: <1316788392.6544.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 06:27 -0700, David Rientjes wrote:
> On Fri, 23 Sep 2011, Mike Galbraith wrote:
> 
> > cpusets: allow PF_THREAD_BOUND kworkers to escape from a cpuset
> > 
> > kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> > Allow them to be moved to the root cpuset so the cpuset can be destroyed
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Did Li ack this version?

Oops, no.
 
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > index 10131fd..3769f9e 100644
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -1384,7 +1384,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
> >  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> >  	 * be changed.
> >  	 */
> > -	if (tsk->flags & PF_THREAD_BOUND)
> > +	if (tsk->flags & PF_THREAD_BOUND && cont != cont->top_cgroup)
> >  		return -EINVAL;
> >  
> >  	return 0;
> > @@ -1426,9 +1426,14 @@ static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
> >  	/*
> >  	 * can_attach beforehand should guarantee that this doesn't fail.
> >  	 * TODO: have a better way to handle failure here
> > +	 * 
> > +	 * Special case: bound kthreads born in a cpuset may be moved to
> > +	 * the top level cpuset without attempting to diddle their mask.
> >  	 */
> > -	err = set_cpus_allowed_ptr(tsk, cpus_attach);
> > -	WARN_ON_ONCE(err);
> > +	if (!(tsk->flags & PF_THREAD_BOUND && cont == cont->top_cgroup)) {
> > +		err = set_cpus_allowed_ptr(tsk, cpus_attach);
> > +		WARN_ON_ONCE(err);
> > +	}
> >  
> >  	cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
> >  	cpuset_update_task_spread_flag(cs, tsk);
> 
> This doesn't make any sense, the user can now change the cpumask of the 
> kworker with cpusets but not with sched_setaffinity().

marge:~/tmp # ps l `cat /cpusets/system/tasks`|grep kworker
1     0  6466     2  20   0      0     0 schedu S    ?          0:00 [kworker/2:4]

Ok, there's a kworker which was born in 'system' cpuset, cpus 0-2.

marge:~/tmp # taskset -p 6466
pid 6466's current affinity mask: 4
marge:~/tmp # cset shield --reset
cset: --> deactivating/reseting shielding
cset: moving 7 tasks from "/user" user set to root set...
[==================================================]%
cset: moving 243 tasks from "/system" system set to root set...
[==================================================]%
cset: deleting "/user" and "/system" sets
cset: done
marge:~/tmp # taskset -p 6466
pid 6466's current affinity mask: 4

Worker still alive, affinity intact, 'system' cpuset destroyed, no
gripage in dmesg.  All seems fine.

> PF_THREAD_BOUND is set specifically so threads cannot move from the cpu 
> that they are bound to, that's why the cpuset code and sched_setaffinity() 
> reject such a configuration.

Yeah.

>   So the problem isn't in the cpuset code or 
> scheduler at all, you would need to deal with this in the kworker code by 
> either not setting PF_THREAD_BOUND (which, according to the comment, Tejun 
> thinks is pretty important) or manage the worker threads in a way such 
> that the new cpumask (all cpus, since it's in the root cpuset) actually 
> make sense for that kworker.  The cpuset code won't care if the kworker 
> has a cpumask of all online cpus.

I don't see why it's a kworker code problem.  The kworker code couldn't
care less about cpusets.  But I don't care who fixes it or how.

If cpusets doesn't want to let PF_THREAD_BOUND threads out, how about
cpusets not letting userland scripts attach kthreadd instead?

cpusets: disallow moving kthreadd into a cpuset.

If kthreadd is moved into a cpuset, it's child may then acquire
PF_THREAD_BOUND and become trapped, making it's cpuset immortal.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10131fd..0d9cd04 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/kthread.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
 	 * applicable for such threads.  This prevents checking for success of
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
-	 * be changed.
+	 * be changed.  We also disallow attaching kthreadd, to prevent it's
+	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
 		return -EINVAL;
 
 	return 0;


