Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2KLVWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:22:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36293 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2KLVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 41/46] x86, mm: Use clamp_t() in init_range_memory_mapping
Date: Mon, 12 Nov 2012 13:18:37 -0800
Message-Id: <1352755122-25660-42-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save some lines, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 028a129..3c48114 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -354,31 +354,20 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  * this one could take range with hole in it.
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
 
-- 
1.7.7

