Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3ADQKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:10:43 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:35337 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3ADQKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:10:41 -0500
Date: Fri, 4 Jan 2013 17:10:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] dma: mv_xor: do not sync the DMA buffer after being
 deallocated
Message-ID: <20130104171033.4a244c3d@skate>
In-Reply-To: <1356636228-23096-2-git-send-email-lkundrak@v3.sk>
References: <1356636228-23096-1-git-send-email-lkundrak@v3.sk>
	<1356636228-23096-2-git-send-email-lkundrak@v3.sk>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lubomir Rintel,

On Thu, 27 Dec 2012 20:23:48 +0100, Lubomir Rintel wrote:

>  	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
>  				MV_XOR_TEST_SIZE, DMA_FROM_DEVICE);
> +	dma_unmap_single(dma_chan->device->dev, dest_dma, MV_XOR_TEST_SIZE,
> +			 DMA_FROM_DEVICE);

I would assume that dma_unmap_single() implies a
dma_sync_single_for_cpu() since you're unmapping the DMA buffer. So if
you use dma_unmap_single(), I think you can remove the call to
dma_sync_single_for_cpu().


>  	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
>  				PAGE_SIZE, DMA_FROM_DEVICE);
> +	dma_unmap_page(dma_chan->device->dev, dest_dma, PAGE_SIZE,
> +		       DMA_FROM_DEVICE);

Ditto.

Also, the mv_xor_memcpy_self_test() function not only dma_map_single()
the destination buffer, but also the source buffer. So presumably, the
source buffer should also be dma_unmap_single()'d.

And for the mv_xor_xor_self_test() function, multiple source buffers
are dma_map_page()'d, so they should all be dma_unmap_page()'d I guess,
not only the destination buffer.

Does that make sense?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
