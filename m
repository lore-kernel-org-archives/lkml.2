Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab0KOXfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:35:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0KOXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:35:43 -0500
Date: Mon, 15 Nov 2010 23:35:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long
	for 32-bit ptes
Message-ID: <20101115233517.GH31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <20101114151445.GB10871@n2100.arm.linux.org.uk> <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com> <201011151047.37103.arnd@arndb.de> <AANLkTi=FFpCwEhSgs-zOh32JQvqQWqnaQVTitwJeDyzj@mail.gmail.com> <alpine.LFD.2.00.1011151707310.6448@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1011151707310.6448@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 05:11:50PM -0500, Nicolas Pitre wrote:
> On Mon, 15 Nov 2010, Catalin Marinas wrote:
> 
> > On 15 November 2010 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
> > >> > There will be compiler warnings because u32 is unsigned int, and we
> > >> > print it as %08lx.  Generic code cases pte values to (long long) and
> > >> > prints them using %08llx.  We should do the same.
> > >>
> > >> We still need some kind of macro because with LPAE we need %016llx
> > >> since the phys address can go to 40-bit and there are some additional
> > >> bits in the top word. Unless you'd like to always print 16 characters
> > >> even for 32-bit ptes (or if there is some other printk magic I'm not
> > >> aware of).
> > >
> > > Why not just %010llx? That would just be two extra characters.
> > 
> > We still have attributes (like XN, bit 54) stored in the top part of
> > the pte. This may be of interest when debugging.
> 
> They will be printed if they exist. The %010 in front of llx only means 
> to have a minimum of 10 zero-paded digits if the value is smaller than 
> that.
> 
> However, not having aligned values will be confusing.  A macro for the 
> format might be the best compromize.

It's what is done in the generic kernel code for page table entries.

        printk(KERN_ALERT
                "BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
                current->comm,
                (long long)pte_val(pte), (long long)pmd_val(*pmd));

The places where this matters, there isn't any alignment between
lines to worry about:

	printk(", *pmd=%08lx", pmd_val(*pmd));
	printk(", *pte=%08lx", pte_val(*pte));
	printk(", *ppte=%08lx", pte_val(pte[-PTRS_PER_PTE]));

in show_pte() are examples of what need changing.
