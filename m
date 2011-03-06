Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1CFM2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:28:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab1CFM2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:28:37 -0500
Message-ID: <4D737DEE.2050402@redhat.com>
Date: Sun, 06 Mar 2011 14:28:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/10] KVM: MMU: introduce a common function to get no-dirty-logged
 slot
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C657.4030105@cn.fujitsu.com>
In-Reply-To: <4D70C657.4030105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 01:00 PM, Xiao Guangrong wrote:
> pte_prefetch_gfn_to_memslot and mapping_level_dirty_bitmap have the same
> operation, so integrated
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |   26 ++++++++++++++++++--------
>   1 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cd35e71..8acb8e3 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -554,13 +554,24 @@ static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
>   	return ret;
>   }
>
> -static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
> +static struct kvm_memory_slot *
> +gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
>   {
>   	struct kvm_memory_slot *slot;
> -	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
> -	if (slot&&  slot->dirty_bitmap)
> -		return true;
> -	return false;
> +
> +	slot = gfn_to_memslot(vcpu->kvm, gfn);
> +	if (!slot)
> +		return NULL;
> +
> +	if (no_dirty_log&&  slot->dirty_bitmap)
> +		return NULL;
> +
> +	return slot;
> +}
> +
> +static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
> +{
> +	return !!gfn_to_memslot_dirty_bitmap(vcpu, large_gfn, true);
>   }

!! !needed.

>
>   static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
> @@ -2155,9 +2166,8 @@ pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
>   {
>   	struct kvm_memory_slot *slot;
>
> -	slot = gfn_to_memslot(vcpu->kvm, gfn);
> -	if (!slot || slot->flags&  KVM_MEMSLOT_INVALID ||
> -	      (no_dirty_log&&  slot->dirty_bitmap))
> +	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
> +	if (slot&&  slot->flags&  KVM_MEMSLOT_INVALID)
>   		slot = NULL;
>
>   	return slot;

For a unification this adds a lot of code... I think the result is more 
complicated than the starting point.

-- 
error compiling committee.c: too many arguments to function

