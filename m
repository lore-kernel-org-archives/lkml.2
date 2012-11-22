Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2KVUnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:43:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964984Ab2KVS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:50 -0500
Date: Wed, 21 Nov 2012 17:39:28 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-4e33e06555329e93523b3d2590b9210bf84120a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, penberg@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <1353123563-3103-3-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-3-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Split out split_mem_range from init_memory_mapping
Git-Commit-ID: 4e33e06555329e93523b3d2590b9210bf84120a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:39:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e33e06555329e93523b3d2590b9210bf84120a3
Gitweb:     http://git.kernel.org/tip/4e33e06555329e93523b3d2590b9210bf84120a3
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:39 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:01 -0800

x86, mm: Split out split_mem_range from init_memory_mapping

So make init_memory_mapping smaller and readable.

-v2: use 0 instead of nr_range as input parameter found by Yasuaki Ishimatsu.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-3-git-send-email-yinghai@kernel.org
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index aa5b0da..6368b86 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,25 +146,13 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
+static int __meminit split_mem_range(struct map_range *mr, int nr_range,
+				     unsigned long start,
+				     unsigned long end)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long ret = 0;
 	unsigned long pos;
-	struct map_range mr[NR_RANGE_MR];
-	int nr_range, i;
-
-	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
-	       start, end - 1);
-
-	memset(mr, 0, sizeof(mr));
-	nr_range = 0;
+	int i;
 
 	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
@@ -258,6 +246,27 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
+	return nr_range;
+}
+
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	struct map_range mr[NR_RANGE_MR];
+	unsigned long ret = 0;
+	int nr_range, i;
+
+	pr_info("init_memory_mapping: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = split_mem_range(mr, 0, start, end);
+
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 *
