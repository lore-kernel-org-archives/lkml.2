Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2EAK5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:57:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2EAK53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:57:29 -0400
Message-ID: <1335869827.13683.133.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Date: Tue, 01 May 2012 12:57:07 +0200
In-Reply-To: <4F9FBF38.2060903@redhat.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	  <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>
	 <1335865176.13683.120.camel@twins> <4F9FBF38.2060903@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 13:47 +0300, Avi Kivity wrote:
> On 05/01/2012 12:39 PM, Peter Zijlstra wrote:
> > On Sun, 2012-04-29 at 15:23 +0300, Avi Kivity wrote:
> > > On 04/27/2012 07:24 PM, Nikunj A. Dadhania wrote:
> > > > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > > > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > > > paravirtualization.
> > > >
> > > > Use the vcpu state information inside the kvm_flush_tlb_others to
> > > > avoid sending ipi to pre-empted vcpus.
> > > >
> > > > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> > > 
> > > get_user_pages_fast() depends on the IPI to hold off page table teardown
> > > while they are locklessly walked with interrupts disabled.  If a vcpu
> > > were to be preempted while in this critical section, another vcpu
> > > tearing down page tables would go ahead and destroy them.  when the
> > > preempted vcpu resumes it then touches the freed pages.
> > > 
> > > We could try to teach kvm and get_user_pages_fast() about this, but this
> > > is intrusive.  Another option is to replace the cpu_relax() loop with
> > > something that sleeps and is then woken up by the TLB IPI handler if needed.
> >
> > I think something like
> >
> >   select HAVE_RCU_TABLE_FREE if PARAVIRT
> >
> > or somesuch is just about all it takes.
> >
> > A slightly better option would be to wrap all that tlb_*table* goo into
> > paravirt stuff and only do the RCU free when paravirt is indeed enabled,
> > but other than that you're there.
> 
> I infer from this that there is a cost involved with rcu freeing.  Any
> idea how much?

No idea, so far that code has only been used on platforms that required
it so they didn't have a choice in the matter.

> Looks like this increases performance for the overcommitted case, and
> also for the case where many vcpus are sleeping, while reducing
> performance for the uncontended, high duty cycle case.

Sounds backwards if you put it like that ;-)

> > This should work because the preempted vcpu's RCU state would also be
> > stalled and thus avoids the actual page-table from going away.
> 
> It can be unstalled at any moment.  But spin_lock_irq() > rcu_read_lock().

Right, but since gup_fast has IRQs disabled the RCU state machine (as
driven by the tick) won't actually do anything until its done.

To be clear, the case was where the gup_fast() performing vcpu was
preempted in the middle of gup_fast(), on wakeup it would perform the
TLB flush on the virt-enter hook, but meanwhile a sibling vcpu might
have free'd the page-tables.

By using call_rcu_sched() to free the page-tables you'd need to receive
and process at least one tick on the woken up cpu after the freeing, but
since the in-progress gup_fast() will have IRQs disabled this will be
delayed.

Anyway, I don't have any idea about the costs involved with
HAVE_RCU_TABLE_FREE, but I don't think its much.. otherwise these other
platforms (PPC,SPARC) wouldn't have used it, gup_fast() is a very
specific case, whereas mmu-gather is something affecting pretty much all
tasks.

But mostly my comment was due to you saying modifying gup_fast() would
be difficult.. I was thinking the one Kconfig line wasn't as onerous ;-)

