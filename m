Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1I2S1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:27:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35913 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab1I2S1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:27:50 -0400
Date: Thu, 29 Sep 2011 11:27:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] lockdep: Update documentation for lock-class leak
 detection
Message-ID: <20110929182744.GI2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110928181139.GA8217@linux.vnet.ibm.com>
 <1317303019.22581.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317303019.22581.8.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 03:30:19PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-09-28 at 11:11 -0700, Paul E. McKenney wrote:
> > There are a number of bugs that can leak lock classes, which will
> > eventually exhaust the maximum number (currently 8191).  However,
> > the documentation does not tell you how to track down the leakers.
> > This commit addresses this shortcoming.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
> > index abf768c..24bfd9f 100644
> > --- a/Documentation/lockdep-design.txt
> > +++ b/Documentation/lockdep-design.txt
> > @@ -221,3 +221,55 @@ when the chain is validated for the first time, is then put into a hash
> >  table, which hash-table can be checked in a lockfree manner. If the
> >  locking chain occurs again later on, the hash table tells us that we
> >  dont have to validate the chain again.
> > +
> > +Troubleshooting:
> > +----------------
> > +
> > +The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
> > +Exceeding this number will trigger the following lockdep warning:
> > +
> > +	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
> > +
> > +By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
> > +desktop systems have less than 1,000 lock classes, so this warning
> > +normally results from lock-class leakage.  Such leakage can result
> > +from the following:
> > +
> > +1.	Repeated module loading and unloading while running the validator.
> > +	The issue here is that each load of the module will create a
> > +	new set of lock classes for that module's locks, and module
> > +	unloading cannot remove old classes.  Therefore, if that module
> > +	is loaded and unloaded repeatedly, the number of lock classes
> > +	will eventually reach the maximum.
> > +
> > +2.	Dynamically allocating and freeing structures containing fields
> > +	of type "struct lock_class_key".  Again, the fact that old
> > +	lock classes cannot be reused means that repeating allocation/free
> > +	cycles for long enough will cause the number of lock classes to
> > +	eventually reach the maximum.
> > +
> 
> This isn't actually true, we check for keys to be in .data or .bss:
> 
> register_lock_class():
>         /*
>          * Debug-check: all keys must be persistent!
>          */
>         if (!static_obj(lock->key)) {
>                 debug_locks_off();
>                 printk("INFO: trying to register non-static key.\n");
>                 printk("the code is fine but needs lockdep annotation.\n");
>                 printk("turning off the locking correctness validator.\n");
>                 dump_stack();
> 
>                 return NULL;
>         }
> 
> 
> But what can happen is that you 'accidentally' create a lot of static
> locks, eg.
> 
> struct {
> 	spinlock_t lock;
> 	struct hlist_head hlist;
> } my_hash[1 << HASH_BITS];
> 
> If you don't initialize the lock members you'll find that each will get
> a separate lock class based on its static address. This can quickly
> deplete the class storage.
> 
> Now really, you shouldn't ever not initialize a lock, but the above has
> actually happened, although I can't find the commit atm.

Thank you for the review and feedback!  Here is an updated version.

							Thanx, Paul

------------------------------------------------------------------------

lockdep: Update documentation for lock-class leak detection

There are a number of bugs that can leak or overuse lock classes,
which can cause the maximum number of lock classes (currently 8191)
to be exceeded.  However, the documentation does not tell you how to
track down these problems.  This commit addresses this shortcoming.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index abf768c..24bfd9f 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -221,3 +221,55 @@ when the chain is validated for the first time, is then put into a hash
 table, which hash-table can be checked in a lockfree manner. If the
 locking chain occurs again later on, the hash table tells us that we
 dont have to validate the chain again.
+
+Troubleshooting:
+----------------
+
+The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
+Exceeding this number will trigger the following lockdep warning:
+
+	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
+
+By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
+desktop systems have less than 1,000 lock classes, so this warning
+normally results from lock-class leakage.  Such leakage can result
+from the following:
+
+1.	Repeated module loading and unloading while running the validator.
+	The issue here is that each load of the module will create a
+	new set of lock classes for that module's locks, and module
+	unloading cannot remove old classes.  Therefore, if that module
+	is loaded and unloaded repeatedly, the number of lock classes
+	will eventually reach the maximum.
+
+2.	Dynamically allocating and freeing structures containing fields
+	of type "struct lock_class_key".  Again, the fact that old
+	lock classes cannot be reused means that repeating allocation/free
+	cycles for long enough will cause the number of lock classes to
+	eventually reach the maximum.
+
+One might argue that the validator should be modified to allow lock
+classes to be reused.  However, if you are tempted to make this argument,
+first review the code and think through the changes that would be
+required, keeping in mind that the lock classes to be removed are likely
+to be linked into the lock-dependency graph.  This turns out to be a
+harder to do than to say.
+
+But if you run out of lock classes, the next question is what are the
+offending lock classes.  First, the following command gives you the
+number of lock classes currently in use along with the maximum:
+
+	grep "lock-classes" /proc/lockdep_stats
+
+This command gets the following output on a modest Power system:
+
+	 lock-classes:                          748 [max: 8191]
+
+If the number allocated (748 above) increases continually over time,
+then there is likely a leak.  The following command can be used to
+identify the leaking lock classes:
+
+	grep "BD" /proc/lockdep
+
+Run the command and save the output, then compare against the output
+from a later run of this command to identify the leakers.
