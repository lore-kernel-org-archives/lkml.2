Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab1GKORe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:17:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59396 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab1GKORa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:17:30 -0400
Date: Mon, 11 Jul 2011 07:17:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: RKK <kulkarni.ravi4@gmail.com>
Cc: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
Message-ID: <20110711141727.GC2245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
 <20110709160131.GA18172@linux.vnet.ibm.com>
 <20110711035137.GA14739@linux.vnet.ibm.com>
 <CAM=x7SZztLDeB4_mRqnLLKeyzOuVLqGQ5pBmxpdRUKe5EyKr3A@mail.gmail.com>
 <20110711101856.GR6014@linux.vnet.ibm.com>
 <CAM=x7Sa1Tb2Vn-RL=AFsJZKFYbnHxOp2Qpn9O3D7p6FVFtuf6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM=x7Sa1Tb2Vn-RL=AFsJZKFYbnHxOp2Qpn9O3D7p6FVFtuf6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 07:12:25PM +0530, RKK wrote:
> Hi Paul
> On Mon, Jul 11, 2011 at 3:48 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Jul 11, 2011 at 10:46:30AM +0530, RKK wrote:
> >> Hi Paul,
> >> On Mon, Jul 11, 2011 at 9:21 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Sat, Jul 09, 2011 at 09:01:31AM -0700, Paul E. McKenney wrote:
> >> >> On Wed, Jun 29, 2011 at 06:56:35PM +0530, RKK wrote:
> >> >> > Hello,
> >> >> > I tried booting Linux3.0.rc5 on my machine today but everytime it
> >> >> > hangs after this message
> >> >> >
> >> >> > a)starting configure read only root support
> >> >> >
> >> >> > after this waiting for sometime then this message appears
> >> >> >
> >> >> > b)INFO rcu_sched_state: RCU stalls CPU/disks
> >> >> >
> >> >> > i tried to read the Documentation/RCU and enable CONFIG_RCU_TRACE but
> >> >> > dint know how to proceed further  .
> >> >> >
> >> >> > i tried repeating this 4-5 times , one thing i observed that is
> >> >> > appearance of rcu_sched_state is intermittent but everytime the boot
> >> >> > stops/hangs at a) message .
> >> >>
> >> >> Can you set up the SysRq key as described in Documentation/sysrq.txt?
> >> >> This might help you get some information about what the system is doing
> >> >> during the wait time.
> >> >>
> >> >> My guess is that your kernel is spinning with interrupts disabled, and
> >> >> that RCU eventually tries to complain about this.  The possible causes
> >> >> of this are listed in Documentation/RCU/stallwarn.txt.
> >> >
> >> > Could you please try out this patch and see if it helps?
> >> >
> >> >                                                        Thanx, Paul
> >
> > [ . . . ]
> >
> >> Please give me some time as im away. i will test the patch and  get
> >> back to you by today evening .
> >> Warm Regards
> >> Ravi Kulkarni.
> >
> > Just as well -- I fat-fingered the patch creation.  :-/
> >
> > Please see below for the real patch.
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > rcu: Prevent RCU callbacks from executing during early boot
> >
> > Under some rare but real combinations of configuration parameters, RCU
> > callbacks are posted during early boot that use kernel facilities that
> > are not yet initialized.  Therefore, when these callbacks are invoked,
> > hard hangs and crashes ensue.  This commit therefore prevents RCU
> > callbacks from being invoked until after the scheduler is up and running.
> >
> > It might well turn out that a better approach is to identify the specific
> > RCU callbacks that are causing this problem, but that discussion will
> > wait until such time as someone really needs an RCU callback to be
> > invoked during early boot.
> >
> > Reported-by: julie Sullivan <kernelmail.jms@gmail.com>
> > Tested-by: julie Sullivan <kernelmail.jms@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 7e59ffb..4c0210f 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1467,7 +1467,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
> >  */
> >  static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
> >  {
> > -       if (likely(!rsp->boost)) {
> > +       if (likely(rcu_scheduler_active && !rsp->boost)) {
> >                rcu_do_batch(rsp, rdp);
> >                return;
> >        }
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 14dc7dd..ca3c6dc 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -1703,7 +1703,7 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
> >
> >  static void invoke_rcu_callbacks_kthread(void)
> >  {
> > -       WARN_ON_ONCE(1);
> > +       WARN_ON_ONCE(rcu_scheduler_active);
> >  }
> >
> >  static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
> >
> 
> The above patch fixes the bug and now 3.0.rc5 is bootable :). thanks.

Thank you, Ravi!  I have added your Tested-by and will now push this
upstream.

							Thanx, Paul

> maciej rutecki,
> 
> can we close the the below bugzilla entry ?
> https://bugzilla.kernel.org/show_bug.cgi?id=38732
> 
> Warm regards,
> Ravi Kulkarni.
