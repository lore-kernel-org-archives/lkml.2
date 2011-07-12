Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1GLV32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:29:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41760 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab1GLV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:29:27 -0400
Date: Tue, 12 Jul 2011 14:29:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712212920.GQ2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
 <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
 <20110711214301.GP2245@linux.vnet.ibm.com>
 <CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:15:40PM +0100, Julie Sullivan wrote:
> On Mon, Jul 11, 2011 at 10:43 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Jul 11, 2011 at 09:37:53PM +0100, julie Sullivan wrote:
> >> > And here is what I am proposing sending upstream.  I have your Tested-by,
> >> > but had to make a small but very real change in order to make it work
> >> > under all configurations that I test under.  So could you please try
> >> > the attached patch out?  I am particularly interested in how it works
> >> > out when CONFIG_RCU_BOOST=n.
> >> >
> >> >                                                        Thanx, Paul
> >> >
> >> > ------------------------------------------------------------------------
> >> >
> >> > rcu: Prevent RCU callbacks from executing during early boot
> >> >
> >> > Under some rare but real combinations of configuration parameters, RCU
> >> > callbacks are posted during early boot that use kernel facilities that
> >> > are not yet initialized.  Therefore, when these callbacks are invoked,
> >> > hard hangs and crashes ensue.  This commit therefore prevents RCU
> >> > callbacks from being invoked until after the scheduler is up and running.
> >> >
> >> > It might well turn out that a better approach is to identify the specific
> >> > RCU callbacks that are causing this problem, but that discussion will
> >> > wait until such time as someone really needs an RCU callback to be
> >> > invoked during early boot.
> >> >
> >> > Reported-by: julie Sullivan <kernelmail.jms@gmail.com>
> >> > Tested-by: julie Sullivan <kernelmail.jms@gmail.com>
> >> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> >
> >> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> >> > index 7e59ffb..4c0210f 100644
> >> > --- a/kernel/rcutree.c
> >> > +++ b/kernel/rcutree.c
> >> > @@ -1467,7 +1467,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
> >> >  */
> >> >  static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
> >> >  {
> >> > -       if (likely(!rsp->boost)) {
> >> > +       if (likely(rcu_scheduler_active && !rsp->boost)) {
> >> >                rcu_do_batch(rsp, rdp);
> >> >                return;
> >> >        }
> >> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >> > index 14dc7dd..ca3c6dc 100644
> >> > --- a/kernel/rcutree_plugin.h
> >> > +++ b/kernel/rcutree_plugin.h
> >> > @@ -1703,7 +1703,7 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
> >> >
> >> >  static void invoke_rcu_callbacks_kthread(void)
> >> >  {
> >> > -       WARN_ON_ONCE(1);
> >> > +       WARN_ON_ONCE(rcu_scheduler_active);
> >> >  }
> >> >
> >> >  static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
> >> >
> >>
> >> Hi Paul,
> >> Is this to be applied on a clean v3.0-rc4? I tried this but I'm afraid
> >> the boot crash is back again (on -rc5 and -rc6 too).
> >
> > I must confess that it did seem to be giving up a bit too easily.  :-(
> >
> > So, I have created a new branch jms.2011.07.11a on the -rcu git tree at:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >
> > If the new branch jms.2011.07.11a fails and the old branch jms.2011.07.07a
> > succeeds (both with CONFIG_RCU_BOOST=n), then that indicates that my
> > mainlinable patch didn't delay the callbacks quite far enough.  On the
> > other hand, if both succeed, then that means that there is another bug
> > lurking later on in the sequence of commits.
> >
> > Could you please test these out?
> >
> >                                                        Thanx, Paul
> >
> 
> OK tested- jms.2011.07.11a fails. The other one's fine (I'm actually
> running an -rc6 with its patches right now :-)

Just to make sure I understand what patch you are using...  Is it the
one that I have listed below?  It would be bad form for me to send the
wrong patch upstream.  ;-)

If this is the correct one, then the upstreamable patch I sent recently
(https://lkml.org/lkml/2011/7/12/313) should also work.  Famous last
words...

							Thanx, Paul

------------------------------------------------------------------------

rcu: prevent RCU callbacks from being invoked during early boot.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dbe4120..4456395 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1476,7 +1476,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	if (likely(!rsp->boost)) {
+	if (likely(rcu_kthreads_spawnable && !rsp->boost)) {
 		rcu_do_batch(rsp, rdp);
 		return;
 	}
