Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2IFRG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:06:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48246 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135Ab2IFRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:06:27 -0400
Date: Thu, 6 Sep 2012 10:00:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 01/23] rcu: Move RCU grace-period
 initialization into a kthread
Message-ID: <20120906170047.GI2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346938342.18408.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346938342.18408.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-6148-0000-0000-0000095A1045
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:32:22PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > +static int rcu_gp_kthread(void *arg)
> > +{
> > +       unsigned long flags;
> > +       struct rcu_data *rdp;
> > +       struct rcu_node *rnp;
> > +       struct rcu_state *rsp = arg;
> > +
> > +       for (;;) {
> > +
> > +               /* Handle grace-period start. */
> > +               rnp = rcu_get_root(rsp);
> > +               for (;;) {
> > +                       wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> > +                       if (rsp->gp_flags)
> > +                               break;
> > +                       flush_signals(current);
> > +               }
> > +               raw_spin_lock_irqsave(&rnp->lock, flags); 
> 
> You're in a kthread, it should be impossible for IRQs to be disabled
> here, no? Similar for most (all) other sites in this function.
> 
> Using the unconditional IRQ disable/enable is generally faster.

I suppose I could see my way to using raw_spin_lock_irq() here.  ;-)

							Thanx, Paul

