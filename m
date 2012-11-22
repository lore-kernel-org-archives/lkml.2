Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2KVU4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:56:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2KVS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:32 -0500
Date: Wed, 21 Nov 2012 18:23:25 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-961f8fa04b1c3dfe35c2d3ee7ccba28f9b0e0e09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com, davem@davemloft.net
In-Reply-To: <1353123563-3103-45-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-45-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] sparc, mm: Remove calling of free_all_bootmem_node(
 )
Git-Commit-ID: 961f8fa04b1c3dfe35c2d3ee7ccba28f9b0e0e09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:23:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  961f8fa04b1c3dfe35c2d3ee7ccba28f9b0e0e09
Gitweb:     http://git.kernel.org/tip/961f8fa04b1c3dfe35c2d3ee7ccba28f9b0e0e09
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:21 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:48 -0800

sparc, mm: Remove calling of free_all_bootmem_node()

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
Link: http://lkml.kernel.org/r/1353123563-3103-45-git-send-email-yinghai@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: sparclinux@vger.kernel.org
Acked-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/sparc/mm/init_64.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

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
