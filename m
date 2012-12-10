Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2LJTmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20577 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2LJTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:36 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b4-50c63b2bb8a4
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 10/13] v4l2-of: Support variable length of data-lanes
 property
Date: Mon, 10 Dec 2012 20:41:36 +0100
Message-id: <1355168499-5847-11-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV1t62MBBhfnCFpc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI272tnKfjGX7F3zQyWBsYO3i5GTg4JAROJuT8fMkPY
	YhIX7q1n62Lk4hASmM4ocfbAVCing0mi//V7RpAqNgFDid6jfWC2iICZxLvOxywgRcwCfUwS
	J+/8YgVJCAuESPydu4YJxGYRUJV4O3s+kM3BwSvgJnHyYxiIKSGgIDFnkg1IBSdQ9PWhVrCR
	QgKuEj9mrmOewMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkaw759J7WBc2WBxiFGA
	g1GJh1dD61iAEGtiWXFl7iFGCQ5mJRHeCAmgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QA
	IYH0xJLU7NTUgtQimCwTB6dUAyPv5cfhvNwXIl6x5MwQ+z9ngvy/3ROX/XrLKPzdOpZ30qy9
	mznfSVy6ZdsfzuJamb8+dQu/ZO5a/tDOFUXXT3/4J3/6iKDvKamG3y4GRr7P+o0Y9pZbFHpz
	fw5JbOJeu16vfvYsQb+Gb6c5irp7I9g3Hl+4449JyRvJmu0K7eEaSzKcHM9rzVJiKc5INNRi
	LipOBABzypf/+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on code from Guennadi Liakhovetski <g.liakhovetski@gmx.de>.

Add data_lanes property which relects the number of active data lanes,
that is length of the data-lanes array. Previously we assumed the
data-lanes array had fixed length which doesn't match the binding
semantics.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-of.c |   15 +++++++++++----
 include/media/v4l2-of.h           |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index f45d64b..4e6658c 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -33,6 +33,7 @@ void v4l2_of_parse_link(const struct device_node *node,
 	unsigned int v;
 	u32 data_lanes[ARRAY_SIZE(link->mipi_csi_2.data_lanes)];
 	bool data_lanes_present;
+	struct property *prop;
 
 	memset(link, 0, sizeof(*link));
 
@@ -83,10 +84,16 @@ void v4l2_of_parse_link(const struct device_node *node,
 	if (!of_property_read_u32(node, "clock-lanes", &v))
 		link->mipi_csi_2.clock_lane = v;
 
-	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
-					ARRAY_SIZE(data_lanes))) {
-		int i;
-		for (i = 0; i < ARRAY_SIZE(data_lanes); i++)
+	prop = of_find_property(node, "data-lanes", NULL);
+	if (prop) {
+		int i = 0;
+		const __be32 *lane = NULL;
+		do {
+			lane = of_prop_next_u32(prop, lane, &data_lanes[i]);
+		} while (lane && i++ < ARRAY_SIZE(data_lanes));
+
+		link->mipi_csi_2.num_data_lanes = i;
+		while (i--)
 			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
 		data_lanes_present = true;
 	} else {
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 6fafedb..ccb1ebe 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -33,6 +33,7 @@ struct v4l2_of_link {
 		struct {
 			unsigned char data_lanes[4];
 			unsigned char clock_lane;
+			unsigned short num_data_lanes;
 		} mipi_csi_2;
 	};
 };
-- 
1.7.9.5

