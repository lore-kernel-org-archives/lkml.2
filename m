Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0GIAlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:41:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45431 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab0GIAlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:41:15 -0400
Date: Thu, 8 Jul 2010 17:41:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100709004107.GQ2426@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
 <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621174455.GA14886@redhat.com>
 <20100621190212.C8630400C5@magilla.sf.frob.com>
 <20100621200633.GA21099@redhat.com>
 <20100708235925.A71DA4A967@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708235925.A71DA4A967@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 04:59:25PM -0700, Roland McGrath wrote:
> > We can't do call_rcu(release_task),
> > we can't take tasklist for writing in the softirq context. But even
> > if we could, this can't help in fact or I missed something.
> 
> Ah, I had missed that constraint of call_rcu.  (It's not mentioned in the
> kerneldoc comment directly, and is only buried in a couple of brief
> mentions in Documentation/RCU/.)  I was thinking that would suffice because
> it does it between rcu_read_lock critical sections, but I guess it actually
> only does it after the last one and doesn't prevent a new one from having
> started on another CPU.  (And we can't use it anyway.)

Hmmm...  The kerneldoc for rcu_read_lock() looks like it says this
pretty unambiguously.  Then again, that is easy for me to say, given
that I was the one who made most of this stuff up.   ;-)

But it has been awhile since I looked after the kerneldoc.  Please see
below for the changes I would make if left to myself.

Any other suggestions for improvement to the kerneldoc?

							Thanx, Paul

------------------------------------------------------------------------

commit b12483332f1a7ee2db11f4bdc3c4e61edb608b01
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Thu Jul 8 17:38:59 2010 -0700

    rcu: improve kerneldoc for rcu_read_lock(), call_rcu(), and synchronize_rcu()
    
    Make it explicit that new RCU read-side critical sections that start
    after call_rcu() and synchronize_rcu() start might still be running
    after the end of the relevant grace period.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 508ebba..27b44b3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -444,7 +444,7 @@ extern int rcu_my_thread_group_empty(void);
  * until after the all the other CPUs exit their critical sections.
  *
  * Note, however, that RCU callbacks are permitted to run concurrently
- * with RCU read-side critical sections.  One way that this can happen
+ * with new RCU read-side critical sections.  One way that this can happen
  * is via the following sequence of events: (1) CPU 0 enters an RCU
  * read-side critical section, (2) CPU 1 invokes call_rcu() to register
  * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
@@ -602,11 +602,13 @@ extern void wakeme_after_rcu(struct rcu_head  *head);
 /**
  * call_rcu() - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all pre-existing RCU read-side
+ * critical sections have completed.  However, the callback function
+ * might well execute concurrently with RCU read-side critical sections
+ * that started after call_rcu() was invoked.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
@@ -616,9 +618,9 @@ extern void call_rcu(struct rcu_head *head,
 /**
  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
+ * The callback function will be invoked some time after a full grace
  * period elapses, in other words after all currently executing RCU
  * read-side critical sections have completed. call_rcu_bh() assumes
  * that the read-side critical sections end on completion of a softirq
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9906f85..63bb771 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -546,9 +546,11 @@ EXPORT_SYMBOL_GPL(call_rcu);
  *
  * Control will return to the caller some time after a full grace
  * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
+ * read-side critical sections have completed.  Note, however, that
+ * upon return from synchronize_rcu(), the caller might well be executing
+ * concurrently with new RCU read-side critical sections that began while
+ * synchronize_rcu() was waiting.  RCU read-side critical sections are
+ * delimited by rcu_read_lock() and rcu_read_unlock(), and may be nested.
  */
 void synchronize_rcu(void)
 {
