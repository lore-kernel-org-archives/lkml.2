Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0JFOyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab0JFOyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:54:05 -0400
Date: Wed, 6 Oct 2010 11:38:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        cl@linux-foundation.org
Subject: Re: [PATCH v6 04/12] Add memory slot versioning and use it to
 provide fast guest write interface
Message-ID: <20101006143847.GB31423@amt.cnet>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-5-git-send-email-gleb@redhat.com>
 <20101005165738.GA32750@amt.cnet>
 <20101006111417.GX11145@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006111417.GX11145@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 01:14:17PM +0200, Gleb Natapov wrote:
> > > +int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
> > > +			      gpa_t gpa)
> > > +{
> > > +	struct kvm_memslots *slots = kvm_memslots(kvm);
> > > +	int offset = offset_in_page(gpa);
> > > +	gfn_t gfn = gpa >> PAGE_SHIFT;
> > > +
> > > +	ghc->gpa = gpa;
> > > +	ghc->generation = slots->generation;

kvm->memslots can change here.

> > > +	ghc->memslot = gfn_to_memslot(kvm, gfn);
> > > +	ghc->hva = gfn_to_hva(kvm, gfn);

And if so, gfn_to_memslot / gfn_to_hva will use new memslots pointer.

Should dereference all values from one copy of kvm->memslots pointer.
 
> > > +	if (!kvm_is_error_hva(ghc->hva))
> > > +		ghc->hva += offset;
> > > +	else
> > > +		return -EFAULT;
> > > +
> > > +	return 0;
> > > +}
> > 
> > Should use a unique kvm_memslots structure for the cache entry, since it
> > can change in between (use gfn_to_hva_memslot, etc on "slots" pointer).
> > 
> I do not understand what do you mean here. kvm_memslots structure itself
> is not cached only various translation that use it are cached. Translation
> result are never used if kvm_memslots was changed.

> > Also should zap any cached entries on overflow, otherwise malicious
> > userspace could make use of stale slots:
> > 
> There is only one cached entry at each given time. User who wants to
> write into guest memory often defines gfn_to_hva_cache variable
> somewhere. Init it with kvm_gfn_to_hva_cache_init() and then calls
> kvm_write_guest_cached() on it. If there was no slot changes in between
> cached translation are used. Otherwise cache is recalculated.

Malicious userspace can cause entry to be cached, ioctl
SET_USER_MEMORY_REGION 2^32 times, generation number will match,
mark_page_dirty_in_slot will be called with pointer to freed memory.

