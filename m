Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2JWMzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:55:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770Ab2JWMyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:54:45 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3 v2] firmware: Factor out code to add paths to the firmware path list
Date: Tue, 23 Oct 2012 13:52:56 +0100
Message-Id: <1350996776-17864-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/firmware_class.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 322fff3..cf4aa5f 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1426,6 +1426,22 @@ static int fw_cache_piggyback_on_request(const char *name)
 }
 #endif
 
+static int fw_add_path_to_list(const char *path)
+{
+	struct fw_path_rec *fwp;
+
+	fwp = kmalloc(sizeof(*fwp), GFP_KERNEL);
+	if (!fwp)
+		return -ENOMEM;
+	fwp->name = kstrdup(path, GFP_KERNEL);
+	if (!fwp->name) {
+		kfree(fwp);
+		return -ENOMEM;
+	}
+	list_add_tail(&fwp->list, &fw_path_list);
+	return 0;
+}
+
 static void fw_free_path_list(void)
 {
 	struct fw_path_rec *fwp;
@@ -1443,7 +1459,7 @@ static void fw_free_path_list(void)
 static int fw_populate_path_list(void)
 {
 	int i;
-	struct fw_path_rec *fwp;
+	int ret;
 	static const char *fw_path[] = {
 		"/lib/firmware/updates/" UTS_RELEASE,
 		"/lib/firmware/updates",
@@ -1452,22 +1468,14 @@ static int fw_populate_path_list(void)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
-		fwp = kmalloc(sizeof(*fwp), GFP_KERNEL);
-		if (!fwp)
-			goto err_fwp_alloc;
-		fwp->name = kstrdup(fw_path[i], GFP_KERNEL);
-		if (!fwp->name)
-			goto err_fwp_name_alloc;
-		list_add_tail(&fwp->list, &fw_path_list);
+		ret = fw_add_path_to_list(fw_path[i]);
+		if (ret < 0) {
+			fw_free_path_list();
+			return ret;
+		}
 	}
 
 	return 0;
-
-err_fwp_name_alloc:
-	kfree(fwp);
-err_fwp_alloc:
-	fw_free_path_list();
-	return -ENOMEM;
 }
 
 static void *fw_path_seq_start(struct seq_file *seq, loff_t *pos)
-- 
1.8.0

