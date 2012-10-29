Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2J2Pto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:49:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759936Ab2J2Ps0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093356"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Lameter <cl@linux.com>, Hillf Danton <dhillf@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org
Subject: [V5 PATCH 19/26] numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
Date: Mon, 29 Oct 2012 23:21:09 +0800
Message-Id: <1351524078-20363-18-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:44,
	Serialize complete at 2012/10/29 23:19:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All are prepared, we can actually introduce N_MEMORY.
add CONFIG_MOVABLE_NODE make we can use it for movable-dedicated node

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/base/node.c      |    6 ++++++
 include/linux/nodemask.h |    4 ++++
 mm/Kconfig               |    8 ++++++++
 mm/page_alloc.c          |    3 +++
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 4c3aa7c..9cdd66f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -620,6 +620,9 @@ static struct node_attr node_state_attr[] = {
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+#endif
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
@@ -630,6 +633,9 @@ static struct attribute *node_state_attrs[] = {
 #ifdef CONFIG_HIGHMEM
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	&node_state_attr[N_MEMORY].attr.attr,
+#endif
 	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index c6ebdc9..4e2cbfa 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -380,7 +380,11 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	N_MEMORY,		/* The node has memory(regular, high, movable) */
+#else
 	N_MEMORY = N_HIGH_MEMORY,
+#endif
 	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..957ebd5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -143,6 +143,14 @@ config NO_BOOTMEM
 config MEMORY_ISOLATION
 	boolean
 
+config MOVABLE_NODE
+	boolean "Enable to assign a node has only movable memory"
+	depends on HAVE_MEMBLOCK
+	depends on NO_BOOTMEM
+	depends on X86_64
+	depends on NUMA
+	default y
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b70c929..a42337f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,9 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
 #endif
+#ifdef CONFIG_MOVABLE_NODE
+	[N_MEMORY] = { { [0] = 1UL } },
+#endif
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
-- 
1.7.4.4

