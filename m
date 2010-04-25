Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0DYJun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab0DYJul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:50:41 -0400
Message-ID: <4BD41063.9010704@redhat.com>
Date: Sun, 25 Apr 2010 12:50:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/10] KVM MMU: split kvm_sync_page() function
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E89C.8090307@cn.fujitsu.com>
In-Reply-To: <4BD3E89C.8090307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 10:00 AM, Xiao Guangrong wrote:
> Split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
> to clarify the code address Avi's suggestion
>
> kvm_sync_page_transient() function only update shadow page but not mark
> it sync and not write protect sp->gfn. it will be used by later patch
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |   17 +++++++++++++++++
>   1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index abf8bd4..60a91c6 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1196,6 +1196,23 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>
>   static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>
> +static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
> +				   struct kvm_mmu_page *sp)
> +{
> +	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
> +		kvm_mmu_zap_page(vcpu->kvm, sp);
> +		return 1;
> +	}
> +
> +	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
> +		kvm_mmu_zap_page(vcpu->kvm, sp);
> +		return 1;
> +	}
> +
> +	kvm_mmu_flush_tlb(vcpu);
> +	return 0;
> +}
> +
>    

This isn't a split; it duplicates the code.

Since there are some parts in the middle of kvm_sync_page() you don't 
want in sync_page_transient(), you can put them into helpers so that 
sync_page and sync_page_transient only call helpers.

-- 
error compiling committee.c: too many arguments to function

