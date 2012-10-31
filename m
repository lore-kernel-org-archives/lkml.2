Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493Ab2JaMAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:00:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935473Ab2JaMAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:00:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6108970"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, rjw@sisk.pl,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch v4 2/8] memory-hotplug: auto offline page_cgroup when onlining memory block failed
Date: Wed, 31 Oct 2012 19:23:08 +0800
Message-Id: <1351682594-17347-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
References: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:16:54,
	Serialize complete at 2012/10/31 19:16:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a memory block is onlined, we will try allocate memory on that node
to store page_cgroup.  If onlining the memory block failed, we don't
offline the page cgroup, and we have no chance to offline this page cgroup
unless the memory block is onlined successfully again.  It will cause that
we can't hot-remove the memory device on that node, because some memory is
used to store page cgroup.  If onlining the memory block is failed, there
is no need to stort page cgroup for this memory.  So auto offline
page_cgroup when onlining memory block failed.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5ddad0c..44db00e 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -251,6 +251,9 @@ static int __meminit page_cgroup_callback(struct notifier_block *self,
 				mn->nr_pages, mn->status_change_nid);
 		break;
 	case MEM_CANCEL_ONLINE:
+		offline_page_cgroup(mn->start_pfn,
+				mn->nr_pages, mn->status_change_nid);
+		break;
 	case MEM_GOING_OFFLINE:
 		break;
 	case MEM_ONLINE:
-- 
1.8.0

