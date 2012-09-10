Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2IJIWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2IJIWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:22:31 -0400
Message-ID: <504DA343.9080602@redhat.com>
Date: Mon, 10 Sep 2012 11:22:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: MMU: release noslot pfn on the fail path properly
References: <5049908A.7070501@linux.vnet.ibm.com>
In-Reply-To: <5049908A.7070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 09:13 AM, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte
> 
> Introduce mmu_release_pfn_clean to do this kind of thing
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   19 ++++++++++++++-----
>  arch/x86/kvm/paging_tmpl.h |    4 ++--
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 399c177..3c10bca 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2432,6 +2432,16 @@ done:
>  	return ret;
>  }
> 
> +/*
> + * The primary user is page fault path which call it to properly
> + * release noslot_pfn.
> + */
> +static void mmu_release_pfn_clean(pfn_t pfn)
> +{
> +	if (!is_error_pfn(pfn))
> +		kvm_release_pfn_clean(pfn);
> +}
> +

Too many APIs, each slightly different.  How do I know which one to call?

Please change kvm_release_pfn_*() instead, calling some arch hook (or
even #ifdef CONFIG_KVM_HAS_FAST_MMIO) to check for the special case.




-- 
error compiling committee.c: too many arguments to function
