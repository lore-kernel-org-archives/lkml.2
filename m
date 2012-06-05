Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab2FEJci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:32:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59002 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2FEJcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:32:36 -0400
Date: Tue, 5 Jun 2012 14:58:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] uprobes: make register/unregister O(n)
Message-ID: <20120605092834.GN24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120604145238.GA6408@redhat.com>
 <20120604173711.GM24279@linux.vnet.ibm.com>
 <20120604184109.GA24499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120604184109.GA24499@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060509-7606-0000-0000-000000DCF552
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is more theory
> > If the number of vmas in the priority tree keeps increasing in every
> > iteration, and the kmalloc(GFP_NOWAIT) fails i.e more is !0, then
> > dont we end up in a forever loop?
> 
> But this can only hapen if the number of mappings keeps increasing
> indefinitely, this is not possible.

Agree, that why I said in theory.

> 
> And please not that the current code is worse if the number of mappings
> grows. In fact it can livelock even if this number is limited. Suppose
> you are trying to probe /bin/true and some process does
> "while true; do /bin/true; done". It is possible that every time
> register_for_each_vma() finds the new mapping because we do not free
> the previous entries which refer to the already dead process/mm.
> 

Completely agree that build_map_info is much better the current implementation. 
I was only trying understand and if possible simplify.

> 
> > Cant we just restrict this to just 2 iterations? [And depend on
> > uprobe_mmap() to do the necessary if new vmas come in].
> 

> Probably yes, we can improve this. But I don't think this is that
> easy, we can't rely on vma_prio_tree_foreach's ordering.
> 

Correct, I forgot that we cant rely on vma_prio_tree_for_each ordering.

> > >  out:
> >
> > > 	while (prev)
> > > 		prev = free_map_info(prev);
> >
> > If we were able to allocate all map_info objects in the first pass but
> > the last vma belonged to a mm thats at exit, i.e atomic_inc_non_zero
> > returned 0 , then prev is !NULL and more is 0.  Then we seem to clear
> > all the map_info objects without even decreasing the mm counts for which
> > atomic_inc_non_zero() was successful. Will curr be proper in this case.


I missed the point that prev->next is NULL when atomic_inc_non_zero
fails.

> 
> Not sure I understand. To simplify, suppose that we have a single mapping
> but atomic_inc_non_zero() fails. In this case, yes, prev != NULL but
> prev->mm is not valid. We only need to free the "extra" memory and return
> curr == NULL (empty list). This is what the loop above does.
> 
> We only need mmput(mm) if atomic_inc_non_zero() suceeeds, and in this
> case this "mm" should live in "curr" list. If we need more memory, then
> build_map_info() does this right after it detects more != 0. Otherwise
> the caller should do this.
> 

Correct. I understand now.

> > Should this while be an if?
> 
> But we can have more entries to free? Not only because atomic_inc_non_zero
> failed.
> 

Oh Yes, we could have entries to free because the vmas in the prio-tree
might have decreased by the time we walk the prio-tree the second time.

-- 
Thanks and Regards
Srikar

