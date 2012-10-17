Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2JQGgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:36:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:10732 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2JQGgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="205445809"
From: Jenny TC <jenny.tc@intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Jenny TC <jenny.tc@intel.com>
Subject: [PATCH V2] extcon : register for cable interest by cable name
Date: Wed, 17 Oct 2012 17:38:45 +0530
Message-Id: <1350475725-8457-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some scnearios where a driver/framework needs to register
interest for a particular cable without specifying the extcon device
name. One such scenario is charger notifications. The platform will
have charger cabel which will be bound to any extcon device. It's
not mandatory for the charger driver to know which extcon device
it should use. This patch enables the support for registering
interest for a cable just by cable name wihtout specifying the
extcon device name

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
v1:
  Initial submit
V2:
  Removed the new API and modified the extcon_register_interest
  API to accomodate the new requirement

 drivers/extcon/extcon-class.c |   43 +++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..738919e 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -466,22 +466,45 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 			     const char *extcon_name, const char *cable_name,
 			     struct notifier_block *nb)
 {
-	if (!obj || !extcon_name || !cable_name || !nb)
+
+	if (!obj || !cable_name || !nb)
 		return -EINVAL;
 
-	obj->edev = extcon_get_extcon_dev(extcon_name);
-	if (!obj->edev)
-		return -ENODEV;
+	if (extcon_name) {
+
+		obj->edev = extcon_get_extcon_dev(extcon_name);
+		if (!obj->edev)
+			return -ENODEV;
+
+		obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
+		if (obj->cable_index < 0)
+			return -ENODEV;
 
-	obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
-	if (obj->cable_index < 0)
-		return -ENODEV;
+		obj->user_nb = nb;
 
-	obj->user_nb = nb;
+		obj->internal_nb.notifier_call = _call_per_cable;
 
-	obj->internal_nb.notifier_call = _call_per_cable;
+		return raw_notifier_chain_register(&obj->edev->nh, &obj->internal_nb);
+	} else {
+		struct class_dev_iter iter;
+		struct extcon_dev *extd;
+		struct device *dev;
+		if (!extcon_class)
+			return -ENODEV;
+		class_dev_iter_init(&iter, extcon_class, NULL, NULL);
+		while ((dev = class_dev_iter_next(&iter))) {
+			extd = (struct extcon_dev *)dev_get_drvdata(dev);
+
+			if (extcon_find_cable_index(extd, cable_name) < 0)
+				continue;
+
+			class_dev_iter_exit(&iter);
+			return extcon_register_interest(obj, extd->name,
+						cable_name, nb);
+			}
 
-	return raw_notifier_chain_register(&obj->edev->nh, &obj->internal_nb);
+			return -ENODEV;
+		}
 }
 
 /**
-- 
1.7.9.5

