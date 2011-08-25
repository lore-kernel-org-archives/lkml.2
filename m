Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1HYQhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:37:45 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48434
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753472Ab1HYQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 06/59] Staging: hv: blkvsc: Use the newly introduced vmbus ID in the blockvsc driver
Date: Thu, 25 Aug 2011 09:48:32 -0700
Message-Id: <1314290965-2698-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in the blockvsc driver. Also, do
the associated cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 018b293..9b99387 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -111,14 +111,6 @@ struct block_device_context {
 
 static const char *drv_name = "blkvsc";
 
-/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
-static const uuid_le dev_type = {
-	.b = {
-		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
-	}
-};
-
 /*
  * There is a circular dependency involving blkvsc_request_completion()
  * and blkvsc_do_request().
@@ -802,10 +794,24 @@ static void blkvsc_request(struct request_queue *queue)
 	}
 }
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* IDE guid */
+		.guid = {
+			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
+			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
+		}
+	},
+	{
+		.guid = { }
+	},
+};
 
+MODULE_DEVICE_TABLE(vmbus, id_table);
 
 /* The one and only one */
 static  struct hv_driver blkvsc_drv = {
+	.id_table = id_table,
 	.probe =  blkvsc_probe,
 	.remove =  blkvsc_remove,
 	.shutdown = blkvsc_shutdown,
@@ -829,7 +835,6 @@ static int blkvsc_drv_init(void)
 
 	BUILD_BUG_ON(sizeof(sector_t) != 8);
 
-	memcpy(&drv->dev_type, &dev_type, sizeof(uuid_le));
 	drv->driver.name = drv_name;
 
 	/* The driver belongs to vmbus */
-- 
1.7.4.1

