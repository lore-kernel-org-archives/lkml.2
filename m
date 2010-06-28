Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0F1JvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0F1JvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:51:01 -0400
Message-ID: <4C287081.40300@redhat.com>
Date: Mon, 28 Jun 2010 12:50:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com>
In-Reply-To: <4C249BAD.6000609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:06 PM, Xiao Guangrong wrote:
> Consider using small page to fit guest's large page mapping:
>
> If the mapping is writable but the dirty flag is not set, we will find
> the read-only direct sp and setup the mapping, then if the write #PF
> occur, we will mark this mapping writable in the read-only direct sp,
> now, other real read-only mapping will happily write it without #PF.
>
> It may hurt guest's COW
>
> Fixed by re-install the mapping when write #PF occur.
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |    3 ++-
>   arch/x86/kvm/paging_tmpl.h |   18 ++++++++++++++++++
>   2 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 556a798..0412ba4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -153,7 +153,8 @@ module_param(oos_shadow, bool, 0644);
>   #define CREATE_TRACE_POINTS
>   #include "mmutrace.h"
>
> -#define SPTE_HOST_WRITEABLE (1ULL<<  PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_HOST_WRITEABLE	(1ULL<<  PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_NO_DIRTY		(2ULL<<  PT_FIRST_AVAIL_BITS_SHIFT)
>
>   #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index e46eb8a..fdba751 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -325,6 +325,20 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   			break;
>   		}
>
> +		if (*sptep&  SPTE_NO_DIRTY) {
> +			struct kvm_mmu_page *child;
> +
> +			WARN_ON(level !=  gw->level);
> +			WARN_ON(!is_shadow_present_pte(*sptep));
> +			if (dirty) {
> +				child = page_header(*sptep&
> +						      PT64_BASE_ADDR_MASK);
> +				mmu_page_remove_parent_pte(child, sptep);
> +				__set_spte(sptep, shadow_trap_nonpresent_pte);
> +				kvm_flush_remote_tlbs(vcpu->kvm);
> +			}
> +		}
> +
>    

Instead of adding a new bit, can you encode the protection in the direct 
sp's access bits?  So we'll have one sp for read-only or 
writeable-but-not-dirty small pages, and another sp for 
writeable-and-dirty small pages.

-- 
error compiling committee.c: too many arguments to function

