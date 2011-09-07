Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1IGGFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:05:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab1IGGFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789709"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 09/12 v2] stagign: mei: client init code cleanup
Date: Wed,  7 Sep 2011 09:03:15 +0300
Message-Id: <1315375398-29529-10-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

starting removing the dependency from the module parameters.
setting the default timeout on init so don't need to check if it is bigger
then zero.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/wd.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 68c177b..fd67952 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -72,32 +72,25 @@ bool mei_wd_host_init(struct mei_device *dev)
 
 	/* look for WD client and connect to it */
 	dev->wd_cl.state = MEI_FILE_DISCONNECTED;
-	dev->wd_timeout = watchdog_timeout;
-
-	if (dev->wd_timeout > 0) {
-		/* find ME WD client */
-		mei_find_me_client_update_filext(dev, &dev->wd_cl,
-					&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
-
-		dev_dbg(&dev->pdev->dev, "check wd_cl\n");
-		if (MEI_FILE_CONNECTING == dev->wd_cl.state) {
-			if (!mei_connect(dev, &dev->wd_cl)) {
-				dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
-				dev->wd_cl.state = MEI_FILE_DISCONNECTED;
-				dev->wd_cl.host_client_id = 0;
-				ret = false;
-				goto end;
-			} else {
-				dev->wd_cl.timer_count = CONNECT_TIMEOUT;
-			}
-		} else {
-			dev_dbg(&dev->pdev->dev, "Failed to find WD client\n");
+	dev->wd_timeout = AMT_WD_DEFAULT_TIMEOUT;
+
+	/* find ME WD client */
+	mei_find_me_client_update_filext(dev, &dev->wd_cl,
+				&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
+
+	dev_dbg(&dev->pdev->dev, "check wd_cl\n");
+	if (MEI_FILE_CONNECTING == dev->wd_cl.state) {
+		if (!mei_connect(dev, &dev->wd_cl)) {
+			dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
+			dev->wd_cl.state = MEI_FILE_DISCONNECTED;
+			dev->wd_cl.host_client_id = 0;
 			ret = false;
 			goto end;
+		} else {
+			dev->wd_cl.timer_count = CONNECT_TIMEOUT;
 		}
 	} else {
-		dev->wd_bypass = true;
-		dev_dbg(&dev->pdev->dev, "WD requested to be disabled\n");
+		dev_dbg(&dev->pdev->dev, "Failed to find WD client\n");
 		ret = false;
 		goto end;
 	}
-- 
1.7.4.1

