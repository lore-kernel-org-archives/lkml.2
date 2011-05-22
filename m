Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1EVJFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 05:05:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58732 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1EVJE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 05:04:56 -0400
Date: Sun, 22 May 2011 11:04:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/next] fixes and breakup of memory-barrier-decrease
 patch
Message-ID: <20110522090440.GD27167@elte.hu>
References: <20110521140613.GA13062@linux.vnet.ibm.com>
 <20110521142844.GA29813@elte.hu>
 <20110521190830.GH2271@linux.vnet.ibm.com>
 <20110521191418.GA30688@elte.hu>
 <20110521203922.GI2271@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521203922.GI2271@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > I mean, without Frederic's patch we are getting very long hangs due to the 
> > barrier patch, right?
> 
> Yes.  The reason we are seeing these hangs is that HARDIRQ_ENTER() invoked 
> irq_enter(), which calls rcu_irq_enter() but that the matching HARDIRQ_EXIT() 
> invoked __irq_exit(), which does not call rcu_irq_exit(). This resulted in 
> calls to rcu_irq_enter() that were not balanced by matching calls to 
> rcu_irq_exit().  Therefore, after these tests completed, RCU's dyntick-idle 
> nesting count was a large number, which caused RCU to conclude that the 
> affected CPU was not in dyntick-idle mode when in fact it was.
> 
> RCU would therefore incorrectly wait for this dyntick-idle CPU.
> 
> With Frederic's patch, these tests don't ever call either rcu_irq_enter() or 
> rcu_irq_exit(), which works because the CPU running the test is already 
> marked as not being in dyntick-idle mode.
> 
> So, with Frederic's patch, the rcu_irq_enter() and rcu_irq_exit() calls are 
> balanced and things work.
> 
> The reason that the imbalance was not noticed before the barrier patch was 
> applied is that the old implementation of rcu_enter_nohz() ignored the 
> nesting depth.  This could still result in delays, but much shorter ones.  
> Whenever there was a delay, RCU would IPI the CPU with the unbalanced nesting 
> level, which would eventually result in rcu_enter_nohz() being called, which 
> in turn would force RCU to see that the CPU was in dyntick-idle mode.
> 
> Hmmm...  I should add this line of reasoning to one of the commit logs, 
> shouldn't I?  (Added it.  Which of course invalidates my pull request.)

Well, the thing i was missing from the tree was Frederic's fix patch. Or was 
that included in one of the commits?

I mean, if we just revert the revert, we reintroduce the delay, no matter who 
is to blame - not good! :-)

> > Even if the barrier patch is not to blame - somehow it still managed to 
> > produce these hangs - and we do not understand it yet.
> 
> >From Yinghai's message https://lkml.org/lkml/2011/5/12/465, I believe
> that the residual delay he is seeing is not due to the barrier patch,
> but rather due to a26ac2455 (move TREE_RCU from softirq to kthrea).
> 
> More on this below.

Ok - we can treat that regression differently. Also, that seems like a much 
shorter delay, correct? The delays fixed by Frederic's patch were huge (i think 
i saw a 1 hour delay once) - they were essentially not delays but hangs.

Thanks,

	Ingo
