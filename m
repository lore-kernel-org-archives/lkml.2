Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1JSI7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:59:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60088 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab1JSI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:59:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Oct 2011 10:59:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-mapping: fix sync_single_range_* DMA debugging
Message-ID: <20111019105910.4f79b3a8@stein>
In-Reply-To: <4E99F69F.1080701@ladisch.de>
References: <4DC960B2.40406@ladisch.de>
	<20110510203826.17d1ad91@stein>
	<4DCAAEFF.8060907@ladisch.de>
	<20110517223618.43633eee@stein>
	<4DD36B16.6040802@ladisch.de>
	<4E920ABE.8070100@ladisch.de>
	<20111015171523.434f47c8@stein>
	<4E99E92B.6020408@ladisch.de>
	<4E99F69F.1080701@ladisch.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 15 Clemens Ladisch wrote:
> Commit 5fd75a7850b5 (dma-mapping: remove unnecessary sync_single_range_*
> in dma_map_ops) unified not only the dma_map_ops but also the
> corresponding debug_dma_sync_* calls.  This led to spurious WARN()ings
> like the following because the DMA debug code was no longer able to
> detect the DMA buffer base address without the separate offset parameter:
> 
> WARNING: at lib/dma-debug.c:911 check_sync+0xce/0x446()
> firewire_ohci 0000:04:00.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x00000000cedaa400] [size=1024 bytes]
> Call Trace: ...
>  [<ffffffff811326a5>] check_sync+0xce/0x446
>  [<ffffffff81132ad9>] debug_dma_sync_single_for_device+0x39/0x3b
>  [<ffffffffa01d6e6a>] ohci_queue_iso+0x4f3/0x77d [firewire_ohci]
>  ...
> 
> To fix this, unshare the sync_single_* and sync_single_range_*
> implementations so that we are able to call the correct debug_dma_sync_*
> functions.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> ---
>  include/asm-generic/dma-mapping-common.h |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index 0c80bb3..9e31514 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -123,7 +123,12 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
>  						 size_t size,
>  						 enum dma_data_direction dir)
>  {
> -	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
> +	struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	BUG_ON(!valid_dma_direction(dir));
> +	if (ops->sync_single_for_cpu)
> +		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
> +	debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
>  }
> 
>  static inline void dma_sync_single_range_for_device(struct device *dev,
> @@ -132,7 +137,12 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
>  						    size_t size,
>  						    enum dma_data_direction dir)
>  {
> -	dma_sync_single_for_device(dev, addr + offset, size, dir);
> +	struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	BUG_ON(!valid_dma_direction(dir));
> +	if (ops->sync_single_for_device)
> +		ops->sync_single_for_device(dev, addr + offset, size, dir);
> +	debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
>  }
> 
>  static inline void



-- 
Stefan Richter
-=====-==-== =-=- =--==
http://arcgraph.de/sr/
