Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1GOSDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:03:21 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59886
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751216Ab1GOSDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:03:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 010/117] Staging: hv: util: Make hv_utils a vmbus device driver
Date: Fri, 15 Jul 2011 10:45:58 -0700
Message-Id: <1310752065-27895-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hv_utils a vmbus device driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index c164b54..e72bfe0 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -36,6 +36,8 @@ static u8 *shut_txf_buf;
 static u8 *time_txf_buf;
 static u8 *hbeat_txf_buf;
 
+static const char *driver_name = "hv_util";
+
 static void shutdown_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
@@ -210,6 +212,27 @@ static void heartbeat_onchannelcallback(void *context)
 	}
 }
 
+/*
+ * The devices managed by the util driver don't need any additional
+ * setup.
+ */
+static int util_probe(struct hv_device *dev)
+{
+	return 0;
+}
+
+static int util_remove(struct hv_device *dev)
+{
+	return 0;
+}
+
+
+/* The one and only one */
+static  struct hv_driver util_drv = {
+	.probe =  util_probe,
+	.remove =  util_remove,
+};
+
 static const struct pci_device_id __initconst
 hv_utils_pci_table[] __maybe_unused = {
 	{ PCI_DEVICE(0x1414, 0x5353) }, /* Hyper-V emulated VGA controller */
@@ -264,7 +287,9 @@ static int __init init_hyperv_utils(void)
 
 	hv_cb_utils[HV_KVP_MSG].callback = &hv_kvp_onchannelcallback;
 
-	return 0;
+	util_drv.driver.name = driver_name;
+
+	return vmbus_child_driver_register(&util_drv.driver);
 }
 
 static void exit_hyperv_utils(void)
@@ -296,6 +321,7 @@ static void exit_hyperv_utils(void)
 	kfree(shut_txf_buf);
 	kfree(time_txf_buf);
 	kfree(hbeat_txf_buf);
+	vmbus_child_driver_unregister(&util_drv.driver);
 }
 
 module_init(init_hyperv_utils);
-- 
1.7.4.1

