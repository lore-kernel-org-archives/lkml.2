Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2EBVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2EBVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:15:40 -0400
Date: Wed, 2 May 2012 18:10:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120502211031.GB12604@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
 <20120427145213.GB28796@amt.cnet>
 <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
 <4FA0C8A7.9000001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0C8A7.9000001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:39:51PM +0800, Xiao Guangrong wrote:
> On 04/29/2012 04:50 PM, Takuya Yoshikawa wrote:
> 
> > On Fri, 27 Apr 2012 11:52:13 -0300
> > Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > 
> >> Yes but the objective you are aiming for is to read and write sptes
> >> without mmu_lock. That is, i am not talking about this patch. 
> >> Please read carefully the two examples i gave (separated by "example)").
> > 
> > The real objective is not still clear.
> > 
> > The ~10% improvement reported before was on macro benchmarks during live
> > migration.  At least, that optimization was the initial objective.
> > 
> > But at some point, the objective suddenly changed to "lock-less" without
> > understanding what introduced the original improvement.
> > 
> > Was the problem really mmu_lock contention?
> > 
> 
> 
> Takuya, i am so tired to argue the advantage of lockless write-protect
> and lockless O(1) dirty-log again and again.

His point is valid: there is a lack of understanding on the details of
the improvement.

Did you see the pahole output on struct kvm? Apparently mmu_lock is
sharing a cacheline with read-intensive memslots pointer. It would be 
interesting to see what are the effects of cacheline aligning mmu_lock.

> > If the path being introduced by this patch is really fast, isn't it
> > possible to achieve the same improvement still using mmu_lock?
> > 
> > 
> > Note: During live migration, the fact that the guest gets faulted is
> > itself a limitation.  We could easily see noticeable slowdown of a
> > program even if it runs only between two GET_DIRTY_LOGs.
> > 
> 
> 
> Obviously no.
> 
> It depends on what the guest is doing, from my autotest test, it very
> easily to see that, the huge improvement is on bench-migration not
> pure-migration.
> 
> > 
> >> The rules for code under mmu_lock should be:
> >>
> >> 1) Spte updates under mmu lock must always be atomic and 
> >> with locked instructions.
> >> 2) Spte values must be read once, and appropriate action
> >> must be taken when writing them back in case their value 
> >> has changed (remote TLB flush might be required).
> > 
> > Although I am not certain about what will be really needed in the
> > final form, if this kind of maybe-needed-overhead is going to be
> > added little by little, I worry about possible regression.
> 
> 
> Well, will you suggest Linus to reject all patches and stop
> all discussion for the "possible regression" reason?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
