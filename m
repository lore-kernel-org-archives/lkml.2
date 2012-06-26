Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2FZMEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:04:11 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48601
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab2FZMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:04:08 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Rupesh Gujare <rgujare@ozmodevices.com>
Subject: [PATCH 1/3] staging: ozwpan: Unregister with sysfs while unloading.
Date: Tue, 26 Jun 2012 13:03:39 +0100
Message-ID: <1340712221-6750-2-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
References: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Destroy device node & unregister device class from sysfs while unloading
driver

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozcdev.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 929756a..d983219 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -42,6 +42,7 @@ struct oz_serial_ctx {
 /*------------------------------------------------------------------------------
  */
 static struct oz_cdev g_cdev;
+struct class *g_oz_class;
 /*------------------------------------------------------------------------------
  * Context: process and softirq
  */
@@ -330,7 +331,6 @@ const struct file_operations oz_fops = {
 int oz_cdev_register(void)
 {
 	int err;
-	struct class *cl;
 	struct device *dev;
 	memset(&g_cdev, 0, sizeof(g_cdev));
 	err = alloc_chrdev_region(&g_cdev.devnum, 0, 1, "ozwpan");
@@ -348,12 +348,12 @@ int oz_cdev_register(void)
 		oz_trace("Failed to add cdev\n");
 		goto out2;
 	}
-	cl = class_create(THIS_MODULE, "ozmo_wpan");
-	if (IS_ERR(cl)) {
+	g_oz_class = class_create(THIS_MODULE, "ozmo_wpan");
+	if (IS_ERR(g_oz_class)) {
 		oz_trace("Failed to register ozmo_wpan class\n");
 		goto out1;
 	}
-	dev = device_create(cl, NULL, g_cdev.devnum, NULL, "ozwpan");
+	dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL, "ozwpan");
 	if (IS_ERR(dev)) {
 		oz_trace("Failed to create sysfs entry for cdev\n");
 		goto out1;
@@ -373,6 +373,10 @@ int oz_cdev_deregister(void)
 {
 	cdev_del(&g_cdev.cdev);
 	unregister_chrdev_region(g_cdev.devnum, 1);
+	if (g_oz_class) {
+		device_destroy(g_oz_class, g_cdev.devnum);
+		class_destroy(g_oz_class);
+	}
 	return 0;
 }
 /*------------------------------------------------------------------------------
-- 
1.7.5.4


