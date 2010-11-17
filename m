Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935131Ab0KQRgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758512Ab0KQRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:36:28 -0500
Date: Wed, 17 Nov 2010 15:36:16 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
Message-ID: <20101117173616.GG18959@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <20101117152943.GA18959@amt.cnet>
 <4CE4024B.4090600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4024B.4090600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 06:26:51PM +0200, Avi Kivity wrote:
> On 11/17/2010 05:29 PM, Marcelo Tosatti wrote:
> >>  diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> >>  index ba00eef..58b4d9a 100644
> >>  --- a/arch/x86/kvm/paging_tmpl.h
> >>  +++ b/arch/x86/kvm/paging_tmpl.h
> >>  @@ -781,6 +781,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >>   			else
> >>   				nonpresent = shadow_notrap_nonpresent_pte;
> >>   			drop_spte(vcpu->kvm,&sp->spt[i], nonpresent);
> >>  +			kvm_flush_remote_tlbs(vcpu->kvm);
> >>   			continue;
> >>   		}
> >
> >This is not needed. Guest is responsible for flushing on
> >present->nonpresent change.
> 
> sync_page
> drop_spte
> kvm_mmu_notifier_invalidate_page
> kvm_unmap_rmapp
> spte doesn't exist -> no flush
> page is freed
> guest can write into freed page?

Ugh right.

> I don't think we need to flush immediately; set a "tlb dirty" bit
> somewhere that is cleareded when we flush the tlb.
> kvm_mmu_notifier_invalidate_page() can consult the bit and force a
> flush if set.

Yep.

