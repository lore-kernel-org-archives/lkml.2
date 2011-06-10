Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1FJAus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:50:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40380 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FJAur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ugveuwqyIwOGAvJ9zGI/j2xRUc4sbCtbSuk4e2dK2F4+YE1uZKj+ywFJrjzd680bD0
         pesWUqtD35SoWOv9Y+B39ZNP2axGC2Wkn3g5NUVf6V6T/mWDEyExMgQdvI4FUx3H32bA
         534SQjZJ267IFbI2/jgrYu2PLYOqF3dEDJkd4=
Date: Fri, 10 Jun 2011 02:50:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] rcu: Detect uses of rcu read side in extended
 quiescent states
Message-ID: <20110610005041.GI25771@somewhere.redhat.com>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
 <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
 <20110610002350.GO2285@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610002350.GO2285@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:23:50PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 10, 2011 at 01:47:24AM +0200, Frederic Weisbecker wrote:
> > Detect uses of rcu that are not supposed to happen when we
> > are in an extended quiescent state.
> > 
> > This can happen for example if we use rcu between the time we
> > stop the tick and the time we restart it. Or inside an irq that
> > didn't use rcu_irq_enter,exit() or other possible kind of rcu API
> > misuse.
> > 
> > v2: Rebase against latest rcu changes, handle tiny RCU as well
> 
> Good idea on checking for RCU read-side critical sections happening
> in dyntick-idle periods!
> 
> But wouldn't it be better to put the checks in rcu_read_lock() and
> friends?  The problem I see with putting them in rcu_dereference_check()
> is that someone can legitimately do something like the following
> while in dyntick-idle mode:
> 
> 	spin_lock(&mylock);
> 	/* do a bunch of stuff */
> 	p = rcu_dereference_check(myrcuptr, lockdep_is_held(&mylock));
> 
> The logic below would complain about this usage, despite the fact
> that it is perfectly safe because the update-side lock is held.
> 
> Make sense, or am I missing something?
> 
> 						Thanx, Paul

I'm an idiot. I put my check in rcu_dereference_check() on purpose because
it's always called from places that check one of the rcu locks are held,
but I forgot that's also used for custom conditions with the _check()
things.

That said, putting the check in rcu_read_lock() and alike  would only work
with rcu_read_lock() itself. Few users of rcu_read_lock_sched() actually
call it explicitely but rely on irq disabled or preempt disabled. And I can't put the
checks there as it's fine to disabled irqs in dyntick idle.

What about the below? (untested yet)

And I would print the state of dynticks-idle mode in the final lockdep warning.

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6cad1f3..b9e68ae 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -278,7 +278,7 @@ static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	return lock_is_held(&rcu_lock_map);
+	return lock_is_held(&rcu_lock_map) && !rcu_check_extended_qs();
 }
 
 /*
@@ -310,13 +310,13 @@ static inline int rcu_read_lock_sched_held(void)
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
 	if (debug_locks)
-		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
+		lockdep_opinion = lock_is_held(&rcu_sched_lock_map) && !rcu_check_extended_qs();
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
 {
-	return 1;
+	return !rcu_check_extended_qs();
 }
 #endif /* #else #ifdef CONFIG_PREEMPT */
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a088c90..20d6e7228 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -88,7 +88,7 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	return in_softirq() || irqs_disabled();
+	return !rcu_check_extended_qs() && (in_softirq() || irqs_disabled());
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
