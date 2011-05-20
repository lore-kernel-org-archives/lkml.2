Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766Ab1ETALq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40342 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934715Ab1ETALn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:43 -0400
X-Sasl-enc: gyKnBe3HnkSClE1FP5OmwHUbKpK7ifgI8n4ApVOc7vyM 1305850302
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/44] driver core: let dev_set_drvdata return int instead of void as it can fail
Date: Thu, 19 May 2011 17:10:40 -0700
Message-Id: <1305850262-9575-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Before commit

	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)

calling dev_set_drvdata with dev=NULL was an unchecked error. After some
discussion about what to return in this case removing the check (and so
producing a null pointer exception) seems fine.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c      |    7 +++----
 include/linux/device.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7e9219b..e3a3eff 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -413,17 +413,16 @@ void *dev_get_drvdata(const struct device *dev)
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 
-void dev_set_drvdata(struct device *dev, void *data)
+int dev_set_drvdata(struct device *dev, void *data)
 {
 	int error;
 
-	if (!dev)
-		return;
 	if (!dev->p) {
 		error = device_private_init(dev);
 		if (error)
-			return;
+			return error;
 	}
 	dev->p->driver_data = data;
+	return 0;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
diff --git a/include/linux/device.h b/include/linux/device.h
index 350ceda..2215d01 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -557,7 +557,7 @@ extern int device_move(struct device *dev, struct device *new_parent,
 extern const char *device_get_devnode(struct device *dev,
 				      mode_t *mode, const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
-extern void dev_set_drvdata(struct device *dev, void *data);
+extern int dev_set_drvdata(struct device *dev, void *data);
 
 /*
  * Root device objects for grouping under /sys/devices
-- 
1.7.4.2

