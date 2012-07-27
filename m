Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2G0Ka7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:30:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2G0Ka5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:30:57 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336320000"; 
   d="scan'208";a="5496467"
Message-ID: <50126F0D.5060900@cn.fujitsu.com>
Date: Fri, 27 Jul 2012 18:35:57 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH v5 18/19] memory-hotplug: add node_device_release
References: <50126B83.3050201@cn.fujitsu.com>
In-Reply-To: <50126B83.3050201@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:31:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:31:25,
	Serialize complete at 2012/07/27 18:31:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

When calling unregister_node(), the function shows following message at
device_release().

Device 'node2' does not have a release() function, it is broken and must be
fixed.

So the patch implements node_device_release()

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/base/node.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index af1a177..9bc2f57 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -252,6 +252,13 @@ static inline void hugetlb_register_node(struct node *node) {}
 static inline void hugetlb_unregister_node(struct node *node) {}
 #endif
 
+static void node_device_release(struct device *dev)
+{
+	struct node *node_dev = to_node(dev);
+
+	flush_work(&node_dev->node_work);
+	memset(node_dev, 0, sizeof(struct node));
+}
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -265,6 +272,7 @@ int register_node(struct node *node, int num, struct node *parent)
 
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
 	error = device_register(&node->dev);
 
 	if (!error){
-- 
1.7.1

