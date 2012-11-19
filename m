Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2KSNyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:54:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2KSNyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:54:01 -0500
Date: Mon, 19 Nov 2012 14:54:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Q: __lockdep_no_validate__ (Was: [PATCH -mm 0/3]
	percpu_rw_semaphore: lockdep + config)
Message-ID: <20121119135412.GA24476@redhat.com>
References: <20121118190257.GA9660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118190257.GA9660@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Oleg Nesterov wrote:
>
> On 11/11, Oleg Nesterov wrote:
> >
> It turns out, lockdep annotations are not that simple due to internal
> locks used by percpu_rw_semaphore. To clarify, it is actually simple
> but lockdep_set_novalidate_class() doesn't seem to actually work, and
> more importantly, it must not be used according to checkpatch.pl.

Still, is __lockdep_no_validate__ logic correct? I am just curious.

Consider the following code,


	DEFINE_MUTEX(m1);
	DEFINE_MUTEX(m2);
	DEFINE_MUTEX(mx);

	static void trigger_lockdep_bug(bool novalidate)
	{
		if (novalidate)
			lockdep_set_novalidate_class(&mx);

		// m1 -> mx -> m2
		mutex_lock(&m1);
			mutex_lock(&mx);
		mutex_lock(&m2);
		mutex_unlock(&m2);
			mutex_unlock(&mx);
		mutex_unlock(&m1);


		// m2 -> m1 ; should trigger the warning

		mutex_lock(&m2);
		mutex_lock(&m1);
		mutex_unlock(&m1);
		mutex_unlock(&m2);

	}

trigger_lockdep_bug(false) works correctly, but novalidate => true
confuses (I think) lockdep and it doesn't detect the trivial deadlock.

check_prev_add(m1, mx) still adds the new dependency, but then it is
ignored because of __lockdep_no_validate__ check.

Certainly I do not understand this code (and I am sure I will never
understand it even if I try ;) But perhaps something like below makes
sense? Or I misunderstood the purpose of lockdep_set_novalidate_class?

Thanks,

Oleg.

--- x/kernel/lockdep.c
+++ x/kernel/lockdep.c
@@ -1935,7 +1939,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (hlock->read != 2 &&
+		    hlock->instance->key != &__lockdep_no_validate__) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;

