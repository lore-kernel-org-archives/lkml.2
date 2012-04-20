Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2DUAMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:12:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab2DUAMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:12:37 -0400
Date: Fri, 20 Apr 2012 18:52:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
Message-ID: <20120420215211.GC13817@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911C05.2070701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F911C05.2070701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:19:17PM +0800, Xiao Guangrong wrote:
> If this bit is set, it means the W bit of the spte is cleared due
> to shadow page table protection
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   56 ++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index dd984b6..eb02fc4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -147,6 +147,7 @@ module_param(dbg, bool, 0644);
> 
>  #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
>  #define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
> +#define SPTE_WRITE_PROTECT	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 2))
> 
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> 
> @@ -1042,36 +1043,51 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
> 
> +static bool spte_wp_by_dirty_log(u64 spte)
> +{
> +	WARN_ON(is_writable_pte(spte));
> +
> +	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
> +}

Is the information accurate? Say:

- dirty log write protect, set SPTE_ALLOW_WRITE, clear WRITABLE.
- shadow gfn, rmap_write_protect finds page not WRITABLE.
- spte points to shadow gfn, but SPTE_WRITE_PROTECT is not set.

BTW,

"introduce SPTE_ALLOW_WRITE bit

This bit indicates whether the spte is allow to be writable that
means the gpte of this spte is writable and the pfn pointed by
this spte is writable on host"

Other than the fact that each bit should have one meaning, how
can this bit be accurate without write protection of the gpte?

As soon as guest writes to gpte, information in bit is outdated.

