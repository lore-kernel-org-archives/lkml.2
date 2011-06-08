Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1FHXtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:49:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1FHXtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K19d3Y/Y25UyS1olImS8vkZUUkD7IJwMLHza1rAvFHxUUbTLLTtAssEoOVJ7m3miIb
         RxbNqdCh/udh0Y77hp/Gr7WrM7BPrCHXg9dEAa4R1lEYQgCfrnoNx9kt7Qs7TSupVdKq
         bQmvC/tYEe4m/YprOf5duPnteuhQJSwZYYtG8=
Date: Thu, 9 Jun 2011 01:48:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 04/28] rcu: Restore checks for blocking in
 RCU read-side critical sections
Message-ID: <20110608234855.GE25771@somewhere.redhat.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110608232833.GD25771@somewhere.redhat.com>
 <20110608234622.GM2324@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608234622.GM2324@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 04:46:22PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 09, 2011 at 01:28:35AM +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 08, 2011 at 12:29:43PM -0700, Paul E. McKenney wrote:
> > > Long ago, using TREE_RCU with PREEMPT would result in "scheduling
> > > while atomic" diagnostics if you blocked in an RCU read-side critical
> > > section.  However, PREEMPT now implies TREE_PREEMPT_RCU, which defeats
> > > this diagnostic.  This commit therefore adds a replacement diagnostic
> > > based on PROVE_RCU.
> > > 
> > > Because rcu_lockdep_assert() and lockdep_rcu_dereference() are now being
> > > used for things that have nothing to do with rcu_dereference(), rename
> > > lockdep_rcu_dereference() to lockdep_rcu_suspicious() and add a third
> > > argument that is a string indicating what is suspicious.  This third
> > > argument is passed in from a new third argument to rcu_lockdep_assert().
> > > Update all calls to rcu_lockdep_assert() to add an informative third
> > > argument.
> > > 
> > > Finally, add a pair of rcu_lockdep_assert() calls from within
> > > rcu_note_context_switch(), one complaining if a context switch occurs
> > > in an RCU-bh read-side critical section and another complaining if a
> > > context switch occurs in an RCU-sched read-side critical section.
> > > These are present only if the PROVE_RCU kernel parameter is enabled.
> > > 
> > > Again, you must enable PROVE_RCU to see these new diagnostics.  But you
> > > are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > So, do you think we can get rid of this patch now that we are going to have CONFIG_ATOMIC_SLEEP
> > working everywhere?
> > 
> > The last remaining piece we need is to check rcu_preempt_depth() from schedule_debug(),
> > which does a kind of lightweight might_sleep() check alike.
> 
> I believe that we need them both.  Your patch provides a lightweight
> check.  Mine is way heavier weight (CONFIG_PROVE_RCU is required), but
> tells you in what function the offending RCU read-side critical section
> was entered.

Well, that can be found easily in the stacktrace. But ok.
