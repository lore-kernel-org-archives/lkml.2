Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0JVS3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:29:44 -0400
Received: from kroah.org ([198.145.64.141]:37812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758947Ab0JVSZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/31] uio: Don't clear driver data
Date: Fri, 22 Oct 2010 11:25:00 -0700
Message-Id: <1287771916-15016-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Currently uio sets it's driver data to NULL just as it is unregistering
attributes.  sysfs maks the guaranatee that it will not call attributes
after device_destroy is called so this is unncessary and leads to lots
of unnecessary code in uio.c

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index bc774cc..8132288 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -229,10 +229,7 @@ static ssize_t show_name(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%s\n", idev->info->name);
-	else
-		return -ENODEV;
+	return sprintf(buf, "%s\n", idev->info->name);
 }
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
@@ -240,10 +237,7 @@ static ssize_t show_version(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%s\n", idev->info->version);
-	else
-		return -ENODEV;
+	return sprintf(buf, "%s\n", idev->info->version);
 }
 static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 
@@ -251,11 +245,7 @@ static ssize_t show_event(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%u\n",
-				(unsigned int)atomic_read(&idev->event));
-	else
-		return -ENODEV;
+	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
 }
 static DEVICE_ATTR(event, S_IRUGO, show_event, NULL);
 
@@ -878,7 +868,6 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
-	dev_set_drvdata(idev->dev, NULL);
 	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
 	kfree(idev);
 
-- 
1.7.2

