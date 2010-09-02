Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0IBP4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0IBP4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:56:13 -0400
Message-ID: <4C7FC91A.5030305@redhat.com>
Date: Thu, 02 Sep 2010 18:56:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: MMU: Fix 32 bit legacy paging with NPT
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com> <1283441387-7378-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1283441387-7378-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 06:29 PM, Joerg Roedel wrote:
> This patch fixes 32 bit legacy paging with NPT enabled. The
> mmu_check_root call on the top-level of the loop causes
> root_gfn to take values (in the tdp_enabled path) which are
> outside of guest memory. So the mmu_check_root call fails at
> some point in the loop interation causing the guest to
> tiple-fault.
> This patch changes the mmu_check_root calls to the places
> where they are really necessary. As a side-effect it
> introduces a check for the root of a pae page table too.
>
>
> @@ -2387,6 +2387,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
>   		return 0;
>   	}
>   	direct = !is_paging(vcpu);
> +
> +	if (mmu_check_root(vcpu, root_gfn))
> +		return 1;
> +
>   	for (i = 0; i<  4; ++i) {
>   		hpa_t root = vcpu->arch.mmu.pae_root[i];
>
> @@ -2398,10 +2402,10 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
>   				continue;
>   			}
>   			root_gfn = pdptr>>  PAGE_SHIFT;
> +			if (mmu_check_root(vcpu, root_gfn))
> +				return 1;
>   		} else if (vcpu->arch.mmu.root_level == 0)
>   			root_gfn = 0;
> -		if (mmu_check_root(vcpu, root_gfn))
> -			return 1;
>   		if (tdp_enabled) {
>   			direct = 1;
>   			root_gfn = i<<  30;

The overloading of root_gfn is pretty bad.  Also, we don't really need 
to check root_gfn for the direct case (the guest can easily switch cr3 
later to one that would fail the check).

However, I'll apply the patch since it fixes the direct problem.  More 
involved fixes can come later (esp. after the nnpt patches land).


-- 
error compiling committee.c: too many arguments to function

