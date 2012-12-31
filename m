Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2LaLLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:11:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55518 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2LaLJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:43 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 07/10] mfd: twl-core: Move 'inuse' check early at probe time
Date: Mon, 31 Dec 2012 12:09:28 +0100
Message-ID: <1356952171-6109-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can fail earlier in case multiple instance of the twl-core is tried to
be loaded.
The twl-core by design only supports one instance.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 547fed5..1827088 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1170,6 +1170,12 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -EINVAL;
 	}
 
+	if (inuse) {
+		dev_dbg(&client->dev, "only one instance of %s allowed\n",
+			DRIVER_NAME);
+		return -EBUSY;
+	}
+
 	pdev = platform_device_alloc(DRIVER_NAME, -1);
 	if (!pdev) {
 		dev_err(&client->dev, "can't alloc pdev\n");
@@ -1188,12 +1194,6 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto free;
 	}
 
-	if (inuse) {
-		dev_dbg(&client->dev, "driver is already in use\n");
-		status = -EBUSY;
-		goto free;
-	}
-
 	if ((id->driver_data) & TWL6030_CLASS) {
 		twl_id = TWL6030_CLASS_ID;
 		twl_map = &twl6030_map[0];
-- 
1.8.0.2

