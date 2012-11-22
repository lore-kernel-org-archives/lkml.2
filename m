Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2KVS6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814Ab2KVS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:29 -0500
Date: Wed, 21 Nov 2012 18:16:08 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-1829ae9ad7380bf17333ab9ad1610631d9cb8664@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-38-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-38-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use pfn instead of pos in split_mem_range
Git-Commit-ID: 1829ae9ad7380bf17333ab9ad1610631d9cb8664
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:16:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1829ae9ad7380bf17333ab9ad1610631d9cb8664
Gitweb:     http://git.kernel.org/tip/1829ae9ad7380bf17333ab9ad1610631d9cb8664
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:14 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:41 -0800

x86, mm: use pfn instead of pos in split_mem_range

could save some bit shifting operations.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-38-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1cca052..4bf1c53 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -204,12 +204,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long end)
 {
 	unsigned long start_pfn, end_pfn;
-	unsigned long pos;
+	unsigned long pfn;
 	int i;
 
 	/* head if not big page alignment ? */
-	start_pfn = PFN_DOWN(start);
-	pos = PFN_PHYS(start_pfn);
+	pfn = start_pfn = PFN_DOWN(start);
 #ifdef CONFIG_X86_32
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
@@ -217,26 +216,26 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * and overlapping MTRRs into large pages can cause
 	 * slowdowns.
 	 */
-	if (pos == 0)
+	if (pfn == 0)
 		end_pfn = PFN_DOWN(PMD_SIZE);
 	else
-		end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+		end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #endif
 	if (end_pfn > PFN_DOWN(end))
 		end_pfn = PFN_DOWN(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 	/* big page (2M) range */
-	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #ifdef CONFIG_X86_32
 	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	end_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
 	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
 		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #endif
@@ -244,32 +243,32 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
 	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = PFN_PHYS(end_pfn);
+		pfn = end_pfn;
 	}
 #endif
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = PFN_DOWN(pos);
+	start_pfn = pfn;
 	end_pfn = PFN_DOWN(end);
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
