Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3AERyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:54:51 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57377 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab3AERyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:54:50 -0500
Date: Sat, 5 Jan 2013 09:54:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, patches@linaro.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH tip/core/urgent 1/2] rcu: Prevent soft-lockup complaints
 about no-CBs CPUs
Message-ID: <20130105175440.GE19783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105165817.GA13260@linux.vnet.ibm.com>
 <1357405131-13421-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAFTL4hyYh=C6-jPBm0pWjn2xeDRGtYVGYD46hSr=OfPjNtuDGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyYh=C6-jPBm0pWjn2xeDRGtYVGYD46hSr=OfPjNtuDGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726D3B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 06:21:01PM +0100, Frederic Weisbecker wrote:
> Hi Paul,
> 
> 2013/1/5 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > From: Paul Gortmaker <paul.gortmaker@windriver.com>
> >
> > The wait_event() at the head of the rcu_nocb_kthread() can result in
> > soft-lockup complaints if the CPU in question does not register RCU
> > callbacks for an extended period.  This commit therefore changes
> > the wait_event() to a wait_event_interruptible().
> >
> > Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index f6e5ec2..43dba2d 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -2366,10 +2366,11 @@ static int rcu_nocb_kthread(void *arg)
> >         for (;;) {
> >                 /* If not polling, wait for next batch of callbacks. */
> >                 if (!rcu_nocb_poll)
> > -                       wait_event(rdp->nocb_wq, rdp->nocb_head);
> > +                       wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
> >                 list = ACCESS_ONCE(rdp->nocb_head);
> >                 if (!list) {
> >                         schedule_timeout_interruptible(1);
> > +                       flush_signals(current);
> 
> Why is that needed?

To satisfy my paranoia.  ;-)  And in case someone ever figures out some
way to send a signal to a kthread.

							Thanx, Paul

