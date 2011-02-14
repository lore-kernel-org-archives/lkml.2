Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1BNMV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:21:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58169 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1BNMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v9 12/12] v4l: Make v4l2_subdev inherit from media_entity
Date: Mon, 14 Feb 2011 13:21:07 +0100
Message-Id: <1297686067-9666-13-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4L2 subdevices are media entities. As such they need to inherit from
(include) the media_entity structure.

When registering/unregistering the subdevice, the media entity is
automatically registered/unregistered. The entity is acquired on device
open and released on device close.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/v4l2-framework.txt |   23 ++++++++++++++++
 drivers/media/video/v4l2-device.c            |   36 +++++++++++++++++++++++---
 drivers/media/video/v4l2-subdev.c            |   28 ++++++++++++++++++-
 include/media/v4l2-subdev.h                  |    6 ++++
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 0627081..77d96f4 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -268,6 +268,26 @@ A sub-device driver initializes the v4l2_subdev struct using:
 Afterwards you need to initialize subdev->name with a unique name and set the
 module owner. This is done for you if you use the i2c helper functions.
 
+If integration with the media framework is needed, you must initialize the
+media_entity struct embedded in the v4l2_subdev struct (entity field) by
+calling media_entity_init():
+
+	struct media_pad *pads = &my_sd->pads;
+	int err;
+
+	err = media_entity_init(&sd->entity, npads, pads, 0);
+
+The pads array must have been previously initialized. There is no need to
+manually set the struct media_entity type and name fields, but the revision
+field must be initialized if needed.
+
+A reference to the entity will be automatically acquired/released when the
+subdev device node (if any) is opened/closed.
+
+Don't forget to cleanup the media entity before the sub-device is destroyed:
+
+	media_entity_cleanup(&sd->entity);
+
 A device (bridge) driver needs to register the v4l2_subdev with the
 v4l2_device:
 
@@ -277,6 +297,9 @@ This can fail if the subdev module disappeared before it could be registered.
 After this function was called successfully the subdev->dev field points to
 the v4l2_device.
 
+If the v4l2_device parent device has a non-NULL mdev field, the sub-device
+entity will be automatically registered with the media device.
+
 You can unregister a sub-device using:
 
 	v4l2_device_unregister_subdev(sd);
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 0af46e4..259415b 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -118,8 +118,11 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 
 int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
-						struct v4l2_subdev *sd)
+				struct v4l2_subdev *sd)
 {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity *entity = &sd->entity;
+#endif
 	int err;
 
 	/* Check for valid input */
@@ -147,6 +150,19 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 		return err;
 	}
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	/* Register the entity. */
+	if (v4l2_dev->mdev) {
+		err = media_device_register_entity(v4l2_dev->mdev, entity);
+		if (err < 0) {
+			if (sd->internal_ops && sd->internal_ops->unregistered)
+				sd->internal_ops->unregistered(sd);
+			module_put(sd->owner);
+			return err;
+		}
+	}
+#endif
+
 	spin_lock(&v4l2_dev->lock);
 	list_add_tail(&sd->list, &v4l2_dev->subdevs);
 	spin_unlock(&v4l2_dev->lock);
@@ -177,25 +193,37 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 					      sd->owner);
 		if (err < 0)
 			return err;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		sd->entity.v4l.major = VIDEO_MAJOR;
+		sd->entity.v4l.minor = vdev->minor;
+#endif
 	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
 
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 {
+	struct v4l2_device *v4l2_dev;
+
 	/* return if it isn't registered */
 	if (sd == NULL || sd->v4l2_dev == NULL)
 		return;
 
-	spin_lock(&sd->v4l2_dev->lock);
+	v4l2_dev = sd->v4l2_dev;
+
+	spin_lock(&v4l2_dev->lock);
 	list_del(&sd->list);
-	spin_unlock(&sd->v4l2_dev->lock);
+	spin_unlock(&v4l2_dev->lock);
+
 	if (sd->internal_ops && sd->internal_ops->unregistered)
 		sd->internal_ops->unregistered(sd);
 	sd->v4l2_dev = NULL;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (v4l2_dev->mdev)
+		media_device_unregister_entity(&sd->entity);
+#endif
 	video_unregister_device(&sd->devnode);
 	module_put(sd->owner);
 }
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 9374406..29b7ddf 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -35,7 +35,10 @@ static int subdev_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-	struct v4l2_fh *vfh;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity *entity;
+#endif
+	struct v4l2_fh *vfh = NULL;
 	int ret;
 
 	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
@@ -58,11 +61,20 @@ static int subdev_open(struct file *file)
 		v4l2_fh_add(vfh);
 		file->private_data = vfh;
 	}
-
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (sd->v4l2_dev->mdev) {
+		entity = media_entity_get(&sd->entity);
+		if (!entity) {
+			ret = -EBUSY;
+			goto err;
+		}
+	}
+#endif
 	return 0;
 
 err:
 	if (vfh != NULL) {
+		v4l2_fh_del(vfh);
 		v4l2_fh_exit(vfh);
 		kfree(vfh);
 	}
@@ -72,8 +84,16 @@ err:
 
 static int subdev_close(struct file *file)
 {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+#endif
 	struct v4l2_fh *vfh = file->private_data;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (sd->v4l2_dev->mdev)
+		media_entity_put(&sd->entity);
+#endif
 	if (vfh != NULL) {
 		v4l2_fh_del(vfh);
 		v4l2_fh_exit(vfh);
@@ -172,5 +192,9 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->grp_id = 0;
 	sd->dev_priv = NULL;
 	sd->host_priv = NULL;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	sd->entity.name = sd->name;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+#endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 3f4e0d1..c37d6e4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
@@ -448,6 +449,9 @@ struct v4l2_subdev_internal_ops {
    stand-alone or embedded in a larger struct.
  */
 struct v4l2_subdev {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity entity;
+#endif
 	struct list_head list;
 	struct module *owner;
 	u32 flags;
@@ -470,6 +474,8 @@ struct v4l2_subdev {
 	unsigned int nevents;
 };
 
+#define media_entity_to_v4l2_subdev(ent) \
+	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
 	container_of(vdev, struct v4l2_subdev, devnode)
 
-- 
1.7.3.4

