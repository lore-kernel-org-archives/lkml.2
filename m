Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1HaNoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:44:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab1HaNoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:44:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44294821"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 01/12] staging: mei: removing dependency between WD and AMTHI init function.
Date: Wed, 31 Aug 2011 16:42:37 +0300
Message-Id: <1314798168-15613-2-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMTHI need to be initialized after WD Client was initialized, moving the AMTHI outside
of the WD initialization function.
in order to remove the coupling between the initialization of those clients.

AMTHI is getting initialized (getting connected to the FW feature/client) in two ways:
 1) if mei driver fails to send connect message to watchdog client (WD initialization), then
    immediately the AMTHI client getting initialized right after the watchdog initialization function.
 2) if Watchdog client success to send connect message to watchdog client, then only after
    the driver is getting the connect response message the AMTHI client is getting initialized

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/init.c      |    8 +++++++-
 drivers/staging/mei/interface.h |    2 +-
 drivers/staging/mei/wd.c        |   16 ++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index 0fa8216..69a57e7 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -521,7 +521,13 @@ void mei_host_client_properties(struct mei_device *dev)
 	bitmap_set(dev->host_clients_map, 0, 3);
 	dev->mei_state = MEI_ENABLED;
 
-	mei_wd_host_init(dev);
+	/* if wd initialization fails, initialization the AMTHI client,
+	 * otherwise the AMTHI client will be initialized after the WD client connect response
+	 * will be received
+	 */
+	if (mei_wd_host_init(dev))
+		mei_host_init_iamthif(dev);
+
 	return;
 }
 
diff --git a/drivers/staging/mei/interface.h b/drivers/staging/mei/interface.h
index d0bf5cf..7bcf096 100644
--- a/drivers/staging/mei/interface.h
+++ b/drivers/staging/mei/interface.h
@@ -48,7 +48,7 @@ int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
 
 int mei_wd_send(struct mei_device *dev);
 int mei_wd_stop(struct mei_device *dev, bool preserve);
-void mei_wd_host_init(struct mei_device *dev);
+bool mei_wd_host_init(struct mei_device *dev);
 void mei_wd_start_setup(struct mei_device *dev);
 
 int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl);
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 42f04ef..721487d 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -63,8 +63,10 @@ void mei_wd_start_setup(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-void mei_wd_host_init(struct mei_device *dev)
+bool mei_wd_host_init(struct mei_device *dev)
 {
+	bool ret = false;
+
 	mei_cl_init(&dev->wd_cl, dev);
 
 	/* look for WD client and connect to it */
@@ -83,19 +85,25 @@ void mei_wd_host_init(struct mei_device *dev)
 				dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
 				dev->wd_cl.state = MEI_FILE_DISCONNECTED;
 				dev->wd_cl.host_client_id = 0;
-				mei_host_init_iamthif(dev) ;
+				ret = false;
+				goto end;
 			} else {
 				dev->wd_cl.timer_count = CONNECT_TIMEOUT;
 			}
 		} else {
 			dev_dbg(&dev->pdev->dev, "Failed to find WD client\n");
-			mei_host_init_iamthif(dev) ;
+			ret = false;
+			goto end;
 		}
 	} else {
 		dev->wd_bypass = true;
 		dev_dbg(&dev->pdev->dev, "WD requested to be disabled\n");
-		mei_host_init_iamthif(dev) ;
+		ret = false;
+		goto end;
 	}
+
+end:
+	return ret;
 }
 
 /**
-- 
1.7.4.1

