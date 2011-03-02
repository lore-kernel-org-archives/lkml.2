Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1CBAHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:07:19 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52082 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab1CBAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:07:17 -0500
Date: Tue, 1 Mar 2011 16:07:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110302000703.GK2218@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D6765B6.1030401@cn.fujitsu.com>
 <20110225203219.GD2269@linux.vnet.ibm.com>
 <4D6B16A8.4050405@cn.fujitsu.com>
 <1298886437.2428.10174.camel@twins>
 <20110301001300.GD2331@linux.vnet.ibm.com>
 <1298990291.5226.870.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298990291.5226.870.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 03:38:11PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-02-28 at 16:13 -0800, Paul E. McKenney wrote:
> 
> > I am OK doing the sched_setscheduler_nocheck() in UP_PREPARE, correct?
> 
> Yeah, it should be perfectly fine to call that.

Cool!

> > Ah, there is the rub -- I am using wait_event(), so I need to wake up the
> > kthread once before anyone uses it (or at least concurrently with anyone
> > using it).  Which I can presumably do from the CPU_STARTING notifier.
> 
> Right, so your kthread is doing:
> 
> static int rcu_cpu_kthread()
> {
>   for (;;) {
>     wait_event_interruptible();
> 
>     /* do stuff */
> 
>   }
>   return 0;
> }
> 
> Which means that all folks wanting to make use of this already need to
> do a wakeup. So I don't see any reason to do that first wakeup from
> CPU_STARTING.

That is good to hear, because doing so seems to result in abject failure.

> wait_event() will only actually wait if the condition is false, in the
> start-up case above it will find the condition true and fall right
> through to do stuff.

So as long as it is OK to call sched_setscheduler_nocheck() before
the kthread is first awakened, we should be OK.

							Thanx, Paul
