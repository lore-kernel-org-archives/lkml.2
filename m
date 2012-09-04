Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2IDWv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:51:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:51:25 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7zoRB9YQJIYA:10 a=imTROTZUkysA:10 a=RAM01ziftVcA:10 a=wFfiXLW5-aMA:10 a=56vLhSP8h14A:10 a=2eRPLDGB9N0A:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=Ol_gRtWE3NOhPqSxtCEA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346799082.27919.31.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Tue, 04 Sep 2012 18:51:22 -0400
In-Reply-To: <20120904223350.GQ2593@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120831180052.GB4259@jtriplet-mobl1>
	 <20120904223350.GQ2593@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 15:33 -0700, Paul E. McKenney wrote:
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
> 
> Steven will let me know if I am confused on this point.
> 

You're not confused, the situation is confusing :-/

Because some trace events happen inside the idle loop after rcu has
"shutdown", we needed to create "trace_foo_rcuidle()" handlers that can
handle this condition. That is, for every trace_foo() static inline
(used at the tracepoint location), there exists a static inline
trace_foo_rcuidle(), that looks something like this:

static inline void trace_##name##_rcuidle(proto) {
	if (static_key_false(&__tracepoint_##name.key)) { 
		rcu_idle_exit();
		__DO_TRACE();
		rcu_idle_enter();
	}
}

Although these calls are never used by module code, because they are
static inlines, they are still defined for all tracepoints, kernel
tracepoints as well as module tracepoints. And thus, need the export :-(

-- Steve



