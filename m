Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0FKP05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:26:57 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:52467 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab0FKP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:26:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 01/13] ARM: define the PrimeCell DMA API v6
Date: Fri, 11 Jun 2010 17:26:29 +0200
Message-ID: <1276269989-1323-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the DMA engine with a PrimeCell runtime
reconfigure command to configure the DMA channel. This has been
identified as the basic extension needed to drive DMA on top of
the PL011, PL022 and PL180 PrimeCells.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/amba/dma.h  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    5 +++++
 2 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/amba/dma.h

diff --git a/include/linux/amba/dma.h b/include/linux/amba/dma.h
new file mode 100644
index 0000000..0a5825d
--- /dev/null
+++ b/include/linux/amba/dma.h
@@ -0,0 +1,44 @@
+/*
+ *  linux/include/amba/dma.h
+ *
+ *  Copyright (C) 2010 ST-Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#if !defined(AMBA_DMA_H) && defined(CONFIG_DMADEVICES)
+#define AMBA_DMA_H
+
+#include <linux/dma-mapping.h>
+
+/**
+ * struct amba_dma_channel_config - dmaengine config for PrimeCells
+ * @addr: this is the physical address where DMA data should be
+ * read (RX) or written (TX)
+ * @addr_width: this is the width of the source (RX) or target
+ * (TX) register where DMA data shall be read/written, in bytes.
+ * legal values: 1, 2, 4, 8.
+ * @direction: whether the data goes in or out on this channel,
+ * right now.
+ * @maxburst: the maximum number of words (note: words, not bytes)
+ * that can be sent in one burst to the device. Typically something
+ * like half the FIFO depth on I/O peripherals so you don't
+ * overflow it.
+ *
+ * This struct is passed in as configuration data to a DMA engine
+ * in order to set up a certain channel for PrimeCell DMA transport.
+ * Anything the DMA engine needs to know about the PrimeCell shall
+ * be passed through this struct. The DMA engine has to provide an
+ * additional command in the channel config interface, DMA_CONFIG_AMBA
+ * and this struct will then be passed in as an argument to the
+ * DMA engine device_control() function.
+ */
+struct amba_dma_channel_config {
+	dma_addr_t addr;
+	u8 addr_width:4;
+	enum dma_data_direction direction;
+	int maxburst;
+};
+
+#endif /* AMBA_DMA_H */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..c309f3e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -114,11 +114,16 @@ enum dma_ctrl_flags {
  * @DMA_TERMINATE_ALL: terminate all ongoing transfers
  * @DMA_PAUSE: pause ongoing transfers
  * @DMA_RESUME: resume paused transfer
+ * @DMA_CONFIG_AMBA: this command is only implemented by DMA controllers
+ * that need to runtime reconfigure the channel for use with ARM
+ * PrimeCell slaves. An additional argument must be passed in with this
+ * command. (See further <linux/amba/dma.h>)
  */
 enum dma_ctrl_cmd {
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
+	DMA_CONFIG_AMBA,
 };
 
 /**
-- 
1.6.3.3

