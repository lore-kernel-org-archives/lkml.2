Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1C1XyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:54:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37276 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1C1Xx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:53:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82587975"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH v2 2/2] regulator: Propagate uA_load requirements up supply chain
Date: Mon, 28 Mar 2011 16:53:52 -0700
Message-Id: <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_set_optimum_mode currently only determines the load
on the specified regulator.  Physically however, this current
must be provided by regulators further up the supply chain.
Add code to handle uA_load propagation up through the regulator
supply chain in both regulator_set_optimum_mode and drms_uA_update.

Add a new regulator operation callback function named
get_current_required to struct regulator_ops to assist in this
propagation.  get_current_required will return the input current
required for a given regulator based on input voltage, output
voltage, and output current.  It should be able to capture all
hardware specific current characteristics of a regulator.
The input current required for a typical linear and switching
regulator would be simple to describe in this callback.

Usage of the get_current_required callback is conditional such
that if it is not specified for a given regulator, then that
regulator will not attempt to propagate its required current
to its supply regulator.  This means that there is no change
to system operation if get_current_required is unspecified.

Extend struct regulator_dev slightly by adding a new member:
uA_load.  This will default to 0 and only be filled with the
return value of get_current_required (if specified).  It
effectively caches the load required by a regulator so that it is
not necessary to walk through the tree of supplied regulators
every time that regulator_set_optimum_mode or drms_uA_update is
called.

Modify regulator_total_uA_show so that it also sums in the loads
of supplied regulators.

Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 drivers/regulator/core.c         |   69 ++++++++++++++++++++++++++++++++++++-
 include/linux/regulator/driver.h |    5 +++
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 05904be..dc2bbcf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -422,10 +422,20 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
+	struct regulator_dev *consumer_rdev;
 	struct regulator *regulator;
 	int uA = 0;
 
+	/* Calculate total load of consumer regulator devices. */
+	list_for_each_entry(consumer_rdev, &rdev->supply_list, slist)
+		if (consumer_rdev->desc->ops->get_current_required) {
+			mutex_lock(&consumer_rdev->mutex);
+			uA += consumer_rdev->uA_load;
+			mutex_unlock(&consumer_rdev->mutex);
+		}
+
 	mutex_lock(&rdev->mutex);
+	/* Calculate total load of consumer devices. */
 	list_for_each_entry(regulator, &rdev->consumer_list, list)
 		uA += regulator->uA_load;
 	mutex_unlock(&rdev->mutex);
@@ -574,10 +584,14 @@ static struct class regulator_class = {
 	.dev_attrs = regulator_dev_attrs,
 };
 
-/* Calculate the new optimum regulator operating mode based on the new total
- * consumer load. All locks held by caller */
+/*
+ * Calculate the new optimum regulator operating mode based on the new total
+ * consumer load. Lock for rdev is held by caller. Locks will be taken for
+ * consumer regulators of rdev.
+ */
 static void drms_uA_update(struct regulator_dev *rdev)
 {
+	struct regulator_dev *consumer_rdev;
 	struct regulator *sibling;
 	int current_uA = 0, output_uV, input_uV, err;
 	unsigned int mode;
@@ -607,6 +621,14 @@ static void drms_uA_update(struct regulator_dev *rdev)
 	list_for_each_entry(sibling, &rdev->consumer_list, list)
 		current_uA += sibling->uA_load;
 
+	/* calculate total load of consumer regulator devices before locking */
+	list_for_each_entry(consumer_rdev, &rdev->supply_list, slist)
+		if (consumer_rdev->desc->ops->get_current_required) {
+			mutex_lock(&consumer_rdev->mutex);
+			current_uA += consumer_rdev->uA_load;
+			mutex_unlock(&consumer_rdev->mutex);
+		}
+
 	/* now get the optimum mode for our new total regulator load */
 	mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
 						  output_uV, current_uA);
@@ -615,6 +637,14 @@ static void drms_uA_update(struct regulator_dev *rdev)
 	err = regulator_check_mode(rdev, mode);
 	if (err == 0)
 		rdev->desc->ops->set_mode(rdev, mode);
+
+	if (rdev->desc->ops->get_current_required) {
+		err = rdev->desc->ops->get_current_required(rdev, input_uV,
+							output_uV, current_uA);
+		if (err < 0)
+			return;
+		rdev->uA_load = err;
+	}
 }
 
 static int suspend_set_state(struct regulator_dev *rdev,
@@ -2033,10 +2063,20 @@ EXPORT_SYMBOL_GPL(regulator_get_mode);
 int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 {
 	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *consumer_rdev;
 	struct regulator *consumer;
 	int ret, output_uV, input_uV, total_uA_load = 0;
 	unsigned int mode;
 
+	/* calculate total load of consumer regulator devices before locking */
+	list_for_each_entry(consumer_rdev, &rdev->supply_list, slist) {
+		if (consumer_rdev->desc->ops->get_current_required) {
+			mutex_lock(&consumer_rdev->mutex);
+			total_uA_load += consumer_rdev->uA_load;
+			mutex_unlock(&consumer_rdev->mutex);
+		}
+	}
+
 	mutex_lock(&rdev->mutex);
 
 	regulator->uA_load = uA_load;
@@ -2086,9 +2126,34 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 		rdev_err(rdev, "failed to set optimum mode %x\n", mode);
 		goto out;
 	}
+
+	if (rdev->desc->ops->get_current_required) {
+		ret = rdev->desc->ops->get_current_required(rdev, input_uV,
+						output_uV, total_uA_load);
+		if (ret < 0) {
+			rdev_err(rdev, "failed to get required load @ %d uA "
+					"%d -> %d uV, rc=%d\n", total_uA_load,
+					input_uV, output_uV, ret);
+			goto out;
+		}
+
+		rdev->uA_load = ret;
+	}
+
 	ret = mode;
+
 out:
 	mutex_unlock(&rdev->mutex);
+
+	/* Update load for our supplies */
+	while (rdev->desc->ops->get_current_required && rdev->supply) {
+		rdev = rdev->supply;
+
+		mutex_lock(&rdev->mutex);
+		drms_uA_update(rdev);
+		mutex_unlock(&rdev->mutex);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index b8ed16a..521b1b6 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -117,6 +117,10 @@ struct regulator_ops {
 	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
 					  int output_uV, int load_uA);
 
+	/* get supply current required for load */
+	int (*get_current_required) (struct regulator_dev *, int input_uV,
+				     int output_uV, int load_uA);
+
 	/* the operations below are for configuration of regulator state when
 	 * its parent PMIC enters a global STANDBY/HIBERNATE state */
 
@@ -178,6 +182,7 @@ struct regulator_dev {
 	int exclusive;
 	u32 use_count;
 	u32 open_count;
+	int uA_load;
 
 	/* lists we belong to */
 	struct list_head list; /* list of all regulators */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

