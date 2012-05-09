Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2EIKUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:20:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:59138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2EIKUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163879319"
Subject: Re: [PATCH V2 2/2] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org
In-Reply-To: <1336030889-32269-3-git-send-email-ldewangan@nvidia.com>
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
	 <1336030889-32269-3-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 May 2012 15:44:04 +0530
Message-ID: <1336558444.1540.243.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 13:11 +0530, Laxman Dewangan wrote:
> Adding dmaengine based NVIDIA's Tegra APB dma driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1: 
> - Incorportaed review comments from Vinod.
> - get rid of the tegra_dma header.
> - Having clock control through runtime pm.
> - Remove regmap support.
> 
>  drivers/dma/Kconfig     |   13 +
>  drivers/dma/Makefile    |    1 +
>  drivers/dma/tegra_dma.c | 1714 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1728 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/tegra_dma.c
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index ef378b5..26d9a23 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -148,6 +148,19 @@ config TXX9_DMAC
>  	  Support the TXx9 SoC internal DMA controller.  This can be
>  	  integrated in chips such as the Toshiba TX4927/38/39.
>  
> +config TEGRA_DMA
> +	bool "NVIDIA Tegra DMA support"
> +	depends on ARCH_TEGRA
> +	select DMA_ENGINE
> +	help
> +	  Support for the NVIDIA Tegra DMA controller driver. The DMA
> +	  controller is having multiple DMA channel which can be configured
> +	  for different peripherals like audio, UART, SPI, I2C etc which is
> +	  in APB bus.
> +	  This DMA controller transfers data from memory to peripheral fifo
> +	  address or vice versa. It does not support memory to memory data
> +	  transfer.
> +
>  config SH_DMAE
>  	tristate "Renesas SuperH DMAC support"
>  	depends on (SUPERH && SH_DMA) || (ARM && ARCH_SHMOBILE)
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 86b795b..3aaa63a 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_MXS_DMA) += mxs-dma.o
>  obj-$(CONFIG_TIMB_DMA) += timb_dma.o
>  obj-$(CONFIG_SIRF_DMA) += sirf-dma.o
>  obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
> +obj-$(CONFIG_TEGRA_DMA) += tegra_dma.o
>  obj-$(CONFIG_PL330_DMA) += pl330.o
>  obj-$(CONFIG_PCH_DMA) += pch_dma.o
>  obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
> diff --git a/drivers/dma/tegra_dma.c b/drivers/dma/tegra_dma.c
> new file mode 100644
> index 0000000..3c599ca
> --- /dev/null
> +++ b/drivers/dma/tegra_dma.c
> @@ -0,0 +1,1714 @@
> +/*
> + * DMA driver for Nvidia's Tegra APB DMA controller.
> + *
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +
> +#include <mach/clk.h>
> +#include "dmaengine.h"
> +
> +#define APB_DMA_GEN			0x0
> +#define GEN_ENABLE			BIT(31)
> +
> +#define APB_DMA_CNTRL			0x010
> +#define APB_DMA_IRQ_MASK		0x01c
> +#define APB_DMA_IRQ_MASK_SET		0x020
> +
> +/* CSR register */
> +#define APB_DMA_CHAN_CSR		0x00
> +#define CSR_ENB				BIT(31)
> +#define CSR_IE_EOC			BIT(30)
> +#define CSR_HOLD			BIT(29)
> +#define CSR_DIR				BIT(28)
> +#define CSR_ONCE			BIT(27)
> +#define CSR_FLOW			BIT(21)
> +#define CSR_REQ_SEL_SHIFT		16
> +#define CSR_WCOUNT_MASK			0xFFFC
> +
> +/* STATUS register */
> +#define APB_DMA_CHAN_STA		0x004
> +#define STA_BUSY			BIT(31)
> +#define STA_ISE_EOC			BIT(30)
> +#define STA_HALT			BIT(29)
> +#define STA_PING_PONG			BIT(28)
> +#define STA_COUNT_SHIFT			2
> +#define STA_COUNT_MASK			0xFFFC
> +
> +/* AHB memory address */
> +#define APB_DMA_CHAN_AHB_PTR		0x010
> +
> +/* AHB sequence register */
> +#define APB_DMA_CHAN_AHB_SEQ		0x14
> +#define AHB_SEQ_INTR_ENB		BIT(31)
> +#define AHB_SEQ_BUS_WIDTH_SHIFT		28
> +#define AHB_SEQ_BUS_WIDTH_8		(0 << AHB_SEQ_BUS_WIDTH_SHIFT)
> +#define AHB_SEQ_BUS_WIDTH_16		(1 << AHB_SEQ_BUS_WIDTH_SHIFT)
> +#define AHB_SEQ_BUS_WIDTH_32		(2 << AHB_SEQ_BUS_WIDTH_SHIFT)
> +#define AHB_SEQ_BUS_WIDTH_64		(3 << AHB_SEQ_BUS_WIDTH_SHIFT)
> +#define AHB_SEQ_BUS_WIDTH_128		(4 << AHB_SEQ_BUS_WIDTH_SHIFT)
> +#define AHB_SEQ_DATA_SWAP		BIT(27)
> +#define AHB_SEQ_BURST_1			(4 << 24)
> +#define AHB_SEQ_BURST_4			(5 << 24)
> +#define AHB_SEQ_BURST_8			(6 << 24)
> +#define AHB_SEQ_DBL_BUF			BIT(19)
> +#define AHB_SEQ_WRAP_SHIFT		16
> +#define AHB_SEQ_WRAP_NONE		0
> +
> +/* APB address */
> +#define APB_DMA_CHAN_APB_PTR		0x018
> +
> +/* APB sequence register */
> +#define APB_DMA_CHAN_APB_SEQ		0x01c
> +#define APB_SEQ_BUS_WIDTH_SHIFT		28
> +#define APB_SEQ_BUS_WIDTH_8		(0 << APB_SEQ_BUS_WIDTH_SHIFT)
> +#define APB_SEQ_BUS_WIDTH_16		(1 << APB_SEQ_BUS_WIDTH_SHIFT)
> +#define APB_SEQ_BUS_WIDTH_32		(2 << APB_SEQ_BUS_WIDTH_SHIFT)
> +#define APB_SEQ_BUS_WIDTH_64		(3 << APB_SEQ_BUS_WIDTH_SHIFT)
> +#define APB_SEQ_BUS_WIDTH_128		(4 << APB_SEQ_BUS_WIDTH_SHIFT)
> +#define APB_SEQ_DATA_SWAP		BIT(27)
> +#define APB_SEQ_WRAP_SHIFT		16
> +#define APB_SEQ_WRAP_WORD_1		(1 << APB_SEQ_WRAP_SHIFT)
> +
> +/*
> + * If any burst is in flight and DMA paused then this is the time to complete
> + * on-flight burst and update DMA status register.
> + */
> +#define DMA_BURST_COMPLETE_TIME		20
> +
> +/* Channel base address offset from APBDMA base address */
> +#define DMA_CHANNEL_BASE_ADDRESS_OFFSET	0x1000
> +
> +/* DMA channel register space size */
> +#define DMA_CHANNEL_REGISTER_SIZE	0x20
> +
> +/*
> + * Initial number of descriptors to allocate for each channel during
> + * allocation. More descriptors will be allocated dynamically if
> + * client needs it.
> + */
> +#define DMA_NR_DESCS_PER_CHANNEL	4
> +#define DMA_NR_REQ_PER_DESC		8
all of these should be namespaced.
APB and AHB are fairly generic names. 
> +
> +struct tegra_dma;
> +
> +/*
> + * tegra_dma_chip_data Tegra chip specific DMA data
> + * @nr_channels: Number of channels available in the controller.
> + * @max_dma_count: Maximum DMA transfer count supported by DMA controller.
> + */
> +struct tegra_dma_chip_data {
> +	int nr_channels;
> +	int max_dma_count;
> +};
> +
> +/*
> + * dma_transfer_mode: Different DMA transfer mode.
> + * DMA_MODE_ONCE: DMA transfer the configured buffer once and at the end of
> + *		transfer, DMA  stops automatically and generates interrupt
> + *		if enabled. SW need to reprogram DMA for next transfer.
> + * DMA_MODE_CYCLE: DMA keeps transferring the same buffer again and again
> + *		until DMA stopped explicitly by SW or another buffer
> + *		configured. After transfer completes, DMA again starts
> + *		transfer from beginning of buffer without SW intervention.
> + *		If any new address/size is configured during buffer transfer
> + *		then DMA start transfer with new configuration when the
> + *		current transfer has completed otherwise it will keep
> + *		transferring with old configuration. It also generates
> + *		the interrupt each time the buffer transfer completes.
> + * DMA_MODE_CYCLE_HALF_NOTIFY: This mode is identical to DMA_MODE_CYCLE,
> + *		except that an additional interrupt is generated half-way
> + *		through the buffer. This is kind of ping-pong buffer mechanism.
> + *		If SW wants to change the address/size of the buffer then
> + *		it must only change when DMA is transferring the second
> + *		half of buffer. In DMA configuration, it only need to
> + *		configure starting of first buffer and size of the half buffer.
> + */
> +enum dma_transfer_mode {
> +	DMA_MODE_NONE,
> +	DMA_MODE_ONCE,
> +	DMA_MODE_CYCLE,
> +	DMA_MODE_CYCLE_HALF_NOTIFY,
> +};
I dont understand why you would need to keep track of these?
You get a request for DMA. You have properties of transfer. You prepare
you descriptors and then submit.
Why would you need to create above modes and remember them?
> +
> +/* Dma channel registers */
> +struct tegra_dma_channel_regs {
> +	unsigned long	csr;
> +	unsigned long	ahb_ptr;
> +	unsigned long	apb_ptr;
> +	unsigned long	ahb_seq;
> +	unsigned long	apb_seq;
> +};
> +
> +/*
> + * tegra_dma_sg_req: Dma request details to configure hardware. This
> + * contains the details for one transfer to configure DMA hw.
> + * The client's request for data transfer can be broken into multiple
> + * sub-transfer as per requester details and hw support.
> + * This sub transfer get added in the list of transfer and point to Tegra
> + * DMA descriptor which manages the transfer details.
> + */
> +struct tegra_dma_sg_req {
> +	struct tegra_dma_channel_regs	ch_regs;
> +	int				req_len;
> +	bool				configured;
> +	bool				last_sg;
> +	bool				half_done;
> +	struct list_head		node;
> +	struct tegra_dma_desc		*dma_desc;
> +};
> +
> +/*
> + * tegra_dma_desc: Tegra DMA descriptors which manages the client requests.
> + * This descriptor keep track of transfer status, callbacks and request
> + * counts etc.
> + */
> +struct tegra_dma_desc {
> +	struct dma_async_tx_descriptor	txd;
> +	int				bytes_requested;
> +	int				bytes_transferred;
> +	enum dma_status			dma_status;
> +	struct list_head		node;
> +	struct list_head		tx_list;
> +	struct list_head		cb_node;
> +	bool				ack_reqd;
> +	bool				cb_due;
what are these two for, seems redundant to me
> +	dma_cookie_t			cookie;
> +};
> +
> +struct tegra_dma_channel;
> +
> +typedef void (*dma_isr_handler)(struct tegra_dma_channel *tdc,
> +				bool to_terminate);
> +
> +/* tegra_dma_channel: Channel specific information */
> +struct tegra_dma_channel {
> +	struct dma_chan		dma_chan;
> +	bool			config_init;
> +	int			id;
> +	int			irq;
> +	unsigned long		chan_base_offset;
> +	spinlock_t		lock;
> +	bool			busy;
> +	enum dma_transfer_mode	dma_mode;
> +	int			descs_allocated;
> +	struct tegra_dma	*tdma;
> +
> +	/* Different lists for managing the requests */
> +	struct list_head	free_sg_req;
> +	struct list_head	pending_sg_req;
> +	struct list_head	free_dma_desc;
> +	struct list_head	wait_ack_dma_desc;
> +	struct list_head	cb_desc;
> +
> +	/* isr handler and tasklet for bottom half of isr handling */
> +	dma_isr_handler		isr_handler;
> +	struct tasklet_struct	tasklet;
> +	dma_async_tx_callback	callback;
> +	void			*callback_param;
> +
> +	/* Channel-slave specific configuration */
> +	struct dma_slave_config dma_sconfig;
> +};
> +
> +/* tegra_dma: Tegra DMA specific information */
> +struct tegra_dma {
> +	struct dma_device		dma_dev;
> +	struct device			*dev;
> +	struct clk			*dma_clk;
> +	spinlock_t			global_lock;
> +	void __iomem			*base_addr;
> +	struct tegra_dma_chip_data	*chip_data;
> +
> +	/* Some register need to be cache before suspend */
> +	u32				reg_gen;
> +
> +	/* Last member of the structure */
> +	struct tegra_dma_channel channels[0];
> +};
> +
> +static inline void tdma_write(struct tegra_dma *tdma, u32 reg, u32 val)
> +{
> +	writel(val, tdma->base_addr + reg);
> +}
> +
> +static inline u32 tdma_read(struct tegra_dma *tdma, u32 reg)
> +{
> +	return readl(tdma->base_addr + reg);
> +}
> +
> +static inline void tdc_write(struct tegra_dma_channel *tdc,
> +		u32 reg, u32 val)
> +{
> +	writel(val, tdc->tdma->base_addr + tdc->chan_base_offset + reg);
> +}
> +
> +static inline u32 tdc_read(struct tegra_dma_channel *tdc, u32 reg)
> +{
> +	return readl(tdc->tdma->base_addr + tdc->chan_base_offset + reg);
> +}
> +
> +static inline struct tegra_dma_channel *to_tegra_dma_chan(struct dma_chan *dc)
> +{
> +	return container_of(dc, struct tegra_dma_channel, dma_chan);
> +}
> +
> +static inline struct tegra_dma_desc *txd_to_tegra_dma_desc(
> +		struct dma_async_tx_descriptor *td)
> +{
> +	return container_of(td, struct tegra_dma_desc, txd);
> +}
> +
> +static inline struct device *tdc2dev(struct tegra_dma_channel *tdc)
> +{
> +	return &tdc->dma_chan.dev->device;
> +}
> +
> +static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *tx);
> +static int tegra_dma_runtime_suspend(struct device *dev);
> +static int tegra_dma_runtime_resume(struct device *dev);
> +
> +static int allocate_tegra_desc(struct tegra_dma_channel *tdc,
> +		int ndma_desc, int nsg_req)
pls follow single convention for naming in driver eithe xxx_tegra_yyy or
tegra_xxx_yyy... BUT not both!
> +{
> +	int i;
> +	struct tegra_dma_desc *dma_desc;
> +	struct tegra_dma_sg_req *sg_req;
> +	struct dma_chan *dc = &tdc->dma_chan;
> +	struct list_head dma_desc_list;
> +	struct list_head sg_req_list;
> +	unsigned long flags;
> +
> +	INIT_LIST_HEAD(&dma_desc_list);
> +	INIT_LIST_HEAD(&sg_req_list);
> +
> +	/* Initialize DMA descriptors */
> +	for (i = 0; i < ndma_desc; ++i) {
> +		dma_desc = kzalloc(sizeof(struct tegra_dma_desc), GFP_ATOMIC);
kernel convention is kzalloc(sizeof(*dma_desc),....
> +		if (!dma_desc) {
> +			dev_err(tdc2dev(tdc),
> +				"%s(): Memory allocation fails\n", __func__);
> +			goto fail_alloc;
> +		}
> +
> +		dma_async_tx_descriptor_init(&dma_desc->txd, dc);
> +		dma_desc->txd.tx_submit = tegra_dma_tx_submit;
> +		dma_desc->txd.flags = DMA_CTRL_ACK;
> +		list_add_tail(&dma_desc->node, &dma_desc_list);
> +	}
> +
> +	/* Initialize req descriptors */
> +	for (i = 0; i < nsg_req; ++i) {
> +		sg_req = kzalloc(sizeof(struct tegra_dma_sg_req), GFP_ATOMIC);
> +		if (!sg_req) {
> +			dev_err(tdc2dev(tdc),
> +				"%s(): Memory allocation fails\n", __func__);
> +			goto fail_alloc;
> +		}
> +		list_add_tail(&sg_req->node, &sg_req_list);
> +	}
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (ndma_desc) {
> +		tdc->descs_allocated += ndma_desc;
> +		list_splice(&dma_desc_list, &tdc->free_dma_desc);
> +	}
> +
> +	if (nsg_req)
> +		list_splice(&sg_req_list, &tdc->free_sg_req);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return tdc->descs_allocated;
> +
> +fail_alloc:
> +	while (!list_empty(&dma_desc_list)) {
> +		dma_desc = list_first_entry(&dma_desc_list,
> +					typeof(*dma_desc), node);
> +		list_del(&dma_desc->node);
> +	}
> +
> +	while (!list_empty(&sg_req_list)) {
> +		sg_req = list_first_entry(&sg_req_list, typeof(*sg_req), node);
> +		list_del(&sg_req->node);
> +	}
> +	return 0;
> +}
> +
> +/* Get DMA desc from free list, if not there then allocate it */
> +static struct tegra_dma_desc *tegra_dma_desc_get(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_desc *dma_desc = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +
> +	/* Check from free list desc */
> +	if (!list_empty(&tdc->free_dma_desc)) {
> +		dma_desc = list_first_entry(&tdc->free_dma_desc,
> +					typeof(*dma_desc), node);
> +		list_del(&dma_desc->node);
> +		goto end;
> +	}
sorry I dont like this jumping and returning for two lines of code.
Makes much sense to return from here.
> +
> +	/*
> +	 * Check list with desc which are waiting for ack, may be it
> +	 * got acked from client.
> +	 */
> +	if (!list_empty(&tdc->wait_ack_dma_desc)) {
> +		list_for_each_entry(dma_desc, &tdc->wait_ack_dma_desc, node) {
> +			if (async_tx_test_ack(&dma_desc->txd)) {
> +				list_del(&dma_desc->node);
> +				goto end;
> +			}
> +		}
> +	}
> +
> +	/* There is no free desc, allocate it */
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	dev_dbg(tdc2dev(tdc),
> +		"Allocating more descriptors for channel %d\n", tdc->id);
> +	allocate_tegra_desc(tdc, DMA_NR_DESCS_PER_CHANNEL,
> +				DMA_NR_DESCS_PER_CHANNEL * DMA_NR_REQ_PER_DESC);
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->free_dma_desc))
> +		goto end;
> +
> +	dma_desc = list_first_entry(&tdc->free_dma_desc,
> +					typeof(*dma_desc), node);
> +	list_del(&dma_desc->node);
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return dma_desc;
> +}
> +
> +static void tegra_dma_desc_put(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_desc *dma_desc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (!list_empty(&dma_desc->tx_list))
> +		list_splice_init(&dma_desc->tx_list, &tdc->free_sg_req);
> +	list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +}
> +
> +static void tegra_dma_desc_done_locked(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_desc *dma_desc)
> +{
> +	if (dma_desc->ack_reqd)
> +		list_add_tail(&dma_desc->node, &tdc->wait_ack_dma_desc);
what does ack_reqd mean?
Do you ahve unlocked version of this function, name suggests so...
> +	else
> +		list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
> +}
> +
> +static struct tegra_dma_sg_req *tegra_dma_sg_req_get(
> +		struct tegra_dma_channel *tdc)
in this and other functions, you have used goto to unlock and return.
Rather than that why don't you simplify code by calling these while
holding lock
> +{
> +	struct tegra_dma_sg_req *sg_req = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->free_sg_req)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		dev_dbg(tdc2dev(tdc),
> +			"Reallocating sg_req for channel %d\n", tdc->id);
> +		allocate_tegra_desc(tdc, 0,
> +				DMA_NR_DESCS_PER_CHANNEL * DMA_NR_REQ_PER_DESC);
> +		spin_lock_irqsave(&tdc->lock, flags);
> +		if (list_empty(&tdc->free_sg_req)) {
> +			dev_dbg(tdc2dev(tdc),
> +			"Not found free sg_req for channel %d\n", tdc->id);
> +			goto end;
> +		}
> +	}
> +
> +	sg_req = list_first_entry(&tdc->free_sg_req, typeof(*sg_req), node);
> +	list_del(&sg_req->node);
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return sg_req;
> +}
[snip]

> +
> +static void tegra_dma_abort_all(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +	while (!list_empty(&tdc->pending_sg_req)) {
> +		sgreq = list_first_entry(&tdc->pending_sg_req,
> +						typeof(*sgreq), node);
> +		list_del(&sgreq->node);
> +		list_add_tail(&sgreq->node, &tdc->free_sg_req);
> +		if (sgreq->last_sg) {
> +			dma_desc = sgreq->dma_desc;
> +			dma_desc->dma_status = DMA_ERROR;
> +			tegra_dma_desc_done_locked(tdc, dma_desc);
> +
> +			/* Add in cb list if it is not there. */
> +			if (!dma_desc->cb_due) {
> +				list_add_tail(&dma_desc->cb_node,
> +							&tdc->cb_desc);
> +				dma_desc->cb_due = true;
> +			}
> +			dma_cookie_complete(&dma_desc->txd);
does this make sense. You are marking an aborted descriptor as complete.
> +		}
> +	}
> +	tdc->dma_mode = DMA_MODE_NONE;
> +}
> +
> +static bool handle_continuous_head_request(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_sg_req *last_sg_req, bool to_terminate)
> +{
> +	struct tegra_dma_sg_req *hsgreq = NULL;
> +
> +	if (list_empty(&tdc->pending_sg_req)) {
> +		dev_err(tdc2dev(tdc),
> +			"%s(): Dma is running without any req list\n",
> +			__func__);
this is just waste of real estate and very ugly. Move them to 1/2 lines.
> +		tegra_dma_stop(tdc);
> +		return false;
> +	}
> +
> +	/*
> +	 * Check that head req on list should be in flight.
> +	 * If it is not in flight then abort transfer as
> +	 * transfer looping can not continue.
> +	 */
> +	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
> +	if (!hsgreq->configured) {
> +		tegra_dma_stop(tdc);
> +		dev_err(tdc2dev(tdc),
> +			"Error in dma transfer loop, aborting dma\n");
> +		tegra_dma_abort_all(tdc);
> +		return false;
> +	}
> +
> +	/* Configure next request in single buffer mode */
> +	if (!to_terminate && (tdc->dma_mode == DMA_MODE_CYCLE))
> +		tdc_configure_next_head_desc(tdc);
> +	return true;
> +}
> +
> +static void tegra_dma_tasklet(unsigned long data)
> +{
> +	struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
> +	unsigned long flags;
> +	dma_async_tx_callback callback = NULL;
> +	void *callback_param = NULL;
> +	struct tegra_dma_desc *dma_desc;
> +	struct list_head cb_dma_desc_list;
> +
> +	INIT_LIST_HEAD(&cb_dma_desc_list);
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->cb_desc)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		return;
> +	}
> +	list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +
> +	while (!list_empty(&cb_dma_desc_list)) {
> +		dma_desc  = list_first_entry(&cb_dma_desc_list,
> +				typeof(*dma_desc), cb_node);
> +		list_del(&dma_desc->cb_node);
> +
> +		callback = dma_desc->txd.callback;
> +		callback_param = dma_desc->txd.callback_param;
> +		dma_desc->cb_due = false;
> +		if (callback)
> +			callback(callback_param);
You should mark the descriptor as complete before calling callback.
Also tasklet is supposed to move the next pending descriptor to the
engine, I dont see that happening here?
> +	}
> +}
> +
> +static void tegra_dma_terminate_all(struct dma_chan *dc)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +	unsigned long flags;
> +	unsigned long status;
> +	struct list_head new_list;
> +	dma_async_tx_callback callback = NULL;
> +	void *callback_param = NULL;
> +	struct list_head cb_dma_desc_list;
> +	bool was_busy;
> +
> +	INIT_LIST_HEAD(&new_list);
> +	INIT_LIST_HEAD(&cb_dma_desc_list);
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->pending_sg_req)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		return;
> +	}
> +
> +	if (!tdc->busy) {
> +		list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +		goto skip_dma_stop;
> +	}
> +
> +	/* Pause DMA before checking the queue status */
> +	tegra_dma_pause(tdc, true);
> +
> +	status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	if (status & STA_ISE_EOC) {
> +		dev_dbg(tdc2dev(tdc), "%s():handling isr\n", __func__);
> +		tdc->isr_handler(tdc, true);
> +		status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	}
> +	list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +
> +	was_busy = tdc->busy;
> +	tegra_dma_stop(tdc);
> +	if (!list_empty(&tdc->pending_sg_req) && was_busy) {
> +		sgreq = list_first_entry(&tdc->pending_sg_req,
> +					typeof(*sgreq), node);
> +		sgreq->dma_desc->bytes_transferred +=
> +				get_current_xferred_count(tdc, sgreq, status);
> +	}
> +	tegra_dma_resume(tdc);
> +
> +skip_dma_stop:
> +	tegra_dma_abort_all(tdc);
> +	/* Ignore callbacks pending list */
> +	INIT_LIST_HEAD(&tdc->cb_desc);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +
> +	/* Call callbacks if was pending before aborting requests */
> +	while (!list_empty(&cb_dma_desc_list)) {
> +		dma_desc  = list_first_entry(&cb_dma_desc_list,
> +				typeof(*dma_desc), cb_node);
> +		list_del(&dma_desc->cb_node);
> +		callback = dma_desc->txd.callback;
> +		callback_param = dma_desc->txd.callback_param;
again, callback would be called from tasklet, so why would it need to be
called from here , and why would this be pending.
> +		if (callback)
> +			callback(callback_param);
> +	}
> +}
> +
> +
-- 
~Vinod

