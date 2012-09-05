Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab2IEJUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:20:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758375Ab2IEJUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:20:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789095"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RFC v9 PATCH 21/21] memory-hotplug: auto offline page_cgroup when onlining memory block failed
Date: Wed, 5 Sep 2012 17:25:55 +0800
Message-Id: <1346837155-534-22-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:05,
	Serialize complete at 2012/09/05 17:20:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

When a memory block is onlined, we will try allocate memory on that node
to store page_cgroup. If onlining the memory block failed, we don't
offline the page cgroup, and we have no chance to offline this page cgroup
unless the memory block is onlined successfully again. It will cause
that we can't hot-remove the memory device on that node, because some
memory is used to store page cgroup. If onlining the memory block
is failed, there is no need to stort page cgroup for this memory. So
auto offline page_cgroup when onlining memory block failed.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/page_cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
1.7.1

