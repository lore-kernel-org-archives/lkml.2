Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2AaMEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:04:01 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:39237 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab2AaMD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:03:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] usb: dwc3: debugfs: fix error check
Date: Tue, 31 Jan 2012 14:03:51 +0200
Message-Id: <1328011431-25610-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.9
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs APIs will return two different error
values depending on the situation:

 -> if debugfs isn't enabled in the kernel:
	it will return -ENODEV

 -> if debugfs is enabled in the kernel:
	it will return NULL

This means that blindly using IS_ERR() isn't
enough and, in fact, will not work on a real
error condition.

While we could be checking for a NULL pointer
only because we only compile and link debugfs.o
when CONFIG_DEBUG_FS is enabled, we decided
to play it safe should any of the debugfs rules
change over time.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

this falls into the "has never worked before" case
and will be sent to mainline on v3.4 merge window.

The failure is very marginal anyway. There are a bunch
of other files in the kernel which need a similar
fix:

arch/arm/mach
arch/arm/plat
arch/avr32/kernel/ocd.c
arch/mips/jz4740/clock
arch/s390/hypfs/hypfs_dbfs.c
drivers/block/pktcdvd.c
drivers/hwmon/asus_atk0110.c
drivers/misc/ti
drivers/mmc/core/debugfs.c
drivers/mmc/host/s3cmci.c
drivers/mtd/mtdswap.c
drivers/net/caif/caif_serial.c
drivers/net/ethernet/marvell/skge.c
drivers/net/ethernet/marvell/sky2.c
drivers/net/wireless/b43/debugfs.c
drivers/net/wireless/b43legacy/debugfs.c
drivers/net/wireless/rt2x00/rt2x00debug.c
drivers/net/wireless/wl12xx/debugfs.c
drivers/pinctrl/core.c
drivers/regulator/core.c
drivers/s390/block/dasd.c
drivers/staging/ft1000/ft1000
drivers/staging/slicoss/slicoss.c
drivers/usb/gadget/atmel_usba_udc.c
drivers/usb/gadget/pxa27x_udc.c
drivers/usb/gadget/s3c2410_udc.c
drivers/usb/mon/mon_text.c
drivers/usb/musb/musb_debugfs.c
drivers/video/omap2/dss/core.c
net/caif/caif_socket.c
net/l2tp/l2tp_debugfs.c
sound/soc/soc

Anyone interested, please take a pick ;-)

 drivers/usb/dwc3/debugfs.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index b99ee12..545c035 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -669,8 +669,8 @@ int __devinit dwc3_debugfs_init(struct dwc3 *dwc)
 	int			ret;
 
 	root = debugfs_create_dir(dev_name(dwc->dev), NULL);
-	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
+	if (IS_ERR_OR_NULL(root)) {
+		ret = -ENOMEM;
 		goto err0;
 	}
 
@@ -678,29 +678,29 @@ int __devinit dwc3_debugfs_init(struct dwc3 *dwc)
 
 	file = debugfs_create_file("regdump", S_IRUGO, root, dwc,
 			&dwc3_regdump_fops);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	if (IS_ERR_OR_NULL(file)) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
 	file = debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
 			dwc, &dwc3_mode_fops);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	if (IS_ERR_OR_NULL(file)) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
 	file = debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
 			dwc, &dwc3_testmode_fops);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	if (IS_ERR_OR_NULL(file)) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
 	file = debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
 			dwc, &dwc3_link_state_fops);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	if (IS_ERR_OR_NULL(file)) {
+		ret = -ENOMEM;
 		goto err1;
 	}
 
-- 
1.7.9

