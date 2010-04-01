Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0DAL1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:27:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:33464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0DAL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:27:47 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BB480CC.2060503@redhat.com>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com>  <4BB480CC.2060503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 13:27:44 +0200
Message-ID: <1270121264.1653.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 14:17 +0300, Avi Kivity wrote:
> On 04/01/2010 02:13 PM, Avi Kivity wrote:
> >
> >> Anyway, I don't see a reason why we can't convert those locks to
> >> mutexes and get rid of the whole preempt disabled region.
> >
> > If someone is willing to audit all code paths to make sure these locks 
> > are always taken in schedulable context I agree that's a better fix.
> >
> 
>  From mm/rmap.c:
> 
> > /*
> >  * Lock ordering in mm:
> >  *
> >  * inode->i_mutex    (while writing or truncating, not reading or 
> > faulting)
> >  *   inode->i_alloc_sem (vmtruncate_range)
> >  *   mm->mmap_sem
> >  *     page->flags PG_locked (lock_page)
> >  *       mapping->i_mmap_lock
> >  *         anon_vma->lock
> ...
> > *
> >  * (code doesn't rely on that order so it could be switched around)
> >  * ->tasklist_lock
> >  *   anon_vma->lock      (memory_failure, collect_procs_anon)
> >  *     pte map lock
> >  */
> 
> i_mmap_lock is a spinlock, and tasklist_lock is a rwlock, so some 
> changes will be needed.

i_mmap_lock will need to change just as well, mm_take_all_locks() uses
both anon_vma->lock and mapping->i_mmap_lock.

I've almost got a patch done that converts those two, still need to look
where that tasklist_lock muck happens.



