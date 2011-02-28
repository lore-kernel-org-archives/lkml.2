Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1B1Uwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:52:41 -0500
Received: from mxout1.idt.com ([157.165.5.25]:58638 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab1B1Uwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:52:31 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH 5/5] RapidIO: remove mport resource reservation from common RIO code
Date: Mon, 28 Feb 2011 15:51:05 -0500
Message-Id: <1298926265-5381-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
References: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes resource reservation from the common sybsystem initialization code
and make it part of mport driver initialization. This resolves conflict
with resource reservation by device specific mport drivers.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    9 +++++++++
 drivers/rapidio/rio.c         |   14 +-------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 7d35a12..f25ad15 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1432,6 +1432,14 @@ int fsl_rio_setup(struct platform_device *dev)
 	port->iores.flags = IORESOURCE_MEM;
 	port->iores.name = "rio_io_win";
 
+	if (request_resource(&iomem_resource, &port->iores) < 0) {
+		dev_err(&dev->dev, "RIO: Error requesting master port region"
+			" 0x%016llx-0x%016llx\n",
+			(u64)port->iores.start, (u64)port->iores.end);
+			rc = -ENOMEM;
+			goto err_res;
+	}
+
 	priv->pwirq   = irq_of_parse_and_map(dev->dev.of_node, 0);
 	priv->bellirq = irq_of_parse_and_map(dev->dev.of_node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->dev.of_node, 3);
@@ -1536,6 +1544,7 @@ int fsl_rio_setup(struct platform_device *dev)
 	return 0;
 err:
 	iounmap(priv->regs_win);
+err_res:
 	kfree(priv);
 err_priv:
 	kfree(port);
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 9a7b216..c29719c 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1137,20 +1137,9 @@ static int __devinit rio_init(void)
 
 int __devinit rio_init_mports(void)
 {
-	int rc = 0;
 	struct rio_mport *port;
 
 	list_for_each_entry(port, &rio_mports, node) {
-		if (!request_mem_region(port->iores.start,
-					resource_size(&port->iores),
-					port->name)) {
-			printk(KERN_ERR
-			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end);
-			rc = -ENOMEM;
-			goto out;
-		}
-
 		if (port->host_deviceid >= 0)
 			rio_enum_mport(port);
 		else
@@ -1159,8 +1148,7 @@ int __devinit rio_init_mports(void)
 
 	rio_init();
 
-      out:
-	return rc;
+	return 0;
 }
 
 device_initcall_sync(rio_init_mports);
-- 
1.7.3.1

