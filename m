Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab2JIEBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:01:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2JIEBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:01:36 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/4] firmware loader: fix one reqeust_firmware race
Date: Tue,  9 Oct 2012 12:01:02 +0800
Message-Id: <1349755264-23876-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
References: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several loading requests may be pending on one same
firmware buf, and this patch moves fw_map_pages_buf()
before complete_all(&fw_buf->completion) and let all
requests see the mapped 'buf->data' once the loading
is completed.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d06a8d0..f288251 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -423,6 +423,18 @@ static void firmware_free_data(const struct firmware *fw)
 #ifndef PAGE_KERNEL_RO
 #define PAGE_KERNEL_RO PAGE_KERNEL
 #endif
+
+/* one pages buffer should be mapped/unmapped only once */
+static int fw_map_pages_buf(struct firmware_buf *buf)
+{
+	if (buf->data)
+		vunmap(buf->data);
+	buf->data = vmap(buf->pages, buf->nr_pages, 0, PAGE_KERNEL_RO);
+	if (!buf->data)
+		return -ENOMEM;
+	return 0;
+}
+
 /**
  * firmware_loading_store - set value in the 'loading' control file
  * @dev: device pointer
@@ -467,6 +479,14 @@ static ssize_t firmware_loading_store(struct device *dev,
 		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
 			set_bit(FW_STATUS_DONE, &fw_buf->status);
 			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
+
+			/*
+			 * Several loading requests may be pending on
+			 * one same firmware buf, so let all requests
+			 * see the mapped 'buf->data' once the loading
+			 * is completed.
+			 * */
+			fw_map_pages_buf(fw_buf);
 			complete_all(&fw_buf->completion);
 			break;
 		}
@@ -670,15 +690,6 @@ exit:
 	return fw_priv;
 }
 
-/* one pages buffer is mapped/unmapped only once */
-static int fw_map_pages_buf(struct firmware_buf *buf)
-{
-	buf->data = vmap(buf->pages, buf->nr_pages, 0, PAGE_KERNEL_RO);
-	if (!buf->data)
-		return -ENOMEM;
-	return 0;
-}
-
 /* store the pages buffer info firmware from buf */
 static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 {
@@ -884,9 +895,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	if (!retval && f_dev->parent)
 		fw_add_devm_name(f_dev->parent, buf->fw_id);
 
-	if (!retval)
-		retval = fw_map_pages_buf(buf);
-
 	/*
 	 * After caching firmware image is started, let it piggyback
 	 * on request firmware.
-- 
1.7.9.5

