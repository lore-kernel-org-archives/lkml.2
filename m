Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2GXRBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:01:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52206 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2GXRBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:01:33 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 10/13] driver core: devres: introduce devres_for_each_res
Date: Wed, 25 Jul 2012 01:00:10 +0800
Message-Id: <1343149213-10160-11-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces one devres API of devres_for_each_res
so that the device's driver can iterate each resource it has
interest in.

The firmware loader will use the API to get each firmware name
from the device instance.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/devres.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    3 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 2360adb..8273ba5 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -144,6 +144,48 @@ EXPORT_SYMBOL_GPL(devres_alloc);
 #endif
 
 /**
+ * devres_for_each_res - Resource iterator
+ * @dev: Device to iterate resource from
+ * @release: Look for resources associated with this release function
+ * @match: Match function (optional)
+ * @match_data: Data for the match function
+ * @fn: function to be called for each matched resource.
+ *
+ * Call @fn for each devres of @dev which is associated with @release
+ * and for which @match returns 1.
+ *
+ * RETURNS:
+ * 	void
+ */
+void devres_for_each_res(struct device *dev, dr_release_t release,
+			dr_match_t match, void *match_data,
+			void (*fn)(struct device *, void *))
+{
+	struct devres_node *node;
+	struct devres_node *tmp;
+	unsigned long flags;
+
+	if (!fn)
+		return;
+
+	spin_lock_irqsave(&dev->devres_lock, flags);
+	list_for_each_entry_safe_reverse(node, tmp,
+			&dev->devres_head, entry) {
+		struct devres *dr = container_of(node, struct devres, node);
+
+		if (node->release != release)
+			continue;
+		if (match && !match(dev, dr->data, match_data))
+			continue;
+		spin_unlock_irqrestore(&dev->devres_lock, flags);
+		fn(dev, dr->data);
+		spin_lock_irqsave(&dev->devres_lock, flags);
+	}
+	spin_unlock_irqrestore(&dev->devres_lock, flags);
+}
+EXPORT_SYMBOL_GPL(devres_for_each_res);
+
+/**
  * devres_free - Free device resource data
  * @res: Pointer to devres data to free
  *
diff --git a/include/linux/device.h b/include/linux/device.h
index 52a5f15..34dc1f8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -536,6 +536,9 @@ extern void *__devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
 #else
 extern void *devres_alloc(dr_release_t release, size_t size, gfp_t gfp);
 #endif
+extern void devres_for_each_res(struct device *dev, dr_release_t release,
+			dr_match_t match, void *match_data,
+			void (*fn)(struct device *, void *));
 extern void devres_free(void *res);
 extern void devres_add(struct device *dev, void *res);
 extern void *devres_find(struct device *dev, dr_release_t release,
-- 
1.7.9.5

