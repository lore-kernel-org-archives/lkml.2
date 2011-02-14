Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1BNMYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:24:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58172 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1BNMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v9 05/12] media: Entity use count
Date: Mon, 14 Feb 2011 13:21:00 +0100
Message-Id: <1297686067-9666-6-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the wide differences between drivers regarding power management
needs, the media controller does not implement power management.
However, the media_entity structure includes a use_count field that
media drivers can use to track the number of users of every entity for
power management needs.

The use_count field is owned by media drivers and must not be touched by
entity drivers. Access to the field must be protected by the media
device graph_mutex lock.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media-framework.txt |   13 ++++++++++
 drivers/media/media-device.c      |    1 +
 drivers/media/media-entity.c      |   46 +++++++++++++++++++++++++++++++++++++
 include/media/media-device.h      |    4 +++
 include/media/media-entity.h      |    9 +++++++
 5 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index ab17f33..78ae020 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -258,3 +258,16 @@ When the graph traversal is complete the function will return NULL.
 
 Graph traversal can be interrupted at any moment. No cleanup function call is
 required and the graph structure can be freed normally.
+
+
+Use count and power handling
+----------------------------
+
+Due to the wide differences between drivers regarding power management needs,
+the media controller does not implement power management. However, the
+media_entity structure includes a use_count field that media drivers can use to
+track the number of users of every entity for power management needs.
+
+The use_count field is owned by media drivers and must not be touched by entity
+drivers. Access to the field must be protected by the media device graph_mutex
+lock.
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a36509a..d2bc809 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -73,6 +73,7 @@ int __must_check media_device_register(struct media_device *mdev)
 	mdev->entity_id = 1;
 	INIT_LIST_HEAD(&mdev->entities);
 	spin_lock_init(&mdev->lock);
+	mutex_init(&mdev->graph_mutex);
 
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 166f2b5..3e7e2d5 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <media/media-entity.h>
+#include <media/media-device.h>
 
 /**
  * media_entity_init - Initialize a media entity
@@ -196,6 +197,51 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
 /* -----------------------------------------------------------------------------
+ * Module use count
+ */
+
+/*
+ * media_entity_get - Get a reference to the parent module
+ * @entity: The entity
+ *
+ * Get a reference to the parent media device module.
+ *
+ * The function will return immediately if @entity is NULL.
+ *
+ * Return a pointer to the entity on success or NULL on failure.
+ */
+struct media_entity *media_entity_get(struct media_entity *entity)
+{
+	if (entity == NULL)
+		return NULL;
+
+	if (entity->parent->dev &&
+	    !try_module_get(entity->parent->dev->driver->owner))
+		return NULL;
+
+	return entity;
+}
+EXPORT_SYMBOL_GPL(media_entity_get);
+
+/*
+ * media_entity_put - Release the reference to the parent module
+ * @entity: The entity
+ *
+ * Release the reference count acquired by media_entity_get().
+ *
+ * The function will return immediately if @entity is NULL.
+ */
+void media_entity_put(struct media_entity *entity)
+{
+	if (entity == NULL)
+		return;
+
+	if (entity->parent->dev)
+		module_put(entity->parent->dev->driver->owner);
+}
+EXPORT_SYMBOL_GPL(media_entity_put);
+
+/* -----------------------------------------------------------------------------
  * Links management
  */
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a8390fe..5d2bff4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -25,6 +25,7 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 #include <media/media-devnode.h>
@@ -42,6 +43,7 @@
  * @entity_id:	ID of the next entity to be registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
+ * @graph_mutex: Entities graph operation lock
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -69,6 +71,8 @@ struct media_device {
 
 	/* Protects the entities list */
 	spinlock_t lock;
+	/* Serializes graph operations. */
+	struct mutex graph_mutex;
 };
 
 /* media_devnode to media_device */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 28f61f6..a9b31d9 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -81,6 +81,12 @@ struct media_entity {
 	struct media_pad *pads;		/* Pads array (num_pads elements) */
 	struct media_link *links;	/* Links array (max_links elements)*/
 
+	/* Reference counts must never be negative, but are signed integers on
+	 * purpose: a simple WARN_ON(<0) check can be used to detect reference
+	 * count bugs that would make them negative.
+	 */
+	int use_count;			/* Use count for the entity. */
+
 	union {
 		/* Node specifications */
 		struct {
@@ -129,6 +135,9 @@ void media_entity_cleanup(struct media_entity *entity);
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 
+struct media_entity *media_entity_get(struct media_entity *entity);
+void media_entity_put(struct media_entity *entity);
+
 void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
-- 
1.7.3.4

