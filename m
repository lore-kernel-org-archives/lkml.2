Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2KVUyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:54:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2KVS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:35 -0500
Date: Wed, 21 Nov 2012 17:56:08 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-aeebe84cc96cde4181807bc67c300c550d0ef123@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-19-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-19-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Use big page size for small memory range
Git-Commit-ID: aeebe84cc96cde4181807bc67c300c550d0ef123
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:56:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aeebe84cc96cde4181807bc67c300c550d0ef123
Gitweb:     http://git.kernel.org/tip/aeebe84cc96cde4181807bc67c300c550d0ef123
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:55 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:16 -0800

x86, mm: Use big page size for small memory range

We could map small range in the middle of big range at first, so should use
big page size at first to avoid using small page size to break down page table.

Only can set big page bit when that range has ram area around it.

-v2: fix 32bit boundary checking. We can not count ram above max_low_pfn
	for 32 bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-19-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bb44e9f..da591eb 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -88,6 +88,40 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+/*
+ * adjust the page_size_mask for small range to go with
+ *	big page size instead small one if nearby are ram too.
+ */
+static void __init_refok adjust_range_page_size_mask(struct map_range *mr,
+							 int nr_range)
+{
+	int i;
+
+	for (i = 0; i < nr_range; i++) {
+		if ((page_size_mask & (1<<PG_LEVEL_2M)) &&
+		    !(mr[i].page_size_mask & (1<<PG_LEVEL_2M))) {
+			unsigned long start = round_down(mr[i].start, PMD_SIZE);
+			unsigned long end = round_up(mr[i].end, PMD_SIZE);
+
+#ifdef CONFIG_X86_32
+			if ((end >> PAGE_SHIFT) > max_low_pfn)
+				continue;
+#endif
+
+			if (memblock_is_region_memory(start, end - start))
+				mr[i].page_size_mask |= 1<<PG_LEVEL_2M;
+		}
+		if ((page_size_mask & (1<<PG_LEVEL_1G)) &&
+		    !(mr[i].page_size_mask & (1<<PG_LEVEL_1G))) {
+			unsigned long start = round_down(mr[i].start, PUD_SIZE);
+			unsigned long end = round_up(mr[i].end, PUD_SIZE);
+
+			if (memblock_is_region_memory(start, end - start))
+				mr[i].page_size_mask |= 1<<PG_LEVEL_1G;
+		}
+	}
+}
+
 static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long start,
 				     unsigned long end)
@@ -182,6 +216,9 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 		nr_range--;
 	}
 
+	if (!after_bootmem)
+		adjust_range_page_size_mask(mr, nr_range);
+
 	for (i = 0; i < nr_range; i++)
 		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
 				mr[i].start, mr[i].end - 1,
