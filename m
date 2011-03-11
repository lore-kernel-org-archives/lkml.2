Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1CKHjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:39:09 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:54066 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1CKHjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:39:07 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, dmitry.torokhov@gmail.com,
        Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 1/2] hid-ntrig: sysfs nodes for modes
Date: Fri, 11 Mar 2011 02:37:51 -0500
Message-Id: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.2.3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-11_02:2011-03-11,2011-03-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

---

If the code is there, might as well expose a friendly interface to the
user.
---
 drivers/hid/hid-ntrig.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index fa862c5..24ab6a5 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -24,6 +24,8 @@
 
 #define NTRIG_DUPLICATE_USAGES	0x001
 
+static const char *ntrig_modes[4] = { "pen", "touch", "auto", "dual" };
+
 static unsigned int min_width;
 module_param(min_width, uint, 0644);
 MODULE_PARM_DESC(min_width, "Minimum touch contact width to accept.");
@@ -430,6 +432,64 @@ static ssize_t set_deactivate_slack(struct device *dev,
 static DEVICE_ATTR(deactivate_slack, S_IWUSR | S_IRUGO, show_deactivate_slack,
 		   set_deactivate_slack);
 
+
+static ssize_t show_mode(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	int mode = ntrig_get_mode(container_of(dev, struct hid_device, dev));
+	int i, ret;
+	char *s = buf;
+
+	if (mode < 0)
+		return mode;
+
+
+	for (i = 0; i < 4; i++)
+		s += sprintf(s, "%s%s%s ", (i == mode) ? "[" : "",
+			     ntrig_modes[i], (i == mode) ? "]" : "");
+
+	if (mode >= 4)
+		s += sprintf(s, "[%d]\n", mode);
+	else
+		*(s - 1) = '\n';
+
+	ret = s - buf;
+
+	return ret;
+}
+
+static ssize_t store_mode(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	int len;
+	int i;
+	int mode = -EINVAL;
+	char *p;
+
+	p = memchr(buf, '\n', count);
+	len = p ? p - buf : count;
+
+	if (len == 1 && buf[0] >= '0' && buf[0] <= '4') {
+		mode = buf[0] - '0';
+	} else
+		for (i = 0; i < 4; i++)
+			if (len == strlen(ntrig_modes[i]) &&
+			    !strncmp(buf, ntrig_modes[i], len)) {
+				mode = i;
+				break;
+			}
+
+	if (mode < 0)
+		return mode;
+
+	ntrig_set_mode(container_of(dev, struct hid_device, dev), mode);
+
+	return count;
+}
+static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, show_mode, store_mode);
+
 static struct attribute *sysfs_attrs[] = {
 	&dev_attr_sensor_physical_width.attr,
 	&dev_attr_sensor_physical_height.attr,
@@ -441,6 +501,7 @@ static struct attribute *sysfs_attrs[] = {
 	&dev_attr_activation_width.attr,
 	&dev_attr_activation_height.attr,
 	&dev_attr_deactivate_slack.attr,
+	&dev_attr_mode.attr,
 	NULL
 };
 
-- 
1.7.2.3

