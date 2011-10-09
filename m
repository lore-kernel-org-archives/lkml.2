Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1JILMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51465 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1JILL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:11:56 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/7] staging: wlags49_h2: Handle sysfs_create_group return correctly
Date: Sun,  9 Oct 2011 12:11:31 +0100
Message-Id: <1318158697-15979-2-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function returns 0 on success and non-zero on error. So
correctly record the status so it is freed appropriately.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_internal.h |    2 +-
 drivers/staging/wlags49_h2/wl_sysfs.c    |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index 6351bb8..9ed2857 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -883,7 +883,7 @@ struct wl_private
 	int                         is_registered;
 	int                         is_handling_int;
 	int                         firmware_present;
-	char                        sysfsCreated;
+	bool                        sysfsCreated;
 	CFG_DRV_INFO_STRCT          driverInfo;
 	CFG_IDENTITY_STRCT          driverIdentity;
 	CFG_FW_IDENTITY_STRCT       StationIdentity;
diff --git a/drivers/staging/wlags49_h2/wl_sysfs.c b/drivers/staging/wlags49_h2/wl_sysfs.c
index 9b833b3..1508f04 100644
--- a/drivers/staging/wlags49_h2/wl_sysfs.c
+++ b/drivers/staging/wlags49_h2/wl_sysfs.c
@@ -120,17 +120,19 @@ static struct attribute_group wlags_group = {
 
 void register_wlags_sysfs(struct net_device *net)
 {
-    struct device *dev = &(net->dev);
-    struct wl_private *lp = wl_priv(net);
-
-    lp->sysfsCreated = sysfs_create_group(&dev->kobj, &wlags_group);
+	struct device *dev = &(net->dev);
+	struct wl_private *lp = wl_priv(net);
+	int err;
+	err = sysfs_create_group(&dev->kobj, &wlags_group);
+	if (!err)
+		lp->sysfsCreated = true;
 }
 
 void unregister_wlags_sysfs(struct net_device *net)
 {
-    struct device *dev = &(net->dev);
-    struct wl_private *lp = wl_priv(net);
+	struct device *dev = &(net->dev);
+	struct wl_private *lp = wl_priv(net);
 
-    if (lp->sysfsCreated)
-	sysfs_remove_group(&dev->kobj, &wlags_group);
+	if (lp->sysfsCreated)
+		sysfs_remove_group(&dev->kobj, &wlags_group);
 }
-- 
1.7.4.1

