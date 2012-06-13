Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2FMXXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2FMXXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:23:52 -0400
Date: Wed, 13 Jun 2012 19:40:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120613224002.GE19290@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
 <4FC471B8.3070204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC471B8.3070204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 02:50:32PM +0800, Xiao Guangrong wrote:
> If the the present bit of page fault error code is set, it indicates
> the shadow page is populated on all levels, it means what we do is
> only modify the access bit which can be done out of mmu-lock
> 
> Currently, in order to simplify the code, we only fix the page fault
> caused by write-protect on the fast path
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 114 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 150c5ad..d6101a8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -445,6 +445,11 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
>  }
>  #endif
> 
> +static bool spte_can_be_writable(u64 spte)
> +{
> +	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
> +}
> +

spte_is_locklessly_modifiable(). Its easy to confuse
"spte_can_be_writable" with different things.

>  static bool spte_has_volatile_bits(u64 spte)
>  {
>  	if (!shadow_accessed_mask)
> @@ -454,7 +459,7 @@ static bool spte_has_volatile_bits(u64 spte)
>  		return false;
> 
>  	if ((spte & shadow_accessed_mask) &&
> -	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
> +	      (!spte_can_be_writable(spte) || (spte & shadow_dirty_mask)))
>  		return false;

mmu_spte_update is handling several different cases. Please rewrite
it, add a comment on top of it (or spread comments on top of each
significant code line) with all cases it is handling (also recheck it
regarding new EPT accessed/dirty bits code).

For one thing, if spte can be updated locklessly the update must be
atomic:

if spte can be locklessly updated
	read-and-modify must be atomic.


