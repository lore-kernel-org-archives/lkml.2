Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2KVUwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:52:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab2KVS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:36 -0500
Date: Wed, 21 Nov 2012 18:14:04 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-5a0d3aeeeffbd1534a510fc10c4ab7c99c45afce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-36-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-36-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use round_up/down in split_mem_range()
Git-Commit-ID: 5a0d3aeeeffbd1534a510fc10c4ab7c99c45afce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:14:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a0d3aeeeffbd1534a510fc10c4ab7c99c45afce
Gitweb:     http://git.kernel.org/tip/5a0d3aeeeffbd1534a510fc10c4ab7c99c45afce
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:12 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:40 -0800

x86, mm: use round_up/down in split_mem_range()

to replace own inline version for those roundup and rounddown.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-36-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8168bf8..0e625e6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -218,13 +218,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	 * slowdowns.
 	 */
 	if (pos == 0)
-		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+		end_pfn = PMD_SIZE >> PAGE_SHIFT;
 	else
-		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-				 << (PMD_SHIFT - PAGE_SHIFT);
+		end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
-			<< (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #endif
 	if (end_pfn > (end >> PAGE_SHIFT))
 		end_pfn = end >> PAGE_SHIFT;
@@ -234,15 +232,13 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	}
 
 	/* big page (2M) range */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
 #ifdef CONFIG_X86_32
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+	end_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
+	if (end_pfn > (round_down(end, PMD_SIZE) >> PAGE_SHIFT))
+		end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 #endif
 
 	if (start_pfn < end_pfn) {
@@ -253,9 +249,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PUD_SIZE) >> PAGE_SHIFT;
+	end_pfn = round_down(end, PUD_SIZE) >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
@@ -264,9 +259,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = round_up(pos, PMD_SIZE) >> PAGE_SHIFT;
+	end_pfn = round_down(end, PMD_SIZE) >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
