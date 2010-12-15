Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0LOBdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:33:45 -0500
Received: from ns2.cypress.com ([157.95.67.5]:52770 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0LOBdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:33:43 -0500
Subject: [PATCH] gpmc timing configuration west bridge related
From: Sutharsan <srmt@cypress.com>
To: greg@kroah.com
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:33:07 -0800
Message-ID: <1292376787.3270.47.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds gpmc configuration functions(./arch/arm/mach-omap2/usb-cywb-pnand.c) needed by cypress westbridge device controller driver.
West bridge device controller driver is updated to use gpmc configuration functions instead of modifying gpmc registers directly.

Please let us know your comments.

Thanks&Regards,
Sutharsan.

---

diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/arch/arm/mach-omap2/Makefile kernel-cywb/arch/arm/mach-omap2/Makefile
--- linux-2.6.37_vanilla/arch/arm/mach-omap2/Makefile	2010-11-29 20:42:04.000000000 -0800
+++ kernel-cywb/arch/arm/mach-omap2/Makefile	2010-12-13 16:04:08.378446603 -0800
@@ -182,6 +182,7 @@ obj-y					+= $(usbfs-m) $(usbfs-y)
 obj-y					+= usb-musb.o
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
 obj-y					+= usb-ehci.o
+obj-$(CONFIG_WESTBRIDGE_ASTORIA)        += usb-cywb-pnand.o
 
 onenand-$(CONFIG_MTD_ONENAND_OMAP2)	:= gpmc-onenand.o
 obj-y					+= $(onenand-m) $(onenand-y)
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/arch/arm/mach-omap2/usb-cywb-pnand.c kernel-cywb/arch/arm/mach-omap2/usb-cywb-pnand.c
--- linux-2.6.37_vanilla/arch/arm/mach-omap2/usb-cywb-pnand.c	1969-12-31 16:00:00.000000000 -0800
+++ kernel-cywb/arch/arm/mach-omap2/usb-cywb-pnand.c	2010-12-14 15:51:13.710787480 -0800
@@ -0,0 +1,182 @@
+/*
+ * linux /arch/arm/mach-omap2/usb-cywb-pnand.c
+ *
+ * Copyright (C) 2010  Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ * Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+
+#include <plat/gpmc.h>
+
+/*
+ * chip select number on GPMC ( 0..7 )
+ */
+#define AST_GPMC_CS 4
+
+/*
+ * for use by gpmc_set_timings api, measured in ns, not clocks
+ */
+#define WB_GPMC_BUSCYC_t    (7 * 6)
+#define WB_GPMC_CS_t_o_n    (0)
+#define WB_GPMC_ADV_t_o_n   (0)
+#define WB_GPMC_OE_t_o_n    (0)
+#define WB_GPMC_OE_t_o_f_f  (5 * 6)
+#define WB_GPMC_WE_t_o_n    (1 * 6)
+#define WB_GPMC_WE_t_o_f_f  (5 * 6)
+#define WB_GPMC_RDS_ADJ     (2 * 6)
+#define WB_GPMC_RD_t_a_c_c  (WB_GPMC_OE_t_o_f_f + WB_GPMC_RDS_ADJ)
+#define WB_GPMC_WR_t_a_c_c  (WB_GPMC_BUSCYC_t)
+
+#define GPMC_16BIT_MODE 0
+#define GPMC_RETIME     1
+
+/*
+ * GPMC_CONFIG7[cs] register bit fields
+ * AS_CS_MASK - 3 bit mask for  A26,A25,A24,
+ * AS_CS_BADDR - 6 BIT VALUE  A29 ...A24
+ * CSVALID_B - CSVALID bit on GPMC_CONFIG7[cs] register
+ */
+#define AS_CS_MASK	(0X7 << 8)
+#define AS_CS_BADDR	 0x02
+#define CSVALID_B (1 << 6)
+
+#define BLKSZ_4K 0x1000
+
+/*
+ * switch GPMC DATA bus mode
+ */
+void cywb_gpmc_enable_16bit_bus(bool dbus16_enabled)
+{
+	uint32_t tmp32;
+
+	/*
+	 * disable gpmc CS4 operation 1st
+	 */
+	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS,
+				GPMC_CS_CONFIG7) & ~GPMC_CONFIG7_CSVALID;
+	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
+
+	/*
+	 * GPMC NAND data bus can be 8 or 16 bit wide
+	 */
+	if (dbus16_enabled) {
+		printk(KERN_INFO "enabling 16 bit bus\n");
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+				(GPMC_CONFIG1_DEVICETYPE(2) |
+				GPMC_CONFIG1_WAIT_PIN_SEL(2) |
+				GPMC_CONFIG1_DEVICESIZE_16)
+				);
+	} else {
+		printk(KERN_INFO "enabling 8 bit bus\n");
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+				(GPMC_CONFIG1_DEVICETYPE(2) |
+				GPMC_CONFIG1_WAIT_PIN_SEL(2))
+				);
+	}
+
+	/*
+	 * re-enable astoria CS operation on GPMC
+	 */
+	 gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+			(tmp32 | GPMC_CONFIG7_CSVALID));
+}
+
+int cywb_pnand_platform_retime(int action, bool dbus16_enabled)
+{
+	u32 tmp32;
+	struct gpmc_timings	timings;
+	int retval;
+
+	switch (action) {
+
+	case GPMC_16BIT_MODE:
+		cywb_gpmc_enable_16bit_bus(dbus16_enabled);
+		retval = 0;
+		break;
+	case GPMC_RETIME:
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+						(GPMC_CONFIG1_DEVICETYPE(2) |
+						GPMC_CONFIG1_WAIT_PIN_SEL(2)));
+
+		memset(&timings, 0, sizeof(timings));
+
+		/* cs timing */
+		timings.cs_on = WB_GPMC_CS_t_o_n;
+		timings.cs_wr_off = WB_GPMC_BUSCYC_t;
+		timings.cs_rd_off = WB_GPMC_BUSCYC_t;
+
+		/* adv timing */
+		timings.adv_on = WB_GPMC_ADV_t_o_n;
+		timings.adv_rd_off = WB_GPMC_BUSCYC_t;
+		timings.adv_wr_off = WB_GPMC_BUSCYC_t;
+
+		/* oe timing */
+		timings.oe_on = WB_GPMC_OE_t_o_n;
+		timings.oe_off = WB_GPMC_OE_t_o_f_f;
+		timings.access = WB_GPMC_RD_t_a_c_c;
+		timings.rd_cycle = WB_GPMC_BUSCYC_t;
+
+		/* we timing */
+		timings.we_on = WB_GPMC_WE_t_o_n;
+		timings.we_off = WB_GPMC_WE_t_o_f_f;
+		timings.wr_access = WB_GPMC_WR_t_a_c_c;
+		timings.wr_cycle = WB_GPMC_BUSCYC_t;
+
+		timings.page_burst_access = WB_GPMC_BUSCYC_t;
+		timings.wr_data_mux_bus = WB_GPMC_BUSCYC_t;
+		gpmc_cs_set_timings(AST_GPMC_CS, &timings);
+
+		/*
+		 * DISABLE cs4, NOTE GPMC REG7 is already configured
+		 * at this point by gpmc_cs_request
+		 */
+		tmp32 = gpmc_cs_read_reg(AST_GPMC_CS, GPMC_CS_CONFIG7) &
+						~GPMC_CONFIG7_CSVALID;
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
+
+		/*
+		 * PROGRAM chip select Region, (see OMAP3430 TRM PAGE 1088)
+		 */
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+					(AS_CS_MASK | AS_CS_BADDR));
+
+		/*
+		 * by default configure GPMC into 8 bit mode
+		 * (to match astoria default mode)
+		 */
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
+					(GPMC_CONFIG1_DEVICETYPE(2) |
+					GPMC_CONFIG1_WAIT_PIN_SEL(2)));
+
+		/*
+		 * ENABLE astoria cs operation on GPMC
+		 */
+		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
+						(tmp32 | GPMC_CONFIG7_CSVALID));
+		retval = 0;
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+
+	return retval;
+
+}
+EXPORT_SYMBOL(cywb_pnand_platform_retime);
+
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c kernel-cywb/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-11-29 20:42:04.000000000 -0800
+++ kernel-cywb/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-12-14 15:37:02.770286377 -0800
@@ -129,6 +129,13 @@ static uint8_t pnand_16bit;
 #define PGMPAGE_B2  0x10
 
 /*
+ * following macros are used in ./arch/arm/mach-omap2/usb-cywb-pnand.c
+ * so move them to common header
+ */
+#define GPMC_16BIT_MODE 0
+#define GPMC_RETIME     1
+
+/*
  * The type of DMA operation, per endpoint
  */
 typedef enum cy_as_hal_dma_type {
@@ -303,55 +310,22 @@ static u16 omap_cfg_reg_L(u32 pad_func_i
  */
 void cy_as_hal_gpmc_enable_16bit_bus(bool dbus16_enabled)
 {
-	uint32_t tmp32;
-
-	/*
-	 * disable gpmc CS4 operation 1st
-	 */
-	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS,
-				GPMC_CS_CONFIG7) & ~GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
-
-	/*
-	 * GPMC NAND data bus can be 8 or 16 bit wide
-	 */
-	if (dbus16_enabled) {
-		DBGPRN("enabling 16 bit bus\n");
-		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-				(GPMC_CONFIG1_DEVICETYPE(2) |
-				GPMC_CONFIG1_WAIT_PIN_SEL(2) |
-				GPMC_CONFIG1_DEVICESIZE_16)
-				);
-	} else {
-		DBGPRN(KERN_INFO "enabling 8 bit bus\n");
-		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-				(GPMC_CONFIG1_DEVICETYPE(2) |
-				GPMC_CONFIG1_WAIT_PIN_SEL(2))
-				);
-	}
-
-	/*
-	 * re-enable astoria CS operation on GPMC
-	 */
-	 gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-			(tmp32 | GPMC_CONFIG7_CSVALID));
-
 	/*
 	 *remember the state
 	 */
 	pnand_16bit = dbus16_enabled;
+	cywb_pnand_platform_retime(GPMC_16BIT_MODE, dbus16_enabled);
 }
 
 static int cy_as_hal_gpmc_init(void)
 {
 	u32 tmp32;
-	int err;
-	struct gpmc_timings	timings;
+
 	/*
 	 * get GPMC i/o registers base(already been i/o mapped
 	 * in kernel, no need for separate i/o remap)
 	 */
-	gpmc_base = phys_to_virt(OMAP34XX_GPMC_BASE);
+	gpmc_base = (u32)ioremap_nocache(OMAP34XX_GPMC_BASE, BLKSZ_4K);
 	DBGPRN(KERN_INFO "kernel has gpmc_base=%x , val@ the base=%x",
 		gpmc_base, __raw_readl(gpmc_base)
 	);
@@ -363,109 +337,7 @@ static int cy_as_hal_gpmc_init(void)
 	naddr_reg_vma = GPMC_VMA(AST_GPMC_NAND_ADDR);
 	ndata_reg_vma = GPMC_VMA(AST_GPMC_NAND_DATA);
 
-	/*
-	 * request GPMC CS for ASTORIA request
-	 */
-	if (gpmc_cs_request(AST_GPMC_CS, SZ_16M, (void *)&csa_phy) < 0) {
-		cy_as_hal_print_message(KERN_ERR "error failed to request"
-					"ncs4 for ASTORIA\n");
-			return -1;
-	} else {
-		DBGPRN(KERN_INFO "got phy_addr:%x for "
-				"GPMC CS%d GPMC_CFGREG7[CS4]\n",
-				 csa_phy, AST_GPMC_CS);
-	}
-
-	/*
-	 * request VM region for 4K addr space for chip select 4 phy address
-	 * technically we don't need it for NAND devices, but do it anyway
-	 * so that data read/write bus cycle can be triggered by reading
-	 * or writing this mem region
-	 */
-	if (!request_mem_region(csa_phy, BLKSZ_4K, "AST_OMAP_HAL")) {
-		err = -EBUSY;
-		cy_as_hal_print_message(KERN_ERR "error MEM region "
-					"request for phy_addr:%x failed\n",
-					csa_phy);
-			goto out_free_cs;
-	}
-
-	/*
-	 * REMAP mem region associated with our CS
-	 */
-	gpmc_data_vma = (u32)ioremap_nocache(csa_phy, BLKSZ_4K);
-	if (!gpmc_data_vma) {
-		err = -ENOMEM;
-		cy_as_hal_print_message(KERN_ERR "error- ioremap()"
-					"for phy_addr:%x failed", csa_phy);
-
-		goto out_release_mem_region;
-	}
-	cy_as_hal_print_message(KERN_INFO "ioremap(%x) returned vma=%x\n",
-							csa_phy, gpmc_data_vma);
-
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-						(GPMC_CONFIG1_DEVICETYPE(2) |
-						GPMC_CONFIG1_WAIT_PIN_SEL(2)));
-
-	memset(&timings, 0, sizeof(timings));
-
-	/* cs timing */
-	timings.cs_on = WB_GPMC_CS_t_o_n;
-	timings.cs_wr_off = WB_GPMC_BUSCYC_t;
-	timings.cs_rd_off = WB_GPMC_BUSCYC_t;
-
-	/* adv timing */
-	timings.adv_on = WB_GPMC_ADV_t_o_n;
-	timings.adv_rd_off = WB_GPMC_BUSCYC_t;
-	timings.adv_wr_off = WB_GPMC_BUSCYC_t;
-
-	/* oe timing */
-	timings.oe_on = WB_GPMC_OE_t_o_n;
-	timings.oe_off = WB_GPMC_OE_t_o_f_f;
-	timings.access = WB_GPMC_RD_t_a_c_c;
-	timings.rd_cycle = WB_GPMC_BUSCYC_t;
-
-	/* we timing */
-	timings.we_on = WB_GPMC_WE_t_o_n;
-	timings.we_off = WB_GPMC_WE_t_o_f_f;
-	timings.wr_access = WB_GPMC_WR_t_a_c_c;
-	timings.wr_cycle = WB_GPMC_BUSCYC_t;
-
-	timings.page_burst_access = WB_GPMC_BUSCYC_t;
-	timings.wr_data_mux_bus = WB_GPMC_BUSCYC_t;
-	gpmc_cs_set_timings(AST_GPMC_CS, &timings);
-
-	cy_as_hal_print_omap_regs("GPMC_CONFIG", 1,
-			GPMC_VMA(GPMC_CFG_REG(1, AST_GPMC_CS)), 7);
-
-	/*
-	 * DISABLE cs4, NOTE GPMC REG7 is already configured
-	 * at this point by gpmc_cs_request
-	 */
-	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS, GPMC_CS_CONFIG7) &
-						~GPMC_CONFIG7_CSVALID;
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
-
-	/*
-	 * PROGRAM chip select Region, (see OMAP3430 TRM PAGE 1088)
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-					(AS_CS_MASK | AS_CS_BADDR));
-
-	/*
-	 * by default configure GPMC into 8 bit mode
-	 * (to match astoria default mode)
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
-					(GPMC_CONFIG1_DEVICETYPE(2) |
-					GPMC_CONFIG1_WAIT_PIN_SEL(2)));
-
-	/*
-	 * ENABLE astoria cs operation on GPMC
-	 */
-	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
-					(tmp32 | GPMC_CONFIG7_CSVALID));
+	cywb_pnand_platform_retime(GPMC_RETIME, cy_false);
 
 	/*
 	 * No method currently exists to write this register through GPMC APIs
@@ -479,14 +351,6 @@ static int cy_as_hal_gpmc_init(void)
 	cy_as_hal_print_message("GPMC_CONFIG_REG=0x%x\n", tmp32);
 
 	return 0;
-
-out_release_mem_region:
-	release_mem_region(csa_phy, BLKSZ_4K);
-
-out_free_cs:
-	gpmc_cs_free(AST_GPMC_CS);
-
-	return err;
 }
 
 /*
@@ -810,8 +674,6 @@ void cy_as_hal_omap_hardware_deinit(cy_a
 	if (csa_phy != 0)
 		release_mem_region(csa_phy, BLKSZ_4K);
 
-	gpmc_cs_free(AST_GPMC_CS);
-
 	free_irq(OMAP_GPIO_IRQ(AST_INT), dev_p);
 
 	cy_as_hal_release_user_pads(user_pad_cfg);
diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h kernel-cywb/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h	2010-11-29 20:42:04.000000000 -0800
+++ kernel-cywb/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h	2010-12-14 11:07:04.938213184 -0800
@@ -38,6 +38,12 @@
  */
 #define CY_AS_OMAP_KERNEL_HAL_SIG		(0x1441)
 
+/*
+ * following macros are used in ./arch/arm/mach-omap2/usb-cywb-pnand.c
+ * so move them to common header
+ */
+#define GPMC_16BIT_MODE 0
+#define GPMC_RETIME     1
 
 /*
  * Data structures
@@ -67,6 +73,8 @@ typedef struct cy_as_omap_dev_kernel {
 	struct completion dma_complete;
 } cy_as_omap_dev_kernel;
 
+extern int cywb_pnand_platform_retime(int action, bool dbus16_enabled);
+
 #endif
 
 /*[]*/

Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

