Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1EKPkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:40:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58788 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab1EKPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:40:12 -0400
Date: Wed, 11 May 2011 11:54:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/19] ARM: LPAE: Invalidate the TLB before freeing the
	PMD
Message-ID: <20110511105419.GD5315@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:23:19AM +0100, Catalin Marinas wrote:
> +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> +				  unsigned long addr)
> +{
> +#ifdef CONFIG_ARM_LPAE
> +	tlb_add_flush(tlb, addr);
> +	tlb_flush(tlb);
> +	pmd_free((tlb)->mm, pmdp);
> +#endif
> +}

You're:

1. tlb_add_flush() - Adding the address which covers the PMD to the range
   of virtual addresses which need flushing - ok.
2. tlb_flush() - You're then forcing a flush.
3. pmd_free() - You're now freeing the page.

One of the points about the shootdown interface is that it batches things
up.  So what's wrong with:

static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
	unsigned long addr)
{
#ifdef CONFIG_ARM_LPAE
	tlb_add_flush(tlb, addr);
	tlb_remove_page(tlb, virt_to_page(pmdp));
#endif
}

and leave the tlb invalidate and actual page freeing to the batching code
to deal with?
