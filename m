Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0E3NM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 09:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0E3NMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 09:12:24 -0400
Message-ID: <4C026433.50602@redhat.com>
Date: Sun, 30 May 2010 16:12:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM: MMU: introduce some macros to cleanup hlist
 traverseing
References: <4C025BDC.1020304@cn.fujitsu.com>
In-Reply-To: <4C025BDC.1020304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 03:36 PM, Xiao Guangrong wrote:
> Introduce for_each_gfn_sp(), for_each_gfn_indirect_sp() and
> for_each_gfn_indirect_valid_sp() to cleanup hlist traverseing
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |  129 ++++++++++++++++++++++------------------------------
>   1 files changed, 54 insertions(+), 75 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 56f8c3c..84c705e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1200,6 +1200,22 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>
>   static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>
> +#define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
> +  hlist_for_each_entry_safe(sp, pos, n,					\
> +	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
> +		if (sp->gfn == gfn)
>    


    if (...)
         for_each_gfn_sp(...)
               blah();
    else
          BUG();

will break.  Can do 'if ((sp)->gfn != (gfn)) ; else'.

Or call functions from the for (;;) parameters to advance the cursor.

(also use parentheses to protect macro arguments)



> +
> +#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)			\
> +  hlist_for_each_entry_safe(sp, pos, n,					\
> +	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
> +		if (sp->gfn == gfn&&  !sp->role.direct)
> +
> +#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)		\
> +  hlist_for_each_entry_safe(sp, pos, n,					\
> +	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
> +		if (sp->gfn == gfn&&  !sp->role.direct&&		\
> +			!sp->role.invalid)
>    

Shouldn't we always skip invalid gfns?  What about providing both gfn 
and role to the macro?

-- 
error compiling committee.c: too many arguments to function

