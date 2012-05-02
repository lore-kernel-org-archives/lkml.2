Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2EBIv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:51:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50789 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab2EBIvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:51:54 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Cc: mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <1335865176.13683.120.camel@twins>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com> <1335865176.13683.120.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Wed, 02 May 2012 14:21:14 +0530
Message-ID: <87obq7ge4d.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12050122-5140-0000-0000-0000012A9A7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2012 11:39:36 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
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
[root@krm1 linux]# grep HAVE_RCU_TABLE .config
CONFIG_HAVE_RCU_TABLE_FREE=y
[root@krm1 linux]# make -j32  -s
mm/memory.c: In function ‘tlb_remove_table_one’:
mm/memory.c:315: error: implicit declaration of function ‘__tlb_remove_table’

I suppose we need to have __tlb_remove_table. Trying to understand what
needs to be done there.

Regards
Nikunj

