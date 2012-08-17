Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2HQQIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:08:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab2HQQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:08:10 -0400
Date: Fri, 17 Aug 2012 17:07:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 06/31] arm64: MMU fault handling and page table
 management
Message-ID: <20120817160729.GJ24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-7-git-send-email-catalin.marinas@arm.com>
 <201208151347.01169.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151347.01169.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:47:00PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +pgd_t *pgd_alloc(struct mm_struct *mm)
> > +{
> > +	pgd_t *new_pgd;
> > +
> > +	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, PGD_ORDER);
> > +	if (!new_pgd)
> > +		return NULL;
> > +
> > +	memset(new_pgd, 0, PAGE_SIZE << PGD_ORDER);
> > +
> > +	return new_pgd;
> > +}
> > +
> > +void pgd_free(struct mm_struct *mm, pgd_t *pgd)
> > +{
> > +	free_pages((unsigned long)pgd, PGD_ORDER);
> > +}
>  
> According to the documentation, you should only need 8kb for the pgd on
> a 64kb page system. Is it required that you use up a full page here?

Not with the current virtual memory layout with 39-bit address space for
kernel. With 64K pages we can increase the address space to 42-bit while
still using 2-level page table, in which case a full page is used.

But for now I'll keep the same virtual memory layout and add a check on
(PTRS_PER_PGD * sizeof(pgd_t)), the compiler will choose the right path.

-- 
Catalin
