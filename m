Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab2DZOuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:50:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54900 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2DZOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:50:12 -0400
Date: Thu, 26 Apr 2012 07:49:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 3/4] rcu: Make RCU_FAST_NO_HZ account
 for pauses out of idle
Message-ID: <20120426144910.GC2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335197761-6577-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335445242.13683.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335445242.13683.19.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042614-5518-0000-0000-000003F05863
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 03:00:42PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 09:16 -0700, Paul E. McKenney wrote:
> >  static DEFINE_PER_CPU(int, rcu_dyntick_drain);
> >  static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
> >  static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
> > +static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
> > +static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
> > +static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
> > +static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
> 
> 
> Wouldn't that all be prettier if it were in a struct of sorts?
> 
> struct rcu_dyntick {
> 	int			drain;
> 	unsigned long		holdoff;
> 	struct timer_list	gp_timer;
> 	unsigned long		gp_timer_expires;
> 	bool			first_pass;
> 	unsigned long		posted;
> 	unsigned long		posted_snap;
> };
> 
> static DEFINE_PER_CPU(struct rcu_dyntick, rcu_dyntick);
> 
> ( fwiw, bool doesn't have a well specified storage type )
> 
> This way you have more control over the placement, variables are forced
> to be together, instead of at the mercy of whatever per_cpu and the
> linker do, and you more clearly see the holes in the structure.
> 
> All the per_cpu() usage should still work like:
> 
>   per_cpu(rcu_dyntick.first_pass, cpu) = 0;

Excellent point -- I have added that transformation to the todo list for 3.6.

I must confess that I had no idea that you could say the above.  I would
have expected to have to say the following:

    per_cpu(rcu_dyntick, cpu).first_pass = 0;

Not much difference either way, though.

							Thanx, Paul

