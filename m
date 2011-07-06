Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1GFRj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab1GFRj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:39:26 -0400
Date: Wed, 6 Jul 2011 14:39:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] KVM: MMU: clean up spte updating and clearing
Message-ID: <20110706173911.GA9820@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C32FE.2020805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C32FE.2020805@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:25:34PM +0800, Xiao Guangrong wrote:
> Clean up the code between mmu_spte_clear_* and mmu_spte_update
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   75 +++++++++++++++++++++++++++-------------------------
>  1 files changed, 39 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 48c0a45..857d0d6 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -279,24 +279,51 @@ static u64 __xchg_spte(u64 *sptep, u64 new_spte)
>  #endif
>  }
>  
> -static bool spte_has_volatile_bits(u64 spte)
> +static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
> +{
> +	return (old_spte & bit_mask) && !(new_spte & bit_mask);
> +}
> +
> +static bool spte_has_volatile_bits(u64 spte, u64 keep_bits)
>  {
> +	bool access_nonvolatile = false, dirty_nonvolatile = false;
> +
>  	if (!shadow_accessed_mask)
>  		return false;
>  
> -	if (!is_shadow_present_pte(spte))
> -		return false;
> +	if ((spte | keep_bits) & shadow_accessed_mask)
> +		access_nonvolatile = true;
> +
> +	if (!is_writable_pte(spte) || ((spte | keep_bits) & shadow_dirty_mask))
> +		dirty_nonvolatile = true;
>  
> -	if ((spte & shadow_accessed_mask) &&
> -	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
> +	if (access_nonvolatile && dirty_nonvolatile)
>  		return false;
>  
>  	return true;
>  }
>  
> -static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
> +static void track_spte_bits(u64 old_spte, u64 keep_bits, bool always_track)
>  {
> -	return (old_spte & bit_mask) && !(new_spte & bit_mask);
> +	if (always_track ||
> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_accessed_mask)))
> +		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +
> +	if (always_track ||
> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_dirty_mask)))
> +		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +}

This is much more confusing than previously, please drop it.

