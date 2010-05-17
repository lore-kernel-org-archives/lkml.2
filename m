Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0EQJsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:48:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31852 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab0EQJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:47:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 17 May 2010 11:48:26 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: g_mass_storage: static data instead of dynamic
 allocation
In-reply-to: <e3abf3898ffa038852e8b3307d37927f886fb72c.1273772850.git.mina86@mina86.com>
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <6fef14ee3d854a995817fe6fde39f14b1d853905.1274088911.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
References: <e3abf3898ffa038852e8b3307d37927f886fb72c.1273772850.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This patch changes msg_do_config() function so that it uses
a static object for a fsg_common structure instead of dynamically
allocated.  This is a micro-optimisation.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
Greg KH wrote:
> This patch doesn't apply.  Care to redo it against the linux-next tree?

Hope this works.

 drivers/usb/gadget/mass_storage.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 705cc1f..a3349f2 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -143,7 +143,7 @@ static int msg_thread_exits(struct fsg_common *common)
 
 static int __init msg_do_config(struct usb_configuration *c)
 {
-	struct fsg_common *common;
+	static struct fsg_common common, *retp;
 	struct fsg_config config;
 	int ret;
 
@@ -154,12 +154,13 @@ static int __init msg_do_config(struct usb_configuration *c)
 
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

