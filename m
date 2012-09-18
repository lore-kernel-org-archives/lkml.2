Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2IRXdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:33:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49726 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2IRXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:33:10 -0400
Date: Tue, 18 Sep 2012 16:32:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 3/5] rcu: Document SRCU dead-CPU
 capabilities, emphasize read-side limits
Message-ID: <20120918233257.GO2487@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352312-31987-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <50583AF0.9050403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50583AF0.9050403@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12091823-5112-0000-0000-00000C87B0CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 05:12:16PM +0800, Lai Jiangshan wrote:
> On 08/31/2012 02:45 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The current documentation did not help someone grepping for SRCU to
> > learn that disabling preemption is not a replacement for srcu_read_lock(),
> > so upgrade the documentation to bring this out, not just for SRCU,
> > but also for RCU-bh.  Also document the fact that SRCU readers are
> > respected on CPUs executing in user mode, idle CPUs, and even on
> > offline CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Good.  (Sorry, I'm late.)

But, as it turns out, not too late.  ;-)

Thank you for the review!

							Thanx, Paul

> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> > ---
> >  Documentation/RCU/checklist.txt |    6 ++++++
> >  Documentation/RCU/whatisRCU.txt |    9 +++++++--
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
> > index fc103d7..cdb20d4 100644
> > --- a/Documentation/RCU/checklist.txt
> > +++ b/Documentation/RCU/checklist.txt
> > @@ -310,6 +310,12 @@ over a rather long period of time, but improvements are always welcome!
> >  	code under the influence of preempt_disable(), you instead
> >  	need to use synchronize_irq() or synchronize_sched().
> >  
> > +	This same limitation also applies to synchronize_rcu_bh()
> > +	and synchronize_srcu(), as well as to the asynchronous and
> > +	expedited forms of the three primitives, namely call_rcu(),
> > +	call_rcu_bh(), call_srcu(), synchronize_rcu_expedited(),
> > +	synchronize_rcu_bh_expedited(), and synchronize_srcu_expedited().
> > +
> >  12.	Any lock acquired by an RCU callback must be acquired elsewhere
> >  	with softirq disabled, e.g., via spin_lock_irqsave(),
> >  	spin_lock_bh(), etc.  Failing to disable irq on a given
> > diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
> > index 69ee188..bf0f6de 100644
> > --- a/Documentation/RCU/whatisRCU.txt
> > +++ b/Documentation/RCU/whatisRCU.txt
> > @@ -873,7 +873,7 @@ d.	Do you need to treat NMI handlers, hardirq handlers,
> >  	and code segments with preemption disabled (whether
> >  	via preempt_disable(), local_irq_save(), local_bh_disable(),
> >  	or some other mechanism) as if they were explicit RCU readers?
> > -	If so, you need RCU-sched.
> > +	If so, RCU-sched is the only choice that will work for you.
> >  
> >  e.	Do you need RCU grace periods to complete even in the face
> >  	of softirq monopolization of one or more of the CPUs?  For
> > @@ -884,7 +884,12 @@ f.	Is your workload too update-intensive for normal use of
> >  	RCU, but inappropriate for other synchronization mechanisms?
> >  	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
> >  
> > -g.	Otherwise, use RCU.
> > +g.	Do you need read-side critical sections that are respected
> > +	even though they are in the middle of the idle loop, during
> > +	user-mode execution, or on an offlined CPU?  If so, SRCU is the
> > +	only choice that will work for you.
> > +
> > +h.	Otherwise, use RCU.
> >  
> >  Of course, this all assumes that you have determined that RCU is in fact
> >  the right tool for your job.
> 

