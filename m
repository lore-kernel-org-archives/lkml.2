Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3AJQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:51:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54062 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3AJQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:51:49 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 02/14] usb: phy: Add new API usb_get_phy_from_dev()
Date: Thu, 10 Jan 2013 18:51:22 +0200
Message-ID: <1357836694-30788-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This API allows PHY users to get the usb_phy data structure
from a device handle.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/otg/otg.c   |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h |    6 ++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index a30c041..ba3a568 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -35,6 +35,21 @@ static struct usb_phy *__usb_find_phy(struct list_head *list,
 	return ERR_PTR(-ENODEV);
 }
 
+static struct usb_phy *__usb_find_phy_dev(struct list_head *list,
+	struct device *dev)
+{
+	struct usb_phy *phy;
+
+	list_for_each_entry(phy, list, head) {
+		if (phy->dev != dev)
+			continue;
+
+		return phy;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 static void devm_usb_phy_release(struct device *dev, void *res)
 {
 	struct usb_phy *phy = *(struct usb_phy **)res;
@@ -77,6 +92,27 @@ struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
 }
 EXPORT_SYMBOL(devm_usb_get_phy);
 
+struct usb_phy *usb_get_phy_from_dev(struct device *dev)
+{
+	struct usb_phy *phy = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&phy_lock, flags);
+
+	phy = __usb_find_phy_dev(&phy_list, dev);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "%s: unable to find PHY\n", __func__);
+		goto done;
+	}
+
+	get_device(phy->dev);
+
+done:
+	spin_unlock_irqrestore(&phy_lock, flags);
+	return phy;
+}
+EXPORT_SYMBOL(usb_get_phy_from_dev);
+
 /**
  * usb_get_phy - find the USB PHY
  * @type - the type of the phy the controller requires
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index a29ae1e..cd798c4 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -147,6 +147,7 @@ usb_phy_shutdown(struct usb_phy *x)
 /* for usb host and peripheral controller drivers */
 #ifdef CONFIG_USB_OTG_UTILS
 extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
+extern struct usb_phy *usb_get_phy_from_dev(struct device *dev);
 extern struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type);
 extern void usb_put_phy(struct usb_phy *);
@@ -157,6 +158,11 @@ static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
 	return NULL;
 }
 
+static inline struct usb_phy *usb_get_phy_from_dev(struct device *dev)
+{
+	return NULL;
+}
+
 static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type)
 {
-- 
1.7.4.1

