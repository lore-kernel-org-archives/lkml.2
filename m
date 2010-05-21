Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab0EURAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:00:20 -0400
Received: from kroah.org ([198.145.64.141]:39115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243Ab0EUQyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/38] firmware loader: do not allocate firmare id separately
Date: Fri, 21 May 2010 09:53:45 -0700
Message-Id: <1274460848-11377-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

fw_id has the same life time as firmware_priv so it makes sense to move
it into firmware_priv structure instead of allocating separately.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c378a35..d98e424 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -86,7 +86,6 @@ static int loading_timeout = 60;	/* In seconds */
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char *fw_id;
 	struct completion completion;
 	struct bin_attribute attr_data;
 	struct firmware *fw;
@@ -94,9 +93,9 @@ struct firmware_priv {
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
-	const char *vdata;
 	struct timer_list timeout;
 	bool nowait;
+	char fw_id[];
 };
 
 static void
@@ -153,7 +152,6 @@ static void fw_dev_release(struct device *dev)
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kfree(fw_priv->pages);
-	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	kfree(dev);
 
@@ -437,8 +435,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 			      struct device *device)
 {
 	int retval;
-	struct firmware_priv *fw_priv = kzalloc(sizeof(*fw_priv),
-						GFP_KERNEL);
+	struct firmware_priv *fw_priv =
+		kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
 	struct device *f_dev = kzalloc(sizeof(*f_dev), GFP_KERNEL);
 
 	*dev_p = NULL;
@@ -449,16 +447,9 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 		goto error_kfree;
 	}
 
+	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
 	fw_priv->attr_data = firmware_attr_data_tmpl;
-	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
-	if (!fw_priv->fw_id) {
-		dev_err(device, "%s: Firmware name allocation failed\n",
-			__func__);
-		retval = -ENOMEM;
-		goto error_kfree;
-	}
-
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
-- 
1.7.0.3

