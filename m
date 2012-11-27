Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2K0QSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:18:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:33422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab2K0QSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:18:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,328,1352102400"; 
   d="scan'208";a="223083040"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        myungjoo.ham@samsung.com, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        anish kumar <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH] EXTCON: Get and set cable properties
Date: Wed, 28 Nov 2012 03:19:16 +0530
Message-Id: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing EXTCON implementation doesn't give a mechanim to read the cable
properties and extra states a cable needs to support. There are scenarios
where a cable can have more than two states(CONNECT/DISCONNECT/SUSPEND/RESUME etc)
and can have some properties associated with cables(mA)

This patch introduces interface to get and set cable properties
from EXTCON framework. The cable property can be set either by
the extcon cable provider or by other subsystems who know the cable
properties using eth API extcon_cable_set_data()

When the consumer gets a notification from the extcon, it can use the
extcon_cable_get_data() to get the cable properties irrespective of who
provides the cable data.

This gives a single interface for setting and getting the cable properties.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/extcon/extcon-class.c |   30 ++++++++++++++++++++++++++++++
 include/linux/extcon.h        |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index d398821..304f343 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -545,6 +545,36 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
 }
 EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
 
+/**
+ * extcon_cable_set_data() - Set the data structure for a cable
+ * @edev:	the extcon device
+ * @cable_index:	the cable index of the correspondant
+ * @type:	type of the data structure
+ * @data:
+ */
+void extcon_cable_set_data(struct extcon_dev *edev, int cable_index,
+			   enum extcon_cable_name type,
+			   union extcon_cable_data data)
+{
+	edev->cables[cable_index].type = type;
+	edev->cables[cable_index].data = data;
+}
+
+/**
+ * extcon_cable_get_data() - Get the data structure for a cable
+ * @edev:	the extcon device
+ * @cable_index:	the cable index of the correspondant
+ * @type:	type of the data structure
+ * @data:	the corresponding data structure (e.g., regulator)
+ */
+void extcon_cable_get_data(struct extcon_dev *edev, int cable_index,
+			   enum extcon_cable_name *type,
+			   union extcon_cable_data *data)
+{
+	*type = edev->cables[cable_index].type;
+	*data = edev->cables[cable_index].data;
+}
+
 static struct device_attribute extcon_attrs[] = {
 	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
 	__ATTR_RO(name),
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 2c26c14..4556cc5 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -135,6 +135,19 @@ struct extcon_dev {
 	struct device_attribute *d_attrs_muex;
 };
 
+/* FIXME: Is this the right place for this structure definition?
+ * Do we need to move it to power_supply.h?
+ */
+struct extcon_chrgr_cable_props {
+	unsigned long state;
+	int mA;
+};
+
+union extcon_cable_data {
+	struct extcon_chrgr_cable_props chrgr_cbl_props;
+	/* Please add accordingly*/
+};
+
 /**
  * struct extcon_cable	- An internal data for each cable of extcon device.
  * @edev	The extcon device
@@ -143,6 +156,8 @@ struct extcon_dev {
  * @attr_name	"name" sysfs entry
  * @attr_state	"state" sysfs entry
  * @attrs	Array pointing to attr_name and attr_state for attr_g
+ * @type:	The type of @data.
+ * @data:	The data structure representing the status and states of this cable.
  */
 struct extcon_cable {
 	struct extcon_dev *edev;
@@ -153,6 +168,11 @@ struct extcon_cable {
 	struct device_attribute attr_state;
 
 	struct attribute *attrs[3]; /* to be fed to attr_g.attrs */
+
+	union extcon_cable_data data;
+
+	/* extcon cable type */
+	enum extcon_cable_name type;
 };
 
 /**
@@ -183,6 +203,17 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
+ * Following APIs are for managing the status and states of each cable.
+ * For example, if a cable is represented as a regulator, then the cable
+ * may have struct regulator as its data.
+ */
+extern void extcon_cable_set_data(struct extcon_dev *edev, int cable_index,
+			enum extcon_cable_name type,
+			union extcon_cable_data data);
+extern void extcon_cable_get_data(struct extcon_dev *edev, int cable_index,
+			enum extcon_cable_name *type,
+			union extcon_cable_data *data);
+/*
  * get/set/update_state access the 32b encoded state value, which represents
  * states of all possible cables of the multistate port. For example, if one
  * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
@@ -244,6 +275,14 @@ static inline int extcon_dev_register(struct extcon_dev *edev,
 
 static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
 
+static void extcon_cable_set_data(struct extcon_dev *edev, int cable_index,
+				enum extcon_cable_name type,
+				union extcon_cable_data data) { }
+
+static void extcon_cable_get_data(struct extcon_dev *edev, int cable_index,
+				enum extcon_cable_name *type,
+				union extcon_cable_data *data) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.7.9.5

