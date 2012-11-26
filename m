Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab2KZROq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48151 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 234/270] x86, mm: Use memblock memory loop instead of e820_RAM
Date: Mon, 26 Nov 2012 14:58:44 -0200
Message-Id: <1353949160-26803-235-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 1f2ff682ac951ed82cc043cf140d2851084512df upstream.

We need to handle E820_RAM and E820_RESERVED_KERNEL at the same time.

Also memblock has page aligned range for ram, so we could avoid mapping
partial pages.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/setup.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e615c31..6cafbcd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -920,18 +920,19 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
 		int i;
-		for (i = 0; i < e820.nr_map; i++) {
-			struct e820entry *ei = &e820.map[i];
+		unsigned long start, end;
+		unsigned long start_pfn, end_pfn;
 
-			if (ei->addr + ei->size <= 1UL << 32)
-				continue;
+		for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
+							 NULL) {
 
-			if (ei->type == E820_RESERVED)
+			end = PFN_PHYS(end_pfn);
+			if (end <= (1UL<<32))
 				continue;
 
+			start = PFN_PHYS(start_pfn);
 			max_pfn_mapped = init_memory_mapping(
-				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
-				ei->addr + ei->size);
+						max((1UL<<32), start), end);
 		}
 
 		/* can we preseve max_low_pfn ?*/
-- 
1.7.9.5

