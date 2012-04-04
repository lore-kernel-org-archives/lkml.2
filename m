Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2DDVtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:49:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48330 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab2DDVsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:48:47 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 6/6] regmap: prevent division by zero in rbtree_show
Date: Wed,  4 Apr 2012 15:48:33 -0600
Message-Id: <1333576113-13196-6-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

If there are no nodes in the cache, nodes will be 0, so calculating
"registers / nodes" will cause division by zero.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regcache-rbtree.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 9eea758..e49e71f 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -138,6 +138,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	unsigned int base, top;
 	int nodes = 0;
 	int registers = 0;
+	int average;
 
 	map->lock(map);
 
@@ -152,8 +153,13 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 		registers += top - base + 1;
 	}
 
+	if (nodes)
+		average = registers / nodes;
+	else
+		average = 0;
+
 	seq_printf(s, "%d nodes, %d registers, average %d registers\n",
-		   nodes, registers, registers / nodes);
+		   nodes, registers, average);
 
 	map->unlock(map);
 
-- 
1.7.0.4

