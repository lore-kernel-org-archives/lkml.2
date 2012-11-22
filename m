Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2KVVZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:25:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab2KVSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 059/171] crush: fix tree node weight lookup
Date: Wed, 21 Nov 2012 16:40:05 -0800
Message-Id: <20121122004039.289073464@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit f671d4cd9b36691ac4ef42cde44c1b7a84e13631)

Fix the node weight lookup for tree buckets by using a correct accessor.

Reflects ceph.git commit d287ade5bcbdca82a3aef145b92924cf1e856733.

Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/crush/crush.h |    5 +++++
 net/ceph/crush/crush.c      |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/crush/crush.h
+++ b/include/linux/crush/crush.h
@@ -177,4 +177,9 @@ extern void crush_destroy_bucket_straw(s
 extern void crush_destroy_bucket(struct crush_bucket *b);
 extern void crush_destroy(struct crush_map *map);
 
+static inline int crush_calc_tree_node(int i)
+{
+	return ((i+1) << 1)-1;
+}
+
 #endif
--- a/net/ceph/crush/crush.c
+++ b/net/ceph/crush/crush.c
@@ -37,9 +37,7 @@ int crush_get_bucket_item_weight(const s
 	case CRUSH_BUCKET_LIST:
 		return ((struct crush_bucket_list *)b)->item_weights[p];
 	case CRUSH_BUCKET_TREE:
-		if (p & 1)
-			return ((struct crush_bucket_tree *)b)->node_weights[p];
-		return 0;
+		return ((struct crush_bucket_tree *)b)->node_weights[crush_calc_tree_node(p)];
 	case CRUSH_BUCKET_STRAW:
 		return ((struct crush_bucket_straw *)b)->item_weights[p];
 	}


