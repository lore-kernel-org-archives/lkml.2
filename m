Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab2BCGMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:12:45 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52331 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2BCGMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:12:44 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 22:12:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 37/41] lockdep: Add CPU-idle/offline
 warning to lockdep-RCU splat
Message-ID: <20120203061225.GD3008@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-37-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202060752.GT29058@leaf>
 <20120202183007.GB2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202183007.GB2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 10:30:07AM -0800, Paul E. McKenney wrote:
> On Wed, Feb 01, 2012 at 10:07:52PM -0800, Josh Triplett wrote:
> > On Wed, Feb 01, 2012 at 11:41:55AM -0800, Paul E. McKenney wrote:
> > > --- a/kernel/lockdep.c
> > > +++ b/kernel/lockdep.c
> > > @@ -4176,7 +4176,13 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
> > >  	printk("-------------------------------\n");
> > >  	printk("%s:%d %s!\n", file, line, s);
> > >  	printk("\nother info that might help us debug this:\n\n");
> > > -	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
> > > +	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
> > > +	       !rcu_lockdep_current_cpu_online()
> > > +			? "RCU used illegally from offline CPU!\n"
> > > +			: rcu_is_cpu_idle()
> > > +				? "RCU used illegally from idle CPU!\n"
> > > +				: "",
> > 
> > Not the usual way I've seen chained ?: indented in kernel code:
> > 
> >  cond1 ? value1 :
> >  cond2 ? value2 :
> >  value3
> > 
> > That avoids repeated indentation over to the right, much like "else if".
> 
> I tried the following, but didn't like it:
> 
> 	       !rcu_lockdep_current_cpu_online() ? "RCU used illegally from offline CPU!\n" :
> 	       rcu_is_cpu_idle() ? "RCU used illegally from idle CPU!\n" :
> 	       "",

Seems like an improvement to me, but it also doesn't matter enough to
bikeshed further about. :)

- Josh Triplett
