Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1BCIhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:37:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1BCIhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:37:37 -0500
From: Bernhard Walle <walle@corscience.de>
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Thu,  3 Feb 2011 09:37:18 +0100
Message-Id: <1296722238-4308-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:EqwpQNPDfZKPFrkzN3KkmFECqy6unjAhBYeXD9yUdtC
 6JeTOzXJ0zi67qHCoVE/TRJ1J2bKRCyMibCnQFXAQIRVw4pgeF
 vwfhhLFMSbPVQ327jLA+g9bpp/OMgN/8ZxG7iOqvQJ6l+rw9oY
 7UjAM9CqMKFWS+L8NTTjUyGj/LL1OV1v2NOIB6mJhRYOesPkJA
 q7YIOXbXBEMwMieI1mvNQ==
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
 drivers/spi/spidev.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 4e6245e..833e238 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -30,6 +30,7 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/compat.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -471,6 +472,16 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+static long
+spidev_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#else
+#define spidev_compat_ioctl NULL
+#endif /* CONFIG_COMPAT */
+
 static int spidev_open(struct inode *inode, struct file *filp)
 {
 	struct spidev_data	*spidev;
@@ -543,6 +554,7 @@ static const struct file_operations spidev_fops = {
 	.write =	spidev_write,
 	.read =		spidev_read,
 	.unlocked_ioctl = spidev_ioctl,
+	.compat_ioctl = spidev_compat_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
 	.llseek =	no_llseek,
-- 
1.7.1

