Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964Ab0FRLHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:07:50 -0400
Received: from claw.goop.org ([74.207.240.146]:37904 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab0FRLHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:07:48 -0400
Message-ID: <4C1B537F.30300@goop.org>
Date: Fri, 18 Jun 2010 12:07:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, matthew@wil.cx, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C1AE64C.6040609@jp.fujitsu.com> <4C1AE680.7090408@jp.fujitsu.com>
In-Reply-To: <4C1AE680.7090408@jp.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 04:22 AM, Kenji Kaneshige wrote:
> Current x86 ioremap() doesn't handle physical address higher than
> 32-bit properly in X86_32 PAE mode. When physical address higher than
> 32-bit is passed to ioremap(), higher 32-bits in physical address is
> cleared wrongly. Due to this bug, ioremap() can map wrong address to
> linear address space.
>
> In my case, 64-bit MMIO region was assigned to a PCI device (ioat
> device) on my system. Because of the ioremap()'s bug, wrong physical
> address (instead of MMIO region) was mapped to linear address space.
> Because of this, loading ioatdma driver caused unexpected behavior
> (kernel panic, kernel hangup, ...).
>
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>
> ---
>  arch/x86/mm/ioremap.c   |   12 +++++-------
>  include/linux/io.h      |    4 ++--
>  include/linux/vmalloc.h |    2 +-
>  lib/ioremap.c           |   10 +++++-----
>  mm/vmalloc.c            |    2 +-
>  5 files changed, 14 insertions(+), 16 deletions(-)
>
> Index: linux-2.6.34/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c
> +++ linux-2.6.34/arch/x86/mm/ioremap.c
> @@ -62,8 +62,8 @@ int ioremap_change_attr(unsigned long va
>  static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  		unsigned long size, unsigned long prot_val, void *caller)
>  {
> -	unsigned long pfn, offset, vaddr;
> -	resource_size_t last_addr;
> +	unsigned long offset, vaddr;
> +	resource_size_t pfn, last_pfn, last_addr;
>   

Why is pfn resource_size_t here? Is it to avoid casting, or does it
actually need to hold more than 32 bits? I don't see any use of pfn
aside from the page_is_ram loop, and I don't think that can go beyond 32
bits. If you're worried about boundary conditions at the 2^44 limit,
then you can make last_pfn inclusive, or compute num_pages and use that
for the loop condition.

>  	const resource_size_t unaligned_phys_addr = phys_addr;
>  	const unsigned long unaligned_size = size;
>  	struct vm_struct *area;
> @@ -100,10 +100,8 @@ static void __iomem *__ioremap_caller(re
>  	/*
>  	 * Don't allow anybody to remap normal RAM that we're using..
>  	 */
> -	for (pfn = phys_addr >> PAGE_SHIFT;
> -				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
> -				pfn++) {
> -
> +	last_pfn = last_addr >> PAGE_SHIFT;
>   

If last_addr can be non-page aligned, should it be rounding up to the
next pfn rather than rounding down? Ah, looks like you fix it in the
second patch.

J
