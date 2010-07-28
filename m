Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0G1Gdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:33:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0G1Gdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sT86uuSvWQk8LfqNZlRybqaM6Jm3AtSvKNJ7QRgVjGEuj0Za7H11vniVT1UkRsnMH7
         0yk8BT35vxGC3+ye2QCpOEgEKTAiiuLfJcXbVLr0m1IqOfcyYlMSD4FM/hnd4Lkso8eb
         LXZ8hic5/NHF9kEzagoUE0VqUepasGXOojWvY=
MIME-Version: 1.0
In-Reply-To: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
References: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
Date: Tue, 27 Jul 2010 23:33:43 -0700
X-Google-Sender-Auth: pENIZx6XDL2xt782jiMN36m7NeM
Message-ID: <AANLkTi=dORrwVO4H-JkN42=Er-21haEHcxnrhC+NC24J@mail.gmail.com>
Subject: Re: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
From: Dan Williams <dan.j.williams@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linus.ml.walleij@gmail.com,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:58 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> Hello Dan,
>
> The second rev of patch fixes the comments recieved last time.
> I have also cleaned up the driver and few more cosmetic changes
>
> This patch add DMA drivers for DMA controllers in Langwell chipset
> of Intel(R) Moorestown platform and DMA controllers in Penwell of
> Intel(R) Medfield platfrom
>
> This patch adds support for Moorestown DMAC1 and DMAC2 controllers.
> It also add support for Medfiled GP DMA and DMAC1 controllers.
> These controllers supports memory to peripheral and peripheral to
> memory transfers. It support only single block transfers.
>
> This driver is based on Kernel DMA engine
> Anyone who wishes to use this controller should use DMA engine APIs
>
> This controller exposes DMA_SLAVE capabilities and notifies the client drivers
> of DMA transaction completion
>
> Config option required to be enabled CONFIG_INTEL_MID_DMAC=y
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/dma/Kconfig              |   13 +
>  drivers/dma/Makefile             |    1 +
>  drivers/dma/intel_mid_dma.c      | 1143 ++++++++++++++++++++++++++++++++++++++
>  drivers/dma/intel_mid_dma_regs.h |  260 +++++++++
>  include/linux/intel_mid_dma.h    |   86 +++
>  5 files changed, 1503 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/intel_mid_dma.c
>  create mode 100644 drivers/dma/intel_mid_dma_regs.h
>  create mode 100644 include/linux/intel_mid_dma.h
>
[..]
> +/**
> + * intel_mid_dma_prep_memcpy - Prep memcpy txn
> + * @chan: chan for DMA transfer
> + * @dest: destn address
> + * @src: src address
> + * @len: DMA transfer len
> + * @flags: DMA flags
> + *
> + * Perform a DMA memcpy. Note we support slave periphral DMA transfers only
> + * The periphral txn details should be filled in slave structure properly
> + * Returns the descriptor for this txn
> + */
> +static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
> +                       struct dma_chan *chan, dma_addr_t dest,
> +                       dma_addr_t src, size_t len, unsigned long flags)

The use of the prep_dma_memcpy routine instead of prep_slave_sg is a
bit odd for device-to-memory dma because the dma_addr_t type only
describes the bus address view of host memory from the device
perspective.  Other slave dma devices are using a backdoor method
(since a good abstraction does not exist) to associate a known channel
to a known device and then specifying the host address and a direction
via prep_slave_sg.  I see that this usage of dma_addr_t was inherited
from the dw_spi implementation, so not much we can do about it now,
but I don't think its a model we want to perpetuate.

I do see that the dw_spi_mid driver is only calling
dma_request_channel(mask, NULL, NULL).  Are we guaranteed that
dw_spi_mid silicon collateral will only ever exist on an intel_mid_dma
platform?  Otherwise can the dw_mid_spi driver survive talking to
another random DMA_SLAVE|DMA_MEMCPY channel?  The purpose of the
filter_fn parameter to dma_request_channel() is to guarantee (by
arch-specific hackery) that you are talking to a known compatible
channel for your device.

> +{
> +       struct intel_mid_dma_chan *midc;
> +       struct intel_mid_dma_desc *desc = NULL;
> +       struct intel_mid_dma_slave *mids;
> +       union intel_mid_dma_ctl_lo ctl_lo;
> +       union intel_mid_dma_ctl_hi ctl_hi;
> +       union intel_mid_dma_cfg_lo cfg_lo;
> +       union intel_mid_dma_cfg_hi cfg_hi;
> +       enum intel_mid_dma_width width = 0;
> +
> +       pr_debug("MDMA: Prep for memcpy\n");
> +       WARN_ON(!chan);
> +       if (!len)
> +               return NULL;
> +
> +       mids = chan->private;
> +       WARN_ON(!mids);
> +
> +       midc = to_intel_mid_dma_chan(chan);
> +       WARN_ON(!midc);

These WARN_ONs are a bit odd because if they trigger we'll hit null
pointer dereferences soon afterwards.  Is that what you wanted?

[..]
> +/**
> + * struct intel_mid_dma_slave - DMA slave structure
> + *
> + * @dirn: DMA trf direction
> + * @src_width: tx register width
> + * @dst_width: rx register width
> + * @hs_mode: HW/SW handshaking mode
> + * @cfg_mode: DMA data transfer mode (per-per/mem-per/mem-mem)
> + * @src_msize: Source DMA burst size
> + * @dst_msize: Dst DMA burst size
> + * @device_instance: DMA peripheral device instance, we can have multiple
> + *             peripheral device connected to single DMAC
> + */
> +struct intel_mid_dma_slave {
> +       enum dma_data_direction         dirn;
> +       enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
> +       enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
> +       enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
> +       enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
> +       enum intel_mid_dma_msize        src_msize; /*size if src burst*/
> +       enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
> +       unsigned int            device_instance; /*0, 1 for periphral instance*/
> +};

For 2.6.37 I'd like to see a conversion of this to the result of
Linus' dma_slave_config work, but this isn't a blocker for 2.6.36.

The dw_mid_spi issues (dma_addr_t and dma_request_channel() usage) are
outside the drivers/dma/ tree, so I'll go ahead and apply this*.  If
you want to fix up the WARN_ON issues just send an incremental cleanup
patch.

--
Dan

*applied with a fix for:
drivers/dma/intel_mid_dma.c:511: warning: format %d expects type int,
but argument 4 has type size_t
