Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2KVU4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:56:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2KVS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:31 -0500
Date: Wed, 21 Nov 2012 18:15:06 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-84d770019bb990dcd8013d9d08174d0e1516b517@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-37-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-37-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use PFN_DOWN in split_mem_range()
Git-Commit-ID: 84d770019bb990dcd8013d9d08174d0e1516b517
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:15:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84d770019bb990dcd8013d9d08174d0e1516b517
Gitweb:     http://git.kernel.org/tip/84d770019bb990dcd8013d9d08174d0e1516b517
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:13 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:40 -0800

x86, mm: use PFN_DOWN in split_mem_range()

to replace own inline version for shifting.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-37-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0e625e6..1cca052 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -208,8 +208,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	int i;
 
 	/* head if not big page alignment ? */
-	start_pfn = start >> PAGE_SHIFT;
-	pos = start_pfn << PAGE_SHIFT;
+	start_pfn = PFN_DOWN(start);
+	pos = PFN_PHYS(start_pfn);
 #ifdef CONFIG_X86_32
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
@@ -218,59 +218,59 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * slowdowns.
 	 */
 	if (pos == 0)
-		end_pfn = PMD_SIZE >> PAGE_SHIFT;
+		end_pfn = PFN_DOWN(PMD_SIZE);
 	else
-		end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+		end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #endif
-	if (end_pfn > (end >> PAGE_SHIFT))
-		end_pfn = end >> PAGE_SHIFT;
+	if (end_pfn > PFN_DOWN(end))
+		end_pfn = PFN_DOWN(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 	/* big page (2M) range */
-	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
 #ifdef CONFIG_X86_32
-	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #else /* CONFIG_X86_64 */
-	end_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
-	if (end_pfn > (round_down(end, PMD_SIZE) >> PAGE_SHIFT))
-		end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
+		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 #endif
 
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
-	end_pfn = round_down(end, PUD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PUD_SIZE));
+	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
-	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
+	start_pfn = PFN_DOWN(round_up(pos, PMD_SIZE));
+	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-		pos = end_pfn << PAGE_SHIFT;
+		pos = PFN_PHYS(end_pfn);
 	}
 #endif
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = pos>>PAGE_SHIFT;
-	end_pfn = end>>PAGE_SHIFT;
+	start_pfn = PFN_DOWN(pos);
+	end_pfn = PFN_DOWN(end);
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
