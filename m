Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180Ab2IFQ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:59:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab2IFQ7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:59:41 -0400
Message-ID: <1346950736.18408.43.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 18:58:56 +0200
In-Reply-To: <20120906164745.GF2448@linux.vnet.ibm.com>
References: <20120905213945.GA15216@linux.vnet.ibm.com>
	 <1346881720.2600.48.camel@twins> <20120905234443.GY3308@linux.vnet.ibm.com>
	 <1346926417.2600.73.camel@twins> <20120906164745.GF2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 09:47 -0700, Paul E. McKenney wrote:
> The key point is "would simple put RCU into extended quiescent state".
> This can only happen if the CPU has no callbacks.  If the CPU does have
> callbacks, then RCU will need to do some work to advance the callbacks.
> Advancing the callbacks requires that RCU periodically do work on that
> CPU, resulting in OS jitter.

But since its then not actually in adaptive-tick mode (the tick is still
running) who cares? It will only disable the tick once all preconditions
are met, this includes RCU being in extended qs, so until that time...

> > That way you could run the entire state thing from a kthread with random
> > affinity, all 'per-cpu' data would still be fine since only the one
> > kthread will access it, even though locality might suffer somewhat.
> 
> Well, the current patch set does move much of the grace-period machinery
> to a kthread.  Much of the remaining work needs to remain on the CPUs
> (at least those not in an extended quiescent state) in order to keep
> the overhead of the read-side primitives and scheduler hooks inexpensive. 

Ah indeed, what you're saying is that the data required by those hooks
needs to be accessed locally in order to avoid proper atomic ops.

So then you do indeed need to break the state machine into two parts,
and I guess that's the bit you're struggling with.

Still I would not make this more complex than it needs to be, if the
tick is running we can use this to drive the state machine, if its not,
we are in extended qs and we don't need to drive the tick.


