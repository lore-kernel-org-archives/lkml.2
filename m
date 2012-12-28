Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2L1UlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:41:08 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51482 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2L1UlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:41:05 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 28 Dec 2012 14:41:04 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Steven Rostedt <rostedt@goodmis.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: (sb105x) Fix compile error seen if PARPORT_PC is undefined
Date: Fri, 28 Dec 2012 12:41:11 -0800
Message-Id: <1356727271-21633-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
ERROR: "parport_pc_probe_port" [drivers/staging/sb105x/sb105x.ko] undefined!

by making the code calling it conditional. Also remove the external reference to
parport_pc_probe_port() from the sb105x source file, as it doesn't belong there.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/sb105x/sb_pci_mp.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index edb2a85..b7ded88 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -1,12 +1,7 @@
 #include "sb_pci_mp.h"
 #include <linux/module.h>
 #include <linux/parport.h>
-
-extern struct parport *parport_pc_probe_port(unsigned long base_lo,
-		unsigned long base_hi,
-		int irq, int dma,
-		struct device *dev,
-		int irqflags);
+#include <linux/parport_pc.h>
 
 static struct mp_device_t mp_devs[MAX_MP_DEV];
 static int mp_nrpcibrds = sizeof(mp_pciboards)/sizeof(mppcibrd_t);
@@ -3066,12 +3061,16 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 				pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
 			}
 
+#if IS_ENABLED(CONFIG_PARPORT_PC)
 			/* add PC compatible parallel port */
 			parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
+#endif
 			break;
 		case PCI_DEVICE_ID_MP1P :
+#if IS_ENABLED(CONFIG_PARPORT_PC)
 			/* add PC compatible parallel port */
 			parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
+#endif
 			break;
 	}
 
-- 
1.7.9.7

