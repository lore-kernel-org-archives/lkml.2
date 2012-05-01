Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2EADe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 23:34:58 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36725 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2EADe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 23:34:56 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <4F9D32B4.8040002@redhat.com>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 01 May 2012 09:04:22 +0530
Message-ID: <87vckgh8w1.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12043017-5140-0000-0000-00000128CD34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2012 15:23:16 +0300, Avi Kivity <avi@redhat.com> wrote:
> On 04/27/2012 07:24 PM, Nikunj A. Dadhania wrote:
> > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > paravirtualization.
> >
> > Use the vcpu state information inside the kvm_flush_tlb_others to
> > avoid sending ipi to pre-empted vcpus.
> >
> > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> 
> get_user_pages_fast() depends on the IPI to hold off page table teardown
> while they are locklessly walked with interrupts disabled.  If a vcpu
> were to be preempted while in this critical section, another vcpu
> tearing down page tables would go ahead and destroy them.  when the
> preempted vcpu resumes it then touches the freed pages.
> 
> We could try to teach kvm and get_user_pages_fast() about this, but this
> is intrusive. 


> Another option is to replace the cpu_relax() loop with
> something that sleeps and is then woken up by the TLB IPI handler if needed.
> 
That was the initial implementation that I did. Where we were not
looking for sleeping vcpus, just send IPIs to affected vcpus and execute
halt. One of the vcpu that sees the flushmask as empty would generate
the kick to the halted vcpu. I can respin my patches with just this as
well.

Regards
Nikunj

