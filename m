Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2HBGBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:01:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2HBGBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:01:13 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534633"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: [RFC PATCH 14/23 V2] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Date: Thu, 2 Aug 2012 14:01:19 +0800
Message-Id: <1343887288-8866-15-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:42,
	Serialize complete at 2012/08/02 14:01:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB only fucus on the nodes which has normal memory, so ignore the other
node's hot-adding and hot-removing.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/slub.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..4c5bdc0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3577,6 +3577,9 @@ static void slab_mem_offline_callback(void *arg)
 	if (offline_node < 0)
 		return;
 
+	if (page_zonenum(pfn_to_page(marg->start_pfn)) > ZONE_NORMAL)
+		return;
+
 	down_read(&slub_lock);
 	list_for_each_entry(s, &slab_caches, list) {
 		n = get_node(s, offline_node);
@@ -3611,6 +3614,9 @@ static int slab_mem_going_online_callback(void *arg)
 	if (nid < 0)
 		return 0;
 
+	if (page_zonenum(pfn_to_page(marg->start_pfn)) > ZONE_NORMAL)
+		return 0;
+
 	/*
 	 * We are bringing a node online. No memory is available yet. We must
 	 * allocate a kmem_cache_node structure in order to bring the node
-- 
1.7.1

