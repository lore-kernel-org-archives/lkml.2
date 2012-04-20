Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2DUAMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2DUAMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:12:37 -0400
Date: Fri, 20 Apr 2012 18:33:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
Message-ID: <20120420213319.GA13817@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911BAB.6000206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F911BAB.6000206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:17:47PM +0800, Xiao Guangrong wrote:
> Introduce a common function to abstract spte write-protect to
> cleanup the code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   60 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4a3cc18..e70ff38 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1041,6 +1041,34 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
> 
> +/* Return true if the spte is dropped. */
> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
> +			       bool *flush)
> +{
> +	u64 spte = *sptep;
> +
> +	if (!is_writable_pte(spte))
> +		return false;
> +
> +	*flush |= true;
> +
> +	if (large) {
> +		pgprintk("rmap_write_protect(large): spte %p %llx\n",
> +			 spte, *spte);
> +		BUG_ON(!is_large_pte(spte));
> +
> +		drop_spte(kvm, sptep);
> +		--kvm->stat.lpages;
> +		return true;
> +	}
> +
> +	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
> +	spte = spte & ~PT_WRITABLE_MASK;
> +	mmu_spte_update(sptep, spte);
> +
> +	return false;
> +}
> +
>  static bool
>  __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
>  {
> @@ -1050,24 +1078,13 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
> 
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> -		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> -
> -		if (!is_writable_pte(*sptep)) {
> -			sptep = rmap_get_next(&iter);
> -			continue;
> -		}
> -
> -		if (level == PT_PAGE_TABLE_LEVEL) {
> -			mmu_spte_update(sptep, *sptep & ~PT_WRITABLE_MASK);
> -			sptep = rmap_get_next(&iter);
> -		} else {
> -			BUG_ON(!is_large_pte(*sptep));
> -			drop_spte(kvm, sptep);
> -			--kvm->stat.lpages;

It is preferable to remove all large sptes including read-only ones, the
current behaviour, then to verify that no read->write transition can
occur in fault paths (fault paths which are increasing in number).

