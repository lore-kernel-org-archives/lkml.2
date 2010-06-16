Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab0FPPZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:25:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34981 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab0FPPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:25:15 -0400
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4C189830.2070300@redhat.com>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135530.4565745D@kernel.beaverton.ibm.com>
	 <4C189830.2070300@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 08:25:11 -0700
Message-Id: <1276701911.6437.16973.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 12:24 +0300, Avi Kivity wrote:
> On 06/15/2010 04:55 PM, Dave Hansen wrote:
> > In a previous patch, we removed the 'nr_to_scan' tracking.
> > It was not being used to track the number of objects
> > scanned, so we stopped using it entirely.  Here, we
> > strart using it again.
> >
> > The theory here is simple; if we already have the refcount
> > and the kvm->mmu_lock, then we should do as much work as
> > possible under the lock.  The downside is that we're less
> > fair about the KVM instances from which we reclaim.  Each
> > call to mmu_shrink() will tend to "pick on" one instance,
> > after which it gets moved to the end of the list and left
> > alone for a while.
> >    
> 
> That also increases the latency hit, as well as a potential fault storm, 
> on that instance.  Spreading out is less efficient, but smoother.

This is probably something that we need to go back and actually measure.
My suspicion is that, when memory fills up and this shrinker is getting
called a lot, it will be naturally fair.  That list gets shuffled around
enough, and mmu_shrink() called often enough that no VMs get picked on
too unfairly.

I'll go back and see if I can quantify this a bit, though.

I do worry about the case where you really have only a single CPU going
into reclaim and a very small number of VMs on the system.  You're
basically guaranteeing that you'll throw away nr_to_scan of the poor
victim VM's, with no penalty on the other guy.  

> > If mmu_shrink() has already done a significant amount of
> > scanning, the use of 'nr_to_scan' inside shrink_kvm_mmu()
> > will also ensure that we do not over-reclaim when we have
> > already done a lot of work in this call.
> >
> > In the end, this patch defines a "scan" as:
> > 1. An attempt to acquire a refcount on a 'struct kvm'
> > 2. freeing a kvm mmu page
> >
> > This would probably be most ideal if we can expose some
> > of the work done by kvm_mmu_remove_some_alloc_mmu_pages()
> > as also counting as scanning, but I think we have churned
> > enough for the moment.
> 
> It usually removes one page.

Does it always just go right now and free it, or is there any real
scanning that has to go on?

> > diff -puN arch/x86/kvm/mmu.c~make-shrinker-more-aggressive arch/x86/kvm/mmu.c
> > --- linux-2.6.git/arch/x86/kvm/mmu.c~make-shrinker-more-aggressive	2010-06-14 11:30:44.000000000 -0700
> > +++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-14 11:38:04.000000000 -0700
> > @@ -2935,8 +2935,10 @@ static int shrink_kvm_mmu(struct kvm *kv
> >
> >   	idx = srcu_read_lock(&kvm->srcu);
> >   	spin_lock(&kvm->mmu_lock);
> > -	if (kvm->arch.n_used_mmu_pages>  0)
> > -		freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
> > +	while (nr_to_scan>  0&&  kvm->arch.n_used_mmu_pages>  0) {
> > +		freed_pages += kvm_mmu_remove_some_alloc_mmu_pages(kvm);
> > +		nr_to_scan--;
> > +	}
> >    
> 
> What tree are you patching?

These applied to Linus's latest as of yesterday.

-- Dave

