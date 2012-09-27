Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2I0HAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:00:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab2I0HAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:00:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,495,1344182400"; 
   d="scan'208";a="5926300"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: [PATCH 2/3] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Date: Thu, 27 Sep 2012 14:47:49 +0800
Message-Id: <1348728470-5580-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 14:46:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 14:46:53,
	Serialize complete at 2012/09/27 14:46:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB only fucus on the nodes which has normal memory, so ignore the other
node's hot-adding and hot-removing.

Aka: if some memroy of a node(which has no onlined memory) is online,
but this new memory onlined is not normal memory(HIGH memory example),
we should not allocate kmem_cache_node for SLUB.

And if the last normal memory is offlined, but the node still has memroy,
we should remove kmem_cache_node for that node.(current code delay it when
all of the memory is offlined)

so we only do something when marg->status_change_nid_normal > 0.
marg->status_change_nid is not suitable here.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2fdd96f..2d78639 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3577,7 +3577,7 @@ static void slab_mem_offline_callback(void *arg)
 	struct memory_notify *marg = arg;
 	int offline_node;
 
-	offline_node = marg->status_change_nid;
+	offline_node = marg->status_change_nid_normal;
 
 	/*
 	 * If the node still has available memory. we need kmem_cache_node
@@ -3610,7 +3610,7 @@ static int slab_mem_going_online_callback(void *arg)
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	int nid = marg->status_change_nid_normal;
 	int ret = 0;
 
 	/*
-- 
1.7.4.4

