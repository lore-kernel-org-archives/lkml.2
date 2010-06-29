Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0F2MAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab0F2MAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:00:37 -0400
Date: Tue, 29 Jun 2010 08:44:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 8/10] KVM: MMU: prefetch ptes when intercepted guest
 #PF
Message-ID: <20100629114446.GB26369@amt.cnet>
References: <4C2498EC.2010006@cn.fujitsu.com>
 <4C249BEA.1030908@cn.fujitsu.com>
 <20100628130431.GA6209@amt.cnet>
 <4C29A9CC.2080508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C29A9CC.2080508@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 04:07:40PM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> +
> >> +	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
> >> +		return;
> >> +
> >> +	if (sp->role.direct)
> >> +		return direct_pte_prefetch(vcpu, sptep);
> > 
> > Can never happen.
> > 
> 
> Marcelo,
> 
> Thanks for your comment. You mean that we can't meet sp->role.direct here?
> could you please tell me why? During my test, it can be triggered.

Ah, for 1->1 emulation, right.

> >> @@ -322,6 +395,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> >>  				     user_fault, write_fault,
> >>  				     dirty, ptwrite, level,
> >>  				     gw->gfn, pfn, false, true);
> >> +			FNAME(pte_prefetch)(vcpu, sptep);
> >>  			break;
> >>  		}
> > 
> > 
> > I'm afraid this can introduce regressions since it increases mmu_lock
> > contention. Can you get some numbers with 4-vcpu or 8-vcpu guest and
> > many threads benchmarks, such as kernbench and apachebench? (on
> > non-EPT).
> > 
> 
> The pte prefetch is the fast path, it only occupies little time, for the worst
> case, only need read 128 byte form the guest pte, and if it prefetched success,
> the #PF cause by later access will avoid, then we avoid to exit form the guest,
> and walk guest pte, walk shadow pages, flush local tlb... a lots of work can be
> reduced.
> 
> Before i post this patchset firstly, i do the performance test by using unixbench,
> it improved ~3.6% under EPT disable case.
> (it's in the first version's chagelog)
> 
> Today, i do the kernbench test with 4 vcpu and 1G memory, the result shows it
> improved ~1.6% :-)

OK, nice.

> > Also prefetch should be disabled for EPT, due to lack of accessed bit.
> > 
> 
> But we call mmu_set_spte() with speculative == false, it not touch the accessed bit.

There is no accessed bit on EPT. So the aging code (kvm_age_rmapp)
considers any present translation as accessed. There is no way to
distinguish between actually accessed translations and prefetched (but
unused) ones.
