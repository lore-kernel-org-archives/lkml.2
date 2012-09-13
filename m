Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2IMQ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:59:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50890 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2IMQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:59:51 -0400
Date: Thu, 13 Sep 2012 09:58:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU lockup in the SMP idle thread, help...
Message-ID: <20120913165844.GW4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
 <50520E8A.9030408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50520E8A.9030408@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091316-7606-0000-0000-000003A1472B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:49:14AM -0700, John Stultz wrote:
> On 09/13/2012 05:36 AM, Linus Walleij wrote:
> >Hi Paul et al,
> >
> >I have this sporadic lockup in the SMP idle thread on ARM U8500:
> >
> >root@ME:/
> >root@ME:/
> >root@ME:/ INFO: rcu_preempt detected stalls on CPUs/tasks: { 0}
> >(detected by 1, t=23190 jiffies)
> >[<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c0068624>]
> >(rcu_check_callbacks+0x69c/0x6e0)
> >[<c0068624>] (rcu_check_callbacks+0x69c/0x6e0) from [<c0029cbc>]
> >(update_process_times+0x38/0x4c)
> >[<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
> >(tick_sched_timer+0x80/0xe4)
> >[<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
> >(__run_hrtimer.isra.18+0x44/0xd0)
> >[<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
> >(hrtimer_interrupt+0x118/0x2b4)
> >[<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
> >(twd_handler+0x30/0x44)
> >[<c0013658>] (twd_handler+0x30/0x44) from [<c0063834>]
> >(handle_percpu_devid_irq+0x80/0xa0)
> >[<c0063834>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00601ec>]
> >(generic_handle_irq+0x2c/0x40)
> >[<c00601ec>] (generic_handle_irq+0x2c/0x40) from [<c000ef58>]
> >(handle_IRQ+0x4c/0xac)
> >[<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
> >[<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
> >Exception stack(0xcf851f88 to 0xcf851fd0)
> >1f80:                   00000020 c05d5920 00000001 00000000 cf850000 cf850000
> >1fa0: c05f4d48 c02de0b4 c05d8d90 412fc091 cf850000 00000000 01000000 cf851fd0
> >1fc0: c000f234 c000f238 60000013 ffffffff
> >[<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
> >[<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
> >[<c000f438>] (cpu_idle+0x98/0xe4) from [<002d2ef4>] (0x2d2ef4)
> >
> >The hangup has been there in the v3.6-rc series for a while (probably
> >since the merge window).
> >
> >I haven't been able to bisect out why this is happening, because the bug
> >is pretty hazardous to check - you have to boot the system and leave it alone
> >or use it sporadically for a while. Then all of a sudden it happens.
> >
> >So: reproducible, but not deterministically reproducible (I hate this kind
> >of thing...)
> >
> >The code involved seems to be generic kernel code apart from the
> >ARM GIC and TWD timer drivers.
> >
> >Any hints or debug options I should switch on?
> 
> I saw this once as well testing the fix to Daniel's deep idle hang
> issue (also on 32 bit).
> 
> Really briefly looking at the code in rcutree.c, I'm curious if
> we're hitting a false positive on the 5 minute jiffies overflow?

Hmmm...  Might be.  Does the patch below help?

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
index 3d63d1c..aea3157 100644
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

