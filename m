Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3ADRud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:50:33 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:64877 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3ADRuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:50:19 -0500
MIME-Version: 1.0
In-Reply-To: <1357260531-11115-27-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
Date: Fri, 4 Jan 2013 10:50:15 -0700
Message-ID: <CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 5:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Normal boot path on system with iommu support:
> swiotlb buffer will be allocated early at first and then try to initialize
> iommu, if iommu for intel or amd could setup properly, swiotlb buffer
> will be freed.
>
> The early allocating is with bootmem, and get panic when we try to use
> kdump with buffer above 4G only if swiotlb is enabled.
>
> because actually the kernel can go on without swiotlb, and use intel iommu.
>
> Try disable swiotlb if there is not enough ram for it.
>
> That is for kdump to use kernel above 4G.
>
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>  arch/x86/kernel/pci-swiotlb.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 6c483ba..949ebfe 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -6,6 +6,7 @@
>  #include <linux/swiotlb.h>
>  #include <linux/bootmem.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/memblock.h>
>
>  #include <asm/iommu.h>
>  #include <asm/swiotlb.h>
> @@ -50,6 +51,11 @@ static struct dma_map_ops swiotlb_dma_ops = {
>         .dma_supported = NULL,
>  };
>
> +static bool __init enough_mem_for_swiotlb(void)
> +{
> +       /* do we have less than 1M RAM under 4G ? */
> +       return memblock_mem_size(1ULL<<(32-PAGE_SHIFT)) > (1ULL<<20);
> +}
>  /*
>   * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
>   *
> @@ -58,12 +64,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
>   */
>  int __init pci_swiotlb_detect_override(void)
>  {
> -       int use_swiotlb = swiotlb | swiotlb_force;
> -
>         if (swiotlb_force)
>                 swiotlb = 1;
> +       else if (!enough_mem_for_swiotlb())
> +               swiotlb = 0;
>
> -       return use_swiotlb;
> +       return swiotlb;

This change doesn't take into account what swiolb was when
pci_swiotlb_detect_override() is called. Instead of returning
use_swiotlb like the original code did, it returns swiotlb which could
be zero, if !enough_mem_for_swiotlb().

Might work fine on Intel platforms, but not on systems where the IOMMU
driver wants to enable swiotlb for some devices as in the case of AMD.

AMD IOMMU driver enables swiotlb for devices that are not specified in
IVRs and/or not in the AMD IOMMU scope, after it successfully
initializes IOMMU. It will explicitely set switolb=1 to make sure
reserved swiotlb memory is not released. This change will break that
case.

Reference: amd_iommu_init_dma_ops()

        iommu_detected = 1;
        swiotlb = 0;

        /* Make the driver finally visible to the drivers */
        unhandled = device_dma_ops_init();
        if (unhandled && max_pfn > MAX_DMA32_PFN) {
                /* There are unhandled devices - initialize swiotlb for them */
                swiotlb = 1;
        }


Thanks,
-- Shuah
