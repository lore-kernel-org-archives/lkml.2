Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2IDWst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:48:49 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52691 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:48:48 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 173.246.103.110
Date: Tue, 4 Sep 2012 15:48:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120904224839.GA11413@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831180052.GB4259@jtriplet-mobl1>
 <20120904223350.GQ2593@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904223350.GQ2593@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:33:50PM -0700, Paul E. McKenney wrote:
> On Fri, Aug 31, 2012 at 11:00:52AM -0700, Josh Triplett wrote:
> > On Thu, Aug 30, 2012 at 11:56:17AM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > 
> > > There is a need to use RCU from interrupt context, but either before
> > > rcu_irq_enter() is called or after rcu_irq_exit() is called.  If the
> > > interrupt occurs from idle, then lockdep-RCU will complain about such
> > > uses, as they appear to be illegal uses of RCU from the idle loop.
> > > In other environments, RCU_NONIDLE() could be used to properly protect
> > > the use of RCU, but RCU_NONIDLE() currently cannot be invoked except
> > > from process context.
> > > 
> > > This commit therefore modifies RCU_NONIDLE() to permit its use more
> > > globally.
> > > 
> > > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Something seems wrong about this.  The addition of EXPORT_SYMBOL_GPL
> > suggests that such interrupt handlers might live in modules.  In what
> > situation might a module interrupt handler get called from the idle
> > loop, before rcu_irq_enter or after rcu_irq_exit, and need to know that
> > when using RCU?
> 
> Drivers can be in modules, in which case their interrupt handlers will
> also be in the corresponding module.  I do agree that in most cases,
> the irq_enter() and irq_exit() hooks would be invoked by non-module code,
> but I do believe that I had to add those exports due to build failures.

I definitely understand that drivers can have interrupt handlers in
modules; however, I have a hard time seeing a case where a module has a
legitimate reason to invoke rcu_irq_enter or rcu_irq_exit, or to run
before the former or after the latter.

- Josh Triplett
