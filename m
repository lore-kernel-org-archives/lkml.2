Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2GSKPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab2GSKPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:15:11 -0400
Message-ID: <5007DE28.2080305@redhat.com>
Date: Thu, 19 Jul 2012 13:15:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/10] KVM: introduce readonly_fault_pfn
References: <5005791B.8040807@linux.vnet.ibm.com> <50057A49.8070400@linux.vnet.ibm.com>
In-Reply-To: <50057A49.8070400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 05:44 PM, Xiao Guangrong wrote:
> Introduce readonly_fault_pfn, in the later patch, it indicates failure
> when we try to get a writable pfn from the readonly memslot
> 
> +
>  inline int kvm_is_mmio_pfn(pfn_t pfn)
>  {
>  	if (pfn_valid(pfn)) {
> @@ -949,13 +952,15 @@ EXPORT_SYMBOL_GPL(kvm_disable_largepages);
> 
>  int is_error_page(struct page *page)
>  {
> -	return page == bad_page || page == hwpoison_page || page == fault_page;
> +	return page == bad_page || page == hwpoison_page || page == fault_page
> +		|| page == readonly_fault_page;

All those checks are slow, and get_page(fault_page) etc. isn't very
scalable.

We should move to ERR_PTR() etc.  We could use ENOENT, EHWPOISON,
EFAULT, and EROFS for the above, or maybe there are better matches.

>  }
>  EXPORT_SYMBOL_GPL(is_error_page);
> 
>  int is_error_pfn(pfn_t pfn)
>  {
> -	return pfn == bad_pfn || pfn == hwpoison_pfn || pfn == fault_pfn;
> +	return pfn == bad_pfn || pfn == hwpoison_pfn || pfn == fault_pfn
> +		|| pfn == readonly_fault_pfn;
>  }

And a similar change here.
-- 
error compiling committee.c: too many arguments to function


