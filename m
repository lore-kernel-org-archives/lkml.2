Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2KVUxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:53:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876Ab2KVS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:36 -0500
Date: Wed, 21 Nov 2012 17:58:13 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-f763ad1d3870abb811ec7520b4c1adc56471a3a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-21-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-21-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Break down init_all_memory_mapping
Git-Commit-ID: f763ad1d3870abb811ec7520b4c1adc56471a3a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:58:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f763ad1d3870abb811ec7520b4c1adc56471a3a4
Gitweb:     http://git.kernel.org/tip/f763ad1d3870abb811ec7520b4c1adc56471a3a4
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:57 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:17 -0800

x86, mm: Break down init_all_memory_mapping

Will replace that with top-down page table initialization.
New API need to take range: init_range_memory_mapping()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-21-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index da591eb..c688ea3 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -398,40 +398,30 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  * Depending on the alignment of E820 ranges, this may possibly result in using
  * smaller size (i.e. 4K instead of 2M or 1G) page tables.
  */
-static void __init init_all_memory_mapping(void)
+static void __init init_range_memory_mapping(unsigned long range_start,
+					   unsigned long range_end)
 {
 	unsigned long start_pfn, end_pfn;
 	int i;
 
-	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
-
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		u64 start = (u64)start_pfn << PAGE_SHIFT;
 		u64 end = (u64)end_pfn << PAGE_SHIFT;
 
-		if (end <= ISA_END_ADDRESS)
+		if (end <= range_start)
 			continue;
 
-		if (start < ISA_END_ADDRESS)
-			start = ISA_END_ADDRESS;
-#ifdef CONFIG_X86_32
-		/* on 32 bit, we only map up to max_low_pfn */
-		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+		if (start < range_start)
+			start = range_start;
+
+		if (start >= range_end)
 			continue;
 
-		if ((end >> PAGE_SHIFT) > max_low_pfn)
-			end = max_low_pfn << PAGE_SHIFT;
-#endif
-		init_memory_mapping(start, end);
-	}
+		if (end > range_end)
+			end = range_end;
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
+		init_memory_mapping(start, end);
 	}
-#endif
 }
 
 void __init init_mem_mapping(void)
@@ -461,8 +451,15 @@ void __init init_mem_mapping(void)
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 
 	max_pfn_mapped = 0; /* will get exact value next */
-	init_all_memory_mapping();
-
+	/* the ISA range is always mapped regardless of memory holes */
+	init_memory_mapping(0, ISA_END_ADDRESS);
+	init_range_memory_mapping(ISA_END_ADDRESS, end);
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
