Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2DSQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:22:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2DSQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:22:09 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andy Whitcroft <apw@canonical.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drm -- stop early access to drm devices
Date: Thu, 19 Apr 2012 17:22:05 +0100
Message-Id: <1334852525-14950-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334852525-14950-1-git-send-email-apw@canonical.com>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a drm driver is initialised we first allocate and initialise the
drm minor numbers including creating the sysfs files, then we trigger
the driver load method.  The act of creating the sysfs files triggers the
uevent.  This means udev may start programs which open /dev/dri/card0 and
other interfaces, this can occur before the load method has even started
and thus before the driver has fully initialised its data structures.
In the case of plymouthd this leads to it opening and closing (in disgust)
the interface, which in turn leads to a kernel panic as the mutexes are
yet to be initialised.

This patch delays the linking up of the drm devices minor numbers until
the driver is fully initialised.  As it is possible for consumers of
these interfaces to reach them before they are fully initialised we
arrange for opens of these devices to return EAGAIN until the device is
fully initialised.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/gpu/drm/drm_fops.c     |    8 ++++++--
 drivers/gpu/drm/drm_pci.c      |    4 ++++
 drivers/gpu/drm/drm_platform.c |    4 ++++
 drivers/gpu/drm/drm_stub.c     |    2 +-
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index cdfbf27..b415ef0 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -129,7 +129,8 @@ int drm_open(struct inode *inode, struct file *filp)
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
 		return -ENODEV;
-
+	if (IS_ERR(minor))
+		return PTR_ERR(minor);
 	if (!(dev = minor->dev))
 		return -ENODEV;
 
@@ -180,7 +181,10 @@ int drm_stub_open(struct inode *inode, struct file *filp)
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
 		goto out;
-
+	if (IS_ERR(minor)) {
+		err = PTR_ERR(minor);
+		goto out;
+	}
 	if (!(dev = minor->dev))
 		goto out;
 
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 13f3d93..b321672 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -367,6 +367,10 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
 
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		idr_replace(&drm_minors_idr, dev->control, dev->control->index);
+	idr_replace(&drm_minors_idr, dev->primary, dev->primary->index);
+
 	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
 		 driver->name, driver->major, driver->minor, driver->patchlevel,
 		 driver->date, pci_name(pdev), dev->primary->index);
diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index 82431dc..d749389 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -90,6 +90,10 @@ int drm_get_platform_dev(struct platform_device *platdev,
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
 
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		idr_replace(&drm_minors_idr, dev->control, dev->control->index);
+	idr_replace(&drm_minors_idr, dev->primary, dev->primary->index);
+
 	mutex_unlock(&drm_global_mutex);
 
 	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n",
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index aa454f8..6c32781 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -357,7 +357,7 @@ int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int type)
 	new_minor->index = minor_id;
 	INIT_LIST_HEAD(&new_minor->master_list);
 
-	idr_replace(&drm_minors_idr, new_minor, minor_id);
+	idr_replace(&drm_minors_idr, ERR_PTR(-EAGAIN), minor_id);
 
 	if (type == DRM_MINOR_LEGACY) {
 		ret = drm_proc_init(new_minor, minor_id, drm_proc_root);
-- 
1.7.9.5

