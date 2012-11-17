Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2KQDly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:41:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2KQDk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v8 44/46] sparc, mm: Remove calling of free_all_bootmem_node()
Date: Fri, 16 Nov 2012 19:39:21 -0800
Message-Id: <1353123563-3103-45-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now NO_BOOTMEM version free_all_bootmem_node() does not really
do free_bootmem at all, and it only call
register_page_bootmem_info_node instead.

That is confusing, try to kill that free_all_bootmem_node().

Before that, this patch will remove calling of free_all_bootmem_node()

We add register_page_bootmem_info() to call register_page_bootmem_info_node
directly.

Also could use free_all_bootmem() for numa case, and it is just
the same as free_low_memory_core_early().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: sparclinux@vger.kernel.org
Acked-by: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/mm/init_64.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 9e28a11..b24bac2 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2021,6 +2021,16 @@ static void __init patch_tlb_miss_handler_bitmap(void)
 	flushi(&valid_addr_bitmap_insn[0]);
 }
 
+static void __init register_page_bootmem_info(void)
+{
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	int i;
+
+	for_each_online_node(i)
+		if (NODE_DATA(i)->node_spanned_pages)
+			register_page_bootmem_info_node(NODE_DATA(i));
+#endif
+}
 void __init mem_init(void)
 {
 	unsigned long codepages, datapages, initpages;
@@ -2038,20 +2048,8 @@ void __init mem_init(void)
 
 	high_memory = __va(last_valid_pfn << PAGE_SHIFT);
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	{
-		int i;
-		for_each_online_node(i) {
-			if (NODE_DATA(i)->node_spanned_pages != 0) {
-				totalram_pages +=
-					free_all_bootmem_node(NODE_DATA(i));
-			}
-		}
-		totalram_pages += free_low_memory_core_early(MAX_NUMNODES);
-	}
-#else
+	register_page_bootmem_info();
 	totalram_pages = free_all_bootmem();
-#endif
 
 	/* We subtract one to account for the mem_map_zero page
 	 * allocated below.
-- 
1.7.7

