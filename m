Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966336Ab2JZUEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:04:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45332 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966316Ab2JZUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:04:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/1jtRnI7P1Mhwxxr9L6DEFuU4mWbZyUP9fjV8Ioa
	vtuvRTyqudVuL8
Message-ID: <1351281877.16639.98.camel@maggy.simpson.net>
Subject: Re: process hangs on do_exit when oom happens
From: Mike Galbraith <efault@gmx.de>
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 26 Oct 2012 13:04:37 -0700
In-Reply-To: <1351270990.16639.92.camel@maggy.simpson.net>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	 <20121019160425.GA10175@dhcp22.suse.cz>
	 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
	 <CAKTCnzkMQQXRdx=ikydsD9Pm3LuRgf45_=m7ozuFmSZyxazXyA@mail.gmail.com>
	 <CAKWKT+bYOf0cEDuiibf6eV2raMxe481y-D+nrBgPWR3R+53zvg@mail.gmail.com>
	 <20121023095028.GD15397@dhcp22.suse.cz>
	 <CAKWKT+b2s4E7Nne5d0UJwfLGiCXqAUgrCzuuZi6ZPdjszVSmWg@mail.gmail.com>
	 <20121023101500.GE15397@dhcp22.suse.cz>
	 <CAKTCnzkiabWK8tAORkhg6oW11VvXS-YqBwDzED_3=J1buhaQnQ@mail.gmail.com>
	 <CAKWKT+ZahFTnPRJ4FCebxfcrcYEBf+PL9Wa_Foygep_gFst4_g@mail.gmail.com>
	 <20121025095719.GA11105@dhcp22.suse.cz>
	 <CAKWKT+ZRTUwer8qhjWGjkra63e10R67UQzezdaCaStz+rvGjxw@mail.gmail.com>
	 <1351270990.16639.92.camel@maggy.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:03 -0700, Mike Galbraith wrote:

> The bug is in the patch that used sched_setscheduler_nocheck().  Plain
> sched_setscheduler() would have replied -EGOAWAY.

sched_setscheduler_nocheck() should say go away too methinks.  This
isn't about permissions, it's about not being stupid in general.

sched: fix __sched_setscheduler() RT_GROUP_SCHED conditionals

Remove user and rt_bandwidth_enabled() RT_GROUP_SCHED conditionals in
__sched_setscheduler().  The end result of kernel OR user promoting a
task in a group with zero rt_runtime allocated is the same bad thing,
and throttle switch position matters little.  It's safer to just say
no solely based upon bandwidth existence, may save the user a nasty
surprise if he later flips the throttle switch to 'on'.

The commit below came about due to sched_setscheduler_nocheck()
allowing a task in a task group with zero rt_runtime allocated to
be promoted by the kernel oom logic, thus marooning it forever.

<quote>
commit 341aea2bc48bf652777fb015cc2b3dfa9a451817
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Thu Apr 14 15:22:13 2011 -0700

    oom-kill: remove boost_dying_task_prio()
    
    This is an almost-revert of commit 93b43fa ("oom: give the dying task a
    higher priority").
    
    That commit dramatically improved oom killer logic when a fork-bomb
    occurs.  But I've found that it has nasty corner case.  Now cpu cgroup has
    strange default RT runtime.  It's 0!  That said, if a process under cpu
    cgroup promote RT scheduling class, the process never run at all.
</quote>

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..d3a35f8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3810,17 +3810,14 @@ recheck:
 	}
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	if (user) {
-		/*
-		 * Do not allow realtime tasks into groups that have no runtime
-		 * assigned.
-		 */
-		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
-				!task_group_is_autogroup(task_group(p))) {
-			task_rq_unlock(rq, p, &flags);
-			return -EPERM;
-		}
+	/*
+	 * Do not allow realtime tasks into groups that have no runtime
+	 * assigned.
+	 */
+	if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0 &&
+			!task_group_is_autogroup(task_group(p))) {
+		task_rq_unlock(rq, p, &flags);
+		return -EPERM;
 	}
 #endif
 


