Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2JSGlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:41:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2JSGlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:41:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029358"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 2/9] suppress "Device nodeX does not have a release() function" warning
Date: Fri, 19 Oct 2012 14:46:35 +0800
Message-Id: <1350629202-9664-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 14:40:44,
	Serialize complete at 2012/10/19 14:40:44
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
 drivers/base/node.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index af1a177..2baa73a 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -252,6 +252,9 @@ static inline void hugetlb_register_node(struct node *node) {}
 static inline void hugetlb_unregister_node(struct node *node) {}
 #endif
 
+static void node_device_release(struct device *dev)
+{
+}
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -263,8 +266,11 @@ int register_node(struct node *node, int num, struct node *parent)
 {
 	int error;
 
+	memset(node, 0, sizeof(*node));
+
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
 	error = device_register(&node->dev);
 
 	if (!error){
-- 
1.7.1

