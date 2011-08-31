Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1HaVPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:15:12 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:38058
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755592Ab1HaVPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:15:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/4] Staging: hv: util: Deal with driver register failures
Date: Wed, 31 Aug 2011 14:35:54 -0700
Message-Id: <1314826557-28755-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314826529-28716-1-git-send-email-kys@microsoft.com>
References: <1314826529-28716-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly deal with vmbus_driver_register() failures.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index e29a2a2..6039217 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -277,6 +277,7 @@ static  struct hv_driver util_drv = {
 
 static int __init init_hyperv_utils(void)
 {
+	int ret;
 	pr_info("Registering HyperV Utility Driver\n");
 
 	if (hv_kvp_init())
@@ -289,12 +290,15 @@ static int __init init_hyperv_utils(void)
 
 	if (!shut_txf_buf || !time_txf_buf || !hbeat_txf_buf) {
 		pr_info("Unable to allocate memory for receive buffer\n");
-		kfree(shut_txf_buf);
-		kfree(time_txf_buf);
-		kfree(hbeat_txf_buf);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
+	ret = vmbus_driver_register(&util_drv);
+
+	if (ret != 0)
+		goto err;
+
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
 
 	hv_cb_utils[HV_TIMESYNC_MSG].callback = &timesync_onchannelcallback;
@@ -303,7 +307,14 @@ static int __init init_hyperv_utils(void)
 
 	hv_cb_utils[HV_KVP_MSG].callback = &hv_kvp_onchannelcallback;
 
-	return vmbus_driver_register(&util_drv);
+	return 0;
+
+err:
+	kfree(shut_txf_buf);
+	kfree(time_txf_buf);
+	kfree(hbeat_txf_buf);
+
+	return ret;
 }
 
 static void exit_hyperv_utils(void)
-- 
1.7.4.1

