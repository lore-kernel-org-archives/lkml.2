Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2JJEsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:48:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:36336 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2JJEso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,563,1344236400"; 
   d="scan'208";a="202636480"
From: Jenny TC <jenny.tc@intel.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
Cc: jenny.tc@intel.com
Subject: [PATCH] extcon : register for cable interest by cable name
Date: Wed, 10 Oct 2012 15:50:48 +0530
Message-Id: <1349864448-21276-1-git-send-email-jenny.tc@intel.com>
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
 drivers/extcon/extcon-class.c |   52 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |    3 +++
 2 files changed, 55 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..3d8e825 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -485,6 +485,58 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 }
 
 /**
+ * extcon_register_interest_cable_byname() - Register a notifier for a state
+ *			change of a specific cable, on any extcon device
+ *			extcon device.
+ * @obj:	an empty extcon_specific_cable_nb object to be returned.
+ * @cable_name:		the target cable name.
+ * @nb:		the notifier block to get notified.
+ *
+ * Provide an empty extcon_specific_cable_nb.
+ * extcon_register_interest_cable_name() sets the struct for you.
+ *
+ * extcon_register_cable_interest is a helper function for those who want to get
+ * notification for a single specific cable's status change without knowing the
+ * extcon device name.
+ *
+ * Note : This will register the interest with the first extcon device which
+ * reports the status for the cable. If multiple extcon devices reports the
+ * same cable name, this API will register interest with the first extcon device
+ */
+
+struct extcon_dev *register_interest_cable_byname
+		(struct extcon_specific_cable_nb *extcon_dev,
+		const char *cable_name, struct notifier_block *nb)
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+	struct extcon_dev *extd = NULL;
+
+	/* Identify the extcon device which supports the cable and register
+	* interest.
+	*/
+	if (extcon_class == NULL)
+		return NULL;
+	class_dev_iter_init(&iter, extcon_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		extd = (struct extcon_dev *)dev_get_drvdata(dev);
+		/* check for cable  support */
+		if (extcon_find_cable_index(extd, cable_name) < 0) {
+			extd = NULL;
+			continue;
+		}
+
+		if (extcon_register_interest(extcon_dev, extd->name,
+						cable_name, nb) < 0) {
+			extd = NULL;
+			continue;
+		}
+	}
+	class_dev_iter_exit(&iter);
+	return extd;
+}
+
+/**
  * extcon_unregister_interest() - Unregister the notifier registered by
  *				extcon_register_interest().
  * @obj:	the extcon_specific_cable_nb object returned by
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 7443a56..9be8286 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -222,6 +222,9 @@ extern int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 				    const char *extcon_name,
 				    const char *cable_name,
 				    struct notifier_block *nb);
+extern struct extcon_dev *register_interest_cable_byname
+		(struct extcon_specific_cable_nb *extcon_dev,
+		const char *cable_name, struct notifier_block *nb);
 extern int extcon_unregister_interest(struct extcon_specific_cable_nb *nb);
 
 /*
-- 
1.7.9.5

