Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927Ab0KQQ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:26:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790Ab0KQQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:26:58 -0500
Message-ID: <4CE4024B.4090600@redhat.com>
Date: Wed, 17 Nov 2010 18:26:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
References: <4CE355A0.6020907@cn.fujitsu.com> <20101117152943.GA18959@amt.cnet>
In-Reply-To: <20101117152943.GA18959@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:29 PM, Marcelo Tosatti wrote:
> >  diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> >  index ba00eef..58b4d9a 100644
> >  --- a/arch/x86/kvm/paging_tmpl.h
> >  +++ b/arch/x86/kvm/paging_tmpl.h
> >  @@ -781,6 +781,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >   			else
> >   				nonpresent = shadow_notrap_nonpresent_pte;
> >   			drop_spte(vcpu->kvm,&sp->spt[i], nonpresent);
> >  +			kvm_flush_remote_tlbs(vcpu->kvm);
> >   			continue;
> >   		}
>
> This is not needed. Guest is responsible for flushing on
> present->nonpresent change.

sync_page
drop_spte
kvm_mmu_notifier_invalidate_page
kvm_unmap_rmapp
spte doesn't exist -> no flush
page is freed
guest can write into freed page?

I don't think we need to flush immediately; set a "tlb dirty" bit 
somewhere that is cleareded when we flush the tlb.  
kvm_mmu_notifier_invalidate_page() can consult the bit and force a flush 
if set.

-- 
error compiling committee.c: too many arguments to function

