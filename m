Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1BAWBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:01:03 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34260 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1BAWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:01:01 -0500
Date: Tue, 1 Feb 2011 14:00:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, efault@gmx.de, torvalds@linux-foundation.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
Message-ID: <20110201220026.GD2142@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110112150740.77dde58c@kryten>
 <1295288253.30950.280.camel@laptop>
 <smp-call-function-peter-reply@mdm.bga.com>
 <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <ipi-list-reply@mdm.bga.com>
 <smp-call-function-list-race-fix-v2@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <smp-call-function-list-race-fix-v2@mdm.bga.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:12:18AM -0600, Milton Miller wrote:
> Peter pointed out there was nothing preventing the list_del_rcu in
> smp_call_function_interrupt from running before the list_add_rcu in
> smp_call_function_many.   Fix this by not setting refs until we
> have gotten the lock for the list.  Take advantage of the wmb in
> list_add_rcu to save an explicit additional one.

Finally getting a chance to give this full attention...

I don't know how to do this patch-by-patch, so I applied these
three patches to mainline and looked at the result.  This probably
gets some comments that are irrelevant to these patches, but so it
goes.

Starting with smp_call_function_many():

o	The check for refs is redundant:

		/* some callers might race with other cpus changing the mask */
		if (unlikely(!refs)) {
			csd_unlock(&data->csd);
			return;
		}

	The memory barriers and atomic functions in
	generic_smp_call_function_interrupt() prevent the callback from
	being reused before the cpumask bits have all been cleared, right?
	Furthermore, csd_lock() contains a full memory barrier that pairs
	with the full memory barrier in csd_unlock(), so if csd_lock()
	returns, we are guaranteed to see the effects of all accesses
	to the prior incarnation of this structure.

	Yes, there might be another CPU that got a pointer to this
	callback just as another CPU removed it.  That CPU will see
	the callback as having their bit of the CPU mask zero until
	we set it, and they will further see ->refs as being zero
	until we set it.  And we don't set ->refs until after we
	re-insert the callback.

	So I we can drop this "if" statement entirely.

o	The smp_mb() below look extraneous.  The comment in
	generic_exec_single() agrees -- it says that the IPI
	code is required to impose ordering.  Besides,
	there is a lock in arch_send_call_function_ipi_mask(),
	and in conjunction with the unlock below, this makes
	a full memory barrier.  So I believe that we can drop
	the smp_mb() shown below.  (But not the comment!!!)

		raw_spin_unlock_irqrestore(&call_function.lock, flags);

		/*
		 * Make the list addition visible before sending the ipi.
		 * (IPIs must obey or appear to obey normal Linux cache
		 * coherency rules -- see comment in generic_exec_single).
		 */
		smp_mb();

		/* Send a message to all CPUs in the map */
		arch_send_call_function_ipi_mask(data->cpumask);

Next up: generic_smp_call_function_interrupt()

o	Shouldn't the smp_mb() at the top of the function be supplied
	in arch-specific code for those architectures that require it?

o	So, the check for the current CPU's bit in the mask...

	o	If the bit is clear, then we are looking at an callback
		that this CPU already processed or that was not intended
		for this CPU in the first place.

		Of course, this callback might be reused immediately
		after we do the check.  In that case, there should
		be an IPI waiting for us shortly.  If the IPI beat
		the callback to us, that seems to me to be a bug
		in the architecture rather than in this code.

	o	If the bit is set, then we need to process this callback.
		IRQs are disabled, so we cannot race with ourselves
		-- our bit will remain set until we clear it.
		The list_add_rcu() in smp_call_function_many()
		in conjunction with the list_for_each_entry_rcu()
		in generic_smp_call_function_interrupt() guarantees
		that all of the field except for ->refs will be seen as
		initialized in the common case where we are looking at
		an callback that has just been enqueued.

		In the uncommon case where we picked up the pointer
		in list_for_each_entry_rcu() just before the last
		CPU removed the callback and when someone else
		immediately recycled it, all bets are off.  We must
		ensure that we see all initialization via some other
		means.

		OK, so where is the memory barrier that pairs with the
		smp_rmb() between the ->cpumask and ->refs checks?
		It must be before the assignment to ->cpumask.  One
		candidate is the smp_mb() in csd_lock(), but that does
		not make much sense.  What we need to do is to ensure
		that if we see our bit in ->cpumask, that we also see
		the atomic decrement that previously zeroed ->refs.
		But some third CPU did that atomic decrement, which
		brings transitivity into play, which leads me to believe
		that this smp_rmb() might need to be upgraded to a
		full smp_mb().

o	After we verify that the ->refs field is non-zero, we pick
	up the ->csd.func and ->csd.info fields, but with no intervening
	memory barrier.  There needs to be at least an smp_rmb()
	following the test of the ->refs field.  Since there is
	no transitivity required, smp_rmb() should do the trick.

	If this seems unnecessary, please keep in mind that there
	is nothing stopping the compiler and the CPU from reordering
	the statements in smp_call_function_many() that initialize
	->csd.func, ->csd.info, and ->cpumask.

	In contrast, given the suggested smp_rmb(), we are guaranteed
	of the identity of the callback from the time we test ->refs
	until the time someone calls csd_unlock(), which cannot precede
	the time that we atomically decrement ->refs.

o	It seems silly to pick up the ->csd.func field twice.  Why
	not use the local variable?

o	The cpumask_test_and_clear_cpu() and the atomic_dec_return()
	are both atomic operations that return values, so they act
	as full memory barriers.

	The cpumask_test_and_clear_cpu() needs to be atomic despite
	the identity guarantee because CPUs might be concurrently
	trying to clear bits in the same word.

Here is the corresponding (untested) patch.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

smp_call_function: additional memory-order tightening.

The csd_lock() and csd_unlock() interaction guarantees that the
smp_call_function_many() function sees the results of interactions
with prior incarnations of the callback, so the check is not needed.
Instead, tighter memory ordering is required in the companion
generic_smp_call_function_interrupt() function to ensure proper
interaction with partially initialized callbacks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/smp.c b/kernel/smp.c
index 064bb6e..4c8b005 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -209,13 +209,19 @@ void generic_smp_call_function_interrupt(void)
 		if (!cpumask_test_cpu(cpu, data->cpumask))
 			continue;
 
-		smp_rmb();
+		smp_mb(); /* If we see our bit set above, we need to see */
+			  /* all the processing associated with the prior */
+			  /* incarnation of this callback. */
 
 		if (atomic_read(&data->refs) == 0)
 			continue;
 
+		smp_rmb(); /* If we see non-zero ->refs, we need to see all */
+			   /* other initialization for this incarnation of */
+			   /* this callback. */
+
 		func = data->csd.func;			/* for later warn */
-		data->csd.func(data->csd.info);
+		func(data->csd.info);
 
 		/*
 		 * If the cpu mask is not still set then func enabled
@@ -492,12 +498,6 @@ void smp_call_function_many(const struct cpumask *mask,
 	cpumask_clear_cpu(this_cpu, data->cpumask);
 	refs = cpumask_weight(data->cpumask);
 
-	/* some callers might race with other cpus changing the mask */
-	if (unlikely(!refs)) {
-		csd_unlock(&data->csd);
-		return;
-	}
-
 	/*
 	 * We reuse the call function data without waiting for any grace
 	 * period after some other cpu removes it from the global queue.
@@ -527,8 +527,9 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * Make the list addition visible before sending the ipi.
 	 * (IPIs must obey or appear to obey normal Linux cache
 	 * coherency rules -- see comment in generic_exec_single).
+	 * The unlock above combined with the lock in the IPI
+	 * code covers this requirement.
 	 */
-	smp_mb();
 
 	/* Send a message to all CPUs in the map */
 	arch_send_call_function_ipi_mask(data->cpumask);
