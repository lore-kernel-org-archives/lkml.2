Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0GUSei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab0GUSeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:34:36 -0400
Message-ID: <4C473DB3.7040405@redhat.com>
Date: Wed, 21 Jul 2010 21:34:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: MMU: fix page dirty tracking lost while sync
 page
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C3FD11D.1060104@cn.fujitsu.com>
In-Reply-To: <4C3FD11D.1060104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 06:25 AM, Xiao Guangrong wrote:
> In sync-page path, if spte.writable is changed, it will lose page dirty
> tracking, for example:
>
> assume spte.writable = 0 in a unsync-page, when it's synced, it map spte
> to writable(that is spte.writable = 1), later guest write spte.gfn, it means
> spte.gfn is dirty, then guest changed this mapping to read-only, after it's
> synced,  spte.writable = 0
>
> So, when host release the spte, it detect spte.writable = 0 and not mark page
> dirty
>
>    

Subtle, good catch.

>   set_pte:
> +	if (is_writable_pte(*sptep)&&  !is_writable_pte(spte))
> +		kvm_set_pfn_dirty(pfn);
>   	update_spte(sptep, spte);
>    

I think this has to be done after the tlb flush, otherwise we have

   set_pfn_dirty
   (some other cpu) write out page, mark as clean
   (some other vcpu writes through stale tlb entry)
   update_spte
   tlb flush

but perhaps mmu notifiers protect us here, if the cleaner wants to write 
out the page it has to clear the dirty bit in sptes as well, and that 
will block on mmu_lock.

Later on we can use the dirty bit instead of writeable bit, except on 
EPT.  But let's start with your fix.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

