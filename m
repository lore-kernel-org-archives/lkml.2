Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2CIVGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:06:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:55290 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2CIVGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:06:13 -0500
Message-ID: <1331327166.3105.68.camel@pasglop>
Subject: Re: [PATCH 3/3] flush_tlb_range() needs ->page_table_lock when
 ->mmap_sem is not held
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 10 Mar 2012 08:06:06 +1100
In-Reply-To: <20120305205354.GM23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
	 <20120305064029.GK23916@ZenIV.linux.org.uk>
	 <CA+55aFwQtEPGwK-W8H3Fa0EZUOV057kj_xhUXONZRcyeZtSt3Q@mail.gmail.com>
	 <20120305205354.GM23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 20:53 +0000, Al Viro wrote:
> On Mon, Mar 05, 2012 at 12:30:19PM -0800, Linus Torvalds wrote:
> > Is this safe? And why does it need it? Please add more explanations.
> 
> a) safety - as the matter of fact, all other callers either hold either
> ->mmap_sem (exclusive) or ->page_table_lock.  flush_tlb_range() is
> called under ->page_table_lock in a lot of places, e.g.
> page_referenced_one() -> pmdp_clear_flush_young_notify() ->
> -> pmdp_clear_flush_young() -> flush_tlb_range(), with
>                 /* go ahead even if the pmd is pmd_trans_splitting() */
>                 if (pmdp_clear_flush_young_notify(vma, address, pmd))
>                         referenced++;
>                 spin_unlock(&mm->page_table_lock);
> in page_referenced_one().
>
> b) there are instances that work with page tables.  See e.g.
> arch/powerpc/mm/tlb_hash32.c, flush_tlb_range() and flush_range() in there.
> The same goes for uml, with a lot more extensive playing with page tables.

Yes, we need to make sure they don't go away. Without any of these locks
page table pages may be freed... however, I don't see the page table
lock ensuring that anymore. The hugetlb_free_pgd_range implementation in
powerpc seemed to have old comments about expecting the PTL to be held
but that doesn't appear to be the case anymore.

In fact I always worry with the whole walking of page tables vs. freeing
them. We use sched RCU to delay the freeing so we -should- be ok if we
keep interrupts off on the walking side but it's fishy.

> Almost all callers are actually fine - flush_tlb_range() may have no need
> to bother playing with page tables, but it can do so safely; again, this
> caller is the sole exception - everything else either has exclusive ->mmap_sem
> on the mm in question, or mm->page_table_lock is held.

mmap_sem will protect vs. page tables freeing. page_table_lock on the
other hand...

Cheers,
Ben.


