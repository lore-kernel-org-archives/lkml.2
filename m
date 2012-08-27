Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2H0Svf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:51:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51412 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2H0Svd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:51:33 -0400
Date: Mon, 27 Aug 2012 11:17:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: suspicious RCU usage in rcu_torture_writer()
Message-ID: <20120827181750.GJ6122@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120825033623.GA19330@localhost>
 <20120826000149.GG3436@linux.vnet.ibm.com>
 <20120827044052.GA16267@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827044052.GA16267@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082718-2356-0000-0000-000001A1CE00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 12:40:52PM +0800, Fengguang Wu wrote:
> On Sat, Aug 25, 2012 at 05:01:49PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 25, 2012 at 11:36:23AM +0800, Fengguang Wu wrote:
> > > Greetings,
> > > 
> > > I got this warning on 3.6.0-rc2. Full dmesg/config attached.
> > > 
> > > [    3.051375] Initializing RT-Tester: OK
> > > [    3.052491] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stut
> > > ter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> > > [    3.059084] 
> > > [    3.059451] ===============================
> > > [    3.060454] [ INFO: suspicious RCU usage. ]
> > > [    3.061482] 3.6.0-rc2-00010-g4c58c42 #59 Not tainted
> > > [    3.062686] -------------------------------
> > > [    3.063744] /c/kernel-tests/src/stable/kernel/rcutorture.c:990 suspicious rcu_dereference_check() usage!
> > > 
> > >  982         do {
> > >  983                 schedule_timeout_uninterruptible(1);
> > >  984                 rp = rcu_torture_alloc();
> > >  985                 if (rp == NULL)
> > >  986                         continue;
> > >  987                 rp->rtort_pipe_count = 0;
> > >  988                 udelay(rcu_random(&rand) & 0x3ff);
> > >  989                 old_rp = rcu_dereference_check(rcu_torture_current,
> > > >990                                                current == writer_task);
> > >  991                 rp->rtort_mbtest = 1;
> > >  992                 rcu_assign_pointer(rcu_torture_current, rp);
> > >  993                 smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
> > >  994                 if (old_rp) {
> > 
> > 
> > Does the following clear this up?
> 
> Sorry I'm still trying to reproduce this. It must be a rare bug
> because it only showed up in several of the tens of thousands of test
> boots. To reproduce it, I've done near 1000 boots however still not
> caught it yet. Let's run it for more time...

I will push the fix up for 3.7, if something else is happening, we can
debug when it comes up.  ;-)

							Thanx, Paul

> Thanks,
> Fengguang
> 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Prevent initialization race in rcutorture kthreads
> > 
> > When you do something like "t = kthread_run(...)", it is possible that
> > the kthread will start running before the assignment to "t" happens.
> > If the child kthread expects to find a pointer to its task_struct in "t",
> > it will then be fatally disappointed.  This commit therefore switches
> > such cases to kthread_create() followed by wake_up_process(), guaranteeing
> > that the assignment happens before the child kthread starts running.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 7a97b5b..8ff4fad 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -2028,14 +2028,15 @@ rcu_torture_init(void)
> >  	/* Start up the kthreads. */
> >  
> >  	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
> > -	writer_task = kthread_run(rcu_torture_writer, NULL,
> > -				  "rcu_torture_writer");
> > +	writer_task = kthread_create(rcu_torture_writer, NULL,
> > +				     "rcu_torture_writer");
> >  	if (IS_ERR(writer_task)) {
> >  		firsterr = PTR_ERR(writer_task);
> >  		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
> >  		writer_task = NULL;
> >  		goto unwind;
> >  	}
> > +	wake_up_process(writer_task);
> >  	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
> >  				   GFP_KERNEL);
> >  	if (fakewriter_tasks == NULL) {
> > @@ -2150,14 +2151,15 @@ rcu_torture_init(void)
> >  	}
> >  	if (shutdown_secs > 0) {
> >  		shutdown_time = jiffies + shutdown_secs * HZ;
> > -		shutdown_task = kthread_run(rcu_torture_shutdown, NULL,
> > -					    "rcu_torture_shutdown");
> > +		shutdown_task = kthread_create(rcu_torture_shutdown, NULL,
> > +					       "rcu_torture_shutdown");
> >  		if (IS_ERR(shutdown_task)) {
> >  			firsterr = PTR_ERR(shutdown_task);
> >  			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
> >  			shutdown_task = NULL;
> >  			goto unwind;
> >  		}
> > +		wake_up_process(shutdown_task);
> >  	}
> >  	i = rcu_torture_onoff_init();
> >  	if (i != 0) {
> 

