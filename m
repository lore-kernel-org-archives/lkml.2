Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072Ab2JKTIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:08:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36138 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab2JKTDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:03:54 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 02/16] ARM: davinci: move private EDMA API to arm/common
Date: Thu, 11 Oct 2012 15:04:27 -0400
Message-Id: <1349982281-10785-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349982281-10785-1-git-send-email-mporter@ti.com>
References: <1349982281-10785-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mach-davinci/dma.c to common/edma.c so it can be used
by OMAP (specifically AM33xx) as well. This just moves the
private EDMA API but does not support OMAP.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/Kconfig                               |    1 +
 arch/arm/common/Kconfig                        |    3 +
 arch/arm/common/Makefile                       |    1 +
 arch/arm/{mach-davinci/dma.c => common/edma.c} |    2 +-
 arch/arm/mach-davinci/Makefile                 |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c    |    2 +-
 arch/arm/mach-davinci/davinci.h                |    2 +-
 arch/arm/mach-davinci/devices-tnetv107x.c      |    2 +-
 arch/arm/mach-davinci/devices.c                |    7 +-
 arch/arm/mach-davinci/dm355.c                  |    2 +-
 arch/arm/mach-davinci/dm365.c                  |    2 +-
 arch/arm/mach-davinci/dm644x.c                 |    2 +-
 arch/arm/mach-davinci/dm646x.c                 |    2 +-
 arch/arm/mach-davinci/include/mach/da8xx.h     |    2 +-
 arch/arm/mach-davinci/include/mach/edma.h      |  267 ------------------------
 arch/arm/plat-omap/Kconfig                     |    1 +
 drivers/dma/edma.c                             |    2 +-
 drivers/mmc/host/davinci_mmc.c                 |    1 +
 include/linux/mfd/davinci_voicecodec.h         |    3 +-
 include/linux/platform_data/edma.h             |  198 ++++++++++++++++++
 include/linux/platform_data/spi-davinci.h      |    2 +-
 sound/soc/davinci/davinci-evm.c                |    1 +
 sound/soc/davinci/davinci-pcm.c                |    1 +
 sound/soc/davinci/davinci-pcm.h                |    2 +-
 sound/soc/davinci/davinci-sffsdr.c             |    6 +-
 25 files changed, 228 insertions(+), 288 deletions(-)
 rename arch/arm/{mach-davinci/dma.c => common/edma.c} (99%)
 delete mode 100644 arch/arm/mach-davinci/include/mach/edma.h
 create mode 100644 include/linux/platform_data/edma.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 767aae8..56b7b23 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -911,6 +911,7 @@ config ARCH_DAVINCI
 	select GENERIC_IRQ_CHIP
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select NEED_MACH_GPIO_H
+	select TI_PRIV_EDMA
 	help
 	  Support for TI's DaVinci platform.
 
diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
index 283fa1d..bd87838 100644
--- a/arch/arm/common/Kconfig
+++ b/arch/arm/common/Kconfig
@@ -40,3 +40,6 @@ config SHARP_PARAM
 
 config SHARP_SCOOP
 	bool
+
+config TI_PRIV_EDMA
+	bool
diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index e8a4e58..d09a39b 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SHARP_PARAM)	+= sharpsl_param.o
 obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
+obj-$(CONFIG_TI_PRIV_EDMA)	+= edma.o
diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/common/edma.c
similarity index 99%
rename from arch/arm/mach-davinci/dma.c
rename to arch/arm/common/edma.c
index a685e97..4411087 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/common/edma.c
@@ -25,7 +25,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 /* Offsets matching "struct edmacc_param" */
 #define PARM_OPT		0x00
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 2227eff..97c639e 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -5,7 +5,7 @@
 
 # Common objects
 obj-y 			:= time.o clock.o serial.o psc.o \
-			   dma.o usb.o common.o sram.o aemif.o
+			   usb.o common.o sram.o aemif.o
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index be30997..86f55ba 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -26,12 +26,12 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
 #include <mach/irqs.h>
-#include <mach/edma.h>
 #include <mach/mux.h>
 #include <mach/cp_intc.h>
 #include <mach/tnetv107x.h>
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 12d544b..d26a6bc 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -23,9 +23,9 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/platform_data/davinci_asp.h>
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/keyscan-davinci.h>
 #include <mach/hardware.h>
-#include <mach/edma.h>
 
 #include <media/davinci/vpfe_capture.h>
 #include <media/davinci/vpif_types.h>
diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 29b17f7..59efd7f 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -18,10 +18,10 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/platform_data/edma.h>
 
 #include <mach/common.h>
 #include <mach/irqs.h>
-#include <mach/edma.h>
 #include <mach/tnetv107x.h>
 
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 4c48a36..f45d591 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -19,9 +19,10 @@
 #include <mach/irqs.h>
 #include <mach/cputype.h>
 #include <mach/mux.h>
-#include <mach/edma.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <mach/time.h>
+#include <linux/platform_data/edma.h>
+
 
 #include "davinci.h"
 #include "clock.h"
@@ -141,10 +142,10 @@ static struct resource mmcsd0_resources[] = {
 	},
 	/* DMA channels: RX, then TX */
 	{
-		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCRXEVT),
+		.start = EDMA_CTLR_CHAN(0, 26),
 		.flags = IORESOURCE_DMA,
 	}, {
-		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCTXEVT),
+		.start = EDMA_CTLR_CHAN(0, 27),
 		.flags = IORESOURCE_DMA,
 	},
 };
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index a255434..b165c27 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -19,7 +19,6 @@
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
 #include <mach/irqs.h>
@@ -28,6 +27,7 @@
 #include <mach/common.h>
 #include <linux/platform_data/spi-davinci.h>
 #include <mach/gpio-davinci.h>
+#include <linux/platform_data/edma.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index b680c83..a611716 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -18,11 +18,11 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 0755d46..0949dc4 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -12,11 +12,11 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/irqs.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 97c0f8e..08f9dab 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -13,11 +13,11 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/irqs.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index c9ee723..750936a 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -19,8 +19,8 @@
 #include <linux/platform_data/davinci_asp.h>
 
 #include <mach/serial.h>
-#include <mach/edma.h>
 #include <mach/pm.h>
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/i2c-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
diff --git a/arch/arm/mach-davinci/include/mach/edma.h b/arch/arm/mach-davinci/include/mach/edma.h
deleted file mode 100644
index 7e84c90..0000000
--- a/arch/arm/mach-davinci/include/mach/edma.h
+++ /dev/null
@@ -1,267 +0,0 @@
-/*
- *  TI DAVINCI dma definitions
- *
- *  Copyright (C) 2006-2009 Texas Instruments.
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-/*
- * This EDMA3 programming framework exposes two basic kinds of resource:
- *
- *  Channel	Triggers transfers, usually from a hardware event but
- *		also manually or by "chaining" from DMA completions.
- *		Each channel is coupled to a Parameter RAM (PaRAM) slot.
- *
- *  Slot	Each PaRAM slot holds a DMA transfer descriptor (PaRAM
- *		"set"), source and destination addresses, a link to a
- *		next PaRAM slot (if any), options for the transfer, and
- *		instructions for updating those addresses.  There are
- *		more than twice as many slots as event channels.
- *
- * Each PaRAM set describes a sequence of transfers, either for one large
- * buffer or for several discontiguous smaller buffers.  An EDMA transfer
- * is driven only from a channel, which performs the transfers specified
- * in its PaRAM slot until there are no more transfers.  When that last
- * transfer completes, the "link" field may be used to reload the channel's
- * PaRAM slot with a new transfer descriptor.
- *
- * The EDMA Channel Controller (CC) maps requests from channels into physical
- * Transfer Controller (TC) requests when the channel triggers (by hardware
- * or software events, or by chaining).  The two physical DMA channels provided
- * by the TCs are thus shared by many logical channels.
- *
- * DaVinci hardware also has a "QDMA" mechanism which is not currently
- * supported through this interface.  (DSP firmware uses it though.)
- */
-
-#ifndef EDMA_H_
-#define EDMA_H_
-
-/* PaRAM slots are laid out like this */
-struct edmacc_param {
-	unsigned int opt;
-	unsigned int src;
-	unsigned int a_b_cnt;
-	unsigned int dst;
-	unsigned int src_dst_bidx;
-	unsigned int link_bcntrld;
-	unsigned int src_dst_cidx;
-	unsigned int ccnt;
-};
-
-#define CCINT0_INTERRUPT     16
-#define CCERRINT_INTERRUPT   17
-#define TCERRINT0_INTERRUPT   18
-#define TCERRINT1_INTERRUPT   19
-
-/* fields in edmacc_param.opt */
-#define SAM		BIT(0)
-#define DAM		BIT(1)
-#define SYNCDIM		BIT(2)
-#define STATIC		BIT(3)
-#define EDMA_FWID	(0x07 << 8)
-#define TCCMODE		BIT(11)
-#define EDMA_TCC(t)	((t) << 12)
-#define TCINTEN		BIT(20)
-#define ITCINTEN	BIT(21)
-#define TCCHEN		BIT(22)
-#define ITCCHEN		BIT(23)
-
-#define TRWORD (0x7<<2)
-#define PAENTRY (0x1ff<<5)
-
-/* Drivers should avoid using these symbolic names for dm644x
- * channels, and use platform_device IORESOURCE_DMA resources
- * instead.  (Other DaVinci chips have different peripherals
- * and thus have different DMA channel mappings.)
- */
-#define DAVINCI_DMA_MCBSP_TX              2
-#define DAVINCI_DMA_MCBSP_RX              3
-#define DAVINCI_DMA_VPSS_HIST             4
-#define DAVINCI_DMA_VPSS_H3A              5
-#define DAVINCI_DMA_VPSS_PRVU             6
-#define DAVINCI_DMA_VPSS_RSZ              7
-#define DAVINCI_DMA_IMCOP_IMXINT          8
-#define DAVINCI_DMA_IMCOP_VLCDINT         9
-#define DAVINCI_DMA_IMCO_PASQINT         10
-#define DAVINCI_DMA_IMCOP_DSQINT         11
-#define DAVINCI_DMA_SPI_SPIX             16
-#define DAVINCI_DMA_SPI_SPIR             17
-#define DAVINCI_DMA_UART0_URXEVT0        18
-#define DAVINCI_DMA_UART0_UTXEVT0        19
-#define DAVINCI_DMA_UART1_URXEVT1        20
-#define DAVINCI_DMA_UART1_UTXEVT1        21
-#define DAVINCI_DMA_UART2_URXEVT2        22
-#define DAVINCI_DMA_UART2_UTXEVT2        23
-#define DAVINCI_DMA_MEMSTK_MSEVT         24
-#define DAVINCI_DMA_MMCRXEVT             26
-#define DAVINCI_DMA_MMCTXEVT             27
-#define DAVINCI_DMA_I2C_ICREVT           28
-#define DAVINCI_DMA_I2C_ICXEVT           29
-#define DAVINCI_DMA_GPIO_GPINT0          32
-#define DAVINCI_DMA_GPIO_GPINT1          33
-#define DAVINCI_DMA_GPIO_GPINT2          34
-#define DAVINCI_DMA_GPIO_GPINT3          35
-#define DAVINCI_DMA_GPIO_GPINT4          36
-#define DAVINCI_DMA_GPIO_GPINT5          37
-#define DAVINCI_DMA_GPIO_GPINT6          38
-#define DAVINCI_DMA_GPIO_GPINT7          39
-#define DAVINCI_DMA_GPIO_GPBNKINT0       40
-#define DAVINCI_DMA_GPIO_GPBNKINT1       41
-#define DAVINCI_DMA_GPIO_GPBNKINT2       42
-#define DAVINCI_DMA_GPIO_GPBNKINT3       43
-#define DAVINCI_DMA_GPIO_GPBNKINT4       44
-#define DAVINCI_DMA_TIMER0_TINT0         48
-#define DAVINCI_DMA_TIMER1_TINT1         49
-#define DAVINCI_DMA_TIMER2_TINT2         50
-#define DAVINCI_DMA_TIMER3_TINT3         51
-#define DAVINCI_DMA_PWM0                 52
-#define DAVINCI_DMA_PWM1                 53
-#define DAVINCI_DMA_PWM2                 54
-
-/* DA830 specific EDMA3 information */
-#define EDMA_DA830_NUM_DMACH		32
-#define EDMA_DA830_NUM_TCC		32
-#define EDMA_DA830_NUM_PARAMENTRY	128
-#define EDMA_DA830_NUM_EVQUE		2
-#define EDMA_DA830_NUM_TC		2
-#define EDMA_DA830_CHMAP_EXIST		0
-#define EDMA_DA830_NUM_REGIONS		4
-#define DA830_DMACH2EVENT_MAP0		0x000FC03Fu
-#define DA830_DMACH2EVENT_MAP1		0x00000000u
-#define DA830_EDMA_ARM_OWN		0x30FFCCFFu
-
-/*ch_status paramater of callback function possible values*/
-#define DMA_COMPLETE 1
-#define DMA_CC_ERROR 2
-#define DMA_TC1_ERROR 3
-#define DMA_TC2_ERROR 4
-
-enum address_mode {
-	INCR = 0,
-	FIFO = 1
-};
-
-enum fifo_width {
-	W8BIT = 0,
-	W16BIT = 1,
-	W32BIT = 2,
-	W64BIT = 3,
-	W128BIT = 4,
-	W256BIT = 5
-};
-
-enum dma_event_q {
-	EVENTQ_0 = 0,
-	EVENTQ_1 = 1,
-	EVENTQ_2 = 2,
-	EVENTQ_3 = 3,
-	EVENTQ_DEFAULT = -1
-};
-
-enum sync_dimension {
-	ASYNC = 0,
-	ABSYNC = 1
-};
-
-#define EDMA_CTLR_CHAN(ctlr, chan)	(((ctlr) << 16) | (chan))
-#define EDMA_CTLR(i)			((i) >> 16)
-#define EDMA_CHAN_SLOT(i)		((i) & 0xffff)
-
-#define EDMA_CHANNEL_ANY		-1	/* for edma_alloc_channel() */
-#define EDMA_SLOT_ANY			-1	/* for edma_alloc_slot() */
-#define EDMA_CONT_PARAMS_ANY		 1001
-#define EDMA_CONT_PARAMS_FIXED_EXACT	 1002
-#define EDMA_CONT_PARAMS_FIXED_NOT_EXACT 1003
-
-#define EDMA_MAX_CC               2
-
-/* alloc/free DMA channels and their dedicated parameter RAM slots */
-int edma_alloc_channel(int channel,
-	void (*callback)(unsigned channel, u16 ch_status, void *data),
-	void *data, enum dma_event_q);
-void edma_free_channel(unsigned channel);
-
-/* alloc/free parameter RAM slots */
-int edma_alloc_slot(unsigned ctlr, int slot);
-void edma_free_slot(unsigned slot);
-
-/* alloc/free a set of contiguous parameter RAM slots */
-int edma_alloc_cont_slots(unsigned ctlr, unsigned int id, int slot, int count);
-int edma_free_cont_slots(unsigned slot, int count);
-
-/* calls that operate on part of a parameter RAM slot */
-void edma_set_src(unsigned slot, dma_addr_t src_port,
-				enum address_mode mode, enum fifo_width);
-void edma_set_dest(unsigned slot, dma_addr_t dest_port,
-				 enum address_mode mode, enum fifo_width);
-void edma_get_position(unsigned slot, dma_addr_t *src, dma_addr_t *dst);
-void edma_set_src_index(unsigned slot, s16 src_bidx, s16 src_cidx);
-void edma_set_dest_index(unsigned slot, s16 dest_bidx, s16 dest_cidx);
-void edma_set_transfer_params(unsigned slot, u16 acnt, u16 bcnt, u16 ccnt,
-		u16 bcnt_rld, enum sync_dimension sync_mode);
-void edma_link(unsigned from, unsigned to);
-void edma_unlink(unsigned from);
-
-/* calls that operate on an entire parameter RAM slot */
-void edma_write_slot(unsigned slot, const struct edmacc_param *params);
-void edma_read_slot(unsigned slot, struct edmacc_param *params);
-
-/* channel control operations */
-int edma_start(unsigned channel);
-void edma_stop(unsigned channel);
-void edma_clean_channel(unsigned channel);
-void edma_clear_event(unsigned channel);
-void edma_pause(unsigned channel);
-void edma_resume(unsigned channel);
-
-struct edma_rsv_info {
-
-	const s16	(*rsv_chans)[2];
-	const s16	(*rsv_slots)[2];
-};
-
-/* platform_data for EDMA driver */
-struct edma_soc_info {
-
-	/* how many dma resources of each type */
-	unsigned	n_channel;
-	unsigned	n_region;
-	unsigned	n_slot;
-	unsigned	n_tc;
-	unsigned	n_cc;
-	/*
-	 * Default queue is expected to be a low-priority queue.
-	 * This way, long transfers on the default queue started
-	 * by the codec engine will not cause audio defects.
-	 */
-	enum dma_event_q	default_queue;
-
-	/* Resource reservation for other cores */
-	struct edma_rsv_info	*rsv;
-
-	const s8	(*queue_tc_mapping)[2];
-	const s8	(*queue_priority_mapping)[2];
-};
-
-#endif
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index c9d1c36..2aa70cd 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -29,6 +29,7 @@ config ARCH_OMAP2PLUS
 	select OMAP_DM_TIMER
 	select USE_OF
 	select PROC_DEVICETREE if PROC_FS
+	select TI_PRIV_EDMA
 	help
 	  "Systems based on OMAP2, OMAP3, OMAP4 or OMAP5"
 
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index fdcf079..47ba7bf 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 2063677..f5d46ea 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -35,6 +35,7 @@
 #include <linux/edma.h>
 #include <linux/mmc/mmc.h>
 
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/mmc-davinci.h>
 
 /*
diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
index 0ab6132..7dd6524 100644
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@ -26,8 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
-
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 /*
  * Register values.
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
new file mode 100644
index 0000000..7396f0b3
--- /dev/null
+++ b/include/linux/platform_data/edma.h
@@ -0,0 +1,198 @@
+/*
+ *  TI DAVINCI dma definitions
+ *
+ *  Copyright (C) 2006-2009 Texas Instruments.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+/*
+ * This EDMA3 programming framework exposes two basic kinds of resource:
+ *
+ *  Channel	Triggers transfers, usually from a hardware event but
+ *		also manually or by "chaining" from DMA completions.
+ *		Each channel is coupled to a Parameter RAM (PaRAM) slot.
+ *
+ *  Slot	Each PaRAM slot holds a DMA transfer descriptor (PaRAM
+ *		"set"), source and destination addresses, a link to a
+ *		next PaRAM slot (if any), options for the transfer, and
+ *		instructions for updating those addresses.  There are
+ *		more than twice as many slots as event channels.
+ *
+ * Each PaRAM set describes a sequence of transfers, either for one large
+ * buffer or for several discontiguous smaller buffers.  An EDMA transfer
+ * is driven only from a channel, which performs the transfers specified
+ * in its PaRAM slot until there are no more transfers.  When that last
+ * transfer completes, the "link" field may be used to reload the channel's
+ * PaRAM slot with a new transfer descriptor.
+ *
+ * The EDMA Channel Controller (CC) maps requests from channels into physical
+ * Transfer Controller (TC) requests when the channel triggers (by hardware
+ * or software events, or by chaining).  The two physical DMA channels provided
+ * by the TCs are thus shared by many logical channels.
+ *
+ * DaVinci hardware also has a "QDMA" mechanism which is not currently
+ * supported through this interface.  (DSP firmware uses it though.)
+ */
+
+#ifndef EDMA_H_
+#define EDMA_H_
+
+/* PaRAM slots are laid out like this */
+struct edmacc_param {
+	unsigned int opt;
+	unsigned int src;
+	unsigned int a_b_cnt;
+	unsigned int dst;
+	unsigned int src_dst_bidx;
+	unsigned int link_bcntrld;
+	unsigned int src_dst_cidx;
+	unsigned int ccnt;
+};
+
+/* fields in edmacc_param.opt */
+#define SAM		BIT(0)
+#define DAM		BIT(1)
+#define SYNCDIM		BIT(2)
+#define STATIC		BIT(3)
+#define EDMA_FWID	(0x07 << 8)
+#define TCCMODE		BIT(11)
+#define EDMA_TCC(t)	((t) << 12)
+#define TCINTEN		BIT(20)
+#define ITCINTEN	BIT(21)
+#define TCCHEN		BIT(22)
+#define ITCCHEN		BIT(23)
+
+/*ch_status paramater of callback function possible values*/
+#define DMA_COMPLETE 1
+#define DMA_CC_ERROR 2
+#define DMA_TC1_ERROR 3
+#define DMA_TC2_ERROR 4
+
+enum address_mode {
+	INCR = 0,
+	FIFO = 1
+};
+
+enum fifo_width {
+	W8BIT = 0,
+	W16BIT = 1,
+	W32BIT = 2,
+	W64BIT = 3,
+	W128BIT = 4,
+	W256BIT = 5
+};
+
+enum dma_event_q {
+	EVENTQ_0 = 0,
+	EVENTQ_1 = 1,
+	EVENTQ_2 = 2,
+	EVENTQ_3 = 3,
+	EVENTQ_DEFAULT = -1
+};
+
+enum sync_dimension {
+	ASYNC = 0,
+	ABSYNC = 1
+};
+
+#define EDMA_CTLR_CHAN(ctlr, chan)	(((ctlr) << 16) | (chan))
+#define EDMA_CTLR(i)			((i) >> 16)
+#define EDMA_CHAN_SLOT(i)		((i) & 0xffff)
+
+#define EDMA_CHANNEL_ANY		-1	/* for edma_alloc_channel() */
+#define EDMA_SLOT_ANY			-1	/* for edma_alloc_slot() */
+#define EDMA_CONT_PARAMS_ANY		 1001
+#define EDMA_CONT_PARAMS_FIXED_EXACT	 1002
+#define EDMA_CONT_PARAMS_FIXED_NOT_EXACT 1003
+
+#define EDMA_MAX_CC               2
+
+/* alloc/free DMA channels and their dedicated parameter RAM slots */
+int edma_alloc_channel(int channel,
+	void (*callback)(unsigned channel, u16 ch_status, void *data),
+	void *data, enum dma_event_q);
+void edma_free_channel(unsigned channel);
+
+/* alloc/free parameter RAM slots */
+int edma_alloc_slot(unsigned ctlr, int slot);
+void edma_free_slot(unsigned slot);
+
+/* alloc/free a set of contiguous parameter RAM slots */
+int edma_alloc_cont_slots(unsigned ctlr, unsigned int id, int slot, int count);
+int edma_free_cont_slots(unsigned slot, int count);
+
+/* calls that operate on part of a parameter RAM slot */
+void edma_set_src(unsigned slot, dma_addr_t src_port,
+				enum address_mode mode, enum fifo_width);
+void edma_set_dest(unsigned slot, dma_addr_t dest_port,
+				 enum address_mode mode, enum fifo_width);
+void edma_get_position(unsigned slot, dma_addr_t *src, dma_addr_t *dst);
+void edma_set_src_index(unsigned slot, s16 src_bidx, s16 src_cidx);
+void edma_set_dest_index(unsigned slot, s16 dest_bidx, s16 dest_cidx);
+void edma_set_transfer_params(unsigned slot, u16 acnt, u16 bcnt, u16 ccnt,
+		u16 bcnt_rld, enum sync_dimension sync_mode);
+void edma_link(unsigned from, unsigned to);
+void edma_unlink(unsigned from);
+
+/* calls that operate on an entire parameter RAM slot */
+void edma_write_slot(unsigned slot, const struct edmacc_param *params);
+void edma_read_slot(unsigned slot, struct edmacc_param *params);
+
+/* channel control operations */
+int edma_start(unsigned channel);
+void edma_stop(unsigned channel);
+void edma_clean_channel(unsigned channel);
+void edma_clear_event(unsigned channel);
+void edma_pause(unsigned channel);
+void edma_resume(unsigned channel);
+
+struct edma_rsv_info {
+
+	const s16	(*rsv_chans)[2];
+	const s16	(*rsv_slots)[2];
+};
+
+/* platform_data for EDMA driver */
+struct edma_soc_info {
+
+	/* how many dma resources of each type */
+	unsigned	n_channel;
+	unsigned	n_region;
+	unsigned	n_slot;
+	unsigned	n_tc;
+	unsigned	n_cc;
+	/*
+	 * Default queue is expected to be a low-priority queue.
+	 * This way, long transfers on the default queue started
+	 * by the codec engine will not cause audio defects.
+	 */
+	enum dma_event_q	default_queue;
+
+	/* Resource reservation for other cores */
+	struct edma_rsv_info	*rsv;
+
+	const s8	(*queue_tc_mapping)[2];
+	const s8	(*queue_priority_mapping)[2];
+};
+
+#endif
diff --git a/include/linux/platform_data/spi-davinci.h b/include/linux/platform_data/spi-davinci.h
index 7af305b..8dc2fa47 100644
--- a/include/linux/platform_data/spi-davinci.h
+++ b/include/linux/platform_data/spi-davinci.h
@@ -19,7 +19,7 @@
 #ifndef __ARCH_ARM_DAVINCI_SPI_H
 #define __ARCH_ARM_DAVINCI_SPI_H
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 #define SPI_INTERN_CS	0xFF
 
diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index 6fac5af..44365d5 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -14,6 +14,7 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 #include <linux/i2c.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index 93ea3bf..c9d1b7a 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/platform_data/edma.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-pcm.h
index fc4d01c..deab6c3 100644
--- a/sound/soc/davinci/davinci-pcm.h
+++ b/sound/soc/davinci/davinci-pcm.h
@@ -13,7 +13,7 @@
 #define _DAVINCI_PCM_H
 
 #include <linux/platform_data/davinci_asp.h>
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 struct davinci_pcm_dma_params {
 	int channel;			/* sync dma channel ID */
diff --git a/sound/soc/davinci/davinci-sffsdr.c b/sound/soc/davinci/davinci-sffsdr.c
index 5be65aa..5345e63 100644
--- a/sound/soc/davinci/davinci-sffsdr.c
+++ b/sound/soc/davinci/davinci-sffsdr.c
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 #include <linux/gpio.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -28,7 +29,6 @@
 #include <asm/plat-sffsdr/sffsdr-fpga.h>
 #endif
 
-#include <mach/edma.h>
 
 #include "../codecs/pcm3008.h"
 #include "davinci-pcm.h"
@@ -123,8 +123,8 @@ static struct resource sffsdr_snd_resources[] = {
 };
 
 static struct evm_snd_platform_data sffsdr_snd_data = {
-	.tx_dma_ch	= DAVINCI_DMA_MCBSP_TX,
-	.rx_dma_ch	= DAVINCI_DMA_MCBSP_RX,
+	.tx_dma_ch	= 2,
+	.rx_dma_ch	= 3,
 };
 
 static struct platform_device *sffsdr_snd_device;
-- 
1.7.9.5

