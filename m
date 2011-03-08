Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1CHMYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:24:22 -0500
Received: from compulab.co.il ([67.18.134.219]:50875 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1CHMYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:24:19 -0500
Message-ID: <4D761F7F.2030908@compulab.co.il>
Date: Tue, 08 Mar 2011 14:22:23 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v2] pch_uart: reference clock on CM-iTC
References: <4D74A600.7070302@compulab.co.il> <20110307200733.GA18849@kroah.com>
In-Reply-To: <20110307200733.GA18849@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default clock source for UARTs on Topcliff is external UART_CLK.
On CM-iTC USB_48MHz is used instead. After VCO2PLL and DIV
manipulations UARTs will receive 192 MHz.
Clock manipulations on Topcliff are controlled in pch_phub.c

v2: redone against the linux-next tree

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/misc/pch_phub.c       |   19 +++++++++++++++++++
 drivers/tty/serial/pch_uart.c |    9 +++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 98bffc4..a85c4a3 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/if_ether.h>
 #include <linux/ctype.h>
+#include <linux/dmi.h>

 #define PHUB_STATUS 0x00		/* Status Register offset */
 #define PHUB_CONTROL 0x04		/* Control Register offset */
@@ -46,6 +47,13 @@
 #define PCH_MINOR_NOS 1
 #define CLKCFG_CAN_50MHZ 0x12000000
 #define CLKCFG_CANCLK_MASK 0xFF000000
+#define CLKCFG_UART_MASK			0xFFFFFF
+
+/* CM-iTC */
+#define CLKCFG_UART_48MHZ			(1 << 16)
+#define CLKCFG_BAUDDIV				(2 << 20)
+#define CLKCFG_PLL2VCO				(8 << 9)
+#define CLKCFG_UARTCLKSEL			(1 << 18)

 /* Macros for ML7213 */
 #define PCI_VENDOR_ID_ROHM			0x10db
@@ -618,6 +626,17 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CAN_50MHZ,
 					       CLKCFG_CANCLK_MASK);

+		/* quirk for CM-iTC board */
+		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+			pch_phub_read_modify_write_reg(chip,
+						(unsigned int)CLKCFG_REG_OFFSET,
+						CLKCFG_UART_48MHZ |
+						CLKCFG_BAUDDIV |
+						CLKCFG_PLL2VCO |
+						CLKCFG_UARTCLKSEL,
+						CLKCFG_UART_MASK);
+
+
 		/* set the prefech value */
 		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
 		/* set the interrupt delay value */
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 7aba41f..26403b8 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -20,6 +20,7 @@
 #include <linux/serial_core.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/dmi.h>

 #include <linux/dmaengine.h>
 #include <linux/pch_dma.h>
@@ -1403,14 +1404,18 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (!rxbuf)
 		goto init_port_free_txbuf;

+	base_baud = 1843200; /* 1.8432MHz */
+
+	/* quirk for CM-iTC board */
+	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+		base_baud = 192000000; /* 192.0MHz */
+
 	switch (port_type) {
 	case PORT_UNKNOWN:
 		fifosize = 256; /* EG20T/ML7213: UART0 */
-		base_baud = 1843200; /* 1.8432MHz */
 		break;
 	case PORT_8250:
 		fifosize = 64; /* EG20T:UART1~3  ML7213: UART1~2*/
-		base_baud = 1843200; /* 1.8432MHz */
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid Port Type(=%d)\n", port_type);
-- 
1.7.0.4
