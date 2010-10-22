Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0JVXyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab0JVXyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rVZiaAnUsFV7U1UoekqIR/BmLXbSvCgwwTJvvig0nU/gbMuphv1w8cK6bEXETsJCY9
         6fmp+fhh+3DxaFViOXdVKKXTDp7UsyA+Fakl59j9x5WbDsNi2NIQ3o1gncho4woV+1DK
         0Kwhe6oGki1FxKrQZoV0aUarwqu+8f7Uug+c0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 15/29] memstick: jmb38x_ms: Create header
Date: Sat, 23 Oct 2010 01:53:43 +0200
Message-Id: <1287791637-10329-16-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the new header add:

* debug macros
* Registers + some documntation

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  139 +--------------------------
 drivers/memstick/host/jmb38x_ms.h |  188 +++++++++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+), 133 deletions(-)
 create mode 100644 drivers/memstick/host/jmb38x_ms.h

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index f2b894c..7a00bef 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -17,141 +17,10 @@
 #include <linux/highmem.h>
 #include <linux/memstick.h>
 #include <linux/slab.h>
-
-#define DRIVER_NAME "jmb38x_ms"
+#include "jmb38x_ms.h"
 
 static int no_dma;
-module_param(no_dma, bool, 0644);
-
-enum {
-	DMA_ADDRESS       = 0x00,
-	BLOCK             = 0x04,
-	DMA_CONTROL       = 0x08,
-	TPC_P0            = 0x0c,
-	TPC_P1            = 0x10,
-	TPC               = 0x14,
-	HOST_CONTROL      = 0x18,
-	DATA              = 0x1c,
-	STATUS            = 0x20,
-	INT_STATUS        = 0x24,
-	INT_STATUS_ENABLE = 0x28,
-	INT_SIGNAL_ENABLE = 0x2c,
-	TIMER             = 0x30,
-	TIMER_CONTROL     = 0x34,
-	PAD_OUTPUT_ENABLE = 0x38,
-	PAD_PU_PD         = 0x3c,
-	CLOCK_DELAY       = 0x40,
-	ADMA_ADDRESS      = 0x44,
-	CLOCK_CONTROL     = 0x48,
-	LED_CONTROL       = 0x4c,
-	VERSION           = 0x50
-};
-
-struct jmb38x_ms_host {
-	struct jmb38x_ms        *chip;
-	void __iomem            *addr;
-	spinlock_t              lock;
-	struct tasklet_struct   notify;
-	int                     id;
-	char                    host_id[32];
-	int                     irq;
-	unsigned int            block_pos;
-	unsigned long           timeout_jiffies;
-	struct timer_list       timer;
-	struct memstick_request *req;
-	unsigned char           cmd_flags;
-	unsigned char           io_pos;
-	unsigned int            io_word[2];
-};
-
-struct jmb38x_ms {
-	struct pci_dev        *pdev;
-	int                   host_cnt;
-	struct memstick_host  *hosts[];
-};
-
-#define BLOCK_COUNT_MASK       0xffff0000
-#define BLOCK_SIZE_MASK        0x00000fff
-
-#define DMA_CONTROL_ENABLE     0x00000001
-
-#define TPC_DATA_SEL           0x00008000
-#define TPC_DIR                0x00004000
-#define TPC_WAIT_INT           0x00002000
-#define TPC_GET_INT            0x00000800
-#define TPC_CODE_SZ_MASK       0x00000700
-#define TPC_DATA_SZ_MASK       0x00000007
-
-#define HOST_CONTROL_TDELAY_EN 0x00040000
-#define HOST_CONTROL_HW_OC_P   0x00010000
-#define HOST_CONTROL_RESET_REQ 0x00008000
-#define HOST_CONTROL_REI       0x00004000
-#define HOST_CONTROL_LED       0x00000400
-#define HOST_CONTROL_FAST_CLK  0x00000200
-#define HOST_CONTROL_RESET     0x00000100
-#define HOST_CONTROL_POWER_EN  0x00000080
-#define HOST_CONTROL_CLOCK_EN  0x00000040
-#define HOST_CONTROL_REO       0x00000008
-#define HOST_CONTROL_IF_SHIFT  4
-
-#define HOST_CONTROL_IF_SERIAL 0x0
-#define HOST_CONTROL_IF_PAR4   0x1
-#define HOST_CONTROL_IF_PAR8   0x3
-
-#define STATUS_BUSY             0x00080000
-#define STATUS_MS_DAT7          0x00040000
-#define STATUS_MS_DAT6          0x00020000
-#define STATUS_MS_DAT5          0x00010000
-#define STATUS_MS_DAT4          0x00008000
-#define STATUS_MS_DAT3          0x00004000
-#define STATUS_MS_DAT2          0x00002000
-#define STATUS_MS_DAT1          0x00001000
-#define STATUS_MS_DAT0          0x00000800
-#define STATUS_HAS_MEDIA        0x00000400
-#define STATUS_FIFO_EMPTY       0x00000200
-#define STATUS_FIFO_FULL        0x00000100
-#define STATUS_MS_CED           0x00000080
-#define STATUS_MS_ERR           0x00000040
-#define STATUS_MS_BRQ           0x00000020
-#define STATUS_MS_CNK           0x00000001
-
-#define INT_STATUS_TPC_ERR      0x00080000
-#define INT_STATUS_CRC_ERR      0x00040000
-#define INT_STATUS_TIMER_TO     0x00020000
-#define INT_STATUS_HSK_TO       0x00010000
-#define INT_STATUS_ANY_ERR      0x00008000
-#define INT_STATUS_FIFO_WRDY    0x00000080
-#define INT_STATUS_FIFO_RRDY    0x00000040
-#define INT_STATUS_MEDIA_OUT    0x00000010
-#define INT_STATUS_MEDIA_IN     0x00000008
-#define INT_STATUS_DMA_BOUNDARY 0x00000004
-#define INT_STATUS_EOTRAN       0x00000002
-#define INT_STATUS_EOTPC        0x00000001
-
-#define INT_STATUS_ALL          0x000f801f
-
-#define PAD_OUTPUT_ENABLE_MS  0x0F3F
-
-#define PAD_PU_PD_OFF         0x7FFF0000
-#define PAD_PU_PD_ON_MS_SOCK0 0x5f8f0000
-#define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
-
-#define CLOCK_CONTROL_40MHZ   0x00000001
-#define CLOCK_CONTROL_50MHZ   0x0000000a
-#define CLOCK_CONTROL_60MHZ   0x00000008
-#define CLOCK_CONTROL_62_5MHZ 0x0000000c
-#define CLOCK_CONTROL_OFF     0x00000000
-
-#define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
-#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
-#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
-
-enum {
-	CMD_READY    = 0x01,
-	FIFO_READY   = 0x02,
-	REG_DATA     = 0x04,
-	DMA_DATA     = 0x08
-};
+static int debug;
 
 static unsigned int jmb38x_ms_read_data(struct jmb38x_ms_host *host,
 					unsigned char *buf, unsigned int length)
@@ -1012,5 +881,9 @@ MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, jmb38x_ms_id_tbl);
 
+module_param(no_dma, bool, S_IRUGO);
+module_param(debug, bool, S_IRUGO);
+
+
 module_init(jmb38x_ms_init);
 module_exit(jmb38x_ms_exit);
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
new file mode 100644
index 0000000..5bca4b3
--- /dev/null
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -0,0 +1,188 @@
+/*
+ *  jmb38x_ms.c - JMicron jmb38x MemoryStick card reader
+ *
+ *  Copyright (C) 2008 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define DRIVER_NAME "jmb38x_ms"
+
+/* physical address of a page for DMA */
+#define	DMA_ADDRESS            0x00
+
+/* controls the size of the TPC */
+#define	BLOCK                  0x04
+#define BLOCK_COUNT_MASK        0xffff0000
+#define BLOCK_COUNT_1BLOCK      0x00010000
+#define BLOCK_SIZE_MASK         0x00000fff
+
+/* Enables the DMA */
+#define	DMA_CONTROL            0x08
+#define DMA_CONTROL_ENABLE      0x00000001
+
+/* A window for small TPCs to send the contents inline */
+#define	TPC_P0                 0x0c
+#define	TPC_P1                 0x10
+
+/* TPC execution register */
+#define	TPC                    0x14
+#define TPC_DATA_SEL            0x00008000
+#define TPC_DIR                 0x00004000
+#define TPC_WAIT_INT            0x00002000
+#define TPC_GET_INT             0x00000800
+#define TPC_CODE_SZ_MASK        0x00000700
+#define TPC_DATA_SZ_MASK        0x00000007
+
+/* General device settings */
+#define	HOST_CONTROL           0x18
+#define HOST_CONTROL_TDELAY_EN  0x00040000
+#define HOST_CONTROL_HW_OC_P    0x00010000
+#define HOST_CONTROL_RESET_REQ  0x00008000
+#define HOST_CONTROL_REI        0x00004000
+#define HOST_CONTROL_LED        0x00000400
+#define HOST_CONTROL_FAST_CLK   0x00000200
+#define HOST_CONTROL_RESET      0x00000100
+#define HOST_CONTROL_POWER_EN   0x00000080
+#define HOST_CONTROL_CLOCK_EN   0x00000040
+#define HOST_CONTROL_REO        0x00000008
+#define HOST_CONTROL_BSY_TIME	0x00000007
+
+#define HOST_CONTROL_IF_SHIFT  4
+#define HOST_CONTROL_IF_SERIAL 0x0
+#define HOST_CONTROL_IF_PAR4   0x1
+#define HOST_CONTROL_IF_PAR8   0x3
+
+
+/* IO window for PIO access to internal FIFO*/
+#define	DATA                   0x1c
+
+/* MS status */
+#define	STATUS                 0x20
+#define STATUS_BUSY             0x00080000
+#define STATUS_MS_DAT7          0x00040000
+#define STATUS_MS_DAT6          0x00020000
+#define STATUS_MS_DAT5          0x00010000
+#define STATUS_MS_DAT4          0x00008000
+#define STATUS_MS_DAT3          0x00004000
+#define STATUS_MS_DAT2          0x00002000
+#define STATUS_MS_DAT1          0x00001000
+#define STATUS_MS_DAT0          0x00000800
+#define STATUS_HAS_MEDIA        0x00000400
+#define STATUS_FIFO_EMPTY       0x00000200
+#define STATUS_FIFO_FULL        0x00000100
+#define STATUS_MS_CED           0x00000080
+#define STATUS_MS_ERR           0x00000040
+#define STATUS_MS_BRQ           0x00000020
+#define STATUS_MS_CNK           0x00000001
+
+/* Device status */
+#define	INT_STATUS             0x24
+#define INT_STATUS_TPC_ERR      0x00080000
+#define INT_STATUS_CRC_ERR      0x00040000
+#define INT_STATUS_TIMER_TO     0x00020000
+#define INT_STATUS_HSK_TO       0x00010000
+#define INT_STATUS_ANY_ERR      0x00008000
+#define INT_STATUS_FIFO_WRDY    0x00000080
+#define INT_STATUS_FIFO_RRDY    0x00000040
+#define INT_STATUS_MEDIA_OUT    0x00000010
+#define INT_STATUS_MEDIA_IN     0x00000008
+#define INT_STATUS_DMA_BOUNDARY 0x00000004
+#define INT_STATUS_EOTRAN       0x00000002
+#define INT_STATUS_EOTPC        0x00000001
+#define INT_STATUS_ALL          0x000f801f
+
+/* Interrupt enable - ???*/
+#define	INT_STATUS_ENABLE      0x28
+
+/* Interrupt enable*/
+#define	INT_SIGNAL_ENABLE      0x2c
+
+/* Current timer value */
+#define	TIMER                  0x30
+
+/* Enable/disable the timer */
+#define	TIMER_CONTROL          0x34
+
+/* Output pad enable */
+#define	PAD_OUTPUT_ENABLE      0x38
+#define PAD_OUTPUT_ENABLE_MS    0x0F3F
+
+/* Ouput pad pull-up, pull-down control */
+#define	PAD_PU_PD              0x3c
+#define PAD_PU_PD_OFF           0x7fff0000
+#define PAD_PU_PD_ON_MS_SOCK0   0x5f8f0000
+#define PAD_PU_PD_ON_MS_SOCK1   0x0f0f0000
+
+/* Internal clock delay */
+#define	CLOCK_DELAY            0x40
+
+/* ??? */
+#define	ADMA_ADDRESS           0x44
+
+/* Set the device clock */
+#define	CLOCK_CONTROL          0x48
+#define CLOCK_CONTROL_RESET     0x00000008
+#define CLOCK_CONTROL_40MHZ     0x00000009
+#define CLOCK_CONTROL_50MHZ     0x0000000a
+#define CLOCK_CONTROL_62_5MHZ   0x0000000c
+#define CLOCK_CONTROL_OFF       0x00000000
+
+/* Led blink period */
+#define	LED_CONTROL            0x4c
+
+/* Hardware version */
+#define	VERSION                0x50
+
+#define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
+#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
+#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
+
+struct jmb38x_ms_host {
+	struct jmb38x_ms        *chip;
+	void __iomem            *addr;
+	spinlock_t              lock;
+	struct tasklet_struct   notify;
+	int                     id;
+	char                    host_id[32];
+	int                     irq;
+	unsigned int            block_pos;
+	unsigned long           timeout_jiffies;
+	struct timer_list       timer;
+	struct memstick_request *req;
+	unsigned char           cmd_flags;
+	unsigned char           io_pos;
+	unsigned int            io_word[2];
+};
+
+struct jmb38x_ms {
+	struct pci_dev        *pdev;
+	int                   host_cnt;
+	struct memstick_host  *hosts[];
+};
+
+enum {
+	CMD_READY    = 0x01,
+	FIFO_READY   = 0x02,
+	REG_DATA     = 0x04,
+	DMA_DATA     = 0x08
+};
+
+
+#define __dbg(host, level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG \
+				"%s: " format "\n", dev_name(&host->msh->dev) \
+					 , ## __VA_ARGS__); \
+		else \
+			dev_dbg(&host->msh->dev, format, ## __VA_ARGS__); \
+	} while (0)
+
+#define dbg(host, format, ...)		__dbg(host, 1, format, ## __VA_ARGS__)
+#define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
+#define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
-- 
1.7.1

