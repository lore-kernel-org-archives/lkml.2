Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab0EMRuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:50:08 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32278 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab0EMRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:50:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 13 May 2010 19:50:32 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] usb: gadget: g_mass_storage: static data instead of dynamic
 allocation
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <e3abf3898ffa038852e8b3307d37927f886fb72c.1273772850.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes msg_do_config() function so that it uses
a static object for a fsg_common structure instead of dynamically
allocated.  This is a micro-optimisation.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/mass_storage.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index d574bad..d85ca27 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -143,7 +143,7 @@ static int msg_thread_exits(struct fsg_common *common)
 
 static int __init msg_do_config(struct usb_configuration *c)
 {
-	struct fsg_common *common;
+	static struct fsg_common common, *retp;
 	struct fsg_config config;
 	int ret;
 
@@ -156,12 +156,13 @@ static int __init msg_do_config(struct usb_configuration *c)
 	config.ops = &(const struct fsg_operations){
 		.thread_exits = msg_thread_exits,
 	};
-	common = fsg_common_init(0, c->cdev, &config);
-	if (IS_ERR(common))
-		return PTR_ERR(common);
 
-	ret = fsg_add(c->cdev, c, common);
-	fsg_common_put(common);
+	retp = fsg_common_init(&common, c->cdev, &config);
+	if (IS_ERR(retp))
+		return PTR_ERR(retp);
+
+	ret = fsg_add(c->cdev, c, &common);
+	fsg_common_put(&common);
 	return ret;
 }
 
-- 
1.7.1

