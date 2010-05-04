Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab0EDSVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:21:39 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:55444 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168Ab0EDSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:21:22 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org,
       guy.paradis@n-trig.com, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 3/3] ntrig sysfs access to filter parameters
Date: Tue,  4 May 2010 14:20:17 -0400
Message-Id: <1272997217-15335-4-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
References: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should make it a little more convenient to tweak the filtering
parameters on the fly.  Also unlike load-time parameters, this provides
independent tuning for each device conntected.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
 drivers/hid/hid-ntrig.c |  285 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 285 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 18609c1..b6b0cae 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -89,6 +89,287 @@ struct ntrig_data {
 	__u16 sensor_physical_height;
 };
 
+
+static ssize_t show_phys_width(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->sensor_physical_width);
+}
+
+static DEVICE_ATTR(sensor_physical_width, S_IRUGO, show_phys_width, NULL);
+
+static ssize_t show_phys_height(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->sensor_physical_height);
+}
+
+static DEVICE_ATTR(sensor_physical_height, S_IRUGO, show_phys_height, NULL);
+
+static ssize_t show_log_width(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->sensor_logical_width);
+}
+
+static DEVICE_ATTR(sensor_logical_width, S_IRUGO, show_log_width, NULL);
+
+static ssize_t show_log_height(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->sensor_logical_height);
+}
+
+static DEVICE_ATTR(sensor_logical_height, S_IRUGO, show_log_height, NULL);
+
+static ssize_t show_min_width(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->min_width *
+				    nd->sensor_physical_width /
+				    nd->sensor_logical_width);
+}
+
+static ssize_t set_min_width(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val > nd->sensor_physical_width)
+		return -EINVAL;
+
+	nd->min_width = val * nd->sensor_logical_width /
+			      nd->sensor_physical_width;
+
+	return count;
+}
+
+static DEVICE_ATTR(min_width, S_IWUSR | S_IRUGO, show_min_width, set_min_width);
+
+static ssize_t show_min_height(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->min_height *
+				    nd->sensor_physical_height /
+				    nd->sensor_logical_height);
+}
+
+static ssize_t set_min_height(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val > nd->sensor_physical_height)
+		return -EINVAL;
+
+	nd->min_height = val * nd->sensor_logical_height /
+			       nd->sensor_physical_height;
+
+	return count;
+}
+
+static DEVICE_ATTR(min_height, S_IWUSR | S_IRUGO, show_min_height,
+		   set_min_height);
+
+static ssize_t show_activate_slack(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->activate_slack);
+}
+
+static ssize_t set_activate_slack(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val > 0x7f)
+		return -EINVAL;
+
+	nd->activate_slack = val;
+
+	return count;
+}
+
+static DEVICE_ATTR(activate_slack, S_IWUSR | S_IRUGO, show_activate_slack,
+		   set_activate_slack);
+
+static ssize_t show_activation_width(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->activation_width *
+				    nd->sensor_physical_width /
+				    nd->sensor_logical_width);
+}
+
+static ssize_t set_activation_width(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val > nd->sensor_physical_width)
+		return -EINVAL;
+
+	nd->activation_width = val * nd->sensor_logical_width /
+				     nd->sensor_physical_width;
+
+	return count;
+}
+
+static DEVICE_ATTR(activation_width, S_IWUSR | S_IRUGO, show_activation_width,
+		   set_activation_width);
+
+static ssize_t show_activation_height(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", nd->activation_height *
+				    nd->sensor_physical_height /
+				    nd->sensor_logical_height);
+}
+
+static ssize_t set_activation_height(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val > nd->sensor_physical_height)
+		return -EINVAL;
+
+	nd->activation_height = val * nd->sensor_logical_height /
+				      nd->sensor_physical_height;
+
+	return count;
+}
+
+static DEVICE_ATTR(activation_height, S_IWUSR | S_IRUGO,
+		   show_activation_height, set_activation_height);
+
+static ssize_t show_deactivate_slack(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	return sprintf(buf, "%d\n", -nd->deactivate_slack);
+}
+
+static ssize_t set_deactivate_slack(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	/*
+	 * No more than 8 terminal frames have been observed so far
+	 * and higher slack is highly likely to leave the single
+	 * touch emulation stuck down.
+	 */
+	if (val > 7)
+		return -EINVAL;
+
+	nd->deactivate_slack = -val;
+
+	return count;
+}
+
+static DEVICE_ATTR(deactivate_slack, S_IWUSR | S_IRUGO, show_deactivate_slack,
+		   set_deactivate_slack);
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_sensor_physical_width.attr,
+	&dev_attr_sensor_physical_height.attr,
+	&dev_attr_sensor_logical_width.attr,
+	&dev_attr_sensor_logical_height.attr,
+	&dev_attr_min_height.attr,
+	&dev_attr_min_width.attr,
+	&dev_attr_activate_slack.attr,
+	&dev_attr_activation_width.attr,
+	&dev_attr_activation_height.attr,
+	&dev_attr_deactivate_slack.attr,
+	NULL
+};
+
+static struct attribute_group ntrig_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
 /*
  * this driver is aimed at two firmware versions in circulation:
  *  - dual pen/finger single touch
@@ -567,6 +848,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (report)
 		usbhid_submit_report(hdev, report, USB_DIR_OUT);
 
+	ret = sysfs_create_group(&hdev->dev.kobj,
+			&ntrig_attribute_group);
 
 	return 0;
 err_free:
@@ -576,6 +859,8 @@ err_free:
 
 static void ntrig_remove(struct hid_device *hdev)
 {
+	sysfs_remove_group(&hdev->dev.kobj,
+			&ntrig_attribute_group);
 	hid_hw_stop(hdev);
 	kfree(hid_get_drvdata(hdev));
 }
-- 
1.7.1

