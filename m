Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab0DAQuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:50:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:45396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab0DAQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:49:55 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1270140300.1598.148.camel@laptop>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com> <4BB480CC.2060503@redhat.com>
	 <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop>
	 <20100401154249.GQ5825@random.random> <1270138354.1598.99.camel@laptop>
	 <20100401161840.GX5825@random.random>  <1270140300.1598.148.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 18:49:52 +0200
Message-ID: <1270140592.1598.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 18:45 +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-01 at 18:18 +0200, Andrea Arcangeli wrote:
> > On Thu, Apr 01, 2010 at 06:12:34PM +0200, Peter Zijlstra wrote:
> > > One thing we can do there is to mutex_trylock() if we get the lock, see
> > > if we've got the right object, if the trylock fails we can do the
> > > refcount thing and sleep. That would allow the fast-path to remain a
> > > single atomic.
> > 
> > But then how do you know which anon_vma_unlink has to decrease the
> > refcount and which not? That info should need to be stored in the
> > kernel stack, can't be stored in the vma. I guess it's feasible but
> > passing that info around sounds more tricky than the trylock itself
> > (adding params to those functions with int &refcount). 
> 
> I was thinking of something like:
> 
> struct anon_vma *page_lock_anon_vma(struct page *page)
> {
> 	struct anon_vma *anon_vma = NULL;
> 	unsigned long anon_mapping;
> 
> 	rcu_read_lock();
> 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
>         if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)              
>                 goto out;                                                          
>         if (!page_mapped(page))                                                    
>                 goto out;                                                          
> 
>         anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);         
>         if (!mutex_trylock(&anon_vma->lock)) {
> 		if (atomic_inc_unless_zero(&anon_vma->ref)) {
> 			rcu_read_unlock();
> 			mutex_lock(&anon_vma->lock);
> 			atomic_dec(&anon_vma->ref); /* ensure the lock pins it */
> 		} else
> 			anon_vma = NULL;
> 	}
> 	rcu_read_unlock();
> 	
>         return anon_vma;
> }
> 
> void page_unlock_anon_vma(struct anon_vma *anon_vma)
> {
> 	mutex_unlock(&anon_vma->lock);	
> }
> 
> Then anybody reaching ref==0 would only need to sync against the lock
> before freeing.

Ah, there is a race where the dec after lock makes it 0, we could catch
that by making it -1 and free in unlock_anon_vma().

