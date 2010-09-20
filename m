Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0ITPYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:24:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0ITPYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:24:53 -0400
Message-ID: <4C977CBF.6030702@redhat.com>
Date: Mon, 20 Sep 2010 17:24:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: Don't touch unsync sp in kvm_mmu_pte_write()
References: <4C976D48.6020400@cn.fujitsu.com> <4C976DF6.1020905@cn.fujitsu.com>
In-Reply-To: <4C976DF6.1020905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/20/2010 04:21 PM, Xiao Guangrong wrote:
> Gfn may have many shadow pages, when one sp need be synced, we write
> protected sp->gfn and sync this sp but we keep other shadow pages
> asynchronous
>
> So, while gfn happen page fault, let it not touches unsync page, the unsync
> page only updated at invlpg/flush TLB time
>
> @@ -3157,6 +3164,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>
>   	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
>   	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
> +		if (sp->unsync)
> +			continue;
> +
>

Not sure this is a win.  If a gpte is updated from having p=0 to p=1 (or 
permissions upgraded), we may not have an invlpg to sync the spte, since 
the hardware doesn't require it.  With this change, we may get an extra #PF.

-- 
error compiling committee.c: too many arguments to function

