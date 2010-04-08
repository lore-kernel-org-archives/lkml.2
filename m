Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab0DHJAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:00:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:55908 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0DHJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:00:14 -0400
Date: Thu, 8 Apr 2010 16:58:14 +0800
From: Liang Li <liang.li@windriver.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + x86-fix-handling-of-the-reservetop-boot-option.patch added to
 -mm tree
Message-ID: <20100408085814.GD26543@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <201004072200.o37M0d19009878@imap1.linux-foundation.org>
 <4BBD1AA3.4000204@oracle.com>
 <20100408010558.GA4053@localhost>
 <4BBD2DD4.1060101@oracle.com>
 <20100408015353.GB4053@localhost>
 <4BBD5BEF.3000406@oracle.com>
 <20100408045945.GB26543@localhost>
 <4BBD7E52.80507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBD7E52.80507@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 08 Apr 2010 08:59:33.0413 (UTC) FILETIME=[CE8E8D50:01CAD6F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:57:22PM -0700, Yinghai wrote:
> On 04/07/2010 09:59 PM, Liang Li wrote:
> > On Wed, Apr 07, 2010 at 09:30:39PM -0700, Yinghai wrote:
> >> On 04/07/2010 06:53 PM, Liang Li wrote:
> >>> Does this similar modification like this is more preferred?
> >>>
> >>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> >>> index a1dcfa3..30a3e97 100644
> >>> --- a/arch/x86/include/asm/io.h
> >>> +++ b/arch/x86/include/asm/io.h
> >>> @@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
> >>>  extern void __iomem *early_memremap(resource_size_t phys_addr,
> >>>  				    unsigned long size);
> >>>  extern void early_iounmap(void __iomem *addr, unsigned long size);
> >>> +extern void fixup_early_ioremap(void);
> >>>  
> >>>  #define IO_SPACE_LIMIT 0xffff
> >>>  
> >>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> >>> index ea82ef0..fe06296 100644
> >>> --- a/arch/x86/mm/ioremap.c
> >>> +++ b/arch/x86/mm/ioremap.c
> >>> @@ -448,6 +448,23 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
> >>>  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
> >>>  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
> >>>  
> >>> +void __init fixup_early_ioremap(void)
> >>> +{
> >>> +	int i;
> >>> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> >>> +		if (prev_map[i])
> >>> +			break;
> >>> +	}
> >>> +
> >>> +	if (i == FIX_BTMAPS_SLOTS)
> >> <
> >>> +		WARN_ON(1);
> >> BUG_ON()
> >>> +
> >>> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
> >>> +		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS * i);
> >>> +
> >> need to clear the old PMD, and set new PMD.
> >>
> >> so you can clear old PMD and call early_ioremap_init() in fixup_early_ioremap()
> > 
> > Call early_ioremap_init will do the update PMD work. So the preferred
> > patch would be:
> > ---------------
> > From 61fe7a116cbbf6eef98a49b88ed5861ed9ebd32d Mon Sep 17 00:00:00 2001
> > From: Liang Li <liang.li@windriver.com>
> > Date: Mon, 22 Mar 2010 18:38:14 +0800
> > Subject: [PATCH] x86: let 'reservetop' functioning right
> > 
> > When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
> > stop booting due to a early_ioremap bug that relate to commit 8827247ff.
> > 
> > The root cause of boot failure problem is the value of 'slot_virt[i]'
> > was initialized in setup_arch->early_ioremap_init. But later in
> > setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
> > when 'reservetop=0xbadc0de' being specified.
> > 
> > When reservetop being handled then FIXADDR_TOP get adjusted, Hence check
> > prev_map then re-initialize slot_virt and PMD based on new FIXADDR_TOP.
> > 
> > Signed-off-by: Liang Li <liang.li@windriver.com>
> > Cc: Wang Chen <wangchen@cn.fujitsu.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  arch/x86/include/asm/io.h |    1 +
> >  arch/x86/mm/ioremap.c     |   15 +++++++++++++++
> >  arch/x86/mm/pgtable.c     |    2 ++
> >  3 files changed, 18 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> > index a1dcfa3..30a3e97 100644
> > --- a/arch/x86/include/asm/io.h
> > +++ b/arch/x86/include/asm/io.h
> > @@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
> >  extern void __iomem *early_memremap(resource_size_t phys_addr,
> >  				    unsigned long size);
> >  extern void early_iounmap(void __iomem *addr, unsigned long size);
> > +extern void fixup_early_ioremap(void);
> >  
> >  #define IO_SPACE_LIMIT 0xffff
> >  
> > diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> > index 5eb1ba7..e4ab706 100644
> > --- a/arch/x86/mm/ioremap.c
> > +++ b/arch/x86/mm/ioremap.c
> > @@ -448,6 +448,21 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
> >  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
> >  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
> >  
> > +void __init fixup_early_ioremap(void)
> > +{
> > +	int i;
> > +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> > +		if (prev_map[i])
> > +			break;
> > +	}
> > +
> > +	if (i < FIX_BTMAPS_SLOTS)
> > +		BUG_ON(1);
> > +
> > +	early_ioremap_init();
> > +	return;
> > +}
> > +
> >  static int __init check_early_ioremap_leak(void)
> >  {
> >  	int count = 0;
> > diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> > index 5c4ee42..ea4d54c 100644
> > --- a/arch/x86/mm/pgtable.c
> > +++ b/arch/x86/mm/pgtable.c
> > @@ -4,6 +4,7 @@
> >  #include <asm/pgtable.h>
> >  #include <asm/tlb.h>
> >  #include <asm/fixmap.h>
> > +#include <asm/io.h>
> >  
> >  #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
> >  
> > @@ -351,6 +352,7 @@ void __init reserve_top_address(unsigned long reserve)
> >  	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
> >  	       (int)-reserve);
> >  	__FIXADDR_TOP = -reserve - PAGE_SIZE;
> > +	fixup_early_ioremap();
> >  #endif
> >  }
> >  
> > -----------
> > Acceptable?
> > 
> good to me.
> 
> may need to ask xen/lguest/vmi related to check that too.
> 
> arch/x86/kernel/vmi_32.c:       reserve_top_address(-vmi_rom->virtual_top);
> arch/x86/lguest/boot.c: reserve_top_address(lguest_data.reserve_mem);
> arch/x86/mm/pgtable_32.c:       reserve_top_address(address);
> arch/x86/xen/mmu.c:     reserve_top_address(-top);

When linux as vmi/xen/lguest guest OS, kernel call reserve_top_address
before start_kernel. It is far before the start_kernel hence far before
setup_arch->early_ioremap_init. So it is unsafe to place
fixup_early_ioremap inside reserve_top_address. So I think the patch
should be:

>From 7cefa9a80c4434f2941a7072d39b1f1ffc08a40f Mon Sep 17 00:00:00 2001
From: Liang Li <liang.li@windriver.com>
Date: Mon, 22 Mar 2010 18:38:14 +0800
Subject: [PATCH] x86: let 'reservetop' functioning right

When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
stop booting due to a early_ioremap bug that relate to commit 8827247ff.

The root cause of boot failure problem is the value of 'slot_virt[i]'
was initialized in setup_arch->early_ioremap_init. But later in
setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
when 'reservetop=0xbadc0de' being specified.

When reservetop being handled then FIXADDR_TOP get adjusted, Hence check
prev_map then re-initialize slot_virt and PMD based on new FIXADDR_TOP.

Signed-off-by: Liang Li <liang.li@windriver.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |   15 +++++++++++++++
 arch/x86/mm/pgtable_32.c  |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index a1dcfa3..30a3e97 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
 extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void fixup_early_ioremap(void);
 
 #define IO_SPACE_LIMIT 0xffff
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 5eb1ba7..e4ab706 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -448,6 +448,21 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 
+void __init fixup_early_ioremap(void)
+{
+	int i;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i])
+			break;
+	}
+
+	if (i < FIX_BTMAPS_SLOTS)
+		BUG_ON(1);
+
+	early_ioremap_init();
+	return;
+}
+
 static int __init check_early_ioremap_leak(void)
 {
 	int count = 0;
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 1a8faf0..26eadaa 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -128,6 +128,7 @@ static int __init parse_reservetop(char *arg)
 
 	address = memparse(arg, &arg);
 	reserve_top_address(address);
+	fixup_early_ioremap();
 	return 0;
 }
 early_param("reservetop", parse_reservetop);
-- 
1.6.6

Thanks and best regards,
	   -Liang Li

> 
> 
> YH
