Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2LJTmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2LJTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7a-50c63b2fe829
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 11/13] v4l2-of: Add v4l2_of_parse_data_lanes() function
Date: Mon, 10 Dec 2012 20:41:37 +0100
Message-id: <1355168499-5847-12-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQV1962MBBrPXKllc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK6vr1nKdioWnHgblQD4165LkZODgkBE4nWZe8ZIWwx
	iQv31rN1MXJxCAlMZ5SYuHkRC4TTwSTxae0GsCo2AUOJ3qN9YLaIgJnEu87HYEXMAn1MEifv
	/GIFSQgLeEsc/XwMrIhFQFXixfQpQEUcHLwCbhJPH3iBmBICChJzJtmAVHACRV8fagWrFhJw
	lfgxcx3zBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCPf9MegfjqgaLQ4wCHIxK
	PLwaWscChFgTy4orcw8xSnAwK4nwRkgAhXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmk
	J5akZqemFqQWwWSZODilGhgjF9aGi8QJ3D/hI12qu/bY/Mazx7c49NpOvWna2PPwkyPj+uKD
	X48aSa6ec7NcZDGDTalJhVeNqpkuV+XEPd9D1+msvnml6X16hlyU94xlN1wPXkyvjDnPxf+D
	z22RyIPz64oaBMUzHkjs/bCTx22+04UXk5UqjF7t3vArPZ8/0vO9VVrnFl0lluKMREMt5qLi
	RAAyL95++AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the data-lanes property parsing code and make a separate function
out of it, so it can be used in drivers that don't need all features
packed in v4l2_of_parse_link().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-of.c |   48 ++++++++++++++++++++++++-------------
 include/media/v4l2-of.h           |   28 ++++++++++++++++------
 2 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 4e6658c..032ee67 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -15,6 +15,35 @@
 
 #include <media/v4l2-of.h>
 
+
+/**
+ * v4l2_of_parse_data_lanes() - parse data-lanes property
+ * @node: a node containing data-lanes property [in]
+ * @mipi_csi2: data lanes configuration [out]
+ *
+ * Return: 0 on success or negative error value otherwise.
+ */
+int v4l2_of_parse_data_lanes(const struct device_node *node,
+				struct v4l2_of_mipi_csi2 *mipi_csi2)
+{
+	struct property *prop = of_find_property(node, "data-lanes", NULL);
+	u32 data_lanes[ARRAY_SIZE(mipi_csi2->data_lanes)];
+	const __be32 *lane = NULL;
+	int i = 0;
+
+	if (!prop)
+		return -EINVAL;
+
+	do {
+		lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
+	} while (lane && i++ < ARRAY_SIZE(data_lanes));
+
+	mipi_csi2->num_data_lanes = i;
+	while (i--)
+		mipi_csi2->data_lanes[i] = data_lanes[i];
+	return 0;
+}
+
 /*
  * All properties are optional. If none are found, we don't set any flags. This
  * means, the port has a static configuration and no properties have to be
@@ -29,11 +58,9 @@ void v4l2_of_parse_link(const struct device_node *node,
 			struct v4l2_of_link *link)
 {
 	const struct device_node *port_node = of_get_parent(node);
+	bool data_lanes_present = false;
 	int size;
 	unsigned int v;
-	u32 data_lanes[ARRAY_SIZE(link->mipi_csi_2.data_lanes)];
-	bool data_lanes_present;
-	struct property *prop;
 
 	memset(link, 0, sizeof(*link));
 
@@ -84,21 +111,8 @@ void v4l2_of_parse_link(const struct device_node *node,
 	if (!of_property_read_u32(node, "clock-lanes", &v))
 		link->mipi_csi_2.clock_lane = v;
 
-	prop = of_find_property(node, "data-lanes", NULL);
-	if (prop) {
-		int i = 0;
-		const __be32 *lane = NULL;
-		do {
-			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
-		} while (lane && i++ < ARRAY_SIZE(data_lanes));
-
-		link->mipi_csi_2.num_data_lanes = i;
-		while (i--)
-			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
+	if (!v4l2_of_parse_data_lanes(node, &link->mipi_csi_2))
 		data_lanes_present = true;
-	} else {
-		data_lanes_present = false;
-	}
 
 	if (of_get_property(node, "clock-noncontinuous", &size))
 		link->mbus_flags |= V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index ccb1ebe..9b036e6 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -13,11 +13,18 @@
 
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/errno.h>
 
 #include <media/v4l2-mediabus.h>
 
 struct device_node;
 
+struct v4l2_of_mipi_csi2 {
+	unsigned char data_lanes[4];
+	unsigned char clock_lane;
+	unsigned short num_data_lanes;
+};
+
 struct v4l2_of_link {
 	unsigned int port;
 	unsigned int addr;
@@ -30,17 +37,15 @@ struct v4l2_of_link {
 			unsigned char bus_width;
 			unsigned char data_shift;
 		} parallel;
-		struct {
-			unsigned char data_lanes[4];
-			unsigned char clock_lane;
-			unsigned short num_data_lanes;
-		} mipi_csi_2;
+		struct v4l2_of_mipi_csi2 mipi_csi_2;
 	};
 };
 
 #ifdef CONFIG_OF
 void v4l2_of_parse_link(const struct device_node *node,
 			struct v4l2_of_link *link);
+int v4l2_of_parse_data_lanes(const struct device_node *node,
+			   struct v4l2_of_mipi_csi2 *mipi_csi2);
 struct device_node *v4l2_of_get_next_link(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *v4l2_of_get_remote(const struct device_node *node);
@@ -49,15 +54,24 @@ static inline void v4l2_of_parse_link(const struct device_node *node,
 				      struct v4l2_of_link *link)
 {
 }
+
+static inline int v4l2_of_parse_data_lanes(const struct device_node *node,
+				struct v4l2_of_mipi_csi2 *mipi_csi2)
+{
+	return -ENOSYS;
+}
+
 static inline struct device_node *v4l2_of_get_next_link(const struct device_node *parent,
 						struct device_node *previous)
 {
 	return NULL;
 }
+
 static inline struct device_node *v4l2_of_get_remote(const struct device_node *node)
 {
 	return NULL;
 }
-#endif
 
-#endif
+#endif /* CONFIG_OF */
+
+#endif /* _V4L2_OF_H */
-- 
1.7.9.5

