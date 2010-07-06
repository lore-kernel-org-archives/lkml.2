Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0GFNGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:06:21 -0400
Received: from shutemov.name ([188.40.19.243]:58890 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab0GFNGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:06:19 -0400
Date: Tue, 6 Jul 2010 16:06:18 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
 pre-ARMv6
Message-ID: <20100706130618.GA14177@shutemov.name>
References: <20100701175144.GA2116@kroah.com>
 <20100701173212.785441106@clark.site>
 <20100701221420.GA10481@shutemov.name>
 <20100701221728.GA12187@suse.de>
 <20100701222541.GB10481@shutemov.name>
 <20100701224837.GA27389@flint.arm.linux.org.uk>
 <20100701225911.GC10481@shutemov.name>
 <20100701231207.GB27389@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701231207.GB27389@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 12:12:07AM +0100, Russell King wrote:
> On Fri, Jul 02, 2010 at 01:59:11AM +0300, Kirill A. Shutemov wrote:
> > On Thu, Jul 01, 2010 at 11:48:37PM +0100, Russell King wrote:
> > > One possibility is that for some reason you're using the legacy prefetch
> > > abort code or pre-IFSR code, which will always tell the kernel that its
> > > a translation fault - and in this case, this patch would improve the
> > > situation.  What kernel version are you using?
> > 
> > 2.6.32
> 
> Should be recent enough.
> 
> > If you run this test in loop on kernel without the patch you'll finally
> > get hung instead SIGSEGV.
> > 
> > It seems the patch fixes more than it was written for. :)
> 
> Have you investigated the IFSR and IFAR values, and the corresponding
> page table state?  I'm not going to be able to run your test code for
> a few days.

I've investigated the issue. It's reproducible if you try to jump to
the megabyte next to section mapping.

On my OMAP3-based device I use address 0xfc1XXXXX for debugging propose.
It's a megabyte next to OMAP343X_SMS mapping.

On ARM one Linux PGD entry contains two hardware entry. But there is error
in do_translation_fault(). It's always call pmd_none() check for the first
entry of two, not for the entry corresponded to address. So in case if we
try to jump the megabyte next to section mapping, we will have inifinity
loop of translation faults.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 9634fe1..825b9da 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -406,7 +406,8 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
        pmd_k = pmd_offset(pgd_k, addr);
        pmd   = pmd_offset(pgd, addr);
 
-       if (pmd_none(*pmd_k))
+       index = (addr >> SECTION_SHIFT) & 1;
+       if (pmd_none(pmd_k[index]))
                goto bad_area;
 
        copy_pmd(pmd, pmd_k);
-- 
 Kirill A. Shutemov
