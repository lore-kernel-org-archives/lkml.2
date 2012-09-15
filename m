Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2IOPlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab2IOPlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:41:20 -0400
Date: Sat, 15 Sep 2012 12:13:38 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: MMU: release noslot pfn on the fail path
 properly
Message-ID: <20120915151338.GA3037@amt.cnet>
References: <5052FF61.3070600@linux.vnet.ibm.com>
 <5052FF82.1060106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052FF82.1060106@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 05:57:22PM +0800, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |    6 ++++--
>  arch/x86/kvm/paging_tmpl.h |    6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)

Its clearer to the reader if is_invalid_pfn() is used instead of 
is_error_pfn.

BTW how about killing this unused helper

static bool mmu_invalid_pfn(pfn_t pfn)
{
        return unlikely(is_invalid_pfn(pfn));
}

This can be done inlined.

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index aa0b469..f74c63a 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2877,7 +2877,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
> 
>  out_unlock:
>  	spin_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (!is_error_pfn(pfn))
> +		kvm_release_pfn_clean(pfn);
>  	return 0;
>  }

