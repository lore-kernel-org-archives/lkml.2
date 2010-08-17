Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0HQBhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:37:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:13271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0HQBhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:37:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,379,1278313200"; 
   d="scan'208";a="828779386"
Subject: Re: [PATCH 3/4] [Patch-next] ACPI, APEI Fix the return
 value(==NULL) of acpi_pre_map always.
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <4C69DE57.9070608@np.css.fujitsu.com>
References: <4C69DE57.9070608@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 09:37:43 +0800
Message-ID: <1282009063.2744.1495.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 08:56 +0800, Jin Dongming wrote:
> acpi_pre_map() is used for remapping the physical address of I/O, so
> it should be return NULL or remapped virtual address. The problem
> is whether I/O remapping is successful or not, the function returns
> NULL always.

No. NULL is returned for error path only. Please check the code again.

> In acpi_pre_map(), after the physical address is remapped sucessfully,
> it will check whether the physical address has been added into acpi_iomaps
> list again. If the physical address has beed added into acpi_iomaps,
> the virtual address will be saved in vaddr. Otherwise, NULL be saved in
> vaddr.
> 
> So if the physical address has never been remapped, the return value of
> acpi_pre_map will be NULL always.
> 
> This patch fixed it and I confirmed it on x86_64 next-tree.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
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

pre_map is not performance critical, so "unlikely" here helps little.

>  		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>  		iounmap(map->vaddr);
>  		kfree(map);
> @@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
>  	list_add_tail_rcu(&map->list, &acpi_iomaps);
>  	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>  
> -	return vaddr + (paddr - pg_off);
> +	return map->vaddr + (paddr - pg_off);
>  err_unmap:
>  	iounmap(vaddr);
>  	return NULL;

When will vaddr != map->vaddr?

Best Regards,
Huang Ying


