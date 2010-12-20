Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0LTLip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:38:45 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51266 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0LTLgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:36:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: broonie@opensource.wolfsonmicro.com, clemens@ladisch.de, gregkh@suse.de,
        sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v7 09/12] media: Pipelines and media streams
Date: Mon, 20 Dec 2010 12:36:32 +0100
Message-Id: <1292844995-7900-10-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers often need to associate pipeline objects to entities, and to
take stream state into account when configuring entities and links. The
pipeline API helps drivers manage that information.

When starting streaming, drivers call media_entity_pipeline_start(). The
function marks all entities connected to the given entity through
enabled links, either directly or indirectly, as streaming. Similarly,
when stopping the stream, drivers call media_entity_pipeline_stop().

The media_entity_pipeline_start() function takes a pointer to a media
pipeline and stores it in every entity in the graph. Drivers should
embed the media_pipeline structure in higher-level pipeline structures
and can then access the pipeline through the media_entity structure.

Link configuration will fail with -EBUSY by default if either end of the
link is a streaming entity, unless the link is marked with the
MEDIA_LINK_FLAG_DYNAMIC flag.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |    5 ++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |    3 +
 Documentation/media-framework.txt                  |   38 ++++++++++
 drivers/media/media-entity.c                       |   74 ++++++++++++++++++++
 include/linux/media.h                              |    1 +
 include/media/media-entity.h                       |   10 +++
 6 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/v4l/media-ioc-enum-links.xml
index bcec89b..aa164f4 100644
--- a/Documentation/DocBook/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/v4l/media-ioc-enum-links.xml
@@ -179,6 +179,11 @@
 	    <entry>The link enabled state can't be modified at runtime. An
 	    immutable link is always enabled.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_LINK_FLAG_DYNAMIC</constant></entry>
+	    <entry>The link enabled state can be modified during streaming. This
+	    flag is set by drivers and is read-only for applications.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/v4l/media-ioc-setup-link.xml b/Documentation/DocBook/v4l/media-ioc-setup-link.xml
index 09ab3d2..2331e76 100644
--- a/Documentation/DocBook/v4l/media-ioc-setup-link.xml
+++ b/Documentation/DocBook/v4l/media-ioc-setup-link.xml
@@ -60,6 +60,9 @@
     <para>Link configuration has no side effect on other links. If an enabled
     link at the sink pad prevents the link from being enabled, the driver
     returns with an &EBUSY;.</para>
+    <para>Only links marked with the <constant>DYNAMIC</constant> link flag can
+    be enabled/disabled while streaming media data. Attempting to enable or
+    disable a streaming non-dynamic link will return an &EBUSY;.</para>
     <para>If the specified link can't be found the driver returns with an
     &EINVAL;.</para>
   </refsect1>
diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 4603417..7163dcb 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -343,3 +343,41 @@ link_setup calls are made with power active on the source and sink entities.
 In other words, enabling or disabling a link propagates reference count changes
 through the graph, and the final state is identical to what it would have been
 if the link had been enabled or disabled from the start.
+
+
+Pipelines and media streams
+---------------------------
+
+When starting streaming, drivers must notify all entities in the pipeline to
+prevent link states from being modified during streaming by calling
+
+	media_entity_pipeline_start(struct media_entity *entity,
+				    struct media_pipeline *pipe);
+
+The function will mark all entities connected to the given entity through
+enabled links, either directly or indirectly, as streaming.
+
+The media_pipeline instance pointed to by the pipe argument will be stored in
+every entity in the pipeline. Drivers should embed the media_pipeline structure
+in higher-level pipeline structures and can then access the pipeline through
+the media_entity pipe field.
+
+Calls to media_entity_pipeline_start() can be nested. The pipeline pointer must
+be identical for all nested calls to the function.
+
+When stopping the stream, drivers must notify the entities with
+
+	media_entity_pipeline_stop(struct media_entity *entity);
+
+If multiple calls to media_entity_pipeline_start() have been made the same
+number of media_entity_pipeline_stop() calls are required to stop streaming. The
+media_entity pipe field is reset to NULL on the last nested stop call.
+
+Link configuration will fail with -EBUSY by default if either end of the link is
+a streaming entity. Links that can be modified while streaming must be marked
+with the MEDIA_LINK_FLAG_DYNAMIC flag.
+
+If other operations need to be disallowed on streaming entities (such as
+changing entities configuration parameters) drivers can explictly check the
+media_entity stream_count field to find out if an entity is streaming. This
+operation must be done with the media_device graph_mutex held.
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 53718f1..73bb26d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -197,6 +197,75 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
 /* -----------------------------------------------------------------------------
+ * Pipeline management
+ */
+
+/**
+ * media_entity_pipeline_start - Mark a pipeline as streaming
+ * @entity: Starting entity
+ * @pipe: Media pipeline to be assigned to all entities in the pipeline.
+ *
+ * Mark all entities connected to a given entity through enabled links, either
+ * directly or indirectly, as streaming. The given pipeline object is assigned to
+ * every entity in the pipeline and stored in the media_entity pipe field.
+ *
+ * Calls to this function can be nested, in which case the same number of
+ * media_entity_pipeline_stop() calls will be required to stop streaming. The
+ * pipeline pointer must be identical for all nested calls to
+ * media_entity_pipeline_start().
+ */
+void media_entity_pipeline_start(struct media_entity *entity,
+				 struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->parent;
+	struct media_entity_graph graph;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		entity->stream_count++;
+		WARN_ON(entity->pipe && entity->pipe != pipe);
+		entity->pipe = pipe;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
+
+/**
+ * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * @entity: Starting entity
+ *
+ * Mark all entities connected to a given entity through enabled links, either
+ * directly or indirectly, as not streaming. The media_entity pipe field is
+ * reset to NULL.
+ *
+ * If multiple calls to media_entity_pipeline_start() have been made, the same
+ * number of calls to this function are required to mark the pipeline as not
+ * streaming.
+ */
+void media_entity_pipeline_stop(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->parent;
+	struct media_entity_graph graph;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		entity->stream_count--;
+		if (entity->stream_count == 0)
+			entity->pipe = NULL;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
+
+/* -----------------------------------------------------------------------------
  * Power state handling
  */
 
@@ -505,6 +574,11 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 	if (link->flags == flags)
 		return 0;
 
+	if (!(link->flags & MEDIA_LINK_FLAG_DYNAMIC) &&
+	    (link->source->entity->stream_count ||
+	     link->sink->entity->stream_count))
+		return -EBUSY;
+
 	source = __media_entity_get(link->source->entity);
 	if (!source)
 		return ret;
diff --git a/include/linux/media.h b/include/linux/media.h
index 0611e3d..944629b 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -106,6 +106,7 @@ struct media_pad_desc {
 
 #define MEDIA_LINK_FLAG_ENABLED			(1 << 0)
 #define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
+#define MEDIA_LINK_FLAG_DYNAMIC			(1 << 2)
 
 struct media_link_desc {
 	struct media_pad_desc source;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 36ad6c7..8dbc268 100644
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
 
+	int stream_count;		/* Stream count for the entity. */
 	int use_count;			/* Use count for the entity. */
 
+	struct media_pipeline *pipe;	/* Pipeline this entity belongs to. */
+
 	union {
 		/* Node specifications */
 		struct {
@@ -115,6 +121,7 @@ struct media_entity_graph {
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
+
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 int __media_entity_setup_link(struct media_link *link, u32 flags);
@@ -130,6 +137,9 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
+void media_entity_pipeline_start(struct media_entity *entity,
+		struct media_pipeline *pipe);
+void media_entity_pipeline_stop(struct media_entity *entity);
 
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
-- 
1.7.2.2

