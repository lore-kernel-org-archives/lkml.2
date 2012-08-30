Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2H3QvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:51:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58608 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab2H3QvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:51:13 -0400
From: Bin Liu <b-liu@ti.com>
To: <mugunthanvnm@ti.com>, <vaibhav.bedia@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <b-liu@ti.com>
Subject: [PATCH] net: ethernet: fix kernel OOPS when remove davinci_mdio module
Date: Thu, 30 Aug 2012 11:37:32 -0500
Message-ID: <1346344652-28487-1-git-send-email-b-liu@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

davinci mdio device is not unregistered from mdiobus when removing
the module, which causes BUG_ON() when free the device from mdiobus.

Calling mdiobus_unregister() before mdiobus_free() fixes the issue.

Signed-off-by: Bin Liu <b-liu@ti.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 0c2fcdd..7de19a5 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -391,8 +391,10 @@ static int __devexit davinci_mdio_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct davinci_mdio_data *data = dev_get_drvdata(dev);
 
-	if (data->bus)
+	if (data->bus) {
+		mdiobus_unregister(data->bus);
 		mdiobus_free(data->bus);
+	}
 
 	if (data->clk)
 		clk_put(data->clk);
-- 
1.7.0.4

