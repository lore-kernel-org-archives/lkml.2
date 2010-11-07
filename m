Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0KGNZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 08:25:04 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:62587 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0KGNZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 08:25:02 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 08:25:02 EST
Date: Sun, 7 Nov 2010 13:18:25 +0000
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        jesse.barnes@intel.com
Subject: [PATCH] Fix Winbond CIR driver initialisation
Message-ID: <20101107131825.GA40383@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting a vanilla kernel results in:

[    4.771256] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.771365] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.771452] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    4.771674] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

Which prevents the winbond-cir driver from initialising since ttyS1 is 
a bastardised serial port, which can only be used for IR using the 
winbond-cir driver.

[   13.947470] Winbond CIR 00:03: Region 0x2f8-0x2ff already in use!
[   13.947741] Winbond CIR 00:03: disabled
[   13.947746] Winbond CIR: probe of 00:03 failed with error -16

A workaround is to boot with argument 8250.nr_uarts=1. This is not really 
desirable, so this patch makes ttyS1 go away.

This is tested on an Intel DG45ID motherboard with the real serial port 
enabled and disabled in the BIOS.

Signed-off-by: Sean Young <sean@mess.org>
---
diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 64f1de7..3da8b49 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -57,6 +57,7 @@
 #include <linux/bitrev.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/serial_8250.h>
 
 #define DRVNAME "winbond-cir"
 
@@ -1392,10 +1393,22 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
-		err = -EBUSY;
-		goto exit_release_ebase;
+		bool ok = false;
+#ifdef CONFIG_SERIAL_8250
+		/*
+		 * This device is a hacked serial port which will be
+		 * detected by the serial 8250 driver.
+		 */
+		dev_info(device, "Unregistering phony serial port ttyS1\n");
+		serial8250_unregister_port(1);
+		ok = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
+#endif
+		if (!ok) {
+			dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+				data->sbase, data->sbase + SP_IOMEM_LEN - 1);
+			err = -EBUSY;
+			goto exit_release_ebase;
+		}
 	}
 
 	err = request_irq(data->irq, wbcir_irq_handler,
