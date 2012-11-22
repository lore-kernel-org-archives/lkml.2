Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2KVU7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:59:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2KVS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:27 -0500
Date: Wed, 21 Nov 2012 18:20:18 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-b8fd39c036ab982aa087b7ee671f86e2574d31f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-42-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-42-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Use clamp_t() in init_range_memory_mapping
Git-Commit-ID: b8fd39c036ab982aa087b7ee671f86e2574d31f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:20:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8fd39c036ab982aa087b7ee671f86e2574d31f2
Gitweb:     http://git.kernel.org/tip/b8fd39c036ab982aa087b7ee671f86e2574d31f2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:18 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:46 -0800

x86, mm: Use clamp_t() in init_range_memory_mapping

save some lines, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-42-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 2a27e5a..6f85de8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -357,31 +357,20 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  * would have hole in the middle or ends, and only ram parts will be mapped.
  */
 static unsigned long __init init_range_memory_mapping(
-					   unsigned long range_start,
-					   unsigned long range_end)
+					   unsigned long r_start,
+					   unsigned long r_end)
 {
 	unsigned long start_pfn, end_pfn;
 	unsigned long mapped_ram_size = 0;
 	int i;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		u64 start = (u64)start_pfn << PAGE_SHIFT;
-		u64 end = (u64)end_pfn << PAGE_SHIFT;
-
-		if (end <= range_start)
-			continue;
-
-		if (start < range_start)
-			start = range_start;
-
-		if (start >= range_end)
+		u64 start = clamp_val(PFN_PHYS(start_pfn), r_start, r_end);
+		u64 end = clamp_val(PFN_PHYS(end_pfn), r_start, r_end);
+		if (start >= end)
 			continue;
 
-		if (end > range_end)
-			end = range_end;
-
 		init_memory_mapping(start, end);
-
 		mapped_ram_size += end - start;
 	}
 
