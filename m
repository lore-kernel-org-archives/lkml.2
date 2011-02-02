Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1BBK41 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 2 Feb 2011 05:56:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1BBK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:56:26 -0500
From: y@vger.kernel.org
To: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        Bernhard Walle <walle@corscience.de>
Subject: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Wed,  2 Feb 2011 11:56:16 +0100
Message-Id: <1296644176-23891-1-git-send-email-y>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:HvBhlqDbzNoSSj3ObsIoQQqvu5yum/FKJA8ez0Z14yK
 pxfDv15kVmYpasm3fgmiT0dSC2ItmxPIR19Lg5SK6YR0wDcxee
 CNXfwMiNxnMDWn7Ia4HMeG76HPzYCgnyStrgHXABt/2z5EH9E6
 jxaeZFgmeRLZO4sECmLh9QKqYasQDkQ6489wBKrm+872zpsx2T
 uHohXjeAsxHpkK5m7Ip4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Walle <walle@corscience.de>

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

