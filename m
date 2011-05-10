Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1EJQWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:22:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58011 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab1EJQWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:22:04 -0400
Date: Tue, 10 May 2011 09:21:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
Message-ID: <20110510162158.GK2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <6921.1304989476@localhost>
 <20110510082029.GF2258@linux.vnet.ibm.com>
 <20110510085746.GG27426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510085746.GG27426@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:57:46AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > -	raw_spin_lock_irqsave(&rnp->lock, flags);
> > -	rnp->wakemask |= rdp->grpmask;
> > -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +	do {
> > +		old = rnp->wakemask;
> > +		new = old | rdp->grpmask;
> > +	} while (cmpxchg(&rnp->wakemask, old, new) != old);
> 
> Hm, isnt this an inferior version of atomic_or_long() in essence?
> 
> Note that atomic_or_long() is x86 only, so a generic one would have to be 
> offered too i suspect, atomic_cmpxchg() driven or so - which would look like 
> the above loop.
> 
> Most architectures could offer atomic_or_long() i suspect.

Is the following what you had in mind?  This (untested) patch provides
only the generic function: if this is what you had in mind, I can put
together optimized versions for a couple of the architectures.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..e7c2e69 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -171,6 +171,9 @@ config ARCH_HAS_DEFAULT_IDLE
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
+config ARCH_HAS_ATOMIC_OR_LONG
+	def_bool X86_64
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 96c038e..2fc3222 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -34,4 +34,17 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_ATOMIC_OR_LONG
+static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
+{
+	unsigned long old;
+	unsigned long new;
+
+	do {
+		old = ACCESS_ONCE(*v1);
+		new = old | v2;
+	} while (cmpxchg(v1, old, new) != old);
+}
+#endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR_LONG */
+
 #endif /* _LINUX_ATOMIC_H */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 20c22c5..86f44a3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -36,7 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/nmi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/completion.h>
@@ -1525,15 +1525,10 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
  */
 static void rcu_cpu_kthread_timer(unsigned long arg)
 {
-	unsigned long old;
-	unsigned long new;
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
 	struct rcu_node *rnp = rdp->mynode;
 
-	do {
-		old = rnp->wakemask;
-		new = old | rdp->grpmask;
-	} while (cmpxchg(&rnp->wakemask, old, new) != old);
+	atomic_or_long(&rnp->wakemask, rdp->grpmask);
 	invoke_rcu_node_kthread(rnp);
 }
 
