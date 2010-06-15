Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0FOLWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450Ab0FOLWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:22:14 -0400
Message-ID: <4C17625E.3020308@redhat.com>
Date: Tue, 15 Jun 2010 14:22:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com>
In-Reply-To: <4C16E999.6050004@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 05:46 AM, Xiao Guangrong wrote:
> Introduce gfn_to_page_atomic() and gfn_to_pfn_atomic(), those
> functions is fast path and can used in atomic context, the later
> patch will use those
>
>
> @@ -942,6 +942,41 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_hva);
>
> +static pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
> +{
> +	struct page *page[1];
> +	int npages;
> +	pfn_t pfn;
> +
> +	npages = __get_user_pages_fast(addr, 1, 1, page);
> +
> +	if (unlikely(npages != 1)) {
> +		if (is_hwpoison_address(addr)) {
> +			get_page(hwpoison_page);
> +			return page_to_pfn(hwpoison_page);
> +		}
> +		get_page(bad_page);
> +		return page_to_pfn(bad_page);
> +	} else
> +		pfn = page_to_pfn(page[0]);
> +
> +	return pfn;
> +}
>    

Too much duplication.  How about putting the tail end of the function in 
a common helper (with an inatomic flag)?

btw, is_hwpoison_address() is racy.  While it looks up the address, some 
other task can unmap the page tables under us.

Andi/Huang?

One way of fixing it is get_user_pages_ptes_fast(), which also returns 
the pte, also atomically.  I want it for other reasons as well (respond 
to a read fault by gupping the page for read, but allowing write access 
if the pte indicates it is writeable).


-- 
error compiling committee.c: too many arguments to function

