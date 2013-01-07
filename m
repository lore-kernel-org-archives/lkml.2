Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3AGNHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:07:01 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58047 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3AGNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:07:00 -0500
Date: Mon, 7 Jan 2013 05:06:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [ANNOUNCE] 3.7-nohz1
Message-ID: <20130107130632.GI19783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
 <1356057332.5896.81.camel@gandalf.local.home>
 <CAFTL4hy_k8rWg5EAFnh-owey7NJCQbK+ULrkNrSjgdynzEseTw@mail.gmail.com>
 <20121230035638.GM2542@linux.vnet.ibm.com>
 <CAFTL4hyhP0n89NqZe5vNb19E8HJsa779yQG7FGdddfq_eVrpMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyhP0n89NqZe5vNb19E8HJsa779yQG7FGdddfq_eVrpMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010713-7606-0000-0000-00000735D380
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 12:42:53AM +0100, Frederic Weisbecker wrote:
> 2012/12/30 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Mon, Dec 24, 2012 at 12:43:25AM +0100, Frederic Weisbecker wrote:
> >> 2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
> >> > On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
> >> >> Let's imagine you have 4 CPUs. We keep the CPU 0 to offline RCU callbacks there and to
> >> >> handle the timekeeping. We set the rest as full dynticks. So you need the following kernel
> >> >> parameters:
> >> >>
> >> >>       rcu_nocbs=1-3 full_nohz=1-3
> >> >>
> >> >> (Note rcu_nocbs value must always be the same as full_nohz).
> >> >
> >> > Why? You can't have: rcu_nocbs=1-4 full_nohz=1-3
> >>
> >> That should be allowed.
> >>
> >> >   or: rcu_nocbs=1-3 full_nohz=1-4 ?
> >>
> >> But that not.
> >>
> >> You need to have: rcu_nocbs & full_nohz == full_nohz. This is because
> >> the tick is not there to maintain the local RCU callbacks anymore. So
> >> this must be offloaded to the rcu_nocb threads.
> >>
> >> I just have a doubt with rcu_nocb. Do we still need the tick to
> >> complete the grace period for local rcu callbacks? I need to discuss
> >> that with Paul.
> >
> > The tick is only needed if rcu_needs_cpu() returns false.  Of course,
> > this means that if you don't invoke rcu_needs_cpu() before returning to
> > adaptive-idle usermode execution, you are correct that a full_nohz CPU
> > would also have to be a rcu_nocbs CPU.
> >
> > That said, I am getting close to having an rcu_needs_cpu() that only
> > returns false if there are callbacks immediately ready to invoke, at
> > least if RCU_FAST_NO_HZ=y.
> 
> Ok. Also when a CPU enqueues a callback and starts a grace period, the
> tick polls on the grace period completion.

If RCU_FAST_NO_HZ=n, then yes, this is the case, but only for !rcu_nocbs
CPUs.

>                                            How is it handled with
> rcu_nocbs CPUs? Does rcu_needs_cpu() return false until the grace
> period is completed? If so I still need to restart the local tick
> whenever a new callback is enqueued.

Each rcu_nocbs CPU has a kthread, and that kthread is responsible for
making sure that any needed grace periods move forward.  In mainline, this
is done via CPU 0, which is required to be a !rcu_nocbs CPU.  In -rcu,
the no-CBs kthreads communicate with the grace-period kthread via the
rcu_node tree, so that if all CPUs are rcu_nocbs CPUs, rcu_needs_cpu()
will always return false, even if RCU_FAST_NO_HZ=n.

							Thanx, Paul

