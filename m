Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2IJIyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:54:49 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24804 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2IJIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoFZI7gSGPFoESA5VdkwU
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262490"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new callbacks to tpci200
Date: Mon, 10 Sep 2012 10:51:41 +0200
Message-Id: <1347267118-9580-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Provide get_clockrate, set_clockrate, get_error, get_timeout and reset_timeout
callbacks.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  107 +++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 4383953..861b00d 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -14,6 +14,20 @@
 #include <linux/module.h>
 #include "tpci200.h"
 
+static u16 tpci200_status_timeout[] = {
+	TPCI200_A_TIMEOUT,
+	TPCI200_B_TIMEOUT,
+	TPCI200_C_TIMEOUT,
+	TPCI200_D_TIMEOUT,
+};
+
+static u16 tpci200_status_error[] = {
+	TPCI200_A_ERROR,
+	TPCI200_B_ERROR,
+	TPCI200_C_ERROR,
+	TPCI200_D_ERROR,
+};
+
 static struct ipack_bus_ops tpci200_bus_ops;
 
 static int tpci200_slot_unregister(struct ipack_device *dev);
@@ -507,6 +521,94 @@ out_unlock:
 	return res;
 }
 
+static int tpci200_get_clockrate(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->control[dev->slot];
+	return (ioread16(addr) & TPCI200_CLK32) ? 32 : 8;
+}
+
+static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 reg;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->control[dev->slot];
+
+	/* Ensure the control register is not changed by another task after we
+	 * have read it. */
+	mutex_lock(&tpci200->mutex);
+	reg = ioread16(addr);
+	switch (mherz) {
+	case 8:
+		reg &= ~(TPCI200_CLK32); break;
+	case 32:
+		reg |= TPCI200_CLK32; break;
+	default:
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
+	}
+	iowrite16(reg, addr);
+	mutex_unlock(&tpci200->mutex);
+	return 0;
+}
+
+static int tpci200_get_error(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_error[dev->slot];
+	return (ioread16(addr) & mask) ? 1 : 0;
+}
+
+static int tpci200_get_timeout(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_timeout[dev->slot];
+
+	return (ioread16(addr) & mask) ? 1 : 0;
+}
+
+static int tpci200_reset_timeout(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_timeout[dev->slot];
+
+	iowrite16(mask, addr);
+	return 0;
+}
+
+
+
 static void tpci200_uninstall(struct tpci200_board *tpci200)
 {
 	int i;
@@ -524,6 +626,11 @@ static struct ipack_bus_ops tpci200_bus_ops = {
 	.request_irq = tpci200_request_irq,
 	.free_irq = tpci200_free_irq,
 	.remove_device = tpci200_slot_unregister,
+	.get_clockrate = tpci200_get_clockrate,
+	.set_clockrate = tpci200_set_clockrate,
+	.get_error     = tpci200_get_error,
+	.get_timeout   = tpci200_get_timeout,
+	.reset_timeout = tpci200_reset_timeout,
 };
 
 static int tpci200_install(struct tpci200_board *tpci200)
-- 
1.7.10.4

