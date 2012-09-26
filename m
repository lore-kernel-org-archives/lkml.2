Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2IZEez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 00:34:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41038 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2IZEex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 00:34:53 -0400
Date: Tue, 25 Sep 2012 21:34:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
Message-ID: <20120926043445.GB2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120925111938.GA4545@localhost>
 <20120925150701.GA2502@linux.vnet.ibm.com>
 <20120926042237.GA18287@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926042237.GA18287@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092604-2876-0000-0000-0000007DBA8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 12:22:37PM +0800, Fengguang Wu wrote:
> On Tue, Sep 25, 2012 at 08:07:01AM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 25, 2012 at 07:19:38PM +0800, Fengguang Wu wrote:
> > > Hi Paul,
> > > 
> > > I've just bisected down one RCU stall problem:
> > > 
> > > [   12.035785] pktgen: Packet Generator for packet performance testing. Version: 2.74
> > > [   12.435439] atkbd: probe of serio0 rejects match -19
> > > [  111.700160] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10002 jiffies)
> > > [  111.700171] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-00004-gda10491 #1
> > > [  111.700178] Call Trace:
> > > [  111.700475]  [<c10c3c84>] rcu_check_callbacks+0x544/0x570
> > > [  111.700538]  [<c1075e86>] update_process_times+0x36/0x70
> > > [  111.700547]  [<c10a6267>] tick_sched_timer+0x57/0xc0
> > > [  111.700552]  [<c108758a>] __run_hrtimer.isra.31+0x4a/0xc0
> > > [  111.700557]  [<c10a6210>] ? tick_nohz_handler+0xf0/0xf0
> > > [  111.700559]  [<c1088155>] hrtimer_interrupt+0xf5/0x290
> > > [  111.700562]  [<c1091cb8>] ? sched_clock_idle_wakeup_event+0x18/0x20
> > > [  111.700565]  [<c10a6399>] ? tick_nohz_stop_idle+0x39/0x40
> > > [  111.700572]  [<c104f56f>] smp_apic_timer_interrupt+0x4f/0x80
> > > [  111.700587]  [<c1753636>] apic_timer_interrupt+0x2a/0x30
> > > [  111.700593]  [<c10565b5>] ? native_safe_halt+0x5/0x10
> > > [  111.700599]  [<c1039f89>] default_idle+0x29/0x50
> > > [  111.700601]  [<c103a958>] cpu_idle+0x68/0xb0
> > > [  111.700609]  [<c16f2ff7>] rest_init+0x67/0x70
> > > [  111.700627]  [<c1af7929>] start_kernel+0x2ea/0x2f0
> > > [  111.700629]  [<c1af7474>] ? repair_env_string+0x51/0x51
> > > [  111.700631]  [<c1af72a2>] i386_start_kernel+0x78/0x7d
> > > [  127.040302] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
> > > [  127.041308] CPA self-test:
> > > 
> > > to this commit:
> > > 
> > > commit 06ae115a1d551cd952d80df06eaf8b5153351875
> > > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Date:   Sun Aug 14 15:56:54 2011 -0700
> > > 
> > >     rcu: Avoid having just-onlined CPU resched itself when RCU is idle
> > 
> > Interesting.  Of course the stack is from the CPU that detected the
> > problem rather than the problematic CPU.  ;-)
> > 
> > Could you please try the following patch?
> 
> Paul, thanks for the quick fix! However it may still stall sometimes.
> Attached are 3 dmesgs with the stalls.

Do you have c96ea7cf from -rcu applied?  Corresponding patch is below.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Avoid spurious RCU CPU stall warnings

If a given CPU avoids the idle loop but also avoids starting a new
RCU grace period for a full minute, RCU can issue spurious RCU CPU
stall warnings.  This commit fixes this issue by adding a check for
ongoing grace period to avoid these spurious stall warnings.

Reported-by: Becky Bruce <bgillbruce@gmail.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2cf8eb3..98f2752 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -819,7 +819,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	j = ACCESS_ONCE(jiffies);
 	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
+	if (rcu_gp_in_progress(rsp) &&
+	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);

