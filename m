Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2B1Io2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:44:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab2B1Io0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:44:26 -0500
Date: Tue, 28 Feb 2012 09:43:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120228084359.GJ21106@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227155338.7b5110cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> Subject: brlocks/lglocks: cleanups

This patch, while I agree with the goal of de-CPP-ing the 
lglocks code, violates my sense of taste and logic in numerous 
ways. If we touch this code it should be done right.

This patch should also probably go upstream through the 
locking/lockdep tree? Mind sending it us once you think it's 
ready?

> 
>  fs/dcache.c            |    4 
>  fs/file_table.c        |   17 +--
>  fs/internal.h          |    3 
>  fs/namei.c             |   24 ++--
>  fs/namespace.c         |  140 ++++++++++++++--------------
>  fs/pnode.c             |    4 
>  fs/proc_namespace.c    |    4 
>  include/linux/lglock.h |  189 +++++++--------------------------------
>  kernel/Makefile        |    2 
>  kernel/lglock.c        |  136 ++++++++++++++++++++++++++++
>  10 files changed, 269 insertions(+), 254 deletions(-)

It's absolutely crazy to do such a large patch that both 
uninlines the code and changes the API.

There is absolutely no good reason to do it like that - and the 
resulting merge pain on Andrew is a direct result of that: had 
it been kept separate it would be much easier and safer to 
update just the API change patch ...

Do those things in at least two patches, making the bigger API 
change patch plain and *OBVIOUS*.

> +struct lglock {
> +	arch_spinlock_t __percpu *lock;
> +	cpumask_t cpus;	/* XXX need to put on separate cacheline? */
> +	spinlock_t cpu_lock;
> +	struct notifier_block cpu_notifier;
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lock_class_key lock_key;
> +	struct lockdep_map    lock_dep_map;
> +#endif
> +};

This is not a readable structure definition. Plenty of readable 
ones exist in the tree, they should be inspected for clues.

> +/* Only valid for statics */

what does this comment mean?

> +void lg_lock_init(struct lglock *lg, char *name);
> +void lg_local_lock(struct lglock *lg);
> +void lg_local_unlock(struct lglock *lg);
> +void lg_local_lock_cpu(struct lglock *lg, int cpu);
> +void lg_local_unlock_cpu(struct lglock *lg, int cpu);
> +void lg_global_lock_online(struct lglock *lg);
> +void lg_global_unlock_online(struct lglock *lg);
> +void lg_global_lock(struct lglock *lg);
> +void lg_global_unlock(struct lglock *lg);
> +
> +int lg_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu);

These APIs lack documentation.

> +/* Note there is no uninit, so lglocks cannot be defined in
> + * modules (but it's fine to use them from there)
> + * Could be added though, just undo lg_lock_init
> + */

I'm sure Andi knows what the standard shape of multi-line 
comments is in the kernel? Why has he still not learned?

> +void lg_local_lock(struct lglock *lg)
> +{
> +	arch_spinlock_t *lock;
> +	preempt_disable();

I'm sure Andi knows what's wrong here, he has been reviewed 
dozens of times for similar mistakes in the x86 trees.

> +void lg_local_unlock(struct lglock *lg)
> +{
> +	arch_spinlock_t *lock;
> +	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);

ditto.

> +void lg_local_lock_cpu(struct lglock *lg, int cpu)
> +{
> +	arch_spinlock_t *lock;
> +	preempt_disable();

ditto.

> +	arch_spinlock_t *lock;
> +	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);

ditto.

> +{
> +	int i;
> +	spin_lock(&lg->cpu_lock);

ditto.

> +{
> +	int i;
> +	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);

ditto.

> +{
> +	int i;
> +	preempt_disable();

ditto.

> +{
> +	int i;
> +	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);

ditto.

> +int lg_cpu_callback(struct notifier_block *nb,
> +                              unsigned long action, void *hcpu)

ugly linebreak, we can do better.


> +{
> +	struct lglock *lglock = container_of(nb, struct lglock, cpu_notifier);
> +	switch (action & ~CPU_TASKS_FROZEN) {

sigh.

Until these defects (and probably more, haven't done a full 
check) are fixed:

Nacked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
