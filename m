Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2GZI4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab2GZI4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:56:21 -0400
Message-ID: <5011062F.3080505@redhat.com>
Date: Thu, 26 Jul 2012 11:56:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: remove dummy pages
References: <5010C008.4030304@linux.vnet.ibm.com> <5010C083.30102@linux.vnet.ibm.com>
In-Reply-To: <5010C083.30102@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 06:58 AM, Xiao Guangrong wrote:
> Currently, kvm allocates some pages and use them as error indicators,
> it wastes memory and is not good for scalability
> 
> Base on Avi's suggestion, we use the error codes instead of these pages
> to indicate the error conditions
> 
> 
> +static pfn_t get_bad_pfn(void)
> +{
> +	return -ENOENT;
> +}
> +
> +pfn_t get_fault_pfn(void)
> +{
> +	return -EFAULT;
> +}
> +EXPORT_SYMBOL_GPL(get_fault_pfn);
> +
> +static pfn_t get_hwpoison_pfn(void)
> +{
> +	return -EHWPOISON;
> +}
> +

Would be better as #defines

>  int is_hwpoison_pfn(pfn_t pfn)
>  {
> -	return pfn == hwpoison_pfn;
> +	return pfn == -EHWPOISON;
>  }
>  EXPORT_SYMBOL_GPL(is_hwpoison_pfn);
> 
>  int is_noslot_pfn(pfn_t pfn)
>  {
> -	return pfn == bad_pfn;
> +	return pfn == -ENOENT;
>  }
>  EXPORT_SYMBOL_GPL(is_noslot_pfn);
> 
>  int is_invalid_pfn(pfn_t pfn)
>  {
> -	return pfn == hwpoison_pfn || pfn == fault_pfn;
> +	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
>  }
>  EXPORT_SYMBOL_GPL(is_invalid_pfn);
> 

So is_*_pfn() could go away and be replaced by ==.

> 
>  EXPORT_SYMBOL_GPL(gfn_to_page);
> 
>  void kvm_release_page_clean(struct page *page)
>  {
> -	kvm_release_pfn_clean(page_to_pfn(page));
> +	if (!is_error_page(page))
> +		kvm_release_pfn_clean(page_to_pfn(page));
>  }
>  EXPORT_SYMBOL_GPL(kvm_release_page_clean);

Note, we can remove calls to kvm_release_page_clean() from error paths
now, so in the future we can drop the test.

Since my comments are better done as a separate patch, I applied all
three patches.  Thanks!

-- 
error compiling committee.c: too many arguments to function


