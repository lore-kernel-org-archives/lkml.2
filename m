Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1IMJvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1IMJvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:51:22 -0400
Message-ID: <4E6F2790.4020602@redhat.com>
Date: Tue, 13 Sep 2011 12:51:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: MMU: avoid pte_list_desc running out in
 kvm_mmu_pte_write
References: <4E5C4C20.3000403@cn.fujitsu.com>
In-Reply-To: <4E5C4C20.3000403@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:34 AM, Xiao Guangrong wrote:
> kvm_mmu_pte_write is unsafe since we need to alloc pte_list_desc in the
> function when spte is prefetched, unfortunately, we can not know how many
> spte need to be prefetched on this path, that means we can use out of the
> free  pte_list_desc object in the cache, and BUG_ON() is triggered, also some
> path does not fill the cache, such as INS instruction emulated that does not
> trigger page fault
>
> @@ -3716,10 +3735,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>   		goto out;
>   	}
>
> -	r = mmu_topup_memory_caches(vcpu);
> -	if (r)
> -		goto out;
> -
>   	er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
>

Suppose we are out of memory, can't this get us in an endless loop?

return -ENOMEM breaks as out (and kills the guest, likely).

-- 
error compiling committee.c: too many arguments to function

