Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072Ab2COJ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:58:40 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:39803 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761050Ab2COJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:58:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] driver core: always handle dpm_order
Date: Thu, 15 Mar 2012 10:58:18 +0100
Message-ID: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

If !dev->class, device_move() does not respect the dpm_order.
Fix it to do so.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
[Fixed a small dangling label compile warning]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/base/core.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 74dda4f..be07591 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1746,25 +1746,25 @@ int device_move(struct device *dev, struct device *new_parent,
 		set_dev_node(dev, dev_to_node(new_parent));
 	}
 
-	if (!dev->class)
-		goto out_put;
-	error = device_move_class_links(dev, old_parent, new_parent);
-	if (error) {
-		/* We ignore errors on cleanup since we're hosed anyway... */
-		device_move_class_links(dev, new_parent, old_parent);
-		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
-			if (new_parent)
-				klist_remove(&dev->p->knode_parent);
-			dev->parent = old_parent;
-			if (old_parent) {
-				klist_add_tail(&dev->p->knode_parent,
-					       &old_parent->p->klist_children);
-				set_dev_node(dev, dev_to_node(old_parent));
+	if (dev->class) {
+		error = device_move_class_links(dev, old_parent, new_parent);
+		if (error) {
+			/* We ignore errors on cleanup since we're hosed anyway... */
+			device_move_class_links(dev, new_parent, old_parent);
+			if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
+				if (new_parent)
+					klist_remove(&dev->p->knode_parent);
+				dev->parent = old_parent;
+				if (old_parent) {
+					klist_add_tail(&dev->p->knode_parent,
+						       &old_parent->p->klist_children);
+					set_dev_node(dev, dev_to_node(old_parent));
+				}
 			}
+			cleanup_glue_dir(dev, new_parent_kobj);
+			put_device(new_parent);
+			goto out;
 		}
-		cleanup_glue_dir(dev, new_parent_kobj);
-		put_device(new_parent);
-		goto out;
 	}
 	switch (dpm_order) {
 	case DPM_ORDER_NONE:
@@ -1779,7 +1779,7 @@ int device_move(struct device *dev, struct device *new_parent,
 		device_pm_move_last(dev);
 		break;
 	}
-out_put:
+
 	put_device(old_parent);
 out:
 	device_pm_unlock();
-- 
1.7.9.2

