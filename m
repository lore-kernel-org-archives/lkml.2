Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2KVUsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:48:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab2KVS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:43 -0500
Date: Wed, 21 Nov 2012 17:43:39 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-84f1ae30bb68d8da98bca7ff2c2b825b2ac8c9a5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-7-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-7-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Change find_early_table_space() paramters
Git-Commit-ID: 84f1ae30bb68d8da98bca7ff2c2b825b2ac8c9a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:43:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f1ae30bb68d8da98bca7ff2c2b825b2ac8c9a5
Gitweb:     http://git.kernel.org/tip/84f1ae30bb68d8da98bca7ff2c2b825b2ac8c9a5
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:43 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:05 -0800

x86, mm: Change find_early_table_space() paramters

call split_mem_range inside the function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-7-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index dbef4ff..51f919f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -196,12 +196,18 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
  * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
  * pages. Then find enough contiguous space for those page tables.
  */
-static void __init find_early_table_space(struct map_range *mr, int nr_range)
+static void __init find_early_table_space(unsigned long start, unsigned long end)
 {
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
-	unsigned long start = 0, good_end;
+	unsigned long good_end;
 	phys_addr_t base;
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range;
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+	nr_range = split_mem_range(mr, nr_range, start, end);
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
@@ -276,7 +282,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(mr, nr_range);
+		find_early_table_space(start, end);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
