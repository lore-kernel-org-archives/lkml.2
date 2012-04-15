Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2DOPQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab2DOPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:16:35 -0400
Message-ID: <4F8AE64F.7080909@redhat.com>
Date: Sun, 15 Apr 2012 18:16:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com>
In-Reply-To: <4F87FC82.2050302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 01:14 PM, Xiao Guangrong wrote:
> Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
> to avoid unnecessary shadow page walking
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0c6e92d..8b71908 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>  	return level - 1;
>  }
>
> -#define PTE_LIST_DESC		(0x1ull)
> +#define PTE_LIST_DESC_BIT	0
> +#define PTE_LIST_WP_BIT	1
> +#define PTE_LIST_DESC		(1 << PTE_LIST_DESC_BIT)
>  #define PTE_LIST_FLAG_MASK	(0x3ull)
>
>  static void
> @@ -1067,6 +1069,12 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
>  	return mmu_memory_cache_free_objects(cache);
>  }
>
> +static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
> +{
> +	if (!(*spte & SPTE_HOST_WRITEABLE))
> +		__test_and_set_bit(PTE_LIST_WP_BIT, rmapp);
> +}
>

Why is this needed, in addition to spte.SPTE_WRITE_PROTECT?

-- 
error compiling committee.c: too many arguments to function

