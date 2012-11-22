Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2KVU6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:58:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964846Ab2KVS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:29 -0500
Date: Wed, 21 Nov 2012 18:17:11 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-2e8059edb6fc5887e8e022d9e04fba26c9e0abcb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-39-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-39-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use limit_pfn for end pfn
Git-Commit-ID: 2e8059edb6fc5887e8e022d9e04fba26c9e0abcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:17:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e8059edb6fc5887e8e022d9e04fba26c9e0abcb
Gitweb:     http://git.kernel.org/tip/2e8059edb6fc5887e8e022d9e04fba26c9e0abcb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:15 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:43 -0800

x86, mm: use limit_pfn for end pfn

instead of shifting end to get that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-39-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4bf1c53..f410dc6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -203,10 +203,12 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 				     unsigned long start,
 				     unsigned long end)
 {
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn, end_pfn, limit_pfn;
 	unsigned long pfn;
 	int i;
 
+	limit_pfn = PFN_DOWN(end);
+
 	/* head if not big page alignment ? */
 	pfn = start_pfn = PFN_DOWN(start);
 #ifdef CONFIG_X86_32
@@ -223,8 +225,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 #else /* CONFIG_X86_64 */
 	end_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #endif
-	if (end_pfn > PFN_DOWN(end))
-		end_pfn = PFN_DOWN(end);
+	if (end_pfn > limit_pfn)
+		end_pfn = limit_pfn;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pfn = end_pfn;
@@ -233,11 +235,11 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	/* big page (2M) range */
 	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
 #ifdef CONFIG_X86_32
-	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 #else /* CONFIG_X86_64 */
 	end_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
-	if (end_pfn > PFN_DOWN(round_down(end, PMD_SIZE)))
-		end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	if (end_pfn > round_down(limit_pfn, PFN_DOWN(PMD_SIZE)))
+		end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 #endif
 
 	if (start_pfn < end_pfn) {
@@ -249,7 +251,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
 	start_pfn = round_up(pfn, PFN_DOWN(PUD_SIZE));
-	end_pfn = PFN_DOWN(round_down(end, PUD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PUD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
@@ -259,7 +261,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 	/* tail is not big page (1G) alignment */
 	start_pfn = round_up(pfn, PFN_DOWN(PMD_SIZE));
-	end_pfn = PFN_DOWN(round_down(end, PMD_SIZE));
+	end_pfn = round_down(limit_pfn, PFN_DOWN(PMD_SIZE));
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
@@ -269,7 +271,7 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 
 	/* tail is not big page (2M) alignment */
 	start_pfn = pfn;
-	end_pfn = PFN_DOWN(end);
+	end_pfn = limit_pfn;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
