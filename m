Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0DAQIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab0DAQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:07:52 -0400
Date: Thu, 1 Apr 2010 18:07:03 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401160703.GU5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <1270137002.1598.65.camel@laptop>
 <1270137362.1598.77.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270137362.1598.77.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:56:02PM +0200, Peter Zijlstra wrote:
> Another thing is mm->nr_ptes, that doens't appear to be properly
> serialized, __pte_alloc() does ++ under mm->page_table_lock, but
> free_pte_range() does -- which afaict isn't always with page_table_lock
> held, it does however always seem to have mmap_sem for writing.

Not saying this is necessarily safe, but how can be that relevant with
spinlock->mutex/rwsem conversion? Only thing that breaks with that
conversion would be RCU (the very anon_vma rcu breaks because it
rcu_read_lock disabling preempt and then takes the anon_vma->lock,
that falls apart because taking the anon_vma->lock will imply a
schedule), but nr_ptes is a write operation so it can't be protected
by RCU.

> However __pte_alloc() callers do not in fact hold mmap_sem for writing.

As long as the mmap_sem readers always also take the page_table_lock
we're safe.
