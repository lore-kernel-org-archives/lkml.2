Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab2IEXox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:44:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52320 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab2IEXow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:44:52 -0400
Date: Wed, 5 Sep 2012 16:44:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
Message-ID: <20120905234443.GY3308@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120905213945.GA15216@linux.vnet.ibm.com>
 <1346881720.2600.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346881720.2600.48.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090523-8974-0000-0000-00000D27DFD9
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171632; UDB=6.00038928; UTC=2012-09-05
 23:44:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:48:40PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 14:39 -0700, Paul E. McKenney wrote:
> > RCU callback execution can add significant OS jitter and also can degrade
> > scheduling latency.  This commit therefore adds the ability for selected
> > CPUs ("rcu_nocbs=" boot parameter) to have their callbacks offloaded to
> > kthreads.  If the "rcu_nocb_poll" boot parameter is also specified, these
> > kthreads will do polling, removing the need for the offloaded CPUs to do
> > wakeups.  At least one CPU must be doing normal callback processing:
> > currently CPU 0 cannot be selected as a no-CBs CPU.  In addition, attempts
> > to offline the last normal-CBs CPU will fail.
> > 
> > This is an experimental patch, so just FYI for the moment.  Known
> > shortcomings include:
> > 
> > o       The counters should be atomic_long_t rather than atomic_t.
> > 
> > o       No-CBs CPUs can be configured only at boot time.
> > 
> > o       Only a modest number of CPUs can be configured as no-CBs CPUs.
> >         Definitely a few tens, perhaps a few hundred, but no way thousands.
> > 
> > o       At least one CPU must remain a normal-CBs CPU.
> > 
> > o       Not much in the way of energy-efficiency features, though there
> >         are some natural energy savings inherent in the implementation
> >         
> > o       The per-no-CBs-CPU kthreads are not subject to RCU priority boosting.
> > 
> > o       Care is required when setting the kthreads to RT priority.
> > 
> > Later versions will address some of them, but others are likely to remain. 
> 
> My LPC feedback in writing...
> 
> So I see RCU as consisting of two parts:
>   A) Grace period tracking,
>   2) Running the callbacks.
> 
> This series seems to conflate the two, it talks of doing the callbacks
> elsewhere (kthread), but it also moves the grace period detectoring into
> the same kthread.
> 
> The latter part is what complicates the thing. I'd suggest doing the
> very simple callbacks only implementation first and leaving the grace
> period machinery in the tick.
> 
> Its typically the callbacks that consume most CPU time, whereas the
> grace period computations, while tricky and subtle, are relatively
> cheap.
> 
> In particular, it solves the need to wait for grace periods from the
> kthread (and bounce that no-nocb cpu to make progress), and it makes the
> atomic list operations stuff a lot easier.

I was excited by this possibility when you first mentioned it, but
the low-OS-jitter fans are going to need the grace-period computation
to be offloaded as well.  So if I use your (admittedly much simpler)
approach, I get to rewrite it when Frederic's adaptive-ticks work goes
in.  Given that this is probably happening relatively soon, it would be
better if I just did the implementation that will be needed long-term,
rather than rewriting.

Though I am sure that people will be sad about fewer RCU patches.  ;-)

							Thanx, Paul

