Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0D0Mho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0D0Mhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:37:42 -0400
Message-ID: <4BD6DA94.7050501@redhat.com>
Date: Tue, 27 Apr 2010 15:37:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/22] KVM: MMU: Implement nested gva_to_gpa functions
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-13-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-13-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch adds the functions to do a nested l2_gva to
> l1_gpa page table walk.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    4 ++++
>   arch/x86/kvm/mmu.c              |    8 ++++++++
>   arch/x86/kvm/paging_tmpl.h      |   31 +++++++++++++++++++++++++++++++
>   3 files changed, 43 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ccdbd2f..3cbfb51 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -287,6 +287,10 @@ struct kvm_vcpu_arch {
>   	bool tpr_access_reporting;
>
>   	struct kvm_mmu mmu;
> +
> +	/* Used for two dimensional paging emulation */
> +	struct kvm_mmu nested_mmu;
> +
>   	/* only needed in kvm_pv_mmu_op() path, but it's hot so
>   	 * put it here to avoid allocation */
>   	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4e0bfdb..8bd40b5 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2144,6 +2144,14 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
>   	return vaddr;
>   }
>
> +static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
> +					 u32 access, u32 *error)
> +{
> +	if (error)
> +		*error = 0;
>    

Why allow error == NULL?

>
> +static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
> +				      u32 access, u32 *error)
> +{
> +	struct guest_walker walker;
> +	gpa_t gpa = UNMAPPED_GVA;
> +	int r;
> +
> +	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr,
> +				    !!(access&  PFERR_WRITE_MASK),
> +				    !!(access&  PFERR_USER_MASK),
> +				    !!(access&  PFERR_FETCH_MASK));
>    

Those !! are unneeded.


-- 
error compiling committee.c: too many arguments to function

