Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2EAMNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:13:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2EAMNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:13:31 -0400
Message-ID: <4F9FD337.5010908@redhat.com>
Date: Tue, 01 May 2012 15:12:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu>   <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins> <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>
In-Reply-To: <1335869827.13683.133.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 01:57 PM, Peter Zijlstra wrote:
> > Looks like this increases performance for the overcommitted case, and
> > also for the case where many vcpus are sleeping, while reducing
> > performance for the uncontended, high duty cycle case.
>
> Sounds backwards if you put it like that ;-)

Yes...

> > > This should work because the preempted vcpu's RCU state would also be
> > > stalled and thus avoids the actual page-table from going away.
> > 
> > It can be unstalled at any moment.  But spin_lock_irq() > rcu_read_lock().
>
> Right, but since gup_fast has IRQs disabled the RCU state machine (as
> driven by the tick) won't actually do anything until its done.

That's what I meant, except I mistyped local_irq_disable() as
spin_lock_irq().  local_irq_save() is a stronger version or rcu_read_lock().

> To be clear, the case was where the gup_fast() performing vcpu was
> preempted in the middle of gup_fast(), on wakeup it would perform the
> TLB flush on the virt-enter hook, but meanwhile a sibling vcpu might
> have free'd the page-tables.
>
> By using call_rcu_sched() to free the page-tables you'd need to receive
> and process at least one tick on the woken up cpu after the freeing, but
> since the in-progress gup_fast() will have IRQs disabled this will be
> delayed.

We're now moving the freeing of kvm shadow page tables from using rcu to
using an irq-protected scheme like gup_fast(), because of the
performance differences.  We didn't track it down but I expect the cause
is less reuse of cache-hot pages.

> Anyway, I don't have any idea about the costs involved with
> HAVE_RCU_TABLE_FREE, but I don't think its much.. otherwise these other
> platforms (PPC,SPARC) wouldn't have used it, gup_fast() is a very
> specific case, whereas mmu-gather is something affecting pretty much all
> tasks.

What's changed is not gup_fast() but the performance of munmap(),
exit(), and exec(), no?

What bounds the amount of memory waiting to be freed during an rcu grace
period?

> But mostly my comment was due to you saying modifying gup_fast() would
> be difficult.. I was thinking the one Kconfig line wasn't as onerous ;-)

Yes, you're right - the code is all there and as long as we tolerate the
use of local_irq_disable() in place of rcu_read_lock() no code changes
are needed.

-- 
error compiling committee.c: too many arguments to function

