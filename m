Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1JASHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:07:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:8430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1JASHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="58040402"
Subject: Re: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data
 transfers
From: Vinod Koul <vinod.koul@intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>,
        Dan <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 23:31:17 +0530
Message-ID: <1317492077.1573.1839.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 17:38 -0400, Alexandre Bounine wrote:
Please CC *maintainers* on your patches, get_maintainers.pl will tell
you who. Adding Dan here
> Adds DMA Engine framework support into RapidIO subsystem.
> Uses DMA Engine DMA_SLAVE interface to generate data transfers to/from remote
> RapidIO target devices. Uses scatterlist to describe local data buffer and
> dma_chan.private member to pass target specific information. Supports flat
> data buffer only for a remote side.
The way dmaengine works today is that it doesn't know anything about
client subsystem. But this brings in a subsystem details to dmaengine
which I don't agree with yet.
Why can't we abstract this out??

After going thru the patch, I do not believe that this this is case of
SLAVE transfers, Dan can you please take a look at this patch


> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Li Yang <leoli@freescale.com>
> ---
>  drivers/dma/dmaengine.c   |    4 ++
>  drivers/rapidio/Kconfig   |    6 +++
>  drivers/rapidio/rio.c     |   79 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dmaengine.h |    1 +
>  include/linux/rio.h       |   47 ++++++++++++++++++++++++++
>  include/linux/rio_drv.h   |    9 +++++
>  6 files changed, 146 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index b48967b..11fdc2c 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -699,6 +699,10 @@ int dma_async_device_register(struct dma_device *device)
>  		!device->device_prep_dma_cyclic);
>  	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
>  		!device->device_control);
> +	BUG_ON(dma_has_cap(DMA_RAPIDIO, device->cap_mask) &&
> +		!device->device_prep_slave_sg);
> +	BUG_ON(dma_has_cap(DMA_RAPIDIO, device->cap_mask) &&
> +		!device->device_control);
>  
>  	BUG_ON(!device->device_alloc_chan_resources);
>  	BUG_ON(!device->device_free_chan_resources);
> diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
> index bc87192..c4aa279 100644
> --- a/drivers/rapidio/Kconfig
> +++ b/drivers/rapidio/Kconfig
> @@ -34,3 +34,9 @@ config RAPIDIO_DEBUG
>  	  If you are unsure about this, say N here.
>  
>  source "drivers/rapidio/switches/Kconfig"
> +
> +# This option to be turned on by a device selection
> +config RAPIDIO_DMA_ENGINE
> +	bool
> +	select DMADEVICES
> +	select DMA_ENGINE
> diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
> index 86c9a09..e5905fc 100644
> --- a/drivers/rapidio/rio.c
> +++ b/drivers/rapidio/rio.c
> @@ -1121,6 +1121,85 @@ int rio_std_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> +
> +#include <linux/dmaengine.h>
> +
> +static bool rio_chan_filter(struct dma_chan *chan, void *arg)
> +{
> +	struct rio_dev *rdev = arg;
> +
> +	/* Check that DMA device belongs to the right MPORT */
> +	return (rdev->net->hport ==
> +		container_of(chan->device, struct rio_mport, dma));
> +}
> +
> +/**
> + * rio_request_dma - request RapidIO capable DMA channel that supports
> + *   specified target RapidIO device.
> + * @rdev: RIO device control structure
> + *
> + * Returns pointer to allocated DMA channel or NULL if failed.
> + */
> +struct dma_chan *rio_request_dma(struct rio_dev *rdev)
> +{
> +	dma_cap_mask_t mask;
> +	struct dma_chan *dchan;
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_RAPIDIO, mask);
> +	dchan = dma_request_channel(mask, rio_chan_filter, rdev);
> +
> +	return dchan;
> +}
> +EXPORT_SYMBOL_GPL(rio_request_dma);
> +
> +/**
> + * rio_release_dma - release specified DMA channel
> + * @dchan: DMA channel to release
> + */
> +void rio_release_dma(struct dma_chan *dchan)
> +{
> +	dma_release_channel(dchan);
> +}
> +EXPORT_SYMBOL_GPL(rio_release_dma);
> +
> +/**
> + * rio_dma_prep_slave_sg - RapidIO specific wrapper
> + *   for device_prep_slave_sg callback defined by DMAENGINE.
> + * @rdev: RIO device control structure
> + * @dchan: DMA channel to configure
> + * @data: RIO specific data descriptor
> + * @direction: DMA data transfer direction (TO or FROM the device)
> + * @flags: dmaengine defined flags
> + *
> + * Initializes RapidIO capable DMA channel for the specified data transfer.
> + * Uses DMA channel private extension to pass information related to remote
> + * target RIO device.
> + * Returns pointer to DMA transaction descriptor or NULL if failed.
> + */
> +struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
> +	struct dma_chan *dchan, struct rio_dma_data *data,
> +	enum dma_data_direction direction, unsigned long flags)
> +{
> +	struct dma_async_tx_descriptor *txd = NULL;
> +	struct rio_dma_ext rio_ext;
> +
> +	rio_ext.destid = rdev->destid;
> +	rio_ext.rio_addr_u = data->rio_addr_u;
> +	rio_ext.rio_addr = data->rio_addr;
> +	rio_ext.wr_type = data->wr_type;
> +	dchan->private = &rio_ext;
> +
> +	txd = dchan->device->device_prep_slave_sg(dchan, data->sg, data->sg_len,
> +						  direction, flags);
> +
> +	return txd;
> +}
> +EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
You should move the rdev and data to dma_slave_config, that way you
should be able to use the existing _prep_slave_sg function.

> +
> +#endif /* CONFIG_RAPIDIO_DMA_ENGINE */
> +
>  static void rio_fixup_device(struct rio_dev *dev)
>  {
>  }
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 8fbf40e..867b685 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -70,6 +70,7 @@ enum dma_transaction_type {
>  	DMA_PRIVATE,
>  	DMA_ASYNC_TX,
>  	DMA_SLAVE,
> +	DMA_RAPIDIO,
>  	DMA_CYCLIC,
>  };
>  
> diff --git a/include/linux/rio.h b/include/linux/rio.h
> index 4d50611..a6d1054c 100644
> --- a/include/linux/rio.h
> +++ b/include/linux/rio.h
> @@ -20,6 +20,9 @@
>  #include <linux/errno.h>
>  #include <linux/device.h>
>  #include <linux/rio_regs.h>
> +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> +#include <linux/dmaengine.h>
> +#endif
>  
>  #define RIO_NO_HOPCOUNT		-1
>  #define RIO_INVALID_DESTID	0xffff
> @@ -254,6 +257,9 @@ struct rio_mport {
>  	u32 phys_efptr;
>  	unsigned char name[40];
>  	void *priv;		/* Master port private data */
> +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> +	struct dma_device	dma;
> +#endif
>  };
>  
>  /**
> @@ -395,6 +401,47 @@ union rio_pw_msg {
>  	u32 raw[RIO_PW_MSG_SIZE/sizeof(u32)];
>  };
>  
> +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> +
> +/**
> + * enum rio_write_type - RIO write transaction types used in DMA transfers
> + *
> + * Note: RapidIO specification defines write (NWRITE) and
> + * write-with-response (NWRITE_R) data transfer operations.
> + * Existing DMA controllers that service RapidIO may use one of these operations
> + * for entire data transfer or their combination with only the last data packet
> + * requires response.
> + */
> +enum rio_write_type {
> +	RDW_DEFAULT,		/* default method used by DMA driver */
> +	RDW_ALL_NWRITE,		/* all packets use NWRITE */
> +	RDW_ALL_NWRITE_R,	/* all packets use NWRITE_R */
> +	RDW_LAST_NWRITE_R,	/* last packet uses NWRITE_R, all other - NWRITE */
> +};
Why not use the current mechanism of specifying callback or ACK flags if
you want a response or not.

> +
> +struct rio_dma_ext {
> +	u16 destid;
> +	u64 rio_addr;	/* low 64-bits of 66-bit RapidIO address */
> +	u8  rio_addr_u;  /* upper 2-bits of 66-bit RapidIO address */
> +	enum rio_write_type wr_type; /* preferred RIO write operation type */
> +};
will this address translated to a dma_addr_t or not?
> +
> +struct rio_dma_data {
> +	/* Local data (as scatterlist) */
> +	struct scatterlist	*sg;	/* I/O scatter list */
> +	unsigned int		sg_len;	/* size of scatter list */
> +	/* Remote device address (flat buffer) */
> +	u64 rio_addr;	/* low 64-bits of 66-bit RapidIO address */
> +	u8  rio_addr_u;  /* upper 2-bits of 66-bit RapidIO address */
> +	enum rio_write_type wr_type; /* preferred RIO write operation type */
> +};
> +
> +static inline struct rio_mport *dma_to_mport(struct dma_device *ddev)
> +{
> +	return container_of(ddev, struct rio_mport, dma);
> +}
> +#endif /* CONFIG_RAPIDIO_DMA_ENGINE */
> +
>  /* Architecture and hardware-specific functions */
>  extern int rio_register_mport(struct rio_mport *);
>  extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
> diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
> index 229b3ca..d140996 100644
> --- a/include/linux/rio_drv.h
> +++ b/include/linux/rio_drv.h
> @@ -378,6 +378,15 @@ void rio_unregister_driver(struct rio_driver *);
>  struct rio_dev *rio_dev_get(struct rio_dev *);
>  void rio_dev_put(struct rio_dev *);
>  
> +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> +extern struct dma_chan *rio_request_dma(struct rio_dev *rdev);
> +extern void rio_release_dma(struct dma_chan *dchan);
> +extern struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(
> +		struct rio_dev *rdev, struct dma_chan *dchan,
> +		struct rio_dma_data *data, enum dma_data_direction direction,
> +		unsigned long flags);
> +#endif
> +
>  /**
>   * rio_name - Get the unique RIO device identifier
>   * @rdev: RIO device


-- 
~Vinod

