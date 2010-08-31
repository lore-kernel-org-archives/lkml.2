Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0HaGca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:32:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:48167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0HaGc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:32:28 -0400
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
In-Reply-To: <1283236004.2151.33.camel@pasglop>
References: <20100828141637.421594670@chello.nl>
	 <20100828142455.960494507@chello.nl>  <1283236004.2151.33.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:31:05 +1000
Message-ID: <1283236265.2151.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 16:26 +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2010-08-28 at 16:16 +0200, Peter Zijlstra wrote:
> > Fix up powerpc to the new mmu_gather stuffs.
> 
> Unfortunately, I think this is broken...
> 
> First there's an actual bug here:
> 
> >  	last = _switch(old_thread, new_thread);
> >  
> > +#ifdef CONFIG_PPC64
> > +	if (task_thread_info(new)->local_flags & _TLF_LAZY_MMU) {
> > +		task_thread_info(new)->local_flags &= ~_TLF_LAZY_MMU;
> > +		batch = &__get_cpu_var(ppc64_tlb_batch);
> > +		batch->active = 1;
> > +	}
> > +#endif
> > +
> 
> Here, you are coming out of _switch() which will have swapped the
> stack and non-volatile registers to the state they were in when the
> new task was originally switched-out. Thus "new" which is a local variable
> (either on stack or in a non-volatile register) will now refer to whatever
> was the next task back then.
> 
> I suppose that's what's causing the similar patch you have in -rt to
> fail btw. This could be fixed easily by using "current" instead.

And here's a fix. Using current_thread_info() everywhere is better
anyways, you are not supposed to touch the local_flags within anything
but "current" so we may as well make it explicit.

Feel free to fold that into your -rt patch and this one if you decide
not to drop that whole part.

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 6ee4b09..6e8b6de 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -517,12 +517,12 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 	batch = &__get_cpu_var(ppc64_tlb_batch);
 	if (batch->active) {
-		task_thread_info(prev)->local_flags |= _TLF_LAZY_MMU;
+		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
 		if (batch->index)
 			__flush_tlb_pending(batch);
 		batch->active = 0;
 	}
-#endif
+#endif /* CONFIG_PPC64 */
 
 	local_irq_save(flags);
 
@@ -539,12 +539,12 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	last = _switch(old_thread, new_thread);
 
 #ifdef CONFIG_PPC64
-	if (task_thread_info(new)->local_flags & _TLF_LAZY_MMU) {
-		task_thread_info(new)->local_flags &= ~_TLF_LAZY_MMU;
+	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
+		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
 		batch = &__get_cpu_var(ppc64_tlb_batch);
 		batch->active = 1;
 	}
-#endif
+#endif /* CONFIG_PPC64 */
 
 	local_irq_restore(flags);
 


