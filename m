Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0FQCuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 22:50:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49861 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0FQCuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 22:50:54 -0400
Date: Wed, 16 Jun 2010 20:50:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
Message-ID: <20100617025052.GH9298@parisc-linux.org>
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C197A9E.5040509@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:30:06AM +0900, Kenji Kaneshige wrote:
> Index: linux-2.6.34/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-15 04:43:00.978332015 +0900
> +++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-15 05:32:59.291693007 +0900
> @@ -62,8 +62,8 @@
>  static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  		unsigned long size, unsigned long prot_val, void *caller)
>  {
> -	unsigned long pfn, offset, vaddr;
> -	resource_size_t last_addr;
> +	unsigned long offset, vaddr;
> +	resource_size_t pfn, last_pfn, last_addr;

I have a hard time understanding this change.  pfn is always a physical
address shifted by PAGE_SHIFT.  So a 32-bit pfn supports up to 44-bit
physical addresses.  Are your addresses above 44-bits?

> @@ -115,7 +113,7 @@
>  	 * Mappings have to be page-aligned
>  	 */
>  	offset = phys_addr & ~PAGE_MASK;
> -	phys_addr &= PAGE_MASK;
> +	phys_addr = (phys_addr >> PAGE_SHIFT) << PAGE_SHIFT;

I'd rather see PAGE_MASK fixed.  Would this work?

 #define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK       (~(PAGE_SIZE-1))
+#define PAGE_MASK       (~(PAGE_SIZE-1ULL))

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
