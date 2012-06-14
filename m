Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2FNSgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:36:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32484 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2FNSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:36:47 -0400
Date: Thu, 14 Jun 2012 14:29:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, rusty@rustcorp.com.au
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear
 functions
Message-ID: <20120614182913.GA21956@phenom.dumpdata.com>
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
 <20120613140404.GH5979@phenom.dumpdata.com>
 <4FD8AB07.7080004@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD8AB07.7080004@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 04:00:23PM +0100, David Vrabel wrote:
> On 13/06/12 15:04, Konrad Rzeszutek Wilk wrote:
> > On Wed, Jun 13, 2012 at 11:20:43AM +0100, David Vrabel wrote:
> >> This series removes the x86-specific implementation of
> >> ptep_get_and_clear() and pmdp_get_and_clear().
> >>
> >> The principal reason for this is it allows Xen paravitualized guests
> >> to batch the PTE clears which is a significant performance
> >> optimization of munmap() and mremap() -- the number of entries into
> >> the hypervisor is reduced by about a factor of about 30 (60 in 32-bit
> >> guests) for munmap().
> >>
> >> There may be minimal gains on native and KVM guests due to the removal
> >> of the locked xchg.
> > 
> > What about lguest?
> 
> As I note in the description of patch 1:
> 
> "There may be a performance regression with lguest guests as
> an optimization for avoiding calling pte_update() when doing a full
> teardown of an mm is removed."
> 
> I don't know how much this performance regression would be or if the
> performance of lguest guests is something people care about.
> 
> We could have an x86-specific ptep_get_and_clear_full() which looks like:
> 
> pte_t ptep_get_and_clear_full(
> 	struct mm_struct *mm, unsigned long addr, pte_t *ptep,
> 	int full)
> {
> 	pte_t pte = *ptep;
> 
> 	pte_clear(mm, address, ptep);
> 	if (!full)
> 		pte_update(mm, addr, ptep);
> 
> 	return pte;
> }
> 
> Which would have all the performance benefits of the proposed patch
> without the performance regression with lguest.

Lets rope Rusty in this since he is the maintainer of lguest.
> 
> David
> 
> >>
> >> Removal of arch-specific functions where generic ones are suitable
> >> seems to be a generally useful thing to me.
> >>
> >> The full reasoning for why this is safe is included in the commit
> >> message of patch 1 but to summarize.  The atomic get-and-clear does
> >> not guarantee that the latest dirty/accessed bits are returned as TLB
> >> as there is a still a window after the get-and-clear and before the
> >> TLB flush that the bits may be updated on other processors.  So, user
> >> space applications accessing pages that are being unmapped or remapped
> >> already have unpredictable behaviour.
> >>
> >> David
