Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0GFW6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:58:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57896 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0GFW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:58:54 -0400
Date: Tue, 6 Jul 2010 23:58:15 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
	pre-ARMv6
Message-ID: <20100706225815.GA21834@flint.arm.linux.org.uk>
References: <20100701175144.GA2116@kroah.com> <20100701173212.785441106@clark.site> <20100701221420.GA10481@shutemov.name> <20100701221728.GA12187@suse.de> <20100701222541.GB10481@shutemov.name> <20100701224837.GA27389@flint.arm.linux.org.uk> <20100701225911.GC10481@shutemov.name> <20100701231207.GB27389@flint.arm.linux.org.uk> <20100706130618.GA14177@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706130618.GA14177@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 04:06:18PM +0300, Kirill A. Shutemov wrote:
> I've investigated the issue. It's reproducible if you try to jump to
> the megabyte next to section mapping.

Okay, this is specific to the way that OMAP sets up its mappings, which
is why it doesn't appear everywhere.

> On ARM one Linux PGD entry contains two hardware entry. But there is error
> in do_translation_fault(). It's always call pmd_none() check for the first
> entry of two, not for the entry corresponded to address. So in case if we
> try to jump the megabyte next to section mapping, we will have inifinity
> loop of translation faults.

Okay, now that we know _why_ it happens, I'm satisfied that the fix
previously committed will help this situation.

> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 9634fe1..825b9da 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -406,7 +406,8 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>         pmd_k = pmd_offset(pgd_k, addr);
>         pmd   = pmd_offset(pgd, addr);
>  
> -       if (pmd_none(*pmd_k))
> +       index = (addr >> SECTION_SHIFT) & 1;
> +       if (pmd_none(pmd_k[index]))

I do think this is extremely obscure, and therefore requires a comment
to help people understand what is going on here and why.  Leaving it
in the commit log would be an invitation for this to be needlessly
cut'n'pasted.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
