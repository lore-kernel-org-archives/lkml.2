Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0EJI4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:56:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0EJIz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:55:59 -0400
Message-ID: <4BE7CA19.1030405@redhat.com>
Date: Mon, 10 May 2010 11:55:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH] kvm: calculate correct gfn for small host pages which
 emulates large guest pages
References: <4BD97AC1.8070704@cn.fujitsu.com> <4BDA4342.9070603@cn.fujitsu.com>
In-Reply-To: <4BDA4342.9070603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 05:41 AM, Lai Jiangshan wrote:
> Lai Jiangshan wrote:
>    
>> RFC, because maybe I missing something with the old code.
>>
>> Frome: Lai Jiangshan<laijs@cn.fujitsu.com>
>>
>> In Document/kvm/mmu.txt:
>>    gfn:
>>      Either the guest page table containing the translations shadowed by this
>>      page, or the base page frame for linear translations. See role.direct.
>>
>> But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
>> situations occurred:
>>   1) guest is 32bit paging and guest uses pse-36 and the guest PDE maps
>>      a 4-MByte page(backed by 4k host pages) and bits 20:13 of the guest PDE
>>      is not equals to 0.
>>   2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
>>      (backed by 4k or 2M host pages)
>>
>>      
> Resend this patch with the changelog changed.
>
> As Marcelo Tosatti and Gui Jianfeng points out,
> FNAME(fetch)() miss quadrant on 4mb large page emulation with shadow.
>
> Subject: [PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
>
> In Document/kvm/mmu.txt:
>    gfn:
>      Either the guest page table containing the translations shadowed by this
>      page, or the base page frame for linear translations. See role.direct.
>
> But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
> situations occurred:
>   1) guest is 32bit paging and the guest PDE maps a 4-MByte page
>      (backed by 4k host pages), FNAME(fetch)() miss handling the quadrant.
>
>      And if guest use pse-36, "table_gfn = gpte_to_gfn(gw->ptes[level - delta]);"
>      is incorrect.
>   2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
>      (backed by 4k or 2M host pages).
>
> So we fix it to suit to the document and suit to the code which
> requires sp->gfn correct when sp->role.direct=1.
>
> We use the goal mapping gfn(gw->gfn) to calculate the base page frame
> for linear translations, it is simple and easy to be understood.
>
> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 702c016..958e9c6 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -338,10 +338,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   			direct = 1;
>   			if (!is_dirty_gpte(gw->ptes[level - delta]))
>   				access&= ~ACC_WRITE_MASK;
> -			table_gfn = gpte_to_gfn(gw->ptes[level - delta]);
> -			/* advance table_gfn when emulating 1gb pages with 4k */
> -			if (delta == 0)
> -				table_gfn += PT_INDEX(addr, level);
> +			/*
> +			 * It is a large guest pages backed by small host pages,
> +			 * So we set @direct(@shadow_page->role.direct)=1, and
> +			 * set @table_gfn(@shadow_page->gfn)=the base page frame
> +			 * for linear translations.
> +			 */
> +			table_gfn = gw->gfn&  ~(KVM_PAGES_PER_HPAGE(level) - 1);
>   		} else {
>   			direct = 0;
>   			table_gfn = gw->table_gfn[level - 2];
>    

Looks good, indeed it is a lot easier to understand than the original 
calculation (a minor issue is that the variable name is misleading, but 
that's a problem with kvm_mmu_page definition and not this patch).

-- 
error compiling committee.c: too many arguments to function

