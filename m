Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab2JaLsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:48:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab2JaLs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:48:27 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6108900"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, rjw@sisk.pl,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [Patch v4 5/8] suppress "Device nodeX does not have a release() function" warning
Date: Wed, 31 Oct 2012 19:23:11 +0800
Message-Id: <1351682594-17347-6-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
References: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:51,
	Serialize complete at 2012/10/31 19:16:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

When calling unregister_node(), the function shows following message at
device_release().

"Device 'node2' does not have a release() function, it is broken and must
be fixed."

The reason is node's device struct does not have a release() function.

So the patch registers node_device_release() to the device's release()
function for suppressing the warning message. Additionally, the patch adds
memset() to initialize a node struct into register_node(). Because the node
struct is part of node_devices[] array and it cannot be freed by
node_device_release(). So if system reuses the node struct, it has a garbage.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/base/node.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 28216ce..4282e82 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -252,6 +252,24 @@ static inline void hugetlb_register_node(struct node *node) {}
 static inline void hugetlb_unregister_node(struct node *node) {}
 #endif
 
+static void node_device_release(struct device *dev)
+{
+	struct node *node = to_node(dev);
+
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+	/*
+	 * We schedule the work only when a memory section is
+	 * onlined/offlined on this node. When we come here,
+	 * all the memory on this node has been offlined,
+	 * so we won't enqueue new work to this work.
+	 *
+	 * The work is using node->node_work, so we should
+	 * flush work before freeing the memory.
+	 */
+	flush_work(&node->node_work);
+#endif
+	kfree(node);
+}
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -265,6 +283,7 @@ int register_node(struct node *node, int num, struct node *parent)
 
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
 	error = device_register(&node->dev);
 
 	if (!error){
@@ -586,7 +605,6 @@ int register_one_node(int nid)
 void unregister_one_node(int nid)
 {
 	unregister_node(node_devices[nid]);
-	kfree(node_devices[nid]);
 	node_devices[nid] = NULL;
 }
 
-- 
1.8.0

