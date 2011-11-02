Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747Ab1KCBm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab1KCBmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.102201348@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [080/101] [S390] ccwgroup: move attributes to attribute group
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

commit dbdf1afcaaabe83dea15a3cb9b9013e73ae3b1ad upstream.

Put sysfs attributes of ccwgroup devices in an attribute group to
ensure that these attributes are actually present when userspace
is notified via uevents.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/cio/ccwgroup.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -66,6 +66,12 @@ __ccwgroup_remove_symlinks(struct ccwgro
 	
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
@@ -280,25 +300,17 @@ int ccwgroup_create_from_string(struct d
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
@@ -408,7 +420,7 @@ ccwgroup_online_store (struct device *de
 	int ret;
 
 	if (!dev->driver)
-		return -ENODEV;
+		return -EINVAL;
 
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
@@ -441,8 +453,6 @@ ccwgroup_online_show (struct device *dev
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
 


