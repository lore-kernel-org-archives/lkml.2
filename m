Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1AYIGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:06:37 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59938 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1AYIGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Sw34hhEl+BS5yIVpiJrRBEkb6K89sv38b32XJNgEBnMod34h74T4GO7Z/tfZDbBEU0
         tzTZ3o+Kvux/P3QyhzVqRosRt/1YQin196sttmFQHrer7kdZUblcGvQKWKyjIY4v4Wm7
         SiLMyEjdQgsSNL+QygkH88XL55dOIQVCUs1Pw=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 5/6] Platform support for On-chip MSP ethernet devices.
Date: Tue, 25 Jan 2011 13:52:43 +0530
Message-Id: <1295943763-20392-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Some of MSP family SoC's comes with legacy 100Mbps mspeth while some comes with
newer Gigabit TSMAC.Following patch adds platform support for both types of MAC's.
If TSMAC is not selected assume platform having legacy mspeth.This patch also 
gpio_macros required for resetting phy.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 .../asm/pmc-sierra/msp71xx/msp_gpio_macros.h       |  327 ++++++++++++++++++++
 arch/mips/pmc-sierra/Kconfig                       |   10 +
 arch/mips/pmc-sierra/msp71xx/Makefile              |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_eth.c             |  188 +++++++++++
 4 files changed, 526 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_eth.c

diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
new file mode 100644
index 0000000..a3de5ab
--- /dev/null
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
@@ -0,0 +1,327 @@
+/*
+ * $Id: linux-2.6.24-pmc-msp8xx0.patch,v 1.1.2.2 2010/07/15 07:38:59 paanoop1 Exp $
+ *
+ * Macros for external SMP-safe access to the PMC Athena (MSP7120) reference
+ * board GPIO pins
+ *
+ * Copyright 2005 PMC-Sierra, Inc.
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
+ */
+
+#ifndef __MSP_GPIO_MACROS_H__
+#define __MSP_GPIO_MACROS_H__
+
+#include <msp_regops.h>
+#include <msp_regs.h>
+
+#if defined(CONFIG_PMC_MSP7140) || defined(CONFIG_PMC_MSP7150) || defined(CONFIG_PMC_MSP82XX_ACADIA)
+#define MSP_NUM_GPIOS		(28)
+#else
+#define MSP_NUM_GPIOS		(20)
+#endif
+
+/* -- GPIO Enumerations -- */
+typedef enum {
+	MSP_GPIO_LO = 0,
+	MSP_GPIO_HI = 1,
+	MSP_GPIO_NONE,		/* Special - Means pin is out of range */
+	MSP_GPIO_TOGGLE,	/* Special - Sets pin to opposite */
+} msp_gpio_data_t;
+
+typedef enum {
+	MSP_GPIO_INPUT		= 0x0,
+	/* MSP_GPIO_ INTERRUPT	= 0x1,	Not supported yet */
+	MSP_GPIO_UART_INPUT	= 0x2,	/* Only GPIO 4 or 5 */
+	MSP_GPIO_OUTPUT		= 0x8,
+	MSP_GPIO_UART_OUTPUT	= 0x9,	/* Only GPIO 2 or 3 */
+	MSP_GPIO_PERIF_TIMERA	= 0x9,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_PERIF_TIMERB	= 0xa,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_UNKNOWN	= 0xb,  /* No such GPIO or mode */
+} msp_gpio_mode_t;
+
+/* -- Static Tables -- */
+
+/* Maps pins to data register */
+static volatile u32 * const MSP_GPIO_DATA_REGISTER[] = {
+	/* GPIO 0 and 1 on the first register */
+	GPIO_DATA1_REG, GPIO_DATA1_REG,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG,
+	GPIO_DATA4_REG, GPIO_DATA4_REG,
+	/* GPIO 16 - 23 on the first strange EXTENDED register */
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	/* GPIO 24 - 27 on the second strange EXTENDED register */
+	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
+	EXTENDED_GPIO2_REG,
+};
+
+/* Maps pins to mode register */
+static volatile u32 * const MSP_GPIO_MODE_REGISTER[] = {
+	/* GPIO 0 and 1 on the first register */
+	GPIO_CFG1_REG, GPIO_CFG1_REG,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG,
+	GPIO_CFG4_REG, GPIO_CFG4_REG,
+	/* GPIO 16 - 23 on the first strange EXTENDED register */
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	/* GPIO 24 - 27 on the second strange EXTENDED register */
+	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
+	EXTENDED_GPIO2_REG,
+};
+
+/* Maps 'basic' pins to relative offset from 0 per register */
+static int MSP_GPIO_OFFSET[] = {
+	/* GPIO 0 and 1 on the first register */
+	0, 0,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	2, 2, 2, 2,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	6, 6, 6, 6,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	10, 10, 10, 10, 10, 10,
+};
+
+/* Maps MODE to allowed pin mask */
+static unsigned int MSP_GPIO_MODE_ALLOWED[] = {
+	0xffffffff,	/* Mode 0 - INPUT */
+	0x00000,	/* Mode 1 - INTERRUPT */
+	0x00030,	/* Mode 2 - UART_INPUT (GPIO 4, 5)*/
+	0, 0, 0, 0, 0,	/* Modes 3, 4, 5, 6, and 7 are reserved */
+	0xffffffff,	/* Mode 8 - OUTPUT */
+	0x0000f,	/* Mode 9 - UART_OUTPUT/PERF_TIMERA (GPIO 0, 1, 2, 3) */
+	0x00003,	/* Mode a - PERF_TIMERB (GPIO 0, 1) */
+	0x00000,	/* Mode b - Not really a mode! */
+};
+
+/* -- Bit masks -- */
+
+/* This gives you the 'register relative offlet gpio' number */
+#define OFFSET_GPIO_NUMBER(gpio)	(gpio - MSP_GPIO_OFFSET[gpio])
+
+/* These take the 'register relative offset gpio' number */
+#define BASIC_DATA_REG_MASK(ogpio)		(1 << ogpio)
+#define BASIC_MODE_REG_VALUE(mode, ogpio)	(mode << BASIC_MODE_REG_SHIFT(ogpio))
+#define BASIC_MODE_REG_MASK(ogpio)		BASIC_MODE_REG_VALUE(0xf, ogpio)
+#define BASIC_MODE_REG_SHIFT(ogpio)		(ogpio * 4)
+#define BASIC_MODE_REG_FROM_REG(data, ogpio)	((data & BASIC_MODE_REG_MASK(ogpio)) >> BASIC_MODE_REG_SHIFT(ogpio))
+
+/* These take the actual GPIO number (0 through 15) */
+#define BASIC_DATA_MASK(gpio)	BASIC_DATA_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_MASK(gpio)	BASIC_MODE_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE(mode, gpio)	BASIC_MODE_REG_VALUE(mode, OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_SHIFT(gpio)	BASIC_MODE_REG_SHIFT(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_FROM_REG(data, gpio)	BASIC_MODE_REG_FROM_REG(data,OFFSET_GPIO_NUMBER(gpio))
+
+/*
+ * Each extended GPIO register is 32 bits long and is responsible for up to 
+ * eight GPIOs. The least significant 16 bits contain the set and clear bit pair
+ * for each of the GPIOs. The most significant 16 bits contain the disable and
+ * enable bit pair for each of the GPIOs. For example, the extended GPIO reg
+ * for GPIOs 16-23 is as follows:
+ *
+ * 	31: GPIO23_DISABLE
+ * 	...
+ * 	19: GPIO17_DISABLE
+ * 	18: GPIO17_ENABLE
+ * 	17: GPIO16_DISABLE
+ * 	16: GPIO16_ENABLE
+ * 	...
+ * 	3:  GPIO17_SET
+ * 	2:  GPIO17_CLEAR
+ * 	1:  GPIO16_SET
+ * 	0:  GPIO16_CLEAR
+ */
+
+/* This gives the 'register relative offset gpio' number */
+#define EXTENDED_OFFSET_GPIO(gpio)	(gpio < 24 ? gpio - 16 : gpio - 24)
+
+/* These take the 'register relative offset gpio' number */
+#define EXTENDED_REG_DISABLE(ogpio)	(0x2 << ((ogpio * 2) + 16))
+#define EXTENDED_REG_ENABLE(ogpio)	(0x1 << ((ogpio * 2) + 16))
+#define EXTENDED_REG_SET(ogpio)		(0x2 << (ogpio * 2))
+#define EXTENDED_REG_CLR(ogpio)		(0x1 << (ogpio * 2))
+
+/* These take the actual GPIO number (16 through 27) */
+#define EXTENDED_DISABLE(gpio)	EXTENDED_REG_DISABLE(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_ENABLE(gpio)	EXTENDED_REG_ENABLE(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_SET(gpio)	EXTENDED_REG_SET(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_CLR(gpio)	EXTENDED_REG_CLR(EXTENDED_OFFSET_GPIO(gpio))
+
+#define EXTENDED_FULL_MASK		(0xffffffff)
+
+/* -- API inline-functions -- */
+
+/*
+ * Gets the current value of the specified pin
+ */
+static inline msp_gpio_data_t msp_gpio_pin_get( unsigned int gpio )
+{
+	u32 pinhi_mask = 0, pinhi_mask2 = 0;
+
+	if( gpio >= MSP_NUM_GPIOS )
+		return MSP_GPIO_NONE;
+
+	if(gpio < 16 ) {
+		pinhi_mask = BASIC_DATA_MASK(gpio);
+	} else {
+		/*
+		 * Two cases are possible with the EXTENDED register:
+		 *  - In output mode (ENABLED flag set), check the CLR bit
+		 *  - In input mode (ENABLED flag not set), check the SET bit
+		 */
+		pinhi_mask = EXTENDED_ENABLE(gpio) | EXTENDED_CLR(gpio);
+		pinhi_mask2 = EXTENDED_SET(gpio);
+	}
+	if (((*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask) == pinhi_mask) ||
+	    (*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask2))
+		return MSP_GPIO_HI;
+	else
+		return MSP_GPIO_LO;
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_set( msp_gpio_data_t data, unsigned int gpio )
+{
+	if( gpio >= MSP_NUM_GPIOS )
+		return;
+
+	if( gpio < 16 ) {
+		if( data == MSP_GPIO_TOGGLE )
+			toggle_reg32( MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio) );
+		else if( data == MSP_GPIO_HI )
+			set_reg32( MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio) );
+		else
+			clear_reg32( MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio) );
+	} else {
+		if( data == MSP_GPIO_TOGGLE ) {
+			/* Special ugly case:
+			 *   We have to read the CLR bit.
+			 *   If set, we write the CLR bit.
+			 *   If not, we write the SET bit.
+			 */
+			u32 tmpdata;
+			custom_read_reg32( MSP_GPIO_DATA_REGISTER[gpio], tmpdata );
+			if( tmpdata & EXTENDED_CLR(gpio) )
+				tmpdata = EXTENDED_CLR(gpio);
+			else
+				tmpdata = EXTENDED_SET(gpio);
+			custom_write_reg32( MSP_GPIO_DATA_REGISTER[gpio], tmpdata );
+		} else {
+			u32 newdata;
+			if( data == MSP_GPIO_HI )
+				newdata = EXTENDED_SET(gpio);
+			else
+				newdata = EXTENDED_CLR(gpio);
+			set_value_reg32( MSP_GPIO_DATA_REGISTER[gpio], EXTENDED_FULL_MASK, newdata );
+		}
+	}
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_hi( unsigned int gpio )
+{
+	msp_gpio_pin_set( MSP_GPIO_HI, gpio );
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_lo( unsigned int gpio )
+{
+	msp_gpio_pin_set( MSP_GPIO_LO, gpio );
+}
+
+/* Sets the specified pin to the opposite value */
+static inline void msp_gpio_pin_toggle( unsigned int gpio )
+{
+	msp_gpio_pin_set( MSP_GPIO_TOGGLE, gpio );
+}
+
+/* Gets the mode of the specified pin */
+static inline msp_gpio_mode_t msp_gpio_pin_get_mode( unsigned int gpio )
+{
+	msp_gpio_mode_t retval = MSP_GPIO_UNKNOWN;
+	uint32_t data;
+
+	if( gpio >= MSP_NUM_GPIOS )
+		return retval;
+
+	data = *MSP_GPIO_MODE_REGISTER[gpio];
+
+	if( gpio < 16 ) {
+		retval = BASIC_MODE_FROM_REG(data, gpio);
+	} else {
+		/* Extended pins can only be either INPUT or OUTPUT */
+		if( data & EXTENDED_ENABLE(gpio) )
+			retval = MSP_GPIO_OUTPUT;
+		else
+			retval = MSP_GPIO_INPUT;
+	}
+
+	return retval;
+}
+
+/*
+ * Sets the specified mode on the requested pin
+ * Returns 0 on success, or -1 if that mode is not allowed on this pin
+ */
+static inline int msp_gpio_pin_mode( msp_gpio_mode_t mode, unsigned int gpio )
+{
+	u32 modemask, newmode;
+
+	if( (1 << gpio) & ~MSP_GPIO_MODE_ALLOWED[mode] )
+		return -1;
+
+	if( gpio >= MSP_NUM_GPIOS )
+		return -1;
+
+	if( gpio < 16 ) {
+		modemask = BASIC_MODE_MASK(gpio);
+		newmode =  BASIC_MODE(mode, gpio);
+	} else {
+		modemask = EXTENDED_FULL_MASK;
+		if( mode == MSP_GPIO_INPUT )
+			newmode = EXTENDED_DISABLE(gpio);
+		else
+			newmode = EXTENDED_ENABLE(gpio);
+	}
+	
+	/* Do the set atomically */
+	set_value_reg32( MSP_GPIO_MODE_REGISTER[gpio], modemask, newmode );
+
+	return 0;
+}
+
+#endif /* __MSP_GPIO_MACROS_H__ */
diff --git a/arch/mips/pmc-sierra/Kconfig b/arch/mips/pmc-sierra/Kconfig
index af41cda..3d8d57b 100644
--- a/arch/mips/pmc-sierra/Kconfig
+++ b/arch/mips/pmc-sierra/Kconfig
@@ -28,6 +28,7 @@ config PMC_MSP7120_GW
 	select IRQ_MSP_CIC
 	select HW_HAS_PCI
 	select MSP_HAS_USB
+	select MSP_ETH
 
 config PMC_MSP7120_FPGA
 	bool "PMC-Sierra MSP7120 FPGA"
@@ -44,3 +45,12 @@ config HYPERTRANSPORT
 config MSP_HAS_USB
 	boolean
 	depends on PMC_MSP
+
+config MSP_ETH
+	boolean
+	select MSP_HAS_MAC
+	depends on PMC_MSP
+
+config MSP_HAS_MAC
+	boolean
+	depends on PMC_MSP
diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index f26cab3..cefba77 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_PMC_MSP7120_GW) += msp_hwbutton.o
 obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
 obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
 obj-$(CONFIG_PCI) += msp_pci.o
-obj-$(CONFIG_MSPETH) += msp_eth.o
+obj-$(CONFIG_MSP_HAS_MAC) += msp_eth.o
 obj-$(CONFIG_MSP_HAS_USB) += msp_usb.o
 obj-$(CONFIG_MIPS_MT_SMP) += msp_smp.o
 obj-$(CONFIG_MIPS_MT_SMTC) += msp_smtc.o
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_eth.c b/arch/mips/pmc-sierra/msp71xx/msp_eth.c
new file mode 100644
index 0000000..fa510ca
--- /dev/null
+++ b/arch/mips/pmc-sierra/msp71xx/msp_eth.c
@@ -0,0 +1,188 @@
+/*
+ * The setup file for ethernet related hardware on PMC-Sierra MSP processors.
+ *
+ * Copyright 2010 PMC-Sierra, Inc.
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
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <msp_regs.h>
+#include <msp_int.h>
+#include <msp_gpio_macros.h>
+
+
+#define MSP_ETHERNET_GPIO0	14
+#define MSP_ETHERNET_GPIO1	15
+#define MSP_ETHERNET_GPIO2	16
+
+#ifdef CONFIG_MSP_HAS_TSMAC
+#define MSP_TSMAC_SIZE	0x10020
+#define MSP_TSMAC_ID	"pmc_tsmac"
+
+static struct resource msp_tsmac0_resources[] = {
+	[0] = {
+		.start	= MSP_MAC0_BASE,
+		.end	= MSP_MAC0_BASE + MSP_TSMAC_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSP_INT_MAC0,
+		.end	= MSP_INT_MAC0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource msp_tsmac1_resources[] = {
+	[0] = {
+		.start	= MSP_MAC1_BASE,
+		.end	= MSP_MAC1_BASE + MSP_TSMAC_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSP_INT_MAC1,
+		.end	= MSP_INT_MAC1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+static struct resource msp_tsmac2_resources[] = {
+	[0] = {
+		.start	= MSP_MAC2_BASE,
+		.end	= MSP_MAC2_BASE + MSP_TSMAC_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSP_INT_SAR,
+		.end	= MSP_INT_SAR,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+
+static struct platform_device tsmac_device[] = {
+	[0] = {
+		.name	= MSP_TSMAC_ID,
+		.id	= 0,
+		.num_resources = ARRAY_SIZE(msp_tsmac0_resources),
+		.resource = msp_tsmac0_resources,
+	},
+	[1] = {
+		.name	= MSP_TSMAC_ID,
+		.id	= 1,
+		.num_resources = ARRAY_SIZE(msp_tsmac1_resources),
+		.resource = msp_tsmac1_resources,
+	},
+	[2] = {
+		.name	= MSP_TSMAC_ID,
+		.id	= 2,
+		.num_resources = ARRAY_SIZE(msp_tsmac2_resources),
+		.resource = msp_tsmac2_resources,
+	},
+};
+#define msp_eth_devs	tsmac_device
+
+#else
+/* If it is not TSMAC assume MSP_ETH (100Mbps) */
+#define MSP_ETH_ID	"pmc_mspeth"
+#define MSP_ETH_SIZE	0xE0
+static struct resource msp_eth0_resources[] = {
+	[0] = {
+		.start	= MSP_MAC0_BASE,
+		.end	= MSP_MAC0_BASE + MSP_ETH_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSP_INT_MAC0,
+		.end	= MSP_INT_MAC0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource msp_eth1_resources[] = {
+	[0] = {
+		.start	= MSP_MAC1_BASE,
+		.end	= MSP_MAC1_BASE + MSP_ETH_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSP_INT_MAC1,
+		.end	= MSP_INT_MAC1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+
+
+static struct platform_device mspeth_device[] = {
+	[0] = {
+		.name	= MSP_ETH_ID,
+		.id	= 0,
+		.num_resources = ARRAY_SIZE(msp_eth0_resources),
+		.resource = msp_eth0_resources,
+	},
+	[1] = {
+		.name	= MSP_ETH_ID,
+		.id	= 1,
+		.num_resources = ARRAY_SIZE(msp_eth1_resources),
+		.resource = msp_eth1_resources,
+	},
+
+};
+#define msp_eth_devs	mspeth_device
+
+#endif
+int __init msp_eth_setup(void)
+{
+	int i, ret = 0;
+
+	/* Configure the GPIO and take the ethernet PHY out of reset */
+	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO0);
+	msp_gpio_pin_hi(MSP_ETHERNET_GPIO0);
+
+#ifdef CONFIG_MSP_HAS_TSMAC
+	/* 3 phys on boards with TSMAC */
+	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO1);
+	msp_gpio_pin_hi(MSP_ETHERNET_GPIO1);
+
+	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO2);
+	msp_gpio_pin_hi(MSP_ETHERNET_GPIO2);
+#endif
+	for (i = 0; i < ARRAY_SIZE(msp_eth_devs); i++) {
+		ret = platform_device_register(&msp_eth_devs[i]);
+		printk(KERN_INFO"device: %d, return value = %d\n", i, ret);
+		if (ret) {
+			while (--i >= 0)
+				platform_device_unregister(&msp_eth_devs[i]);
+			break;
+		}
+	}
+
+	if (ret)
+		printk(KERN_WARNING "Could not initialize \
+						MSPETH device structures.\n");
+
+	return ret;
+}
+subsys_initcall(msp_eth_setup);
-- 
1.7.0.4

