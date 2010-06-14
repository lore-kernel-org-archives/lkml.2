Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0FNInt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:43:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34432 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab0FNImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:42:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 14 Jun 2010 10:43:35 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4.1 01/13] USB: gadget: g_mass_storage: static data instead of
 dynamic allocation
In-reply-to: <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <50e2dbde2dcb321c5db43566a292bb334018da21.1276503768.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes msg_do_config() function so that it uses
a static object for a fsg_common structure instead of dynamically
allocated.  This is a micro-optimisation.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Compared to previous patch fixed retp needlessly having static
instead of automatic storage.

 drivers/usb/gadget/mass_storage.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 705cc1f..e68c00e 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -143,7 +143,9 @@ static int msg_thread_exits(struct fsg_common *common)
 
 static int __init msg_do_config(struct usb_configuration *c)
 {
-	struct fsg_common *common;
+	static struct fsg_common common;
+
+	struct fsg_common *retp;
 	struct fsg_config config;
 	int ret;
 
@@ -154,12 +156,13 @@ static int __init msg_do_config(struct usb_configuration *c)
 
 	fsg_config_from_params(&config, &mod_data);
 	config.thread_exits = msg_thread_exits;
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

