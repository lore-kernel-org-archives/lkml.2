Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2KRNNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2KRNNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943291"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/7] mei: simplify write complete loop in irq handler
Date: Sun, 18 Nov 2012 15:13:19 +0200
Message-Id: <1353244400-9619-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extract the common, hence non conditional code
from the if-else statment

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index cccb63a..e5aa0ed 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1027,34 +1027,21 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 		cl = pos->cl;
 		if (cl == NULL)
 			continue;
+		if (mei_flow_ctrl_creds(dev, cl) <= 0) {
+			dev_dbg(&dev->pdev->dev,
+				"No flow control credentials for client %d, not sending.\n",
+				cl->host_client_id);
+			continue;
+		}
 
-		if (cl != &dev->iamthif_cl) {
-			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
-				dev_dbg(&dev->pdev->dev,
-					"No flow control credentials for client %d, not sending.\n",
-					cl->host_client_id);
-				continue;
-			}
-			ret = mei_irq_thread_write_complete(dev, &slots, pos,
-						cmpl_list);
-			if (ret)
-				return ret;
-
-		} else if (cl == &dev->iamthif_cl) {
-			/* IAMTHIF IOCTL */
-			dev_dbg(&dev->pdev->dev, "complete amthi write cb.\n");
-			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
-				dev_dbg(&dev->pdev->dev,
-					"No flow control credentials for amthi client %d.\n",
-					cl->host_client_id);
-				continue;
-			}
+		if (cl == &dev->iamthif_cl)
 			ret = mei_amthif_irq_write_complete(dev, &slots,
 							pos, cmpl_list);
-			if (ret)
-				return ret;
-
-		}
+		else
+			ret = mei_irq_thread_write_complete(dev, &slots, pos,
+						cmpl_list);
+		if (ret)
+			return ret;
 
 	}
 	return 0;
-- 
1.7.4.4

