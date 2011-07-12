Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1GLVNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:13:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33491 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1GLVNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:13:53 -0400
Date: Tue, 12 Jul 2011 23:13:47 +0200
From: Florian Mickler <florian@mickler.org>
To: RKK <kulkarni.ravi4@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, maciej.rutecki@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
Message-ID: <20110712231347.4f2ec2d2@schatten.dmk.lab>
In-Reply-To: <20110711141727.GC2245@linux.vnet.ibm.com>
References: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
	<20110709160131.GA18172@linux.vnet.ibm.com>
	<20110711035137.GA14739@linux.vnet.ibm.com>
	<CAM=x7SZztLDeB4_mRqnLLKeyzOuVLqGQ5pBmxpdRUKe5EyKr3A@mail.gmail.com>
	<20110711101856.GR6014@linux.vnet.ibm.com>
	<CAM=x7Sa1Tb2Vn-RL=AFsJZKFYbnHxOp2Qpn9O3D7p6FVFtuf6w@mail.gmail.com>
	<20110711141727.GC2245@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 07:17:27 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > >> Please give me some time as im away. i will test the patch and  get
> > >> back to you by today evening .
> > >> Warm Regards
> > >> Ravi Kulkarni.
> > >
> > > Just as well -- I fat-fingered the patch creation.  :-/
> > >
> > > Please see below for the real patch.
> > >
> > >                                                        Thanx, Paul
> > >
> > > ------------------------------------------------------------------------
> > >
> > > rcu: Prevent RCU callbacks from executing during early boot
> > >
> > > Under some rare but real combinations of configuration parameters, RCU
> > > callbacks are posted during early boot that use kernel facilities that
> > > are not yet initialized.  Therefore, when these callbacks are invoked,
> > > hard hangs and crashes ensue.  This commit therefore prevents RCU
> > > callbacks from being invoked until after the scheduler is up and running.
> > >
> > > It might well turn out that a better approach is to identify the specific
> > > RCU callbacks that are causing this problem, but that discussion will
> > > wait until such time as someone really needs an RCU callback to be
> > > invoked during early boot.
> > >
> > > Reported-by: julie Sullivan <kernelmail.jms@gmail.com>
> > > Tested-by: julie Sullivan <kernelmail.jms@gmail.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >
> > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > index 7e59ffb..4c0210f 100644
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -1467,7 +1467,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
> > >  */
> > >  static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
> > >  {
> > > -       if (likely(!rsp->boost)) {
> > > +       if (likely(rcu_scheduler_active && !rsp->boost)) {
> > >                rcu_do_batch(rsp, rdp);
> > >                return;
> > >        }
> > > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > > index 14dc7dd..ca3c6dc 100644
> > > --- a/kernel/rcutree_plugin.h
> > > +++ b/kernel/rcutree_plugin.h
> > > @@ -1703,7 +1703,7 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
> > >
> > >  static void invoke_rcu_callbacks_kthread(void)
> > >  {
> > > -       WARN_ON_ONCE(1);
> > > +       WARN_ON_ONCE(rcu_scheduler_active);
> > >  }
> > >
> > >  static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
> > >
> > 
> > The above patch fixes the bug and now 3.0.rc5 is bootable :). thanks.
> 
> Thank you, Ravi!  I have added your Tested-by and will now push this
> upstream.
> 
> 							Thanx, Paul
> 
> > maciej rutecki,
> > 
> > can we close the the below bugzilla entry ?
> > https://bugzilla.kernel.org/show_bug.cgi?id=38732
> > 
> > Warm regards,
> > Ravi Kulkarni.

I added a link to the bugzilla and put it in the 'patch available'
state. 

The rule is to close the bug as soon as the patch hit's
mainline (i.e. Linus' tree). If it has a bugzilla link in the
changelog, I will post an automatic notification to that bug as soon as
Linus releases a kernel with that patch. Else the 'regression tracking
team' will have to manually dig through the bugreport or find a note by
someone involved in the bugzilla to that effect.

Regards,
Flo

