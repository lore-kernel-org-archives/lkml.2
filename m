Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282Ab2JaJQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:16:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2JaJQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:16:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107690"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART5 Patch 4/5] memblock: limit memory address from memblock
Date: Wed, 31 Oct 2012 17:21:42 +0800
Message-Id: <1351675303-11786-5-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
References: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:16,
	Serialize complete at 2012/10/31 17:15:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Setting kernelcore_max_pfn means all memory which is bigger than
the boot parameter is allocated as ZONE_MOVABLE. So memory which
is allocated by memblock also should be limited by the parameter.

The patch limits memory from memblock.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/memblock.h | 1 +
 mm/memblock.c            | 5 ++++-
 mm/page_alloc.c          | 6 +++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..3e52911 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+extern phys_addr_t memblock_limit;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..ee2e307 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -957,7 +957,10 @@ void __init_memblock memblock_trim_memory(phys_addr_t align)
 
 void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
-	memblock.current_limit = limit;
+	if (!memblock_limit || (memblock_limit > limit))
+		memblock.current_limit = limit;
+	else
+		memblock.current_limit = memblock_limit;
 }
 
 static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c35fe5..26f007bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -205,6 +205,8 @@ static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
+phys_addr_t memblock_limit;
+
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
 EXPORT_SYMBOL(movable_zone);
@@ -4987,7 +4989,9 @@ static int __init cmdline_parse_core(char *p, unsigned long *core)
  */
 static int __init cmdline_parse_kernelcore_max_addr(char *p)
 {
-	return cmdline_parse_core(p, &required_kernelcore_max_pfn);
+	cmdline_parse_core(p, &required_kernelcore_max_pfn);
+	memblock_limit = required_kernelcore_max_pfn << PAGE_SHIFT;
+	return 0;
 }
 early_param("kernelcore_max_addr", cmdline_parse_kernelcore_max_addr);
 #endif
-- 
1.8.0

