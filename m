Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2L3D5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 22:57:04 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57478 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab2L3D5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 22:57:02 -0500
Date: Sat, 29 Dec 2012 19:56:38 -0800
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
Message-ID: <20121230035638.GM2542@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
 <1356057332.5896.81.camel@gandalf.local.home>
 <CAFTL4hy_k8rWg5EAFnh-owey7NJCQbK+ULrkNrSjgdynzEseTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy_k8rWg5EAFnh-owey7NJCQbK+ULrkNrSjgdynzEseTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12123003-9360-0000-0000-00000E8BBA37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 12:43:25AM +0100, Frederic Weisbecker wrote:
> 2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
> > On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
> >> Let's imagine you have 4 CPUs. We keep the CPU 0 to offline RCU callbacks there and to
> >> handle the timekeeping. We set the rest as full dynticks. So you need the following kernel
> >> parameters:
> >>
> >>       rcu_nocbs=1-3 full_nohz=1-3
> >>
> >> (Note rcu_nocbs value must always be the same as full_nohz).
> >
> > Why? You can't have: rcu_nocbs=1-4 full_nohz=1-3
> 
> That should be allowed.
> 
> >   or: rcu_nocbs=1-3 full_nohz=1-4 ?
> 
> But that not.
> 
> You need to have: rcu_nocbs & full_nohz == full_nohz. This is because
> the tick is not there to maintain the local RCU callbacks anymore. So
> this must be offloaded to the rcu_nocb threads.
> 
> I just have a doubt with rcu_nocb. Do we still need the tick to
> complete the grace period for local rcu callbacks? I need to discuss
> that with Paul.

The tick is only needed if rcu_needs_cpu() returns false.  Of course,
this means that if you don't invoke rcu_needs_cpu() before returning to
adaptive-idle usermode execution, you are correct that a full_nohz CPU
would also have to be a rcu_nocbs CPU.

That said, I am getting close to having an rcu_needs_cpu() that only
returns false if there are callbacks immediately ready to invoke, at
least if RCU_FAST_NO_HZ=y.

							Thanx, Paul

> > That needs to be fixed. Either with a warning, and/or to force the two
> > to be the same. That is, if they specify:
> >
> >   rcu_nocbs=1-3 full_nohz=1-4
> >
> > Then set rcu_nocbs=1-4 with a warning about it. Or simply set
> >  full_nohz=1-3.
> 
> Yep, will do.
> 
> Thanks!
> 
> >
> > -- Steve
> >
> >>
> >> Now if you want proper isolation you need to:
> >>
> >> * Migrate your processes adequately
> >> * Migrate your irqs to CPU 0
> >> * Migrate the RCU nocb threads to CPU 0. Example with the above configuration:
> >>
> >>       for p in $(ps -o pid= -C rcuo1,rcuo2,rcuo3)
> >>       do
> >>               taskset -cp 0 $p
> >>       done
> >>
> >> Then run what you want on the full dynticks CPUs. For best results, run 1 task
> >> per CPU, mostly in userspace and mostly CPU bound (otherwise more IO = more kernel
> >> mode execution = more chances to get IPIs, tick restarted, workqueues, kthreads, etc...)
> >>
> >> This page contains a good reminder for those interested in CPU isolation: https://github.com/gby/linux/wiki
> >>
> >> But keep in mind that my tree is not yet ready for serious production.
> >>
> >
> >
> 

