Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2EAKrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:47:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab2EAKrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:47:42 -0400
Message-ID: <4F9FBF38.2060903@redhat.com>
Date: Tue, 01 May 2012 13:47:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu>  <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com> <1335865176.13683.120.camel@twins>
In-Reply-To: <1335865176.13683.120.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 12:39 PM, Peter Zijlstra wrote:
> On Sun, 2012-04-29 at 15:23 +0300, Avi Kivity wrote:
> > On 04/27/2012 07:24 PM, Nikunj A. Dadhania wrote:
> > > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > > paravirtualization.
> > >
> > > Use the vcpu state information inside the kvm_flush_tlb_others to
> > > avoid sending ipi to pre-empted vcpus.
> > >
> > > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> > 
> > get_user_pages_fast() depends on the IPI to hold off page table teardown
> > while they are locklessly walked with interrupts disabled.  If a vcpu
> > were to be preempted while in this critical section, another vcpu
> > tearing down page tables would go ahead and destroy them.  when the
> > preempted vcpu resumes it then touches the freed pages.
> > 
> > We could try to teach kvm and get_user_pages_fast() about this, but this
> > is intrusive.  Another option is to replace the cpu_relax() loop with
> > something that sleeps and is then woken up by the TLB IPI handler if needed.
>
> I think something like
>
>   select HAVE_RCU_TABLE_FREE if PARAVIRT
>
> or somesuch is just about all it takes.
>
> A slightly better option would be to wrap all that tlb_*table* goo into
> paravirt stuff and only do the RCU free when paravirt is indeed enabled,
> but other than that you're there.

I infer from this that there is a cost involved with rcu freeing.  Any
idea how much?

Looks like this increases performance for the overcommitted case, and
also for the case where many vcpus are sleeping, while reducing
performance for the uncontended, high duty cycle case.

> This should work because the preempted vcpu's RCU state would also be
> stalled and thus avoids the actual page-table from going away.

It can be unstalled at any moment.  But spin_lock_irq() > rcu_read_lock().

-- 
error compiling committee.c: too many arguments to function

