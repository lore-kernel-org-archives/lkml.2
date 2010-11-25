Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0KYCbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 21:31:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35139 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab0KYCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 21:31:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: [RFC/PATCH v6 09/12] media: Entity locking and pipeline management
Date: Thu, 25 Nov 2010 03:28:16 +0100
Message-Id: <1290652099-15102-10-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Link states must not be modified while streaming is in progress on a
graph they belong or connect to. The entity locking API helps drivers
enforcing that requirement.

When starting streaming on a graph, drivers lock all entities in the
graph with a call to media_entity_graph_lock(). Similarly, when stopping
the stream, they unlock the entities with a call to
media_entity_graph_unlock().

The media_entity_graph_lock() function takes a pointer to a media
pipeline and stores it in every entity in the graph. Drivers should
embed the media_pipeline structure in higher-level pipeline structures
and can then access the pipeline through the media_entity structure.

Link configuration will fail with -EBUSY if either end of the link is a
locked entity.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media-framework.txt |   35 ++++++++++++++++++++
 drivers/media/media-entity.c      |   64 +++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h      |   10 ++++++
 3 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index e2987b7..3131e1e 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -343,3 +343,38 @@ and sink entities.
 In other words, activating or deactivating a link propagates reference count
 changes through the graph, and the final state is identical to what it would
 have been if the link had been active or inactive from the start.
+
+
+Entity locking and pipelines
+----------------------------
+
+When starting streaming, drivers must lock all entities in the graph to
+prevent link states from being modified during streaming by calling
+
+	media_entity_graph_lock(struct media_entity *entity,
+				struct media_pipeline *pipe);
+
+The function will lock all entities connected to the given entity through
+active links, either directly or indirectly.
+
+The media_pipeline instance pointed to by the pipe argument will be stored in
+every entity in the graph. Drivers should embed the media_pipeline structure
+in higher-level pipeline structures and can then access the pipeline through
+the media_entity pipe field.
+
+Calls to media_entity_graph_lock() can be nested. The pipeline pointer must be
+identical for all nested calls to the function.
+
+When stopping the stream, drivers must unlock the entities with
+
+	media_entity_graph_unlock(struct media_entity *entity);
+
+If multiple calls to media_entity_graph_lock() have been made the same number
+of media_entity_graph_unlock() calls are required to unlock the graph. The
+media_entity pipe field is reset to NULL on the last nested unlock call.
+
+Link configuration will fail with -EBUSY if either end of the link is a
+locked entity. If other operations need to be disallowed on locked entities
+(such as changing entities configuration parameters) drivers can explictly
+check the media_entity lock_count field to find out if an entity is locked.
+This operation must be done with the media_device graph_mutex held.
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5ebda28..3e2670e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -196,6 +196,67 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
+/**
+ * media_entity_graph_lock - Lock all entities in a graph
+ * @entity: Starting entity
+ * @pipe: Media pipeline to be assigned to all entities in the graph.
+ *
+ * Lock all entities connected to a given entity through active links, either
+ * directly or indirectly. The given pipeline is assigned to every entity in
+ * the graph and stored in the media_entity pipe field.
+ *
+ * Calls to this function can be nested, in which case the same number of
+ * media_entity_graph_unlock() calls will be required to unlock the graph. The
+ * pipeline pointer must be identical for all nested calls to
+ * media_entity_graph_lock().
+ */
+void media_entity_graph_lock(struct media_entity *entity,
+			     struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->parent;
+	struct media_entity_graph graph;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		entity->lock_count++;
+		WARN_ON(entity->pipe && entity->pipe != pipe);
+		entity->pipe = pipe;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_entity_graph_lock);
+
+/**
+ * media_entity_graph_unlock - Unlock all entities in a graph
+ * @entity: Starting entity
+ *
+ * Unlock all entities connected to a given entity through active links, either
+ * directly or indirectly. The media_entity pipe field is reset to NULL on the
+ * last nested unlock call.
+ */
+void media_entity_graph_unlock(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->parent;
+	struct media_entity_graph graph;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		entity->lock_count--;
+		if (entity->lock_count == 0)
+			entity->pipe = NULL;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_entity_graph_unlock);
+
 /* -----------------------------------------------------------------------------
  * Power state handling
  */
@@ -505,6 +566,9 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link->flags == flags)
 		return 0;
 
+	if (link->source->entity->lock_count || link->sink->entity->lock_count)
+		return -EBUSY;
+
 	source = __media_entity_get(link->source->entity);
 	if (!source)
 		return ret;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 11bef651..74030f2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -26,6 +26,9 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+struct media_pipeline {
+};
+
 struct media_link {
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
@@ -68,8 +71,11 @@ struct media_entity {
 
 	const struct media_entity_operations *ops;	/* Entity operations */
 
+	int lock_count;			/* Lock count for the entity. */
 	int use_count;			/* Use count for the entity. */
 
+	struct media_pipeline *pipe;	/* Pipeline this entity belongs to. */
+
 	union {
 		/* Node specifications */
 		struct {
@@ -111,6 +117,7 @@ struct media_entity_graph {
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
+
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 int __media_entity_setup_link(struct media_link *link, u32 flags);
@@ -126,6 +133,9 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
+void media_entity_graph_lock(struct media_entity *entity,
+		struct media_pipeline *pipe);
+void media_entity_graph_unlock(struct media_entity *entity);
 
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
-- 
1.7.2.2

