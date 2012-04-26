Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2DZMrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:47:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:51537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2DZMrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:47:15 -0400
Message-ID: <1335444391.13683.11.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 4/6] rcu: Clarify help text for
 RCU_BOOST_PRIO
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 14:46:31 +0200
In-Reply-To: <1335199347-13926-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-4-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote:
> +         This option specifies the real-time priority to which long-term
> +         preempted RCU readers are to be boosted.  If you are working
> +         with a real-time application that has one or more CPU-bound
> +         threads running at a real-time priority level,

Then your application is broken ;-) the kernel is known to mis-behave
under these circumstances since it doesn't get to run house-keeping
tasks. RCU is just one of these and elevating it doesn't make it work.

>  you should set
> +         RCU_BOOST_PRIO to a priority higher then the highest-priority
> +         real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
> +         of 1 is appropriate in the common case, which is real-time
> +         applications that do not have any CPU-bound threads.

Alternatively, 1 is the worst possible choice forcing people to consider
the issue.

> +         Some real-time applications might not have a single real-time
> +         thread that saturates a given CPU, but instead might have
> +         multiple real-time threads that, taken together, fully utilize
> +         that CPU.  In this case, you should set RCU_BOOST_PRIO to
> +         a priority higher than the lowest-priority thread that is
> +         conspiring to prevent the CPU from running any non-real-time
> +         tasks.  For example, if one thread at priority 10 and another
> +         thread at priority 5 are between themselves fully consuming
> +         the CPU time on a given CPU, then RCU_BOOST_PRIO should be
> +         set to priority 6 or higher. 

I'd call this misleading, who's to say that preempting the 5 would yield
enough time to complete the RCU work?

This all gets us back to the fun question of RCU delayed bandwidth
budgeting.. ideally every 'task' that does call_rcu() should donate some
of its budget towards the thread running the callback.

Anyway, I'd argue both the old and new description are bonkers.
