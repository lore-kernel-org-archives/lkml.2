Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0GAMIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab0GAMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:08:19 -0400
Date: Thu, 1 Jul 2010 09:07:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
Message-ID: <20100701120719.GC18607@amt.cnet>
References: <4C2AF9FA.9020601@cn.fujitsu.com>
 <4C2AFB65.2030807@cn.fujitsu.com>
 <20100630204324.GA5366@amt.cnet>
 <4C2BEB48.3080705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2BEB48.3080705@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:11:36AM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> +
> >> +		addr = gfn_to_hva_many(vcpu->kvm, gfn, &entry);
> >> +		if (kvm_is_error_hva(addr))
> >> +			return -1;
> >> +
> >> +		entry = min(entry, (int)(end - start));
> >> +		ret = __get_user_pages_fast(addr, entry, 1, pages);
> >> +		if (ret <= 0)
> >> +			return -1;
> > 
> > Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is 
> > the overhead significant that this is worthwhile?
> > 
> > You're bypassing the centralized interface.
> 
> I think it's worthwhile to do since we can reduce gup overhead, no reason
> to traverse process's page table again and again for the consecutive pages.

I'd prefer to use gfn_to_pfn_atomic. The big win is with shadow mode and
there its already done one at a time.

> > 
> >> +
> >> +		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
> >> +		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
> >> +			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
> >> +			     pfn, true, false);
> > 
> > reset_host_protection should be true, see commit 1403283acca (also for
> > direct case to be consistent).
> > 
> 
> Ah, i forgot it, thanks, Marcelo!
> 
> I'll post a small fix patch base on this patchset to change 'false' to 'true' if no
> other places no to be improved. :-)
