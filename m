Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2HOURX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:17:23 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62964 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2HOTvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 090/165] [S390] ccwgroup: move attributes to attribute group
Date: Wed, 15 Aug 2012 15:47:14 -0400
Message-ID: <1345060109-9187-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dbdf1afcaaabe83dea15a3cb9b9013e73ae3b1ad upstream.

Put sysfs attributes of ccwgroup devices in an attribute group to
ensure that these attributes are actually present when userspace
is notified via uevents.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/s390/cio/ccwgroup.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 5f97ea2..fcedb92 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -66,6 +66,12 @@ __ccwgroup_remove_symlinks(struct ccwgroup_device *gdev)
 	
 }
 
+static ssize_t ccwgroup_online_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count);
+static ssize_t ccwgroup_online_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf);
 /*
  * Provide an 'ungroup' attribute so the user can remove group devices no
  * longer needed or accidentially created. Saves memory :)
@@ -112,6 +118,20 @@ out:
 }
 
 static DEVICE_ATTR(ungroup, 0200, NULL, ccwgroup_ungroup_store);
+static DEVICE_ATTR(online, 0644, ccwgroup_online_show, ccwgroup_online_store);
+
+static struct attribute *ccwgroup_attrs[] = {
+	&dev_attr_online.attr,
+	&dev_attr_ungroup.attr,
+	NULL,
+};
+static struct attribute_group ccwgroup_attr_group = {
+	.attrs = ccwgroup_attrs,
+};
+static const struct attribute_group *ccwgroup_attr_groups[] = {
+	&ccwgroup_attr_group,
+	NULL,
+};
 
 static void
 ccwgroup_release (struct device *dev)
@@ -280,25 +300,17 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 	}
 
 	dev_set_name(&gdev->dev, "%s", dev_name(&gdev->cdev[0]->dev));
-
+	gdev->dev.groups = ccwgroup_attr_groups;
 	rc = device_add(&gdev->dev);
 	if (rc)
 		goto error;
 	get_device(&gdev->dev);
-	rc = device_create_file(&gdev->dev, &dev_attr_ungroup);
-
-	if (rc) {
-		device_unregister(&gdev->dev);
-		goto error;
-	}
-
 	rc = __ccwgroup_create_symlinks(gdev);
 	if (!rc) {
 		mutex_unlock(&gdev->reg_mutex);
 		put_device(&gdev->dev);
 		return 0;
 	}
-	device_remove_file(&gdev->dev, &dev_attr_ungroup);
 	device_unregister(&gdev->dev);
 error:
 	for (i = 0; i < num_devices; i++)
@@ -408,7 +420,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 	int ret;
 
 	if (!dev->driver)
-		return -ENODEV;
+		return -EINVAL;
 
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
@@ -441,8 +453,6 @@ ccwgroup_online_show (struct device *dev, struct device_attribute *attr, char *b
 	return sprintf(buf, online ? "1\n" : "0\n");
 }
 
-static DEVICE_ATTR(online, 0644, ccwgroup_online_show, ccwgroup_online_store);
-
 static int
 ccwgroup_probe (struct device *dev)
 {
@@ -454,12 +464,7 @@ ccwgroup_probe (struct device *dev)
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
 
-	if ((ret = device_create_file(dev, &dev_attr_online)))
-		return ret;
-
 	ret = gdrv->probe ? gdrv->probe(gdev) : -ENODEV;
-	if (ret)
-		device_remove_file(dev, &dev_attr_online);
 
 	return ret;
 }
@@ -470,9 +475,6 @@ ccwgroup_remove (struct device *dev)
 	struct ccwgroup_device *gdev;
 	struct ccwgroup_driver *gdrv;
 
-	device_remove_file(dev, &dev_attr_online);
-	device_remove_file(dev, &dev_attr_ungroup);
-
 	if (!dev->driver)
 		return 0;
 
-- 
1.7.12.rc2

