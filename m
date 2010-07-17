Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab0GQEbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 00:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0GQEbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 00:31:34 -0400
Date: Sat, 17 Jul 2010 07:31:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
Message-ID: <20100717043124.GA24480@redhat.com>
References: <4C3FC033.3000605@cn.fujitsu.com>
 <20100716071936.GE17894@redhat.com>
 <20100716232612.GB8946@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716232612.GB8946@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 08:26:12PM -0300, Marcelo Tosatti wrote:
> On Fri, Jul 16, 2010 at 10:19:36AM +0300, Gleb Natapov wrote:
> > On Fri, Jul 16, 2010 at 10:13:07AM +0800, Lai Jiangshan wrote:
> > > When page fault, we always call get_user_pages(write=1).
> > > 
> > > Actually, we don't need to do this when it is not write fault.
> > > get_user_pages(write=1) will cause shared page(ksm) copied.
> > > If this page is not modified in future, this copying and the copied page
> > > are just wasted. Ksm may scan and merge them and may cause thrash.
> > > 
> > But is page is written into afterwords we will get another page fault.
> > 
> > > In this patch, if the page is RO for host VMM and it not write fault for guest,
> > > we will use RO page, otherwise we use a writable page.
> > > 
> > Currently pages allocated for guest memory are required to be RW, so after your series
> > behaviour will remain exactly the same as before.
> 
> Except KSM pages.
> 
KSM page will be COWed by __get_user_pages_fast(addr, 1, 1, page) in
get_user_page_and_protection() just like it COWed now, no?
 
> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > ---
> > > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > > index 8ba9b0d..6382140 100644
> > > --- a/arch/x86/kvm/mmu.c
> > > +++ b/arch/x86/kvm/mmu.c
> > > @@ -1832,6 +1832,45 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
> > >  	}
> > >  }
> > >  
> > > +/* get a current mapped page fast, and test whether the page is writable. */
> > > +static struct page *get_user_page_and_protection(unsigned long addr,
> > > +	int *writable)
> > > +{
> > > +	struct page *page[1];
> > > +
> > > +	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> > > +		*writable = 1;
> > > +		return page[0];
> > > +	}
> > > +	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> > > +		*writable = 0;
> > > +		return page[0];
> > > +	}
> > > +	return NULL;
> > > +}
> > > +
> > > +static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
> > > +		int write_fault, int *host_writable)
> > > +{
> > > +	unsigned long addr;
> > > +	struct page *page;
> > > +
> > > +	if (!write_fault) {
> > > +		addr = gfn_to_hva(kvm, gfn);
> > > +		if (kvm_is_error_hva(addr)) {
> > > +			get_page(bad_page);
> > > +			return page_to_pfn(bad_page);
> > > +		}
> > > +
> > > +		page = get_user_page_and_protection(addr, host_writable);
> > > +		if (page)
> > > +			return page_to_pfn(page);
> > > +	}
> > > +
> > > +	*host_writable = 1;
> > > +	return kvm_get_pfn_for_gfn(kvm, gfn);
> > > +}
> > > +
> > kvm_get_pfn_for_gfn() returns fault_page if page is mapped RO, so caller
> > of kvm_get_pfn_for_page_fault() and kvm_get_pfn_for_gfn() will get
> > different results when called on the same page. Not good.
> > kvm_get_pfn_for_page_fault() logic should be folded into
> > kvm_get_pfn_for_gfn().
> 
> Agreed. Please keep gfn_to_pfn related code in virt/kvm/kvm_main.c.

--
			Gleb.
