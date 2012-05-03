Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2ECRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:15:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53816 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757825Ab2ECRP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:15:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] devres: Add devres_release()
Date: Thu,  3 May 2012 18:15:13 +0100
Message-Id: <1336065314-11696-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336065314-11696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APIs using devres frequently want to implement a "remove and free the
resource" operation so it seems sensible that they should be able to
just have devres do the freeing for them since that's a big part of what
devres is all about.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/devres.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/device.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 1741a60..2360adb 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -330,6 +330,37 @@ int devres_destroy(struct device *dev, dr_release_t release,
 }
 EXPORT_SYMBOL_GPL(devres_destroy);
 
+
+/**
+ * devres_release - Find a device resource and destroy it, calling release
+ * @dev: Device to find resource from
+ * @release: Look for resources associated with this release function
+ * @match: Match function (optional)
+ * @match_data: Data for the match function
+ *
+ * Find the latest devres of @dev associated with @release and for
+ * which @match returns 1.  If @match is NULL, it's considered to
+ * match all.  If found, the resource is removed atomically, the
+ * release function called and the resource freed.
+ *
+ * RETURNS:
+ * 0 if devres is found and freed, -ENOENT if not found.
+ */
+int devres_release(struct device *dev, dr_release_t release,
+		   dr_match_t match, void *match_data)
+{
+	void *res;
+
+	res = devres_remove(dev, release, match, match_data);
+	if (unlikely(!res))
+		return -ENOENT;
+
+	(*release)(dev, res);
+	devres_free(res);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devres_release);
+
 static int remove_nodes(struct device *dev,
 			struct list_head *first, struct list_head *end,
 			struct list_head *todo)
diff --git a/include/linux/device.h b/include/linux/device.h
index e3399290..5c7fdbd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -541,6 +541,8 @@ extern void *devres_remove(struct device *dev, dr_release_t release,
 			   dr_match_t match, void *match_data);
 extern int devres_destroy(struct device *dev, dr_release_t release,
 			  dr_match_t match, void *match_data);
+extern int devres_release(struct device *dev, dr_release_t release,
+			  dr_match_t match, void *match_data);
 
 /* devres group */
 extern void * __must_check devres_open_group(struct device *dev, void *id,
-- 
1.7.10

