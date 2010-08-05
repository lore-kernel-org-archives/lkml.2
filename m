Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab0HENAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:00:14 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:53099 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759188Ab0HENAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:00:09 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Philippe Langlais <philippe.langlais@stericsson.com>
Subject: [PATCH 3/5] U6715 gpio platform driver This driver is U6 platform generic
Date: Thu, 5 Aug 2010 14:58:24 +0200
Message-ID: <1281013106-26119-3-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
---
 arch/arm/mach-u67xx/board_u67xx_wavex.c |  468 ++++++++++++++++++++++
 arch/arm/mach-u67xx/devices.c           |   67 +++
 arch/arm/plat-u6xxx/Makefile            |    2 +-
 arch/arm/plat-u6xxx/gpio.c              |  665 +++++++++++++++++++++++++++++++
 arch/arm/plat-u6xxx/include/mach/gpio.h |  391 ++++++++++++++++++
 arch/arm/plat-u6xxx/include/mach/scon.h |  123 ++++++
 6 files changed, 1715 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-u6xxx/gpio.c
 create mode 100644 arch/arm/plat-u6xxx/include/mach/gpio.h
 create mode 100644 arch/arm/plat-u6xxx/include/mach/scon.h

diff --git a/arch/arm/mach-u67xx/board_u67xx_wavex.c b/arch/arm/mach-u67xx/board_u67xx_wavex.c
index 633989f..c54a79b 100644
--- a/arch/arm/mach-u67xx/board_u67xx_wavex.c
+++ b/arch/arm/mach-u67xx/board_u67xx_wavex.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/gpio.h>
 #include <linux/platform_device.h>
 
 #include <asm/setup.h>
@@ -23,6 +24,472 @@
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/timer.h>
+#include <mach/scon.h>
+
+/**
+ * SCON initial settings
+ * Allows to define the PIN multiplexing for all the platform (Linux and Modem)
+ */
+struct u6_scon_config u6_scon_init_config[SCON_REGISTER_NB] = {
+ {
+	SCON_SYSMUX0_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A0  & 0xF))) | /* FM IRQ */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A1  & 0xF))) | /* UART 2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A2  & 0xF))) | /* UART 2 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A3  & 0xF))) |
+	(GPIO_MODE_MUX3 << (2 * (GPIO_A4  & 0xF))) | /* SIMOFF_copy for modem */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A5  & 0xF))) | /* for AGPS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A6  & 0xF))) | /* LCD backlight
+							-> ressource backligth*/
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A7  & 0xF))) | /* Bluetooth */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A8  & 0xF))) | /* Reserved for mode DPWS*/
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A9  & 0xF))) | /* Reserved for mode DPWS*/
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A10 & 0xF))) | /* UART2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A11 & 0xF))) | /* UART2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A12 & 0xF))) | /* UART 1, configured
+							by boot, don't touch */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A13 & 0xF))) | /* free */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A14 & 0xF))) | /* PMU irq */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A15 & 0xF)))
+ },
+ {
+	SCON_SYSMUX1_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A16 & 0xF))) | /* FCI data 3 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A17 & 0xF))) | /* free */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A18 & 0xF))) | /* FCI data 2 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A19 & 0xF))) | /* FCI data 1 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A20 & 0xF))) | /* Cam Ligth copy */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A21 & 0xF))) | /* RF on -> GPIO */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_A22 & 0xF))) | /* RF RF_DPN */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A23 & 0xF))) | /* RF reset -> GPIO */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A24 & 0xF))) | /* AGPS reset */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A25 & 0xF))) | /* AGPS wake up */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A26 & 0xF))) | /* free */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A27 & 0xF))) | /* SPI1 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A28 & 0xF))) | /* SPI1 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_A29 & 0xF))) | /* Audio IIS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A30 & 0xF))) | /* AGPS pwr on */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_A31 & 0xF)))  /* free */
+ },
+ {
+	SCON_SYSMUX2_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B0  & 0xF))) | /* RF DD */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B1  & 0xF))) | /* RF DU */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B2  & 0xF))) | /* RF FSC */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B3  & 0xF))) | /* RF DCL */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B4  & 0xF))) | /* UART RTS1 -> console */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B5  & 0xF))) | /* UART TXD1 -> console */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B6  & 0xF))) | /* NFI ready -> for NFI */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B7  & 0xF))) | /* VDE_EOFI -> VDE already
+						configured by splashscreen */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B8  & 0xF))) | /* RFEN0 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_B9  & 0xF))) | /* FCICMD -> for FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_B10 & 0xF))) | /* FCICLK -> for FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_B11 & 0xF))) | /* FCIDATA0 -> for FCI */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B12 & 0xF))) | /* RFSIG6 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B13 & 0xF))) | /* RFSIG7 */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_B14 & 0xF))) |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_B15 & 0xF)))  /* RFDATA */
+ },
+ {
+	SCON_SYSMUX3_REG,
+	0
+ },
+ {
+	SCON_SYSMUX4_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C0  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C1  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C2  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C3  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C4  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C5  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C6  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C7  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C8  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C9  & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C10 & 0xF))) | /* VDE */
+#ifdef CONFIG_EBI_BUS
+	(GPIO_MODE_MUX2 << (2 * (GPIO_C11 & 0xF))) | /* EBI_CS0 */
+#else
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C11 & 0xF))) | /* VDE */
+#endif
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C12 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C13 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C14 & 0xF))) | /* KCOL0 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C15 & 0xF)))  /* KCOL1 -> keypad */
+
+ },
+ {
+	SCON_SYSMUX5_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C16 & 0xF))) | /* KCOL2 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C17 & 0xF))) | /* KCOL3 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C18 & 0xF))) | /* KCOL4 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C19 & 0xF))) | /* KROW0 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C20 & 0xF))) | /* KROW1 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C21 & 0xF))) | /* KROW2 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C22 & 0xF))) | /* KROW3 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C23 & 0xF))) | /* KROW4 -> keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C24 & 0xF))) | /* RF3GSPIEN0 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C25 & 0xF))) | /* RF3GSPIDATA */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C26 & 0xF))) | /* RF3GSPICLK */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C27 & 0xF))) | /* RFSM_OUT0 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C28 & 0xF))) | /* RFSM_OUT1 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_C29 & 0xF))) | /* RFSM_OUT2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_C30 & 0xF))) | /* I2C -> ressource */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_C31 & 0xF)))  /* I2C -> ressource */
+ },
+ {
+	SCON_SYSMUX6_REG,
+	0 |
+	(GPIO_MODE_MUX1 << (2 * (GPIO_D0  & 0xF))) | /* CAM PWRDN1 -> CAM */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D1  & 0xF))) | /* CAM DATA 0 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D2  & 0xF))) | /* CAM DATA 1 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D3  & 0xF))) | /* CAM DATA 2 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D4  & 0xF))) | /* CAM DATA 3 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D5  & 0xF))) | /* CAM DATA 4 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D6  & 0xF))) | /* CAM DATA 5 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D7  & 0xF))) | /* CAM DATA 6 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D8  & 0xF))) | /* CAM DATA 7 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D9  & 0xF))) | /* CAM DATA 8 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D10 & 0xF))) | /* CAM DATA 9 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D11 & 0xF))) | /* CAMVS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D12 & 0xF))) | /* CAMHS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D13 & 0xF))) | /* CAMCLKI */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D14 & 0xF))) | /* CAMCLKO */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_D15 & 0xF)))  /* VDDC2EN */
+ },
+ {
+	SCON_SYSMUX7_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D16 & 0xF))) | /* RF3GGPO9 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D17 & 0xF))) | /* RF3GGPO8 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_D18 & 0xF))) | /* FCI card detect, FCI */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_D19 & 0xF))) | /* CAM_Prelight copy, CAM*/
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D20 & 0xF))) | /* UART1 RXD1 -> Console */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D21 & 0xF))) | /* DIISWS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D22 & 0xF))) | /* DIISSDO */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D23 & 0xF))) | /* DIISCK */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_D24 & 0xF))) | /* GPIOD24 ->FM Reset */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_D25 & 0xF))) | /* RFSIG3 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D26 & 0xF))) | /* RF3GGPO6 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D27 & 0xF))) | /* RF3GGPO7 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D28 & 0xF))) | /* RF3GGPO5 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_D29 & 0xF))) | /* GPIOD29 USB suspend */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D30 & 0xF))) | /* RF3GGPO4 */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_D31 & 0xF)))  /* RFCLK */
+ },
+#ifdef CONFIG_MACH_U67XX_V2_WAVEB_2GB
+{
+	SCON_SYSMUX8_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E0  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E1  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E2  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E3  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E4  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E5  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E6  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E7  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E8  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E9  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E10 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E11 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E12 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E13 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E14 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E15 & 0xF)))  /* DEBUG */
+ },
+ {
+	SCON_SYSMUX9_REG,
+	0 |
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E16 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E17 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E18 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E19 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E20 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E21 & 0xF))) | /* SDATO2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E22 & 0xF))) | /* SDATIN2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E23 & 0xF))) | /* SCLK2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E24 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E25 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E26 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E27 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E28 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E29 & 0xF))) | /* FCI_copy
+							-> FCI USB suspend */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E30 & 0xF))) | /* RFSM_OUT3 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E31 & 0xF)))  /* GPIO CAM */
+ },
+#else
+{
+	SCON_SYSMUX8_REG,
+	0 |
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E0  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E1  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E2  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E3  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E4  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E5  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E6  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E7  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E8  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E9  & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E10 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E11 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E12 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E13 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E14 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E15 & 0xF)))  /* DEBUG */
+ },
+ {
+	SCON_SYSMUX9_REG,
+	0 |
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E16 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E17 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E18 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E19 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX2 << (2 * (GPIO_E20 & 0xF))) | /* DEBUG */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E21 & 0xF))) | /* SDATO2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E22 & 0xF))) | /* SDATIN2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E23 & 0xF))) | /* SCLK2 -> SPI2 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E24 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E25 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E26 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E27 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E28 & 0xF))) | /* FCI_copy -> FCI */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E29 & 0xF))) | /* FCI_copy
+							-> FCI USB suspend */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_E30 & 0xF))) | /* RFSM_OUT3 */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_E31 & 0xF)))  /* GPIO CAM */
+ },
+
+#endif
+ {
+	SCON_SYSMUX10_REG,
+	0 |
+#ifdef CONFIG_EBI_BUS
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F0  & 0xF))) | /* EBI_IO0_copy */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F1  & 0xF))) | /* EBI_OE_RW_copy */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F2  & 0xF))) | /* EBI_WE_E_copy */
+#else
+	(GPIO_MODE_MUX1 << (2 * (GPIO_F0  & 0xF))) | /* CAM_PWR_REG -> CAM */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_F1  & 0xF))) | /* AGPS FRAME_SYNC, AGPS */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F2  & 0xF))) | /* free */
+#endif
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F3  & 0xF))) | /* KCOL5 -> Keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F4  & 0xF))) | /* KCOL6 -> Keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F5  & 0xF))) | /* KCOL7 -> Keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F6  & 0xF))) | /* KROW5 -> Keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F7  & 0xF))) | /* KROW6 -> Keypad */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F8  & 0xF))) | /* KROW7 -> Keypad */
+	(GPIO_MODE_MUX1 << (2 * (GPIO_F9  & 0xF))) | /* eMMC_PDn -> FCI */
+#ifdef CONFIG_EBI_BUS
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F10 & 0xF))) | /* VDE_CS0_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F11 & 0xF))) | /* EBI_IO1_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F12 & 0xF))) | /* EBI_IO2_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F13 & 0xF))) | /* EBI_IO3_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F14 & 0xF))) | /* EBI_IO4_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F15 & 0xF)))  /* EBI_IO5_copy */
+#else
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F10 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F11 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F12 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F13 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F14 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F15 & 0xF)))  /* VDE */
+#endif
+ },
+ {
+	SCON_SYSMUX11_REG,
+	0 |
+#ifdef CONFIG_EBI_BUS
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F16 & 0xF))) | /* EBI_IO6_copy */
+	(GPIO_MODE_MUX3 << (2 * (GPIO_F17 & 0xF))) | /* EBI_IO7_copy */
+#else
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F16 & 0xF))) | /* VDE */
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F17 & 0xF))) | /* VDE */
+#endif
+	(GPIO_MODE_MUX0 << (2 * (GPIO_F18 & 0xF)))  /* NFI_CE_n -> NFI */
+ },
+ /* Configure PAD Value */
+ {
+	SCON_SYSPAD0_REG,
+	0 |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A0   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A1   & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A2   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A3   & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A4   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A5   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A6   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A7   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A8   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A9   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A10  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A11  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A12  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A13  & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A14  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A15  & 0xF)))
+ },
+ {
+	SCON_SYSPAD1_REG,
+	0 |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A16  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A17  & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A18  & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_A19  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A20  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A21  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A22  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A23  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A24  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A25  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A26  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A27  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A28  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A29  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A30  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_A31  & 0xF)))
+ },
+ {
+	SCON_SYSPAD2_REG,
+	0 |
+	(SCON_PAD_PULL_DOWN   << (2 * (GPIO_B0   & 0xF))) |
+	(SCON_PAD_PULL_DOWN   << (2 * (GPIO_B1   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B2   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B3   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B4   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B5   & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_B6   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B7   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B8   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B9   & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B10  & 0xF))) |
+	(SCON_PAD_PLAIN_INPUT << (2 * (GPIO_B11  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B12  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B13  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B14  & 0xF))) |
+	(SCON_PAD_REPEATER    << (2 * (GPIO_B15  & 0xF)))
+ },
+};
+
+/* GPIO def settings to avoid HW issue */
+struct u6_gpio_config u6_gpio_init_config[] = {
+	/* GPIO A bank */
+	{
+		.gpio = GPIO_A5,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 1,
+	},
+	{
+		.gpio = GPIO_A6,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 1,
+	},
+	{
+		.gpio = GPIO_A7,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A8,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 1,
+	},
+	{
+		.gpio = GPIO_A9,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 1,
+	},
+	{
+		.gpio = GPIO_A13,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A17,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A21,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A23,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A24,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 1,
+	},
+	{
+		.gpio = GPIO_A25,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_A30,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	/* GPIO B bank */
+	/* GPIO C bank */
+	/* GPIO D bank */
+	{
+		.gpio = GPIO_D0,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_D24,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_D29,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	/* GPIO E bank */
+	{
+		.gpio = GPIO_E31,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	/* GPIO F bank */
+	{
+		.gpio = GPIO_F0,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_F1,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_F2,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	},
+	{
+		.gpio = GPIO_F9,
+		.dir = GPIO_DIR_OUTPUT,
+		.value = 0,
+	}
+};
+
+u32 gpio_to_configure = ARRAY_SIZE(u6_gpio_init_config);
 
 /* List of board specific devices */
 static struct platform_device *devices[] __initdata = {
@@ -30,6 +497,7 @@ static struct platform_device *devices[] __initdata = {
 
 void __init u67xx_init(void)
 {
+	u6_gpio_init();
 	/* Add specific board devices */
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
diff --git a/arch/arm/mach-u67xx/devices.c b/arch/arm/mach-u67xx/devices.c
index 1d00b35..f558fca 100644
--- a/arch/arm/mach-u67xx/devices.c
+++ b/arch/arm/mach-u67xx/devices.c
@@ -11,10 +11,77 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <linux/platform_device.h>
+#include <linux/fs.h>
+#include <linux/gpio.h>
+#include <mach/hardware.h>
+#include <mach/scon.h>
+
+/* EXTINT to GPIO mapping */
+unsigned char extint_to_gpio[NR_EXTINT] = {
+	GPIO_A0,  /*extint 0 */
+	GPIO_A1,  /*extint 1 */
+	GPIO_A2,  /*extint 2 */
+	GPIO_A3,  /*extint 3 */
+	GPIO_A4,  /*extint 4 */
+	GPIO_A5,  /*extint 5 */
+	GPIO_A12, /*extint 6 */
+	GPIO_A13, /*extint 7 */
+	GPIO_A14, /*extint 8 */
+	GPIO_A15, /*extint 9 */
+	GPIO_A16, /*extint 10 */
+	GPIO_A17, /*extint 11 */
+	GPIO_D19, /*extint 12 */
+	GPIO_A19, /*extint 13 */
+	GPIO_A20, /*extint 14 */
+	GPIO_B11, /*extint 15 */
+	GPIO_E30, /*extint 16 */
+	GPIO_D15, /*extint 17 */
+	GPIO_D20, /*extint 18 */
+	GPIO_B9,  /*extint 19 */
+	GPIO_B7,  /*extint 20 */
+	GPIO_A25, /*extint 21 */
+	GPIO_D18, /*extint 22 */
+	GPIO_A6   /*extint 23 */
+};
+EXPORT_SYMBOL(extint_to_gpio);
+
+struct gpio_bank u6_gpio_bank[6] = {
+	{GPIOA_PINS_REG, SCON_SYSMUX0_REG},
+	{GPIOB_PINS_REG, SCON_SYSMUX2_REG},
+	{GPIOC_PINS_REG, SCON_SYSMUX4_REG},
+	{GPIOD_PINS_REG, SCON_SYSMUX6_REG},
+	{GPIOE_PINS_REG, SCON_SYSMUX8_REG},
+	{GPIOF_PINS_REG, SCON_SYSMUX10_REG},
+};
+
+static struct gpio_data u6_gpio_data = {
+	ARRAY_SIZE(u6_gpio_bank),	/* nb bank */
+	u6_gpio_bank
+};
+
+static struct resource u6_wavex_gpio_resources[] = {
+	[0] = {
+	       .start = GPIOA_BASE,	/* Physical address */
+	       .end = GPIOA_BASE + SZ_4K - 1,
+	       .flags = IORESOURCE_MEM,
+	       },
+};
+
+static struct platform_device u6_wavex_gpio_device = {
+	.name = "u6-gpio",
+	.id = -1,
+	.dev = {
+		.platform_data = &u6_gpio_data,
+		},
+	.num_resources = ARRAY_SIZE(u6_wavex_gpio_resources),
+	.resource = u6_wavex_gpio_resources,
+};
 
 /* list of devices */
 static struct platform_device *platform_devs[] __initdata = {
+	&u6_wavex_gpio_device,
 };
 
 /* register generic devices */
diff --git a/arch/arm/plat-u6xxx/Makefile b/arch/arm/plat-u6xxx/Makefile
index afdf82b..3d6898e 100644
--- a/arch/arm/plat-u6xxx/Makefile
+++ b/arch/arm/plat-u6xxx/Makefile
@@ -3,6 +3,6 @@
 #
 
 # Common support
-obj-y := io.o irq.o clock.o
+obj-y := io.o irq.o clock.o gpio.o
 
 obj-$(CONFIG_U6_MTU_TIMER) += timer.o
diff --git a/arch/arm/plat-u6xxx/gpio.c b/arch/arm/plat-u6xxx/gpio.c
new file mode 100644
index 0000000..b064ee2
--- /dev/null
+++ b/arch/arm/plat-u6xxx/gpio.c
@@ -0,0 +1,665 @@
+/*
+ * linux/arch/arm/plat-u6xxx/gpio.c
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ * Support functions for GPIO
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/ptrace.h>
+#include <linux/sysdev.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <asm/irq.h>
+#include <asm/mach/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/scon.h>
+
+#define DRV_NAME "u6-gpio"
+
+/*
+ * PN5220 GPIO/MUX registers
+ * defined in asm/arch/registers.h
+ */
+
+#define U6_GPIO_PINS_OFFSET	0
+#define U6_GPIO_OUTPUT_OFFSET	4
+#define U6_GPIO_DIR_OFFSET	8
+
+#define U6_MUX2_OFFSET		4
+
+static struct gpio_bank *gpio_bank_desc;
+static int gpio_bank_count;
+
+static inline struct gpio_bank *get_gpio_bank(int gpio)
+{
+	/* 32 GPIOs per bank */
+	return &(gpio_bank_desc[gpio >> 5]);
+}
+
+static inline int get_gpio_index(int gpio)
+{
+	return gpio & 0x1f;
+}
+
+static int check_gpio(int gpio)
+{
+	int retval = ((unsigned int)gpio) < U6_GPIO_COUNT;
+	WARN(!retval, DRV_NAME": invalid GPIO %d\n", gpio);
+	return retval;
+}
+
+static inline int gpio_is_requested(struct gpio_bank *bank, unsigned long mask)
+{
+	return bank->reserved_map & mask;
+}
+
+static int check_gpio_requested(struct gpio_bank *bank, int index)
+{
+	int retval = gpio_is_requested(bank, 1 << index);
+	if (unlikely(!retval)) {
+		char c = 'A' + (bank - get_gpio_bank(0));
+		printk(KERN_ERR DRV_NAME": GPIO %c%d is not requested yet\n",
+		       c, index);
+		dump_stack();
+	}
+	return retval;
+}
+
+static int check_gpio_unrequested(struct gpio_bank *bank, int index)
+{
+	int retval = !gpio_is_requested(bank, 1 << index);
+	if (unlikely(!retval)) {
+		char c = 'A' + (bank - get_gpio_bank(0));
+		printk(KERN_ERR DRV_NAME": GPIO %c%d is already requested\n",
+		       c, index);
+		dump_stack();
+	}
+	return retval;
+}
+
+static int check_gpio_irq(int gpio_irq)
+{
+	int retval = ((unsigned int)gpio_irq) < NR_EXTINT;
+	if (unlikely(!retval)) {
+		printk(KERN_ERR DRV_NAME": invalid GPIO-IRQ %d\n", gpio_irq);
+		dump_stack();
+	}
+	return retval;
+}
+
+static void _set_gpio_direction(struct gpio_bank *bank, int gpio, int is_input)
+{
+	void __iomem *reg = bank->gpio_base;
+	u32 l;
+
+	/* select direction register */
+	reg += U6_GPIO_DIR_OFFSET;
+
+	/* in register 0 = input, 1 = output */
+	l = readl(reg);
+	if (is_input)
+		l &= ~(1 << gpio);
+	else
+		l |= (1 << gpio);
+	writel(l, reg);
+}
+
+int u6_gpio_set_direction(int gpio, int is_input)
+{
+	unsigned long flags, index;
+	struct gpio_bank *bank;
+
+	if (!check_gpio(gpio))
+		return -EINVAL;
+
+	bank = get_gpio_bank(gpio);
+	index = get_gpio_index(gpio);
+	if (!check_gpio_requested(bank, index))
+		return -EINVAL;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	_set_gpio_direction(bank, index, is_input);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(u6_gpio_set_direction);
+
+static void _set_gpio_mode(struct gpio_bank *bank, int gpio, int mode)
+{
+	void __iomem *reg = bank->mux_base;
+	unsigned long l;
+
+	/* select direction register */
+	if (gpio >= 16) {
+		reg += U6_MUX2_OFFSET;
+		gpio -= 16;
+	}
+
+	/* apply mux mode */
+	/* width 2 bit */
+	l = readl(reg);
+	l &= ~(3 << (gpio * 2));
+	l |= (mode << (gpio * 2));
+	writel(l, reg);
+}
+
+int u6_gpio_set_mode(int gpio, int mode)
+{
+	struct gpio_bank *bank;
+	int index;
+
+	if (!check_gpio(gpio))
+		return -EINVAL;
+
+	bank = get_gpio_bank(gpio);
+	index = get_gpio_index(gpio);
+	if (!check_gpio_requested(bank, index))
+		return -EINVAL;
+
+	spin_lock(&bank->lock);
+	_set_gpio_mode(bank, get_gpio_index(gpio), mode);
+	spin_unlock(&bank->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(u6_gpio_set_mode);
+
+int u6_gpio_set_mode_gpio(int gpio)
+{
+	int muxmode = gpio >= GPIO_B0 ? GPIO_MODE_MUX1 : GPIO_MODE_MUX0;
+	return u6_gpio_set_mode(gpio, muxmode);
+}
+EXPORT_SYMBOL(u6_gpio_set_mode_gpio);
+
+static void _write_gpio_pin(struct gpio_bank *bank, int gpio, int gpio_value)
+{
+	void __iomem *reg = bank->gpio_base;
+	unsigned long l = 0;
+
+	reg += U6_GPIO_OUTPUT_OFFSET;
+	l = readl(reg);
+	if (gpio_value)
+		l |= 1 << gpio;
+	else
+		l &= ~(1 << gpio);
+	writel(l, reg);
+}
+
+static int u6_gpio_to_extint(int gpio)
+{
+	int extint_idx;
+
+	for (extint_idx = 0; extint_idx < NR_EXTINT; extint_idx++)
+		if (extint_to_gpio[extint_idx] == gpio)
+			return extint_idx;
+
+	return -1;
+}
+
+int u6_gpio_write_pin(int gpio, int gpio_value)
+{
+	struct gpio_bank *bank;
+	unsigned long index;
+
+	if (!check_gpio(gpio))
+		return -EINVAL;
+
+	bank = get_gpio_bank(gpio);
+	index = get_gpio_index(gpio);
+	if (!check_gpio_requested(bank, index))
+		return -EINVAL;
+
+	spin_lock(&bank->lock);
+	_write_gpio_pin(bank, index, gpio_value);
+	spin_unlock(&bank->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(u6_gpio_write_pin);
+
+int u6_gpio_read_pin(int gpio)
+{
+	struct gpio_bank *bank;
+	void __iomem *reg;
+	u32 l = 0;
+	int irq, index;
+
+	if (!check_gpio(gpio))
+		return -EINVAL;
+
+	bank = get_gpio_bank(gpio);
+	index = get_gpio_index(gpio);
+	if (!check_gpio_requested(bank, index))
+		return -EINVAL;
+
+	/* check if the GPIO is used as extint */
+	irq = u6_gpio_to_extint(gpio);
+	if (irq >= 0) {
+		/* and if it's an alternate internal signal */
+		/* (cf U67xx datasheet table 444) */
+		reg = EXTINT_CFGx(irq);
+		l = readl(reg);
+		if (l & EXTINT_SEL_ALTERNATE) {
+			reg = EXTINT_SIGNAL_REG;
+			return (readl(reg) & (1 << irq)) != 0;
+		}
+	}
+
+	reg = bank->gpio_base;
+	reg += U6_GPIO_PINS_OFFSET;
+	return (readl(reg) & (1 << index)) != 0;
+}
+EXPORT_SYMBOL(u6_gpio_read_pin);
+
+static int _u6_gpio_request(struct gpio_bank *bank, int index)
+{
+	int retval = 0;
+	unsigned long mask = 1 << index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	if (unlikely(!check_gpio_unrequested(bank, index)))
+		retval = -EINVAL;
+	else
+		bank->reserved_map |= mask;
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return retval;
+}
+
+static int u6_gpio_acquire(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
+
+	return _u6_gpio_request(bank, offset);
+}
+
+int u6_gpio_request(int gpio)
+{
+	int index;
+	struct gpio_bank *bank;
+
+	if (!check_gpio(gpio))
+		return -EINVAL;
+
+	index = get_gpio_index(gpio);
+	bank = get_gpio_bank(gpio);
+
+	return _u6_gpio_request(bank, index);
+}
+EXPORT_SYMBOL(u6_gpio_request);
+
+static void _u6_gpio_free(struct gpio_bank *bank, int index)
+{
+	unsigned long mask = 1 << index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	if (likely(check_gpio_requested(bank, index)))
+		bank->reserved_map &= ~mask;
+	spin_unlock_irqrestore(&bank->lock, flags);
+}
+
+static void u6_gpio_release(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
+
+	return _u6_gpio_free(bank, offset);
+}
+
+void u6_gpio_free(int gpio)
+{
+	int index;
+	struct gpio_bank *bank;
+
+	if (!check_gpio(gpio))
+		return;
+
+	index = get_gpio_index(gpio);
+	bank = get_gpio_bank(gpio);
+	_u6_gpio_free(bank, index);
+}
+EXPORT_SYMBOL(u6_gpio_free);
+
+/* New GPIO_GENERIC interface */
+
+static int gpio_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_bank *bank;
+	unsigned long flags;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock_irqsave(&bank->lock, flags);
+	_set_gpio_direction(bank, offset, 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
+	return 0;
+}
+
+static int gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return u6_gpio_read_pin(chip->base + offset);
+}
+
+static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_bank *bank;
+	unsigned long flags;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock_irqsave(&bank->lock, flags);
+	_write_gpio_pin(bank, offset, value);
+	_set_gpio_direction(bank, offset, 0);
+	spin_unlock_irqrestore(&bank->lock, flags);
+	return 0;
+}
+
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_bank *bank;
+	unsigned long flags;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock_irqsave(&bank->lock, flags);
+	_write_gpio_pin(bank, offset, value);
+	spin_unlock_irqrestore(&bank->lock, flags);
+}
+
+static int gpio_2irq(struct gpio_chip *chip, unsigned offset)
+{
+	return u6_gpio_to_extint(chip->base + offset);
+}
+
+/*
+ * U6 EXTINT : only EXTINT 3 is managed by Linux
+ * We need to unmask the GPIO bank interrupt as soon as possible to
+ * avoid missing GPIO interrupts for other lines in the bank.
+ * Then we need to mask-read-clear-unmask the triggered GPIO lines
+ * in the bank to avoid missing nested interrupts for a GPIO line.
+ * If we wait to unmask individual GPIO lines in the bank after the
+ * line's interrupt handler has been run, we may miss some nested
+ * interrupts.
+ */
+static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long isr;
+	unsigned long flags;
+	unsigned int gpio_irq;
+
+	/* LPA TBD */
+	desc->chip->ack(irq);
+
+	/* read status */
+	local_irq_save(flags);
+	isr = readl(EXTINT_STATUS_REG) & readl(EXTINT_ENABLE3_REG);
+	/* clear IRQ source(s) */
+	writel(~isr, EXTINT_STATUS_REG);
+	local_irq_restore(flags);
+
+	gpio_irq = IRQ_COUNT;
+	for (; isr != 0; isr >>= 1, gpio_irq++) {
+		struct irq_desc *d;
+		if (!(isr & 1))
+			continue;
+		d = irq_desc + gpio_irq;
+#ifdef CONFIG_DEBUG_EXTINT
+		printk(KERN_ERR "got something from EXTINT#%i line\n",
+		       gpio_irq - IRQ_COUNT);
+#endif
+		desc_handle_irq(gpio_irq, d);
+	}
+
+}
+
+static void gpio_ack_irq(unsigned int irq)
+{
+	unsigned int gpio_irq = irq - IRQ_COUNT;
+	writel(~(1 << gpio_irq), EXTINT_STATUS_REG);
+}
+
+static void gpio_mask_irq(unsigned int irq)
+{
+	unsigned int gpio_irq = irq - IRQ_COUNT;
+	writel(readl(EXTINT_ENABLE3_REG) & ~(1 << gpio_irq),
+		     EXTINT_ENABLE3_REG);
+}
+
+static void gpio_unmask_irq(unsigned int irq)
+{
+	unsigned int gpio_irq = irq - IRQ_COUNT;
+	writel(readl(EXTINT_ENABLE3_REG) | (1 << gpio_irq),
+		     EXTINT_ENABLE3_REG);
+}
+
+int u6_gpio_clear_irq(unsigned int irq)
+{
+	unsigned int gpio_irq;
+	gpio_irq = irq - IRQ_COUNT;
+	if (!check_gpio_irq(gpio_irq))
+		return -EINVAL;
+	writel(~(1 << gpio_irq), EXTINT_STATUS_REG);
+	return 0;
+}
+EXPORT_SYMBOL(u6_gpio_clear_irq);
+
+int u6_gpio_set_irq_debounce(int irq, int cycles)
+{
+	int gpio;
+	struct gpio_bank *bank;
+	void __iomem *reg;
+	int mode;
+	u32 l = 0;
+
+	gpio = EXTINT_TO_GPIO(irq);
+	irq -= IRQ_COUNT;
+	if (!check_gpio_irq(irq))
+		goto err;
+
+	bank = get_gpio_bank(gpio);
+	if (!check_gpio_requested(bank, get_gpio_index(gpio)))
+		return -EINVAL;
+
+	reg = EXTINT_CFGx(irq);
+	l = readl(reg);
+
+	mode = l & (3 << EXTINT_MODE_SHIFT);
+	if (mode == EXTINT_MODE_BYPASS)
+		goto err;
+
+	/* clear mode and set streching to debounce */
+	if (mode == EXTINT_MODE_STRETCHING) {
+		l &= ~(3 << EXTINT_MODE_SHIFT);
+		l |= EXTINT_MODE_DEBOUNCE;
+	}
+	/* clear and set the debounce field */
+	l &= ~(7 << EXTINT_DEBOUNCE_SHIFT);
+	l |= ((cycles & 0x7) << EXTINT_DEBOUNCE_SHIFT);
+	writel(l, reg);
+
+	return 0;
+err:
+	return -EINVAL;
+}
+EXPORT_SYMBOL(u6_gpio_set_irq_debounce);
+
+int u6_gpio_set_irq_selection(int irq, int selection)
+{
+	int gpio, index;
+	struct gpio_bank *bank;
+	u32 l = 0;
+	void __iomem *reg;
+
+	gpio = EXTINT_TO_GPIO(irq);
+	irq -= IRQ_COUNT;
+	if (!check_gpio_irq(irq))
+		return -EINVAL;
+
+	bank = get_gpio_bank(gpio);
+	index = get_gpio_index(gpio);
+	if (!check_gpio_requested(bank, index))
+		return -EINVAL;
+
+	reg = EXTINT_CFGx(irq);
+	l = readl(reg);
+
+	if (selection == EXTINT_SEL_ALTERNATE)
+		l |= EXTINT_SEL_ALTERNATE;
+	else
+		l &= ~EXTINT_SEL_ALTERNATE;
+	writel(l, reg);
+
+	return 0;
+}
+EXPORT_SYMBOL(u6_gpio_set_irq_selection);
+
+/*
+ * -the level type set the bypass mode
+ * -and by default the edge type select the stretching mode.
+ * if you would a debounce you must defined your nb
+ * cycle with u6_set_gpio_debounce
+ */
+static int _set_gpio_triggering(int gpio_irq, int trigger)
+{
+	void __iomem *reg = EXTINT_CFGx(gpio_irq);
+	u32 l = 0;
+
+	l = readl(reg);
+	l &= ~(3 << 6 | 1 << 2);
+
+	if (trigger == IRQ_TYPE_LEVEL_LOW)
+		l |= EXTINT_POL_NEGATIVE;
+	else if (trigger == IRQ_TYPE_LEVEL_HIGH)
+		l |= EXTINT_POL_POSITIVE;
+	else if (trigger == IRQ_TYPE_EDGE_RISING)
+		l |= (EXTINT_MODE_STRETCHING | EXTINT_POL_POSITIVE);
+	else if (trigger == IRQ_TYPE_EDGE_FALLING)
+		l |= (EXTINT_MODE_STRETCHING | EXTINT_POL_NEGATIVE);
+	else if (trigger == IRQ_TYPE_EDGE_BOTH)
+		l |= EXTINT_MODE_DUAL_EDGE;
+	else
+		goto err;
+
+	writel(l, reg);
+
+	return 0;
+err:
+	return -EINVAL;
+}
+
+static int gpio_irq_type(unsigned irq, unsigned type)
+{
+	unsigned gpio_irq;
+	int retval;
+
+	gpio_irq = irq - IRQ_COUNT;
+
+	if (!check_gpio_irq(gpio_irq))
+		return -EINVAL;
+
+	if (type & (IRQF_TRIGGER_PROBE))
+		return -EINVAL;
+
+	retval = _set_gpio_triggering(gpio_irq, type);
+	return retval;
+}
+
+static struct irq_chip gpio_irq_chip = {
+	.ack = gpio_ack_irq,
+	.disable = gpio_mask_irq,
+	.enable = gpio_unmask_irq,
+	.mask = gpio_mask_irq,
+	.unmask = gpio_unmask_irq,
+	.set_type = gpio_irq_type,
+	/*.set_wake     = gpio_wake_enable, */
+};
+
+static int __devinit u6_gpio_probe(struct platform_device *pdev)
+{
+	int i, j;
+	int gpio = 0;
+	struct gpio_bank *bank;
+	struct gpio_data *data = pdev->dev.platform_data;
+	unsigned long flags;
+
+	printk(KERN_INFO "U6 GPIO\n");
+	gpio_bank_desc = data->gpio_bank_desc;
+	gpio_bank_count = data->nb_banks;
+
+	for (i = 0; i < gpio_bank_count; i++) {
+		int gpio_count = 32;	/* 32 GPIO per bank */
+		bank = &gpio_bank_desc[i];
+		bank->reserved_map = 0;
+		spin_lock_init(&bank->lock);
+
+		bank->chip.request = u6_gpio_acquire;
+		bank->chip.free = u6_gpio_release;
+		bank->chip.direction_input = gpio_input;
+		bank->chip.get = gpio_get;
+		bank->chip.direction_output = gpio_output;
+		bank->chip.set = gpio_set;
+		bank->chip.to_irq = gpio_2irq;
+		bank->chip.label = "gpio";
+		bank->chip.base = gpio;
+		gpio += gpio_count;
+
+		bank->chip.ngpio = gpio_count;
+
+		gpiochip_add(&bank->chip);
+
+	}
+
+	/* configure MUX and PAD settings */
+	for (i = 0; i < SCON_REGISTER_NB; i++)
+		writel(u6_scon_init_config[i].scon_reg_value,
+			     u6_scon_init_config[i].scon_reg_addr);
+
+	/* for extint */
+	for (j = IRQ_COUNT; j < IRQ_COUNT + NR_EXTINT; j++) {
+		set_irq_chip(j, &gpio_irq_chip);
+		set_irq_handler(j, handle_simple_irq);
+		set_irq_flags(j, IRQF_VALID);
+	}
+
+	local_irq_save(flags);
+	/* mask all EXT IRQ sources before registring handler */
+	/* read status */
+	j = readl(EXTINT_STATUS_REG) & readl(EXTINT_ENABLE3_REG);
+	/* clear IRQ source(s) */
+	writel(j, EXTINT_STATUS_REG);
+
+	writel(0, EXTINT_ENABLE3_REG);
+
+	/* set irq in low level */
+	set_irq_type(IRQ_EXTINT3, IRQF_TRIGGER_LOW);
+
+	/* chained GPIO-IRQ on EXTINT3 */
+	set_irq_chained_handler(IRQ_EXTINT3, gpio_irq_handler);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static struct platform_driver u6_gpio_driver = {
+	.probe = u6_gpio_probe,
+	.driver = {
+		.name = DRV_NAME,
+	},
+};
+
+int __init u6_gpio_init(void)
+{
+	return platform_driver_register(&u6_gpio_driver);
+}
diff --git a/arch/arm/plat-u6xxx/include/mach/gpio.h b/arch/arm/plat-u6xxx/include/mach/gpio.h
new file mode 100644
index 0000000..72e8147
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/gpio.h
@@ -0,0 +1,391 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/gpio.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ * GPIO handling defines and functions
+ */
+
+#ifndef __ASM_PLAT_U6_GPIO_H
+#define __ASM_PLAT_U6_GPIO_H
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>
+
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+
+/* GPIO bank description */
+struct gpio_bank {
+	void __iomem *gpio_base;
+	void __iomem *mux_base;
+	u16 irq;
+	u16 virtual_irq_start;
+	int method;
+	u32 reserved_map;
+	u32 suspend_wakeup;
+	u32 saved_wakeup;
+	spinlock_t lock;
+	struct gpio_chip chip;
+};
+
+
+struct gpio_data {
+	u32 nb_banks;
+	struct gpio_bank *gpio_bank_desc;
+};
+
+
+/* GPIO Init configuration */
+
+struct u6_gpio_config {
+	u32 gpio;
+	u32 dir;
+	u32 value;
+};
+
+
+/* list of GPIO */
+enum U6_GPIO_LIST {
+	GPIO_A0 = 0,
+	GPIO_A1,
+	GPIO_A2,
+	GPIO_A3,
+	GPIO_A4,
+	GPIO_A5,
+	GPIO_A6,
+	GPIO_A7,
+	GPIO_A8,
+	GPIO_A9,
+	GPIO_A10,
+	GPIO_A11,
+	GPIO_A12,
+	GPIO_A13,
+	GPIO_A14,
+	GPIO_A15,
+	GPIO_A16,
+	GPIO_A17,
+	GPIO_A18,
+	GPIO_A19,
+	GPIO_A20,
+	GPIO_A21,
+	GPIO_A22,
+	GPIO_A23,
+	GPIO_A24,
+	GPIO_A25,
+	GPIO_A26,
+	GPIO_A27,
+	GPIO_A28,
+	GPIO_A29,
+	GPIO_A30,
+	GPIO_A31,
+	GPIO_B0,
+	GPIO_B1,
+	GPIO_B2,
+	GPIO_B3,
+	GPIO_B4,
+	GPIO_B5,
+	GPIO_B6,
+	GPIO_B7,
+	GPIO_B8,
+	GPIO_B9,
+	GPIO_B10,
+	GPIO_B11,
+	GPIO_B12,
+	GPIO_B13,
+	GPIO_B14,
+	GPIO_B15,
+	GPIO_B16,
+	GPIO_B17,
+	GPIO_B18,
+	GPIO_B19,
+	GPIO_B20,
+	GPIO_B21,
+	GPIO_B22,
+	GPIO_B23,
+	GPIO_B24,
+	GPIO_B25,
+	GPIO_B26,
+	GPIO_B27,
+	GPIO_B28,
+	GPIO_B29,
+	GPIO_B30,
+	GPIO_B31,
+	GPIO_C0,
+	GPIO_C1,
+	GPIO_C2,
+	GPIO_C3,
+	GPIO_C4,
+	GPIO_C5,
+	GPIO_C6,
+	GPIO_C7,
+	GPIO_C8,
+	GPIO_C9,
+	GPIO_C10,
+	GPIO_C11,
+	GPIO_C12,
+	GPIO_C13,
+	GPIO_C14,
+	GPIO_C15,
+	GPIO_C16,
+	GPIO_C17,
+	GPIO_C18,
+	GPIO_C19,
+	GPIO_C20,
+	GPIO_C21,
+	GPIO_C22,
+	GPIO_C23,
+	GPIO_C24,
+	GPIO_C25,
+	GPIO_C26,
+	GPIO_C27,
+	GPIO_C28,
+	GPIO_C29,
+	GPIO_C30,
+	GPIO_C31,
+	GPIO_D0,
+	GPIO_D1,
+	GPIO_D2,
+	GPIO_D3,
+	GPIO_D4,
+	GPIO_D5,
+	GPIO_D6,
+	GPIO_D7,
+	GPIO_D8,
+	GPIO_D9,
+	GPIO_D10,
+	GPIO_D11,
+	GPIO_D12,
+	GPIO_D13,
+	GPIO_D14,
+	GPIO_D15,
+	GPIO_D16,
+	GPIO_D17,
+	GPIO_D18,
+	GPIO_D19,
+	GPIO_D20,
+	GPIO_D21,
+	GPIO_D22,
+	GPIO_D23,
+	GPIO_D24,
+	GPIO_D25,
+	GPIO_D26,
+	GPIO_D27,
+	GPIO_D28,
+	GPIO_D29,
+	GPIO_D30,
+	GPIO_D31,
+	GPIO_E0,
+	GPIO_E1,
+	GPIO_E2,
+	GPIO_E3,
+	GPIO_E4,
+	GPIO_E5,
+	GPIO_E6,
+	GPIO_E7,
+	GPIO_E8,
+	GPIO_E9,
+	GPIO_E10,
+	GPIO_E11,
+	GPIO_E12,
+	GPIO_E13,
+	GPIO_E14,
+	GPIO_E15,
+	GPIO_E16,
+	GPIO_E17,
+	GPIO_E18,
+	GPIO_E19,
+	GPIO_E20,
+	GPIO_E21,
+	GPIO_E22,
+	GPIO_E23,
+	GPIO_E24,
+	GPIO_E25,
+	GPIO_E26,
+	GPIO_E27,
+	GPIO_E28,
+	GPIO_E29,
+	GPIO_E30,
+	GPIO_E31,
+	GPIO_F0,
+	GPIO_F1,
+	GPIO_F2,
+	GPIO_F3,
+	GPIO_F4,
+	GPIO_F5,
+	GPIO_F6,
+	GPIO_F7,
+	GPIO_F8,
+	GPIO_F9,
+	GPIO_F10,
+	GPIO_F11,
+	GPIO_F12,
+	GPIO_F13,
+	GPIO_F14,
+	GPIO_F15,
+	GPIO_F16,
+	GPIO_F17,
+	GPIO_F18,
+	GPIO_F19,
+	GPIO_F20,
+	GPIO_F21,
+	GPIO_F22,
+	GPIO_F23,
+	GPIO_F24,
+	GPIO_F25,
+	GPIO_F26,
+	GPIO_F27,
+	GPIO_F28,
+	GPIO_F29,
+	GPIO_F30,
+	GPIO_F31,
+	U6_GPIO_COUNT,
+};
+
+enum U6_GPIO_MODE {
+	GPIO_MODE_MUX0 = 0,
+	GPIO_MODE_MUX1,
+	GPIO_MODE_MUX2,
+	GPIO_MODE_MUX3
+};
+
+
+#define GPIO_DIR_INPUT  1
+#define GPIO_DIR_OUTPUT 0
+
+
+extern int  u6_gpio_init(void);	/* Call from board init only */
+extern int  u6_gpio_request(int gpio);
+extern void u6_gpio_free(int gpio);
+extern int  u6_gpio_set_mode(int gpio, int mode);
+extern int  u6_gpio_set_mode_gpio(int gpio);
+extern int  u6_gpio_set_direction(int gpio, int is_input);
+extern int  u6_gpio_write_pin(int gpio, int gpio_value);
+extern int  u6_gpio_read_pin(int gpio);
+extern int  u6_gpio_set_irq_debounce(int irq, int cycles);
+extern int  u6_gpio_set_irq_selection(int irq, int selection);
+extern int  u6_gpio_clear_irq(unsigned int irq);
+
+
+/*
+ * Wrappers for "new style" GPIO calls, using the new infrastructure
+ * which lets us plug in FPGA, I2C, and other implementations.
+ */
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return EXTINT_TO_GPIO(irq);
+}
+
+/*
+* Hardware Register Definitions for EXTINT
+ */
+
+/* EXTINT ENABLE1 Register (32 bits) */
+#define EXTINT_ENABLE1_OFFSET  0x60
+#define EXTINT_ENABLE1_REG     U6_IO_ADDRESS(EXTINT_BASE + EXTINT_ENABLE1_OFFSET)
+
+/* EXTINT ENABLE2 Register (32 bits) */
+#define EXTINT_ENABLE2_OFFSET  0x64
+#define EXTINT_ENABLE2_REG     U6_IO_ADDRESS(EXTINT_BASE + EXTINT_ENABLE2_OFFSET)
+
+/* EXTINT ENABLE3 Register (32 bits) */
+#define EXTINT_ENABLE3_OFFSET  0x68
+#define EXTINT_ENABLE3_REG     U6_IO_ADDRESS(EXTINT_BASE + EXTINT_ENABLE3_OFFSET)
+
+/* EXTINT STATUS Register (32 bits) */
+#define EXTINT_STATUS_OFFSET   0x6C
+#define EXTINT_STATUS_REG      U6_IO_ADDRESS(EXTINT_BASE + EXTINT_STATUS_OFFSET)
+
+/* EXTINT SIGNAL Register (32 bits) */
+#define EXTINT_SIGNAL_OFFSET   0x70
+#define EXTINT_SIGNAL_REG      U6_IO_ADDRESS(EXTINT_BASE + EXTINT_SIGNAL_OFFSET)
+
+/* Bits definition for register EXTINT_CFG[23:0] */
+#define EXTINT_MODE_SHIFT      6
+#define EXTINT_MODE_FIELD      (0xFFFFFFFF - (0x3UL<<EXTINT_MODE_SHIFT))
+#define EXTINT_MODE_BYPASS     (0x0UL<<EXTINT_MODE_SHIFT)
+#define EXTINT_MODE_STRETCHING (0x1UL<<EXTINT_MODE_SHIFT)
+#define EXTINT_MODE_DEBOUNCE   (0x2UL<<EXTINT_MODE_SHIFT)
+#define EXTINT_MODE_DUAL_EDGE  (0x3UL<<EXTINT_MODE_SHIFT)
+#define EXTINT_DEBOUNCE_SHIFT  3
+#define EXTINT_DEBOUNCE_FIELD  (0xFFFFFFFF - (0x7UL<<EXTINT_DEBOUNCE_SHIFT))
+#define EXTINT_DEBOUNCE_0      (0x0UL<<EXTINT_DEBOUNCE_SHIFT)
+#define EXTINT_DEBOUNCE_1      (0x1UL<<EXTINT_DEBOUNCE_SHIFT)
+#define EXTINT_DEBOUNCE_2      (0x2UL<<EXTINT_DEBOUNCE_SHIFT)
+#define EXTINT_DEBOUNCE_3      (0x3UL<<EXTINT_DEBOUNCE_SHIFT)
+#define EXTINT_DEBOUNCE_7      (0x7UL<<EXTINT_DEBOUNCE_SHIFT)
+#define EXTINT_POL_SHIFT       2
+#define EXTINT_POL_FIELD       (0xFFFFFFFF - (0x1UL<<EXTINT_POL_SHIFT))
+#define EXTINT_POL_NEGATIVE    (0x0UL<<EXTINT_POL_SHIFT)
+#define EXTINT_POL_POSITIVE    (0x1UL<<EXTINT_POL_SHIFT)
+#define EXTINT_POL             (0x1UL<<EXTINT_POL_SHIFT)
+#define EXTINT_SEL_SHIFT       1
+#define EXTINT_SEL_FIELD       (0xFFFFFFFF - (0x1UL<<EXTINT_SEL_SHIFT))
+#define EXTINT_SEL_EXTINT      (0x0UL<<EXTINT_SEL_SHIFT)
+#define EXTINT_SEL_ALTERNATE   (0x1UL<<EXTINT_SEL_SHIFT)
+#define EXTINT_SEL             (0x1UL<<EXTINT_SEL_SHIFT)
+
+/*****************************************************************************/
+/* Register description for ENABLE[3:1] */
+
+/* Bits definition for register EXTINT_ENABLE[3:1] */
+#define EXTINT_ENABLE_SHIFT    0
+#define EXTINT_ENABLE_FIELD    (0xFFFFFFFF - (0xFFFFFFUL<<EXTINT_ENABLE_SHIFT))
+#define EXTINT_ENABLE_0        (0x0UL<<EXTINT_ENABLE_SHIFT)
+#define EXTINT_ENABLE_1        (0x1UL<<EXTINT_ENABLE_SHIFT)
+
+/*****************************************************************************/
+/* Register description for STATUS */
+
+/* Bits definition for register EXTINT_STATUS */
+#define EXTINT_STATUS_SHIFT    0
+#define EXTINT_STATUS_FIELD    (0xFFFFFFFF - (0xFFFFFFUL<<EXTINT_STATUS_SHIFT))
+#define EXTINT_STATUS_0        (0x0UL<<EXTINT_STATUS_SHIFT)
+#define EXTINT_STATUS_1        (0x1UL<<EXTINT_STATUS_SHIFT)
+
+/* EXTINTx [0..23] configuration register */
+#define EXTINT_CFGx(x)         U6_IO_ADDRESS(EXTINT_BASE+(x)*4)
+
+/*****************************************************************************
+* Hardware Register Definitions for GPIOx
+*****************************************************************************/
+/* Offsets */
+#define GPIO_PINS_OFFSET       0x0
+#define GPIO_OR_OFFSET         0x4
+#define GPIO_DR_OFFSET         0x8
+
+/* GPIOx PINS Registers (32 bits) */
+#define GPIOA_PINS_REG         U6_IO_ADDRESS(GPIOA_BASE + GPIO_PINS_OFFSET)
+#define GPIOB_PINS_REG         U6_IO_ADDRESS(GPIOB_BASE + GPIO_PINS_OFFSET)
+#define GPIOC_PINS_REG         U6_IO_ADDRESS(GPIOC_BASE + GPIO_PINS_OFFSET)
+#define GPIOD_PINS_REG         U6_IO_ADDRESS(GPIOD_BASE + GPIO_PINS_OFFSET)
+#define GPIOE_PINS_REG         U6_IO_ADDRESS(GPIOE_BASE + GPIO_PINS_OFFSET)
+#define GPIOF_PINS_REG         U6_IO_ADDRESS(GPIOF_BASE + GPIO_PINS_OFFSET)
+
+/* GPIOx OR Registers (32 bits) */
+#define GPIOA_OR_REG           U6_IO_ADDRESS(GPIOC_BASE + GPIO_OR_OFFSET)
+
+#endif
diff --git a/arch/arm/plat-u6xxx/include/mach/scon.h b/arch/arm/plat-u6xxx/include/mach/scon.h
new file mode 100644
index 0000000..180aeeb
--- /dev/null
+++ b/arch/arm/plat-u6xxx/include/mach/scon.h
@@ -0,0 +1,123 @@
+/*
+ * linux/arch/arm/plat-u6xxx/include/mach/scon.h
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * System Configuration Block registers
+ */
+
+#ifndef __ARCH_SCON_H
+#define __ARCH_SCON_H
+
+/*
+ * this structure allows to store SCON register values to set
+ * during initialization step
+ */
+
+struct u6_scon_config {
+	void __iomem *scon_reg_addr;
+	u32 scon_reg_value;
+};
+
+#define SCON_REGISTER_NB         15
+
+extern struct u6_scon_config u6_scon_init_config[SCON_REGISTER_NB];
+
+/* SCON SYSVER Register (32 bits) */
+#define SCON_SYSVER_OFFSET       0x0
+#define SCON_SYSVER_REG          U6_IO_ADDRESS(SCON_BASE + SCON_SYSVER_OFFSET)
+
+/* SCON SYSCON0 Register (32 bits) */
+#define SCON_SYSCON0_OFFSET      0x4
+#define SCON_SYSCON0_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSCON0_OFFSET)
+
+/* SCON SYSPROT Register (32 bits) */
+#define SCON_SYSPROT_OFFSET      0x8
+#define SCON_SYSPROT_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSPROT_OFFSET)
+
+/* SCON SYSMUX0 Register (32 bits) */
+#define SCON_SYSMUX0_OFFSET      0xC
+#define SCON_SYSMUX0_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX0_OFFSET)
+
+/* SCON SYSMUX1 Register (32 bits) */
+#define SCON_SYSMUX1_OFFSET      0x10
+#define SCON_SYSMUX1_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX1_OFFSET)
+
+/* SCON SYSMUX2 Register (32 bits) */
+#define SCON_SYSMUX2_OFFSET      0x14
+#define SCON_SYSMUX2_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX2_OFFSET)
+
+/* SCON SYSMUX3 Register (32 bits) */
+#define SCON_SYSMUX3_OFFSET      0x18
+#define SCON_SYSMUX3_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX3_OFFSET)
+
+/* SCON SYSMUX4 Register (32 bits) */
+#define SCON_SYSMUX4_OFFSET      0x1C
+#define SCON_SYSMUX4_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX4_OFFSET)
+
+/* SCON SYSMUX5 Register (32 bits) */
+#define SCON_SYSMUX5_OFFSET      0x20
+#define SCON_SYSMUX5_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX5_OFFSET)
+
+/* SCON SYSMUX6 Register (32 bits) */
+#define SCON_SYSMUX6_OFFSET      0x24
+#define SCON_SYSMUX6_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX6_OFFSET)
+
+/* SCON SYSMUX7 Register (32 bits) */
+#define SCON_SYSMUX7_OFFSET      0x28
+#define SCON_SYSMUX7_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX7_OFFSET)
+
+/* SCON SYSMUX8 Register (32 bits) */
+#define SCON_SYSMUX8_OFFSET      0x2C
+#define SCON_SYSMUX8_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX8_OFFSET)
+
+/* SCON SYSMUX9 Register (32 bits) */
+#define SCON_SYSMUX9_OFFSET      0x30
+#define SCON_SYSMUX9_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX9_OFFSET)
+
+/* SCON SYSMUX10 Register (32 bits) */
+#define SCON_SYSMUX10_OFFSET     0x34
+#define SCON_SYSMUX10_REG        U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX10_OFFSET)
+
+/* SCON SYSMUX11 Register (32 bits) */
+#define SCON_SYSMUX11_OFFSET     0x38
+#define SCON_SYSMUX11_REG        U6_IO_ADDRESS(SCON_BASE + SCON_SYSMUX11_OFFSET)
+
+/* SCON SYSPAD0 Register (32 bits) */
+#define SCON_SYSPAD0_OFFSET      0x50
+#define SCON_SYSPAD0_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSPAD0_OFFSET)
+
+/* SCON SYSPAD1 Register (32 bits) */
+#define SCON_SYSPAD1_OFFSET      0x54
+#define SCON_SYSPAD1_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSPAD1_OFFSET)
+
+/* SCON SYSPAD2 Register (32 bits) */
+#define SCON_SYSPAD2_OFFSET      0x58
+#define SCON_SYSPAD2_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSPAD2_OFFSET)
+
+/* SCON SYSCON1 Register (32 bits) */
+#define SCON_SYSCON1_OFFSET      0x70
+#define SCON_SYSCON1_REG         U6_IO_ADDRESS(SCON_BASE + SCON_SYSCON1_OFFSET)
+
+/* SCON SYSIISMUX Register (32 bits) */
+#define SCON_SYSIISMUX_OFFSET    0x74
+#define SCON_SYSIISMUX_REG       U6_IO_ADDRESS(SCON_BASE + SCON_SYSIISMUX_OFFSET)
+
+/* SCON SYSAHBPROT Register (32 bits) */
+#define SCON_SYSAHBPROT_OFFSET   0x78
+#define SCON_SYSAHBPROT_REG      U6_IO_ADDRESS(SCON_BASE + SCON_SYSAHBPROT_OFFSET)
+
+/* SCON SYSIVSBRIDGE Register (32 bits) */
+#define SCON_SYSIVSBRIDGE_OFFSET 0x7C
+#define SCON_SYSIVSBRIDGE_REG   U6_IO_ADDRESS(SCON_BASE + SCON_SYSIVSBRIDGE_OFFSET)
+
+/* Register description for SYSPADx */
+/* SYSPAD configuration defines */
+#define SCON_PAD_PULL_UP        0
+#define SCON_PAD_REPEATER       1
+#define SCON_PAD_PLAIN_INPUT    2
+#define SCON_PAD_PULL_DOWN      3
+
+#endif
-- 
1.7.1

