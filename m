Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2DKXy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:54:26 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab2DKXRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:17:49 -0400
Message-Id: <20120411231028.538774815@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 60/78] regmap: prevent division by zero in rbtree_show
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit c04c1b9ee8f30c7a3a25e20e406247003f634ebe upstream.

If there are no nodes in the cache, nodes will be 0, so calculating
"registers / nodes" will cause division by zero.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache-rbtree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -137,6 +137,7 @@ static int rbtree_show(struct seq_file *
 	unsigned int base, top;
 	int nodes = 0;
 	int registers = 0;
+	int average;
 
 	mutex_lock(&map->lock);
 
@@ -151,8 +152,13 @@ static int rbtree_show(struct seq_file *
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
 
 	mutex_unlock(&map->lock);
 


