Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2HDEDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:03:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2HDEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:03:14 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 13/15] firmware loader: use small timeout for cache device firmware
Date: Sat,  4 Aug 2012 12:01:28 +0800
Message-Id: <1344052890-31935-14-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because device_cache_fw_images only cache the firmware which has been
loaded sucessfully at leat once, using a small loading timeout should
be reasonable.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 68fd4c6..8ca0052 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1146,10 +1146,22 @@ static void device_cache_fw_images(void)
 {
 	struct firmware_cache *fwc = &fw_cache;
 	struct device *dev;
+	int old_timeout;
 	DEFINE_WAIT(wait);
 
 	pr_debug("%s\n", __func__);
 
+	/*
+	 * use small loading timeout for caching devices' firmware
+	 * because all these firmware images have been loaded
+	 * successfully at lease once, also system is ready for
+	 * completing firmware loading now. The maximum size of
+	 * firmware in current distributions is about 2M bytes,
+	 * so 10 secs should be enough.
+	 */
+	old_timeout = loading_timeout;
+	loading_timeout = 10;
+
 	device_pm_lock();
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		dev_cache_fw_image(dev);
@@ -1171,6 +1183,8 @@ static void device_cache_fw_images(void)
 	}
 	spin_unlock(&fwc->name_lock);
 	finish_wait(&fwc->wait_queue, &wait);
+
+	loading_timeout = old_timeout;
 }
 
 /**
-- 
1.7.9.5

