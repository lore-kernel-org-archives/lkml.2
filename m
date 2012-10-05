Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2JEPc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:56 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:52494 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab2JEPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:53 -0400
Message-ID: <506EFD99.70007@compulab.co.il>
Date: Fri, 05 Oct 2012 17:32:41 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120711 Thunderbird/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, Mike Rapoport <mike@compulab.co.il>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 14/16] ARM: pxa: armcore: fix PCI PIO warnings
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1349448930-23976-15-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/12 16:55, Arnd Bergmann wrote:
> The it8152 PCI host used on the pxa/cm_x2xx machines
> uses the old-style I/O window registration. This should
> eventually get converted to pci_ioremap_io() but for
> now, let's cast the IT8152_IO_BASE constant to an integer
> type to get rid of the warnings.
> 
> Without this patch, building cm_x2xx_defconfig results in:
> 
> arch/arm/common/it8152.c: In function 'it8152_pci_setup':
> arch/arm/common/it8152.c:287:18: warning: assignment makes integer from pointer without a cast [enabled by default]
> arch/arm/common/it8152.c:288:16: warning: assignment makes integer from pointer without a cast [enabled by default]
> arch/arm/common/it8152.c:291:17: warning: assignment makes integer from pointer without a cast [enabled by default]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Igor Grinberg <grinberg@compulab.co.il>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

Thanks!

> ---
>  arch/arm/common/it8152.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
> index c4110d1..001f491 100644
> --- a/arch/arm/common/it8152.c
> +++ b/arch/arm/common/it8152.c
> @@ -284,11 +284,17 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
>  
>  int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
>  {
> -	it8152_io.start = IT8152_IO_BASE + 0x12000;
> -	it8152_io.end	= IT8152_IO_BASE + 0x12000 + 0x100000;
> +	/*
> +	 * FIXME: use pci_ioremap_io to remap the IO space here and
> +	 * move over to the generic io.h implementation.
> +	 * This requires solving the same problem for PXA PCMCIA
> +	 * support.
> +	 */
> +	it8152_io.start = (unsigned long)IT8152_IO_BASE + 0x12000;
> +	it8152_io.end	= (unsigned long)IT8152_IO_BASE + 0x12000 + 0x100000;
>  
>  	sys->mem_offset = 0x10000000;
> -	sys->io_offset  = IT8152_IO_BASE;
> +	sys->io_offset  = (unsigned long)IT8152_IO_BASE;
>  
>  	if (request_resource(&ioport_resource, &it8152_io)) {
>  		printk(KERN_ERR "PCI: unable to allocate IO region\n");

-- 
Regards,
Igor.
