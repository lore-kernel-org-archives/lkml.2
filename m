Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab0DAQop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758328Ab0DAQoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:38 -0400
Date: Thu, 1 Apr 2010 17:54:56 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401155456.GR5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <1270120592.1653.192.camel@laptop>
 <20100401153645.GP5825@random.random>
 <4BB4BE44.5070507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB4BE44.5070507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 06:39:48PM +0300, Avi Kivity wrote:
> On 04/01/2010 06:36 PM, Andrea Arcangeli wrote:
> > On Thu, Apr 01, 2010 at 01:16:32PM +0200, Peter Zijlstra wrote:
> >    
> >> On Thu, 2010-04-01 at 14:13 +0300, Avi Kivity wrote:
> >>
> >>      
> >>> If someone is willing to audit all code paths to make sure these locks
> >>> are always taken in schedulable context I agree that's a better fix.
> >>>        
> >> They had better be, they're not irq-safe. Also that's what lockdep is
> >> for.
> >>      
> > In my original patchset I included patches from Christoph to convert
> > those locks to mutexes, there was apparently no problem at all with
> > that. But frankly I think the only problem here is the warning. The
> > only compliant we ever had here is from developers, no users at
> > all. If this was a practical problem I think we should have heard
> > something by now with so many KVM users out there (and gru too).
> >
> > The only single reason I'd go for mutexes would be to accommodate
> > XPMEM requirements once and for all, no other reason.
> >    
> 
> There is also a minor benefit for kvm.  Reduced latency over large mmu 
> operations; code simplification (we now have some 
> copy_from_user_inatomic() that could be simplified).

Where exactly is KVM taking these locks? KVM should only call into
GUP, and GUP itself won't iterate over rmaps either. GUP just walks
the host pagetables and trigger page faults if the pages aren't
mapped. I don't see how you're going to remove
copy_from_user_inatomic() given we don't have vmas and other metadata
to take those locks. Maybe we can stop calling GUP but even if we take
the anon_vma mutex/semaphore I think it won't still prevent munmap to
drop the anon pages from under us (even if it'd stop the VM to unmap
them through rmap). To freeze the mapping one would need to take
mmap_sem in write mode in addition to the anon_vma mutex/sem which is
unlikely a win compared to just gup+copy_from_user_inatomic. So I
don't see immediate benefits for KVM but maybe I'm missing something
of course!
