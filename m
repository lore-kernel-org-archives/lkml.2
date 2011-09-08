Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1IHODS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:03:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40501
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933071Ab1IHODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 09/25] Staging: hv: util: Perform some service specific de-initialization in util_remove()
Date: Thu,  8 Sep 2011 07:24:20 -0700
Message-Id: <1315491876-9554-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for modifying the util driver to fully conform to the
Linux Driver Model, perform some service specific de-initialization in
util_remove() as opposed to in exit_hyperv_utils() as is currently done.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index b86128a..2475ab2 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -291,6 +291,30 @@ error:
 static int util_remove(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
+	int service = dev_id->driver_data;
+
+	switch (service) {
+	case HV_SHUTDOWN:
+		kfree(shut_txf_buf);
+		break;
+
+	case HV_TIMESYNC:
+		kfree(time_txf_buf);
+		break;
+
+	case HV_HEARTBEAT:
+		kfree(hbeat_txf_buf);
+		break;
+
+	case HV_KVP:
+		hv_kvp_deinit();
+		break;
+
+	default:
+		pr_err("unknown util service\n");
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
@@ -370,11 +394,6 @@ static void exit_hyperv_utils(void)
 			&chn_cb_negotiate;
 	hv_cb_utils[HV_KVP_MSG].callback = NULL;
 
-	hv_kvp_deinit();
-
-	kfree(shut_txf_buf);
-	kfree(time_txf_buf);
-	kfree(hbeat_txf_buf);
 	vmbus_driver_unregister(&util_drv);
 }
 
-- 
1.7.4.1

