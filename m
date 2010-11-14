Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0KNK4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 05:56:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab0KNK4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 05:56:16 -0500
Message-ID: <4CDFC04A.8010907@redhat.com>
Date: Sun, 14 Nov 2010 12:56:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: notrap it if gpte's reserved is set
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD1841.9010300@cn.fujitsu.com>
In-Reply-To: <4CDD1841.9010300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 12:34 PM, Xiao Guangrong wrote:
> We can past the page fault to guest directly if gpte's reserved
> is set
>

How can that work? shadow_notrap_nonpresent_pte causes a fault with 
PFEC.P=PFEC.RSVD=0, while we need PFEC.P=PFEC.RSVD=1.

> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/paging_tmpl.h |   10 ++++++----
>   1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 291342d..952357a 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -760,6 +760,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   		pt_element_t gpte;
>   		gpa_t pte_gpa;
>   		gfn_t gfn;
> +		bool gpte_invalid;
>
>   		if (!is_shadow_present_pte(sp->spt[i]))
>   			continue;
> @@ -771,12 +772,13 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   			return -EINVAL;
>
>   		gfn = gpte_to_gfn(gpte);
> -		if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)
> -		      || gfn != sp->gfns[i] || !is_present_gpte(gpte)
> -		      || !(gpte&  PT_ACCESSED_MASK)) {
> +		gpte_invalid = is_present_gpte(gpte) ||
> +		   is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL);

Shouldn't that be &&?

> +		if (gpte_invalid || gfn != sp->gfns[i] ||
> +		      !(gpte&  PT_ACCESSED_MASK)) {
>   			u64 nonpresent;
>
> -			if (is_present_gpte(gpte) || !clear_unsync)
> +			if (gpte_invalid || !clear_unsync)
>   				nonpresent = shadow_trap_nonpresent_pte;
>   			else
>   				nonpresent = shadow_notrap_nonpresent_pte;


-- 
error compiling committee.c: too many arguments to function

