Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1BUOg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:36:57 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50873 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754404Ab1BUOg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:36:56 -0500
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
 unsigned long for physical addresses
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110219182631.GS29493@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
	 <20110219182631.GS29493@n2100.arm.linux.org.uk>
Date: Mon, 21 Feb 2011 14:36:47 +0000
Message-ID: <1298299008.19814.20.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 21 Feb 2011 14:36:51.0596 (UTC) FILETIME=[C73A74C0:01CBD1D4]
X-MC-Unique: 111022114365303601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, 2011-02-19 at 18:26 +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 24, 2011 at 05:55:57PM +0000, Catalin Marinas wrote:
> > From: Will Deacon <will.deacon@arm.com>
> >
> > The unsigned long datatype is not sufficient for mapping physical addresses
> > >= 4GB.
> >
> > This patch ensures that the phys_addr_t datatype is used to represent
> > physical addresses which may be beyond the range of an unsigned long.
> > The virt <-> phys macros are updated accordingly to ensure that virtual
> > addresses can remain as they are.
> >
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> This patch needs some more things fixed to prevent warnings:

Ah yes, this is for the non-HIGHMEM case which I hadn't considered for
LPAE. It's a perfectly reasonable configuration I suppose so this needs
fixing.

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index a81355d..6cf76b3 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -809,9 +809,10 @@ static void __init sanity_check_meminfo(void)
>                  */
>                 if (__va(bank->start) >= vmalloc_min ||
>                     __va(bank->start) < (void *)PAGE_OFFSET) {
> -                       printk(KERN_NOTICE "Ignoring RAM at %.8lx-%.8lx "
> +                       printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
>                                "(vmalloc region overlap).\n",
> -                              bank->start, bank->start + bank->size - 1);
> +                              (unsigned long long)bank->start,
> +                              (unsigned long long)bank->start + bank->size - 1);
>                         continue;
>                 }
> 
> @@ -822,10 +823,11 @@ static void __init sanity_check_meminfo(void)
>                 if (__va(bank->start + bank->size) > vmalloc_min ||
>                     __va(bank->start + bank->size) < __va(bank->start)) {
>                         unsigned long newsize = vmalloc_min - __va(bank->start);
> -                       printk(KERN_NOTICE "Truncating RAM at %.8lx-%.8lx "
> -                              "to -%.8lx (vmalloc region overlap).\n",
> -                              bank->start, bank->start + bank->size - 1,
> -                              bank->start + newsize - 1);
> +                       printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
> +                              "to -%.8llx (vmalloc region overlap).\n",
> +                              (unsigned long long)bank->start,
> +                              (unsigned long long)bank->start + bank->size - 1,
> +                              (unsigned long long)bank->start + newsize - 1);
>                         bank->size = newsize;
>                 }
>  #endif


Would you like me to submit an additional patch or are you happy merging
this diff in with my ack?

Cheers,

Will


