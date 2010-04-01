Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab0DAQcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:32:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0DAQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:32:45 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100401160703.GU5825@random.random>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com> <4BB480CC.2060503@redhat.com>
	 <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop>
	 <20100401154249.GQ5825@random.random> <1270137002.1598.65.camel@laptop>
	 <1270137362.1598.77.camel@laptop>  <20100401160703.GU5825@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 18:32:42 +0200
Message-ID: <1270139562.1598.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 18:07 +0200, Andrea Arcangeli wrote:
> On Thu, Apr 01, 2010 at 05:56:02PM +0200, Peter Zijlstra wrote:
> > Another thing is mm->nr_ptes, that doens't appear to be properly
> > serialized, __pte_alloc() does ++ under mm->page_table_lock, but
> > free_pte_range() does -- which afaict isn't always with page_table_lock
> > held, it does however always seem to have mmap_sem for writing.
> 
> Not saying this is necessarily safe, but how can be that relevant with
> spinlock->mutex/rwsem conversion? 

Not directly, but I keep running into that BUG_ON() at the end up
exit_mmap() with my conversion patch, and I though that maybe I widened
the race window.

But I guess I simply messed something up.

> Only thing that breaks with that
> conversion would be RCU (the very anon_vma rcu breaks because it
> rcu_read_lock disabling preempt and then takes the anon_vma->lock,
> that falls apart because taking the anon_vma->lock will imply a
> schedule), but nr_ptes is a write operation so it can't be protected
> by RCU.
> 
> > However __pte_alloc() callers do not in fact hold mmap_sem for writing.
> 
> As long as the mmap_sem readers always also take the page_table_lock
> we're safe.

Ah, I see so its: down_read(mmap_sem) + page_table_lock that's exclusive
against down_write(mmap_sem), nifty, should be a comment somewhere.

