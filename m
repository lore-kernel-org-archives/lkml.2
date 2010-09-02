Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0IBPsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:21 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41187 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0IBPsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH 1/2] [Patch-next] ACPI, APEI Fix the return value(==NULL) of acpi_pre_map().
Date: Thu, 2 Sep 2010 09:47:37 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: "APEI-lenb" <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
References: <4C7F5032.70108@np.css.fujitsu.com>
In-Reply-To: <4C7F5032.70108@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201009020947.44090.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010 01:20:18 am Jin Dongming wrote:
> acpi_pre_map() is used for remapping the physical address of I/O, so
> it should be return NULL or remapped virtual address. The problem is
> that when (paddr - pg_off) equals 0, no matter whether I/O remapping is
> successful or not, the function returns NULL.
> 
> In acpi_pre_map(), after the physical address is remapped successfully,
> it will check whether the physical address has been added into acpi_iomaps
> list again.
>    - If the physical address has been added into acpi_iomaps, the virtual
>      address will be saved in vaddr.
>    - Otherwise, NULL be saved in vaddr.
> 
> So if the physical address is the first time to be remapped, vaddr will be
> NULL always.
> 
> In many cases, (paddr - pg_off) may not equal 0. So the function could work
> well. In our machine, (paddr - pg_off) equals 0, so the return value of
> acpi_pre_map() is NULL.
> 
> This patch fixed it and I confirmed it on x86_64 next-tree.

This description is complicated and obscures the very simple bug
you are fixing.  I suggest something like this:

  ACPI: fix acpi_pre_map() return value

  After we ioremap() a new region, we call __acpi_try_ioremap() to
  see whether another thread has already mapped the same region.
  This check clobbers "vaddr", so compute the return value using
  the ioremap() result "map->vaddr" instead.

> v2:
>     Modified the unsuitable description of patch.
> 
> v3:
>     Modified the wrong words in the description of patch.   
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Acked-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/acpi/atomicio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
> index 8f8bd73..1bc2614 100644
> --- a/drivers/acpi/atomicio.c
> +++ b/drivers/acpi/atomicio.c
> @@ -133,7 +133,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
>  
>  	spin_lock_irqsave(&acpi_iomaps_lock, flags);
>  	vaddr = __acpi_try_ioremap(paddr, size);
> -	if (vaddr) {
> +	if (unlikely(vaddr)) {

This "unlikely" addition also obscures things.  It's completely
unrelated to the bug you're fixing, so it should be in a different
patch, and I'm dubious that there's enough performance advantage to
compensate for the decreased code readability.  I wouldn't make this
change unless you can measure a performance improvement.

>  		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>  		iounmap(map->vaddr);
>  		kfree(map);
> @@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
>  	list_add_tail_rcu(&map->list, &acpi_iomaps);
>  	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>  
> -	return vaddr + (paddr - pg_off);
> +	return map->vaddr + (paddr - pg_off);

Since you're changing this line anyway, I think you should change it to:

  return map->vaddr + (paddr - map->paddr);

so it matches __acpi_try_ioremap().

>  err_unmap:
>  	iounmap(vaddr);
>  	return NULL;
> -- 1.7.1.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
