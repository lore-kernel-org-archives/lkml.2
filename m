Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1IMLAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1IMLAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:00:13 -0400
Message-ID: <4E6F37B4.2080405@redhat.com>
Date: Tue, 13 Sep 2011 14:00:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/11] KVM: MMU: cleanup FNAME(invlpg)
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4CA3.6030808@cn.fujitsu.com>
In-Reply-To: <4E5C4CA3.6030808@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:36 AM, Xiao Guangrong wrote:
> Directly Use mmu_page_zap_pte to zap spte in FNAME(invlpg), also remove the
> same code between FNAME(invlpg) and FNAME(sync_page)
>
>
> +static gpa_t FNAME(get_first_pte_gpa)(struct kvm_mmu_page *sp)

spte

> +{
> +	int offset = 0;
> +
> +	if (PTTYPE == 32)
> +		offset = sp->role.quadrant<<  PT64_LEVEL_BITS;
> +
> +	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
> +}

Only works for L1 tables, yes?  Need a comment so it isn't reused for L2.

> @@ -663,7 +673,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>   	gpa_t pte_gpa = -1;
>   	int level;
>   	u64 *sptep;
> -	int need_flush = 0;
>
>   	vcpu_clear_mmio_info(vcpu, gva);
>
> @@ -675,36 +684,20 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>
>   		sp = page_header(__pa(sptep));
>   		if (is_last_spte(*sptep, level)) {
> -			int offset, shift;
> -
>   			if (!sp->unsync)
>   				break;
>
> -			shift = PAGE_SHIFT -
> -				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
> -			offset = sp->role.quadrant<<  shift;
> -
> -			pte_gpa = (sp->gfn<<  PAGE_SHIFT) + offset;
> +			pte_gpa = FNAME(get_first_pte_gpa)(sp);


Here is can be used for L2 - I think we can use 2MB host pages to back 
4MB guest mappings.



-- 
error compiling committee.c: too many arguments to function

