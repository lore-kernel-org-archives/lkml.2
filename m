Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab0DARCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0DARBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:01:52 -0400
Date: Thu, 1 Apr 2010 17:32:05 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401153205.GO5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:04:04PM +0200, Thomas Gleixner wrote:
> On Thu, 1 Apr 2010, Peter Zijlstra wrote:
> 
> > I'm sure you dropped Ingo and Thomas by accident.
> > 
> > On Thu, 2010-04-01 at 12:40 +0300, Avi Kivity wrote:
> > > mmu_take_all_locks() takes a spinlock for each vma, which means we increase
> > > the preempt count by the number of vmas in an address space.  Since the user
> > > controls the number of vmas, they can cause preempt_count to overflow.
> > > 
> > > Fix by making mmu_take_all_locks() only disable preemption once by making
> > > the spinlocks preempt-neutral.
> > 
> > Right, so while this will get rid of the warning it doesn't make the
> > code any nicer, its still a massive !preempt latency spot.
> 
> I'm not sure whether this is a real well done April 1st joke or if there
> is someone trying to secure the "bad taste patch of the month" price.
> 
> Anyway, I don't see a reason why we can't convert those locks to
> mutexes and get rid of the whole preempt disabled region.

Converting those locks to mutexes will also allow to cleanly handle
XPMEM schedule-in-mmu-notifier-handler requirement the right way.

For now getting rid of the warning is enough though. Changing the
locking would be possible but it'd slowdown the whole kernel all the
time even if nobody would ever load the kvm or gru kernel modules.

Let's be practical, this isn't even a syscall, this is only called by
device driver ioctl and it's about losing 1msec or so in latency, to
keep the whole kernel as fast as if mmu notifier didn't exist. I don't
think we should have 1 single wide lock to take in
mmu_notifier_register and then slowdown the kernel when nobody uses
mmu notifier at all. Losing 1msec when a VM starts isn't a big deal
really. If this wasn't the case it wouldn't have been merged in the
first place I think. Besides with -rt these locks aren't going to hurt
latency AFIK.
