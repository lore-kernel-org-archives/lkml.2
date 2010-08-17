Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0HQI5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:57:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50423 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab0HQI5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:57:30 -0400
Date: Tue, 17 Aug 2010 09:56:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, yuanyabin1978@sina.com,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: add PrimeCell generic DMA to PL022 v9
Message-ID: <20100817085603.GA20325@n2100.arm.linux.org.uk>
References: <1281095419-15600-1-git-send-email-linus.walleij@stericsson.com> <20100817044834.GA27060@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817044834.GA27060@angua.secretlab.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:48:34PM -0600, Grant Likely wrote:
> > +	/* Map DMA buffers */
> > +	sglen = dma_map_sg(&pl022->adev->dev, pl022->sgt_rx.sgl,
> > +			   pl022->sgt_rx.nents, DMA_FROM_DEVICE);
> > +	if (sglen != pages)
> > +		goto err_rx_sgmap;
> > +
> > +	sglen = dma_map_sg(&pl022->adev->dev, pl022->sgt_tx.sgl,
> > +			   pl022->sgt_tx.nents, DMA_TO_DEVICE);
> > +	if (sglen != pages)
> > +		goto err_tx_sgmap;
> > +
> > +	/* Synchronize the TX scatterlist, invalidate buffers, caches etc */
> > +	dma_sync_sg_for_device(&pl022->adev->dev,
> > +			       pl022->sgt_tx.sgl,
> > +			       pl022->sgt_tx.nents,
> > +			       DMA_TO_DEVICE);

This is wrong.  Mapping a scatterlist already makes it available for
the device to use.  There's no point re-doing that work by using
the sync API.

Let's go over the DMA API one more time.

	CPU owns buffer, device must not access

dma_map_xx		buffer ownership transitions from CPU to device

	device owns buffer, CPU must not access

dma_sync_xx_for_cpu	buffer ownership transitions from device to CPU

	CPU owns buffer, device must not access

dma_sync_xx_for_device	buffer ownership transitions from CPU to device

	device owns buffer, CPU must not access

dma_unmap_xx		buffer ownership transitions from device to CPU

	CPU owns buffer, device must not access
