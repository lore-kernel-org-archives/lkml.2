Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab2DZPze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:55:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35966 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab2DZPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:55:20 -0400
Date: Thu, 26 Apr 2012 08:54:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ
 timers expire on correct CPU
Message-ID: <20120426155450.GD2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335445496.13683.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335445496.13683.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042615-3534-0000-0000-000007D46468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 03:04:56PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 09:16 -0700, Paul E. McKenney wrote:
> > -               mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
> > -                         per_cpu(rcu_idle_gp_timer_expires, cpu));
> > +               tp = &per_cpu(rcu_idle_gp_timer, cpu);
> > +               tp->expires = per_cpu(rcu_idle_gp_timer_expires, cpu);
> > +               add_timer_on(tp, cpu); 
> 
> The simpler change looks to use mod_timer_pinned()

Good point!

Except...  Now that you mention it, I don't see how mod_timer_pinned()
actually helps.  It looks to me like a CPU-hotplug operation will
migrate the timers anyway.

This is actually (in theory) harmless in the RCU_FAST_NO_HZ case, because
the CPU_DYING stuff will force a wakeup of the CPU in question, which
will cancel the timer.  But still, mod_timer_pinned() has a rather
misleading name.  ;-)

But a line is a line, so I made this change.

							Thanx, Paul

