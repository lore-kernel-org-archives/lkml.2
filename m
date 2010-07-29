Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0G2F4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0G2F4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:56:51 -0400
Date: Thu, 29 Jul 2010 08:56:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
Message-ID: <20100729055641.GK31711@redhat.com>
References: <4C3FC033.3000605@cn.fujitsu.com>
 <20100716071936.GE17894@redhat.com>
 <4C50E43A.4020106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C50E43A.4020106@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 10:15:22AM +0800, Lai Jiangshan wrote:
> On 07/16/2010 03:19 PM, Gleb Natapov wrote:
> 
> >> +/* get a current mapped page fast, and test whether the page is writable. */
> >> +static struct page *get_user_page_and_protection(unsigned long addr,
> >> +	int *writable)
> >> +{
> >> +	struct page *page[1];
> >> +
> >> +	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> >> +		*writable = 1;
> >> +		return page[0];
> >> +	}
> >> +	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> >> +		*writable = 0;
> >> +		return page[0];
> >> +	}
> >> +	return NULL;
> >> +}
> >> +
> >> +static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
> >> +		int write_fault, int *host_writable)
> >> +{
> >> +	unsigned long addr;
> >> +	struct page *page;
> >> +
> >> +	if (!write_fault) {
> >> +		addr = gfn_to_hva(kvm, gfn);
> >> +		if (kvm_is_error_hva(addr)) {
> >> +			get_page(bad_page);
> >> +			return page_to_pfn(bad_page);
> >> +		}
> >> +
> >> +		page = get_user_page_and_protection(addr, host_writable);
> >> +		if (page)
> >> +			return page_to_pfn(page);
> >> +	}
> >> +
> >> +	*host_writable = 1;
> >> +	return kvm_get_pfn_for_gfn(kvm, gfn);
> >> +}
> >> +
> > kvm_get_pfn_for_gfn() returns fault_page if page is mapped RO, so caller
> > of kvm_get_pfn_for_page_fault() and kvm_get_pfn_for_gfn() will get
> > different results when called on the same page. Not good.
> > kvm_get_pfn_for_page_fault() logic should be folded into
> > kvm_get_pfn_for_gfn().
> > 
> 
> 
> The different results are the things we just need.
How so? Users of kvm_get_pfn_for_gfn() will think that page is invalid
and may report misconfiguration to userspace and users of
kvm_get_pfn_for_page_fault() will think that the access to page is OK.
There are no many users of kvm_get_pfn_for_gfn() and may be your patch
replace all of them with kvm_get_pfn_for_page_fault(), but this just
strengthen the point that they should be merged.

> We don't want to copy and write a page which is mapped RO when
> only read fault.
I don't see how returning inconsistent results helps us achieving that.

BTW since kvm_get_pfn_for_gfn() will never map RO page
get_user_page_and_protection() will never find any RO pages. Looks like
kvm_get_pfn_for_page_fault() is equivalent to kvm_get_pfn_for_gfn()
since !write_fault section will at best find mapped RW page.

--
			Gleb.
