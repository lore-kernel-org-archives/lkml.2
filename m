Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0HaG2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:28:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:43786 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0HaG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:28:06 -0400
Subject: Re: [PATCH 08/20] powerpc: Preemptible mmu_gather
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20100828142455.960494507@chello.nl>
References: <20100828141637.421594670@chello.nl>
	 <20100828142455.960494507@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:26:44 +1000
Message-ID: <1283236004.2151.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 16:16 +0200, Peter Zijlstra wrote:
> Fix up powerpc to the new mmu_gather stuffs.

Unfortunately, I think this is broken...

First there's an actual bug here:

>  	last = _switch(old_thread, new_thread);
>  
> +#ifdef CONFIG_PPC64
> +	if (task_thread_info(new)->local_flags & _TLF_LAZY_MMU) {
> +		task_thread_info(new)->local_flags &= ~_TLF_LAZY_MMU;
> +		batch = &__get_cpu_var(ppc64_tlb_batch);
> +		batch->active = 1;
> +	}
> +#endif
> +

Here, you are coming out of _switch() which will have swapped the
stack and non-volatile registers to the state they were in when the
new task was originally switched-out. Thus "new" which is a local variable
(either on stack or in a non-volatile register) will now refer to whatever
was the next task back then.

I suppose that's what's causing the similar patch you have in -rt to
fail btw. This could be fixed easily by using "current" instead.

However, there I have another concern.

> PPC has an extra batching queue to RCU free the actual pagetable
> allocations, use the ARCH extentions for that for now.

Right, so far that looks fine (at least after a quick look).

> For the ppc64_tlb_batch, which tracks the vaddrs to unhash from the
> hardware hash-table, keep using per-cpu arrays but flush on context
> switch and use a TLF bit to track the laxy_mmu state.

However, that doesn't seem necessary at all, at least not for !-rt, or
unless you broke something that I would need to look at very closely
then :-)

IE. Enable/disable the batch only within "lazy_mmu_mode" sections. We do
that in large part because we do not want non-flushed pages to exist
outside of the pte spinlock.

The reason is that if we let that happen, a small possibility exist for
our MMU hash page handling to try to insert a duplicate entry for a
given PTE into the hash table, which is basically fatal.

Thus, we only exist during that lazy period, which means with a lock
held. Hence we can't schedule and the changes you do regarding
get/put_cpu_var are unnecessary.

Another "trick" here btw is that fork() is currently not using a batch,
but with our technique, we do get batching there too.

So unless something else is broken that makes the above not true
anymore, which would be a concern, most of the changes you did to the
flush batch are unnecessary for your preemptible mmu_gather on non-rt
kernels.

Of course, with -rt and the pte lock becoming a mutex, all of your
changes do become necessary (and I suppose that's where they come from).

Now, those changes won't technically hurt on a non-rt kernel, tho they
will add a tiny bit of overhead. I'll see if I can measure it.

Cheers,
Ben.


