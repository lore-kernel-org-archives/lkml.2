Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0HWRs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:48:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52364 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0HWRsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:48:55 -0400
Date: Mon, 23 Aug 2010 19:48:52 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100823174852.GB26928@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-4-git-send-email-s.hauer@pengutronix.de> <20100823125704.GU27749@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100823125704.GU27749@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Sascha,

On Mon, Aug 23, 2010 at 02:57:04PM +0200, Sascha Hauer wrote:
> 
> This patch adds support for the Freescale i.MX SDMA engine.
> 
> The SDMA engine is a scatter/gather DMA engine which is implemented
> as a seperate coprocessor. SDMA needs its own firmware which is
> requested using the standard request_firmware mechanism. The firmware
> has different entry points for each peripheral type, so drivers
> have to pass the peripheral type to the DMA engine which in turn
> picks the correct firmware entry point from a table contained in
> the firmware image itself.
> The original Freescale code also supports support for transfering
> data to the internal SRAM which needs different entry points to
> the firmware. Support for this is currently not implemented. Also,
> support for the ASRC (asymmetric sample rate converter) is skipped.
> 
> I took a very simple approach to implement dmaengine support. Only
> a single descriptor is statically assigned to a each channel. This
> means that transfers can't be queued up but only a single transfer
> is in progress. This simplifies implementation a lot and is sufficient
> for the usual device/memory transfers.
> 
> Changes since v1:
> 
> - included comments from Linus Walleij
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  arch/arm/mach-imx/include/mach/dma-v1.h |    8 +-
>  arch/arm/mach-mx3/Kconfig               |    2 +
>  arch/arm/plat-mxc/Kconfig               |   10 +
>  arch/arm/plat-mxc/include/mach/dma.h    |   64 ++
>  arch/arm/plat-mxc/include/mach/sdma.h   |   17 +
>  drivers/dma/Kconfig                     |    8 +
>  drivers/dma/Makefile                    |    1 +
>  drivers/dma/imx-sdma.c                  | 1395 +++++++++++++++++++++++++++++++
>  8 files changed, 1499 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/dma.h
>  create mode 100644 arch/arm/plat-mxc/include/mach/sdma.h
>  create mode 100644 drivers/dma/imx-sdma.c
> 
> diff --git a/arch/arm/mach-imx/include/mach/dma-v1.h b/arch/arm/mach-imx/include/mach/dma-v1.h
> index 287431c..ac6fd71 100644
> --- a/arch/arm/mach-imx/include/mach/dma-v1.h
> +++ b/arch/arm/mach-imx/include/mach/dma-v1.h
> @@ -27,6 +27,8 @@
>  
>  #define imx_has_dma_v1()	(cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
>  
> +#include <mach/dma.h>
> +
>  #define IMX_DMA_CHANNELS  16
>  
>  #define DMA_MODE_READ		0
> @@ -96,12 +98,6 @@ int imx_dma_request(int channel, const char *name);
>  
>  void imx_dma_free(int channel);
>  
> -enum imx_dma_prio {
> -	DMA_PRIO_HIGH = 0,
> -	DMA_PRIO_MEDIUM = 1,
> -	DMA_PRIO_LOW = 2
> -};
> -
>  int imx_dma_request_by_prio(const char *name, enum imx_dma_prio prio);
>  
>  #endif	/* __MACH_DMA_V1_H__ */
> diff --git a/arch/arm/mach-mx3/Kconfig b/arch/arm/mach-mx3/Kconfig
> index 85beece..301375c 100644
> --- a/arch/arm/mach-mx3/Kconfig
> +++ b/arch/arm/mach-mx3/Kconfig
> @@ -3,12 +3,14 @@ if ARCH_MX3
>  config ARCH_MX31
>  	select ARCH_HAS_RNGA
>  	select ARCH_MXC_AUDMUX_V2
> +	select IMX_HAVE_SDMA
>  	bool
>  
>  config ARCH_MX35
>  	bool
>  	select ARCH_MXC_IOMUX_V3
>  	select ARCH_MXC_AUDMUX_V2
> +	select IMX_HAVE_SDMA
>  
>  comment "MX3 platforms:"
>  
> diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> index 0527e65..6741625 100644
> --- a/arch/arm/plat-mxc/Kconfig
> +++ b/arch/arm/plat-mxc/Kconfig
> @@ -109,4 +109,14 @@ config ARCH_MXC_AUDMUX_V1
>  config ARCH_MXC_AUDMUX_V2
>  	bool
>  
> +config IMX_HAVE_SDMA
> +	bool
> +
> +config IMX_SDMA
> +	depends on IMX_HAVE_SDMA
> +	tristate "Enable SDMA support"
> +	help
> +	  Include support for the SDMA engine. The SDMA engine needs additional
> +	  firmware support. SDMA can be compiled as a module to support loading
> +	  the firmware when a rootfs is present.
>  endif
> diff --git a/arch/arm/plat-mxc/include/mach/dma.h b/arch/arm/plat-mxc/include/mach/dma.h
> new file mode 100644
> index 0000000..69d181f
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/dma.h
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_ARCH_MXC_DMA_H__
> +#define __ASM_ARCH_MXC_DMA_H__
__MACH_DMA_H__ please

> +
> +#include <linux/scatterlist.h>
> +
> +/*
> + * This enumerates peripheral types. Used for SDMA.
> + */
> +enum sdma_peripheral_type {
> +	IMX_DMATYPE_SSI,	/* MCU domain SSI */
> +	IMX_DMATYPE_SSI_SP,	/* Shared SSI */
> +	IMX_DMATYPE_MMC,	/* MMC */
> +	IMX_DMATYPE_SDHC,	/* SDHC */
> +	IMX_DMATYPE_UART,	/* MCU domain UART */
> +	IMX_DMATYPE_UART_SP,	/* Shared UART */
> +	IMX_DMATYPE_FIRI,	/* FIRI */
> +	IMX_DMATYPE_CSPI,	/* MCU domain CSPI */
> +	IMX_DMATYPE_CSPI_SP,	/* Shared CSPI */
> +	IMX_DMATYPE_SIM,	/* SIM */
> +	IMX_DMATYPE_ATA,	/* ATA */
> +	IMX_DMATYPE_CCM,	/* CCM */
> +	IMX_DMATYPE_EXT,	/* External peripheral */
> +	IMX_DMATYPE_MSHC,	/* Memory Stick Host Controller */
> +	IMX_DMATYPE_MSHC_SP,	/* Shared Memory Stick Host Controller */
> +	IMX_DMATYPE_DSP,	/* DSP */
> +	IMX_DMATYPE_MEMORY,	/* Memory */
> +	IMX_DMATYPE_FIFO_MEMORY,/* FIFO type Memory */
> +	IMX_DMATYPE_SPDIF,	/* SPDIF */
> +	IMX_DMATYPE_IPU_MEMORY,	/* IPU Memory */
> +	IMX_DMATYPE_ASRC,	/* ASRC */
> +	IMX_DMATYPE_ESAI,	/* ESAI */
> +};
> +
> +enum imx_dma_prio {
> +	DMA_PRIO_HIGH = 0,
> +	DMA_PRIO_MEDIUM = 1,
> +	DMA_PRIO_LOW = 2
> +};
> +
> +struct imx_dma_data {
> +	int dma_request; /* DMA request line */
> +	enum sdma_peripheral_type peripheral_type;
> +	int priority;
> +};
> +
> +static inline int imx_dma_is_ipu(struct dma_chan *chan)
> +{
> +	return !strcmp(dev_name(chan->device->dev), "ipu-core");
> +}
> +
> +static inline int imx_dma_is_general_purpose(struct dma_chan *chan)
> +{
> +	return !strcmp(dev_name(chan->device->dev), "imx-sdma");
> +}
> +
> +#endif
> diff --git a/arch/arm/plat-mxc/include/mach/sdma.h b/arch/arm/plat-mxc/include/mach/sdma.h
> new file mode 100644
> index 0000000..9be1122
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/sdma.h
> @@ -0,0 +1,17 @@
> +#ifndef __MACH_MXC_SDMA_H__
> +#define __MACH_MXC_SDMA_H__
__MACH_SDMA_H__

> +
> +/**
> + * struct sdma_platform_data - platform specific data for SDMA engine
> + *
> + * @sdma_version	The version of this SDMA engine
> + * @cpu_name		used to generate the firmware name
> + * @to_version		CPU Tape out version
> + */
> +struct sdma_platform_data {
> +	int sdma_version;
> +	char *cpu_name;
> +	int to_version;
> +};
> +
> +#endif /* __MACH_MXC_SDMA_H__ */
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 9520cf0..ff68307 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -195,6 +195,14 @@ config PCH_DMA
>  	help
>  	  Enable support for the Topcliff PCH DMA engine.
>  
> +config IMX_SDMA
> +	tristate "i.MX SDMA support"
> +	depends on ARCH_MXC
> +	select DMA_ENGINE
> +	help
> +	  Support the i.MX SDMA engine. This engine is integrated into
> +	  Freescale i.MX25/31/35/51 chips.
> +
>  config DMA_ENGINE
>  	bool
>  
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 72bd703..14d7a1b 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -25,3 +25,4 @@ obj-$(CONFIG_TIMB_DMA) += timb_dma.o
>  obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
>  obj-$(CONFIG_PL330_DMA) += pl330.o
>  obj-$(CONFIG_PCH_DMA) += pch_dma.o
> +obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> new file mode 100644
> index 0000000..c447fc0
> --- /dev/null
> +++ b/drivers/dma/imx-sdma.c
> @@ -0,0 +1,1395 @@
> +/*
> + * drivers/dma/imx-sdma.c
> + *
> + * This file contains a driver for the Freescale Smart DMA engine
> + *
> + * Copyright 2010 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
> + *
> + * Based on code from Freescale:
> + *
> + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/mm.h>
> +#include <linux/interrupt.h>
> +#include <linux/clk.h>
> +#include <linux/wait.h>
> +#include <linux/sched.h>
> +#include <linux/semaphore.h>
> +#include <linux/spinlock.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/firmware.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/dmaengine.h>
> +
> +#include <asm/irq.h>
> +#include <mach/sdma.h>
> +#include <mach/dma.h>
> +#include <mach/hardware.h>
> +
> +/* SDMA registers */
> +#define SDMA_H_C0PTR		(sdma->regs + 0x000)
> +#define SDMA_H_INTR		(sdma->regs + 0x004)
> +#define SDMA_H_STATSTOP		(sdma->regs + 0x008)
> +#define SDMA_H_START		(sdma->regs + 0x00c)
> +#define SDMA_H_EVTOVR		(sdma->regs + 0x010)
> +#define SDMA_H_DSPOVR		(sdma->regs + 0x014)
> +#define SDMA_H_HOSTOVR		(sdma->regs + 0x018)
> +#define SDMA_H_EVTPEND		(sdma->regs + 0x01c)
> +#define SDMA_H_DSPENBL		(sdma->regs + 0x020)
> +#define SDMA_H_RESET		(sdma->regs + 0x024)
> +#define SDMA_H_EVTERR		(sdma->regs + 0x028)
> +#define SDMA_H_INTRMSK		(sdma->regs + 0x02c)
> +#define SDMA_H_PSW		(sdma->regs + 0x030)
> +#define SDMA_H_EVTERRDBG	(sdma->regs + 0x034)
> +#define SDMA_H_CONFIG		(sdma->regs + 0x038)
> +#define SDMA_ONCE_ENB		(sdma->regs + 0x040)
> +#define SDMA_ONCE_DATA		(sdma->regs + 0x044)
> +#define SDMA_ONCE_INSTR		(sdma->regs + 0x048)
> +#define SDMA_ONCE_STAT		(sdma->regs + 0x04c)
> +#define SDMA_ONCE_CMD		(sdma->regs + 0x050)
> +#define SDMA_EVT_MIRROR		(sdma->regs + 0x054)
> +#define SDMA_ILLINSTADDR	(sdma->regs + 0x058)
> +#define SDMA_CHN0ADDR		(sdma->regs + 0x05c)
> +#define SDMA_ONCE_RTB		(sdma->regs + 0x060)
> +#define SDMA_XTRIG_CONF1	(sdma->regs + 0x070)
> +#define SDMA_XTRIG_CONF2	(sdma->regs + 0x074)
> +#define SDMA_CHNENBL_0		(sdma->regs + (sdma->version == 2 ? 0x200 : 0x80))
> +#define SDMA_CHNPRI_0		(sdma->regs + 0x100)
I'd prefer having an accessor function like

	u32 sdma_read(struct whatever *sdma, unsigned offset)
	{
		return __raw_readl(sdma->regs + offset);
	}
	...

> +
> +/*
> + * Buffer descriptor status values.
> + */
> +#define BD_DONE  0x01
> +#define BD_WRAP  0x02
> +#define BD_CONT  0x04
> +#define BD_INTR  0x08
> +#define BD_RROR  0x10
> +#define BD_LAST  0x20
> +#define BD_EXTD  0x80
> +
> +/*
> + * Data Node descriptor status values.
> + */
> +#define DND_END_OF_FRAME  0x80
> +#define DND_END_OF_XFER   0x40
> +#define DND_DONE          0x20
> +#define DND_UNUSED        0x01
> +
> +/*
> + * IPCV2 descriptor status values.
> + */
> +#define BD_IPCV2_END_OF_FRAME  0x40
> +
> +#define IPCV2_MAX_NODES        50
> +/*
> + * Error bit set in the CCB status field by the SDMA,
> + * in setbd routine, in case of a transfer error
> + */
> +#define DATA_ERROR  0x10000000
> +
> +/*
> + * Buffer descriptor commands.
> + */
> +#define C0_ADDR             0x01
> +#define C0_LOAD             0x02
> +#define C0_DUMP             0x03
> +#define C0_SETCTX           0x07
> +#define C0_GETCTX           0x03
> +#define C0_SETDM            0x01
> +#define C0_SETPM            0x04
> +#define C0_GETDM            0x02
> +#define C0_GETPM            0x08
> +/*
> + * Change endianness indicator in the BD command field
> + */
> +#define CHANGE_ENDIANNESS   0x80
> +
> +/*
> + * Mode/Count of data node descriptors - IPCv2
> + */
> +struct sdma_mode_count {
> +	u32 count   : 16; /* size of the buffer pointed by this BD */
> +	u32 status  :  8; /* E,R,I,C,W,D status bits stored here */
> +	u32 command :  8; /* command mostlky used for channel 0 */
s/mostlky/mostly/

> +};
> +
> +/*
> + * Buffer descriptor
> + */
> +struct sdma_buffer_descriptor {
> +	struct sdma_mode_count  mode;
> +	dma_addr_t buffer_addr;    /* address of the buffer described */
> +	dma_addr_t ext_buffer_addr; /* extended buffer address */
> +} __attribute__ ((packed));
> +
> +/*
> + * Channel control Block
> + */
> +struct sdma_channel_control {
> +	dma_addr_t current_bd_ptr; /* current buffer descriptor processed */
> +	dma_addr_t base_bd_ptr;    /* first element of buffer descriptor array */
> +	u32 unused;
> +	u32 unused1;
> +} __attribute__ ((packed));
> +
> +/**
> + * struct sdma_state_registers - SDMA context for a channel
> + *
> + * @pc:		program counter
> + * @t:		test bit: status of arithmetic & test instruction
> + * @rpc:	return program counter
> + * @sf:		source fault while loading data
> + * @spc:	loop start program counter
> + * @df:		destination fault while storing data
> + * @epc:	loop end program counter
> + * @lm:		loop mode
> + */
> +struct sdma_state_registers {
> +	u32 pc     :14;
> +	u32 unused1: 1;
> +	u32 t      : 1;
> +	u32 rpc    :14;
> +	u32 unused0: 1;
> +	u32 sf     : 1;
> +	u32 spc    :14;
> +	u32 unused2: 1;
> +	u32 df     : 1;
> +	u32 epc    :14;
> +	u32 lm     : 2;
> +} __attribute__ ((packed));
I'm not sure what CodingStyle recommends, but I'd not add a space
between __attribute__ and (.
> +
> +/**
> + * struct sdma_context_data - sdma context specific to a channel
> + *
> + * @channel_state:	channel state bits
> + * @gReg:		general registers
> + * @mda:		burst dma destination address register
> + * @msa:		burst dma source address register
> + * @ms:			burst dma status register
> + * @md:			burst dma data register
> + * @pda:		peripheral dma destination address register
> + * @psa:		peripheral dma source address register
> + * @ps:			peripheral dma status register
> + * @pd:			peripheral dma data register
> + * @ca:			CRC polynomial register
> + * @cs:			CRC accumulator register
> + * @dda:		dedicated core destination address register
> + * @dsa:		dedicated core source address register
> + * @ds:			dedicated core status register
> + * @dd:			dedicated core data register
> + */
> +struct sdma_context_data {
> +	struct sdma_state_registers  channel_state;
> +	u32  gReg[8];
> +	u32  mda;
> +	u32  msa;
> +	u32  ms;
> +	u32  md;
> +	u32  pda;
> +	u32  psa;
> +	u32  ps;
> +	u32  pd;
> +	u32  ca;
> +	u32  cs;
> +	u32  dda;
> +	u32  dsa;
> +	u32  ds;
> +	u32  dd;
> +	u32  scratch0;
> +	u32  scratch1;
> +	u32  scratch2;
> +	u32  scratch3;
> +	u32  scratch4;
> +	u32  scratch5;
> +	u32  scratch6;
> +	u32  scratch7;
> +} __attribute__ ((packed));
s/  / /?

> +
> +#define NUM_BD (int)(PAGE_SIZE / sizeof(struct sdma_buffer_descriptor))
> +
> +struct sdma_engine;
> +
> +/**
> + * struct sdma_channel - housekeeping for a SDMA channel
> + *
> + * @sdma		pointer to the SDMA engine for this channel
> + * @channel		the channel number, matches dmaengine chan_id
> + * @direction		transfer type. Needed for setting SDMA script
> + * @peripheral_type	Peripheral type. Needed for setting SDMA script
> + * @event_id		aka dma request line
> + * @event_id2		for channels that use 2 events
> + * @word_size		peripheral access size
> + * @buf_tail		ID of the buffer that was processed
> + * @done		channel completion
> + * @num_bd		max NUM_BD. number of descriptors currently handling
> + */
> +struct sdma_channel {
> +	struct sdma_engine		*sdma;
> +	unsigned int			channel;
> +	enum dma_data_direction		direction;
> +	enum sdma_peripheral_type	peripheral_type;
> +	unsigned int			event_id;
> +	unsigned int			event_id2;
> +	enum dma_slave_buswidth		word_size;
> +	unsigned int			buf_tail;
> +	struct completion		done;
> +	unsigned int			num_bd;
> +	struct sdma_buffer_descriptor	*bd;
> +	dma_addr_t			bd_phys;
> +	unsigned int			pc_from_device, pc_to_device;
> +	unsigned long			flags;
> +	dma_addr_t			per_address;
> +	u32				event_mask1, event_mask2;
> +	u32				watermark_level;
> +	u32				shp_addr, per_addr;
> +	struct dma_chan			chan;
> +	spinlock_t			lock;
> +	struct dma_async_tx_descriptor	desc;
> +	dma_cookie_t			last_completed;
> +	enum dma_status			status;
> +};
> +
> +#define IMX_DMA_SG_LOOP		(1 << 0)
> +
> +#define MAX_DMA_CHANNELS 32
> +#define MXC_SDMA_DEFAULT_PRIORITY 1
> +#define MXC_SDMA_MIN_PRIORITY 1
> +#define MXC_SDMA_MAX_PRIORITY 7
> +
> +/*
> + * This enumerates transfer types
> + */
> +enum {
> +	emi_2_per = 0,		/* EMI memory to peripheral */
> +	emi_2_int,		/* EMI memory to internal RAM */
> +	emi_2_emi,		/* EMI memory to EMI memory */
> +	emi_2_dsp,		/* EMI memory to DSP memory */
> +	per_2_int,		/* Peripheral to internal RAM */
s/int/iram/ maybe?

> +	per_2_emi,		/* Peripheral to internal EMI memory */
> +	per_2_dsp,		/* Peripheral to DSP memory */
> +	per_2_per,		/* Peripheral to Peripheral */
> +	int_2_per,		/* Internal RAM to peripheral */
> +	int_2_int,		/* Internal RAM to Internal RAM */
> +	int_2_emi,		/* Internal RAM to EMI memory */
> +	int_2_dsp,		/* Internal RAM to DSP memory */
> +	dsp_2_per,		/* DSP memory to peripheral */
> +	dsp_2_int,		/* DSP memory to internal RAM */
> +	dsp_2_emi,		/* DSP memory to EMI memory */
> +	dsp_2_dsp,		/* DSP memory to DSP memory */
> +	emi_2_dsp_loop,		/* EMI memory to DSP memory loopback */
> +	dsp_2_emi_loop,		/* DSP memory to EMI memory loopback */
> +	dvfs_pll,		/* DVFS script with PLL change       */
> +	dvfs_pdr		/* DVFS script without PLL change    */
> +} sdma_transfer_type;
> +
> +/**
> + * struct sdma_script_start_addrs - SDMA script start pointers
> + *
> + * start addresses of the different functions in the physical
> + * address space of the SDMA engine.
> + */
> +struct sdma_script_start_addrs {
> +	u32 ap_2_ap_addr;
> +	u32 ap_2_bp_addr;
> +	u32 ap_2_ap_fixed_addr;
> +	u32 bp_2_ap_addr;
> +	u32 loopback_on_dsp_side_addr;
> +	u32 mcu_interrupt_only_addr;
> +	u32 firi_2_per_addr;
> +	u32 firi_2_mcu_addr;
> +	u32 per_2_firi_addr;
> +	u32 mcu_2_firi_addr;
> +	u32 uart_2_per_addr;
> +	u32 uart_2_mcu_addr;
> +	u32 per_2_app_addr;
> +	u32 mcu_2_app_addr;
> +	u32 per_2_per_addr;
> +	u32 uartsh_2_per_addr;
> +	u32 uartsh_2_mcu_addr;
> +	u32 per_2_shp_addr;
> +	u32 mcu_2_shp_addr;
> +	u32 ata_2_mcu_addr;
> +	u32 mcu_2_ata_addr;
> +	u32 app_2_per_addr;
> +	u32 app_2_mcu_addr;
> +	u32 shp_2_per_addr;
> +	u32 shp_2_mcu_addr;
> +	u32 mshc_2_mcu_addr;
> +	u32 mcu_2_mshc_addr;
> +	u32 spdif_2_mcu_addr;
> +	u32 mcu_2_spdif_addr;
> +	u32 asrc_2_mcu_addr;
> +	u32 ext_mem_2_ipu_addr;
> +	u32 descrambler_addr;
> +	u32 dptc_dvfs_addr;
> +	u32 utra_addr;
> +	u32 ram_code_start_addr;
> +};
You didn't comment my suggestion to use an array here.  Something like

	struct {
		const char *name;
		u32 addr;
	} start_addr[];
> +
> +#define SDMA_FIRMWARE_MAGIC 0x414d4453
> +
> +/**
> + * struct sdma_firmware_header - Layout of the firmware image
> + *
> + * @magic		"SDMA"
> + * @version_major	increased whenever layout of struct sdma_script_start_addrs
> + *			changes.
> + * @version_minor	firmware minor version (for binary compatible changes)
> + * @script_addrs_start	offset of struct sdma_script_start_addrs in this image
> + * @num_script_addrs	Number of script addresses in this image
> + * @ram_code_start	offset of SDMA ram image in this firmware image
> + * @ram_code_size	size of SDMA ram image
> + */
> +struct sdma_firmware_header {
> +	u32	magic;
> +	u32	version_major;
> +	u32	version_minor;
> +	u32	script_addrs_start;
> +	u32	num_script_addrs;
> +	u32	ram_code_start;
> +	u32	ram_code_size;
> +};
> +
> +struct sdma_engine {
> +	struct device			*dev;
> +	struct sdma_channel		channel[MAX_DMA_CHANNELS];
> +	struct sdma_channel_control	*channel_control;
> +	void __iomem			*regs;
> +	unsigned int			version;
> +	unsigned int			num_events;
> +	struct sdma_context_data	*context;
> +	dma_addr_t			context_phys;
> +	struct dma_device		dma_device;
> +	struct clk			*clk;
> +};
> +
> +#define SDMA_H_CONFIG_DSPDMA	(1 << 12) /* indicates if the DSPDMA is used */
> +#define SDMA_H_CONFIG_RTD_PINS	(1 << 11) /* indicates if Real-Time Debug pins are enabled */
> +#define SDMA_H_CONFIG_ACR	(1 << 4)  /* indicates if AHB freq /core freq = 2 or 1 */
> +#define SDMA_H_CONFIG_CSM	(3)       /* indicates which context switch mode is selected*/
> +
> +static int sdma_config_ownership(struct sdma_channel *sdmac,
> +		bool event_override, bool mcu_verride, bool dsp_override)
> +{
> +	struct sdma_engine *sdma = sdmac->sdma;
> +	int channel = sdmac->channel;
> +	u32 evt, mcu, dsp;
> +
> +	if (event_override && mcu_verride && dsp_override)
> +		return -EINVAL;
> +
> +	evt = readl(SDMA_H_EVTOVR);
> +	mcu = readl(SDMA_H_HOSTOVR);
> +	dsp = readl(SDMA_H_DSPOVR);
__raw_readl?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
