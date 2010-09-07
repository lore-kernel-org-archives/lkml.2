Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0IGJNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:13:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55761 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0IGJNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:13:07 -0400
Message-ID: <4C8601C0.40001@mvista.com>
Date: Tue, 07 Sep 2010 13:11:28 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, dediao@cisco.com, dvomlehn@cisco.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
References: <7d28a475591d9522bd1841a95fe21260@localhost>
In-Reply-To: <7d28a475591d9522bd1841a95fe21260@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-09-2010 8:03, Kevin Cernekee wrote:

> The MIPS DMA coherency functions do not work properly (i.e. kernel oops)
> when HIGHMEM pages are passed in as arguments.  This patch uses the PPC
> approach of calling kmap_atomic() with IRQs disabled to temporarily map
> high pages, in order to flush them out to memory.

> Signed-off-by: Dezhong Diao <dediao@cisco.com>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>   arch/mips/mm/dma-default.c |  159 ++++++++++++++++++++++----------------------
>   1 files changed, 80 insertions(+), 79 deletions(-)

> diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
> index 469d401..3f23952 100644
> --- a/arch/mips/mm/dma-default.c
> +++ b/arch/mips/mm/dma-default.c
[...]
> @@ -191,8 +231,8 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
>   	enum dma_data_direction direction)
>   {
>   	if (cpu_is_noncoherent_r10000(dev))
> -		__dma_sync(dma_addr_to_virt(dev, dma_addr), size,
> -		           direction);
> +		__dma_sync(dma_addr_to_page(dev, dma_addr),
> +			   (dma_addr & ~PAGE_MASK), size, direction);

    Parens are not needed here.

> @@ -277,15 +297,10 @@ EXPORT_SYMBOL(dma_sync_single_for_cpu);
>   void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
>   	size_t size, enum dma_data_direction direction)
>   {
> -	BUG_ON(direction == DMA_NONE);
> -
>   	plat_extra_sync_for_device(dev);
> -	if (!plat_device_is_coherent(dev)) {
> -		unsigned long addr;
> -
> -		addr = dma_addr_to_virt(dev, dma_handle);
> -		__dma_sync(addr, size, direction);
> -	}
> +	if (!plat_device_is_coherent(dev))
> +		__dma_sync(dma_addr_to_page(dev, dma_handle),
> +			   (dma_handle & ~PAGE_MASK), size, direction);

    Here as well...

WBR, Sergei
