Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1BBLbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:31:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BBLbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:31:22 -0500
From: Bernhard Walle <walle@corscience.de>
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Wed,  2 Feb 2011 12:30:40 +0100
Message-Id: <1296646240-31778-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:tdJ91RpVN4S/Hhp7s5FWnrNGSspcUga/pDjJNdsYyRS
 +Cgw4TGW7nvQlkuLg6azhr3tuZoGBNIR12a5C2WOa2b1jm0lye
 TUIFfAFlCezpE2obRr0iqWFV6DF0oKxuD1dO/vD6wxq+pGqthv
 SREMB7Si7Zt9AxggXC02vSXT9aaFvu7sRNT2jxdGAqv1Gjs8Io
 NfOuWi6UfKOqEX2OHw+PQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the compat_ioctl for operations on /dev/spi* so that 32 bit
userspace applications can access SPI. As far as I can see all data
structure are already prepared for that, so no additional conversion has
to be done.

My use case is MIPS with N32 userspace ABI and toolchain, and that was
also the platform where I tested it successfully (Cavium Octeon).

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/spi/spidev.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 4e6245e..95c3f10 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -471,6 +471,14 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+static long
+spidev_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif /* CONFIG_COMPAT */
+
 static int spidev_open(struct inode *inode, struct file *filp)
 {
 	struct spidev_data	*spidev;
@@ -543,6 +551,9 @@ static const struct file_operations spidev_fops = {
 	.write =	spidev_write,
 	.read =		spidev_read,
 	.unlocked_ioctl = spidev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = spidev_compat_ioctl,
+#endif
 	.open =		spidev_open,
 	.release =	spidev_release,
 	.llseek =	no_llseek,
-- 
1.7.1

