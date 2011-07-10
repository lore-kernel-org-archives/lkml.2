Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1GJXPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:15:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35501 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab1GJXPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:15:01 -0400
Date: Sun, 10 Jul 2011 16:14:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110710231449.GQ6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110708002903.GI6014@linux.vnet.ibm.com>
 <20110709100900.GB6014@linux.vnet.ibm.com>
 <CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
 <20110710032510.GG6014@linux.vnet.ibm.com>
 <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
 <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 10:50:48PM +0100, julie Sullivan wrote:
> > Very cool!  Thank you very much for the testing --
> 
> My pleasure
> 
> > I will put together an
> > upstreamable commit with your Tested-by.

And here is what I am proposing sending upstream.  I have your Tested-by,
but had to make a small but very real change in order to make it work
under all configurations that I test under.  So could you please try
the attached patch out?  I am particularly interested in how it works
out when CONFIG_RCU_BOOST=n.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Prevent RCU callbacks from executing during early boot

Under some rare but real combinations of configuration parameters, RCU
callbacks are posted during early boot that use kernel facilities that
are not yet initialized.  Therefore, when these callbacks are invoked,
hard hangs and crashes ensue.  This commit therefore prevents RCU
callbacks from being invoked until after the scheduler is up and running.

It might well turn out that a better approach is to identify the specific
RCU callbacks that are causing this problem, but that discussion will
wait until such time as someone really needs an RCU callback to be
invoked during early boot.

Reported-by: julie Sullivan <kernelmail.jms@gmail.com>
Tested-by: julie Sullivan <kernelmail.jms@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7e59ffb..4c0210f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1467,7 +1467,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	if (likely(!rsp->boost)) {
+	if (likely(rcu_scheduler_active && !rsp->boost)) {
 		rcu_do_batch(rsp, rdp);
 		return;
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 14dc7dd..ca3c6dc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1703,7 +1703,7 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 
 static void invoke_rcu_callbacks_kthread(void)
 {
-	WARN_ON_ONCE(1);
+	WARN_ON_ONCE(rcu_scheduler_active);
 }
 
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
