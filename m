Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2I1ORJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:17:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43906 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2I1ORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:17:04 -0400
Date: Fri, 28 Sep 2012 10:16:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/16] iommu/amd: Check if IOAPIC information is correct
Message-ID: <20120928141644.GC7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348835046-3262-5-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:23:54PM +0200, Joerg Roedel wrote:
> When the IOAPIC information provided in the IVRS table is
> not correct or not complete the system may not boot at all
> when interrupt remapping is enabled. So check if this
> information is correct and print out a firmware bug message
> when it is not.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/Kconfig          |    2 +-
>  drivers/iommu/amd_iommu_init.c |   27 ++++++++++++++++++++++++---
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 9f69b56..e39f9db 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -42,7 +42,7 @@ config AMD_IOMMU
>  	select PCI_PRI
>  	select PCI_PASID
>  	select IOMMU_API
> -	depends on X86_64 && PCI && ACPI
> +	depends on X86_64 && PCI && ACPI && X86_IO_APIC
>  	---help---
>  	  With this option you can enable support for AMD IOMMU hardware in
>  	  your system. An IOMMU is a hardware component which provides
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index db100c5..3f0b68f 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -33,6 +33,7 @@
>  #include <asm/gart.h>
>  #include <asm/x86_init.h>
>  #include <asm/iommu_table.h>
> +#include <asm/io_apic.h>
>  
>  #include "amd_iommu_proto.h"
>  #include "amd_iommu_types.h"
> @@ -1572,6 +1573,23 @@ static void __init free_on_init_error(void)
>  #endif
>  }
>  
> +static bool __init check_ioapic_information(void)
> +{
> +	int idx;
> +
> +	for (idx = 0; idx < nr_ioapics; ++idx) {

That ++idx looks odd - and it looks like the file has a combination of
i++ and ++i. Any particular reason for using this particular one instead
of the more common: "idx++" ? Or just habit?
