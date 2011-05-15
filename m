Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1EOIUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1EOIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:20:20 -0400
Message-ID: <4DCF8CBC.1040602@redhat.com>
Date: Sun, 15 May 2011 11:20:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4DCEF5B1.3050706@cn.fujitsu.com>
In-Reply-To: <4DCEF5B1.3050706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 12:35 AM, Xiao Guangrong wrote:
> Simply return from kvm_mmu_pte_write path if no shadow page is
> write-protected, then we can avoid to walk all shadow pages and hold
> mmu-lock
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2841805..971e2d2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -498,6 +498,7 @@ static void account_shadowed(struct kvm *kvm, gfn_t gfn)
>   		linfo = lpage_info_slot(gfn, slot, i);
>   		linfo->write_count += 1;
>   	}
> +	atomic_inc(&kvm->arch.indirect_shadow_pages);
>   }
>
>   static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
> @@ -513,6 +514,7 @@ static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
>   		linfo->write_count -= 1;
>   		WARN_ON(linfo->write_count<  0);
>   	}
> +	atomic_dec(&kvm->arch.indirect_shadow_pages);
>   }

These atomic ops are always called from within the spinlock, so we don't 
need an atomic_t here.

Sorry, I should have noticed this on the first version.





-- 
error compiling committee.c: too many arguments to function

