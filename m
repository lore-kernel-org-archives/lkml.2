Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2HLD6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 23:58:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43890 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2HLD6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 23:58:44 -0400
Date: Sat, 11 Aug 2012 23:58:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 09/22] ARM: LPAE: use phys_addr_t for initrd location
 and size
In-Reply-To: <1344648306-15619-10-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208112358160.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-10-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> From: Vitaly Andrianov <vitalya@ti.com>
> 
> This patch fixes the initrd setup code to use phys_addr_t instead of assuming
> 32-bit addressing.  Without this we cannot boot on systems where initrd is
> located above the 4G physical address limit.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/mm/init.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 19ba70b..bae9d05 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -36,12 +36,13 @@
>  
>  #include "mm.h"
>  
> -static unsigned long phys_initrd_start __initdata = 0;
> +static phys_addr_t phys_initrd_start __initdata = 0;
>  static unsigned long phys_initrd_size __initdata = 0;
>  
>  static int __init early_initrd(char *p)
>  {
> -	unsigned long start, size;
> +	phys_addr_t start;
> +	unsigned long size;
>  	char *endp;
>  
>  	start = memparse(p, &endp);
> @@ -347,14 +348,14 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	if (phys_initrd_size &&
>  	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
> -		pr_err("INITRD: 0x%08lx+0x%08lx is not a memory region - disabling initrd\n",
> -		       phys_initrd_start, phys_initrd_size);
> +		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region - disabling initrd\n",
> +		       (u64)phys_initrd_start, phys_initrd_size);
>  		phys_initrd_start = phys_initrd_size = 0;
>  	}
>  	if (phys_initrd_size &&
>  	    memblock_is_region_reserved(phys_initrd_start, phys_initrd_size)) {
> -		pr_err("INITRD: 0x%08lx+0x%08lx overlaps in-use memory region - disabling initrd\n",
> -		       phys_initrd_start, phys_initrd_size);
> +		pr_err("INITRD: 0x%08llx+0x%08lx overlaps in-use memory region - disabling initrd\n",
> +		       (u64)phys_initrd_start, phys_initrd_size);
>  		phys_initrd_start = phys_initrd_size = 0;
>  	}
>  	if (phys_initrd_size) {
> -- 
> 1.7.9.5
> 
