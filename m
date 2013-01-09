Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3AIKAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:00:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab3AIKAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:00:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,437,1355068800"; 
   d="scan'208";a="6551518"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [PATCH v6 15/15] memory-hotplug: Do not allocate pdgat if it was not freed when offline.
Date: Wed, 9 Jan 2013 17:32:39 +0800
Message-Id: <1357723959-5416-16-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/09 17:32:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/09 17:32:58,
	Serialize complete at 2013/01/09 17:32:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no way to guarentee the address of pgdat/zone is not
on stack of any kernel threads or used by other kernel objects
without reference counting or other symchronizing method, we cannot
reset node_data and free pgdat when offlining a node. Just reset pgdat
to 0 and reuse the memory when the node is online again.

The problem is suggested by Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
The idea is from Wen Congyang <wency@cn.fujitsu.com>

NOTE: If we don't reset pgdat to 0, the WARN_ON in free_area_init_node()
      will be triggered.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/memory_hotplug.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8b67752..8aa2b56 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1015,11 +1015,14 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 	unsigned long zholes_size[MAX_NR_ZONES] = {0};
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 
-	pgdat = arch_alloc_nodedata(nid);
-	if (!pgdat)
-		return NULL;
+	pgdat = NODE_DATA(nid);
+	if (!pgdat) {
+		pgdat = arch_alloc_nodedata(nid);
+		if (!pgdat)
+			return NULL;
 
-	arch_refresh_nodedata(nid, pgdat);
+		arch_refresh_nodedata(nid, pgdat);
+	}
 
 	/* we can use NODE_DATA(nid) from here */
 
@@ -1072,7 +1075,7 @@ out:
 int __ref add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
+	int new_pgdat = 0, new_node = 0;
 	struct resource *res;
 	int ret;
 
@@ -1083,12 +1086,13 @@ int __ref add_memory(int nid, u64 start, u64 size)
 	if (!res)
 		goto out;
 
-	if (!node_online(nid)) {
+	new_pgdat = NODE_DATA(nid) ? 0 : 1;
+	new_node = node_online(nid) ? 0 : 1;
+	if (new_node) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
 		if (!pgdat)
 			goto error;
-		new_pgdat = 1;
 	}
 
 	/* call arch's memory hotadd */
@@ -1100,7 +1104,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
 	/* we online node here. we can't roll back from here. */
 	node_set_online(nid);
 
-	if (new_pgdat) {
+	if (new_node) {
 		ret = register_one_node(nid);
 		/*
 		 * If sysfs file of new node can't create, cpu on the node
-- 
1.7.1

