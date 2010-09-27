Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab0I0Oac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab0I0Oab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:30:31 -0400
Message-ID: <4CA0AA7E.4090901@redhat.com>
Date: Mon, 27 Sep 2010 16:30:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: MMU: cleanup for error mask set while walk guest
 page table
References: <4CA06BA4.4090303@cn.fujitsu.com> <4CA06BEF.7060401@cn.fujitsu.com>
In-Reply-To: <4CA06BEF.7060401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 12:03 PM, Xiao Guangrong wrote:
> Small cleanup for set page fault error code
>
> Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/paging_tmpl.h |   17 +++++++----------
>   1 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 2bdd843..a83ff37 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -224,9 +224,7 @@ walk:
>   			    is_cpuid_PSE36())
>   				gfn += pse36_gfn_delta(pte);
>
> -			access |= write_fault ? PFERR_WRITE_MASK : 0;
> -			access |= fetch_fault ? PFERR_FETCH_MASK : 0;
> -			access |= user_fault  ? PFERR_USER_MASK  : 0;
> +			access |= write_fault | fetch_fault | user_fault;
>
>   			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
>   						      access);
> @@ -268,10 +266,9 @@ error:
>   	walker->error_code = 0;
>   	if (present)
>   		walker->error_code |= PFERR_PRESENT_MASK;
> -	if (write_fault)
> -		walker->error_code |= PFERR_WRITE_MASK;
> -	if (user_fault)
> -		walker->error_code |= PFERR_USER_MASK;
> +
> +	walker->error_code |= write_fault | user_fault;
> +
>   	if (fetch_fault&&  mmu->nx)
>   		walker->error_code |= PFERR_FETCH_MASK;
>   	if (rsvd_fault)
> @@ -673,9 +670,9 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
>   	int r;
>
>   	r = FNAME(walk_addr)(&walker, vcpu, vaddr,
> -			     !!(access&  PFERR_WRITE_MASK),
> -			     !!(access&  PFERR_USER_MASK),
> -			     !!(access&  PFERR_FETCH_MASK));
> +			     access&  PFERR_WRITE_MASK,
> +			     access&  PFERR_USER_MASK,
> +			     access&  PFERR_FETCH_MASK);
>
>   	if (r) {
>   		gpa = gfn_to_gpa(walker.gfn);

Interesting.  Maybe a next step is to pass the page-fault error code 
instead of the various bits?  Not sure how that interacts with nested 
ept (which has a different permission model).


-- 
error compiling committee.c: too many arguments to function

