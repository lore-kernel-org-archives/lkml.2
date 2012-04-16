Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2DPWTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:19:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42375 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2DPWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:18:58 -0400
Date: Mon, 16 Apr 2012 14:02:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120416210234.GA3490@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
 <20120405123759.GE1963@zod.bos.redhat.com>
 <20120405140006.GB27672@linux.vnet.ibm.com>
 <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
 <20120405143918.GE27672@linux.vnet.ibm.com>
 <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
 <20120410160706.GF2428@linux.vnet.ibm.com>
 <4F859E0E.8050408@wanadoo.fr>
 <20120412180432.GE2394@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412180432.GE2394@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041622-2398-0000-0000-000005DE54D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 11:04:32AM -0700, Paul E. McKenney wrote:
> On Wed, Apr 11, 2012 at 05:06:54PM +0200, Pascal wrote:

[ . . .]

> > RCU_IDLE_GP_DELAY=3 instead of 6 does not improve significantly
> > startup time. Shutdown is shorter, but there are still some delays on
> > umounting some sysfs or oldroot mounts (not always the same).
> > Startup time always varies randomly from 12s to 22s (8s stable without
> > RCU_FAST_NO_HZ).
> > The tasks taking time during startup are rarely the same from boot to
> > boot,and some of them run after filesystems mounting.
> > Example : "console-kit-system-log-start.service" systemd unit took 5s to
> > complete in my last try, and 1s in the previous run. This one occurs
> > after mountings.
> > I enabled CONFIG_RCU_TRACE, and hey, the result in debugfs is beyond
> > my knowledge :(
> > Do you want some data from sys/kernel/debug/rcu (rcudata, ...) ?
> 
> So it seems that mount and unmount operations are often slower with
> RCU_FAST_NO_HZ during boot and shutdown.  Are these operations also
> slower during runtime?  If so, the RCU event tracing across both a fast
> and a slow mount or unmount operation would likely be quite helpful.

Actually, one other possibility is that RCU_FAST_NO_HZ's timer is
being migrated.  If you get a chance, could you please try out the
diagnostic patch below?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Check for timer migration for RCU_FAST_NO_HZ

If RCU_FAST_NO_HZ's timer is migrated, then the CPU that went dyntick-idle
with callbacks might never wake up, which could indefinitely postpone
invocation of its callbacks, which could in turn result in a system hang.
But if the timer is migrated, then it might actually fire.  In contrast,
if it remains on the CPU that posted it, it is guaranteed to be cancelled.

This patch therefore adds a WARN_ON_ONCE() to this timer's handler as
a diagnostic test.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..67ee640 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2053,6 +2053,7 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
  */
 static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
 {
+	WARN_ON_ONCE(1);
 	trace_rcu_prep_idle("Timer");
 	return HRTIMER_NORESTART;
 }

