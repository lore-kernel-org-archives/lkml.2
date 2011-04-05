Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1DEIez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1DEIew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:34:52 -0400
Message-ID: <4D9AD423.6060503@redhat.com>
Date: Tue, 05 Apr 2011 11:34:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4D8FF287.1040300@cn.fujitsu.com> <4D8FF2D2.9070109@cn.fujitsu.com>
In-Reply-To: <4D8FF2D2.9070109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 04:30 AM, Xiao Guangrong wrote:
> Simplely return from kvm_mmu_pte_write path if no shadow page is
> write-protected, than we can avoid to walk all shadow pages and hold
> mmu-lock
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2841805..ccac6c4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3219,6 +3219,11 @@ static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
>   		set_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
>   }
>
> +static bool need_track_pte_changed(struct kvm_vcpu *vcpu)
> +{
> +	return !tdp_enabled || mmu_is_nested(vcpu);
> +}
> +

What happens if this vcpu is nested but another vcpu is not?

Or if we have some indirect pages, but currently we're in non-nested mode?

Suggest instead to keep track of the number of indirect pages across the 
guest.  If it's zero, we can exit early.

>   void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		       const u8 *new, int bytes,
>   		       bool guest_initiated)
> @@ -3233,6 +3238,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	int level, npte, invlpg_counter, r, flooded = 0;
>   	bool remote_flush, local_flush, zap_page;
>
> +	if (!need_track_pte_changed(vcpu))
> +		return;
> +
>   	zap_page = remote_flush = local_flush = false;
>   	offset = offset_in_page(gpa);
>


-- 
error compiling committee.c: too many arguments to function

