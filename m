Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2C0Key (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:34:54 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:42993 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752118Ab2C0Kev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:34:51 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 06:34:51 EDT
From: "Thang Q. Nguyen" <tqnguyen@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
        Josh Boyer <jwboyer@gmail.com>, Stefan Roese <sr@denx.de>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "Thang Q. Nguyen" <tqnguyen@apm.com>
Subject: [PATCH 1/1] Add support 2 SATA ports for Maui and change filename from sata_dwc_460ex.c to sata_dwc_4xx.c
Date: Tue, 27 Mar 2012 17:26:23 +0700
Message-Id: <1332843983-24254-1-git-send-email-tqnguyen@apm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support 2 native SATA ports on APM821XX and change the existing file name from sata_dwc_460ex.c to sata_dwc_4xx.c. This supports both 460EX and APM821XX.

Signed-off-by: Thang Q. Nguyen <tqnguyen@apm.com>
---
 arch/powerpc/boot/dts/bluestone.dts |   21 +
 drivers/ata/Makefile                |    2 +-
 drivers/ata/sata_dwc_4xx.c          | 2178 +++++++++++++++++++++++++++++++++++
 3 files changed, 2200 insertions(+), 1 deletions(-)
 create mode 100644 drivers/ata/sata_dwc_4xx.c

diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
index 2a56a0d..1396e2c 100644
--- a/arch/powerpc/boot/dts/bluestone.dts
+++ b/arch/powerpc/boot/dts/bluestone.dts
@@ -145,6 +145,27 @@
 					/*RXDE*/  0x5 0x4>;
 		};
 
+		/* SATA DWC devices */
+		SATA0: sata@bffd1000 {
+			compatible = "amcc,sata-apm821xx";
+			reg = <4 0xbffd1000 0x800   /* SATA0 */
+			       4 0xbffd0800 0x400>; /* AHBDMA */
+			dma-channel=<0>;
+			interrupt-parent = <&UIC0>;
+			interrupts = <26 4    /* SATA0 */
+			              25 4>;  /* AHBDMA */
+		};
+
+		SATA1: sata@bffd1800 {
+			compatible = "amcc,sata-apm821xx";
+			reg = <4 0xbffd1800 0x800   /* SATA1 */
+			       4 0xbffd0800 0x400>; /* AHBDMA */
+			dma-channel=<1>;
+			interrupt-parent = <&UIC0>;
+			interrupts = <27 4    /* SATA1 */
+			              25 4>;  /* AHBDMA */
+		};
+
 		POB0: opb {
 			compatible = "ibm,opb";
 			#address-cells = <1>;
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 6ece5b7..d225c0c 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
 obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
-obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
+obj-$(CONFIG_SATA_DWC)		+= sata_dwc_4xx.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/sata_dwc_4xx.c b/drivers/ata/sata_dwc_4xx.c
new file mode 100644
index 0000000..f354155
--- /dev/null
+++ b/drivers/ata/sata_dwc_4xx.c
@@ -0,0 +1,2178 @@
+/*
+ * drivers/ata/sata_dwc_4xx.c
+ *
+ * Synopsys DesignWare Cores (DWC) SATA host driver
+ *
+ * Author: Mark Miesfeld <mmiesfeld@amcc.com>
+ *
+ * Ported from 2.6.19.2 to 2.6.25/26 by Stefan Roese <sr@denx.de>
+ * Copyright 2008 DENX Software Engineering
+ *
+ * Based on versions provided by AMCC and Synopsys which are:
+ *          Copyright 2006 Applied Micro Circuits Corporation
+ *          COPYRIGHT (C) 2005  SYNOPSYS, INC.  ALL RIGHTS RESERVED
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * CHANGES:
+ * - Version 1.4:
+ *   + Change filename from sata_dwc_460ex.c to sata_dwc_4xx.c
+ *   + This driver supports more than one SATA port. Each SATA port has its
+ *     own private attribute. Move sata_dwc_host_priv structure to
+ *     sata_dwc_device and sata_dwc_device_port structures.
+ */
+
+#ifdef CONFIG_SATA_DWC_DEBUG
+#define DEBUG
+#endif
+
+#ifdef CONFIG_SATA_DWC_VDEBUG
+#define VERBOSE_DEBUG
+#define DEBUG_NCQ
+#endif
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/libata.h>
+#include <linux/slab.h>
+#include "libata.h"
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+
+/* These two are defined in "libata.h" */
+#undef  DRV_NAME
+#undef  DRV_VERSION
+#define DRV_NAME        "sata-dwc"
+#define DRV_VERSION     "1.4"
+
+#define DMA_NUM_CHANS		2
+#define DMA_NUM_CHAN_REGS	8
+
+#define AHB_DMA_BRST_DFLT	64	/* 16 data items burst length*/
+
+struct dmareg {
+	u32 low;		/* Low bits 0-31 */
+	u32 high;		/* High bits 32-63 */
+};
+
+/* DMA Per Channel registers */
+struct dma_chan_regs {
+	struct dmareg sar;	/* Source Address */
+	struct dmareg dar;	/* Destination address */
+	struct dmareg llp;	/* Linked List Pointer */
+	struct dmareg ctl;	/* Control */
+	struct dmareg sstat;	/* Source Status not implemented in core */
+	struct dmareg dstat;	/* Destination Status not implemented in core*/
+	struct dmareg sstatar;	/* Source Status Address not impl in core */
+	struct dmareg dstatar;	/* Destination Status Address not implemente */
+	struct dmareg cfg;	/* Config */
+	struct dmareg sgr;	/* Source Gather */
+	struct dmareg dsr;	/* Destination Scatter */
+};
+
+/* Generic Interrupt Registers */
+struct dma_interrupt_regs {
+	struct dmareg tfr;	/* Transfer Interrupt */
+	struct dmareg block;	/* Block Interrupt */
+	struct dmareg srctran;	/* Source Transfer Interrupt */
+	struct dmareg dsttran;	/* Dest Transfer Interrupt */
+	struct dmareg error;	/* Error */
+};
+
+struct ahb_dma_regs {
+	struct dma_chan_regs	chan_regs[DMA_NUM_CHAN_REGS];
+	struct dma_interrupt_regs interrupt_raw;	/* Raw Interrupt */
+	struct dma_interrupt_regs interrupt_status;	/* Interrupt Status */
+	struct dma_interrupt_regs interrupt_mask;	/* Interrupt Mask */
+	struct dma_interrupt_regs interrupt_clear;	/* Interrupt Clear */
+	struct dmareg		statusInt;	/* Interrupt combined*/
+	struct dmareg		rq_srcreg;	/* Src Trans Req */
+	struct dmareg		rq_dstreg;	/* Dst Trans Req */
+	struct dmareg		rq_sgl_srcreg;	/* Sngl Src Trans Req*/
+	struct dmareg		rq_sgl_dstreg;	/* Sngl Dst Trans Req*/
+	struct dmareg		rq_lst_srcreg;	/* Last Src Trans Req*/
+	struct dmareg		rq_lst_dstreg;	/* Last Dst Trans Req*/
+	struct dmareg		dma_cfg;		/* DMA Config */
+	struct dmareg		dma_chan_en;		/* DMA Channel Enable*/
+	struct dmareg		dma_id;			/* DMA ID */
+	struct dmareg		dma_test;		/* DMA Test */
+	struct dmareg		res1;			/* reserved */
+	struct dmareg		res2;			/* reserved */
+	/*
+	 * DMA Comp Params
+	 * Param 6 = dma_param[0], Param 5 = dma_param[1],
+	 * Param 4 = dma_param[2] ...
+	 */
+	struct dmareg		dma_params[6];
+};
+
+/* Data structure for linked list item */
+struct lli {
+	u32		sar;		/* Source Address */
+	u32		dar;		/* Destination address */
+	u32		llp;		/* Linked List Pointer */
+	struct dmareg	ctl;		/* Control */
+	struct dmareg	dstat;		/* Destination Status */
+};
+
+enum {
+	SATA_DWC_DMAC_LLI_SZ =	(sizeof(struct lli)),
+	SATA_DWC_DMAC_LLI_NUM =	256,
+	SATA_DWC_DMAC_LLI_TBL_SZ = (SATA_DWC_DMAC_LLI_SZ * \
+					SATA_DWC_DMAC_LLI_NUM),
+	SATA_DWC_DMAC_TWIDTH_BYTES = 4,
+	SATA_DWC_DMAC_CTRL_TSIZE_MAX = (0x00000800 * \
+						SATA_DWC_DMAC_TWIDTH_BYTES),
+};
+
+/* Host Controller ID */
+enum {
+	APM_460EX_SATA = 0,
+	APM_821XX_SATA = 1,
+};
+
+/* DMA Register Operation Bits */
+enum {
+	DMA_EN	=		0x00000001, /* Enable AHB DMA */
+	DMA_CTL_LLP_SRCEN =	0x10000000, /* Blk chain enable Src */
+	DMA_CTL_LLP_DSTEN =	0x08000000, /* Blk chain enable Dst */
+};
+
+#define DMA_CTL_BLK_TS(size)	((size) & 0x000000FFF)	/* Blk Transfer size */
+#define DMA_CHANNEL(ch)		(0x00000001 << (ch))	/* Select channel */
+	/* Enable channel */
+#define	DMA_ENABLE_CHAN(ch)	(0x00000101 << (ch))
+	/* Disable channel */
+#define	DMA_DISABLE_CHAN(ch)	(0x000000100 << (ch))
+	/* Transfer Type & Flow Controller */
+#define	DMA_CTL_TTFC(type)	(((type) & 0x7) << 20)
+#define	DMA_CTL_SMS(num)	(((num) & 0x3) << 25) /* Src Master Select */
+#define	DMA_CTL_DMS(num)	(((num) & 0x3) << 23)/* Dst Master Select */
+	/* Src Burst Transaction Length */
+#define DMA_CTL_SRC_MSIZE(size) (((size) & 0x7) << 14)
+	/* Dst Burst Transaction Length */
+#define	DMA_CTL_DST_MSIZE(size) (((size) & 0x7) << 11)
+	/* Source Transfer Width */
+#define	DMA_CTL_SRC_TRWID(size) (((size) & 0x7) << 4)
+	/* Destination Transfer Width */
+#define	DMA_CTL_DST_TRWID(size) (((size) & 0x7) << 1)
+
+/* Assign HW handshaking interface (x) to destination / source peripheral */
+#define	DMA_CFG_HW_HS_DEST(int_num) (((int_num) & 0xF) << 11)
+#define	DMA_CFG_HW_HS_SRC(int_num) (((int_num) & 0xF) << 7)
+#define	DMA_CFG_HW_CH_PRIOR(int_num) (((int_num) & 0xF) << 5)
+#define	DMA_LLP_LMS(addr, master) (((addr) & 0xfffffffc) | (master))
+
+/*
+ * This define is used to set block chaining disabled in the control low
+ * register.  It is already in little endian format so it can be &'d dirctly.
+ * It is essentially: cpu_to_le32(~(DMA_CTL_LLP_SRCEN | DMA_CTL_LLP_DSTEN))
+ */
+enum {
+	DMA_CTL_LLP_DISABLE_LE32 = 0xffffffe7,
+	DMA_CTL_TTFC_P2M_DMAC	= 0x00000002, /* Per to mem, DMAC cntr */
+	DMA_CTL_TTFC_M2P_PER = 0x00000003, /* Mem to per, peripheral cntr */
+	DMA_CTL_SINC_INC  = 0x00000000, /* Source Address Increment */
+	DMA_CTL_SINC_DEC  = 0x00000200,
+	DMA_CTL_SINC_NOCHANGE =	0x00000400,
+	DMA_CTL_DINC_INC  = 0x00000000, /* Destination Address Increment */
+	DMA_CTL_DINC_DEC  =	0x00000080,
+	DMA_CTL_DINC_NOCHANGE =	0x00000100,
+	DMA_CTL_INT_EN    = 0x00000001, /* Interrupt Enable */
+
+/* Channel Configuration Register high bits */
+	DMA_CFG_FCMOD_REQ = 0x00000001, /* Flow Control - request based */
+	DMA_CFG_PROTCTL   = (0x00000003 << 2),/* Protection Control */
+
+/* Channel Configuration Register low bits */
+	DMA_CFG_RELD_DST  = 0x80000000, /* Reload Dest / Src Addr */
+	DMA_CFG_RELD_SRC  = 0x40000000,
+	DMA_CFG_HS_SELSRC = 0x00000800, /* Software handshake Src/ Dest */
+	DMA_CFG_HS_SELDST = 0x00000400,
+	DMA_CFG_FIFOEMPTY = (0x00000001 << 9), /* FIFO Empty bit */
+
+/* Channel Linked List Pointer Register */
+	DMA_LLP_AHBMASTER1 = 0,	/* List Master Select */
+	DMA_LLP_AHBMASTER2 = 1,
+
+	SATA_DWC_MAX_PORTS = 1,
+
+	SATA_DWC_SCR_OFFSET = 0x24,
+	SATA_DWC_REG_OFFSET = 0x64,
+};
+
+/* DWC SATA Registers */
+struct sata_dwc_regs {
+	u32 fptagr;		/* 1st party DMA tag */
+	u32 fpbor;		/* 1st party DMA buffer offset */
+	u32 fptcr;		/* 1st party DMA Xfr count */
+	u32 dmacr;		/* DMA Control */
+	u32 dbtsr;		/* DMA Burst Transac size */
+	u32 intpr;		/* Interrupt Pending */
+	u32 intmr;		/* Interrupt Mask */
+	u32 errmr;		/* Error Mask */
+	u32 llcr;		/* Link Layer Control */
+	u32 phycr;		/* PHY Control */
+	u32 physr;		/* PHY Status */
+	u32 rxbistpd;		/* Recvd BIST pattern def register */
+	u32 rxbistpd1;		/* Recvd BIST data dword1 */
+	u32 rxbistpd2;		/* Recvd BIST pattern data dword2 */
+	u32 txbistpd;		/* Trans BIST pattern def register */
+	u32 txbistpd1;		/* Trans BIST data dword1 */
+	u32 txbistpd2;		/* Trans BIST data dword2 */
+	u32 bistcr;		/* BIST Control Register */
+	u32 bistfctr;		/* BIST FIS Count Register */
+	u32 bistsr;		/* BIST Status Register */
+	u32 bistdecr;		/* BIST Dword Error count register */
+	u32 res[15];		/* Reserved locations */
+	u32 testr;		/* Test Register */
+	u32 versionr;		/* Version Register */
+	u32 idr;		/* ID Register */
+	u32 unimpl[192];	/* Unimplemented */
+	u32 dmadr[256];		/* FIFO Locations in DMA Mode */
+};
+
+enum {
+	SCR_SCONTROL_DET_ENABLE	= 0x00000001,
+	SCR_SSTATUS_DET_PRESENT	= 0x00000001,
+	SCR_SERROR_DIAG_X	= 0x04000000,
+/* DWC SATA Register Operations */
+	SATA_DWC_TXFIFO_DEPTH	= 0x01FF,
+	SATA_DWC_RXFIFO_DEPTH	= 0x01FF,
+	SATA_DWC_DMACR_TMOD_TXCHEN = 0x00000004,
+	SATA_DWC_DMACR_TXCHEN	= (0x00000001 | SATA_DWC_DMACR_TMOD_TXCHEN),
+	SATA_DWC_DMACR_RXCHEN	= (0x00000002 | SATA_DWC_DMACR_TMOD_TXCHEN),
+	SATA_DWC_DMACR_TXRXCH_CLEAR =	SATA_DWC_DMACR_TMOD_TXCHEN,
+	SATA_DWC_INTPR_DMAT	= 0x00000001,
+	SATA_DWC_INTPR_NEWFP	= 0x00000002,
+	SATA_DWC_INTPR_PMABRT	= 0x00000004,
+	SATA_DWC_INTPR_ERR	= 0x00000008,
+	SATA_DWC_INTPR_NEWBIST	= 0x00000010,
+	SATA_DWC_INTPR_IPF	= 0x10000000,
+	SATA_DWC_INTMR_DMATM	= 0x00000001,
+	SATA_DWC_INTMR_NEWFPM	= 0x00000002,
+	SATA_DWC_INTMR_PMABRTM	= 0x00000004,
+	SATA_DWC_INTMR_ERRM	= 0x00000008,
+	SATA_DWC_INTMR_NEWBISTM	= 0x00000010,
+	SATA_DWC_LLCR_SCRAMEN	= 0x00000001,
+	SATA_DWC_LLCR_DESCRAMEN	= 0x00000002,
+	SATA_DWC_LLCR_RPDEN	= 0x00000004,
+/* This is all error bits, zero's are reserved fields. */
+	SATA_DWC_SERROR_ERR_BITS = 0x0FFF0F03
+};
+
+#define SATA_DWC_SCR0_SPD_GET(v)	(((v) >> 4) & 0x0000000F)
+#define SATA_DWC_DMACR_TX_CLEAR(v)	(((v) & ~SATA_DWC_DMACR_TXCHEN) |\
+						 SATA_DWC_DMACR_TMOD_TXCHEN)
+#define SATA_DWC_DMACR_RX_CLEAR(v)	(((v) & ~SATA_DWC_DMACR_RXCHEN) |\
+						 SATA_DWC_DMACR_TMOD_TXCHEN)
+#define SATA_DWC_DBTSR_MWR(size)	(((size)/4) & SATA_DWC_TXFIFO_DEPTH)
+#define SATA_DWC_DBTSR_MRD(size)	((((size)/4) & SATA_DWC_RXFIFO_DEPTH)\
+						 << 16)
+struct sata_dwc_device {
+	struct device		*dev;		/* generic device struct */
+	struct ata_host		*host;
+	u8			*reg_base;
+	struct sata_dwc_regs	*sata_dwc_regs;	/* DW Synopsys SATA specific */
+	u8			*scr_base;
+	int			dma_channel;	/* DWC SATA DMA channel */
+	int			irq_dma;
+	int			hostID;
+};
+
+#define SATA_DWC_QCMD_MAX	32
+
+struct sata_dwc_device_port {
+	struct sata_dwc_device	*hsdev;
+	struct lli		*llit[SATA_DWC_QCMD_MAX];  /* DMA LLI table */
+	dma_addr_t		llit_dma[SATA_DWC_QCMD_MAX];
+	u32			dma_chan[SATA_DWC_QCMD_MAX];
+	int			dma_pending[SATA_DWC_QCMD_MAX];
+	u32			sata_dwc_sactive_issued;
+	u32			sata_dwc_sactive_queued;
+	u32			dma_interrupt_count;
+};
+
+/*
+ * Commonly used DWC SATA driver Macros
+ */
+#define HSDEV_FROM_HOST(host)	((struct sata_dwc_device *)\
+					(host)->private_data)
+#define HSDEV_FROM_AP(ap)	((struct sata_dwc_device *)\
+					(ap)->host->private_data)
+#define HSDEVP_FROM_AP(ap)	((struct sata_dwc_device_port *)\
+					(ap)->private_data)
+#define HSDEV_FROM_QC(qc)	((struct sata_dwc_device *)\
+					(qc)->ap->host->private_data)
+#define HSDEV_FROM_HSDEVP(p)	((struct sata_dwc_device *)\
+					(hsdevp)->hsdev)
+
+enum {
+	SATA_DWC_DMA_PENDING_NONE	= 0,
+	SATA_DWC_DMA_PENDING_TX		= 1,
+	SATA_DWC_DMA_PENDING_RX		= 2,
+};
+
+/*
+ * Globals
+ */
+static struct sata_dwc_device *dwc_dev_list[2];
+static struct ahb_dma_regs *sata_dma_regs;
+/*
+ * Prototypes
+ */
+static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag);
+static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
+				u32 check_status);
+static void sata_dwc_port_stop(struct ata_port *ap);
+static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag);
+static int dwc_dma_init(struct sata_dwc_device *hsdev, int irq);
+static int dwc_dma_xfer_setup(struct ata_port *ap, dma_addr_t dma_lli);
+static void dwc_dma_xfer_start(int dma_ch);
+static void sata_dwc_init_port(struct ata_port *ap);
+
+
+static const char *get_prot_descript(u8 protocol)
+{
+	switch ((enum ata_tf_protocols)protocol) {
+	case ATA_PROT_NODATA:
+		return "ATA no data";
+	case ATA_PROT_PIO:
+		return "ATA PIO";
+	case ATA_PROT_DMA:
+		return "ATA DMA";
+	case ATA_PROT_NCQ:
+		return "ATA NCQ";
+	case ATAPI_PROT_NODATA:
+		return "ATAPI no data";
+	case ATAPI_PROT_PIO:
+		return "ATAPI PIO";
+	case ATAPI_PROT_DMA:
+		return "ATAPI DMA";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *get_dma_dir_descript(int dma_dir)
+{
+	switch ((enum dma_data_direction)dma_dir) {
+	case DMA_BIDIRECTIONAL:
+		return "bidirectional";
+	case DMA_TO_DEVICE:
+		return "to device";
+	case DMA_FROM_DEVICE:
+		return "from device";
+	default:
+		return "none";
+	}
+}
+
+static void sata_dwc_tf_dump(struct device *dwc_dev, struct ata_taskfile *tf)
+{
+	dev_vdbg(dwc_dev, "taskfile cmd: 0x%02x protocol: %s flags:"
+		"0x%lx device: %x\n", tf->command,
+		get_prot_descript(tf->protocol), tf->flags, tf->device);
+	dev_vdbg(dwc_dev, "feature: 0x%02x nsect: 0x%x lbal: 0x%x "
+		"lbam: 0x%x lbah: 0x%x\n", tf->feature, tf->nsect, tf->lbal,
+		 tf->lbam, tf->lbah);
+	dev_vdbg(dwc_dev, "hob_feature: 0x%02x hob_nsect: 0x%x "
+		"hob_lbal: 0x%x hob_lbam: 0x%x hob_lbah: 0x%x\n",
+		tf->hob_feature, tf->hob_nsect, tf->hob_lbal, tf->hob_lbam,
+		tf->hob_lbah);
+}
+
+/*
+ * Calculate value to be programmed in register corresponding to data length
+ * This value is effectively the log(base 2) of the length
+ */
+static int get_burst_length_encode(int datalength)
+{
+	int items = datalength >> 2;	/* div by 4 to get lword count */
+
+	if (items >= 64)
+		return 5;
+
+	if (items >= 32)
+		return 4;
+
+	if (items >= 16)
+		return 3;
+
+	if (items >= 8)
+		return 2;
+
+	if (items >= 4)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Clear channel interrupt. No interrupt for the specified channel
+ * generated until it is enabled again.
+ */
+static void clear_chan_interrupts(int c)
+{
+	out_le32(&(sata_dma_regs->interrupt_clear.tfr.low), DMA_CHANNEL(c));
+	out_le32(&(sata_dma_regs->interrupt_clear.block.low), DMA_CHANNEL(c));
+	out_le32(&(sata_dma_regs->interrupt_clear.srctran.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(sata_dma_regs->interrupt_clear.dsttran.low),
+		 DMA_CHANNEL(c));
+	out_le32(&(sata_dma_regs->interrupt_clear.error.low), DMA_CHANNEL(c));
+}
+
+/*
+ * Check if the selected DMA channel is currently enabled.
+ */
+static int sata_dwc_dma_chk_en(int ch)
+{
+	u32 dma_chan_reg;
+	/* Read the DMA channel register */
+	dma_chan_reg = in_le32(&(sata_dma_regs->dma_chan_en.low));
+	/* Check if it is currently enabled */
+	if (dma_chan_reg & DMA_CHANNEL(ch))
+		return 1;
+	return 0;
+}
+
+/*
+ * Terminate the current DMA transfer
+ *
+ * Refer to the "Abnormal Transfer Termination" section
+ * Disable the corresponding bit in the ChEnReg register
+ * and poll that register to until the channel is terminated.
+ */
+static void sata_dwc_dma_terminate(struct ata_port *ap, int dma_ch)
+{
+	int enabled = sata_dwc_dma_chk_en(dma_ch);
+	/* If the channel is currenly in use, release it. */
+	if (enabled)  {
+		dev_dbg(ap->dev,
+			"%s terminate DMA on channel=%d (mask=0x%08x) ...",
+			__func__, dma_ch, DMA_DISABLE_CHAN(dma_ch));
+		dev_dbg(ap->dev, "ChEnReg=0x%08x\n",
+			in_le32(&(sata_dma_regs->dma_chan_en.low)));
+		/* Disable the selected channel */
+		out_le32(&(sata_dma_regs->dma_chan_en.low),
+			DMA_DISABLE_CHAN(dma_ch));
+
+		/* Wait for the channel is disabled */
+		do {
+			enabled = sata_dwc_dma_chk_en(dma_ch);
+			ndelay(1000);
+		} while (enabled);
+		dev_dbg(ap->dev, "done\n");
+	}
+}
+
+/*
+ * Check if the DMA channel is currently available for transferring data
+ * on the specified ata_port.
+ */
+static int dma_request_channel(struct ata_port *ap)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+
+	/* Check if the channel is not currently in use */
+	if (!(in_le32(&(sata_dma_regs->dma_chan_en.low)) &\
+		DMA_CHANNEL(hsdev->dma_channel)))
+		return hsdev->dma_channel;
+
+	dev_err(ap->dev, "%s Channel %d is currently in use\n", __func__,
+		hsdev->dma_channel);
+	return -1;
+}
+
+/*
+ * Processing DMA transfer complete interrupt
+ */
+static irqreturn_t dwc_dma_interrupt(int irq, struct sata_dwc_device *hsdev)
+{
+	int chan;
+	u32 tfr_reg, err_reg;
+	unsigned long flags;
+	struct ata_host *host = (struct ata_host *)hsdev->host;
+	struct ata_port *ap;
+	struct sata_dwc_device_port *hsdevp;
+	u8 tag;
+	unsigned int port = 0;
+
+	spin_lock_irqsave(&host->lock, flags);
+	ap = host->ports[port];
+	hsdevp = HSDEVP_FROM_AP(ap);
+
+	/*
+	 * Find the right tag value for the current DMA transfer.
+	 * In case of NCQ transfer, tag for the current transfer is set to
+	 * active_tag.
+	 * For DMA transfer, tag is 0 (active_tag=ATA_TAG_POISION).
+	 */
+	if (ap->link.active_tag != ATA_TAG_POISON)
+		tag = ap->link.active_tag;
+	else
+		tag = 0;
+
+	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
+	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
+	dev_dbg(ap->dev, "eot=0x%08x err=0x%08x pending=%d active port=%d\n",
+		tfr_reg, err_reg, hsdevp->dma_pending[tag], port);
+
+	chan = hsdev->dma_channel;
+	if (chan >= 0) {
+		if (tfr_reg & DMA_CHANNEL(chan)) {
+			/* Clear DMA config after transfer complete */
+			sata_dwc_clear_dmacr(hsdevp, tag);
+
+			/* Clear the interrupt */
+			out_le32(&(sata_dma_regs->interrupt_clear.tfr.low),
+				 DMA_CHANNEL(chan));
+		}
+
+		/* Check for error interrupt, not expect error happens */
+		if (unlikely(err_reg & DMA_CHANNEL(chan))) {
+			dev_err(ap->dev, "error interrupt err_reg=0x%08x\n",
+				err_reg);
+
+			/* Clear the interrupt. */
+			out_le32(&(sata_dma_regs->interrupt_clear\
+				.error.low),
+				 DMA_CHANNEL(chan));
+		}
+	}
+	hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
+
+	if (hsdevp->sata_dwc_sactive_queued == 0)
+		ap->link.active_tag = ATA_TAG_POISON;
+
+	spin_unlock_irqrestore(&host->lock, flags);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Handle DMA transfer complete interrupt. This checks and passes the
+ * processing to the appropriate ATA port.
+ */
+static irqreturn_t dma_dwc_handler(int irq, void *hsdev_instance)
+{
+	u32 tfr_reg, err_reg;
+	int chan;
+
+	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
+	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
+
+	for (chan = 0; chan < DMA_NUM_CHANS; chan++) {
+		/* Check for end-of-transfer interrupt. */
+		if (tfr_reg & DMA_CHANNEL(chan))
+			dwc_dma_interrupt(0, dwc_dev_list[chan]);
+
+		/* Check for error interrupt. */
+		if (err_reg & DMA_CHANNEL(chan))
+			dwc_dma_interrupt(0, dwc_dev_list[chan]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Registers ISR for a particular DMA channel interrupt
+ */
+static int dma_request_interrupts(struct sata_dwc_device *hsdev, int irq)
+{
+	int retval;
+
+	/* Unmask error interrupt */
+	out_le32(&sata_dma_regs->interrupt_mask.error.low,
+		in_le32(&sata_dma_regs->interrupt_mask.error.low) |
+		 DMA_ENABLE_CHAN(hsdev->dma_channel));
+
+	/* Unmask end-of-transfer interrupt */
+	out_le32(&sata_dma_regs->interrupt_mask.tfr.low,
+		in_le32(&sata_dma_regs->interrupt_mask.tfr.low) |
+		 DMA_ENABLE_CHAN(hsdev->dma_channel));
+
+	retval = request_irq(irq, dma_dwc_handler, IRQF_SHARED, "SATA DMA",
+		hsdev);
+	if (retval) {
+		dev_err(hsdev->dev, "%s: could not get IRQ %d\n",\
+		__func__, irq);
+		return -ENODEV;
+	}
+
+	/* Mark this interrupt as requested */
+	hsdev->irq_dma = irq;
+
+	return 0;
+}
+
+/*
+ * The Synopsis driver has a comment proposing that better performance
+ * is possible by only enabling interrupts on the last item in the linked list.
+ * However, it seems that could be a problem if an error happened on one of the
+ * first items.  The transfer would halt, but no error interrupt would occur.
+ * Currently this function sets interrupts enabled for each linked list item:
+ * DMA_CTL_INT_EN.
+ */
+static int map_sg_to_lli(struct ata_port *ap, struct scatterlist *sg,
+			int num_elems, struct lli *lli, dma_addr_t dma_lli,
+			void __iomem *dmadr_addr, int dir)
+{
+	struct device *dwc_dev = ap->dev;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	int i, idx = 0;
+	int fis_len = 0;
+	dma_addr_t next_llp;
+	int bl;
+	u32 sms_val, dms_val;
+
+	dev_dbg(dwc_dev, "%s: sg=%p nelem=%d lli=%p dma_lli=0x%08x"
+		" dmadr=0x%08x\n", __func__, sg, num_elems, lli, (u32)dma_lli,
+		(u32)dmadr_addr);
+
+	bl = get_burst_length_encode(AHB_DMA_BRST_DFLT);
+
+	for (i = 0; i < num_elems; i++, sg++) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		dev_dbg(dwc_dev, "%s: elem=%d sg_addr=0x%x sg_len"
+			"=%d\n", __func__, i, addr, sg_len);
+
+		while (sg_len) {
+			if (unlikely(idx >= SATA_DWC_DMAC_LLI_NUM)) {
+				/* The LLI table is not large enough. */
+				dev_err(dwc_dev, "LLI table overrun "
+				"(idx=%d)\n", idx);
+				break;
+			}
+			len = (sg_len > SATA_DWC_DMAC_CTRL_TSIZE_MAX) ?
+				SATA_DWC_DMAC_CTRL_TSIZE_MAX : sg_len;
+
+			offset = addr & 0xffff;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			/*
+			 * Make sure a LLI block is not created that will span
+			 * 8K max FIS boundary.  If the block spans such a FIS
+			 * boundary, there is a chance that a DMA burst will
+			 * cross that boundary -- this results in an error in
+			 * the host controller.
+			 */
+			if (unlikely(fis_len + len > 8192)) {
+				dev_dbg(dwc_dev, "SPLITTING: fis_len="
+					"%d(0x%x) len=%d(0x%x)\n", fis_len,
+					 fis_len, len, len);
+				len = 8192 - fis_len;
+				fis_len = 0;
+			} else {
+				fis_len += len;
+			}
+			if (fis_len == 8192)
+				fis_len = 0;
+
+			/*
+			 * Set DMA addresses and lower half of control register
+			 * based on direction.
+			 */
+			if (hsdevp->hsdev->hostID == APM_821XX_SATA) {
+				sms_val = 1+hsdevp->hsdev->dma_channel;
+				dms_val = 0;
+			} else {
+				sms_val = 0;
+				dms_val = 1+hsdevp->hsdev->dma_channel;
+			}
+
+			if (dir == DMA_FROM_DEVICE) {
+				lli[idx].dar = cpu_to_le32(addr);
+				lli[idx].sar = cpu_to_le32((u32)dmadr_addr);
+
+				lli[idx].ctl.low = cpu_to_le32(
+					DMA_CTL_TTFC(DMA_CTL_TTFC_P2M_DMAC) |
+					DMA_CTL_SMS(sms_val) |
+					DMA_CTL_DMS(dms_val) |
+					DMA_CTL_SRC_MSIZE(bl) |
+					DMA_CTL_DST_MSIZE(bl) |
+					DMA_CTL_SINC_NOCHANGE |
+					DMA_CTL_SRC_TRWID(2) |
+					DMA_CTL_DST_TRWID(2) |
+					DMA_CTL_INT_EN |
+					DMA_CTL_LLP_SRCEN |
+					DMA_CTL_LLP_DSTEN);
+			} else { /* DMA_TO_DEVICE */
+				lli[idx].sar = cpu_to_le32(addr);
+				lli[idx].dar = cpu_to_le32((u32)dmadr_addr);
+
+				lli[idx].ctl.low = cpu_to_le32(
+					DMA_CTL_TTFC(DMA_CTL_TTFC_M2P_PER) |
+					DMA_CTL_SMS(dms_val) |
+					DMA_CTL_DMS(sms_val) |
+					DMA_CTL_SRC_MSIZE(bl) |
+					DMA_CTL_DST_MSIZE(bl) |
+					DMA_CTL_DINC_NOCHANGE |
+					DMA_CTL_SRC_TRWID(2) |
+					DMA_CTL_DST_TRWID(2) |
+					DMA_CTL_INT_EN |
+					DMA_CTL_LLP_SRCEN |
+					DMA_CTL_LLP_DSTEN);
+			}
+
+			dev_dbg(dwc_dev, "%s setting ctl.high len: "
+				"0x%08x val: 0x%08x\n", __func__,
+				len, DMA_CTL_BLK_TS(len / 4));
+
+			/* Program the LLI CTL high register */
+			lli[idx].ctl.high = cpu_to_le32(DMA_CTL_BLK_TS\
+						(len / 4));
+
+			/* Program the next pointer.  The next pointer must be
+			 * the physical address, not the virtual address.
+			 */
+			next_llp = (dma_lli + ((idx + 1) * sizeof(struct \
+							lli)));
+
+			/* The last 2 bits encode the list master select. */
+			if (hsdevp->hsdev->hostID == APM_460EX_SATA) {
+				next_llp = DMA_LLP_LMS(next_llp,
+					DMA_LLP_AHBMASTER2);
+			} else {
+				next_llp = DMA_LLP_LMS(next_llp,
+					DMA_LLP_AHBMASTER1);
+			}
+
+			lli[idx].llp = cpu_to_le32(next_llp);
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	/*
+	 * The last next ptr has to be zero and the last control low register
+	 * has to have LLP_SRC_EN and LLP_DST_EN (linked list pointer source
+	 * and destination enable) set back to 0 (disabled.) This is what tells
+	 * the core that this is the last item in the linked list.
+	 */
+	if (likely(idx)) {
+		lli[idx-1].llp = 0x00000000;
+		lli[idx-1].ctl.low &= DMA_CTL_LLP_DISABLE_LE32;
+
+		/* Flush cache to memory */
+		dma_cache_sync(NULL, lli, (sizeof(struct lli) * idx),
+			       DMA_BIDIRECTIONAL);
+	}
+
+	return idx;
+}
+
+/*
+ * Enables the DMA channel to start transferring data
+ */
+static void dwc_dma_xfer_start(int dma_ch)
+{
+	/* Enable the DMA channel */
+	out_le32(&(sata_dma_regs->dma_chan_en.low),
+		 in_le32(&(sata_dma_regs->dma_chan_en.low)) |
+		 DMA_ENABLE_CHAN(dma_ch));
+}
+
+
+static int dwc_dma_xfer_setup(struct ata_port *ap, dma_addr_t dma_lli)
+{
+	int dma_ch;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	/* Acquire DMA channel */
+	dma_ch = dma_request_channel(ap);
+	if (unlikely(dma_ch == -1)) {
+		dev_err(ap->dev, "%s: dma channel unavailable\n", __func__);
+		return -EAGAIN;
+	}
+
+	clear_chan_interrupts(dma_ch);
+
+	/* Program the CFG register. */
+	out_le32(&(sata_dma_regs->chan_regs[dma_ch].cfg.high),
+		 DMA_CFG_HW_HS_SRC(dma_ch) | DMA_CFG_HW_HS_DEST(dma_ch) | \
+		 DMA_CFG_PROTCTL | DMA_CFG_FCMOD_REQ);
+
+	out_le32(&(sata_dma_regs->chan_regs[dma_ch].cfg.low),
+		DMA_CFG_HW_CH_PRIOR(dma_ch));
+
+	/* Program the address of the linked list */
+	if (hsdev->hostID == APM_460EX_SATA) {
+		out_le32(&(sata_dma_regs->chan_regs[dma_ch].llp.low),
+			DMA_LLP_LMS(dma_lli, DMA_LLP_AHBMASTER2));
+	} else {
+		out_le32(&(sata_dma_regs->chan_regs[dma_ch].llp.low),
+			DMA_LLP_LMS(dma_lli, DMA_LLP_AHBMASTER1));
+	}
+
+	/* Program the CTL register with src enable / dst enable */
+	out_le32(&(sata_dma_regs->chan_regs[dma_ch].ctl.low),
+		 DMA_CTL_LLP_SRCEN | DMA_CTL_LLP_DSTEN);
+	return dma_ch;
+}
+
+/*
+ * Initializes the SATA DMA driver
+ */
+static int dwc_dma_init(struct sata_dwc_device *hsdev, int irq)
+{
+	int err;
+
+	err = dma_request_interrupts(hsdev, irq);
+	if (err) {
+		dev_err(hsdev->dev, "%s: dma_request_interrupts returns %d\n",
+			__func__, err);
+		return err;
+	}
+
+	/* Enabe DMA support */
+	out_le32(&(sata_dma_regs->dma_cfg.low), DMA_EN);
+
+	dev_notice(hsdev->dev, "DMA initialized\n");
+	dev_dbg(hsdev->dev, "SATA DMA registers=0x%p\n", sata_dma_regs);
+
+	return 0;
+}
+
+static int sata_dwc_scr_read(struct ata_link *link, unsigned int scr, u32 *val)
+{
+	if (unlikely(scr > SCR_NOTIFICATION)) {
+		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
+			__func__, scr);
+		return -EINVAL;
+	}
+
+	*val = in_le32((void *)link->ap->ioaddr.scr_addr + (scr * 4));
+	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=0x%08x\n",
+		__func__, link->ap->print_id, scr, *val);
+
+	return 0;
+}
+
+static int sata_dwc_scr_write(struct ata_link *link, unsigned int scr, u32 val)
+{
+	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=val=0x%08x\n",
+		__func__, link->ap->print_id, scr, val);
+	if (unlikely(scr > SCR_NOTIFICATION)) {
+		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
+			 __func__, scr);
+		return -EINVAL;
+	}
+	out_le32((void *)link->ap->ioaddr.scr_addr + (scr * 4), val);
+
+	return 0;
+}
+
+static u32 core_scr_read(struct ata_port *ap, unsigned int scr)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	return in_le32((void __iomem *)hsdev->scr_base + (scr * 4));
+}
+
+
+static void core_scr_write(struct ata_port *ap, unsigned int scr, u32 val)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	out_le32((void __iomem *)hsdev->scr_base + (scr * 4), val);
+}
+
+static void clear_serror(struct ata_port *ap)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	out_le32((void __iomem *)hsdev->scr_base + 4,
+		in_le32((void __iomem *)hsdev->scr_base + 4));
+
+}
+
+static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
+{
+	out_le32(&hsdev->sata_dwc_regs->intpr,
+		 in_le32(&hsdev->sata_dwc_regs->intpr));
+}
+
+/*
+ * Porting the ata_bus_softreset function from the libata-sff.c library.
+ */
+static int sata_dwc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+		unsigned long deadline)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
+
+	/* Software reset.  causes dev0 to be selected */
+	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	udelay(20);	/* FIXME: flush */
+	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+	udelay(20);	/* FIXME: flush */
+	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = ap->ctl;
+
+	/* Wait the port to become ready */
+	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
+}
+
+/*
+ * Do soft reset on the current SATA link.
+ */
+static int sata_dwc_softreset(struct ata_link *link, unsigned int *classes,
+				unsigned long deadline)
+{
+	int rc;
+	u8 err;
+	struct ata_port *ap = link->ap;
+	unsigned int devmask = 0;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+
+	/* Select device 0 again */
+	ap->ops->sff_dev_select(ap, 0);
+
+	DPRINTK("about to softreset, devmask=%x\n", devmask);
+	rc = sata_dwc_bus_softreset(ap, devmask, deadline);
+
+	/* If link is occupied, -ENODEV too is an error */
+	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
+		ata_link_printk(link, KERN_ERR, "SRST failed(errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* Determine by signature whether we have ATA or ATAPI devices */
+	classes[0] = ata_sff_dev_classify(&link->device[0],
+				devmask & (1 << 0), &err);
+
+	DPRINTK("EXIT, classes[0]=%u [1]=%u\n", classes[0], classes[1]);
+	clear_serror(link->ap);
+
+	/* Terminate DMA if it is currently in use */
+	sata_dwc_dma_terminate(link->ap, hsdev->dma_channel);
+
+	return rc;
+}
+
+/*
+ * Reset all internal parameters to default value.
+ * This function should be called in hardreset
+ */
+static void dwc_reset_internal_params(struct ata_port *ap)
+{
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	int tag;
+	for (tag = 0; tag < SATA_DWC_QCMD_MAX; tag++)
+		hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
+
+	hsdevp->sata_dwc_sactive_issued = 0;
+	hsdevp->sata_dwc_sactive_queued = 0;
+}
+
+static int sata_dwc_hardreset(struct ata_link *link, unsigned int *classes,
+			unsigned long deadline)
+{
+	int rc;
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	bool online;
+
+	/* Reset internal parameters to default values */
+	dwc_reset_internal_params(link->ap);
+
+	/* Call standard hard reset */
+	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+
+	/* Reconfigure the port after hard reset */
+	if (ata_link_online(link))
+		sata_dwc_init_port(link->ap);
+
+	return online ? -EAGAIN : rc;
+}
+
+static u32 qcmd_tag_to_mask(u8 tag)
+{
+	return 0x00000001 << (tag & 0x1f);
+}
+
+static void sata_dwc_error_intr(struct ata_port *ap,
+				struct sata_dwc_device *hsdev, uint intpr)
+{
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	unsigned int err_mask = 0, action = 0;
+	struct ata_queued_cmd *qc;
+	u32 serror;
+	u8 status, tag;
+	u32 err_reg;
+
+	ata_ehi_clear_desc(ehi);
+
+	serror = core_scr_read(ap, SCR_ERROR);
+	status = ap->ops->sff_check_status(ap);
+
+	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
+	tag = ap->link.active_tag;
+
+	dev_err(ap->dev, "%s SCR_ERROR=0x%08x intpr=0x%08x status=0x%08x "
+		" pending=%d dma_err_status=0x%08x\n",
+		__func__, serror, intpr, status, hsdevp->dma_pending[tag],
+		err_reg);
+
+	/* Clear error register and interrupt bit */
+	clear_serror(ap);
+	clear_interrupt_bit(hsdev, SATA_DWC_INTPR_ERR);
+
+	/* This is the only error happening now.  TODO check for exact error */
+	err_mask |= AC_ERR_HOST_BUS;
+	action |= ATA_EH_RESET;
+
+	/* Pass this on to EH */
+	ehi->serror |= serror;
+	ehi->action |= action;
+
+	qc = ata_qc_from_tag(ap, tag);
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	ata_port_abort(ap);
+}
+
+/*
+ * This Interrupt handler called via port ops registered function.
+ */
+static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
+{
+	struct ata_host *host = (struct ata_host *)dev_instance;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc;
+	u8 status, tag;
+	int handled, port = 0;
+	int num_lli;
+	uint intpr, sactive, tag_mask;
+	struct sata_dwc_device_port *hsdevp;
+	u32 mask;
+
+	spin_lock(&host->lock);
+
+	/* Read the interrupt register */
+	intpr = in_le32(&hsdev->sata_dwc_regs->intpr);
+
+	ap = host->ports[port];
+	hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s intpr=0x%08x active_tag=%d\n", __func__, intpr,
+		ap->link.active_tag);
+
+	/* Check for error interrupt */
+	if (intpr & SATA_DWC_INTPR_ERR) {
+		sata_dwc_error_intr(ap, hsdev, intpr);
+		handled = 1;
+		goto DONE;
+	}
+
+	/* Check for DMA SETUP FIS (FP DMA) interrupt */
+	if (intpr & SATA_DWC_INTPR_NEWFP) {
+		clear_interrupt_bit(hsdev, SATA_DWC_INTPR_NEWFP);
+		if (ap->qc_allocated == 0x0) {
+			handled = 1;
+			goto DONE;
+		}
+
+		tag = (u8)(in_le32(&hsdev->sata_dwc_regs->fptagr));
+		mask = qcmd_tag_to_mask(tag);
+		dev_dbg(ap->dev, "%s: NEWFP tag=%d\n", __func__, tag);
+		if ((hsdevp->sata_dwc_sactive_queued & mask) == 0)
+			dev_warn(ap->dev, "CMD tag=%d not pending?\n", tag);
+
+		qc = ata_qc_from_tag(ap, tag);
+		/*
+		 * Start FP DMA for NCQ command.  At this point the tag is the
+		 * active tag.  It is the tag that matches the command about to
+		 * be completed.
+		 */
+		if (qc) {
+			hsdevp->sata_dwc_sactive_issued |= mask;
+			/* Prevent to issue more commands */
+			qc->ap->link.active_tag = tag;
+			qc->dev->link->sactive |= (1 << qc->tag);
+			num_lli = map_sg_to_lli(ap, qc->sg, qc->n_elem, \
+				hsdevp->llit[tag], hsdevp->llit_dma[tag], \
+				(void *__iomem)(&hsdev->sata_dwc_regs->dmadr), \
+				qc->dma_dir);
+			sata_dwc_bmdma_start_by_tag(qc, tag);
+			wmb();
+			qc->ap->hsm_task_state = HSM_ST_LAST;
+		} else {
+		    hsdevp->sata_dwc_sactive_issued &= ~mask;
+		    dev_warn(ap->dev, "No QC available for tag %d (intpr="
+		    "0x%08x, qc_allocated=0x%08x, qc_active=0x%08x)\n", tag,\
+			intpr, ap->qc_allocated, ap->qc_active);
+		}
+
+		handled = 1;
+		goto DONE;
+	}
+
+	sactive = core_scr_read(ap, SCR_ACTIVE);
+	tag_mask = (hsdevp->sata_dwc_sactive_issued | sactive) ^ sactive;
+
+	/*
+	 * If no sactive issued and tag_mask is zero then this is not NCQ.
+	 * Do actions for transfer completion interrupt.
+	 */
+	if (hsdevp->sata_dwc_sactive_issued == 0 && tag_mask == 0) {
+		if (ap->link.active_tag == ATA_TAG_POISON)
+			tag = 0;
+		else
+			tag = ap->link.active_tag;
+		qc = ata_qc_from_tag(ap, tag);
+
+		/* Device interrupt without active qc? */
+		if (unlikely(!qc || (qc->tf.flags & ATA_TFLAG_POLLING))) {
+			dev_err(ap->dev, "%s interrupt with no active qc "
+				"qc=%p\n", __func__, qc);
+			ap->ops->sff_check_status(ap);
+			handled = 1;
+			goto DONE;
+		}
+		/* Get current status and clear interrupt */
+		status = ap->ops->sff_check_status(ap);
+
+		if (status & ATA_ERR) {
+			dev_dbg(ap->dev, "interrupt ATA_ERR (0x%x)\n", status);
+			sata_dwc_qc_complete(ap, qc, 1);
+			handled = 1;
+			goto DONE;
+		}
+
+		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
+			__func__, get_prot_descript(qc->tf.protocol));
+DRVSTILLBUSY:
+		/* Do complete action for the current QC */
+		if (ata_is_dma(qc->tf.protocol)) {
+			sata_dwc_qc_complete(ap, qc, 1);
+		} else if ((ata_is_pio(qc->tf.protocol)) ||
+			(ata_is_nodata(qc->tf.protocol))) {
+			ata_sff_hsm_move(ap, qc, status, 0);
+		} else {
+			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
+				goto DRVSTILLBUSY;
+		}
+
+		handled = 1;
+		goto DONE;
+	}
+
+	/*
+	 * This is a NCQ command. At this point we need to figure out for which
+	 * tags we have gotten a completion interrupt.  One interrupt may serve
+	 * as completion for more than one operation when commands are queued
+	 * (NCQ).  We need to process each completed command.
+	 */
+	if (sactive != 0 || hsdevp->sata_dwc_sactive_issued > 1 || \
+							tag_mask > 1) {
+		dev_dbg(ap->dev, "%s NCQ:sactive=0x%08x  sactive_issued=0x%08x"
+			"tag_mask=0x%08x\n", __func__, sactive,
+			hsdevp->sata_dwc_sactive_issued, tag_mask);
+	}
+
+	if (unlikely((tag_mask | hsdevp->sata_dwc_sactive_issued) != \
+					hsdevp->sata_dwc_sactive_issued)) {
+		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
+			 "sata_dwc_sactive_issued=0x%08x  tag_mask"
+			 "=0x%08x\n", sactive, hsdevp->sata_dwc_sactive_issued,
+			  tag_mask);
+	}
+
+	/* Read just to clear ... not bad if currently still busy */
+	status = ap->ops->sff_check_status(ap);
+	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
+
+	for (tag = 0; tag < 32; tag++) {
+		if (tag_mask & qcmd_tag_to_mask(tag)) {
+			qc = ata_qc_from_tag(ap, tag);
+			if (!qc) {
+				dev_info(ap->dev, "error: Tag %d is set but " \
+					"not available\n", tag);
+				continue;
+			}
+			sata_dwc_qc_complete(ap, qc, 1);
+		}
+	}
+	handled = 1;
+
+DONE:
+	spin_unlock(&host->lock);
+	return IRQ_RETVAL(handled);
+}
+
+static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_HSDEVP(hsdevp);
+
+	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX) {
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			 SATA_DWC_DMACR_RX_CLEAR(
+				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
+	} else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX) {
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			 SATA_DWC_DMACR_TX_CLEAR(
+				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
+	} else {
+		/*
+		 * This should not happen, it indicates the driver is out of
+		 * sync.  If it does happen, clear dmacr anyway.
+		 */
+		dev_err(hsdev->dev, "%s DMA protocol RX and"
+			" TX DMA not pending tag=0x%02x pending=%d"
+			" dmacr: 0x%08x\n", __func__, tag,
+			hsdevp->dma_pending[tag],
+			in_le32(&(hsdev->sata_dwc_regs->dmacr)));
+		out_le32(&(hsdev->sata_dwc_regs->dmacr),
+			SATA_DWC_DMACR_TXRXCH_CLEAR);
+	}
+}
+
+
+static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
+				u32 check_status)
+{
+	u8 status;
+	int i;
+	u8 tag = qc->tag;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	u32 serror;
+	dev_dbg(ap->dev, "%s checkstatus? %x\n", __func__, check_status);
+
+	/* Check main status, clearing INTRQ */
+	status = ap->ops->sff_check_status(ap);
+
+	if (check_status) {
+		i = 0;
+		while (status & ATA_BUSY) {
+			if (++i > 10)
+				break;
+			status = ap->ops->sff_check_altstatus(ap);
+		};
+
+		if (unlikely(status & ATA_BUSY))
+			dev_err(ap->dev, "QC complete cmd=0x%02x STATUS BUSY "
+				"(0x%02x) [%d]\n", qc->tf.command, status, i);
+		serror = core_scr_read(ap, SCR_ERROR);
+		if (unlikely(serror & SATA_DWC_SERROR_ERR_BITS))
+			dev_err(ap->dev, "****** SERROR=0x%08x ******\n",
+				serror);
+	}
+	dev_dbg(ap->dev, "QC complete cmd=0x%02x status=0x%02x ata%u:"
+		" protocol=%d\n", qc->tf.command, status, ap->print_id,
+		 qc->tf.protocol);
+
+	hsdevp->sata_dwc_sactive_issued &= ~qcmd_tag_to_mask(tag);
+
+	/* Complete taskfile transaction (does not read SCR registers) */
+	if (ata_is_atapi(qc->tf.protocol))
+		ata_sff_hsm_move(ap, qc, status, 0);
+	else
+		ata_qc_complete(qc);
+
+	if (hsdevp->sata_dwc_sactive_queued == 0)
+		ap->link.active_tag = ATA_TAG_POISON;
+
+	return 0;
+}
+
+static void sata_dwc_enable_interrupts(struct sata_dwc_device *hsdev)
+{
+	/* Enable selective interrupts by setting the interrupt maskregister*/
+	out_le32(&hsdev->sata_dwc_regs->intmr,
+		 SATA_DWC_INTMR_ERRM |
+		 SATA_DWC_INTMR_NEWFPM |
+		 SATA_DWC_INTMR_PMABRTM |
+		 SATA_DWC_INTMR_DMATM |
+		 SATA_DWC_INTPR_IPF);
+	/*
+	 * Unmask the error bits that should trigger an error interrupt by
+	 * setting the error mask register.
+	 */
+	out_le32(&hsdev->sata_dwc_regs->errmr, SATA_DWC_SERROR_ERR_BITS);
+
+	dev_dbg(hsdev->dev, "%s: INTMR = 0x%08x, ERRMR = 0x%08x\n",
+		 __func__, in_le32(&hsdev->sata_dwc_regs->intmr),
+		in_le32(&hsdev->sata_dwc_regs->errmr));
+}
+
+static void sata_dwc_init_port(struct ata_port *ap)
+{
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+
+	/* Configure DMA */
+	if (ap->port_no == 0)  {
+		dev_dbg(ap->dev, "%s: clearing TXCHEN, RXCHEN in DMAC\n",
+				__func__);
+
+		/* Clear all transmit/receive bits */
+		out_le32(&hsdev->sata_dwc_regs->dmacr,
+			 SATA_DWC_DMACR_TXRXCH_CLEAR);
+
+		dev_dbg(ap->dev, "%s: setting burst size DBTSR\n", __func__);
+		out_le32(&hsdev->sata_dwc_regs->dbtsr,
+			 (SATA_DWC_DBTSR_MWR(AHB_DMA_BRST_DFLT) |
+			  SATA_DWC_DBTSR_MRD(AHB_DMA_BRST_DFLT)));
+	}
+
+	/* Enable interrupts */
+	sata_dwc_enable_interrupts(hsdev);
+}
+
+static void sata_dwc_setup_port(struct ata_ioports *port, unsigned long base)
+{
+	port->cmd_addr = (void *)base + 0x00;
+	port->data_addr = (void *)base + 0x00;
+
+	port->error_addr = (void *)base + 0x04;
+	port->feature_addr = (void *)base + 0x04;
+
+	port->nsect_addr = (void *)base + 0x08;
+
+	port->lbal_addr = (void *)base + 0x0c;
+	port->lbam_addr = (void *)base + 0x10;
+	port->lbah_addr = (void *)base + 0x14;
+
+	port->device_addr = (void *)base + 0x18;
+	port->command_addr = (void *)base + 0x1c;
+	port->status_addr = (void *)base + 0x1c;
+
+	port->altstatus_addr = (void *)base + 0x20;
+	port->ctl_addr = (void *)base + 0x20;
+}
+
+/*
+ * Allocates the scatter gather LLI table for AHB DMA
+ */
+static int sata_dwc_port_start(struct ata_port *ap)
+{
+	int err = 0;
+	struct sata_dwc_device *hsdev;
+	struct sata_dwc_device_port *hsdevp = NULL;
+	struct device *pdev;
+	u32 sstatus;
+	int i;
+
+	hsdev = HSDEV_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s: port_no=%d\n", __func__, ap->port_no);
+
+	hsdev->host = ap->host;
+	pdev = ap->host->dev;
+	if (!pdev) {
+		dev_err(ap->dev, "%s: no ap->host->dev\n", __func__);
+		err = -ENODEV;
+		goto CLEANUP;
+	}
+
+	/* Allocate Port Struct */
+	hsdevp = kzalloc(sizeof(*hsdevp), GFP_KERNEL);
+	if (!hsdevp) {
+		dev_err(ap->dev, "%s: kmalloc failed for hsdevp\n", __func__);
+		err = -ENOMEM;
+		goto CLEANUP;
+	}
+	memset(hsdevp, 0, sizeof(*hsdevp));
+	hsdevp->hsdev = hsdev;
+
+	ap->bmdma_prd = 0;  /* set these so libata doesn't use them */
+	ap->bmdma_prd_dma = 0;
+
+	/*
+	 * DMA - Assign scatter gather LLI table. We can't use the libata
+	 * version since it's PRD is IDE PCI specific.
+	 */
+	for (i = 0; i < SATA_DWC_QCMD_MAX; i++) {
+		hsdevp->llit[i] = dma_alloc_coherent(pdev,
+						     SATA_DWC_DMAC_LLI_TBL_SZ,
+						     &(hsdevp->llit_dma[i]),
+						     GFP_ATOMIC);
+		if (!hsdevp->llit[i]) {
+			dev_err(ap->dev, "%s: dma_alloc_coherent failed\n",
+				 __func__);
+			err = -ENOMEM;
+			goto CLEANUP;
+		}
+	}
+
+	if (ap->port_no == 0)  {
+		dev_dbg(ap->dev, "%s: clearing TXCHEN, RXCHEN in DMAC\n",
+			__func__);
+		out_le32(&hsdev->sata_dwc_regs->dmacr,
+			 SATA_DWC_DMACR_TXRXCH_CLEAR);
+
+		dev_dbg(ap->dev, "%s: setting burst size in DBTSR\n",
+			 __func__);
+		out_le32(&hsdev->sata_dwc_regs->dbtsr,
+			 (SATA_DWC_DBTSR_MWR(AHB_DMA_BRST_DFLT) |
+			  SATA_DWC_DBTSR_MRD(AHB_DMA_BRST_DFLT)));
+	}
+
+	/* Clear any error bits before libata starts issuing commands */
+	clear_serror(ap);
+	ap->private_data = hsdevp;
+
+	/* Are we in Gen I or II */
+	sstatus = core_scr_read(ap, SCR_STATUS);
+	switch (SATA_DWC_SCR0_SPD_GET(sstatus)) {
+	case 0x0:
+		dev_info(ap->dev, "**** No neg speed (nothing attached?)\n");
+		break;
+	case 0x1:
+		dev_info(ap->dev, "**** GEN I speed rate negotiated\n");
+		break;
+	case 0x2:
+		dev_info(ap->dev, "**** GEN II speed rate negotiated\n");
+		break;
+	}
+
+	dev_dbg(ap->dev, "%s: done\n", __func__);
+	return 0;
+
+CLEANUP:
+	sata_dwc_port_stop(ap);
+	kfree(hsdevp);
+	dev_dbg(ap->dev, "%s: fail\n", __func__);
+
+	return err;
+}
+
+static void sata_dwc_port_stop(struct ata_port *ap)
+{
+	int i;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s: ap->id = %d\n", __func__, ap->print_id);
+
+	if (hsdevp) {
+		/* De-allocate LLI table */
+		for (i = 0; i < SATA_DWC_QCMD_MAX; i++) {
+			dma_free_coherent(ap->host->dev,
+				SATA_DWC_DMAC_LLI_TBL_SZ,
+				hsdevp->llit[i], hsdevp->llit_dma[i]);
+		}
+
+		kfree(hsdevp);
+	}
+	ap->private_data = NULL;
+}
+
+/*
+ * As our SATA is master only, no dev_select function needed.
+ * This just overwrite the ata_sff_dev_select() function in
+ * libata-sff
+ */
+void sata_dwc_dev_select(struct ata_port *ap, unsigned int device)
+{
+	ndelay(100);
+}
+
+/**
+ * Filter ATAPI cmds which are unsuitable for DMA.
+ *
+ * The bmdma engines cannot handle speculative data sizes
+ * (bytecount under/over flow). So only allow DMA for
+ * data transfer commands with known data sizes.
+ */
+static int sata_dwc_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	int pio = 1; /* ATAPI DMA disabled by default */
+	unsigned int lba;
+
+	if (scmd) {
+		switch (scmd->cmnd[0]) {
+		case WRITE_6:
+		case WRITE_10:
+		case WRITE_12:
+		case READ_6:
+		case READ_10:
+		case READ_12:
+			pio = 0; /* DMA is safe */
+			break;
+		}
+
+		/* Command WRITE_10 with LBA between -45150 (FFFF4FA2)
+		 * and -1 (FFFFFFFF) shall use PIO mode */
+		if (scmd->cmnd[0] == WRITE_10) {
+			lba = (scmd->cmnd[2] << 24) |
+				(scmd->cmnd[3] << 16) |
+				(scmd->cmnd[4] << 8) |
+				 scmd->cmnd[5];
+			if (lba >= 0xFFFF4FA2)
+				pio = 1;
+		}
+		/*
+		* WORK AROUND: Fix DMA issue when blank CD/DVD disc
+		* in the drive and user use the 'fdisk -l' command.
+		* No DMA data returned so we can not complete the QC.
+		*/
+		if (scmd->cmnd[0] == READ_10) {
+			lba = (scmd->cmnd[2] << 24) |
+				  (scmd->cmnd[3] << 16) |
+				  (scmd->cmnd[4] << 8) |
+				   scmd->cmnd[5];
+			if (lba < 0x20)
+				pio = 1;
+		}
+	}
+	dev_dbg(qc->ap->dev, "%s - using %s mode for command cmd=0x%02x\n", \
+		__func__, (pio ? "PIO" : "DMA"), scmd->cmnd[0]);
+	return pio;
+}
+
+/*
+ * Keeps track of individual command tag ids and calls ata_exec_command
+ * in libata
+ */
+static void sata_dwc_exec_command_by_tag(struct ata_port *ap,
+					 struct ata_taskfile *tf,
+					 u8 tag)
+{
+	unsigned long flags;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+
+	dev_dbg(ap->dev, "%s cmd(0x%02x): %s tag=%d\n", __func__, tf->command,
+		ata_get_cmd_descript(tf->command), tag);
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	hsdevp->sata_dwc_sactive_queued |= qcmd_tag_to_mask(tag);
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+	/*
+	 * Clear SError before executing a new command.
+	 * sata_dwc_scr_write and read can not be used here. Clearing the PM
+	 * managed SError register for the disk needs to be done before the
+	 * task file is loaded.
+	 */
+	clear_serror(ap);
+	ata_sff_exec_command(ap, tf);
+}
+
+
+static void sata_dwc_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	u8 tag = qc->tag;
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x tag=%d\n",
+			__func__, qc->ap->link.sactive, tag);
+	} else {
+		tag = 0;
+	}
+
+	sata_dwc_exec_command_by_tag(qc->ap, &qc->tf, tag);
+}
+
+static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag)
+{
+	int start_dma;
+	u32 reg, dma_chan;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_QC(qc);
+	struct ata_port *ap = qc->ap;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	int dir = qc->dma_dir;
+
+	/* Configure DMA before starting data transfer */
+	dma_chan = dwc_dma_xfer_setup(ap, hsdevp->llit_dma[tag]);
+	if (unlikely(dma_chan < 0)) {
+		dev_err(ap->dev, "%s: dma channel unavailable\n", __func__);
+		/* Offending this QC as no channel available for transfer */
+		qc->err_mask |= AC_ERR_TIMEOUT;
+		return;
+	}
+
+	/* Check if DMA should be started */
+	hsdevp->dma_chan[tag] = dma_chan;
+	if (hsdevp->sata_dwc_sactive_queued & qcmd_tag_to_mask(tag)) {
+		start_dma = 1;
+		if (dir == DMA_TO_DEVICE)
+			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_TX;
+		else
+			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_RX;
+	} else {
+		dev_err(ap->dev, "%s: No pending cmd at tag %d\n",
+			__func__, tag);
+		start_dma = 0;
+	}
+
+	dev_dbg(ap->dev, "%s qc=%p tag: %x cmd: 0x%02x dma_dir: %s "
+		"start_dma? %x\n", __func__, qc, tag, qc->tf.command,
+		get_dma_dir_descript(qc->dma_dir), start_dma);
+	sata_dwc_tf_dump(hsdev->dev, &(qc->tf));
+
+	/* Enable to start DMA transfer */
+	if (start_dma) {
+		reg = core_scr_read(ap, SCR_ERROR);
+		if (unlikely(reg & SATA_DWC_SERROR_ERR_BITS)) {
+			dev_err(ap->dev, "%s: ****** SError=0x%08x ******\n",
+				__func__, reg);
+		}
+
+		if (dir == DMA_TO_DEVICE) {
+			out_le32(&hsdev->sata_dwc_regs->dmacr,
+				SATA_DWC_DMACR_TXCHEN);
+		} else {
+			out_le32(&hsdev->sata_dwc_regs->dmacr,
+				SATA_DWC_DMACR_RXCHEN);
+		}
+
+		/* Enable AHB DMA transfer on the specified channel */
+		dwc_dma_xfer_start(dma_chan);
+		hsdevp->sata_dwc_sactive_queued &= ~qcmd_tag_to_mask(tag);
+	}
+}
+
+static void sata_dwc_bmdma_start(struct ata_queued_cmd *qc)
+{
+	u8 tag = qc->tag;
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		dev_dbg(qc->ap->dev, "%s: ap->link.sactive=0x%08x tag=%d\n",
+			__func__, qc->ap->link.sactive, tag);
+	} else {
+		tag = 0;
+	}
+	dev_dbg(qc->ap->dev, "%s\n", __func__);
+	sata_dwc_bmdma_start_by_tag(qc, tag);
+}
+
+static u8 sata_dwc_dma_status(struct ata_port *ap)
+{
+	u32 status = 0;
+	u32 tfr_reg, err_reg;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+
+	/* Check DMA register for status */
+	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
+	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
+
+	if (unlikely(err_reg & DMA_CHANNEL(hsdev->dma_channel)))
+		status = ATA_DMA_ERR | ATA_DMA_INTR;
+	else if (tfr_reg & DMA_CHANNEL(hsdev->dma_channel))
+		status = ATA_DMA_INTR;
+	return status;
+}
+
+/*
+ * Prepare for a particular queued command based on tag
+ */
+static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
+{
+	struct scatterlist *sg = qc->sg;
+	struct ata_port *ap = qc->ap;
+	int num_lli;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+
+	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
+		return;
+	dev_dbg(ap->dev, "%s: port=%d dma dir=%s n_elem=%d\n",
+		__func__, ap->port_no, get_dma_dir_descript(qc->dma_dir),
+		 qc->n_elem);
+
+	if (!ata_is_ncq(qc->tf.protocol)) {
+		num_lli = map_sg_to_lli(qc->ap, sg, qc->n_elem,
+			hsdevp->llit[tag], hsdevp->llit_dma[tag],
+			(void *__iomem)(&hsdev->sata_dwc_regs->dmadr),
+			qc->dma_dir);
+	}
+}
+
+int sata_dwc_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
+	u8 status;
+	int ret;
+
+	dev_dbg(qc->ap->dev, "%s -\n", __func__);
+	ret = ata_std_qc_defer(qc);
+	if (ret) {
+		printk(KERN_DEBUG "STD Defer %s cmd %s tag=%d\n",
+			(ret == ATA_DEFER_LINK) ? "LINK" : "PORT",
+			ata_get_cmd_descript(qc->tf.command), qc->tag);
+		return ret;
+	}
+
+	/* Check the SATA host for busy status */
+	if (ata_is_ncq(qc->tf.protocol)) {
+		status = ap->ops->sff_check_altstatus(ap);
+		if (status & ATA_BUSY) {
+			dev_dbg(ap->dev,
+				"Defer PORT cmd %s tag=%d as host is busy\n",
+				ata_get_cmd_descript(qc->tf.command), qc->tag);
+			return ATA_DEFER_PORT;/*HOST BUSY*/
+		}
+
+		/* This will prevent collision error */
+		if (hsdevp->sata_dwc_sactive_issued) {
+			dev_dbg(ap->dev, "Defer PORT cmd %s with tag %d " \
+				"because another dma xfer is outstanding\n",
+				ata_get_cmd_descript(qc->tf.command), qc->tag);
+
+			return ATA_DEFER_PORT;/*DEVICE&HOST BUSY*/
+		}
+
+	}
+
+	return 0;
+}
+
+void sata_dwc_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	/* If we have an mmio device with no ctl and no altstatus
+	 * method, this will fail. No such devices are known to exist.
+	 */
+	if (ap->ioaddr.altstatus_addr)
+		ioread8(ap->ioaddr.altstatus_addr);
+
+	ndelay(400);
+}
+
+static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
+{
+	u32 sactive;
+	u8 tag = qc->tag;
+	struct ata_port *ap = qc->ap;
+	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(qc->ap);
+	u8 status;
+
+#ifdef DEBUG_NCQ
+	if (qc->tag > 0 || ap->link.sactive > 1)
+		dev_info(ap->dev, "%s ap id=%d cmd(0x%02x)=%s qc tag=%d "
+			 "prot=%s ap active_tag=0x%08x ap sactive=0x%08x\n",
+			 __func__, ap->print_id, qc->tf.command,
+			 ata_get_cmd_descript(qc->tf.command),
+			 qc->tag, get_prot_descript(qc->tf.protocol),
+			 ap->link.active_tag, ap->link.sactive);
+#endif
+
+	if (!ata_is_ncq(qc->tf.protocol))
+		tag = 0;
+	sata_dwc_qc_prep_by_tag(qc, tag);
+
+	if (ata_is_ncq(qc->tf.protocol)) {
+		status = ap->ops->sff_check_altstatus(ap);
+		if (status & ATA_BUSY) {
+			/* Ignore the QC when device is BUSY */
+			sactive = core_scr_read(qc->ap, SCR_ACTIVE);
+			dev_info(ap->dev, "Ignore current QC as device BUSY"
+				"tag=%d, sactive=0x%08x)\n", qc->tag, sactive);
+			return AC_ERR_SYSTEM;
+		}
+
+		if (hsdevp->sata_dwc_sactive_issued)
+			return AC_ERR_SYSTEM;
+
+		sactive = core_scr_read(qc->ap, SCR_ACTIVE);
+		sactive |= (0x00000001 << tag);
+		qc->dev->link->sactive |= (0x00000001 << tag);
+		core_scr_write(qc->ap, SCR_ACTIVE, sactive);
+
+		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x "
+			"sactive=0x%x\n", __func__, tag, qc->ap->link.sactive,
+			sactive);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);
+		sata_dwc_exec_command_by_tag(ap, &qc->tf, qc->tag);
+	} else {
+		ap->link.active_tag = qc->tag;
+		/* Pass QC to libata-sff to process */
+		ata_bmdma_qc_issue(qc);
+	}
+	return 0;
+}
+
+/*
+ * Prepare for a particular queued command
+ */
+
+static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
+{
+	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO)
+		|| (qc->tf.protocol == ATAPI_PROT_PIO))
+		return;
+
+#ifdef DEBUG_NCQ
+	if (qc->tag > 0)
+		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
+			 __func__, qc->tag, qc->ap->link.active_tag);
+#endif
+}
+
+/*
+ * Get the QC currently used for transferring data
+ */
+static struct ata_queued_cmd *sata_dwc_get_active_qc(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
+		return qc;
+	return NULL;
+}
+
+/*
+ * dwc_lost_interrupt -  check and process if interrupt is lost.
+ * @ap: ATA port
+ *
+ * Process the command when it is timeout.
+ * Check to see if interrupt is lost. If yes, complete the qc.
+ */
+static void sata_dwc_lost_interrupt(struct ata_port *ap)
+{
+	u8 status;
+	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
+	struct ata_queued_cmd *qc;
+
+	dev_dbg(ap->dev, "%s -\n", __func__);
+	/* Only one outstanding command per SFF channel */
+	qc = sata_dwc_get_active_qc(ap);
+	/* We cannot lose an interrupt on a non-existent or polled command */
+	if (!qc)
+		return;
+
+	/* See if the controller thinks it is still busy - if so the command
+	 isn't a lost IRQ but is still in progress */
+	status = ap->ops->sff_check_altstatus(ap);
+	if (status & ATA_BUSY) {
+		ata_port_printk(ap, KERN_INFO, "%s - ATA_BUSY\n", __func__);
+		return;
+	}
+
+	/* There was a command running, we are no longer busy and we have
+	   no interrupt. */
+	ata_link_printk(qc->dev->link, KERN_WARNING,
+		"lost interrupt (Status 0x%x)\n", status);
+
+	if (sata_dwc_dma_chk_en(hsdev->dma_channel)) {
+		/* When DMA does transfer does not complete,
+		 see if DMA fails */
+		qc->err_mask |= AC_ERR_DEV;
+		ap->hsm_task_state = HSM_ST_ERR;
+		sata_dwc_dma_terminate(ap, hsdev->dma_channel);
+	}
+	sata_dwc_qc_complete(ap, qc, 1);
+}
+
+
+static void sata_dwc_error_handler(struct ata_port *ap)
+{
+	bool thaw = false;
+	struct ata_queued_cmd *qc;
+	u8 status = ap->ops->bmdma_status(ap);
+
+	qc = sata_dwc_get_active_qc(ap);
+	/* In case of DMA timeout, process it. */
+	if (qc && ata_is_dma(qc->tf.protocol)) {
+		if ((qc->err_mask == AC_ERR_TIMEOUT)
+			&& (status & ATA_DMA_ERR)) {
+			qc->err_mask = AC_ERR_HOST_BUS;
+			thaw = true;
+		}
+
+		if (thaw) {
+			ap->ops->sff_check_status(ap);
+			if (ap->ops->sff_irq_clear)
+				ap->ops->sff_irq_clear(ap);
+		}
+	}
+	if (thaw)
+		ata_eh_thaw_port(ap);
+
+	ata_sff_error_handler(ap);
+}
+
+u8 sata_dwc_check_status(struct ata_port *ap)
+{
+	return ioread8(ap->ioaddr.status_addr);
+}
+
+u8 sata_dwc_check_altstatus(struct ata_port *ap)
+{
+	return ioread8(ap->ioaddr.altstatus_addr);
+}
+
+/*
+ * scsi mid-layer and libata interface structures
+ */
+static struct scsi_host_template sata_dwc_sht = {
+	ATA_NCQ_SHT(DRV_NAME),
+	.sg_tablesize  = LIBATA_MAX_PRD,
+	/*
+	 * test-only: Currently this driver doesn't handle NCQ
+	 * correctly. We enable NCQ but set the queue depth to a
+	 * max of 1. This will get fixed in in a future release.
+	 */
+	.can_queue     = ATA_DEF_QUEUE, /*ATA_MAX_QUEUE, */
+	.dma_boundary  = ATA_DMA_BOUNDARY,
+};
+
+static struct ata_port_operations sata_dwc_ops = {
+	.inherits       = &ata_sff_port_ops,
+
+	.error_handler  = sata_dwc_error_handler,
+	.softreset      = sata_dwc_softreset,
+	.hardreset      = sata_dwc_hardreset,
+
+	.qc_defer       = sata_dwc_qc_defer,
+	.qc_prep        = sata_dwc_qc_prep,
+	.qc_issue       = sata_dwc_qc_issue,
+
+	.scr_read       = sata_dwc_scr_read,
+	.scr_write      = sata_dwc_scr_write,
+
+	.port_start     = sata_dwc_port_start,
+	.port_stop      = sata_dwc_port_stop,
+
+	.check_atapi_dma = sata_dwc_check_atapi_dma,
+	.bmdma_setup    = sata_dwc_bmdma_setup,
+	.bmdma_start    = sata_dwc_bmdma_start,
+	.bmdma_status   = sata_dwc_dma_status,
+
+	.sff_dev_select = sata_dwc_dev_select,
+	.sff_check_status = sata_dwc_check_status,
+	.sff_check_altstatus = sata_dwc_check_altstatus,
+	.sff_exec_command = sata_dwc_exec_command,
+
+	.lost_interrupt = sata_dwc_lost_interrupt,
+};
+
+static const struct ata_port_info sata_dwc_port_info[] = {
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NCQ,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &sata_dwc_ops,
+	},
+};
+
+static int sata_dwc_probe(struct platform_device *ofdev)
+{
+	struct sata_dwc_device *hsdev;
+	u32 idr, versionr;
+	char *ver = (char *)&versionr;
+	u8 *base = NULL;
+	int err = 0;
+	int irq, rc;
+	struct ata_host *host;
+	struct ata_port_info pi = sata_dwc_port_info[0];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+
+	const unsigned int *dma_chan;
+
+	/* Check if device is declared in device tree */
+	if (!of_device_is_available(ofdev->dev.of_node)) {
+		printk(KERN_INFO "%s: Port disabled via device-tree\n",
+		ofdev->dev.of_node->full_name);
+		return 0;
+	}
+
+	/* Allocate DWC SATA device */
+	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);
+	if (hsdev == NULL) {
+		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
+		err = -ENOMEM;
+		goto error_out_5;
+	}
+	memset(hsdev, 0, sizeof(*hsdev));
+
+	/* Identify host controller using compatible attribute */
+	if (of_device_is_compatible(ofdev->dev.of_node, "amcc,sata-460ex")) {
+		printk(KERN_INFO "\n\nSATA is compatible for sata-460ex\n\n");
+		hsdev->hostID = APM_460EX_SATA;
+	} else {
+		printk(KERN_INFO "\n\nSATA is compatible for sata-821xx\n\n");
+		hsdev->hostID = APM_821XX_SATA;
+	}
+
+	/* Identify SATA controller index from the cell-index property */
+	dma_chan = of_get_property(ofdev->dev.of_node, "dma-channel", NULL);
+	if (dma_chan) {
+		dev_notice(&ofdev->dev, "Getting DMA channel %d\n", *dma_chan);
+		hsdev->dma_channel = *dma_chan;
+	} else {
+		hsdev->dma_channel = 0;
+	}
+
+	/* Get base address from device tree */
+	base = of_iomap(ofdev->dev.of_node, 0);
+	if (!base) {
+		dev_err(&ofdev->dev,
+			"ioremap failed for SATA register address\n");
+		err = -ENODEV;
+		goto error_out_4;
+	}
+	hsdev->reg_base = base;
+	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
+
+	/* Synopsys DWC SATA specific Registers */
+	hsdev->sata_dwc_regs = (void *__iomem)(base + SATA_DWC_REG_OFFSET);
+
+	/* Allocate and fill host */
+	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_DWC_MAX_PORTS);
+	if (!host) {
+		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
+		err = -ENOMEM;
+		goto error_out_4;
+	}
+
+	host->private_data = hsdev;
+
+	/* Setup port */
+	host->ports[0]->ioaddr.cmd_addr = base;
+	host->ports[0]->ioaddr.scr_addr = base + SATA_DWC_SCR_OFFSET;
+	hsdev->scr_base = (u8 *)(base + SATA_DWC_SCR_OFFSET);
+	sata_dwc_setup_port(&host->ports[0]->ioaddr, (unsigned long)base);
+
+	/* Read the ID and Version Registers */
+	idr = in_le32(&hsdev->sata_dwc_regs->idr);
+	versionr = in_le32(&hsdev->sata_dwc_regs->versionr);
+	dev_notice(&ofdev->dev, "id %d, controller version %c.%c%c\n",
+		   idr, ver[0], ver[1], ver[2]);
+
+	/* Get SATA DMA interrupt number */
+	irq = irq_of_parse_and_map(ofdev->dev.of_node, 1);
+	if (irq == NO_IRQ) {
+		dev_err(&ofdev->dev, "no SATA DMA irq\n");
+		err = -ENODEV;
+		goto error_out_3;
+	}
+
+	/* Save dev for later use in dev_xxx() routines */
+	hsdev->dev = &ofdev->dev;
+
+	/* Init glovbal dev list */
+	dwc_dev_list[hsdev->dma_channel] = hsdev;
+
+	/* Get physical SATA DMA register base address */
+	if (sata_dma_regs == NULL) {
+		sata_dma_regs = of_iomap(ofdev->dev.of_node, 1);
+		if (sata_dma_regs == NULL) {
+			dev_err(&ofdev->dev,
+				"ioremap failed for AHBDMA register address\n");
+			err = -ENODEV;
+			goto error_out_2;
+		}
+
+		/* Initialize AHB DMAC */
+		rc = dwc_dma_init(hsdev, irq);
+		if (rc != 0)
+			goto error_out_1;
+	}
+
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
+
+	/* Get SATA interrupt number */
+	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	if (irq == NO_IRQ) {
+		dev_err(&ofdev->dev, "no SATA irq\n");
+		err = -ENODEV;
+		goto error_out_1;
+	}
+
+	/*
+	 * Now, register with libATA core, this will also initiate the
+	 * device discovery process, invoking our port_start() handler &
+	 * error_handler() to execute a dummy Softreset EH session
+	 */
+	rc = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
+
+	if (rc != 0)
+		dev_err(&ofdev->dev, "failed to activate host");
+
+	dev_set_drvdata(&ofdev->dev, host);
+
+	return 0;
+
+error_out_1:
+	iounmap(sata_dma_regs);
+
+error_out_2:
+	free_irq(hsdev->irq_dma, hsdev);
+
+error_out_3:
+	iounmap(base);
+
+error_out_4:
+	kfree(hsdev);
+
+error_out_5:
+	return err;
+}
+
+static int sata_dwc_remove(struct platform_device *ofdev)
+{
+	struct device *dev = &ofdev->dev;
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct sata_dwc_device *hsdev = host->private_data;
+
+	ata_host_detach(host);
+	dev_set_drvdata(dev, NULL);
+
+	/* Free SATA DMA resources */
+	iounmap(sata_dma_regs);
+	free_irq(hsdev->irq_dma, hsdev);
+
+	/* Free internal resources */
+	iounmap(hsdev->reg_base);
+	kfree(hsdev);
+	kfree(host);
+	dev_dbg(&ofdev->dev, "done\n");
+	return 0;
+}
+
+static const struct of_device_id sata_dwc_match[] = {
+	{ .compatible = "amcc,sata-460ex", },
+	{ .compatible = "amcc,sata-apm821xx", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sata_dwc_match);
+
+static struct platform_driver sata_dwc_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = sata_dwc_match,
+	},
+	.probe = sata_dwc_probe,
+	.remove = sata_dwc_remove,
+};
+
+static int __init sata_dwc_init(void)
+{
+	return platform_driver_register(&sata_dwc_driver);
+}
+
+static void __exit sata_dwc_exit(void)
+{
+	platform_driver_unregister(&sata_dwc_driver);
+}
+
+module_init(sata_dwc_init);
+module_exit(sata_dwc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mark Miesfeld <mmiesfeld@amcc.com>");
+MODULE_DESCRIPTION("DesignWare Cores SATA controller low lever driver");
+MODULE_VERSION(DRV_VERSION);
-- 
1.7.3.4

CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information 
that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.

