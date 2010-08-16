Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0HPRzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:55:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36929 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0HPRzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:55:15 -0400
Date: Mon, 16 Aug 2010 10:55:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 09/10] rcu: update obsolete
	rcu_read_lock() comment.
Message-ID: <20100816175507.GG2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100809221447.GA24358@linux.vnet.ibm.com>
 <1281392111-25060-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100816144532.GA8320@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816144532.GA8320@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:45:32AM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > The comment says that blocking is illegal in rcu_read_lock()-style
> > RCU read-side critical sections, which is no longer entirely true
> > given preemptible RCU.  This commit provides a fix.
> > 
> > Suggested-by: David Miller <davem@davemloft.net>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/rcupdate.h |   15 ++++++++++++++-
> >  1 files changed, 14 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 24b8966..d7af96e 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -458,7 +458,20 @@ extern int rcu_my_thread_group_empty(void);
> >   * will be deferred until the outermost RCU read-side critical section
> >   * completes.
> >   *
> > - * It is illegal to block while in an RCU read-side critical section.
> > + * You can avoid reading and understanding the next paragraph by
> > + * following this rule: don't put anything in an rcu_read_lock() RCU
> > + * read-side critical section that would block in a !PREEMPT kernel.
> > + * But if you want the full story, read on!
> > + *
> > + * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
> > + * is illegal to block while in an RCU read-side critical section.  In
> > + * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
> > + * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
> > + * be preempted, but explicit blocking is illegal.  Finally, in preemptible
> > + * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
> > + * RCU read-side critical sections may be preempted and they may also
> > + * block, but only when acquiring spinlocks that are subject to priority
> > + * inheritance.
> 
> It might be good to add a note about locking chain dependency that is
> created in the RT case, e.g., the lock we are sharing with another
> context in preempt RT is subject to the same rules as the RCU C.S.. It
> should never call synchronize_rcu(); this would cause a RCU+lock-induced
> deadlock.
> 
> I must admit, however, that because calling synchronize_rcu() from
> spinlocks is already forbidden, this is already implied.

Thank you for looking this over!

I am updating the srcu_read_lock() docbook comments to call out the
potential for this problem, given that SRCU read-side critical sections
can acquire mutexes, which can be held across both synchronize_srcu()
and synchronize_srcu_expedited().

Seem reasonable?

							Thanx, Paul

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 6f456a7..58971e8 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -139,7 +139,12 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
  * @sp: srcu_struct in which to register the new reader.
  *
  * Enter an SRCU read-side critical section.  Note that SRCU read-side
- * critical sections may be nested.
+ * critical sections may be nested.  However, it is illegal to
+ * call anything that waits on an SRCU grace period for the same
+ * srcu_struct, whether directly or indirectly.  Please note that
+ * one way to indirectly wait on an SRCU grace period is to acquire
+ * a mutex that is held elsewhere while calling synchronize_srcu() or
+ * synchronize_srcu_expedited().
  */
 static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {

> Thanks,
> 
> Mathieu
> 
> >   */
> >  static inline void rcu_read_lock(void)
> >  {
> > -- 
> > 1.7.0.6
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
