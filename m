Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1EKPkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:40:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58788 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1EKPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:40:10 -0400
Date: Wed, 11 May 2011 15:00:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/19] ARM: LPAE: Invalidate the TLB before freeing the
	PMD
Message-ID: <20110511140010.GE5315@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1305109399-13156-1-git-send-email-catalin.marinas@arm.com> <20110511105419.GD5315@n2100.arm.linux.org.uk> <1305121249.10103.45.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305121249.10103.45.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 02:40:49PM +0100, Catalin Marinas wrote:
> On Wed, 2011-05-11 at 11:54 +0100, Russell King - ARM Linux wrote:
> > One of the points about the shootdown interface is that it batches things
> > up.  So what's wrong with:
> > 
> > static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> >         unsigned long addr)
> > {
> > #ifdef CONFIG_ARM_LPAE
> >         tlb_add_flush(tlb, addr);
> >         tlb_remove_page(tlb, virt_to_page(pmdp));
> > #endif
> > }
> > 
> > and leave the tlb invalidate and actual page freeing to the batching code
> > to deal with?
> 
> There isn't a big overhead with my initial code as a pmd covers 1GB and
> we only have 1 or 2 pmds per process that we can free.
> 
> Is there any room for optimising the mmu_gather range? I think this only
> matters for case 1 in your tlb_flush() comment - unmapping a page range
> with a few pages in one pmd and a few other pages in the next pmd we get
> over 1GB range when we actually only need to flush the TLB for a few
> pages.

One of the points is to keep the code as similar to other architectures
so that the folk who are working on consolidating this stuff across other
architectures don't have to wonder why ARM is _unnecessarily_ doing things
differently.
