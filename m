Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2JBIf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:35:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35911 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2JBIf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:35:26 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmware loader: cancel uncache work before caching firmware
Date: Tue,  2 Oct 2012 16:35:10 +0800
Message-Id: <1349166910-15726-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under 'Opportunistic sleep' situation, system sleep might be
triggered very frequently, so the uncahce work may not be completed
before caching firmware during next suspend.

This patch cancels the uncache work before caching firmware to
fix the problem above.

Also this patch optimizes the cacheing firmware mechanism a bit by
only storing one firmware cache entry for one firmware image.

So if the firmware is still cached during suspend, it doesn't need
to be loaded from user space any more.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6e21080..ddc17bc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1068,17 +1068,27 @@ exit:
 	return fce;
 }
 
-static int fw_cache_piggyback_on_request(const char *name)
+static int __fw_entry_found(const char *name)
 {
 	struct firmware_cache *fwc = &fw_cache;
 	struct fw_cache_entry *fce;
-	int ret = 0;
 
-	spin_lock(&fwc->name_lock);
 	list_for_each_entry(fce, &fwc->fw_names, list) {
 		if (!strcmp(fce->name, name))
-			goto found;
+			return 1;
 	}
+	return 0;
+}
+
+static int fw_cache_piggyback_on_request(const char *name)
+{
+	struct firmware_cache *fwc = &fw_cache;
+	struct fw_cache_entry *fce;
+	int ret = 0;
+
+	spin_lock(&fwc->name_lock);
+	if (__fw_entry_found(name))
+		goto found;
 
 	fce = alloc_fw_cache_entry(name);
 	if (fce) {
@@ -1155,8 +1165,13 @@ static void dev_cache_fw_image(struct device *dev, void *data)
 		list_del(&fce->list);
 
 		spin_lock(&fwc->name_lock);
-		fwc->cnt++;
-		list_add(&fce->list, &fwc->fw_names);
+		/* only one cache entry for one firmware */
+		if (!__fw_entry_found(fce->name)) {
+			fwc->cnt++;
+			list_add(&fce->list, &fwc->fw_names);
+		} else {
+			free_fw_cache_entry(fce);
+		}
 		spin_unlock(&fwc->name_lock);
 
 		async_schedule(__async_dev_cache_fw_image, (void *)fce);
@@ -1201,6 +1216,9 @@ static void device_cache_fw_images(void)
 
 	pr_debug("%s\n", __func__);
 
+	/* cancel uncache work */
+	cancel_delayed_work_sync(&fwc->work);
+
 	/*
 	 * use small loading timeout for caching devices' firmware
 	 * because all these firmware images have been loaded
-- 
1.7.9.5

