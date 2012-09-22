Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2IVAFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:05:43 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53041 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2IVAFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:05:41 -0400
Date: Fri, 21 Sep 2012 17:05:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120922000537.GH2454@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120913011208.GT4257@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com>
 <20120920000351.GI2455@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com>
 <20120921212054.GE2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092200-5518-0000-0000-000007D7B209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:41:14PM +0000, Paul Walmsley wrote:
> On Fri, 21 Sep 2012, Paul E. McKenney wrote:
> 
> > On Fri, Sep 21, 2012 at 05:47:31PM +0000, Paul Walmsley wrote:
> >
> > > I built an OMAP kernel from Linus' commit 
> > > 4651afbbae968772efd6dc4ba461cba9b49bb9d8 ("Merge branch 'for-3.6-fixes' of 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq").  The config used 
> > > was 'omap2plus_defconfig', and enabled CONFIG_CPU_IDLE by hand.  Booted it 
> > > on a Pandaboard (OMAP4430ES2) into a very minimal Debian rootfs.
> > 
> > Did you have the patch at https://lkml.org/lkml/2012/8/30/290 applied?
> 
> No, it's just as described above.
> 
> > If not, could you please try it?  (This patch cleared up a similar
> > problem for Becky, also on OMAP.)
> 
> Did not seem to help, either with or without CONFIG_CPU_IDLE.

I was hoping!  ;-)

And my init=/bin/sh kernel ran idle for more than an hour without
any RCU CPU stall warnings...

I am wondering if your system somehow figured out how to start a grace
period that had no RCU callbacks waiting for it.  If that happened,
then a CONFIG_NO_HZ=y system could in theory get into a state where all
CPUs are in dyntick-idle mode, so that none of them is doing anything
to force the grace period to complete.

That should be easy to diagnose, anyway.  Please see below, which
includes the earlier diagnostic patch.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 307caf1..696f189 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -879,6 +879,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	int ndetected = 0;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/* Only let one CPU complain about others per time interval. */
 
@@ -923,8 +924,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	print_cpu_stall_info_end();
-	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
-	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu, q=%lu)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
+	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
@@ -939,8 +943,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 static void print_cpu_stall(struct rcu_state *rsp)
 {
+	int cpu;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/*
 	 * OK, time to rat on ourselves...
@@ -951,7 +957,10 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
-	printk(KERN_CONT " (t=%lu jiffies)\n", jiffies - rsp->gp_start);
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont(" (t=%lu jiffies g=%lu c=%lu q=%lu)\n",
+		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed, totqlen);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 

