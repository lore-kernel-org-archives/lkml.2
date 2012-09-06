Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2IFO31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:29:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:45358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2IFO3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:29:25 -0400
Message-ID: <1346941673.18408.21.camel@twins>
Subject: Re: [PATCH tip/core/rcu 18/23] rcu: Add random PROVE_RCU_DELAY to
 grace-period initialization
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 16:27:53 +0200
In-Reply-To: <1346350718-30937-18-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-18-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> 
> 1.      CPU 0 completes a grace period, but needs an additional
>         grace period, so starts initializing one, initializing all
>         the non-leaf rcu_node strcutures and the first leaf rcu_node
>         structure.  Because CPU 0 is both completing the old grace
>         period and starting a new one, it marks the completion of
>         the old grace period and the start of the new grace period
>         in a single traversal of the rcu_node structures.
> 
>         Therefore, CPUs corresponding to the first rcu_node structure
>         can become aware that the prior grace period has ended, but
>         CPUs corresponding to the other rcu_node structures cannot
>         yet become aware of this.
> 
> 2.      CPU 1 passes through a quiescent state, and therefore informs
>         the RCU core.  Because its leaf rcu_node structure has already
>         been initialized, so this CPU's quiescent state is applied to
>         the new (and only partially initialized) grace period.
> 
> 3.      CPU 1 enters an RCU read-side critical section and acquires
>         a reference to data item A.  Note that this critical section
>         will not block the new grace period.
> 
> 4.      CPU 16 exits dyntick-idle mode.  Because it was in dyntick-idle
>         mode, some other CPU informed the RCU core of its extended
>         quiescent state for the past several grace periods.  This means
>         that CPU 16 is not yet aware that these grace periods have ended.
> 
> 5.      CPU 16 on the second leaf rcu_node structure removes data item A
>         from its enclosing data structure and passes it to call_rcu(),
>         which queues a callback in the RCU_NEXT_TAIL segment of the
>         callback queue.
> 
> 6.      CPU 16 enters the RCU core, possibly because it has taken a
>         scheduling-clock interrupt, or alternatively because it has
>         more than 10,000 callbacks queued.  It notes that the second
>         most recent grace period has ended (recall that it cannot yet
>         become aware that the most recent grace period has completed),
>         and therefore advances its callbacks.  The callback for data
>         item A is therefore in the RCU_NEXT_READY_TAIL segment of the
>         callback queue.
> 
> 7.      CPU 0 completes initialization of the remaining leaf rcu_node
>         structures for the new grace period, including the structure
>         corresponding to CPU 16.
> 
> 8.      CPU 16 again enters the RCU core, again, possibly because it has
>         taken a scheduling-clock interrupt, or alternatively because
>         it now has more than 10,000 callbacks queued.   It notes that
>         the most recent grace period has ended, and therefore advances
>         its callbacks.  The callback for data item A is therefore in
>         the RCU_NEXT_TAIL segment of the callback queue.
> 
> 9.      All CPUs other than CPU 1 pass through quiescent states, so that
>         the new grace period completes.  Note that CPU 1 is still in
>         its RCU read-side critical section, still referencing data item A.
> 
> 10.     Suppose that CPU 2 is the last CPU to pass through a quiescent
>         state for the new grace period, and suppose further that CPU 2
>         does not have any callbacks queued.  It therefore traverses
>         all of the rcu_node structures, marking the new grace period
>         as completed, but does not initialize a new grace period.
> 
> 11.     CPU 16 yet again enters the RCU core, yet again possibly because
>         it has taken a scheduling-clock interrupt, or alternatively
>         because it now has more than 10,000 callbacks queued.   It notes
>         that the new grace period has ended, and therefore advances
>         its callbacks.  The callback for data item A is therefore in
>         the RCU_DONE_TAIL segment of the callback queue.  This means
>         that this callback is now considered ready to be invoked.
> 
> 12.     CPU 16 invokes the callback, freeing data item A while CPU 1
>         is still referencing it. 

This is the same scenario as the previous patch (17), right?

However did you find a 12-stage race like that, is that PROMELA goodness
or are you training to beat some chess champion?
