Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1EFFrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 01:47:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49859 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab1EFFrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 01:47:03 -0400
Date: Thu, 5 May 2011 22:46:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/86] rcu: move TREE_RCU from softirq to
 kthread
Message-ID: <20110506054657.GC2641@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <BANLkTindSvefZFoM6uPx+UyHOsFSmYnfhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTindSvefZFoM6uPx+UyHOsFSmYnfhQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 05:31:35PM +0800, Yong Zhang wrote:
> On Sun, May 1, 2011 at 9:20 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> >
> > If RCU priority boosting is to be meaningful, callback invocation must
> > be boosted in addition to preempted RCU readers.  Otherwise, in presence
> > of CPU real-time threads, the grace period ends, but the callbacks don't
> > get invoked.  If the callbacks don't get invoked, the associated memory
> > doesn't get freed, so the system is still subject to OOM.
> >
> > But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
> > moves the callback invocations to a kthread, which can be boosted easily.
> >
> > Also add comments and properly synchronized all accesses to
> > rcu_cpu_kthread_task, as suggested by Lai Jiangshan.
> >
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> [snip]
> > + * Drop to non-real-time priority and yield, but only after posting a
> > + * timer that will cause us to regain our real-time priority if we
> > + * remain preempted.  Either way, we restore our real-time priority
> > + * before returning.
> > + */
> > +static void rcu_yield(int cpu)
> > +{
> > +       struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
> > +       struct sched_param sp;
> > +       struct timer_list yield_timer;
> > +
> > +       setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);
> 
> setup_timer_on_stack() should be used here :)

Good eyes!!!  Fixed, will update the -rcu git tree.

							Thanx, Paul
