Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab2GXRAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:00:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32908 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2GXRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:00:49 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 02/13] driver core: firmware loader: fix races during loading firmware
Date: Wed, 25 Jul 2012 01:00:02 +0800
Message-Id: <1343149213-10160-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two races in loading firmware:

1, FW_STATUS_DONE should be set before waking up the task waitting
on _request_firmware_load, otherwise FW_STATUS_ABORT may be
thought as DONE mistakenly.

2, Inside _request_firmware_load(), there is a small window between
wait_for_completion() and mutex_lock(&fw_lock), and 'echo 1 > loading'
still may happen during the period, so this patch checks FW_STATUS_DONE
to prevent pages' buffer completed from being freed in firmware_loading_store.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index f789bbd..6e96b8c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -243,18 +243,21 @@ static ssize_t firmware_loading_store(struct device *dev,
 	switch (loading) {
 	case 1:
 		/* discarding any previous partial load */
-		for (i = 0; i < fw_priv->nr_pages; i++)
-			__free_page(fw_priv->pages[i]);
-		kfree(fw_priv->pages);
-		fw_priv->pages = NULL;
-		fw_priv->page_array_size = 0;
-		fw_priv->nr_pages = 0;
-		set_bit(FW_STATUS_LOADING, &fw_priv->status);
+		if (!test_bit(FW_STATUS_DONE, &fw_priv->status)) {
+			for (i = 0; i < fw_priv->nr_pages; i++)
+				__free_page(fw_priv->pages[i]);
+			kfree(fw_priv->pages);
+			fw_priv->pages = NULL;
+			fw_priv->page_array_size = 0;
+			fw_priv->nr_pages = 0;
+			set_bit(FW_STATUS_LOADING, &fw_priv->status);
+		}
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
-			complete(&fw_priv->completion);
+			set_bit(FW_STATUS_DONE, &fw_priv->status);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
+			complete(&fw_priv->completion);
 			break;
 		}
 		/* fallthrough */
@@ -552,7 +555,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	wait_for_completion(&fw_priv->completion);
 
-	set_bit(FW_STATUS_DONE, &fw_priv->status);
 	del_timer_sync(&fw_priv->timeout);
 
 	mutex_lock(&fw_lock);
-- 
1.7.9.5

