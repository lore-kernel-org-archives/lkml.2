Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab0FPPGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:06:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34776 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab0FPPGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:06:08 -0400
Subject: Re: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages
 value
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4C188FC0.3050306@redhat.com>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135523.25D24A73@kernel.beaverton.ibm.com>
	 <4C188FC0.3050306@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 08:06:01 -0700
Message-Id: <1276700761.6437.16878.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 11:48 +0300, Avi Kivity wrote:
> On 06/15/2010 04:55 PM, Dave Hansen wrote:
> > +/*
> > + * This value is the sum of all of the kvm instances's
> > + * kvm->arch.n_used_mmu_pages values.  We need a global,
> > + * aggregate version in order to make the slab shrinker
> > + * faster
> > + */
> > +static unsigned int kvm_total_used_mmu_pages;
> >    
> 
> The variable needs to be at the top of the file.

Gotcha, will do.

> > +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> > +{
> > +	kvm->arch.n_used_mmu_pages += nr;
> > +	kvm_total_used_mmu_pages += nr;
> >    
> 
> Needs an atomic operation, since there's no global lock here.  To avoid 
> bouncing this cacheline around, make the variable percpu and make 
> readers take a sum across all cpus.  Side benefit is that you no longer 
> need an atomic but a local_t, which is considerably cheaper.

That's a good point.  All of the modifications are done under locks, but
the fast path isn't any more.  I'll fix it up.

-- Dave

