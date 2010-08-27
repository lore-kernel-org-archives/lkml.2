Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0H0MWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:22:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0H0MWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:22:35 -0400
Date: Fri, 27 Aug 2010 14:22:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3 v3] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100827122230.GF1473@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:20:24 up 55 days,  3:31, 39 users,  load average: 0.59, 0.73,
	0.80
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Freescale i.MX SDMA engine.

The SDMA engine is a scatter/gather DMA engine which is implemented
as a seperate coprocessor. SDMA needs its own firmware which is
requested using the standard request_firmware mechanism. The firmware
has different entry points for each peripheral type, so drivers
have to pass the peripheral type to the DMA engine which in turn
picks the correct firmware entry point from a table contained in
the firmware image itself.
The original Freescale code also supports support for transfering
data to the internal SRAM which needs different entry points to
the firmware. Support for this is currently not implemented. Also,
support for the ASRC (asymmetric sample rate converter) is skipped.

I took a very simple approach to implement dmaengine support. Only
a single descriptor is statically assigned to a each channel. This
means that transfers can't be queued up but only a single transfer
is in progress. This simplifies implementation a lot and is sufficient
for the usual device/memory transfers.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Linus Walleij <linus.ml.walleij@gmail.com>
---

changes since v2:

- use __raw_readl/__raw_writel
- use __init/__exit instead of __devinit/__devexit
- use request_mem_region.

 arch/arm/mach-imx/include/mach/dma-v1.h |    8 +-
 arch/arm/mach-mx3/Kconfig               |    2 +
 arch/arm/plat-mxc/Kconfig               |   10 +
 arch/arm/plat-mxc/include/mach/dma.h    |   64 ++
 arch/arm/plat-mxc/include/mach/sdma.h   |   17 +
 drivers/dma/Kconfig                     |    8 +
 drivers/dma/Makefile                    |    1 +
 drivers/dma/imx-sdma.c                  | 1392 +++++++++++++++++++++++++++++++
 8 files changed, 1496 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/dma.h
 create mode 100644 arch/arm/plat-mxc/include/mach/sdma.h
 create mode 100644 drivers/dma/imx-sdma.c

diff --git a/arch/arm/mach-imx/include/mach/dma-v1.h b/arch/arm/mach-imx/include/mach/dma-v1.h
index 287431c..ac6fd71 100644
--- a/arch/arm/mach-imx/include/mach/dma-v1.h
+++ b/arch/arm/mach-imx/include/mach/dma-v1.h
@@ -27,6 +27,8 @@
 
 #define imx_has_dma_v1()	(cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
 
+#include <mach/dma.h>
+
 #define IMX_DMA_CHANNELS  16
 
 #define DMA_MODE_READ		0
@@ -96,12 +98,6 @@ int imx_dma_request(int channel, const char *name);
 
 void imx_dma_free(int channel);
 
-enum imx_dma_prio {
-	DMA_PRIO_HIGH = 0,
-	DMA_PRIO_MEDIUM = 1,
-	DMA_PRIO_LOW = 2
-};
-
 int imx_dma_request_by_prio(const char *name, enum imx_dma_prio prio);
 
 #endif	/* __MACH_DMA_V1_H__ */
diff --git a/arch/arm/mach-mx3/Kconfig b/arch/arm/mach-mx3/Kconfig
index 85beece..301375c 100644
--- a/arch/arm/mach-mx3/Kconfig
+++ b/arch/arm/mach-mx3/Kconfig
@@ -3,12 +3,14 @@ if ARCH_MX3
 config ARCH_MX31
 	select ARCH_HAS_RNGA
 	select ARCH_MXC_AUDMUX_V2
+	select IMX_HAVE_SDMA
 	bool
 
 config ARCH_MX35
 	bool
 	select ARCH_MXC_IOMUX_V3
 	select ARCH_MXC_AUDMUX_V2
+	select IMX_HAVE_SDMA
 
 comment "MX3 platforms:"
 
diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index 0527e65..6741625 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -109,4 +109,14 @@ config ARCH_MXC_AUDMUX_V1
 config ARCH_MXC_AUDMUX_V2
 	bool
 
+config IMX_HAVE_SDMA
+	bool
+
+config IMX_SDMA
+	depends on IMX_HAVE_SDMA
+	tristate "Enable SDMA support"
+	help
+	  Include support for the SDMA engine. The SDMA engine needs additional
+	  firmware support. SDMA can be compiled as a module to support loading
+	  the firmware when a rootfs is present.
 endif
diff --git a/arch/arm/plat-mxc/include/mach/dma.h b/arch/arm/plat-mxc/include/mach/dma.h
new file mode 100644
index 0000000..69d181f
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/dma.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_MXC_DMA_H__
+#define __ASM_ARCH_MXC_DMA_H__
+
+#include <linux/scatterlist.h>
+
+/*
+ * This enumerates peripheral types. Used for SDMA.
+ */
+enum sdma_peripheral_type {
+	IMX_DMATYPE_SSI,	/* MCU domain SSI */
+	IMX_DMATYPE_SSI_SP,	/* Shared SSI */
+	IMX_DMATYPE_MMC,	/* MMC */
+	IMX_DMATYPE_SDHC,	/* SDHC */
+	IMX_DMATYPE_UART,	/* MCU domain UART */
+	IMX_DMATYPE_UART_SP,	/* Shared UART */
+	IMX_DMATYPE_FIRI,	/* FIRI */
+	IMX_DMATYPE_CSPI,	/* MCU domain CSPI */
+	IMX_DMATYPE_CSPI_SP,	/* Shared CSPI */
+	IMX_DMATYPE_SIM,	/* SIM */
+	IMX_DMATYPE_ATA,	/* ATA */
+	IMX_DMATYPE_CCM,	/* CCM */
+	IMX_DMATYPE_EXT,	/* External peripheral */
+	IMX_DMATYPE_MSHC,	/* Memory Stick Host Controller */
+	IMX_DMATYPE_MSHC_SP,	/* Shared Memory Stick Host Controller */
+	IMX_DMATYPE_DSP,	/* DSP */
+	IMX_DMATYPE_MEMORY,	/* Memory */
+	IMX_DMATYPE_FIFO_MEMORY,/* FIFO type Memory */
+	IMX_DMATYPE_SPDIF,	/* SPDIF */
+	IMX_DMATYPE_IPU_MEMORY,	/* IPU Memory */
+	IMX_DMATYPE_ASRC,	/* ASRC */
+	IMX_DMATYPE_ESAI,	/* ESAI */
+};
+
+enum imx_dma_prio {
+	DMA_PRIO_HIGH = 0,
+	DMA_PRIO_MEDIUM = 1,
+	DMA_PRIO_LOW = 2
+};
+
+struct imx_dma_data {
+	int dma_request; /* DMA request line */
+	enum sdma_peripheral_type peripheral_type;
+	int priority;
+};
+
+static inline int imx_dma_is_ipu(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "ipu-core");
+}
+
+static inline int imx_dma_is_general_purpose(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "imx-sdma");
+}
+
+#endif
diff --git a/arch/arm/plat-mxc/include/mach/sdma.h b/arch/arm/plat-mxc/include/mach/sdma.h
new file mode 100644
index 0000000..9be1122
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/sdma.h
@@ -0,0 +1,17 @@
+#ifndef __MACH_MXC_SDMA_H__
+#define __MACH_MXC_SDMA_H__
+
+/**
+ * struct sdma_platform_data - platform specific data for SDMA engine
+ *
+ * @sdma_version	The version of this SDMA engine
+ * @cpu_name		used to generate the firmware name
+ * @to_version		CPU Tape out version
+ */
+struct sdma_platform_data {
+	int sdma_version;
+	char *cpu_name;
+	int to_version;
+};
+
+#endif /* __MACH_MXC_SDMA_H__ */
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9520cf0..ff68307 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -195,6 +195,14 @@ config PCH_DMA
 	help
 	  Enable support for the Topcliff PCH DMA engine.
 
+config IMX_SDMA
+	tristate "i.MX SDMA support"
+	depends on ARCH_MXC
+	select DMA_ENGINE
+	help
+	  Support the i.MX SDMA engine. This engine is integrated into
+	  Freescale i.MX25/31/35/51 chips.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 72bd703..14d7a1b 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_TIMB_DMA) += timb_dma.o
 obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
 obj-$(CONFIG_PCH_DMA) += pch_dma.o
+obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
new file mode 100644
index 0000000..1dd0be1
--- /dev/null
+++ b/drivers/dma/imx-sdma.c
@@ -0,0 +1,1392 @@
+/*
+ * drivers/dma/imx-sdma.c
+ *
+ * This file contains a driver for the Freescale Smart DMA engine
+ *
+ * Copyright 2010 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ *
+ * Based on code from Freescale:
+ *
+ * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/dmaengine.h>
+
+#include <asm/irq.h>
+#include <mach/sdma.h>
+#include <mach/dma.h>
+#include <mach/hardware.h>
+
+/* SDMA registers */
+#define SDMA_H_C0PTR		0x000
+#define SDMA_H_INTR		0x004
+#define SDMA_H_STATSTOP		0x008
+#define SDMA_H_START		0x00c
+#define SDMA_H_EVTOVR		0x010
+#define SDMA_H_DSPOVR		0x014
+#define SDMA_H_HOSTOVR		0x018
+#define SDMA_H_EVTPEND		0x01c
+#define SDMA_H_DSPENBL		0x020
+#define SDMA_H_RESET		0x024
+#define SDMA_H_EVTERR		0x028
+#define SDMA_H_INTRMSK		0x02c
+#define SDMA_H_PSW		0x030
+#define SDMA_H_EVTERRDBG	0x034
+#define SDMA_H_CONFIG		0x038
+#define SDMA_ONCE_ENB		0x040
+#define SDMA_ONCE_DATA		0x044
+#define SDMA_ONCE_INSTR		0x048
+#define SDMA_ONCE_STAT		0x04c
+#define SDMA_ONCE_CMD		0x050
+#define SDMA_EVT_MIRROR		0x054
+#define SDMA_ILLINSTADDR	0x058
+#define SDMA_CHN0ADDR		0x05c
+#define SDMA_ONCE_RTB		0x060
+#define SDMA_XTRIG_CONF1	0x070
+#define SDMA_XTRIG_CONF2	0x074
+#define SDMA_CHNENBL0_V2	0x200
+#define SDMA_CHNENBL0_V1	0x080
+#define SDMA_CHNPRI_0		0x100
+
+/*
+ * Buffer descriptor status values.
+ */
+#define BD_DONE  0x01
+#define BD_WRAP  0x02
+#define BD_CONT  0x04
+#define BD_INTR  0x08
+#define BD_RROR  0x10
+#define BD_LAST  0x20
+#define BD_EXTD  0x80
+
+/*
+ * Data Node descriptor status values.
+ */
+#define DND_END_OF_FRAME  0x80
+#define DND_END_OF_XFER   0x40
+#define DND_DONE          0x20
+#define DND_UNUSED        0x01
+
+/*
+ * IPCV2 descriptor status values.
+ */
+#define BD_IPCV2_END_OF_FRAME  0x40
+
+#define IPCV2_MAX_NODES        50
+/*
+ * Error bit set in the CCB status field by the SDMA,
+ * in setbd routine, in case of a transfer error
+ */
+#define DATA_ERROR  0x10000000
+
+/*
+ * Buffer descriptor commands.
+ */
+#define C0_ADDR             0x01
+#define C0_LOAD             0x02
+#define C0_DUMP             0x03
+#define C0_SETCTX           0x07
+#define C0_GETCTX           0x03
+#define C0_SETDM            0x01
+#define C0_SETPM            0x04
+#define C0_GETDM            0x02
+#define C0_GETPM            0x08
+/*
+ * Change endianness indicator in the BD command field
+ */
+#define CHANGE_ENDIANNESS   0x80
+
+/*
+ * Mode/Count of data node descriptors - IPCv2
+ */
+struct sdma_mode_count {
+	u32 count   : 16; /* size of the buffer pointed by this BD */
+	u32 status  :  8; /* E,R,I,C,W,D status bits stored here */
+	u32 command :  8; /* command mostlky used for channel 0 */
+};
+
+/*
+ * Buffer descriptor
+ */
+struct sdma_buffer_descriptor {
+	struct sdma_mode_count  mode;
+	dma_addr_t buffer_addr;    /* address of the buffer described */
+	dma_addr_t ext_buffer_addr; /* extended buffer address */
+} __attribute__ ((packed));
+
+/**
+ * struct sdma_channel_control - Channel control Block
+ *
+ * @current_bd_ptr	current buffer descriptor processed
+ * @base_bd_ptr		first element of buffer descriptor array
+ * @unused		padding. The SDMA engine expects an array of 128 byte
+ *			control blocks
+ */
+struct sdma_channel_control {
+	dma_addr_t current_bd_ptr;
+	dma_addr_t base_bd_ptr;
+	u32 unused[2];
+} __attribute__ ((packed));
+
+/**
+ * struct sdma_state_registers - SDMA context for a channel
+ *
+ * @pc:		program counter
+ * @t:		test bit: status of arithmetic & test instruction
+ * @rpc:	return program counter
+ * @sf:		source fault while loading data
+ * @spc:	loop start program counter
+ * @df:		destination fault while storing data
+ * @epc:	loop end program counter
+ * @lm:		loop mode
+ */
+struct sdma_state_registers {
+	u32 pc     :14;
+	u32 unused1: 1;
+	u32 t      : 1;
+	u32 rpc    :14;
+	u32 unused0: 1;
+	u32 sf     : 1;
+	u32 spc    :14;
+	u32 unused2: 1;
+	u32 df     : 1;
+	u32 epc    :14;
+	u32 lm     : 2;
+} __attribute__ ((packed));
+
+/**
+ * struct sdma_context_data - sdma context specific to a channel
+ *
+ * @channel_state:	channel state bits
+ * @gReg:		general registers
+ * @mda:		burst dma destination address register
+ * @msa:		burst dma source address register
+ * @ms:			burst dma status register
+ * @md:			burst dma data register
+ * @pda:		peripheral dma destination address register
+ * @psa:		peripheral dma source address register
+ * @ps:			peripheral dma status register
+ * @pd:			peripheral dma data register
+ * @ca:			CRC polynomial register
+ * @cs:			CRC accumulator register
+ * @dda:		dedicated core destination address register
+ * @dsa:		dedicated core source address register
+ * @ds:			dedicated core status register
+ * @dd:			dedicated core data register
+ */
+struct sdma_context_data {
+	struct sdma_state_registers  channel_state;
+	u32  gReg[8];
+	u32  mda;
+	u32  msa;
+	u32  ms;
+	u32  md;
+	u32  pda;
+	u32  psa;
+	u32  ps;
+	u32  pd;
+	u32  ca;
+	u32  cs;
+	u32  dda;
+	u32  dsa;
+	u32  ds;
+	u32  dd;
+	u32  scratch0;
+	u32  scratch1;
+	u32  scratch2;
+	u32  scratch3;
+	u32  scratch4;
+	u32  scratch5;
+	u32  scratch6;
+	u32  scratch7;
+} __attribute__ ((packed));
+
+#define NUM_BD (int)(PAGE_SIZE / sizeof(struct sdma_buffer_descriptor))
+
+struct sdma_engine;
+
+/**
+ * struct sdma_channel - housekeeping for a SDMA channel
+ *
+ * @sdma		pointer to the SDMA engine for this channel
+ * @channel		the channel number, matches dmaengine chan_id
+ * @direction		transfer type. Needed for setting SDMA script
+ * @peripheral_type	Peripheral type. Needed for setting SDMA script
+ * @event_id0		aka dma request line
+ * @event_id1		for channels that use 2 events
+ * @word_size		peripheral access size
+ * @buf_tail		ID of the buffer that was processed
+ * @done		channel completion
+ * @num_bd		max NUM_BD. number of descriptors currently handling
+ */
+struct sdma_channel {
+	struct sdma_engine		*sdma;
+	unsigned int			channel;
+	enum dma_data_direction		direction;
+	enum sdma_peripheral_type	peripheral_type;
+	unsigned int			event_id0;
+	unsigned int			event_id1;
+	enum dma_slave_buswidth		word_size;
+	unsigned int			buf_tail;
+	struct completion		done;
+	unsigned int			num_bd;
+	struct sdma_buffer_descriptor	*bd;
+	dma_addr_t			bd_phys;
+	unsigned int			pc_from_device, pc_to_device;
+	unsigned long			flags;
+	dma_addr_t			per_address;
+	u32				event_mask0, event_mask1;
+	u32				watermark_level;
+	u32				shp_addr, per_addr;
+	struct dma_chan			chan;
+	spinlock_t			lock;
+	struct dma_async_tx_descriptor	desc;
+	dma_cookie_t			last_completed;
+	enum dma_status			status;
+};
+
+#define IMX_DMA_SG_LOOP		(1 << 0)
+
+#define MAX_DMA_CHANNELS 32
+#define MXC_SDMA_DEFAULT_PRIORITY 1
+#define MXC_SDMA_MIN_PRIORITY 1
+#define MXC_SDMA_MAX_PRIORITY 7
+
+/**
+ * struct sdma_script_start_addrs - SDMA script start pointers
+ *
+ * start addresses of the different functions in the physical
+ * address space of the SDMA engine.
+ */
+struct sdma_script_start_addrs {
+	u32 ap_2_ap_addr;
+	u32 ap_2_bp_addr;
+	u32 ap_2_ap_fixed_addr;
+	u32 bp_2_ap_addr;
+	u32 loopback_on_dsp_side_addr;
+	u32 mcu_interrupt_only_addr;
+	u32 firi_2_per_addr;
+	u32 firi_2_mcu_addr;
+	u32 per_2_firi_addr;
+	u32 mcu_2_firi_addr;
+	u32 uart_2_per_addr;
+	u32 uart_2_mcu_addr;
+	u32 per_2_app_addr;
+	u32 mcu_2_app_addr;
+	u32 per_2_per_addr;
+	u32 uartsh_2_per_addr;
+	u32 uartsh_2_mcu_addr;
+	u32 per_2_shp_addr;
+	u32 mcu_2_shp_addr;
+	u32 ata_2_mcu_addr;
+	u32 mcu_2_ata_addr;
+	u32 app_2_per_addr;
+	u32 app_2_mcu_addr;
+	u32 shp_2_per_addr;
+	u32 shp_2_mcu_addr;
+	u32 mshc_2_mcu_addr;
+	u32 mcu_2_mshc_addr;
+	u32 spdif_2_mcu_addr;
+	u32 mcu_2_spdif_addr;
+	u32 asrc_2_mcu_addr;
+	u32 ext_mem_2_ipu_addr;
+	u32 descrambler_addr;
+	u32 dptc_dvfs_addr;
+	u32 utra_addr;
+	u32 ram_code_start_addr;
+};
+
+#define SDMA_FIRMWARE_MAGIC 0x414d4453
+
+/**
+ * struct sdma_firmware_header - Layout of the firmware image
+ *
+ * @magic		"SDMA"
+ * @version_major	increased whenever layout of struct sdma_script_start_addrs
+ *			changes.
+ * @version_minor	firmware minor version (for binary compatible changes)
+ * @script_addrs_start	offset of struct sdma_script_start_addrs in this image
+ * @num_script_addrs	Number of script addresses in this image
+ * @ram_code_start	offset of SDMA ram image in this firmware image
+ * @ram_code_size	size of SDMA ram image
+ * @script_addrs	Stores the start address of the SDMA scripts
+ *			(in SDMA memory space)
+ */
+struct sdma_firmware_header {
+	u32	magic;
+	u32	version_major;
+	u32	version_minor;
+	u32	script_addrs_start;
+	u32	num_script_addrs;
+	u32	ram_code_start;
+	u32	ram_code_size;
+};
+
+struct sdma_engine {
+	struct device			*dev;
+	struct sdma_channel		channel[MAX_DMA_CHANNELS];
+	struct sdma_channel_control	*channel_control;
+	void __iomem			*regs;
+	unsigned int			version;
+	unsigned int			num_events;
+	struct sdma_context_data	*context;
+	dma_addr_t			context_phys;
+	struct dma_device		dma_device;
+	struct clk			*clk;
+	struct sdma_script_start_addrs	*script_addrs;
+};
+
+#define SDMA_H_CONFIG_DSPDMA	(1 << 12) /* indicates if the DSPDMA is used */
+#define SDMA_H_CONFIG_RTD_PINS	(1 << 11) /* indicates if Real-Time Debug pins are enabled */
+#define SDMA_H_CONFIG_ACR	(1 << 4)  /* indicates if AHB freq /core freq = 2 or 1 */
+#define SDMA_H_CONFIG_CSM	(3)       /* indicates which context switch mode is selected*/
+
+static inline u32 chnenbl_ofs(struct sdma_engine *sdma, unsigned int event)
+{
+	u32 chnenbl0 = (sdma->version == 2 ? SDMA_CHNENBL0_V2 : SDMA_CHNENBL0_V1);
+
+	return chnenbl0 + event * 4;
+}
+
+static int sdma_config_ownership(struct sdma_channel *sdmac,
+		bool event_override, bool mcu_verride, bool dsp_override)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	u32 evt, mcu, dsp;
+
+	if (event_override && mcu_verride && dsp_override)
+		return -EINVAL;
+
+	evt = __raw_readl(sdma->regs + SDMA_H_EVTOVR);
+	mcu = __raw_readl(sdma->regs + SDMA_H_HOSTOVR);
+	dsp = __raw_readl(sdma->regs + SDMA_H_DSPOVR);
+
+	if (dsp_override)
+		dsp &= ~(1 << channel);
+	else
+		dsp |= (1 << channel);
+
+	if (event_override)
+		evt &= ~(1 << channel);
+	else
+		evt |= (1 << channel);
+
+	if (mcu_verride)
+		mcu &= ~(1 << channel);
+	else
+		mcu |= (1 << channel);
+
+	__raw_writel(evt, sdma->regs + SDMA_H_EVTOVR);
+	__raw_writel(mcu, sdma->regs + SDMA_H_HOSTOVR);
+	__raw_writel(dsp, sdma->regs + SDMA_H_DSPOVR);
+
+	return 0;
+}
+
+/*
+ * sdma_run_channel - run a channel and wait till it's done
+ */
+static int sdma_run_channel(struct sdma_channel *sdmac)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	int ret;
+
+	init_completion(&sdmac->done);
+
+	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
+
+	ret = wait_for_completion_timeout(&sdmac->done, HZ);
+
+	return ret ? 0 : -ETIMEDOUT;
+}
+
+static int sdma_load_script(struct sdma_engine *sdma, void *buf, int size,
+		u32 address)
+{
+	struct sdma_buffer_descriptor *bd0 = sdma->channel[0].bd;
+	void *buf_virt;
+	dma_addr_t buf_phys;
+	int ret;
+
+	buf_virt = dma_alloc_coherent(NULL,
+			size,
+			&buf_phys, GFP_KERNEL);
+	if (!buf_virt)
+		return -ENOMEM;
+
+	bd0->mode.command = C0_SETPM;
+	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.count = size / 2;
+	bd0->buffer_addr = buf_phys;
+	bd0->ext_buffer_addr = address;
+
+	memcpy(buf_virt, buf, size);
+
+	ret = sdma_run_channel(&sdma->channel[0]);
+
+	dma_free_coherent(NULL, size, buf_virt, buf_phys);
+
+	return ret;
+}
+
+static void sdma_event_enable(struct sdma_channel *sdmac, unsigned int event)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	u32 val;
+	u32 chnenbl = chnenbl_ofs(sdma, event);
+
+	val = __raw_readl(sdma->regs + chnenbl);
+	val |= (1 << channel);
+	__raw_writel(val, sdma->regs + chnenbl);
+}
+
+static void sdma_event_disable(struct sdma_channel *sdmac, unsigned int event)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	u32 chnenbl = chnenbl_ofs(sdma, event);
+	u32 val;
+
+	val = __raw_readl(sdma->regs + chnenbl);
+	val &= ~(1 << channel);
+	__raw_writel(val, sdma->regs + chnenbl);
+}
+
+static void sdma_handle_channel_loop(struct sdma_channel *sdmac)
+{
+	struct sdma_buffer_descriptor *bd;
+
+	/*
+	 * loop mode. Iterate over descriptors, re-setup them and
+	 * call callback function.
+	 */
+	while (1) {
+		bd = &sdmac->bd[sdmac->buf_tail];
+
+		if (bd->mode.status & BD_DONE)
+			break;
+
+		if (bd->mode.status & BD_RROR)
+			sdmac->status = DMA_ERROR;
+		else
+			sdmac->status = DMA_SUCCESS;
+
+		bd->mode.status |= BD_DONE;
+		sdmac->buf_tail++;
+		sdmac->buf_tail %= sdmac->num_bd;
+
+		if (sdmac->desc.callback)
+			sdmac->desc.callback(sdmac->desc.callback_param);
+	}
+}
+
+static void mxc_sdma_handle_channel_normal(struct sdma_channel *sdmac)
+{
+	struct sdma_buffer_descriptor *bd;
+	int i, error = 0;
+
+	/*
+	 * non loop mode. Iterate over all descriptors, collect
+	 * errors and call callback function
+	 */
+	for (i = 0; i < sdmac->num_bd; i++) {
+		bd = &sdmac->bd[i];
+
+		 if (bd->mode.status & (BD_DONE | BD_RROR))
+			error = -EIO;
+	}
+
+	if (error)
+		sdmac->status = DMA_ERROR;
+	else
+		sdmac->status = DMA_SUCCESS;
+
+	if (sdmac->desc.callback)
+		sdmac->desc.callback(sdmac->desc.callback_param);
+	sdmac->last_completed = sdmac->desc.cookie;
+}
+
+static void mxc_sdma_handle_channel(struct sdma_channel *sdmac)
+{
+	complete(&sdmac->done);
+
+	/* not interested in channel 0 interrupts */
+	if (sdmac->channel == 0)
+		return;
+
+	if (sdmac->flags & IMX_DMA_SG_LOOP)
+		sdma_handle_channel_loop(sdmac);
+	else
+		mxc_sdma_handle_channel_normal(sdmac);
+}
+
+static irqreturn_t sdma_int_handler(int irq, void *dev_id)
+{
+	struct sdma_engine *sdma = dev_id;
+	u32 stat;
+
+	stat = __raw_readl(sdma->regs + SDMA_H_INTR);
+	__raw_writel(stat, sdma->regs + SDMA_H_INTR);
+
+	while (stat) {
+		int channel = fls(stat) - 1;
+		struct sdma_channel *sdmac = &sdma->channel[channel];
+
+		mxc_sdma_handle_channel(sdmac);
+
+		stat &= ~(1 << channel);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * sets the pc of SDMA script according to the peripheral type
+ */
+static void sdma_get_pc(struct sdma_channel *sdmac,
+		enum sdma_peripheral_type peripheral_type)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int per_2_emi = 0, emi_2_per = 0;
+	/*
+	 * These are needed once we start to support transfers between
+	 * two peripherals or memory-to-memory transfers
+	 */
+	int per_2_per = 0, emi_2_emi = 0;
+
+	sdmac->pc_from_device = 0;
+	sdmac->pc_to_device = 0;
+
+	switch (peripheral_type) {
+	case IMX_DMATYPE_MEMORY:
+		emi_2_emi = sdma->script_addrs->ap_2_ap_addr;
+		break;
+	case IMX_DMATYPE_DSP:
+		emi_2_per = sdma->script_addrs->bp_2_ap_addr;
+		per_2_emi = sdma->script_addrs->ap_2_bp_addr;
+		break;
+	case IMX_DMATYPE_FIRI:
+		per_2_emi = sdma->script_addrs->firi_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_firi_addr;
+		break;
+	case IMX_DMATYPE_UART:
+		per_2_emi = sdma->script_addrs->uart_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_app_addr;
+		break;
+	case IMX_DMATYPE_UART_SP:
+		per_2_emi = sdma->script_addrs->uartsh_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_shp_addr;
+		break;
+	case IMX_DMATYPE_ATA:
+		per_2_emi = sdma->script_addrs->ata_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_ata_addr;
+		break;
+	case IMX_DMATYPE_CSPI:
+	case IMX_DMATYPE_EXT:
+	case IMX_DMATYPE_SSI:
+		per_2_emi = sdma->script_addrs->app_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_app_addr;
+		break;
+	case IMX_DMATYPE_SSI_SP:
+	case IMX_DMATYPE_MMC:
+	case IMX_DMATYPE_SDHC:
+	case IMX_DMATYPE_CSPI_SP:
+	case IMX_DMATYPE_ESAI:
+	case IMX_DMATYPE_MSHC_SP:
+		per_2_emi = sdma->script_addrs->shp_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_shp_addr;
+		break;
+	case IMX_DMATYPE_ASRC:
+		per_2_emi = sdma->script_addrs->asrc_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->asrc_2_mcu_addr;
+		per_2_per = sdma->script_addrs->per_2_per_addr;
+		break;
+	case IMX_DMATYPE_MSHC:
+		per_2_emi = sdma->script_addrs->mshc_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_mshc_addr;
+		break;
+	case IMX_DMATYPE_CCM:
+		per_2_emi = sdma->script_addrs->dptc_dvfs_addr;
+		break;
+	case IMX_DMATYPE_SPDIF:
+		per_2_emi = sdma->script_addrs->spdif_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_spdif_addr;
+		break;
+	case IMX_DMATYPE_IPU_MEMORY:
+		emi_2_per = sdma->script_addrs->ext_mem_2_ipu_addr;
+		break;
+	default:
+		break;
+	}
+
+	sdmac->pc_from_device = per_2_emi;
+	sdmac->pc_to_device = emi_2_per;
+}
+
+static int sdma_load_context(struct sdma_channel *sdmac)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	int load_address;
+	struct sdma_context_data *context = sdma->context;
+	struct sdma_buffer_descriptor *bd0 = sdma->channel[0].bd;
+	int ret;
+
+	if (sdmac->direction == DMA_FROM_DEVICE) {
+		load_address = sdmac->pc_from_device;
+	} else {
+		load_address = sdmac->pc_to_device;
+	}
+
+	if (load_address < 0)
+		return load_address;
+
+	dev_dbg(sdma->dev, "load_address = %d\n", load_address);
+	dev_dbg(sdma->dev, "wml = 0x%08x\n", sdmac->watermark_level);
+	dev_dbg(sdma->dev, "shp_addr = 0x%08x\n", sdmac->shp_addr);
+	dev_dbg(sdma->dev, "per_addr = 0x%08x\n", sdmac->per_addr);
+	dev_dbg(sdma->dev, "event_mask0 = 0x%08x\n", sdmac->event_mask0);
+	dev_dbg(sdma->dev, "event_mask1 = 0x%08x\n", sdmac->event_mask1);
+
+	memset(context, 0, sizeof(*context));
+	context->channel_state.pc = load_address;
+
+	/* Send by context the event mask,base address for peripheral
+	 * and watermark level
+	 */
+	context->gReg[0] = sdmac->event_mask1;
+	context->gReg[1] = sdmac->event_mask0;
+	context->gReg[2] = sdmac->per_addr;
+	context->gReg[6] = sdmac->shp_addr;
+	context->gReg[7] = sdmac->watermark_level;
+
+	bd0->mode.command = C0_SETDM;
+	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
+	bd0->mode.count = sizeof(*context) / 4;
+	bd0->buffer_addr = sdma->context_phys;
+	bd0->ext_buffer_addr = 2048 + (sizeof(*context) / 4) * channel;
+
+	ret = sdma_run_channel(&sdma->channel[0]);
+
+	return ret;
+}
+
+static void sdma_disable_channel(struct sdma_channel *sdmac)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+
+	__raw_writel(1 << channel, sdma->regs + SDMA_H_STATSTOP);
+	sdmac->status = DMA_ERROR;
+}
+
+static int sdma_config_channel(struct sdma_channel *sdmac)
+{
+	int ret;
+
+	sdma_disable_channel(sdmac);
+
+	sdmac->event_mask0 = 0;
+	sdmac->event_mask1 = 0;
+	sdmac->shp_addr = 0;
+	sdmac->per_addr = 0;
+
+	if (sdmac->event_id0) {
+		if (sdmac->event_id0 > 32)
+			return -EINVAL;
+		sdma_event_enable(sdmac, sdmac->event_id0);
+	}
+
+	switch (sdmac->peripheral_type) {
+	case IMX_DMATYPE_DSP:
+		sdma_config_ownership(sdmac, false, true, true);
+		break;
+	case IMX_DMATYPE_MEMORY:
+		sdma_config_ownership(sdmac, false, true, false);
+		break;
+	default:
+		sdma_config_ownership(sdmac, true, true, false);
+		break;
+	}
+
+	sdma_get_pc(sdmac, sdmac->peripheral_type);
+
+	if ((sdmac->peripheral_type != IMX_DMATYPE_MEMORY) &&
+			(sdmac->peripheral_type != IMX_DMATYPE_DSP)) {
+		/* Handle multiple event channels differently */
+		if (sdmac->event_id1) {
+			sdmac->event_mask1 = 1 << (sdmac->event_id1 % 32);
+			if (sdmac->event_id1 > 31)
+				sdmac->watermark_level |= 1 << 31;
+			sdmac->event_mask0 = 1 << (sdmac->event_id0 % 32);
+			if (sdmac->event_id0 > 31)
+				sdmac->watermark_level |= 1 << 30;
+		} else {
+			sdmac->event_mask0 = 1 << sdmac->event_id0;
+			sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
+		}
+		/* Watermark Level */
+		sdmac->watermark_level |= sdmac->watermark_level;
+		/* Address */
+		sdmac->shp_addr = sdmac->per_address;
+	} else {
+		sdmac->watermark_level = 0; /* FIXME: M3_BASE_ADDRESS */
+	}
+
+	ret = sdma_load_context(sdmac);
+
+	return ret;
+}
+
+static int sdma_set_channel_priority(struct sdma_channel *sdmac,
+		unsigned int priority)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+
+	if (priority < MXC_SDMA_MIN_PRIORITY
+	    || priority > MXC_SDMA_MAX_PRIORITY) {
+		return -EINVAL;
+	}
+
+	__raw_writel(priority, sdma->regs + SDMA_CHNPRI_0 + 4 * channel);
+
+	return 0;
+}
+
+static int sdma_request_channel(struct sdma_channel *sdmac)
+{
+	struct sdma_engine *sdma = sdmac->sdma;
+	int channel = sdmac->channel;
+	int ret = -EBUSY;
+
+	sdmac->bd = dma_alloc_coherent(NULL, PAGE_SIZE, &sdmac->bd_phys, GFP_KERNEL);
+	if (!sdmac->bd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(sdmac->bd, 0, PAGE_SIZE);
+
+	sdma->channel_control[channel].base_bd_ptr = sdmac->bd_phys;
+	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
+
+	clk_enable(sdma->clk);
+
+	sdma_set_channel_priority(sdmac, MXC_SDMA_DEFAULT_PRIORITY);
+
+	init_completion(&sdmac->done);
+
+	sdmac->buf_tail = 0;
+
+	return 0;
+out:
+
+	return ret;
+}
+
+static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
+{
+	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
+}
+
+static dma_cookie_t sdma_assign_cookie(struct sdma_channel *sdma)
+{
+	dma_cookie_t cookie = sdma->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	sdma->chan.cookie = cookie;
+	sdma->desc.cookie = cookie;
+
+	return cookie;
+}
+
+static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct sdma_channel, chan);
+}
+
+static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(tx->chan);
+	struct sdma_engine *sdma = sdmac->sdma;
+	dma_cookie_t cookie;
+
+	spin_lock_irq(&sdmac->lock);
+
+	cookie = sdma_assign_cookie(sdmac);
+
+	sdma_enable_channel(sdma, tx->chan->chan_id);
+
+	spin_unlock_irq(&sdmac->lock);
+
+	return cookie;
+}
+
+static int sdma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct imx_dma_data *data = chan->private;
+	int prio, ret;
+
+	/* No need to execute this for internal channel 0 */
+	if (chan->chan_id == 0)
+		return 0;
+
+	if (!data)
+		return -EINVAL;
+
+	switch (data->priority) {
+	case DMA_PRIO_HIGH:
+		prio = 3;
+		break;
+	case DMA_PRIO_MEDIUM:
+		prio = 2;
+		break;
+	case DMA_PRIO_LOW:
+	default:
+		prio = 1;
+		break;
+	}
+
+	sdmac->peripheral_type = data->peripheral_type;
+	sdmac->event_id0 = data->dma_request;
+	ret = sdma_set_channel_priority(sdmac, prio);
+	if (ret)
+		return ret;
+
+	ret = sdma_request_channel(sdmac);
+	if (ret)
+		return ret;
+
+	dma_async_tx_descriptor_init(&sdmac->desc, chan);
+	sdmac->desc.tx_submit = sdma_tx_submit;
+	/* txd.flags will be overwritten in prep funcs */
+	sdmac->desc.flags = DMA_CTRL_ACK;
+
+	return 0;
+}
+
+static void sdma_free_chan_resources(struct dma_chan *chan)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct sdma_engine *sdma = sdmac->sdma;
+
+	sdma_disable_channel(sdmac);
+
+	if (sdmac->event_id0)
+		sdma_event_disable(sdmac, sdmac->event_id0);
+	if (sdmac->event_id1)
+		sdma_event_disable(sdmac, sdmac->event_id1);
+
+	sdmac->event_id0 = 0;
+	sdmac->event_id1 = 0;
+
+	sdma_set_channel_priority(sdmac, 0);
+
+	dma_free_coherent(NULL, PAGE_SIZE, sdmac->bd, sdmac->bd_phys);
+
+	clk_disable(sdma->clk);
+}
+
+static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct sdma_engine *sdma = sdmac->sdma;
+	int ret, i, count;
+	int channel = chan->chan_id;
+	struct scatterlist *sg;
+
+	if (sdmac->status == DMA_IN_PROGRESS)
+		return NULL;
+	sdmac->status = DMA_IN_PROGRESS;
+
+	sdmac->flags = 0;
+
+	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
+			sg_len, channel);
+
+	sdmac->direction = direction;
+	ret = sdma_load_context(sdmac);
+	if (ret)
+		goto err_out;
+
+	if (sg_len > NUM_BD) {
+		dev_err(sdma->dev, "SDMA channel %d: maximum number of sg exceeded: %d > %d\n",
+				channel, sg_len, NUM_BD);
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
+		int param;
+
+		bd->buffer_addr = sgl->dma_address;
+
+		count = sg->length;
+
+		if (count > 0xffff) {
+			dev_err(sdma->dev, "SDMA channel %d: maximum bytes for sg entry exceeded: %d > %d\n",
+					channel, count, 0xffff);
+			ret = -EINVAL;
+			goto err_out;
+		}
+
+		bd->mode.count = count;
+
+		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
+			ret =  -EINVAL;
+			goto err_out;
+		}
+		if (sdmac->word_size == DMA_SLAVE_BUSWIDTH_4_BYTES)
+			bd->mode.command = 0;
+		else
+			bd->mode.command = sdmac->word_size;
+
+		param = BD_DONE | BD_EXTD | BD_CONT;
+
+		if (sdmac->flags & IMX_DMA_SG_LOOP) {
+			param |= BD_INTR;
+			if (i + 1 == sg_len)
+				param |= BD_WRAP;
+		}
+
+		if (i + 1 == sg_len)
+			param |= BD_INTR;
+
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
+				i, count, sg->dma_address,
+				param & BD_WRAP ? "wrap" : "",
+				param & BD_INTR ? " intr" : "");
+
+		bd->mode.status = param;
+	}
+
+	sdmac->num_bd = sg_len;
+	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
+
+	return &sdmac->desc;
+err_out:
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
+		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct sdma_engine *sdma = sdmac->sdma;
+	int num_periods = buf_len / period_len;
+	int channel = chan->chan_id;
+	int ret, i = 0, buf = 0;
+
+	dev_dbg(sdma->dev, "%s channel: %d\n", __func__, channel);
+
+	if (sdmac->status == DMA_IN_PROGRESS)
+		return NULL;
+
+	sdmac->status = DMA_IN_PROGRESS;
+
+	sdmac->flags |= IMX_DMA_SG_LOOP;
+	sdmac->direction = direction;
+	ret = sdma_load_context(sdmac);
+	if (ret)
+		goto err_out;
+
+	if (num_periods > NUM_BD) {
+		dev_err(sdma->dev, "SDMA channel %d: maximum number of sg exceeded: %d > %d\n",
+				channel, num_periods, NUM_BD);
+		goto err_out;
+	}
+
+	if (period_len > 0xffff) {
+		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %d > %d\n",
+				channel, period_len, 0xffff);
+		goto err_out;
+	}
+
+	while (buf < buf_len) {
+		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
+		int param;
+
+		bd->buffer_addr = dma_addr;
+
+		bd->mode.count = period_len;
+
+		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES)
+			goto err_out;
+		if (sdmac->word_size == DMA_SLAVE_BUSWIDTH_4_BYTES)
+			bd->mode.command = 0;
+		else
+			bd->mode.command = sdmac->word_size;
+
+		param = BD_DONE | BD_EXTD | BD_CONT | BD_INTR;
+		if (i + 1 == num_periods)
+			param |= BD_WRAP;
+
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
+				i, period_len, dma_addr,
+				param & BD_WRAP ? "wrap" : "",
+				param & BD_INTR ? " intr" : "");
+
+		bd->mode.status = param;
+
+		dma_addr += period_len;
+		buf += period_len;
+
+		i++;
+	}
+
+	sdmac->num_bd = num_periods;
+	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
+
+	return &sdmac->desc;
+err_out:
+	sdmac->status = DMA_ERROR;
+	return NULL;
+}
+
+static int sdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		unsigned long arg)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct dma_slave_config *dmaengine_cfg = (void *)arg;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		sdma_disable_channel(sdmac);
+		return 0;
+	case DMA_SLAVE_CONFIG:
+		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
+			sdmac->per_address = dmaengine_cfg->src_addr;
+			sdmac->watermark_level = dmaengine_cfg->src_maxburst;
+			sdmac->word_size = dmaengine_cfg->src_addr_width;
+		} else {
+			sdmac->per_address = dmaengine_cfg->dst_addr;
+			sdmac->watermark_level = dmaengine_cfg->dst_maxburst;
+			sdmac->word_size = dmaengine_cfg->dst_addr_width;
+		}
+		return sdma_config_channel(sdmac);
+	default:
+		return -ENOSYS;
+	}
+
+	return -EINVAL;
+}
+
+static enum dma_status sdma_tx_status(struct dma_chan *chan,
+					    dma_cookie_t cookie,
+					    struct dma_tx_state *txstate)
+{
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	dma_cookie_t last_used;
+	enum dma_status ret;
+
+	last_used = chan->cookie;
+
+	ret = dma_async_is_complete(cookie, sdmac->last_completed, last_used);
+	dma_set_tx_state(txstate, sdmac->last_completed, last_used, 0);
+
+	return ret;
+}
+
+static void sdma_issue_pending(struct dma_chan *chan)
+{
+	/*
+	 * Nothing to do. We only have a single descriptor
+	 */
+}
+
+static int __init sdma_init(struct sdma_engine *sdma,
+		void *ram_code, int ram_code_size)
+{
+	int i, ret;
+	dma_addr_t ccb_phys;
+
+	switch (sdma->version) {
+	case 1:
+		sdma->num_events = 32;
+		break;
+	case 2:
+		sdma->num_events = 48;
+		break;
+	default:
+		dev_err(sdma->dev, "Unknown version %d. aborting\n", sdma->version);
+		return -ENODEV;
+	}
+
+	clk_enable(sdma->clk);
+
+	/* Be sure SDMA has not started yet */
+	__raw_writel(0, sdma->regs + SDMA_H_C0PTR);
+
+	sdma->channel_control = dma_alloc_coherent(NULL,
+			MAX_DMA_CHANNELS * sizeof (struct sdma_channel_control) +
+			sizeof(struct sdma_context_data),
+			&ccb_phys, GFP_KERNEL);
+
+	if (!sdma->channel_control) {
+		ret = -ENOMEM;
+		goto err_dma_alloc;
+	}
+
+	sdma->context = (void *)sdma->channel_control +
+		MAX_DMA_CHANNELS * sizeof (struct sdma_channel_control);
+	sdma->context_phys = ccb_phys +
+		MAX_DMA_CHANNELS * sizeof (struct sdma_channel_control);
+
+	/* Zero-out the CCB structures array just allocated */
+	memset(sdma->channel_control, 0,
+			MAX_DMA_CHANNELS * sizeof (struct sdma_channel_control));
+
+	/* disable all channels */
+	for (i = 0; i < sdma->num_events; i++)
+		__raw_writel(0, sdma->regs + chnenbl_ofs(sdma, i));
+
+	/* All channels have priority 0 */
+	for (i = 0; i < MAX_DMA_CHANNELS; i++)
+		__raw_writel(0, sdma->regs + SDMA_CHNPRI_0 + i * 4);
+
+	ret = sdma_request_channel(&sdma->channel[0]);
+	if (ret)
+		goto err_dma_alloc;
+
+	sdma_config_ownership(&sdma->channel[0], false, true, false);
+
+	/* Set Command Channel (Channel Zero) */
+	__raw_writel(0x4050, sdma->regs + SDMA_CHN0ADDR);
+
+	/* Set bits of CONFIG register but with static context switching */
+	/* FIXME: Check whether to set ACR bit depending on clock ratios */
+	__raw_writel(0, sdma->regs + SDMA_H_CONFIG);
+
+	__raw_writel(ccb_phys, sdma->regs + SDMA_H_C0PTR);
+
+	/* download the RAM image for SDMA */
+	sdma_load_script(sdma, ram_code,
+			ram_code_size,
+			sdma->script_addrs->ram_code_start_addr);
+
+	/* Set bits of CONFIG register with given context switching mode */
+	__raw_writel(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
+
+	/* Initializes channel's priorities */
+	sdma_set_channel_priority(&sdma->channel[0], 7);
+
+	clk_disable(sdma->clk);
+
+	return 0;
+
+err_dma_alloc:
+	clk_disable(sdma->clk);
+	dev_err(sdma->dev, "initialisation failed with %d\n", ret);
+	return ret;
+}
+
+static int __init sdma_probe(struct platform_device *pdev)
+{
+	int ret;
+	const struct firmware *fw;
+	const struct sdma_firmware_header *header;
+	const struct sdma_script_start_addrs *addr;
+	int irq;
+	unsigned short *ram_code;
+	struct resource *iores;
+	struct sdma_platform_data *pdata = pdev->dev.platform_data;
+	char *fwname;
+	int i;
+	dma_cap_mask_t mask;
+	struct sdma_engine *sdma;
+
+	sdma = kzalloc(sizeof(*sdma), GFP_KERNEL);
+	if (!sdma)
+		return -ENOMEM;
+
+	sdma->dev = &pdev->dev;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!iores || irq < 0 || !pdata) {
+		ret = -EINVAL;
+		goto err_irq;
+	}
+
+	if (!request_mem_region(iores->start, resource_size(iores), pdev->name)) {
+		ret = -EBUSY;
+		goto err_request_region;
+	}
+
+	sdma->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(sdma->clk)) {
+		ret = PTR_ERR(sdma->clk);
+		goto err_clk;
+	}
+
+	sdma->regs = ioremap(iores->start, resource_size(iores));
+	if (!sdma->regs) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	ret = request_irq(irq, sdma_int_handler, 0, "sdma", sdma);
+	if (ret)
+		goto err_request_irq;
+
+	fwname = kasprintf(GFP_KERNEL, "sdma-%s-to%d.bin",
+			pdata->cpu_name, pdata->to_version);
+	if (!fwname) {
+		ret = -ENOMEM;
+		goto err_cputype;
+	}
+
+	ret = request_firmware(&fw, fwname, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "request firmware \"%s\" failed with %d\n",
+				fwname, ret);
+		kfree(fwname);
+		goto err_cputype;
+	}
+	kfree(fwname);
+
+	if (fw->size < sizeof(*header))
+		goto err_firmware;
+
+	header = (struct sdma_firmware_header *)fw->data;
+
+	if (header->magic != SDMA_FIRMWARE_MAGIC)
+		goto err_firmware;
+	if (header->ram_code_start + header->ram_code_size > fw->size)
+		goto err_firmware;
+
+	addr = (void *)header + header->script_addrs_start;
+	ram_code = (void *)header + header->ram_code_start;
+	sdma->script_addrs = kmalloc(sizeof(*addr), GFP_KERNEL);
+	if (!sdma->script_addrs)
+		goto err_firmware;
+	memcpy(sdma->script_addrs, addr, sizeof(*addr));
+
+	sdma->version = pdata->sdma_version;
+
+	INIT_LIST_HEAD(&sdma->dma_device.channels);
+	/* Initialize channel parameters */
+	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+		struct sdma_channel *sdmac = &sdma->channel[i];
+
+		sdmac->sdma = sdma;
+		spin_lock_init(&sdmac->lock);
+
+		dma_cap_set(DMA_SLAVE, sdma->dma_device.cap_mask);
+		dma_cap_set(DMA_CYCLIC, sdma->dma_device.cap_mask);
+
+		sdmac->chan.device = &sdma->dma_device;
+		sdmac->chan.chan_id = i;
+		sdmac->channel = i;
+
+		/* Add the channel to the DMAC list */
+		list_add_tail(&sdmac->chan.device_node, &sdma->dma_device.channels);
+	}
+
+	ret = sdma_init(sdma, ram_code, header->ram_code_size);
+	if (ret)
+		goto err_init;
+
+	sdma->dma_device.dev = &pdev->dev;
+
+	sdma->dma_device.device_alloc_chan_resources = sdma_alloc_chan_resources;
+	sdma->dma_device.device_free_chan_resources = sdma_free_chan_resources;
+	sdma->dma_device.device_tx_status = sdma_tx_status;
+	sdma->dma_device.device_prep_slave_sg = sdma_prep_slave_sg;
+	sdma->dma_device.device_prep_dma_cyclic = sdma_prep_dma_cyclic;
+	sdma->dma_device.device_control = sdma_control;
+	sdma->dma_device.device_issue_pending = sdma_issue_pending;
+
+	ret = dma_async_device_register(&sdma->dma_device);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to register\n");
+		goto err_init;
+	}
+
+	dev_info(&pdev->dev, "initialized (firmware %d.%d)\n",
+			header->version_major,
+			header->version_minor);
+
+	/* request channel 0. This is an internal control channel
+	 * to the SDMA engine and not available to clients.
+	 */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_request_channel(mask, NULL, NULL);
+
+	release_firmware(fw);
+
+	return 0;
+
+err_init:
+	kfree(sdma->script_addrs);
+err_firmware:
+	release_firmware(fw);
+err_cputype:
+	free_irq(irq, sdma);
+err_request_irq:
+	iounmap(sdma->regs);
+err_ioremap:
+	clk_put(sdma->clk);
+err_clk:
+	release_mem_region(iores->start, resource_size(iores));
+err_request_region:
+err_irq:
+	kfree(sdma);
+	return 0;
+}
+
+static int __exit sdma_remove(struct platform_device *pdev)
+{
+	return -EBUSY;
+}
+
+static struct platform_driver sdma_driver = {
+	.driver		= {
+		.name	= "imx-sdma",
+	},
+	.remove		= __exit_p(sdma_remove),
+};
+
+static int __init sdma_module_init(void)
+{
+	return platform_driver_probe(&sdma_driver, sdma_probe);
+}
+subsys_initcall(sdma_module_init);
+
+MODULE_AUTHOR("Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("i.MX SDMA driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
