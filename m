Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2JKF1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:27:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2JKF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:27:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50765896.4000300@jp.fujitsu.com>
Date: Thu, 11 Oct 2012 14:26:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, <rientjes@google.com>,
        <liuj97@gmail.com>, <minchan.kim@gmail.com>,
        <akpm@linux-foundation.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <wency@cn.fujitsu.com>
Subject: [PATCH 2/2]suppress "Device nodeX does not have a release() function"
 warning
References: <507656D1.5020703@jp.fujitsu.com>
In-Reply-To: <507656D1.5020703@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/base/node.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-3.6/drivers/base/node.c
===================================================================
--- linux-3.6.orig/drivers/base/node.c	2012-10-11 10:04:02.149758748 +0900
+++ linux-3.6/drivers/base/node.c	2012-10-11 10:20:34.111806931 +0900
@@ -252,6 +252,14 @@ static inline void hugetlb_register_node
 static inline void hugetlb_unregister_node(struct node *node) {}
 #endif
 
+static void node_device_release(struct device *dev)
+{
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+	struct node *node_dev = to_node(dev);
+
+	flush_work(&node_dev->node_work);
+#endif
+}
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -263,8 +271,11 @@ int register_node(struct node *node, int
 {
 	int error;
 
+	memset(node, 0, sizeof(*node));
+
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
 	error = device_register(&node->dev);
 
 	if (!error){

