Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2IDXO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:14:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38187 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2IDXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:14:26 -0400
Date: Tue, 4 Sep 2012 16:14:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120904231415.GW2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831180052.GB4259@jtriplet-mobl1>
 <20120904223350.GQ2593@linux.vnet.ibm.com>
 <1346799082.27919.31.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346799082.27919.31.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090423-7408-0000-0000-000008307A7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 06:51:22PM -0400, Steven Rostedt wrote:
> On Tue, 2012-09-04 at 15:33 -0700, Paul E. McKenney wrote:
> > On Fri, Aug 31, 2012 at 11:00:52AM -0700, Josh Triplett wrote:
> > > On Thu, Aug 30, 2012 at 11:56:17AM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > > 
> > > > There is a need to use RCU from interrupt context, but either before
> > > > rcu_irq_enter() is called or after rcu_irq_exit() is called.  If the
> > > > interrupt occurs from idle, then lockdep-RCU will complain about such
> > > > uses, as they appear to be illegal uses of RCU from the idle loop.
> > > > In other environments, RCU_NONIDLE() could be used to properly protect
> > > > the use of RCU, but RCU_NONIDLE() currently cannot be invoked except
> > > > from process context.
> > > > 
> > > > This commit therefore modifies RCU_NONIDLE() to permit its use more
> > > > globally.
> > > > 
> > > > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Something seems wrong about this.  The addition of EXPORT_SYMBOL_GPL
> > > suggests that such interrupt handlers might live in modules.  In what
> > > situation might a module interrupt handler get called from the idle
> > > loop, before rcu_irq_enter or after rcu_irq_exit, and need to know that
> > > when using RCU?
> > 
> > Drivers can be in modules, in which case their interrupt handlers will
> > also be in the corresponding module.  I do agree that in most cases,
> > the irq_enter() and irq_exit() hooks would be invoked by non-module code,
> > but I do believe that I had to add those exports due to build failures.
> > 
> > Steven will let me know if I am confused on this point.
> > 
> 
> You're not confused, the situation is confusing :-/
> 
> Because some trace events happen inside the idle loop after rcu has
> "shutdown", we needed to create "trace_foo_rcuidle()" handlers that can
> handle this condition. That is, for every trace_foo() static inline
> (used at the tracepoint location), there exists a static inline
> trace_foo_rcuidle(), that looks something like this:
> 
> static inline void trace_##name##_rcuidle(proto) {
> 	if (static_key_false(&__tracepoint_##name.key)) { 
> 		rcu_idle_exit();
> 		__DO_TRACE();
> 		rcu_idle_enter();
> 	}
> }
> 
> Although these calls are never used by module code, because they are
> static inlines, they are still defined for all tracepoints, kernel
> tracepoints as well as module tracepoints. And thus, need the export :-(

Very good -- I will add this to the commit log, with attribution.

							Thanx, Paul

