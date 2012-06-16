Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2FPGmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:42:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36989 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2FPGmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:42:52 -0400
Date: Fri, 15 Jun 2012 23:42:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/15] rcu: Use for_each_rcu_flavor() in
 TREE_RCU tracing
Message-ID: <20120616064242.GC2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615235957.GF7613@leaf>
 <20120616005605.GV2389@linux.vnet.ibm.com>
 <20120616052214.GB8252@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616052214.GB8252@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061606-3270-0000-0000-000007395EB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:22:14PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 05:56:05PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 15, 2012 at 04:59:57PM -0700, Josh Triplett wrote:
> > > On Fri, Jun 15, 2012 at 02:06:09PM -0700, Paul E. McKenney wrote:
> > > > @@ -129,24 +125,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
> > > >  		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
> > > >  }
> > > >  
> > > > -#define PRINT_RCU_DATA(name, func, m) \
> > > > -	do { \
> > > > -		int _p_r_d_i; \
> > > > -		\
> > > > -		for_each_possible_cpu(_p_r_d_i) \
> > > > -			func(m, &per_cpu(name, _p_r_d_i)); \
> > > > -	} while (0)
> > > > -
> > > >  static int show_rcudata(struct seq_file *m, void *unused)
> > > >  {
> > > > -#ifdef CONFIG_TREE_PREEMPT_RCU
> > > > -	seq_puts(m, "rcu_preempt:\n");
> > > > -	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
> > > > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > > > -	seq_puts(m, "rcu_sched:\n");
> > > > -	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
> > > > -	seq_puts(m, "rcu_bh:\n");
> > > > -	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
> > > > +	int cpu;
> > > > +	struct rcu_state *rsp;
> > > > +
> > > > +	for_each_rcu_flavor(rsp) {
> > > > +		seq_printf(m, "%s:\n", rsp->name);
> > > > +		for_each_possible_cpu(cpu)
> > > > +		print_one_rcu_data(m, per_cpu_ptr(rsp->rda, cpu));
> > > > +	}
> > > 
> > > As above, I'd suggest inlining print_one_rcu_data.
> > 
> > Not this one, too bulky.
> 
> I looked at the implementation; it just consists of a pile of calls to
> seq_printf.  What about that makes it too bulky to include in the body
> of the loop?

Your referring to it as "a pile of calls" is strong evidence.  ;-)

> > > > @@ -200,6 +188,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
> > > >  
> > > >  static int show_rcudata_csv(struct seq_file *m, void *unused)
> > > >  {
> > > > +	int cpu;
> > > > +	struct rcu_state *rsp;
> > > > +
> > > >  	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
> > > >  	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
> > > >  	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
> > > > @@ -207,14 +198,11 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
> > > >  	seq_puts(m, "\"kt\",\"ktl\"");
> > > >  #endif /* #ifdef CONFIG_RCU_BOOST */
> > > >  	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
> > > > -#ifdef CONFIG_TREE_PREEMPT_RCU
> > > > -	seq_puts(m, "\"rcu_preempt:\"\n");
> > > > -	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
> > > > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > > > -	seq_puts(m, "\"rcu_sched:\"\n");
> > > > -	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
> > > > -	seq_puts(m, "\"rcu_bh:\"\n");
> > > > -	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
> > > > +	for_each_rcu_flavor(rsp) {
> > > > +		seq_printf(m, "\"%s:\"\n", rsp->name);
> > > > +		for_each_possible_cpu(cpu)
> > > > +			print_one_rcu_data_csv(m, per_cpu_ptr(rsp->rda, cpu));
> > > > +	}
> > > 
> > > As above, I'd suggest inlining print_one_rcu_data_csv.
> > 
> > Also too bulky.
> 
> Also just a few calls to seq_printf. :)

For some definition or another of a few lines of code.  ;-)

> > > > @@ -304,9 +292,9 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
> > > >  	struct rcu_node *rnp;
> > > >  
> > > >  	gpnum = rsp->gpnum;
> > > > -	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
> > > > +	seq_printf(m, "%s: c=%lu g=%lu s=%d jfq=%ld j=%x "
> > > >  		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
> > > > -		   rsp->completed, gpnum, rsp->fqs_state,
> > > > +		   rsp->name, rsp->completed, gpnum, rsp->fqs_state,
> > > >  		   (long)(rsp->jiffies_force_qs - jiffies),
> > > >  		   (int)(jiffies & 0xffff),
> > > >  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
> > > > @@ -329,14 +317,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
> > > >  
> > > >  static int show_rcuhier(struct seq_file *m, void *unused)
> > > >  {
> > > > -#ifdef CONFIG_TREE_PREEMPT_RCU
> > > > -	seq_puts(m, "rcu_preempt:\n");
> > > > -	print_one_rcu_state(m, &rcu_preempt_state);
> > > > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > > > -	seq_puts(m, "rcu_sched:\n");
> > > > -	print_one_rcu_state(m, &rcu_sched_state);
> > > > -	seq_puts(m, "rcu_bh:\n");
> > > > -	print_one_rcu_state(m, &rcu_bh_state);
> > > > +	struct rcu_state *rsp;
> > > > +
> > > > +	for_each_rcu_flavor(rsp)
> > > > +		print_one_rcu_state(m, rsp);
> > > 
> > > As above, I'd suggest inlining print_one_rcu_state.
> > 
> > Also too bulky.
> 
> This one I'll grant, since it would introduce an additional level of
> nested loop.
> 
> > > > @@ -377,11 +361,10 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
> > > >  
> > > >  static int show_rcugp(struct seq_file *m, void *unused)
> > > >  {
> > > > -#ifdef CONFIG_TREE_PREEMPT_RCU
> > > > -	show_one_rcugp(m, &rcu_preempt_state);
> > > > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > > > -	show_one_rcugp(m, &rcu_sched_state);
> > > > -	show_one_rcugp(m, &rcu_bh_state);
> > > > +	struct rcu_state *rsp;
> > > > +
> > > > +	for_each_rcu_flavor(rsp)
> > > > +		show_one_rcugp(m, rsp);
> > > 
> > > As above, I'd suggest inlining show_one_rcugp.
> > 
> > Also too bulky.
> 
> show_one_rcugp seems like an extremely simple function; what makes it
> unsuitable for the body of this loop?

Ummm...  Nothing.  I actually did inline this one.  I was clearly
confused when documenting my actions!

							Thanx, Paul

