Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1IWKxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:53:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45605 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752429Ab1IWKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:53:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19LpzlPclBLY+aZHzBf9hfdWSZjTTuWypqVgfIZ4G
	vmWflxxJaagxkl
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <1316770936.6641.11.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 12:53:24 +0200
Message-ID: <1316775204.7562.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 11:42 +0200, Mike Galbraith wrote:
> On Fri, 2011-09-23 at 02:12 -0700, David Rientjes wrote:
> > On Fri, 23 Sep 2011, Mike Galbraith wrote:
> > 
> > > Done, your ACK added as well.
> > > 
> > > kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> > > Allow them to be moved to the root cpuset so the cpuset can be destroyed.
> > > 
> > 
> > Thanks Li for the cc since I introduced this flag.
> > 
> > Does this even work?
> 
> Yup, but..
> 
> > You've modified cpuset_can_attach() to allow the attach for the cgroup 
> > interface, but the actual function that attaches the task in the cpuset 
> > code should fail since it does set_cpus_allowed_ptr() which should return 
> > -EINVAL because of the PF_THREAD_BOUND.  That should have emitted a 
> > WARN_ON() if this patch was tested.
> 
> ..you're right that it warns.  It was tested, but I didn't notice that
> it had griped at me.
> 
> > kworkers can always move themselves to the root cpuset, so that's probably 
> > the better way of handling this than requiring userspace to do so.
> 
> kworker is sleeping in a cpuset that the user wants to depopulate and
> destroy.  I wasn't requiring the user to do that, was allowing him to.

So unless there's some reason kworker threads should worry about their
birthplace, seems to me we should just let the cpuset interface handle
the oddball case.

cpusets: allow PF_THREAD_BOUND kworkers to escape from a cpuset

kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
Allow them to be moved to the root cpuset so the cpuset can be destroyed

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10131fd..3769f9e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1384,7 +1384,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
 	 * be changed.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND && cont != cont->top_cgroup)
 		return -EINVAL;
 
 	return 0;
@@ -1426,9 +1426,14 @@ static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
 	/*
 	 * can_attach beforehand should guarantee that this doesn't fail.
 	 * TODO: have a better way to handle failure here
+	 * 
+	 * Special case: bound kthreads born in a cpuset may be moved to
+	 * the top level cpuset without attempting to diddle their mask.
 	 */
-	err = set_cpus_allowed_ptr(tsk, cpus_attach);
-	WARN_ON_ONCE(err);
+	if (!(tsk->flags & PF_THREAD_BOUND && cont == cont->top_cgroup)) {
+		err = set_cpus_allowed_ptr(tsk, cpus_attach);
+		WARN_ON_ONCE(err);
+	}
 
 	cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
 	cpuset_update_task_spread_flag(cs, tsk);


