Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab2BNGOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:14:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58048 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750990Ab2BNGOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:14:35 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+NvTdqsYWNMTBS9p1ocYYK9BE86wj9EiV7pW+QTz
	wXTh3t4ZXpEwMP
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: fix I2C emulation on GPIO ports
Date: Tue, 14 Feb 2012 06:35:02 +0000
Message-Id: <2c4c8a8a73b64a8ea86ad85d8a59a5914d2f81ea.1329200232.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329200232.git.FlorianSchandinat@gmx.de>
References: <cover.1329200232.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the I2C emulation on GPIO ports by enabling it
(software controlled) and disabling the output on a GPIO line before
reading it.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/via_i2c.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 78f1405..dd53058 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -51,7 +51,7 @@ static void via_i2c_setscl(void *data, int state)
 		val |= 0x01;
 		break;
 	case VIA_PORT_GPIO:
-		val |= 0x80;
+		val |= 0x82;
 		break;
 	default:
 		printk(KERN_ERR "viafb_i2c: specify wrong i2c type.\n");
@@ -67,6 +67,9 @@ static int via_i2c_getscl(void *data)
 	int ret = 0;
 
 	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	if (adap_data->type == VIA_PORT_GPIO)
+		via_write_reg_mask(adap_data->io_port, adap_data->ioport_index,
+			0, 0x80);
 	if (via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x08)
 		ret = 1;
 	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
@@ -80,6 +83,9 @@ static int via_i2c_getsda(void *data)
 	int ret = 0;
 
 	spin_lock_irqsave(&i2c_vdev->reg_lock, flags);
+	if (adap_data->type == VIA_PORT_GPIO)
+		via_write_reg_mask(adap_data->io_port, adap_data->ioport_index,
+			0, 0x40);
 	if (via_read_reg(adap_data->io_port, adap_data->ioport_index) & 0x04)
 		ret = 1;
 	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
@@ -103,7 +109,7 @@ static void via_i2c_setsda(void *data, int state)
 		val |= 0x01;
 		break;
 	case VIA_PORT_GPIO:
-		val |= 0x40;
+		val |= 0x42;
 		break;
 	default:
 		printk(KERN_ERR "viafb_i2c: specify wrong i2c type.\n");
-- 
1.7.9

