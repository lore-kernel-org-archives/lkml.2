Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1AMPok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:44:40 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50569 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab1AMPoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:44:38 -0500
Date: Thu, 13 Jan 2011 07:42:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Weber <weber@corscience.de>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcu_kthread:6 blocked for more than 120 seconds.
Message-ID: <20110113154257.GK17328@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110112174300.GA6504@flint.arm.linux.org.uk>
 <20110112222219.GA17328@linux.vnet.ibm.com>
 <4D2F179E.40401@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F179E.40401@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 04:17:50PM +0100, Thomas Weber wrote:
> Am 12.01.2011 23:22, schrieb Paul E. McKenney:
> > On Wed, Jan 12, 2011 at 05:43:00PM +0000, Russell King wrote:
> >> I'm seeing rcu_kthread get stuck from time to time on ARM Versatile PB
> >> (ARM926).  Kernel is based upon commit 9e9bc973 (immediately prior to
> >> the merge of the OMAP tree.)
> >>
> >> ~ # ps aux|grep rcu
> >> root         6  0.0  0.0      0     0 ?        S    02:31   0:01 [rcu_kthread]
> >> root       502  9.0  0.3   3740   472 ttyAMA0  S+   02:59   0:00 grep rcu
> >> ~ # ps aux|grep rcu
> >> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
> >> root       504  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
> >> ~ # ps aux|grep rcu
> >> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
> >> root       506  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
> >> ~ # ps aux|grep rcu
> >> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
> >> root       508  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
> >> ~ # cat /proc/6/wchan
> >> rcu_kthread
> >> ~ # INFO: task rcu_kthread:6 blocked for more than 120 seconds.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> rcu_kthread     D c02c6684     0     6      2 0x00000000
> >> Backtrace:
> >> [<c02c6388>] (schedule+0x0/0x354) from [<c00836a0>] (rcu_kthread+0x78/0xf4)
> >> [<c0083628>] (rcu_kthread+0x0/0xf4) from [<c00633ac>] (kthread+0x88/0x90)
> >> [<c0063324>] (kthread+0x0/0x90) from [<c004d12c>] (do_exit+0x0/0x5f8)
> >>  r7:00000013 r6:c004d12c r5:c0063324 r4:c181df28
> >> no locks held by rcu_kthread/6.
> > 
> > Does the following patch help?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit 70ce43253a4465211a9c51e33d56a417c759a718
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Wed Jan 12 14:18:11 2011 -0800
> > 
> >     rcu: avoid pointless blocked-task warnings
> >     
> >     If the RCU callback-processing kthread has nothing to do, it parks in
> >     a wait_event().  If RCU remains idle for more than two minutes, the
> >     kernel complains about this.  This commit changes from wait_event()
> >     to wait_event_interruptible() to prevent the kernel from complaining
> >     just because RCU is idle.
> >     
> >     Reported-by: Russell King <rmk@arm.linux.org.uk>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > index 0344937..0c343b9 100644
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -189,7 +189,8 @@ static int rcu_kthread(void *arg)
> >  	unsigned long flags;
> >  
> >  	for (;;) {
> > -		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
> > +		wait_event_interruptible(rcu_kthread_wq,
> > +					 have_rcu_kthread_work != 0);
> >  		morework = rcu_boost();
> >  		local_irq_save(flags);
> >  		work = have_rcu_kthread_work;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Hello Paul,
> here it helps. Tested on Devkit8000 (omap3, beagleboard clone). Without
> this patch I had permanent crashes. With this patch board is running.
> 
> Tested-by: Thomas Weber <weber@corscience.de>

Thank you, Thomas!!!  I have added your Tested-by.

							Thanx, Paul
