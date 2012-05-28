Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2E1OmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2E1OmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:42:08 -0400
Date: Mon, 28 May 2012 16:42:05 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
Message-ID: <20120528144205.GG4016@redhat.com>
References: <4FC316E3.6080607@linux.vnet.ibm.com>
 <4FC35A15.6080000@redhat.com>
 <4FC363EE.6060204@linux.vnet.ibm.com>
 <4FC36E85.4010909@redhat.com>
 <4FC37600.1060301@linux.vnet.ibm.com>
 <4FC37A18.10809@redhat.com>
 <4FC38084.40409@linux.vnet.ibm.com>
 <4FC38362.6010802@redhat.com>
 <4FC3863F.5020902@linux.vnet.ibm.com>
 <4FC38992.8070408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC38992.8070408@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 05:20:02PM +0300, Avi Kivity wrote:
> The "right thing" we should be doing is running get_page() on every
> small page within the frame (we asked for a small page but are
> opportunistrically using the pages around it, without a proper ref).
> That's a bit slow though, so we cheat.

The problem is that we're aligning the pfn. The refcount move just
follows the pfn alignment. The spte setting I think need the correct
aligned pfn that matches the hugepmd NPT/EPT alignment.

So then we're moving the pfn refcount too, otherwise
kvm_release_pfn_clean then would run on a different pfn than the one
that was returned by gup-fast.

If we would drop the refcount before calling __direct_map or use a
gup-fast that doesn't even take a pin, we wouldn't need to move the
refcount and we could only free the page (without having to do a
get_page).

> But I guess we can start with your fix.  But what about shifting mask by
> one bit?  Isn't it sufficient?
> 
> -		mask = KVM_PAGES_PER_HPAGE(level) - 1;
> +		mask = KVM_PAGES_PER_HPAGE(level);
> +		mask *= KVM_HOST_HPAGES_PER_HPAGE;
> +		mask -= 1;
> 
> This should move the reference to the right place.

The pfn passed to mmu_set_spte then would then be aligned at 4M
despite the NTP/EPT size is 2M, so I doubt it would be ok. The real
thing to check here is that the pfn passed is correct. The refcount
just follows.

Just doing s/get_page_unless_zero()/get_page()/ should work I
think. And good thing there's no chance to get this wrong by testing,
it either boots or doesn't boot.
